import { createClient } from 'npm:@supabase/supabase-js@2.112.3';
import { catalogRequest, catalogIp, catalogError } from '../_shared/abuse-policy.js';
const headers = { 'Content-Type': 'application/json', 'Cache-Control': 'no-store', 'Access-Control-Allow-Origin': '*', 'Access-Control-Allow-Headers': 'authorization, apikey, content-type, x-client-info', 'Access-Control-Allow-Methods': 'POST, OPTIONS' };
function json(body: unknown, status = 200) { return new Response(JSON.stringify(body), { status, headers: { ...headers, ...(status === 429 ? { 'Retry-After': '60' } : {}) } }); }
export async function handler(req: Request) {
  if (req.method === 'OPTIONS') return json({});
  if (req.method !== 'POST') return json({ error: 'Method not allowed.' }, 405);
  if (Number(req.headers.get('content-length')) > 1024) return json({ error: 'Request too large.' }, 413);
  let input;
  try {
    const text = await req.text();
    if (text.length > 1024) return json({ error: 'Request too large.' }, 413);
    input = catalogRequest(JSON.parse(text));
  } catch { return json({ error: 'Invalid catalog request.' }, 400); }
  try {
    const url = Deno.env.get('SUPABASE_URL');
    const local = Deno.env.get('ABUSE_LOCAL_DEVELOPMENT') === 'true' && /^http:\/\/(kong|127\.0\.0\.1|localhost)(:|\/)/.test(url || '');
    const ip = catalogIp(req.headers, local);
    const key = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
    if (!url || !key) return json({ error: 'Programs are temporarily unavailable.' }, 503);
    const db = createClient(url, key, { auth: { persistSession: false, autoRefreshToken: false } });
    const token = req.headers.get('authorization')?.replace(/^Bearer /i, '');
    let userId: string | null = null;
    if (token && token !== Deno.env.get('SUPABASE_ANON_KEY') && !token.startsWith('sb_publishable_')) {
      const { data, error } = await db.auth.getUser(token);
      if (error || !data.user || !(data.user.email_confirmed_at || data.user.phone_confirmed_at)) return json({ error: 'Please sign in with a verified account.' }, 401);
      userId = data.user.id;
    }
    const { data, error } = await db.rpc('read_program_catalog', { p_ip: ip, p_user_id: userId, p_program_id: input.programId, p_after: input.after, p_limit: input.limit });
    if (error) { const failure = catalogError(error.code, error.message); return json({ error: failure.error }, failure.status); }
    return json(data);
  } catch { return json({ error: 'Programs are temporarily unavailable. Please try again.' }, 503); }
}
if (import.meta.main) Deno.serve(handler);
