import Stripe from 'npm:stripe@23.0.0';
import { validatePaidSession } from '../_shared/payment-policy.js';
import { adminClient, failure, HttpError, json, paymentConfig, required } from '../_shared/payments.ts';
export async function handler(req: Request) {
  try {
    if (req.method !== 'POST') throw new HttpError(405, 'Method not allowed.');
    const { stripe, livemode } = paymentConfig();
    const secret = required('STRIPE_WEBHOOK_SECRET');
    let event: Stripe.Event;
    try { event = await stripe.webhooks.constructEventAsync(await req.text(), req.headers.get('stripe-signature') || '', secret, undefined, Stripe.createSubtleCryptoProvider()); }
    catch { throw new HttpError(400, 'Invalid webhook signature.'); }
    if (event.livemode !== livemode) throw new HttpError(400, 'Webhook environment mismatch.');
    const paid = ['checkout.session.completed', 'checkout.session.async_payment_succeeded'];
    const failed = ['checkout.session.async_payment_failed', 'checkout.session.expired'];
    if (![...paid, ...failed].includes(event.type)) return json({ received: true });
    const sessionId = (event.data.object as Stripe.Checkout.Session).id;
    const db = adminClient();
    const { data: checkout, error } = await db.from('donation_checkouts').select('*').eq('stripe_session_id', sessionId).maybeSingle();
    if (error) throw error;
    if (!checkout) return json({ received: true, ignored: true });
    if (failed.includes(event.type)) {
      const { error: updateError } = await db.from('donation_checkouts').update({ status: event.type.endsWith('expired') ? 'expired' : 'failed' }).eq('id', checkout.id).eq('status', 'pending');
      if (updateError) throw updateError;
      return json({ received: true });
    }
    const session = await stripe.checkout.sessions.retrieve(sessionId, { expand: ['payment_intent.latest_charge'] });
    if (!validatePaidSession(session, checkout, livemode)) return json({ received: true, pending: true });
    const intent = session.payment_intent as Stripe.PaymentIntent;
    if (!intent || typeof intent === 'string') throw new Error('Missing verified payment intent');
    const charge = intent.latest_charge as Stripe.Charge | null;
    const { error: fulfillError } = await db.rpc('fulfill_stripe_donation', { p_event_id: event.id, p_session_id: session.id, p_payment_intent_id: intent.id, p_amount_cents: session.amount_total, p_livemode: livemode, p_receipt_url: charge && typeof charge !== 'string' ? charge.receipt_url : null });
    if (fulfillError) throw fulfillError;
    return json({ received: true });
  } catch (e) { return failure(e); }
}
if (import.meta.main) Deno.serve(handler);
