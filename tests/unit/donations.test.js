import { beforeEach, describe, expect, it, vi } from 'vitest';
import { amountToCents, supporterTier, validatePaidSession, validateReturnOrigin } from '../../supabase/functions/_shared/payment-policy.js';
const invoke = vi.hoisted(() => vi.fn());
vi.mock('@/lib/supabaseClient', () => ({ supabase: { functions: { invoke } } }));
import { getDonationGuestToken, getVerifiedSupporter, loadDonationStatus } from '@/lib/donationStatus';
import { initiateStripeCheckout } from '@/lib/stripe';
import { getSupporterCategory } from '@/lib/supporterPoints';

beforeEach(() => {
  invoke.mockReset();
  const storage = new Map();
  vi.stubGlobal('localStorage', { getItem: (k) => storage.get(k) ?? null, setItem: (k, v) => storage.set(k, v) });
  vi.stubGlobal('window', { location: { origin: 'https://ubifinder.org', assign: vi.fn() }, dispatchEvent: vi.fn() });
});
describe('payment policy', () => {
  it.each([['1', 100], ['5.25', 525], [10000, 1000000]])('accepts exact cent amounts %s', (value, cents) => expect(amountToCents(value)).toBe(cents));
  it.each([0, -1, 10000.01, NaN, Infinity, '5.001', '1e2', '', true, null, {}, '5usd'])('rejects unsafe amount %s', (value) => expect(() => amountToCents(value)).toThrow());
  it.each([[0, 'Member'], [100, 'Member+'], [499, 'Member+'], [500, 'Supporter'], [4999, 'Supporter'], [5000, 'Champion'], [49999, 'Champion'], [50000, 'Patron']])('tier boundary %i', (cents, tier) => expect(supporterTier(cents)).toBe(tier));
  it('allows only exact return origins', () => {
    const allowed = ['https://ubifinder.org'];
    expect(validateReturnOrigin('https://ubifinder.org', allowed)).toBe(allowed[0]);
    for (const value of ['https://ubifinder.org.evil.test', 'https://ubifinder.org/redirect', 'https://user@ubifinder.org', 'javascript:alert(1)', 'https://ubifinder.org?url=evil']) expect(() => validateReturnOrigin(value, allowed)).toThrow();
  });
  it('only grants matching paid sessions and isolates test/live', () => {
    const row = { id: 'one', stripe_session_id: 'cs_test_fixture', livemode: false, amount_cents: 500 };
    const session = { id: row.stripe_session_id, livemode: false, currency: 'usd', amount_total: 500, metadata: { checkout_id: 'one' }, payment_status: 'paid' };
    expect(validatePaidSession(session, row, false)).toBe(true);
    expect(validatePaidSession({ ...session, payment_status: 'unpaid' }, row, false)).toBe(false);
    for (const update of [{ livemode: true }, { amount_total: 10000 }, { currency: 'eur' }, { metadata: {} }, { id: 'cs_other' }]) expect(() => validatePaidSession({ ...session, ...update }, row, false)).toThrow();
  });
});
describe('browser payment boundary', () => {
  it('creates a persistent strong guest capability', () => {
    const token = getDonationGuestToken();
    expect(token).toMatch(/^[a-f0-9]{64}$/); expect(getDonationGuestToken()).toBe(token);
  });
  it('rejects legacy browser status and only uses verified per-account totals', async () => {
    localStorage.setItem('ubi_supporter_points_v1', JSON.stringify({ hasDonated: true, totalDonatedUsd: 99999 }));
    expect(getSupporterCategory({ id: 'unverified' }).category).toBe('Member');
    invoke.mockResolvedValueOnce({ data: { user_id: 'paid', total_cents: 5000 }, error: null });
    await loadDonationStatus({ id: 'paid' }, null, true);
    expect(getSupporterCategory({ id: 'paid' }).category).toBe('Champion');
    expect(getSupporterCategory({ id: 'other' }).category).toBe('Member');
  });
  it('does not accumulate totals on repeated return visits, and revokes cache on failure', async () => {
    invoke.mockResolvedValue({ data: { user_id: 'replay', total_cents: 500 }, error: null });
    await loadDonationStatus({ id: 'replay' }, 'cs_test_fixture');
    await loadDonationStatus({ id: 'replay' }, 'cs_test_fixture');
    expect(getVerifiedSupporter({ id: 'replay' }).total_cents).toBe(500);
    invoke.mockResolvedValueOnce({ data: null, error: new Error('offline') });
    await expect(loadDonationStatus({ id: 'replay' }, null, true)).rejects.toThrow();
    expect(getVerifiedSupporter({ id: 'replay' }).has_donated).toBe(false);
  });
  it('rejects a status response belonging to another account', async () => {
    invoke.mockResolvedValueOnce({ data: { user_id: 'someone-else', total_cents: 50000 } });
    await expect(loadDonationStatus({ id: 'victim' }, null, true)).rejects.toThrow();
    expect(getVerifiedSupporter({ id: 'victim' }).has_donated).toBe(false);
  });
  it('uses short-lived verified cache without a second request', async () => {
    invoke.mockResolvedValueOnce({ data: { user_id: 'cached', total_cents: 100 } });
    await loadDonationStatus({ id: 'cached' }, null, true);
    expect((await loadDonationStatus({ id: 'cached' })).total_cents).toBe(100);
    expect(invoke).toHaveBeenCalledTimes(1);
  });
  it('keeps anonymous status unpaid when storage is unavailable', () => {
    vi.stubGlobal('localStorage', { getItem: () => { throw new Error('blocked'); } });
    expect(getVerifiedSupporter().has_donated).toBe(false);
  });
  it('rejects fabricated success and unsafe redirect URLs', async () => {
    invoke.mockResolvedValueOnce({ error: new Error('unavailable') });
    await expect(initiateStripeCheckout({ amountUsd: 5 })).rejects.toThrow('No payment was taken');
    expect(window.location.assign).not.toHaveBeenCalled();
    for (const url of ['https://evil.test', 'javascript:alert(1)', 'https://checkout.stripe.com.evil.test']) {
      invoke.mockResolvedValueOnce({ data: { url } });
      await expect(initiateStripeCheckout({ amountUsd: 5 })).rejects.toThrow();
    }
    expect(window.location.assign).not.toHaveBeenCalled();
  });
  it('redirects to hosted checkout and never sends caller-supplied user identity', async () => {
    invoke.mockResolvedValueOnce({ data: { url: 'https://checkout.stripe.com/c/pay/cs_test_fixture' } });
    await initiateStripeCheckout({ amountUsd: '5.25', user: { id: 'untrusted' } });
    expect(invoke.mock.calls.at(-1)[1].body).toMatchObject({ amount_usd: '5.25', return_url: 'https://ubifinder.org' });
    expect(invoke.mock.calls.at(-1)[1].body).not.toHaveProperty('user_id');
    expect(window.location.assign).toHaveBeenCalledWith('https://checkout.stripe.com/c/pay/cs_test_fixture');
  });
});
