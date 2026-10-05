import { supporterTier } from '../_shared/payment-policy.js';
import { adminClient, corsOrigin, donor, failure, HttpError, json, paymentConfig } from '../_shared/payments.ts';
export async function handler(req: Request) {
  let origin: string | undefined;
  try {
    origin = corsOrigin(req);
    if (req.method === 'OPTIONS') return json({}, 200, origin);
    if (req.method !== 'POST') throw new HttpError(405, 'Method not allowed.');
    const { livemode } = paymentConfig();
    const body = await req.json();
    const owner = await donor(req, body.guest_token, livemode);
    const db = adminClient();
    let payment = null;
    if (body.session_id) {
      if (typeof body.session_id !== 'string' || !/^cs_(test_|live_)?[A-Za-z0-9]+$/.test(body.session_id)) throw new HttpError(400, 'Invalid checkout session.');
      const { data, error } = await db.from('donation_checkouts').select('status, amount_cents, receipt_url').eq('stripe_session_id', body.session_id).eq('donor_key', owner.key).maybeSingle();
      if (error) throw error;
      if (!data) throw new HttpError(404, 'Checkout not found for this donor.');
      payment = data;
    }
    const { data: account, error } = await db.from('supporter_accounts').select('total_cents').eq('donor_key', owner.key).maybeSingle();
    if (error) throw error;
    const totalCents = owner.userId ? Number(account?.total_cents || 0) : 0;
    return json({ user_id: owner.userId, total_cents: totalCents, has_donated: totalCents > 0, tier: supporterTier(totalCents), payment, livemode }, 200, origin);
  } catch (e) { return failure(e, origin); }
}
if (import.meta.main) Deno.serve(handler);
