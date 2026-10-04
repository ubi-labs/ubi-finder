import { validateDonorDetails } from '../_shared/donor-details.js';
import { amountToCents, validateReturnOrigin } from '../_shared/payment-policy.js';
import { adminClient, corsOrigin, donor, failure, HttpError, json, paymentConfig, required } from '../_shared/payments.ts';
export async function handler(req: Request) {
  let origin: string | undefined;
  try {
    origin = corsOrigin(req);
    if (req.method === 'OPTIONS') return json({}, 200, origin);
    if (req.method !== 'POST') throw new HttpError(405, 'Method not allowed.');
    const { stripe, livemode, origins } = paymentConfig();
    required('STRIPE_WEBHOOK_SECRET');
    const body = await req.json();
    let amount: number, returnOrigin: string;
    try { amount = amountToCents(body.amount_usd); returnOrigin = validateReturnOrigin(body.return_url, origins); }
    catch (e) { throw new HttpError(400, (e as Error).message); }
    let details;
    try { details = validateDonorDetails(body.donor_name, body.public_recognition); }
    catch (e) { throw new HttpError(400, (e as Error).message); }
    const owner = await donor(req, body.guest_token, livemode);
    const db = adminClient();
    const { data: checkoutId, error: reserveError } = await db.rpc('reserve_donation_checkout', { p_donor_key: owner.key, p_user_id: owner.userId, p_amount_cents: amount, p_livemode: livemode });
    if (reserveError) {
      if (reserveError.message.includes('rate limit')) throw new HttpError(429, 'Too many checkout attempts. Try again later.');
      throw reserveError;
    }
    try {
      const session = await stripe.checkout.sessions.create({ mode: 'payment', customer_email: owner.email,
        metadata: { checkout_id: checkoutId }, payment_intent_data: { receipt_email: owner.email, metadata: { checkout_id: checkoutId } },
        line_items: [{ price_data: { currency: 'usd', unit_amount: amount, product_data: { name: 'UBI Finder community contribution' } }, quantity: 1 }],
        success_url: `${returnOrigin}/donate/success?session_id={CHECKOUT_SESSION_ID}`, cancel_url: `${returnOrigin}/donate/success?cancelled=1`,
      }, { idempotencyKey: checkoutId });
      const { error } = await db.from('donation_checkouts').update({ stripe_session_id: session.id, ...details }).eq('id', checkoutId);
      if (error || !session.url) { await stripe.checkout.sessions.expire(session.id); throw error || new Error('Checkout URL missing'); }
      return json({ url: session.url, session_id: session.id }, 200, origin);
    } catch (e) { await db.from('donation_checkouts').update({ status: 'failed' }).eq('id', checkoutId); throw e; }
  } catch (e) { return failure(e, origin); }
}
if (import.meta.main) Deno.serve(handler);
