import assert from 'node:assert/strict';
import { randomUUID } from 'node:crypto';
import { createClient } from '@supabase/supabase-js';
import { getLocalAdminClient } from '../acceptance/support/local-supabase.js';

const admin = getLocalAdminClient();
const anon = createClient(process.env.VITE_SUPABASE_URL, process.env.VITE_SUPABASE_ANON_KEY);
const users = [];

async function createSignedInUser(label) {
  const password = `${randomUUID()}Aa1!`;
  const created = await admin.auth.admin.createUser({
    email: `usage-${label}-${randomUUID()}@example.test`, password, email_confirm: true,
  });
  assert.equal(created.error, null);
  users.push(created.data.user.id);
  const client = createClient(process.env.VITE_SUPABASE_URL, process.env.VITE_SUPABASE_ANON_KEY);
  const signedIn = await client.auth.signInWithPassword({ email: created.data.user.email, password });
  assert.equal(signedIn.error, null);
  return { client, user: created.data.user };
}

try {
  assert.ok((await anon.from('user_usage_points').select('points_total')).error, 'anonymous read must be denied');
  assert.ok((await anon.from('user_usage_points').insert({ ip_hash: 'anon_denied', points_total: 1 })).error, 'anonymous write must be denied');

  const owner = await createSignedInUser('owner');
  const other = await createSignedInUser('other');
  const hash = `anon_${randomUUID().replaceAll('-', '').slice(0, 20)}`;
  const ownRow = {
    user_id: owner.user.id,
    ip_hash: hash,
    points_total: 12,
    program_views_count: 1,
    map_views_count: 0,
    search_queries_count: 1,
    encouragement_shown: false,
  };

  assert.equal((await owner.client.from('user_usage_points').upsert(ownRow, { onConflict: 'user_id,ip_hash' })).error, null);
  assert.deepEqual(
    (await owner.client.from('user_usage_points').select('user_id,ip_hash,points_total').eq('ip_hash', hash)).data,
    [{ user_id: owner.user.id, ip_hash: hash, points_total: 12 }],
  );
  assert.deepEqual(
    (await other.client.from('user_usage_points').select('user_id,ip_hash,points_total').eq('ip_hash', hash)).data,
    [],
    'another account cannot read owner telemetry',
  );
  assert.equal((await other.client.from('user_usage_points').update({ points_total: 99 }).eq('ip_hash', hash)).error, null);
  assert.equal(
    (await owner.client.from('user_usage_points').select('points_total').eq('ip_hash', hash).single()).data.points_total,
    12,
    'another account cannot update owner telemetry',
  );
  assert.ok((await owner.client.from('user_usage_points').update({ user_id: other.user.id }).eq('ip_hash', hash)).error, 'ownership transfer must be denied');
  assert.ok((await other.client.from('user_usage_points').insert({ ...ownRow, ip_hash: `${hash}x` })).error, 'cross-user insert must be denied');
  assert.ok((await owner.client.from('user_usage_points').insert({ ...ownRow, ip_hash: `${hash}n`, points_total: -1 })).error, 'negative telemetry must be denied');
  assert.ok((await owner.client.from('user_usage_points').insert({ ...ownRow, ip_hash: 'forged' })).error, 'malformed hashes must be denied');
  assert.ok((await owner.client.from('user_usage_points').update({ has_donated: true }).eq('ip_hash', hash)).error, 'paid status forgery must be denied');
  assert.ok((await owner.client.from('user_usage_points').update({ total_donated_usd: 999 }).eq('ip_hash', hash)).error, 'donated amount forgery must be denied');
  assert.equal((await owner.client.from('user_usage_points').update({ points_total: 0 }).eq('ip_hash', hash)).error, null);
  assert.equal(
    (await owner.client.from('user_usage_points').select('points_total').eq('ip_hash', hash).single()).data.points_total,
    0,
    'profile reset to zero must remain valid',
  );

  console.log('Usage points: anonymous denial, own-account upsert/read/reset, cross-account isolation, constraints and payment-field denial passed.');
} finally {
  for (const id of users) {
    const deleted = await admin.auth.admin.deleteUser(id);
    if (deleted.error) throw deleted.error;
  }
}
