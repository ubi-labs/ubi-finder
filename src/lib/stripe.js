import { validateDonorDetails, validateCryptoTransaction } from '../../supabase/functions/_shared/donor-details.js';
import { supabase } from '@/lib/supabaseClient';
import { getDonationGuestToken } from '@/lib/donationStatus';
import { amountToCents } from '../../supabase/functions/_shared/payment-policy.js';

export async function initiateStripeCheckout({ amountUsd = 5, user = null, returnUrl = null, donorDetails = { donor_name: '', public_recognition: false } }) {
  amountToCents(amountUsd);
  const details = validateDonorDetails(donorDetails.donor_name, donorDetails.public_recognition);
  const { data, error } = await supabase.functions.invoke('create-stripe-checkout', {
    body: { ...details, amount_usd: amountUsd, guest_token: getDonationGuestToken(), return_url: returnUrl || window.location.origin },
  });
  if (error || !data?.url) throw new Error('Checkout is unavailable. No payment was taken. Please try again.');
  const url = new URL(data.url);
  if (url.protocol !== 'https:' || url.hostname !== 'checkout.stripe.com' || url.username || url.password) {
    throw new Error('The payment provider returned an invalid checkout link.');
  }
  window.location.assign(url.href);
}

export async function submitCryptoDonation({ amountUsd, donorDetails, chain, transactionReference }) {
  amountToCents(amountUsd);
  const details = validateDonorDetails(donorDetails.donor_name, donorDetails.public_recognition);
  validateCryptoTransaction(chain, transactionReference);
  const { data, error } = await supabase.functions.invoke('submit-crypto-donation', {
    body: { ...details, amount_usd: amountUsd, guest_token: getDonationGuestToken(), crypto_chain: chain, transaction_reference: transactionReference },
  });
  if (error || !data?.donation_id || data.status !== 'pending_review') {
    if (error?.context?.status === 409) throw new Error('This transaction has already been submitted for review.');
    throw new Error('Unable to record your transaction. Please try again.');
  }
  return data;
}
