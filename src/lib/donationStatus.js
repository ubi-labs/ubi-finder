import { supabase } from '@/lib/supabaseClient';
import { supporterTier } from '../../supabase/functions/_shared/payment-policy.js';

const TOKEN_KEY = 'ubi_donation_guest_token';
const verified = new Map();
export function getDonationGuestToken() {
  let token = localStorage.getItem(TOKEN_KEY);
  if (!token || !/^[a-f0-9]{64}$/.test(token)) {
    token = Array.from(crypto.getRandomValues(new Uint8Array(32)), (b) => b.toString(16).padStart(2, '0')).join('');
    localStorage.setItem(TOKEN_KEY, token);
  }
  return token;
}
function ownerKey(user) { return user?.id || `guest:${getDonationGuestToken()}`; }
export function getVerifiedSupporter(user = null) {
  try { return verified.get(ownerKey(user))?.status || { total_cents: 0, has_donated: false, tier: 'Member' }; }
  catch { return { total_cents: 0, has_donated: false, tier: 'Member' }; }
}
export async function loadDonationStatus(user = null, sessionId = null, force = false) {
  const key = ownerKey(user);
  const cached = verified.get(key);
  if (!sessionId && !force && cached && Date.now() - cached.at < 15000) return cached.status;
  const { data, error } = await supabase.functions.invoke('donation-status', {
    body: { guest_token: getDonationGuestToken(), session_id: sessionId },
  });
  if (error || !data || !Number.isSafeInteger(data.total_cents) || data.total_cents < 0 || data.user_id !== (user?.id || null)) {
    verified.delete(key);
    window.dispatchEvent(new Event('ubi_supporter_state_changed'));
    throw new Error('Could not verify your donation. Please try again.');
  }
  const status = { ...data, has_donated: data.total_cents > 0, tier: supporterTier(data.total_cents) };
  verified.set(key, { at: Date.now(), status });
  window.dispatchEvent(new Event('ubi_supporter_state_changed'));
  return status;
}
