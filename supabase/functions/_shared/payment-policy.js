export function amountToCents(amount) {
  if (!['string', 'number'].includes(typeof amount) || !/^\d+(\.\d{1,2})?$/.test(String(amount))) throw new Error('Enter an amount with at most two decimal places.');
  const cents = Math.round(Number(amount) * 100);
  if (!Number.isSafeInteger(cents) || cents < 100 || cents > 1000000) throw new Error('Choose an amount between $1 and $10,000 USD.');
  return cents;
}
export function validateReturnOrigin(value, allowedOrigins) {
  const url = new URL(value);
  if (url.username || url.password || url.pathname !== '/' || url.search || url.hash || !allowedOrigins.includes(url.origin)) throw new Error('Return URL is not allowed.');
  return url.origin;
}
export function supporterTier(totalCents) {
  if (totalCents >= 50000) return 'Patron';
  if (totalCents >= 5000) return 'Champion';
  if (totalCents >= 500) return 'Supporter';
  return totalCents > 0 ? 'Member+' : 'Member';
}
export function validatePaidSession(session, checkout, livemode) {
  if (session.livemode !== livemode || checkout.livemode !== livemode || session.currency !== 'usd' || session.amount_total !== checkout.amount_cents || session.metadata?.checkout_id !== checkout.id || session.id !== checkout.stripe_session_id) throw new Error('Payment does not match checkout.');
  return session.payment_status === 'paid';
}

/**
 * @param {string} mode
 * @param {string | null} [configuredOrigins]
 */
export function paymentOrigins(mode, configuredOrigins = null) {
  if (!['test', 'live'].includes(mode)) throw new Error('Invalid payment environment.');
  if (configuredOrigins !== null) return configuredOrigins.split(',').map((origin) => origin.trim()).filter(Boolean);
  const origins = ['https://ubifinder.org', 'https://www.ubifinder.org'];
  if (mode === 'test') origins.push('https://v0-ubi-finder-git-codex-19-stripe-donations-cubid-team.vercel.app');
  return origins;
}
