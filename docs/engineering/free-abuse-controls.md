# Free abuse controls (#40)

This implementation is a deployment candidate for `dev` staging first. Hosted activation requires the migration, the program-catalog function, the frontend, and Auth settings below. No Redis, premium bot service, paid log drain, or extended log retention is introduced.

Do not merge the feature branch to `dev` until the staging Turnstile site key and native Supabase CAPTCHA secret are installed and the Before User Created hook is ready for coordinated validation. The current Preview (`dev`) environment has only the Supabase URL and anon key, so an automatic staging deployment would otherwise ship a blocked authentication UI. Local and CI bypasses are restricted to the isolated local runtime and are not a hosted activation substitute.

## Account creation

Cloudflare Turnstile is required by production authentication UI. Provide the public `VITE_TURNSTILE_SITE_KEY` in Vercel and the secret in Supabase Auth's native CAPTCHA settings. The frontend passes each token to signup, password/magic-link login, onboarding signup, and password reset, resetting after an attempt. Native Auth verification is essential: a UI widget alone cannot stop direct Auth API calls. Missing site keys block production UI submission; local-supabase Vite development intentionally omits CAPTCHA for isolated acceptance tests.

Configure Before User Created to `pg-functions://postgres/public/before_user_created_abuse_check`. Auth supplies the IP; the function limits account creation to 5/hour and 10/day per IPv4 address or IPv6 /64 network. Unknown IPs fail closed. It does not reject unusual names or modify existing accounts. Keep email confirmation enabled. Quotas use fixed windows, so boundary bursts are possible; native Auth throttles and CAPTCHA remain necessary. Verify operator-created and OAuth accounts with the hook before activating it; an operator path missing IP may require a separately authenticated provisioning route.

## Program reads

Public and verified users receive at most 20 summaries per request through `program-catalog`, using ascending program-ID cursors. Summaries expose explicit discovery/matching fields and a 300-character description; no contact email, original sources, application URLs, or full description. The current catalog and matching UI collect summary pages, sharing a short in-memory cache. Public summaries remain intentionally readable; this control restricts full-data extraction, not discovery information.

Full details require a server-verified, confirmed account. Each detail request, including revisits, passes through the quota RPC. Limits:

- All catalog requests: 600/minute globally; 120/minute/IP; 60/minute/account.
- Detail requests: 60/minute/IP and 30/minute/account.
- Unique detailed programs: 150/IP and 100/account during the preceding 24 hours. Revisiting a program counts against the minute limit but does not refresh its unique-read retention.

Atomic counters and transaction advisory locks enforce quotas across function instances. `read_program_catalog` is callable only by service_role; identity comes from `auth.getUser`, not client input, and is checked again in SQL. Direct anonymous program-table SELECT is revoked. Authenticated raw reads are restricted by RLS to admins, creators, and authorized managers. Inserts/updates retain their existing authorization. Program submission IDs are allocated atomically on the server rather than by enumerating the table.

The endpoint uses the Supabase Cloudflare gateway's overwritten `cf-connecting-ip`, ignoring client `X-Forwarded-For`. IP parsing/canonicalization occurs in Postgres; IPv6 addresses share a /64 bucket to reduce address-rotation bypasses. Missing gateway IP fails closed. **Before hosted cutover, verify the real gateway supplies and overwrites that header, including a forged-header test.** Do not enable browser-supplied header trust as a workaround. `ABUSE_LOCAL_DEVELOPMENT=true` is a server-only setting for isolated local/CI runtime, accepted only with a loopback/Kong HTTP Supabase URL, and must never be set on hosted functions.

## Retention and monitoring

Only counters, unique-read identifiers, and successful signup associations (user UUID, keyed IP, timestamp) are stored; IPs are keyed HMAC identifiers using a private database pepper. No raw IP event log or third-party lookup is added. Expired counters, signup associations, and detail identifiers are purged every minute by pg_cron; retention is at most 24 hours plus the cleanup interval. Private tables have RLS, no client policies/grants, and do not belong to the exposed API schema. Native platform logs remain governed by the existing plan; no paid retention or log export is configured. Review the existing one-day dashboard window and quota responses. Operators can inspect recent signup concentration without collecting raw IPs:

```sql
SELECT ip_key, count(*) AS signups, min(created_at), max(created_at)
FROM abuse_private.signup_events
WHERE created_at > now() - interval '1 day'
GROUP BY ip_key ORDER BY signups DESC;
```

The private tables require operator database access; no public analytics endpoint is exposed. Scheduled alert delivery is not introduced.

## Rollout and rollback

1. Create the free Turnstile widget for the staging and production hostnames. Install the staging public key in Vercel Preview variables for `dev`, the staging secret in native Supabase CAPTCHA settings, and prepare the Before User Created hook. Keep the feature-branch automatic Vercel Git preview disabled; the repository deployment workflow owns the reviewed staging release.
2. Pass clean reset, error-level database lint, the complete SQL suite, concurrent-quota integration, combined Edge tests, and local browser acceptance at the reconciled commit. These checks do not establish hosted activation.
3. Only after the staging configuration is ready, merge the reviewed feature PR to `dev`. The `dev` workflow applies migration `00043`, deploys `program-catalog`, and publishes the frontend against the separate staging backend. Do not add a hosted development bypass or preserve unrestricted raw reads as a compatibility fallback.
4. On staging, verify public summaries, guest detail denial, verified details, management/submission, name preservation, lowercase routing, quotas, and a forged gateway-header request. Confirm the real gateway overwrites `cf-connecting-ip`, native CAPTCHA rejects direct tokenless Auth signup, and legitimate signup/reset/sign-in flows work before activating the signup hook.
5. Hold the `dev`-to-`main` promotion until staging evidence is complete and separately reviewed. Production activation repeats the public key, native CAPTCHA secret, gateway-header, and Before User Created hook checks for the production projects; local, CI, and staging results do not prove production activation.
6. Roll back a faulty frontend/function to the previous *controlled* version. If reverting the migration is necessary, restoring public reads reopens extraction; treat that as an explicit operational decision. Deactivate the signup hook or native CAPTCHA only as a coordinated rollback, and do not mass-delete suspicious accounts.

Validation commands: `npm run lint`, `npm run typecheck`, `npm run test:coverage`, `npm run build`, `supabase db reset`, `supabase db lint --local --level error`, `supabase test db`, `node tests/integration/abuse-controls.mjs`, `npm run test:acceptance:local`, and the Deno tests under `supabase/functions/tests/`.
