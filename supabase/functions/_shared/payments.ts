import { paymentOrigins } from './payment-policy.js';
import Stripe from 'npm:stripe@23.0.0';
import { createClient } from 'npm:@supabase/supabase-js@2.112.3';
export class HttpError extends Error {
  constructor(public status: number, message: string) { super(message); }
}
export function required(name: string) {
  const value = Deno.env.get(name);
  if (!value) throw new HttpError(503, 'Payments are not configured. Please try again later.');
  return value;
}
export function paymentConfig() {
  const key = required('STRIPE_SECRET_KEY');
  const mode = Deno.env.get('STRIPE_MODE') || 'test';
  if (!['test', 'live'].includes(mode) || !['sk', 'rk'].some((type) => key.startsWith(`${type}_${mode}_`))) throw new HttpError(503, 'Payment environment configuration mismatch.');
  const origins = paymentOrigins(mode, Deno.env.get('STRIPE_ALLOWED_ORIGINS') ?? null);
  return { stripe: new Stripe(key, { httpClient: Stripe.createFetchHttpClient() }), livemode: mode === 'live', origins };
}
export function adminClient() {
  return createClient(required('SUPABASE_URL'), required('SUPABASE_SERVICE_ROLE_KEY'), { auth: { autoRefreshToken: false, persistSession: false } });
}
export async function donor(req: Request, guestToken: unknown, livemode: boolean) {
  const token = req.headers.get('authorization')?.replace(/^Bearer /i, '');
  let userId: string | null = null;
  let email: string | undefined;
  if (token && token !== Deno.env.get('SUPABASE_ANON_KEY') && !token.startsWith('sb_publishable_')) {
    const { data, error } = await adminClient().auth.getUser(token);
    if (error || !data.user) throw new HttpError(401, 'Please sign in again.');
    userId = data.user.id; email = data.user.email;
  }
  let identity: string;
  if (userId) identity = `user:${userId}`;
  else {
    if (typeof guestToken !== 'string' || !/^[a-f0-9]{64}$/.test(guestToken)) throw new HttpError(400, 'A valid guest token is required.');
    const digest = await crypto.subtle.digest('SHA-256', new TextEncoder().encode(guestToken));
    identity = 'guest:' + Array.from(new Uint8Array(digest), (b) => b.toString(16).padStart(2, '0')).join('');
  }
  return { key: `${livemode ? 'live' : 'test'}:${identity}`, userId, email };
}
export function json(body: unknown, status = 200, origin?: string) {
  return new Response(JSON.stringify(body), { status, headers: { 'Content-Type': 'application/json', 'Cache-Control': 'no-store', ...(origin ? { 'Access-Control-Allow-Origin': origin, 'Vary': 'Origin', 'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type', 'Access-Control-Allow-Methods': 'POST, OPTIONS' } : {}) } });
}
export function corsOrigin(req: Request) {
  const origin = req.headers.get('origin');
  if (!origin) return undefined;
  let origins: string[];
  try { origins = paymentOrigins(Deno.env.get('STRIPE_MODE') || 'test', Deno.env.get('STRIPE_ALLOWED_ORIGINS') ?? null); }
  catch { throw new HttpError(503, 'Payment environment configuration mismatch.'); }
  if (!origins.includes(origin)) throw new HttpError(403, 'Origin is not allowed.');
  return origin;
}
export function failure(error: unknown, origin?: string) {
  if (error instanceof HttpError) return json({ error: error.message }, error.status, origin);
  console.error('Payment request failed', error instanceof Error ? error.name : 'UnknownError');
  return json({ error: 'Unable to process this payment request. Please try again.' }, 500, origin);
}
