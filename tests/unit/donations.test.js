import { beforeEach, describe, expect, it, vi } from 'vitest';
import { amountToCents, supporterTier, validatePaidSession, validateReturnOrigin } from '../../supabase/functions/_shared/payment-policy.js';
const invoke = vi.hoisted(() => vi.fn());
vi.mock('@/lib/supabaseClient', () => ({ supabase: { functions: { invoke } } }));
import { getDonationGuestToken, getVerifiedSupporter, loadDonationStatus } from '@/lib/donationStatus';
import { validateDonorDetails, validateCryptoTransaction } from '../../supabase/functions/_shared/donor-details.js';
import { initiateStripeCheckout, submitCryptoDonation } from '@/lib/stripe';
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


describe('private donor records and review submissions', () => {
  it('defaults names to confidential and requires a name for public recognition', () => {
    expect(validateDonorDetails(' Alice ')).toEqual({ donor_name: 'Alice', public_recognition: false });
    expect(validateDonorDetails(null)).toEqual({ donor_name: null, public_recognition: false });
    expect(() => validateDonorDetails('', true)).toThrow();
    for (const name of ['a'.repeat(101), 'a\nname', 42]) expect(() => validateDonorDetails(name)).toThrow();
    expect(() => validateDonorDetails('Alice', 'true')).toThrow();
  });
  it('validates and normalizes references without fetching arbitrary URLs', () => {
    const hash = '0x' + 'A'.repeat(64);
    expect(validateCryptoTransaction('ethereum', hash).transaction_hash).toBe(hash.toLowerCase());
    expect(validateCryptoTransaction('celo', 'https://celoscan.io/tx/' + hash).crypto_chain).toBe('celo');
    expect(validateCryptoTransaction('celo', 'https://celo.blockscout.com/tx/' + hash).transaction_hash).toBe(hash.toLowerCase());
    for (const ref of ['0x123', 'https://etherscan.io.evil.test/tx/' + hash, 'https://user@etherscan.io/tx/' + hash, 'https://etherscan.io/tx/' + hash + '?secret=anything', 'javascript:alert(1)']) expect(() => validateCryptoTransaction('ethereum', ref)).toThrow();
    expect(() => validateCryptoTransaction('celo', 'https://etherscan.io/tx/' + hash)).toThrow();
    expect(() => validateCryptoTransaction('unknown', hash)).toThrow();
  });
  it('guests never receive credits even from a legacy server balance', async () => {
    invoke.mockResolvedValueOnce({ data: { user_id: null, total_cents: 50000, payment: { status: 'completed' } } });
    const status = await loadDonationStatus(null, 'cs_test_guest', true);
    expect(status.total_cents).toBe(0);
    expect(status.has_donated).toBe(false);
    expect(status.tier).toBe('Member');
  });
  it('submits private details and a transaction for review, never caller identity or credits', async () => {
    invoke.mockResolvedValueOnce({ data: { donation_id: 'one', status: 'pending_review' } });
    await submitCryptoDonation({ amountUsd: 5, donorDetails: { donor_name: 'Alice', public_recognition: true }, chain: 'ethereum', transactionReference: '0x' + 'a'.repeat(64) });
    expect(invoke.mock.calls[0][0]).toBe('submit-crypto-donation');
    expect(invoke.mock.calls[0][1].body).toMatchObject({ donor_name: 'Alice', public_recognition: true });
    expect(invoke.mock.calls[0][1].body).not.toHaveProperty('user_id');
  });
  it('rejects failed, duplicate, and fabricated confirmation responses', async () => {
    const args = { amountUsd: 5, donorDetails: {}, chain: 'ethereum', transactionReference: '0x' + 'a'.repeat(64) };
    invoke.mockResolvedValueOnce({ error: new Error('offline') });
    await expect(submitCryptoDonation(args)).rejects.toThrow('Unable to record');
    invoke.mockResolvedValueOnce({ error: { context: { status: 409 } } });
    await expect(submitCryptoDonation(args)).rejects.toThrow('already been submitted');
    invoke.mockResolvedValueOnce({ data: { donation_id: 'fake', status: 'completed' } });
    await expect(submitCryptoDonation(args)).rejects.toThrow();
  });
});
