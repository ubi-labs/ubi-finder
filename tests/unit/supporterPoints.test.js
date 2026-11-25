import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';

const stateKey = 'ubi_supporter_points_v1';
const user = { id: 'account-one' };
let points;
let storage;
let localStorage;
let dispatchEvent;
let backend;
let upsert;
let getVerifiedSupporter;
let loadDonationStatus;

const defaultState = () => ({
  points: 0,
  programViews: 0,
  mapViews: 0,
  searchQueries: 0,
  encouragementShown: false,
  hasDonated: false,
  totalDonatedUsd: 0,
  isIpHalved: false,
  hasUsedProfileReset: false,
});

function storeState(overrides = {}) {
  const state = { ...defaultState(), ...overrides };
  storage.set(stateKey, JSON.stringify(state));
  return state;
}

function storedState() {
  return JSON.parse(storage.get(stateKey));
}

async function importPoints(client = backend) {
  vi.resetModules();
  vi.doMock('@/lib/supabaseClient', () => ({ supabase: client }));
  vi.doMock('@/lib/donationStatus', () => ({
    getVerifiedSupporter,
    loadDonationStatus,
  }));
  return import('@/lib/supporterPoints');
}

beforeEach(async () => {
  storage = new Map([['ubi_client_ip_hash', 'ip_fixture']]);
  localStorage = {
    getItem: vi.fn((key) => storage.get(key) ?? null),
    setItem: vi.fn((key, value) => storage.set(key, value)),
  };
  dispatchEvent = vi.fn();
  upsert = vi.fn().mockResolvedValue({ error: null });
  backend = { from: vi.fn(() => ({ upsert })) };
  getVerifiedSupporter = vi.fn(() => ({ has_donated: false, total_cents: 0 }));
  loadDonationStatus = vi.fn().mockResolvedValue(undefined);
  vi.stubGlobal('localStorage', localStorage);
  vi.stubGlobal('window', { dispatchEvent });
  vi.useFakeTimers();
  vi.setSystemTime(new Date('2026-11-12T12:00:00.000Z'));
  points = await importPoints();
});

afterEach(() => {
  vi.useRealTimers();
  vi.unstubAllGlobals();
  vi.doUnmock('@/lib/supabaseClient');
  vi.doUnmock('@/lib/donationStatus');
});

describe('client identifier', () => {
  it('reuses a persisted identifier and then the module cache', async () => {
    expect(await points.getClientIpHash()).toBe('ip_fixture');
    localStorage.getItem.mockImplementation(() => { throw new Error('Storage blocked'); });
    expect(await points.getClientIpHash()).toBe('ip_fixture');
    expect(localStorage.getItem).toHaveBeenCalledTimes(1);
  });

  it('reuses the anonymous identifier without making an external IP request', async () => {
    storage.delete('ubi_client_ip_hash');
    storage.set('ubi_client_anon_id', 'anon_saved');
    expect(await points.getClientIpHash()).toBe('anon_saved');
  });

  it('creates and persists a browser-local anonymous identifier', async () => {
    storage.delete('ubi_client_ip_hash');
    vi.spyOn(Math, 'random').mockReturnValue(0.5);
    expect(await points.getClientIpHash()).toBe('anon_i');
    expect(storage.get('ubi_client_anon_id')).toBe('anon_i');
  });

  it('replaces malformed persisted identifiers with a bounded local identifier', async () => {
    storage.set('ubi_client_ip_hash', 'forged');
    storage.set('ubi_client_anon_id', 'anon_INVALID');
    vi.spyOn(Math, 'random').mockReturnValue(0);
    expect(await points.getClientIpHash()).toBe('anon_0');
    expect(storage.get('ubi_client_anon_id')).toBe('anon_0');
  });

  it('rejects when fallback storage is also unavailable', async () => {
    localStorage.getItem.mockImplementation(() => { throw new Error('Storage blocked'); });
    await expect(points.getClientIpHash()).rejects.toThrow('Storage blocked');
  });
});

describe('local state persistence', () => {
  it('retains the public shared policy exports', () => {
    expect(points.POINT_WEIGHTS).toEqual({ PROGRAM_DETAILS_VIEW: 10, MAP_VIEW: 20, SEARCH_QUERY: 2 });
    expect(points.BASE_THRESHOLDS).toEqual({ SOFT: 40, HARD: 70 });
    expect(points.HALVED_THRESHOLDS).toEqual({ SOFT: 20, HARD: 35 });
  });

  it('provides the complete initial state when no state is saved', () => {
    expect(points.getLocalSupporterState()).toEqual(defaultState());
  });

  it.each(['{malformed', 'undefined', 'null'])('ignores invalid saved JSON %s', (raw) => {
    storage.set(stateKey, raw);
    expect(points.getLocalSupporterState()).toEqual(defaultState());
  });

  it('returns defaults when reading storage fails', () => {
    localStorage.getItem.mockImplementation(() => { throw new Error('Storage blocked'); });
    expect(points.getLocalSupporterState()).toEqual(defaultState());
  });

  it('round-trips saved counters, flags and the state-change event', () => {
    const state = { ...defaultState(), points: 42, encouragementShown: true };
    points.saveLocalSupporterState(state);
    expect(points.getLocalSupporterState()).toEqual(state);
    expect(dispatchEvent).toHaveBeenCalledTimes(1);
    expect(dispatchEvent.mock.calls[0][0].type).toBe('ubi_supporter_state_changed');
  });

  it.each([
    ['negative', -1],
    ['fractional', 1.5],
    ['non-numeric', '4'],
    ['overflow', 2147483648],
  ])('sanitizes %s browser counters before storage or REST synchronization', (_label, value) => {
    const state = { ...defaultState(), points: value, programViews: value, mapViews: value, searchQueries: value };
    points.saveLocalSupporterState(state);
    expect(storedState()).toMatchObject({ points: 0, programViews: 0, mapViews: 0, searchQueries: 0 });
    expect(points.getLocalSupporterState()).toMatchObject({ points: 0, programViews: 0, mapViews: 0, searchQueries: 0 });
  });

  it('ignores failed writes', () => {
    localStorage.setItem.mockImplementation(() => { throw new Error('Storage blocked'); });
    expect(() => points.saveLocalSupporterState(defaultState())).not.toThrow();
    expect(dispatchEvent).not.toHaveBeenCalled();
  });

  it('ignores dispatch errors after persisting the state', () => {
    dispatchEvent.mockImplementation(() => { throw new Error('Window unavailable'); });
    expect(() => points.saveLocalSupporterState(defaultState())).not.toThrow();
    expect(storedState()).toEqual(defaultState());
  });
});

describe('verified supporter categories', () => {
  it.each([
    [0, 'Member', false],
    [1, 'Member+', true],
    [499, 'Member+', true],
    [500, 'Supporter', true],
    [4999, 'Supporter', true],
    [5000, 'Champion', true],
    [49999, 'Champion', true],
    [50000, 'Patron', true],
  ])('classifies %i verified cents as %s', (cents, category, isSupporter) => {
    getVerifiedSupporter.mockReturnValue({ has_donated: cents > 0, total_cents: cents });
    expect(points.getSupporterCategory(user)).toMatchObject({
      category, isSupporter, amount: cents / 100,
    });
    expect(getVerifiedSupporter).toHaveBeenCalledWith(user);
  });

  it('never trusts legacy local payment fields', () => {
    storeState({ hasDonated: true, totalDonatedUsd: 50000 });
    expect(points.getSupporterCategory()).toMatchObject({ category: 'Member', amount: 0 });
  });

  it('treats an unpaid negative mocked balance as a member', () => {
    getVerifiedSupporter.mockReturnValue({ has_donated: false, total_cents: -1 });
    expect(points.getSupporterCategory()).toMatchObject({ category: 'Member', amount: 0 });
  });

  it('uses the numeric fallback for an inconsistent paid mock without an amount', () => {
    getVerifiedSupporter.mockReturnValue({ has_donated: true, total_cents: undefined });
    expect(points.getSupporterCategory()).toMatchObject({ category: 'Member+', amount: 0 });
  });

  it('classifies a positive amount even if a mocked donation flag is false', () => {
    getVerifiedSupporter.mockReturnValue({ has_donated: false, total_cents: 500 });
    expect(points.getSupporterCategory()).toMatchObject({ category: 'Supporter', amount: 5 });
  });
});

describe('removed shared IP lookup', () => {
  it('retains the exported helper as a local-only false result', async () => {
    expect(await points.checkIsIpHalved('ip_fixture', user.id)).toBe(false);
    expect(backend.from).not.toHaveBeenCalled();
  });
});

describe('usage thresholds', () => {
  it.each([
    [false, 0, false, false],
    [false, 39, false, false],
    [false, 40, true, false],
    [false, 69, true, false],
    [false, 70, false, true],
    [true, 19, false, false],
    [true, 20, true, false],
    [true, 34, true, false],
    [true, 35, false, true],
  ])('evaluates halved=%s at %i points', async (halved, total, encourage, gated) => {
    storeState({ points: total, isIpHalved: halved });
    expect(await points.getSupporterStatus()).toMatchObject({
      points: total,
      softThreshold: halved ? 20 : 40,
      hardThreshold: halved ? 35 : 70,
      shouldEncourage: encourage,
      isGated: gated,
      hasUsedProfileReset: false,
    });
  });

  it('does not rewrite state or query shared identifiers while evaluating thresholds', async () => {
    storeState();
    await points.getSupporterStatus(user);
    expect(localStorage.setItem).not.toHaveBeenCalled();
    expect(backend.from).not.toHaveBeenCalled();
  });

  it('suppresses encouragement after dismissal', async () => {
    storeState({ points: 45, encouragementShown: true });
    expect(await points.getSupporterStatus()).toMatchObject({
      shouldEncourage: false, isGated: false,
    });
  });

  it('uses verified donations over stale local payment flags', async () => {
    storeState({ points: 100, hasDonated: false, totalDonatedUsd: 0 });
    getVerifiedSupporter.mockReturnValue({ has_donated: true, total_cents: 500 });
    expect(await points.getSupporterStatus(user)).toMatchObject({
      hasDonated: true, totalDonatedUsd: 5, isGated: false, shouldEncourage: false,
    });
    expect(loadDonationStatus).toHaveBeenCalledWith(user);
  });

  it('continues usage evaluation when donation verification fails', async () => {
    storeState({ points: 70, hasDonated: true, totalDonatedUsd: 999 });
    loadDonationStatus.mockRejectedValue(new Error('Verification unavailable'));
    expect(await points.getSupporterStatus()).toMatchObject({
      hasDonated: false, totalDonatedUsd: 0, isGated: true,
    });
  });

  it('defaults a missing legacy reset flag to false', async () => {
    const state = storeState();
    delete state.hasUsedProfileReset;
    storage.set(stateKey, JSON.stringify(state));
    expect((await points.getSupporterStatus({})).hasUsedProfileReset).toBe(false);
  });
});

describe('usage recording', () => {
  it.each([
    ['PROGRAM_DETAILS_VIEW', 10, 'programViews'],
    ['MAP_VIEW', 20, 'mapViews'],
    ['SEARCH_QUERY', 2, 'searchQueries'],
  ])('adds %s to the existing balance without changing other counters', async (action, weight, counter) => {
    const previous = storeState({
      points: 7, programViews: 2, mapViews: 3, searchQueries: 4,
    });
    const expected = { ...previous, points: previous.points + weight, [counter]: previous[counter] + 1 };
    expect(await points.recordUsageAction(action, user)).toMatchObject(expected);
    expect(storedState()).toEqual(expected);
    expect(upsert).toHaveBeenCalledWith({
      user_id: user.id,
      ip_hash: 'ip_fixture',
      points_total: expected.points,
      program_views_count: expected.programViews,
      map_views_count: expected.mapViews,
      search_queries_count: expected.searchQueries,
      encouragement_shown: false,
      last_action_at: '2026-11-12T12:00:00.000Z',
      updated_at: '2026-11-12T12:00:00.000Z',
    }, { onConflict: 'user_id,ip_hash' });
  });

  it('records an additional configured action without incrementing built-in counters', async () => {
    storeState();
    points.POINT_WEIGHTS.EXTRA_ACTION = 5;
    try {
      expect(await points.recordUsageAction('EXTRA_ACTION', user)).toMatchObject({
        points: 5, programViews: 0, mapViews: 0, searchQueries: 0,
      });
      expect(upsert.mock.calls[0][0]).toMatchObject({
        points_total: 5, program_views_count: 0, map_views_count: 0, search_queries_count: 0,
      });
    } finally {
      delete points.POINT_WEIGHTS.EXTRA_ACTION;
    }
  });

  it('keeps points and counters unchanged for an unknown action', async () => {
    const state = storeState({ points: 12, programViews: 1, searchQueries: 1 });
    await points.recordUsageAction('UNKNOWN');
    expect(storedState()).toEqual(state);
    expect(upsert).not.toHaveBeenCalled();
  });

  it('keeps anonymous usage local without attempting REST writes', async () => {
    storeState();
    expect(await points.recordUsageAction('MAP_VIEW')).toMatchObject({ points: 20, mapViews: 1 });
    expect(upsert).not.toHaveBeenCalled();
    expect(storedState().points).toBe(20);
  });

  it('keeps signed-in usage locally when its asynchronous REST write rejects', async () => {
    storeState();
    upsert.mockRejectedValue(new Error('Backend unavailable'));
    expect(await points.recordUsageAction('MAP_VIEW', user)).toMatchObject({ points: 20, mapViews: 1 });
    await vi.runAllTimersAsync();
    expect(upsert).toHaveBeenCalledOnce();
  });

  it('saturates counters at the PostgreSQL integer boundary before REST synchronization', async () => {
    storeState({ points: 2147483647, mapViews: 2147483647 });
    await points.recordUsageAction('MAP_VIEW', user);
    expect(storedState()).toMatchObject({ points: 2147483647, mapViews: 2147483647 });
    expect(upsert.mock.calls[0][0]).toMatchObject({ points_total: 2147483647, map_views_count: 2147483647 });
  });

  it('sanitizes malformed persisted counters before signed-in synchronization', async () => {
    storeState({ points: -7, programViews: 1.5, mapViews: 2147483648, searchQueries: '4' });
    await points.recordUsageAction('SEARCH_QUERY', user);
    expect(upsert.mock.calls[0][0]).toMatchObject({
      points_total: 2,
      program_views_count: 0,
      map_views_count: 0,
      search_queries_count: 1,
    });
  });

  it('records usage locally without a backend', async () => {
    points = await importPoints(null);
    storeState();
    expect(await points.recordUsageAction('SEARCH_QUERY')).toMatchObject({ points: 2 });
    expect(upsert).not.toHaveBeenCalled();
  });
});

describe('encouragement dismissal', () => {
  it('persists signed-in dismissal to its own account', async () => {
    storeState({ points: 45 });
    await points.markEncouragementDismissed(user);
    expect(storedState().encouragementShown).toBe(true);
    expect(upsert).toHaveBeenCalledWith({
      user_id: user.id,
      ip_hash: 'ip_fixture',
      encouragement_shown: true,
      updated_at: '2026-11-12T12:00:00.000Z',
    }, { onConflict: 'user_id,ip_hash' });
    points = await importPoints();
    expect((await points.getSupporterStatus(user)).shouldEncourage).toBe(false);
    await points.markEncouragementDismissed(user);
    expect(storedState().encouragementShown).toBe(true);
  });

  it('keeps anonymous dismissal local', async () => {
    storeState();
    await points.markEncouragementDismissed();
    expect(storedState().encouragementShown).toBe(true);
    expect(upsert).not.toHaveBeenCalled();
  });

  it('keeps signed-in dismissal when the backend rejects', async () => {
    storeState();
    upsert.mockRejectedValue(new Error('Backend unavailable'));
    await points.markEncouragementDismissed(user);
    expect(storedState().encouragementShown).toBe(true);
  });

  it('dismisses encouragement without a backend', async () => {
    points = await importPoints(null);
    storeState();
    await points.markEncouragementDismissed();
    expect(storedState().encouragementShown).toBe(true);
    expect(upsert).not.toHaveBeenCalled();
  });
});

describe('profile completion reset', () => {
  it.each([
    [false, 0, false],
    [false, 69, false],
    [false, 70, true],
    [false, 90, true],
    [true, 34, true],
    [true, 35, true],
    [true, 40, true],
  ])('resets halved=%s at %i points to halved=%s', async (wasHalved, total, halved) => {
    storeState({
      points: total, isIpHalved: wasHalved,
      programViews: 3, mapViews: 2, searchQueries: 1, encouragementShown: true,
    });
    const status = await points.resetPointsWithProfileCompletion(user);
    expect(status).toMatchObject({
      points: 0, isIpHalved: halved, hasUsedProfileReset: true,
      programViews: 3, mapViews: 2, searchQueries: 1, encouragementShown: true,
      isGated: false, shouldEncourage: false,
      softThreshold: halved ? 20 : 40, hardThreshold: halved ? 35 : 70,
    });
    expect(storedState()).toMatchObject({ points: 0, hasUsedProfileReset: true });
    expect(upsert).toHaveBeenCalledWith({
      user_id: user.id,
      ip_hash: 'ip_fixture',
      points_total: 0,
      updated_at: '2026-11-12T12:00:00.000Z',
    }, { onConflict: 'user_id,ip_hash' });
  });

  it('does not newly halve a verified donor with high usage', async () => {
    storeState({ points: 100 });
    getVerifiedSupporter.mockReturnValue({ has_donated: true, total_cents: 500 });
    expect(await points.resetPointsWithProfileCompletion()).toMatchObject({
      points: 0, isIpHalved: false, softThreshold: 40, hardThreshold: 70,
    });
    expect(upsert).not.toHaveBeenCalled();
  });

  it('keeps anonymous profile reset local', async () => {
    storeState({ points: 70 });
    expect(await points.resetPointsWithProfileCompletion()).toMatchObject({
      points: 0, isIpHalved: true, hasUsedProfileReset: true,
    });
    expect(upsert).not.toHaveBeenCalled();
  });

  it('keeps signed-in profile reset when the backend rejects', async () => {
    storeState({ points: 70 });
    upsert.mockRejectedValue(new Error('Backend unavailable'));
    expect(await points.resetPointsWithProfileCompletion(user)).toMatchObject({
      points: 0, isIpHalved: true, hasUsedProfileReset: true,
    });
  });

  it('resets locally without a backend', async () => {
    points = await importPoints(null);
    storeState({ points: 70 });
    expect(await points.resetPointsWithProfileCompletion()).toMatchObject({
      points: 0, isIpHalved: true, hasUsedProfileReset: true,
    });
    expect(upsert).not.toHaveBeenCalled();
  });
});
