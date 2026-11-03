import { supabase } from './supabaseClient';
let cached;
let pending;
export async function catalogPage(body = {}) {
  const { data: session } = await supabase.auth.getSession();
  const { data, error } = await supabase.functions.invoke('program-catalog', {
    body, headers: { Authorization: session?.session?.access_token ? `Bearer ${session.session.access_token}` : '' }
  });
  if (error) {
    let message = 'Programs are temporarily unavailable. Please try again.';
    try { message = (await error.context.json()).error || message; } catch { /* No public server detail. */ }
    throw new Error(message);
  }
  return data;
}
// Only public summaries are cached. Full details always pass through server quotas.
export async function programSummaries() {
  if (cached && cached.expires > Date.now()) return cached.data;
  if (pending) return pending;
  pending = (async () => {
    const data = [];
    let after = 0;
    for (let page = 0; page < 50; page++) {
      const result = await catalogPage({ after, limit: 20 });
      data.push(...result.programs);
      if (result.next === null) { cached = { data, expires: Date.now() + 60_000 }; return data; }
      if (result.next <= after) throw new Error('Invalid program response.');
      after = result.next;
    }
    throw new Error('Too many results. Please narrow your search.');
  })();
  try { return await pending; } finally { pending = null; }
}
export async function programDetail(programId) {
  return (await catalogPage({ program_id: Number(programId) })).program;
}
export async function programSummaryResult() { return { data: await programSummaries(), error: null }; }
