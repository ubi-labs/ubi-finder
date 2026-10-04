import React, { useState } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import { Heart, ShieldCheck, Wallet } from "lucide-react";
import { useToast } from "@/components/ui/use-toast";
import { useAuth } from "@/lib/AuthContext";
import DonationDetailsFields from "@/components/DonationDetailsFields";
import DonationSignInPrompt from "@/components/DonationSignInPrompt";
import { submitCryptoDonation } from "@/lib/stripe";
import { validateDonorDetails } from "../../supabase/functions/_shared/donor-details.js";
import confetti from "canvas-confetti";
import { Dialog, DialogContent, DialogTitle, DialogDescription } from "@/components/ui/dialog";
import StripeCheckoutModal from "@/components/StripeCheckoutModal";
import { amountToCents, supporterTier } from "../../supabase/functions/_shared/payment-policy.js";

export default function SupportWidget() {
  const { toast } = useToast();
  const [amount, setAmount] = useState("100");
  const [customAmount, setCustomAmount] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isCryptoOpen, setIsCryptoOpen] = useState(false);
  const [cryptoError, setCryptoError] = useState("");
  const { user, isLoadingAuth } = useAuth();
  const [donorDetails, setDonorDetails] = useState({ donor_name: "", public_recognition: false });
  const [cryptoChain, setCryptoChain] = useState("ethereum");
  const [transactionReference, setTransactionReference] = useState("");
  const [checkoutAmount, setCheckoutAmount] = useState(100);
  const selectedAmount = customAmount || amount;

  const handleOpenDonate = async (event, crypto = false) => {
    event.preventDefault();
    setIsSubmitting(true);
    try {
      const cents = amountToCents(selectedAmount);
      validateDonorDetails(donorDetails.donor_name, donorDetails.public_recognition);
      setCheckoutAmount(cents / 100);
      if (crypto) { setCryptoError(""); setIsCryptoOpen(true); }
      else setIsModalOpen(true);
    } catch (error) {
      toast({ title: "Unable to start donation", description: error.message, variant: "destructive" });
    } finally {
      setIsSubmitting(false);
    }
  };

  const confirmCrypto = async () => {
    setIsSubmitting(true);
    setCryptoError("");
    try {
      await submitCryptoDonation({ amountUsd: checkoutAmount, donorDetails, chain: cryptoChain, transactionReference });
      setIsCryptoOpen(false);
      toast({ title: "Thank you for your support!", description: "Transaction saved. We’ll manually confirm it within a week and give credit to the account you signed in with before donating. Guest donations receive no credits." });
      confetti({ particleCount: 120, spread: 90, origin: { y: 0.6 }, disableForReducedMotion: true });
    } catch (error) {
      setCryptoError(error.message);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <>
      <Card className="w-full max-w-lg mx-auto shadow-2xl border-green-200/90 bg-white/95 backdrop-blur-md overflow-hidden relative">
        <div className="absolute -top-12 -right-12 w-36 h-36 bg-green-100/60 rounded-full blur-2xl pointer-events-none" />
        <div className="absolute -bottom-12 -left-12 w-36 h-36 bg-pink-100/60 rounded-full blur-2xl pointer-events-none" />

        <CardHeader className="text-center pb-4 pt-6">
          <div className="flex items-center justify-center mb-3">
            <div className="rounded-full bg-gradient-to-br from-red-100 via-pink-100 to-rose-100 p-3 shadow-inner border border-red-200 animate-pulse">
              <Heart className="h-7 w-7 text-red-600 fill-red-500" />
            </div>
          </div>
          <CardTitle className="text-2xl sm:text-3xl font-extrabold text-green-950 tracking-tight">
            Support This Project
          </CardTitle>
          <CardDescription className="text-sm text-gray-600 max-w-md mx-auto mt-1 leading-relaxed">
            UBI Finder is a public-benefit initiative. Your support helps us research, maintain, and expand access to verified guaranteed income & cash pilots globally.
          </CardDescription>
        </CardHeader>

        <CardContent className="space-y-5 px-6 sm:px-8">
          {!isLoadingAuth && !user && <DonationSignInPrompt />}
          <form onSubmit={(event) => handleOpenDonate(event)} className="space-y-4">
            
            {/* Preset Amount Grid */}
            <div className="space-y-2">
              <Label className="text-xs font-semibold uppercase tracking-wider text-gray-700">
                Select an Amount (USD)
              </Label>
              <RadioGroup
                value={customAmount ? "" : amount}
                onValueChange={(val) => {
                  setAmount(val);
                  setCustomAmount("");
                }}
                className="grid grid-cols-2 sm:grid-cols-4 gap-2.5"
              >
                {["20", "100", "500", "1000"].map((preset) => {
                  const isChecked = !customAmount && amount === preset;
                  return (
                    <Label
                      key={preset}
                      htmlFor={`amount-${preset}`}
                      className={`flex flex-col items-center justify-center py-3.5 px-2 rounded-xl border-2 cursor-pointer transition-all duration-200 text-center ${
                        isChecked
                          ? "border-green-700 bg-green-50/90 text-green-950 shadow-sm font-bold scale-[1.02]"
                          : "border-gray-200 bg-white/70 hover:border-green-300 hover:bg-green-50/30 text-gray-700"
                      }`}
                    >
                      <RadioGroupItem value={preset} id={`amount-${preset}`} className="sr-only" />
                      <span className="text-lg font-bold">${preset}</span>
                      <span className="text-[10px] text-gray-500 font-normal mt-0.5">
                        {supporterTier(Number(preset) * 100)}
                      </span>
                    </Label>
                  );
                })}
              </RadioGroup>
            </div>

            {/* Custom Amount Input */}
            <div className="space-y-1.5">
              <Label htmlFor="custom-amount" className="text-xs font-semibold text-gray-700">
                Or enter a custom amount
              </Label>
              <div className="relative">
                <span className="absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-500 font-bold">$</span>
                <Input
                  id="custom-amount"
                  type="number"
                  min="1"
                  step="any"
                  placeholder="e.g. 50"
                  value={customAmount}
                  onChange={(e) => {
                    setCustomAmount(e.target.value);
                  }}
                  className="pl-8 bg-white/80 border-gray-200 focus:border-green-600 focus:ring-green-600 font-medium"
                />
              </div>
            </div>

            <DonationDetailsFields value={donorDetails} onChange={setDonorDetails} idPrefix="homepage-donor" />

            <p className="text-xs text-gray-600">Pay securely through Stripe. Enter your email and payment details at Checkout.</p>

            <Button
              type="submit"
              disabled={isSubmitting || isLoadingAuth}
              size="lg"
              className="w-full bg-gradient-to-r from-emerald-600 via-green-700 to-teal-700 hover:from-emerald-700 hover:to-teal-800 text-white font-bold py-6 text-base rounded-xl shadow-lg hover:shadow-xl transition-all duration-200 transform hover:-translate-y-0.5 mt-2 flex items-center justify-center gap-2"
            >
              <Heart className="w-5 h-5 fill-white text-white" />
              {isSubmitting ? "Preparing checkout…" : `Donate $${selectedAmount} USD via Stripe`}
            </Button>
            <button type="button" disabled={isSubmitting || isLoadingAuth} onClick={(event) => handleOpenDonate(event, true)} className="block mx-auto text-xs text-gray-600 underline underline-offset-2 hover:text-purple-700 disabled:opacity-50">Donate crypto instead</button>
          </form>
        </CardContent>

        <CardFooter className="bg-gray-50/80 border-t border-gray-100 px-6 py-3.5 flex items-center justify-center gap-4 text-xs text-gray-500">
          <span className="flex items-center gap-1">
            <ShieldCheck className="w-4 h-4 text-green-700" /> Secure Stripe Checkout
          </span>
          <span>•</span>
          <span className="flex items-center gap-1">
            <Wallet className="w-4 h-4 text-purple-700" /> Supporter status after confirmation
          </span>
        </CardFooter>
      </Card>

      <Dialog open={isCryptoOpen} onOpenChange={(open) => { if (!isSubmitting) setIsCryptoOpen(open); }}>
        <DialogContent className="sm:max-w-md max-h-[90vh] overflow-y-auto">
          <DialogTitle>Donate crypto instead</DialogTitle>
          <DialogDescription>Send ETH, USDC, or G$ to <strong>ubifinder.eth</strong> (Ethereum / EVM / Celo). Your selected contribution is ${checkoutAmount.toFixed(2)} USD.</DialogDescription>
          <p className="text-sm text-gray-600">This uses the honor system. Submit only after sending your transfer. We’ll manually confirm your transaction and give account credit within a week for signed-in donors. Self-confirmation does not grant credits immediately.</p>
          {!user && <DonationSignInPrompt />}
          <DonationDetailsFields value={donorDetails} onChange={setDonorDetails} idPrefix="crypto-donor" />
          <div className="space-y-1.5">
            <Label htmlFor="crypto-chain">Transaction network</Label>
            <select id="crypto-chain" value={cryptoChain} onChange={(e) => setCryptoChain(e.target.value)} className="w-full rounded-md border p-2"><option value="ethereum">Ethereum</option><option value="celo">Celo</option></select>
            <Label htmlFor="crypto-transaction">Transaction hash or explorer link</Label>
            <Input id="crypto-transaction" value={transactionReference} onChange={(e) => setTransactionReference(e.target.value)} maxLength={200} placeholder="0x… or your transaction explorer URL" />
          </div>
          {cryptoError && <p role="alert" className="text-sm text-red-700">{cryptoError}</p>}
          <Button disabled={isSubmitting} onClick={confirmCrypto}>{isSubmitting ? "Recording confirmation…" : "I have transferred crypto"}</Button>
          <Button variant="ghost" disabled={isSubmitting} onClick={() => setIsCryptoOpen(false)}>Cancel</Button>
        </DialogContent>
      </Dialog>
      <StripeCheckoutModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        amountUsd={checkoutAmount}
        user={user}
        donorDetails={donorDetails}
        onDonorDetailsChange={setDonorDetails}
      />
    </>
  );
}
