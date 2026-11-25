import { supabase } from '@/lib/supabaseClient';
import { getVerifiedSupporter, loadDonationStatus } from '@/lib/donationStatus';
import { supporterTier } from '../../supabase/functions/_shared/payment-policy.js';
import {
  BASE_THRESHOLDS,
  HALVED_THRESHOLDS,
  POINT_WEIGHTS,
} from '../../supabase/functions/_shared/supporter-constants.js';

export { BASE_THRESHOLDS, HALVED_THRESHOLDS, POINT_WEIGHTS };

const STORAGE_KEY = 'ubi_supporter_points_v1';
const MAX_DATABASE_INTEGER = 2147483647;
const CLIENT_IDENTIFIER_PATTERN = /^(?:ip_[a-z0-9]{1,64}|anon_[a-z0-9]{1,64})$/;

let cachedIpHash = null;

const defaultSupporterState = () => ({
  points: 0,
  programViews: 0,
  mapViews: 0,
  searchQueries: 0,
  encouragementShown: false,
  hasDonated: false,
  totalDonatedUsd: 0,
  isIpHalved: false,
  hasUsedProfileReset: false
});

function sanitizeCounter(value) {
  return Number.isSafeInteger(value) && value >= 0 && value <= MAX_DATABASE_INTEGER ? value : 0;
}

function sanitizeLocalSupporterState(value) {
  const candidate = value || {};
  const defaults = defaultSupporterState();
  return {
    ...defaults,
    ...candidate,
    points: sanitizeCounter(candidate.points),
    programViews: sanitizeCounter(candidate.programViews),
    mapViews: sanitizeCounter(candidate.mapViews),
    searchQueries: sanitizeCounter(candidate.searchQueries),
  };
}

function incrementCounter(value, amount) {
  return Math.min(MAX_DATABASE_INTEGER, sanitizeCounter(value) + amount);
}

// Get or generate an opaque browser-local identifier. It is telemetry only,
// never proof of an IP address, account ownership, payment, or quota authority.
export async function getClientIpHash() {
  if (cachedIpHash) return cachedIpHash;

  const stored = localStorage.getItem('ubi_client_ip_hash');
  if (stored && CLIENT_IDENTIFIER_PATTERN.test(stored)) {
    cachedIpHash = stored;
    return stored;
  }

  let fallback = localStorage.getItem('ubi_client_anon_id');
  if (!fallback || !CLIENT_IDENTIFIER_PATTERN.test(fallback)) {
    fallback = 'anon_' + (Math.random().toString(36).substring(2, 12) || '0');
    localStorage.setItem('ubi_client_anon_id', fallback);
  }
  cachedIpHash = fallback;
  return fallback;
}

// Read local state
export function getLocalSupporterState() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (raw) {
      return sanitizeLocalSupporterState(JSON.parse(raw));
    }
  } catch (e) {
    // Ignore parse error
  }
  return defaultSupporterState();
}

// Save local state
export function saveLocalSupporterState(state) {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(sanitizeLocalSupporterState(state)));
    window.dispatchEvent(new Event('ubi_supporter_state_changed'));
  } catch (e) {
    // Ignore
  }
}

// Compute supporter tier / category
export function getSupporterCategory(user = null) {
  const verified = getVerifiedSupporter(user);
  const local = { hasDonated: verified.has_donated, totalDonatedUsd: verified.total_cents / 100 };
  if (!local.hasDonated && (!local.totalDonatedUsd || local.totalDonatedUsd <= 0)) {
    return {
      category: 'Member',
      badgeClass: 'text-gray-500 bg-gray-100 border-gray-200',
      isSupporter: false,
      amount: 0
    };
  }

  const amount = Number(local.totalDonatedUsd || 0);
  const verifiedCents = Number.isFinite(Number(verified.total_cents))
    ? Number(verified.total_cents)
    : 1;
  const category = supporterTier(verifiedCents);

  if (category === 'Patron') {
    return {
      category: 'Patron',
      badgeClass: 'text-amber-900 bg-amber-100 border-amber-300 font-bold',
      isSupporter: true,
      amount
    };
  } else if (category === 'Champion') {
    return {
      category: 'Champion',
      badgeClass: 'text-emerald-900 bg-emerald-100 border-emerald-300 font-bold',
      isSupporter: true,
      amount
    };
  } else if (category === 'Supporter') {
    return {
      category: 'Supporter',
      badgeClass: 'text-teal-900 bg-teal-100 border-teal-300 font-bold',
      isSupporter: true,
      amount
    };
  } else {
    return {
      category: 'Member+',
      badgeClass: 'text-blue-900 bg-blue-100 border-blue-300 font-bold',
      isSupporter: true,
      amount
    };
  }
}

// Retained for callers that imported the old helper. Browser-provided identifiers
// no longer authorize cross-account lookup or shared-IP threshold changes.
export async function checkIsIpHalved() {
  return false;
}

// Evaluate status
export async function getSupporterStatus(user = null) {
  try { await loadDonationStatus(user); } catch { /* Verification errors grant no payment access. */ }
  const verified = getVerifiedSupporter(user);
  const local = { ...getLocalSupporterState(), hasDonated: verified.has_donated, totalDonatedUsd: verified.total_cents / 100 };
  const isIpHalved = local.isIpHalved;

  const softThreshold = isIpHalved ? HALVED_THRESHOLDS.SOFT : BASE_THRESHOLDS.SOFT;
  const hardThreshold = isIpHalved ? HALVED_THRESHOLDS.HARD : BASE_THRESHOLDS.HARD;

  const isGated = !local.hasDonated && local.points >= hardThreshold;
  const shouldEncourage = !local.hasDonated && !local.encouragementShown && local.points >= softThreshold && !isGated;

  return {
    points: local.points,
    programViews: local.programViews,
    mapViews: local.mapViews,
    searchQueries: local.searchQueries,
    encouragementShown: local.encouragementShown,
    hasDonated: local.hasDonated,
    totalDonatedUsd: local.totalDonatedUsd,
    isIpHalved,
    hasUsedProfileReset: local.hasUsedProfileReset || false,
    softThreshold,
    hardThreshold,
    isGated,
    shouldEncourage
  };
}

// Record usage action
export async function recordUsageAction(actionType, user = null) {
  const pointsToAdd = POINT_WEIGHTS[actionType] || 0;
  if (pointsToAdd === 0) return await getSupporterStatus(user);

  const local = getLocalSupporterState();
  local.points = incrementCounter(local.points, pointsToAdd);

  if (actionType === 'PROGRAM_DETAILS_VIEW') local.programViews = incrementCounter(local.programViews, 1);
  else if (actionType === 'MAP_VIEW') local.mapViews = incrementCounter(local.mapViews, 1);
  else if (actionType === 'SEARCH_QUERY') local.searchQueries = incrementCounter(local.searchQueries, 1);

  saveLocalSupporterState(local);

  const ipHash = await getClientIpHash();
  const userId = user?.id;

  // Guests remain browser-local. Signed-in counters are telemetry synchronized
  // to the account's own RLS-protected row after local integer sanitization.
  if (supabase && userId) {
    (async () => {
      try {
        await supabase.from('user_usage_points').upsert({
          user_id: userId,
          ip_hash: ipHash,
          points_total: local.points,
          program_views_count: local.programViews,
          map_views_count: local.mapViews,
          search_queries_count: local.searchQueries,
          encouragement_shown: local.encouragementShown,
          last_action_at: new Date().toISOString(),
          updated_at: new Date().toISOString()
        }, { onConflict: 'user_id,ip_hash' });
      } catch (err) {
        // Silently ignore upsert error
      }
    })();
  }

  return await getSupporterStatus(user);
}

// Mark encouragement as shown
export async function markEncouragementDismissed(user = null) {
  const local = getLocalSupporterState();
  local.encouragementShown = true;
  saveLocalSupporterState(local);

  const ipHash = await getClientIpHash();
  if (supabase && user?.id) {
    try {
      await supabase.from('user_usage_points').upsert({
        user_id: user.id,
        ip_hash: ipHash,
        encouragement_shown: true,
        updated_at: new Date().toISOString()
      }, { onConflict: 'user_id,ip_hash' });
    } catch (e) {
      // Silently ignore upsert error
    }
  }
}

// Reset points upon complete profile submission:
// - Points are reset to 0 for everyone at time of profile completion.
// - If the site was previously locked (wasGated), applying profile completion unlocks it with the halved 20/35 pt threshold.
// - If the site was never locked before profile completion, the normal threshold continues to apply.
export async function resetPointsWithProfileCompletion(user = null) {
  const local = getLocalSupporterState();
  const currentHardThreshold = local.isIpHalved ? HALVED_THRESHOLDS.HARD : BASE_THRESHOLDS.HARD;
  const wasGated = !getVerifiedSupporter(user).has_donated && local.points >= currentHardThreshold;

  // Reset points to 0 for everyone at profile completion
  local.points = 0;

  // Only apply the halved 20/35 pt threshold if previously locked out
  if (wasGated) {
    local.isIpHalved = true;
  }
  local.hasUsedProfileReset = true;
  saveLocalSupporterState(local);

  const ipHash = await getClientIpHash();
  const userId = user?.id;

  if (supabase && userId) {
    try {
      await supabase.from('user_usage_points').upsert({
        user_id: userId,
        ip_hash: ipHash,
        points_total: 0,
        updated_at: new Date().toISOString()
      }, { onConflict: 'user_id,ip_hash' });
    } catch (e) {
      // Silently ignore upsert error
    }
  }

  return await getSupporterStatus(user);
}
