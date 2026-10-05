import React, { useState } from 'react';
import { Dialog, DialogContent, DialogTitle, DialogDescription } from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import DonationDetailsFields from '@/components/DonationDetailsFields';
import DonationSignInPrompt from '@/components/DonationSignInPrompt';
import { initiateStripeCheckout } from '@/lib/stripe';

export default function StripeCheckoutModal({ isOpen, onClose, amountUsd = 5, user = null, donorDetails = null, onDonorDetailsChange = null }) {
  const [localDetails, setLocalDetails] = useState({ donor_name: '', public_recognition: false });
  const details = donorDetails || localDetails;
  const changeDetails = onDonorDetailsChange || setLocalDetails;
  const [isProcessing, setIsProcessing] = useState(false);
  const [error, setError] = useState('');
  const checkout = async () => {
    setIsProcessing(true); setError('');
    try { await initiateStripeCheckout({ amountUsd, user, donorDetails: details }); }
    catch (e) { setError(e.message); setIsProcessing(false); }
  };
  return (
    <Dialog open={isOpen} onOpenChange={() => { if (!isProcessing) { setError(''); onClose(); } }}>
      <DialogContent className="sm:max-w-md rounded-2xl max-h-[90vh] overflow-y-auto">
        <DialogTitle>{donorDetails && !user ? "Continue without credits?" : "Support UBI Finder"}</DialogTitle>
        <DialogDescription>
          Your donation is ${Number(amountUsd).toFixed(2)} USD.
        </DialogDescription>
        {!user && <DonationSignInPrompt />}
        {!donorDetails && <DonationDetailsFields idPrefix="stripe-donor" value={details} onChange={changeDetails} />}
        {error && <p role="alert" className="text-sm text-red-700">{error}</p>}
        <Button variant={user ? "default" : "link"} disabled={isProcessing} onClick={checkout}>
          {isProcessing ? 'Opening Stripe…' : user ? 'Continue to secure checkout' : 'Continue as guest without credits'}
        </Button>
      </DialogContent>
    </Dialog>
  );
}
