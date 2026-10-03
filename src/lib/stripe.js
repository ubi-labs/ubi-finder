import { supabase } from '@/lib/supabaseClient';
import { getDonationGuestToken } from '@/lib/donationStatus';
import { amountToCents } from '../../supabase/functions/_shared/payment-policy.js';

export async function initiateStripeCheckout({ amountUsd = 5, user = null, returnUrl = null }) {
  amountToCents(amountUsd);
  const { data, error } = await supabase.functions.invoke('create-stripe-checkout', {
    body: { amount_usd: amountUsd, guest_token: getDonationGuestToken(), return_url: returnUrl || window.location.origin },
  });
  if (error || !data?.url) throw new Error('Checkout is unavailable. No payment was taken. Please try again.');
  const url = new URL(data.url);
  if (url.protocol !== 'https:' || url.hostname !== 'checkout.stripe.com' || url.username || url.password) {
    throw new Error('The payment provider returned an invalid checkout link.');
  }
  window.location.assign(url.href);
}
