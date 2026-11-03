# Stripe community contributions

Issue: https://github.com/ubi-labs/ubi-finder/issues/19

The homepage “Support This Project” panel and supporter-gate dialogs use the same Stripe Checkout modal. Stripe is the default; a small crypto alternative records explicitly transaction references for manual review without granting immediate paid access. Interac/bank instructions are removed. Celebration runs only after server-confirmed Stripe completion or successful recording of a crypto self-confirmation. One-time USD contributions use Stripe-hosted Checkout. The browser never collects card details or writes verified donations. It supplies an amount, an exact allowed return origin, and a random guest capability. Signed-in ownership comes from the verified Supabase JWT, never request-body user IDs. Amounts must be $1–$10,000 with at most two decimal places.

`create-stripe-checkout` reserves a server-owned checkout, creates a Stripe session with an idempotency key, and returns its hosted URL. Misconfiguration and provider failures return errors. Ten attempts per donor per hour are allowed; this is a donor-level limit, not an IP-level abuse prevention service.

`stripe-webhook` verifies the raw-body Stripe signature and environment, retrieves the current Stripe session, and validates currency, exact amount, session ID, and checkout metadata. Fulfillment locks the checkout and supporter account and atomically records the event, donation, supporter balance, checkout status, and payment-derived usage fields. Replayed and concurrent delivery cannot increment twice. Unpaid completion waits for async success; async failure and expiry never grant access. The return page only displays server-owned status and polls pending confirmations. Query amounts and legacy localStorage balances confer no paid status.

Guest receipt/status access is attached to a 256-bit token in that browser's localStorage; only its SHA-256 hash is stored server-side. Account credits require signing in before donating; guest contributions confer no credits and cannot be claimed by signing in later. Clearing browser storage loses guest receipt access. Test and live balances are isolated. Tiers use cumulative confirmed cents: Member+ $1, Supporter $5, Champion $50, Patron $500.

## Server configuration and deployment

Deploy migration `00039_verified_stripe_donations.sql` before the three functions. The webhook must accept external calls (`verify_jwt=false`) because Stripe signs them independently. Checkout and status verify user JWTs themselves, while allowing guest capabilities.

Supabase Edge Function secrets:

- `STRIPE_SECRET_KEY`: server-only restricted `rk_test_…` for sandbox or `rk_live_…` for live (preferred); corresponding `sk_test_…`/`sk_live_…` secret keys are also accepted. The key must match `STRIPE_MODE`. Restricted keys need Checkout Sessions write/read, Payment Intents read and Charges read for session creation, webhook verification and receipts.
- `STRIPE_MODE`: `test` (default), explicitly `live` for activation.
- `STRIPE_WEBHOOK_SECRET`: endpoint-specific `whsec_…` copied from Stripe Workbench. A CLI forwarding secret is only for that local listener.
- `STRIPE_ALLOWED_ORIGINS`: comma-separated exact origins. Defaults to the two production origins. Sandbox mode additionally allows only the exact `codex/19-stripe-donations` Vercel branch preview; live mode excludes it. A configured value overrides these defaults, including an empty deny-all value. Local tests must explicitly add their localhost origin.

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

All three payment functions were deployed to the linked project using Supabase API bundling. Stripe sandbox account `acct_1UMankGlK1sz5KBH` has destination `we_1UMbbWGlK1sz5KBHhgdxgEXi` for the URL above and four events. An unsigned runtime probe returned HTTP503 because credentials were not yet configured. The CLI account cannot write project secrets; manual configuration is pending. Migration 00039 was applied directly after isolated CI reset, lint, concurrency/privilege tests and all seven browser scenarios passed. The Vercel preview deployed, but requires Vercel sign-in. End-to-end sandbox payment verification and live activation remain pending. The GitHub migration deployment workflow failed at project linking because its Supabase access token was rejected as Unauthorized; no migrations ran in that failed workflow. Direct CLI deployment used the verified linked project instead. On October 3 (Toronto), the existing Production `SUPABASE_ACCESS_TOKEN` was refreshed from the verified local CLI credential; deployment run 37159865795 attempt 2 passed linking, migrations, and all function deployments. These are deployment metadata and fail-closed runtime evidence, not proof of payment acceptance.

### Sandbox payment verification — October 4, 2026

After manual secret configuration, deployed credentials matched the verified sandbox keys and `STRIPE_MODE=test`. An unsigned webhook returned HTTP400 and a signed unsupported-event probe returned HTTP200. A real Stripe-hosted $5 USD sandbox Checkout completed successfully; its automatic webhook changed server-owned donation status from pending/zero to completed/500 cents, Supporter, with a Stripe receipt URL. Two concurrent signed replays of the actual Stripe completion event both returned HTTP200 and left the total at 500 cents. No live funds were charged. This verifies the deployed sandbox payment backend and replay behavior; it does not independently establish hosted ledger row counts or receipt-email delivery. Main still serves the previous donation frontend; the replacement and verified success page remain in PR #39, with seven CI browser scenarios passing. Live activation remains pending.

## Confidential names, recognition consent, and crypto review

Migration `00040_donor_records_and_crypto_review.sql` adds confidential names/opt-in consent to service-only Checkout records, plus transaction references and review records to `support_donations`. Names are optional (100-character limit); public recognition defaults false and requires a supplied name. No public leaderboard or name-read API exists. Stripe receives only the Checkout ID, not the confidential donor name. Owner reads of crypto records remain protected by RLS; broader browser admin reads/writes were removed. The Edge Function validates identity independently of caller user IDs and creates pending records through a service-only RPC. It rate-limits donor submissions and rejects duplicates by environment/network/hash. Both guest and authenticated clients are unable to confirm or mint credit.

Deploy migration 00040 before updated `create-stripe-checkout`, `donation-status`, and new `submit-crypto-donation`. The latter uses the existing sandbox/live mode and exact origin allowlist. Crypto entry accepts an EVM transaction hash or exact HTTPS transaction URL from Ethereum Etherscan, CeloScan, or [Celo Blockscout](https://celo.blockscout.com/), which is described in [Celo’s explorer migration announcement](https://forum.celo.org/t/deprecation-of-explorer-celo-org/9943). Links are parsed but never fetched; only canonical network/hash are saved. References are not evidence of payment. Users explicitly self-confirm after sending; the UI celebrates successful submission while explaining manual credit is pending.

### Operator procedure: seven-day review and account credit

The donor-facing promise is manual confirmation and credit within a week for donors signed in before donating. This is an operator commitment, not an automated on-chain verifier. A reviewer with authorized SQL/service access must inspect the pending queue daily and resolve records before `review_due_at`:

```sql
select id, user_id, donor_name, public_recognition, crypto_chain, transaction_hash,
       amount_usd as donor_estimate_usd, livemode, review_due_at
from public.support_donations
where review_status = 'pending_review'
order by review_due_at;
```

Independently confirm the actual network, successful/final transaction, token/amount and transfer to the project’s resolved recipient, then determine the received USD value. Before granting credit, establish that the transaction belongs to the signed-in donor (for example, wallet-signed sender ownership or authenticated exchange withdrawal evidence); public transaction hashes alone are insufficient. Do not treat the donor estimate, claimed sender, or submitted reference as verification. Confirm the row’s sandbox/live environment matches the review environment. Use the reviewer’s operator identifier and **verified** cents, for example (IDs/cents are placeholders):

```sql
select public.confirm_crypto_donation(
  p_donation_id => '00000000-0000-0000-0000-000000000000',
  p_verified_amount_cents => 1000,
  p_livemode => false,
  p_reviewer => 'authorized-reviewer-id'
);
```

The transaction locks the review row and supporter account, writes the verified ledger/audit and updates signed-in credit totals atomically. Concurrent or repeated confirmations credit only once. Guest confirmations can be recorded but never grant account credits; there is no automatic guest-to-account transfer. Reject invalid/failed claims through authorized SQL with `review_status='rejected'`, reviewer identifier and review timestamp. Do not run confirmation merely to test a production reference. Reviewers must honor the seven-day queue; deployment alone is not evidence of an operator reviewing it.

### Donor-record and crypto-review deployment — October 4, 2026

Implementation e5084cf passed quality CI and isolated run 37236222792: clean reset/seed, error-level SQL lint, atomic/privacy/manual-review regressions and all 15 browser scenarios. Migration 00040 was applied to the verified linked project `oinubdnkqnifeaaejmjl`, and hosted SQL lint passed. Updated `create-stripe-checkout` and `donation-status`, and new `submit-crypto-donation`, were deployed through API bundling. Hosted introspection confirmed migration/consent columns/review function and denied review execution to guest/authenticated roles while allowing service operators. A synthetic sandbox crypto submission persisted name/consent/canonical hash with a seven-day pending deadline, granted no credit and rejected replay with HTTP409; its row and empty supporter account were removed. No crypto was transferred or credited. The prior completed guest Stripe payment retains its receipt but now returns zero account credits, superseding the earlier browser-guest supporter behavior. Frontend preview deployed; main publication, privileged preview-origin configuration and live activation remain separate.

### Exact sandbox preview allowlist

The current account cannot edit Supabase secrets, but authorized function deployments can configure their own exact sandbox origin defaults. The verified branch preview `https://v0-ubi-finder-git-codex-19-stripe-donations-cubid-team.vercel.app` is allowed only by the test-mode default. No Vercel wildcard, arbitrary preview or live-mode preview allowance was added. `STRIPE_ALLOWED_ORIGINS`, when explicitly set, remains authoritative and overrides all defaults. This replaces the earlier manual-origin prerequisite for the current sandbox preview; live activation still requires the correct account/credentials and separate authorization.
