# Stripe community contributions

Issue: https://github.com/ubi-labs/ubi-finder/issues/19

One-time USD contributions use Stripe-hosted Checkout. The browser never collects card details or writes donations. It supplies an amount, an exact allowed return origin, and a random guest capability. Signed-in ownership comes from the verified Supabase JWT, never request-body user IDs. Amounts must be $1–$10,000 with at most two decimal places.

`create-stripe-checkout` reserves a server-owned checkout, creates a Stripe session with an idempotency key, and returns its hosted URL. Misconfiguration and provider failures return errors. Ten attempts per donor per hour are allowed; this is a donor-level limit, not an IP-level abuse prevention service.

`stripe-webhook` verifies the raw-body Stripe signature and environment, retrieves the current Stripe session, and validates currency, exact amount, session ID, and checkout metadata. Fulfillment locks the checkout and supporter account and atomically records the event, donation, supporter balance, checkout status, and payment-derived usage fields. Replayed and concurrent delivery cannot increment twice. Unpaid completion waits for async success; async failure and expiry never grant access. The return page only displays server-owned status and polls pending confirmations. Query amounts and legacy localStorage balances confer no paid status.

Guest access is attached to a 256-bit token in that browser's localStorage; only its SHA-256 hash is stored server-side. Clearing browser storage loses guest access. Signing in switches to account ownership; guest balances are not automatically transferred. Test and live balances are isolated. Tiers use cumulative confirmed cents: Member+ $1, Supporter $5, Champion $50, Patron $500.

## Server configuration and deployment

Deploy migration `00039_verified_stripe_donations.sql` before the three functions. The webhook must accept external calls (`verify_jwt=false`) because Stripe signs them independently. Checkout and status verify user JWTs themselves, while allowing guest capabilities.

Supabase Edge Function secrets:

- `STRIPE_SECRET_KEY`: server-only `sk_test_…` for sandbox or `sk_live_…` for live.
- `STRIPE_MODE`: `test` (default), explicitly `live` for activation.
- `STRIPE_WEBHOOK_SECRET`: endpoint-specific `whsec_…` copied from Stripe Workbench. A CLI forwarding secret is only for that local listener.
- `STRIPE_ALLOWED_ORIGINS`: comma-separated exact origins. Defaults to `https://ubifinder.org,https://www.ubifinder.org`. Local tests must explicitly add their localhost origin.

Supabase provides `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`, and `SUPABASE_ANON_KEY` automatically. The publishable Stripe key can remain public; hosted redirect Checkout does not need it in the browser. Never expose secret keys as `VITE_` variables.

Create a webhook destination in the **same Stripe sandbox/account** as the API key:

`https://oinubdnkqnifeaaejmjl.supabase.co/functions/v1/stripe-webhook`

Subscribe to `checkout.session.completed`, `checkout.session.async_payment_succeeded`, `checkout.session.async_payment_failed`, and `checkout.session.expired`. Copy that destination's signing secret into Supabase. Enable Stripe's successful-payment email receipts in the Dashboard; known account email is also passed as `receipt_email`. The success page offers Stripe's charge receipt URL when available and suppresses untrusted URLs. Guest email is collected by hosted Checkout. Do not call a contribution tax-deductible without separate organizational/legal confirmation.

The linked Supabase project is named `UBI-Finder-dev`, while the existing repository production migration workflow targets it. Verify that environment boundary before live activation. Production requires the correct live Stripe account, a separate live webhook destination/signing secret, explicit `STRIPE_MODE=live`, deployed frontend/functions/migration, and an explicitly authorized real transaction. Sandbox evidence cannot establish a live payment works.

## Validation

- Unit coverage: exact amounts, tier boundaries, hostile return origins, stale browser balances, owner-scoped verification, unsafe redirects, provider failures.
- `deno test --node-modules-dir=none --no-lock --allow-env supabase/functions/tests/payments_test.ts`: real HMAC signature verification, Stripe session matching, async success/failure, expiry, unavailable configuration/database, guest ownership.
- With an exclusive coordinator-granted local runtime: clean reset, `supabase db lint --local --level error`, then `node tests/integration/stripe-donations.mjs` using allocated local environment variables. The script refuses hosted URLs and tests concurrent delivery, replay, transactional rollback, cumulative totals, and browser privileges.
- `npm run test:acceptance:local`: includes forged amount URLs, cancellation, failed payment, delayed confirmation, repeated visits and receipt URL handling.
- After hosted deployment: complete a real **sandbox** Checkout, verify a delivered webhook, exactly one verified donation and its supporter total/receipt, then resend the webhook and confirm no increment.

## Remaining boundaries

Refunds/disputes do not automatically revoke supporter balances in this implementation. Existing pre-verification donation records remain unverified and confer no new paid access. General usage-point RLS hardening belongs to #30; protected payment fields and the new payment tables reject browser writes. Automatic guest-to-account transfers, recurring billing, global/IP rate limiting, and donation tax receipts are separate work.

## Deployment evidence (2026-10-03)

All three payment functions were deployed to the linked project using Supabase API bundling. Stripe sandbox account `acct_1UMankGlK1sz5KBH` has destination `we_1UMbbWGlK1sz5KBHhgdxgEXi` for the URL above and four events. An unsigned runtime probe returned HTTP503 because credentials were not yet configured. The CLI account cannot write project secrets; manual configuration is pending. Migration 00039 was applied directly after isolated CI reset, lint, concurrency/privilege tests and all seven browser scenarios passed. The Vercel preview deployed, but requires Vercel sign-in. End-to-end sandbox payment verification and live activation remain pending. The GitHub migration deployment workflow failed at project linking because its Supabase access token was rejected as Unauthorized; no migrations ran in that failed workflow. Direct CLI deployment used the verified linked project instead. These are deployment metadata and fail-closed runtime evidence, not proof of payment acceptance.
