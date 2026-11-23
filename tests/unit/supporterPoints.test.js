import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';

const stateKey = 'ubi_supporter_points_v1';
const user = { id: 'account-one' };
let points;
let storage;
let localStorage;
let fetch;
let dispatchEvent;
let backend;
let query;
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
  fetch = vi.fn().mockRejectedValue(new Error('Unexpected network request'));
  dispatchEvent = vi.fn();
  upsert = vi.fn().mockResolvedValue({ error: null });
  query = {
    select: vi.fn().mockReturnThis(),
    eq: vi.fn().mockReturnThis(),
    gte: vi.fn().mockResolvedValue({ data: [] }),
  };
  backend = { from: vi.fn(() => ({ ...query, upsert })) };
  getVerifiedSupporter = vi.fn(() => ({ has_donated: false, total_cents: 0 }));
  loadDonationStatus = vi.fn().mockResolvedValue(undefined);
  vi.stubGlobal('localStorage', localStorage);
  vi.stubGlobal('window', { dispatchEvent });
  vi.stubGlobal('fetch', fetch);
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
    expect(fetch).not.toHaveBeenCalled();
    expect(localStorage.getItem).toHaveBeenCalledTimes(1);
  });

  it('derives and persists a stable hash from the mocked IP response', async () => {
    storage.delete('ubi_client_ip_hash');
    fetch.mockResolvedValue({ ok: true, json: async () => ({ ip: '192.0.2.1' }) });
    const hash = await points.getClientIpHash();
    expect(hash).toMatch(/^ip_[a-z0-9]+$/);
    expect(storage.get('ubi_client_ip_hash')).toBe(hash);
    expect(fetch).toHaveBeenCalledWith('https://api.ipify.org?format=json', {
      signal: expect.any(AbortSignal),
    });
    points = await importPoints();
    expect(await points.getClientIpHash()).toBe(hash);
    expect(fetch).toHaveBeenCalledTimes(1);
  });

  it.each([
    ['non-OK response', { ok: false }],
    ['missing IP', { ok: true, json: async () => ({}) }],
  ])('reuses the anonymous identifier after a %s', async (_name, response) => {
    storage.delete('ubi_client_ip_hash');
    storage.set('ubi_client_anon_id', 'anon_saved');
    fetch.mockResolvedValue(response);
    expect(await points.getClientIpHash()).toBe('anon_saved');
  });

  it('creates an anonymous fallback when the mocked network rejects', async () => {
    storage.delete('ubi_client_ip_hash');
    vi.spyOn(Math, 'random').mockReturnValue(0.5);
    expect(await points.getClientIpHash()).toBe('anon_i');
    expect(storage.get('ubi_client_anon_id')).toBe('anon_i');
  });

  it('falls back after malformed response JSON', async () => {
    storage.delete('ubi_client_ip_hash');
    storage.set('ubi_client_anon_id', 'anon_saved');
    fetch.mockResolvedValue({
      ok: true,
      json: async () => { throw new Error('Malformed response'); },
    });
    expect(await points.getClientIpHash()).toBe('anon_saved');
  });

  it('rejects when fallback storage is also unavailable', async () => {
    localStorage.getItem.mockImplementation(() => { throw new Error('Storage blocked'); });
    await expect(points.getClientIpHash()).rejects.toThrow('Storage blocked');
  });
});

describe('local state persistence', () => {
  it('provides the complete initial state when no state is saved', () => {
    expect(points.getLocalSupporterState()).toEqual(defaultState());
  });

  it.each(['{malformed', 'undefined'])('ignores invalid saved JSON %s', (raw) => {
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

describe('shared IP lookup', () => {
  it.each([
    [[], false],
    [[{ user_id: user.id }], false],
    [[{ user_id: 'other-account' }], true],
    [null, false],
  ])('handles qualifying rows %j', async (data, expected) => {
    query.gte.mockResolvedValue({ data });
    expect(await points.checkIsIpHalved('ip_fixture', user.id)).toBe(expected);
    expect(backend.from).toHaveBeenCalledWith('user_usage_points');
    expect(query.select).toHaveBeenCalledWith('points_total, user_id');
    expect(query.eq).toHaveBeenCalledWith('ip_hash', 'ip_fixture');
    expect(query.gte).toHaveBeenCalledWith('points_total', 70);
  });

  it('recognizes another account for an anonymous visitor', async () => {
    query.gte.mockResolvedValue({ data: [{ user_id: 'other-account' }] });
    expect(await points.checkIsIpHalved('ip_fixture', null)).toBe(true);
  });

  it('returns false when a query rejects', async () => {
    query.gte.mockRejectedValue(new Error('Backend unavailable'));
    expect(await points.checkIsIpHalved('ip_fixture', user.id)).toBe(false);
  });

  it('returns false without a backend', async () => {
    points = await importPoints(null);
    expect(await points.checkIsIpHalved('ip_fixture', user.id)).toBe(false);
  });
});

describe('usage thresholds', () => {
  it.each([
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

  it('persists newly detected shared-IP status', async () => {
    storeState({ points: 35 });
    query.gte.mockResolvedValue({ data: [{ user_id: 'other-account' }] });
    const status = await points.getSupporterStatus(user);
    expect(status).toMatchObject({ isIpHalved: true, isGated: true });
    expect(storedState().isIpHalved).toBe(true);
    expect(dispatchEvent).toHaveBeenCalledTimes(1);
  });

  it('does not rewrite state when the lookup leaves standard thresholds', async () => {
    storeState();
    await points.getSupporterStatus(user);
    expect(localStorage.setItem).not.toHaveBeenCalled();
  });

  it('does not look up a persisted halved status', async () => {
    storeState({ isIpHalved: true });
    await points.getSupporterStatus(user);
    expect(query.gte).not.toHaveBeenCalled();
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
      expect(await points.recordUsageAction('EXTRA_ACTION')).toMatchObject({
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

  it('records an anonymous action and tolerates an async upsert rejection', async () => {
    storeState();
    upsert.mockRejectedValue(new Error('Backend unavailable'));
    expect(await points.recordUsageAction('MAP_VIEW')).toMatchObject({ points: 20, mapViews: 1 });
    expect(upsert.mock.calls[0][0].user_id).toBeNull();
    expect(storedState().points).toBe(20);
  });

  it('records usage locally without a backend', async () => {
    points = await importPoints(null);
    storeState();
    expect(await points.recordUsageAction('SEARCH_QUERY')).toMatchObject({ points: 2 });
    expect(upsert).not.toHaveBeenCalled();
  });
});

describe('encouragement dismissal', () => {
  it.each([undefined, user])('persists dismissal and its identity for %j', async (account) => {
    storeState({ points: 45 });
    await points.markEncouragementDismissed(account);
    expect(storedState().encouragementShown).toBe(true);
    expect(upsert).toHaveBeenCalledWith({
      user_id: account?.id || null,
      ip_hash: 'ip_fixture',
      encouragement_shown: true,
      updated_at: '2026-11-12T12:00:00.000Z',
    }, { onConflict: 'user_id,ip_hash' });
    points = await importPoints();
    expect((await points.getSupporterStatus(account)).shouldEncourage).toBe(false);
    await points.markEncouragementDismissed(account);
    expect(storedState().encouragementShown).toBe(true);
  });

  it('keeps the local dismissal when the backend rejects', async () => {
    storeState();
    upsert.mockRejectedValue(new Error('Backend unavailable'));
    await points.markEncouragementDismissed();
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
    expect(upsert.mock.calls[0][0].user_id).toBeNull();
  });

  it('keeps the reset when an anonymous backend write rejects', async () => {
    storeState({ points: 70 });
    upsert.mockRejectedValue(new Error('Backend unavailable'));
    expect(await points.resetPointsWithProfileCompletion()).toMatchObject({
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
