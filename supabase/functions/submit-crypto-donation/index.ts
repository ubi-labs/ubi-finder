import { validateDonorDetails, validateCryptoTransaction } from '../_shared/donor-details.js';
import { amountToCents } from '../_shared/payment-policy.js';
import { adminClient, corsOrigin, donor, failure, HttpError, json, paymentConfig } from '../_shared/payments.ts';
export async function handler(req: Request) {
  let origin: string | undefined;
  try {
    origin = corsOrigin(req);
    if (req.method === 'OPTIONS') return json({}, 200, origin);
    if (req.method !== 'POST') throw new HttpError(405, 'Method not allowed.');
    const { livemode } = paymentConfig();
    const body = await req.json();
    let amount: number, details, transaction;
    try {
      amount = amountToCents(body.amount_usd);
      details = validateDonorDetails(body.donor_name, body.public_recognition);
      transaction = validateCryptoTransaction(body.crypto_chain, body.transaction_reference);
    } catch (e) { throw new HttpError(400, (e as Error).message); }
    const owner = await donor(req, body.guest_token, livemode);
    const { data, error } = await adminClient().rpc('submit_crypto_donation', {
      p_donor_key: owner.key, p_user_id: owner.userId, p_amount_cents: amount, p_livemode: livemode,
      p_chain: transaction.crypto_chain, p_transaction_hash: transaction.transaction_hash,
      p_donor_name: details.donor_name, p_public_recognition: details.public_recognition,
    });
    if (error?.code === '23505') throw new HttpError(409, 'This transaction has already been submitted. Please do not submit it again.');
    if (error?.message.includes('rate limit')) throw new HttpError(429, 'Too many submissions. Try again later.');
    if (error) throw error;
    return json({ donation_id: data, status: 'pending_review', account_credit_eligible: Boolean(owner.userId) }, 200, origin);
  } catch (e) { return failure(e, origin); }
}
if (import.meta.main) Deno.serve(handler);
