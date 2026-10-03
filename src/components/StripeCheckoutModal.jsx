import React, { useState } from 'react';
import { Dialog, DialogContent, DialogTitle, DialogDescription } from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import { initiateStripeCheckout } from '@/lib/stripe';

export default function StripeCheckoutModal({ isOpen, onClose, amountUsd = 5, user = null }) {
  const [isProcessing, setIsProcessing] = useState(false);
  const [error, setError] = useState('');
  const checkout = async () => {
    setIsProcessing(true); setError('');
    try { await initiateStripeCheckout({ amountUsd, user }); }
    catch (e) { setError(e.message); setIsProcessing(false); }
  };
  return (
    <Dialog open={isOpen} onOpenChange={() => { if (!isProcessing) { setError(''); onClose(); } }}>
      <DialogContent className="sm:max-w-md rounded-2xl">
        <DialogTitle>Support UBI Finder</DialogTitle>
        <DialogDescription>
          Contribute ${Number(amountUsd).toFixed(2)} USD. You’ll enter your payment details securely on Stripe.
        </DialogDescription>
        <p className="text-sm text-gray-600">Supporter access activates after your payment is confirmed.</p>
        {!user && <p className="text-sm text-gray-600">Guest supporter access stays with this browser. Sign in first to keep contributions with your account.</p>}
        {error && <p role="alert" className="text-sm text-red-700">{error}</p>}
        <Button disabled={isProcessing} onClick={checkout}>
          {isProcessing ? 'Opening Stripe…' : 'Continue to secure checkout'}
        </Button>
      </DialogContent>
    </Dialog>
  );
}
