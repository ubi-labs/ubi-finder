import assert from 'node:assert/strict';
import { handler as webhook } from '../stripe-webhook/index.ts';
import { handler as checkout } from '../create-stripe-checkout/index.ts';
import { handler as status } from '../donation-status/index.ts';

const session = { id: 'cs_test_fixture', currency: 'usd', amount_total: 500, livemode: false,
  payment_status: 'paid', metadata: { checkout_id: 'checkout-1' },
  payment_intent: { id: 'pi_fixture', latest_charge: { receipt_url: 'https://pay.stripe.com/receipts/fixture' } } };
const row = { id: 'checkout-1', stripe_session_id: session.id, amount_cents: 500, livemode: false, donor_key: 'test:guest:fixture', status: 'pending' };
const config = { STRIPE_SECRET_KEY: 'sk_test_fixture', STRIPE_WEBHOOK_SECRET: 'whsec_fixture', SUPABASE_URL: 'http://127.0.0.1:60321', SUPABASE_SERVICE_ROLE_KEY: 'service-fixture', SUPABASE_ANON_KEY: 'anon-fixture', STRIPE_ALLOWED_ORIGINS: 'http://127.0.0.1:4173', STRIPE_MODE: 'test' };
async function configured(test: () => Promise<void>) {
  const old = Object.fromEntries(Object.keys(config).map((k) => [k, Deno.env.get(k)]));
  for (const [key, value] of Object.entries(config)) Deno.env.set(key, value);
  const fetch = globalThis.fetch;
  try { await test(); }
  finally {
    globalThis.fetch = fetch;
    for (const [key, value] of Object.entries(old)) value === undefined ? Deno.env.delete(key) : Deno.env.set(key, value);
  }
}
async function signed(type = 'checkout.session.completed', mode = false) {
  const body = JSON.stringify({ id: 'evt_fixture', type, livemode: mode, data: { object: { id: session.id } } });
  const timestamp = Math.floor(Date.now() / 1000);
  const key = await crypto.subtle.importKey('raw', new TextEncoder().encode(config.STRIPE_WEBHOOK_SECRET), { name: 'HMAC', hash: 'SHA-256' }, false, ['sign']);
  const signature = Array.from(new Uint8Array(await crypto.subtle.sign('HMAC', key, new TextEncoder().encode(`${timestamp}.${body}`))), (b) => b.toString(16).padStart(2, '0')).join('');
  return new Request('http://localhost/webhook', { method: 'POST', body, headers: { 'stripe-signature': `t=${timestamp},v1=${signature}` } });
}
function mockDatabase(paidSession = session, unknown = false, rpcFails = false) {
  const calls: { url: string; body: Record<string, unknown> | null }[] = [];
  globalThis.fetch = (input, init) => {
    const url = String(input instanceof Request ? input.url : input);
    const body = init?.body && typeof init.body === 'string' ? JSON.parse(init.body) : null;
    calls.push({ url, body });
    if (url.includes('api.stripe.com')) return Promise.resolve(Response.json(paidSession));
    if (url.includes('fulfill_stripe_donation')) return Promise.resolve(Response.json(rpcFails ? { message: 'database unavailable' } : true, { status: rpcFails ? 500 : 200 }));
    if (url.includes('donation_checkouts')) return Promise.resolve(Response.json(unknown ? null : row));
    throw new Error('Unexpected HTTP call: ' + url);
  };
  return calls;
}
Deno.test('webhook rejects unsigned requests and environment mismatch before writes', () => configured(async () => {
  const calls = mockDatabase();
  assert.equal((await webhook(new Request('http://localhost', { method: 'POST', body: '{}' }))).status, 400);
  assert.equal((await webhook(await signed('checkout.session.completed', true))).status, 400);
  assert.equal(calls.length, 0);
}));
Deno.test('signed payment retrieves Stripe state and passes trusted amount/receipt to fulfillment', () => configured(async () => {
  const calls = mockDatabase();
  assert.equal((await webhook(await signed())).status, 200);
  const rpc = calls.find((c) => c.url.includes('fulfill_stripe_donation'));
  assert.equal(rpc?.body?.p_amount_cents, 500);
  assert.equal(rpc?.body?.p_payment_intent_id, 'pi_fixture');
  assert.equal(rpc?.body?.p_receipt_url, 'https://pay.stripe.com/receipts/fixture');
}));
Deno.test('unpaid completion does not grant access; async success does', () => configured(async () => {
  let calls = mockDatabase({ ...session, payment_status: 'unpaid' });
  assert.equal((await webhook(await signed())).status, 200);
  assert.equal(calls.some((c) => c.url.includes('fulfill_stripe_donation')), false);
  calls = mockDatabase();
  assert.equal((await webhook(await signed('checkout.session.async_payment_succeeded'))).status, 200);
  assert.equal(calls.some((c) => c.url.includes('fulfill_stripe_donation')), true);
}));
Deno.test('wrong amount fails closed and database failure requests webhook retry', () => configured(async () => {
  let calls = mockDatabase({ ...session, amount_total: 50000 });
  assert.equal((await webhook(await signed())).status, 500);
  assert.equal(calls.some((c) => c.url.includes('fulfill_stripe_donation')), false);
  mockDatabase(session, false, true);
  assert.equal((await webhook(await signed())).status, 500);
}));
Deno.test('unknown checkout is ignored; failure and expiry only update pending rows', () => configured(async () => {
  let calls = mockDatabase(session, true);
  assert.equal((await webhook(await signed())).status, 200);
  assert.equal(calls.length, 1);
  for (const type of ['checkout.session.async_payment_failed', 'checkout.session.expired']) {
    calls = mockDatabase();
    assert.equal((await webhook(await signed(type))).status, 200);
    assert.equal(calls[1].url.includes('status=eq.pending'), true);
    assert.equal(calls.some((c) => c.url.includes('fulfill_stripe_donation')), false);
  }
}));
Deno.test('checkout configuration, origins, amounts, and methods fail closed', () => configured(async () => {
  Deno.env.delete('STRIPE_SECRET_KEY');
  assert.equal((await checkout(new Request('http://localhost', { method: 'POST', body: '{}' }))).status, 503);
  Deno.env.set('STRIPE_SECRET_KEY', config.STRIPE_SECRET_KEY);
  assert.equal((await checkout(new Request('http://localhost', { method: 'GET' }))).status, 405);
  for (const body of [{ amount_usd: 0, return_url: 'http://127.0.0.1:4173' }, { amount_usd: 5, return_url: 'https://evil.example' }]) {
    assert.equal((await checkout(new Request('http://localhost', { method: 'POST', body: JSON.stringify(body) }))).status, 400);
  }
  assert.equal((await checkout(new Request('http://localhost', { method: 'OPTIONS', headers: { origin: 'https://evil.example' } }))).status, 403);
}));
Deno.test('status validates guest capability and never exposes another donor checkout', () => configured(async () => {
  assert.equal((await status(new Request('http://localhost', { method: 'POST', body: JSON.stringify({ guest_token: 'weak' }) }))).status, 400);
  const calls = mockDatabase(session, true);
  assert.equal((await status(new Request('http://localhost', { method: 'POST', body: JSON.stringify({ guest_token: 'a'.repeat(64), session_id: session.id }) }))).status, 404);
  assert.equal(calls[0].url.includes('donor_key=eq.test%3Aguest%3A'), true);
}));
Deno.test('checkout uses server ownership, exact cents and safe hosted URLs', () => configured(async () => {
  const calls: { url: string; body: string }[] = [];
  globalThis.fetch = (input, init) => {
    const url = String(input instanceof Request ? input.url : input);
    const body = String(init?.body || '');
    calls.push({ url, body });
    if (url.includes('reserve_donation_checkout')) return Promise.resolve(Response.json('checkout-fixture'));
    if (url.includes('api.stripe.com')) return Promise.resolve(Response.json({ id: session.id, url: 'https://checkout.stripe.com/c/pay/fixture' }));
    if (url.includes('donation_checkouts')) return Promise.resolve(new Response(null, { status: 204 }));
    throw new Error('Unexpected HTTP call');
  };
  const response = await checkout(new Request('http://localhost', { method: 'POST', body: JSON.stringify({ guest_token: 'a'.repeat(64), user_id: 'forged-user', user_email: 'forged@example.test', amount_usd: '5.25', return_url: 'http://127.0.0.1:4173' }) }));
  assert.equal(response.status, 200);
  assert.equal(JSON.parse(calls[0].body).p_user_id, null);
  assert.equal(JSON.parse(calls[0].body).p_amount_cents, 525);
  const params = new URLSearchParams(calls.find((c) => c.url.includes('api.stripe.com'))?.body);
  assert.equal(params.get('line_items[0][price_data][unit_amount]'), '525');
  assert.equal(params.get('success_url'), 'http://127.0.0.1:4173/donate/success?session_id={CHECKOUT_SESSION_ID}');
  assert.equal(params.has('customer_email'), false);
  assert.equal(params.get('metadata[checkout_id]'), 'checkout-fixture');
}));
Deno.test('forged JWT cannot create checkout or select account status', () => configured(async () => {
  let calls = 0;
  globalThis.fetch = () => { calls++; return Promise.resolve(Response.json({ message: 'invalid token' }, { status: 401 })); };
  const body = JSON.stringify({ guest_token: 'a'.repeat(64), amount_usd: 5, return_url: 'http://127.0.0.1:4173' });
  for (const handler of [checkout, status]) assert.equal((await handler(new Request('http://localhost', { method: 'POST', body, headers: { authorization: 'Bearer forged-token' } }))).status, 401);
  assert.equal(calls, 2);
}));
Deno.test('status binds verified account identity and authoritative total', () => configured(async () => {
  globalThis.fetch = (input) => {
    const url = String(input instanceof Request ? input.url : input);
    if (url.includes('/auth/v1/user')) return Promise.resolve(Response.json({ id: 'verified-user', email: 'donor@example.test' }));
    assert.equal(url.includes('donor_key=eq.test%3Auser%3Averified-user'), true);
    return Promise.resolve(Response.json({ total_cents: 5000 }));
  };
  const response = await status(new Request('http://localhost', { method: 'POST', body: '{}', headers: { authorization: 'Bearer verified-jwt' } }));
  assert.equal(response.status, 200);
  const data = await response.json();
  assert.equal(data.user_id, 'verified-user');
  assert.equal(data.total_cents, 5000);
  assert.equal(data.tier, 'Champion');
}));
