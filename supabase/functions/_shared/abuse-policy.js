export function catalogRequest(body) {
  if (!body || typeof body !== 'object' || Array.isArray(body)) throw new Error('Invalid catalog request.');
  if (Object.keys(body).some(k => !['program_id', 'after', 'limit'].includes(k))) throw new Error('Invalid catalog request.');
  const programId = body.program_id ?? null;
  const after = body.after ?? 0;
  const limit = body.limit ?? 20;
  if ((programId !== null && (!Number.isSafeInteger(programId) || programId < 1 || programId > 2147483647)) || !Number.isSafeInteger(after) || after < 0 || after > 2147483647 || !Number.isSafeInteger(limit) || limit < 1 || limit > 20) throw new Error('Invalid catalog request.');
  return { programId, after, limit };
}
// Cloudflare overwrites this header at Supabase's public gateway. Never use a caller's X-Forwarded-For.
export function catalogIp(headers, local = false) {
  if (local) return '127.0.0.1'; // Server-only local test setting; not a request parameter.
  const ip = headers.get('cf-connecting-ip');
  if (!ip || !/^[0-9a-fA-F:.]+$/.test(ip) || ip.length > 45) throw new Error('Unable to validate request source.');
  return ip;
}
export function catalogError(code, message) {
  if (code === '28000') return { status: 401, error: 'Sign in with a verified account to see full program details.' };
  if (code === 'P0001' && message?.includes('quota')) return { status: 429, error: 'Too many program requests. Please wait before trying again.' };
  return { status: 503, error: 'Programs are temporarily unavailable. Please try again.' };
}
