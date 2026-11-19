import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';

const { getUser, maybeSingle, updateUser, savePendingProfile } = vi.hoisted(() => ({
  getUser: vi.fn(),
  maybeSingle: vi.fn(),
  updateUser: vi.fn(),
  savePendingProfile: vi.fn(),
}));

// Exercise the provider's public checkUserAuth action without mounting a browser.
// UI rendering/lifecycle acceptance remains a separate local-runtime check.
vi.mock('react', async importOriginal => ({
  ...await importOriginal(),
  useState: initial => [initial, vi.fn()],
  useEffect: vi.fn(),
}));
vi.mock('@/lib/supabaseClient', () => ({
  supabase: {
    auth: { getUser, updateUser },
    from: () => ({ select: () => ({ eq: () => ({ maybeSingle }) }) }),
  },
}));
vi.mock('@/lib/pendingProfile', () => ({ savePendingProfile }));

import { AuthProvider } from '@/lib/AuthContext';

let storage;
let authUser;
const oldDraft = { name: 'Old draft name', country: 'Canada' };

beforeEach(() => {
  vi.clearAllMocks();
  authUser = {
    id: 'account-one',
    email: 'account@example.test',
    user_metadata: { full_name: 'Old Auth name', profile_id: 'profile-one' },
  };
  getUser.mockReset().mockImplementation(async () => ({ data: { user: authUser }, error: null }));
  maybeSingle.mockReset().mockResolvedValue({ data: { role: 'user' }, error: null });
  updateUser.mockReset().mockResolvedValue({ error: null });
  savePendingProfile.mockReset().mockResolvedValue({
    id: 'profile-one', name: 'Chosen public name', country: 'Canada',
  });
  storage = new Map([
    ['pendingProfile', JSON.stringify(oldDraft)],
    ['pendingProfileStep', '3'],
  ]);
  vi.stubGlobal('localStorage', {
    getItem: key => storage.get(key) ?? null,
    setItem: (key, value) => storage.set(key, value),
    removeItem: key => storage.delete(key),
  });
});

afterEach(() => {
  vi.unstubAllGlobals();
  vi.restoreAllMocks();
});

describe('Auth profile replay through checkUserAuth', () => {
  it('caches the saved public name rather than stale Auth metadata or the pending draft', async () => {
    const auth = AuthProvider({ children: null }).props.value;
    await auth.checkUserAuth();
    expect(savePendingProfile).toHaveBeenCalledWith(
      'account-one', expect.objectContaining({ name: 'Old draft name', country: 'Canada' }), 'profile-one',
    );
    expect(JSON.parse(storage.get('user_profile_data'))).toMatchObject({ name: 'Chosen public name' });
    expect(JSON.parse(storage.get('pendingProfile'))).toMatchObject({ name: 'Chosen public name' });
    expect(storage.get('user_profile_id')).toBe('profile-one');
    expect(storage.has('pendingProfileStep')).toBe(false);
    expect(updateUser).not.toHaveBeenCalled();
  });

  it('retains a later intentional profile edit across another account check', async () => {
    const auth = AuthProvider({ children: null }).props.value;
    await auth.checkUserAuth();
    savePendingProfile.mockResolvedValue({
      id: 'profile-one', name: 'Later intentional edit', country: 'Canada',
    });
    await auth.checkUserAuth();
    expect(JSON.parse(storage.get('pendingProfile')).name).toBe('Later intentional edit');
    expect(JSON.parse(storage.get('user_profile_data')).name).toBe('Later intentional edit');
    expect(authUser.user_metadata.full_name).toBe('Old Auth name');
  });

  it('links the returned profile ID when no Auth or cached reference exists', async () => {
    delete authUser.user_metadata.profile_id;
    const auth = AuthProvider({ children: null }).props.value;
    await auth.checkUserAuth();
    expect(savePendingProfile).toHaveBeenCalledWith('account-one', expect.any(Object), null);
    expect(updateUser).toHaveBeenCalledWith({ data: { profile_id: 'profile-one' } });
  });

  it('uses the cached profile reference if Auth has none', async () => {
    delete authUser.user_metadata.profile_id;
    storage.set('user_profile_id', 'profile-one');
    const auth = AuthProvider({ children: null }).props.value;
    await auth.checkUserAuth();
    expect(savePendingProfile).toHaveBeenCalledWith('account-one', expect.any(Object), 'profile-one');
    expect(updateUser).not.toHaveBeenCalled();
  });

  it('preserves the draft and existing cache on a failed save for a later retry', async () => {
    vi.spyOn(console, 'error').mockImplementation(() => {});
    storage.set('user_profile_data', JSON.stringify({ name: 'Already saved local name' }));
    savePendingProfile.mockRejectedValue(new Error('Profile save unavailable'));
    const auth = AuthProvider({ children: null }).props.value;
    await auth.checkUserAuth();
    expect(JSON.parse(storage.get('pendingProfile'))).toEqual(oldDraft);
    expect(JSON.parse(storage.get('user_profile_data')).name).toBe('Already saved local name');
    expect(storage.get('pendingProfileStep')).toBe('3');
    expect(updateUser).not.toHaveBeenCalled();
  });
});
