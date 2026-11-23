import { beforeEach, describe, expect, it, vi } from 'vitest';

const { from, lookup, write } = vi.hoisted(() => ({
  from: vi.fn(),
  lookup: {
    eq: vi.fn().mockReturnThis(),
    order: vi.fn().mockReturnThis(),
    limit: vi.fn().mockReturnThis(),
    maybeSingle: vi.fn(),
  },
  write: {
    eq: vi.fn().mockReturnThis(),
    select: vi.fn().mockReturnThis(),
    single: vi.fn(),
  },
}));

vi.mock('@/lib/supabaseClient', () => ({ supabase: { from } }));
import { savePendingProfile } from '@/lib/pendingProfile';

const userId = 'account-one';
const draft = { name: 'Old onboarding name', country: 'Canada', household_size: 2 };
let table;

beforeEach(() => {
  vi.clearAllMocks();
  lookup.maybeSingle.mockReset().mockResolvedValue({ data: { id: 'profile-one' }, error: null });
  write.single.mockReset().mockResolvedValue({
    data: { ...draft, id: 'profile-one', name: 'Chosen public name' },
    error: null,
  });
  table = {
    select: vi.fn(() => lookup),
    update: vi.fn(() => write),
    insert: vi.fn(() => write),
  };
  from.mockReturnValue(table);
});

describe('pending profile replay during account updates', () => {
  it('preserves the saved name and returns the actual updated record', async () => {
    const saved = await savePendingProfile(userId, draft, 'profile-one');
    expect(table.update).toHaveBeenCalledWith({ country: 'Canada', household_size: 2 });
    expect(table.update.mock.calls[0][0]).not.toHaveProperty('name');
    expect(lookup.eq).toHaveBeenCalledWith('id', 'profile-one');
    expect(write.eq).toHaveBeenCalledWith('id', 'profile-one');
    expect(saved.name).toBe('Chosen public name');
    expect(draft.name).toBe('Old onboarding name');
    expect(table.insert).not.toHaveBeenCalled();
  });

  it('finds the existing account profile when cached and Auth profile IDs are absent', async () => {
    await savePendingProfile(userId, draft);
    expect(lookup.eq).toHaveBeenCalledWith('created_by_id', userId);
    expect(lookup.order).toHaveBeenCalledWith('created_date', { ascending: false });
    expect(lookup.limit).toHaveBeenCalledWith(1);
    expect(table.insert).not.toHaveBeenCalled();
    expect(table.update.mock.calls[0][0]).not.toHaveProperty('name');
  });

  it('keeps a later intentional edit when an old draft is replayed again', async () => {
    await savePendingProfile(userId, draft, 'profile-one');
    write.single.mockResolvedValue({
      data: { ...draft, id: 'profile-one', name: 'New intentional public name' },
      error: null,
    });
    const saved = await savePendingProfile(userId, draft, 'profile-one');
    expect(saved.name).toBe('New intentional public name');
    for (const [payload] of table.update.mock.calls) {
      expect(payload).not.toHaveProperty('name');
    }
  });

  it('does not write a stale name during overlapping refreshes', async () => {
    const saved = await Promise.all([
      savePendingProfile(userId, draft, 'profile-one'),
      savePendingProfile(userId, { ...draft, name: 'Another old draft' }, 'profile-one'),
    ]);
    expect(saved.map(profile => profile.name)).toEqual(['Chosen public name', 'Chosen public name']);
    expect(table.update).toHaveBeenCalledTimes(2);
    for (const [payload] of table.update.mock.calls) {
      expect(payload).not.toHaveProperty('name');
    }
  });

  it('initializes a new profile with the chosen draft name', async () => {
    lookup.maybeSingle.mockResolvedValue({ data: null, error: null });
    write.single.mockResolvedValue({ data: { ...draft, id: 'new-profile' }, error: null });
    expect(await savePendingProfile(userId, draft)).toEqual({ ...draft, id: 'new-profile' });
    expect(table.insert).toHaveBeenCalledWith([{ ...draft, created_by_id: userId }]);
    expect(table.update).not.toHaveBeenCalled();
  });

  it.each([
    { code: '23503', message: 'Missing referenced identity' },
    { message: 'foreign key constraint' },
  ])('retains the existing foreign-key fallback for new profiles (%j)', async error => {
    lookup.maybeSingle.mockResolvedValue({ data: null, error: null });
    write.single.mockResolvedValueOnce({ data: null, error })
      .mockResolvedValueOnce({ data: { ...draft, id: 'new-profile' }, error: null });
    await savePendingProfile(userId, draft);
    expect(table.insert).toHaveBeenNthCalledWith(1, [{ ...draft, created_by_id: userId }]);
    expect(table.insert).toHaveBeenNthCalledWith(2, [draft]);
  });

  it('stops without writing when the lookup fails', async () => {
    const error = new Error('Profile lookup unavailable');
    lookup.maybeSingle.mockResolvedValue({ data: null, error });
    await expect(savePendingProfile(userId, draft, 'profile-one')).rejects.toBe(error);
    expect(table.update).not.toHaveBeenCalled();
    expect(table.insert).not.toHaveBeenCalled();
  });

  it('does not create a replacement when a known profile cannot be loaded', async () => {
    lookup.maybeSingle.mockResolvedValue({ data: null, error: null });
    await expect(savePendingProfile(userId, draft, 'missing-profile')).rejects.toThrow('could not be loaded');
    expect(table.insert).not.toHaveBeenCalled();
  });

  it('reports failed updates instead of caching a supposed success', async () => {
    const error = new Error('Profile update unavailable');
    write.single.mockResolvedValue({ data: null, error });
    await expect(savePendingProfile(userId, draft, 'profile-one')).rejects.toBe(error);
  });

  it('does not retry an unrelated insertion error', async () => {
    lookup.maybeSingle.mockResolvedValue({ data: null, error: null });
    const error = { code: '42501' };
    write.single.mockResolvedValue({ data: null, error });
    await expect(savePendingProfile(userId, draft)).rejects.toBe(error);
    expect(table.insert).toHaveBeenCalledTimes(1);
  });

  it('rejects an empty save response', async () => {
    write.single.mockResolvedValue({ data: null, error: null });
    await expect(savePendingProfile(userId, draft, 'profile-one')).rejects.toThrow('not saved');
  });
});
