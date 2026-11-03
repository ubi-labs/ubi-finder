import { useEffect, useRef, useState } from 'react';
import { localCaptchaDevelopment } from '@/lib/captcha';
let loader;
function loadTurnstile() {
  if (window.turnstile) return Promise.resolve();
  if (!loader) loader = new Promise((resolve, reject) => {
    const script = document.createElement('script');
    script.src = 'https://challenges.cloudflare.com/turnstile/v0/api.js?render=explicit';
    script.async = true;
    script.onload = () => resolve();
    script.onerror = () => { loader = null; script.remove(); reject(new Error('Verification could not load.')); };
    document.head.appendChild(script);
  });
  return loader;
}
export default function TurnstileChallenge({ onToken, attempt = 0 }) {
  const target = useRef(null);
  const callback = useRef(onToken);
  callback.current = onToken;
  const [failed, setFailed] = useState(false);
  const [retry, setRetry] = useState(0);
  const sitekey = import.meta.env.VITE_TURNSTILE_SITE_KEY;
  useEffect(() => {
    callback.current('');
    setFailed(false);
    if (localCaptchaDevelopment || !sitekey) return;
    let cancelled = false;
    let widget;
    const timeout = setTimeout(() => { if (!cancelled) setFailed(true); }, 15000);
    loadTurnstile().then(() => {
      if (cancelled || !target.current) return;
      clearTimeout(timeout);
      widget = window.turnstile.render(target.current, {
        sitekey,
        callback: token => { setFailed(false); callback.current(token); },
        'expired-callback': () => callback.current(''),
        'error-callback': () => { callback.current(''); setFailed(true); },
      });
    }).catch(() => { if (!cancelled) setFailed(true); });
    return () => { cancelled = true; clearTimeout(timeout); if (widget && window.turnstile) window.turnstile.remove(widget); };
  }, [sitekey, attempt, retry]);
  if (localCaptchaDevelopment) return null;
  if (!sitekey) return <p role="alert" className="text-sm text-red-700">Security verification is temporarily unavailable. Please try again later.</p>;
  return <div>
    <div ref={target} aria-label="Security verification" />
    {failed && <p role="alert" className="text-sm text-red-700">Verification could not load. <button type="button" className="underline" onClick={() => setRetry(n => n + 1)}>Retry verification</button></p>}
  </div>;
}
