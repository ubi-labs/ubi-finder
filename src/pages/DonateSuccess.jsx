import React, { useEffect, useRef, useState } from 'react';
import { useSearchParams, Link } from 'react-router-dom';
import { useAuth } from '@/lib/AuthContext';
import { loadDonationStatus } from '@/lib/donationStatus';
import confetti from 'canvas-confetti';
import { Button } from '@/components/ui/button';

export default function DonateSuccess() {
  const [params] = useSearchParams();
  const { user, isLoadingAuth } = useAuth();
  const sessionId = params.get('session_id');
  const cancelled = params.get('cancelled') === '1';
  const [result, setResult] = useState(null);
  const [error, setError] = useState('');
  const [attempt, setAttempt] = useState(0);
  useEffect(() => {
    if (cancelled || !sessionId || isLoadingAuth) return;
    let stopped = false;
    let timer;
    let polls = 0;
    setResult(null); setError('');
    const verify = async () => {
      try {
        const status = await loadDonationStatus(user, sessionId, true);
        if (stopped) return;
        setResult(status);
        if (status.payment?.status === 'pending' && ++polls < 30) timer = setTimeout(verify, 2000);
      } catch (e) { if (!stopped) setError(e.message); }
    };
    verify();
    return () => { stopped = true; clearTimeout(timer); };
  }, [sessionId, cancelled, user?.id, isLoadingAuth, attempt]);
  const completed = result?.payment?.status === 'completed';
  const celebratedSession = useRef(null);
  useEffect(() => {
    if (!completed || cancelled || celebratedSession.current === sessionId) return;
    celebratedSession.current = sessionId;
    confetti({ particleCount: 120, spread: 90, origin: { y: 0.6 }, disableForReducedMotion: true });
  }, [completed, cancelled, sessionId]);
  const failed = ['failed', 'expired'].includes(result?.payment?.status);
  let receipt = null;
  try {
    const url = new URL(result?.payment?.receipt_url);
    if (url.protocol === 'https:' && url.hostname === 'pay.stripe.com') receipt = url.href;
  } catch { /* A receipt may not be available yet. */ }
  return (
    <main className="min-h-[70vh] flex items-center justify-center p-6">
      <section className="max-w-lg w-full rounded-2xl border border-emerald-200 bg-white p-8 space-y-5">
        <h1 className="text-2xl font-bold">{completed ? 'Thank you for supporting UBI Finder!' : cancelled ? 'Checkout cancelled' : failed ? 'Payment not completed' : error || !sessionId ? 'Unable to verify payment' : 'Confirming your payment'}</h1>
        {completed ? <>
          <p>Your ${(result.payment.amount_cents / 100).toFixed(2)} USD contribution is confirmed.</p>
          {user ? <p>Supporter status: <strong>{result.tier}</strong>. Your account credits are active.</p> : <p>You donated as a guest, so no account credits were granted. Log in before your next donation to receive credits.</p>}
          {receipt && <a className="underline" href={receipt} target="_blank" rel="noopener noreferrer">View Stripe receipt</a>}
        </> : <p role={error ? 'alert' : 'status'}>{cancelled ? 'Checkout was cancelled. Supporter access has not changed.' : failed ? 'This checkout did not complete. You can start a new checkout.' : error || (!sessionId ? 'A valid checkout session is required.' : 'Waiting for Stripe confirmation. Access activates only after a verified payment.')}</p>}
        {!completed && !cancelled && sessionId && <Button variant="outline" onClick={() => setAttempt(attempt + 1)}>Check payment status again</Button>}
        <Link className="block underline" to="/Programs">Explore programs</Link>
      </section>
    </main>
  );
}
