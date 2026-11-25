/**
 * Shared supporter policy values used by the browser and Supabase functions.
 *
 * Point weights and usage thresholds are expressed in points. Donation tier
 * amounts are authored in whole USD for readability and exposed in cents for
 * payment/status comparisons. A checkout still requires at least $1 USD, while
 * any verified positive cent balance retains the existing Member+ status.
 */
export const POINT_WEIGHTS = {
  PROGRAM_DETAILS_VIEW: 10,
  MAP_VIEW: 20,
  SEARCH_QUERY: 2,
};

export const BASE_THRESHOLDS = {
  SOFT: 40,
  HARD: 70,
};

export const HALVED_THRESHOLDS = {
  SOFT: 20,
  HARD: 35,
};

export const DONATION_TIERS_USD = {
  PATRON: 500,
  CHAMPION: 50,
  SUPPORTER: 5,
  MEMBER_PLUS: 1,
};

export const DONATION_TIERS_CENTS = Object.fromEntries(
  Object.entries(DONATION_TIERS_USD).map(([tier, dollars]) => [tier, dollars * 100]),
);
