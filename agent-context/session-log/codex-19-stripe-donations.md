# Stripe donation pipeline — issue #19

## 2026-10-03 — implementation and sandbox Edge Function deployment

Agent: Codex
Branch: `codex/19-stripe-donations`
Pre-commit HEAD: `38b0cf4ea0628fc8f20b6109a15efc09376768aa`
Issue: https://github.com/ubi-labs/ubi-finder/issues/19 (Project status In Progress)

Summary:
- Replaced simulated card collection/success with Stripe-hosted Checkout. Validated exact amounts, return origins, server-authenticated identity and strong guest capabilities; removed browser donation writes and local paid-status authority.
- Added signed webhook and server-owned status function. Added a migration for locked, atomic event/donation/supporter updates, mode isolation, protected usage payment fields, and browser privilege revocation.
- Added amount/origin/tier/ownership/failure unit regressions, real-HMAC Edge Function tests, local database concurrency/RLS tests, and payment-return browser scenarios. CI runs the Deno suite and avoids treating shared/test function directories as deployable functions.
- Deployed `stripe-webhook` v1, hardened `create-stripe-checkout` v2, and `donation-status` v1 directly with Supabase's API bundling to `oinubdnkqnifeaaejmjl`. Webhook is ACTIVE with verify_jwt=false. Unsigned deployed probe returned configured fail-closed HTTP503, not a success.
- Verified Stripe sandbox account `acct_1UMankGlK1sz5KBH`. Created sandbox destination `we_1UMbbWGlK1sz5KBHhgdxgEXi`, subscribing to completed, async succeeded, async failed, and expired Checkout events. Saved its signing secret only in ignored `.env.local`; no credential values logged or committed.
- Secret upload was rejected by Supabase account privileges, despite successful function deployment. User is adding keys manually; requested signing secret and `STRIPE_MODE=test` too.

Validation:
- 10 Deno Edge Function tests passed; handlers typechecked by Deno test.
- `npm ci`, final `npm run lint`, `npm run typecheck`, `npm run test:coverage` and `npm run build` passed. 87 unit tests; statements 99.68%, branches 89.29%, functions 100%, lines 99.65%. Coverage includes the payment policy, checkout client and verified status client. Lint initially raced generated coverage output; generated reports are now explicitly ignored and lint rerun passed. Build retains the existing large-bundle warning.
- Exclusive local Supabase was queued because swap 24,177.4 MiB exceeded the 20 GiB cap. Withdrew that request after identifying the existing isolated Ubuntu PR validation job; coordinator confirmed withdrawal. No Mac stack operated. Migration reset/db lint, new donation database regression and full local acceptance will run in CI.
- Migration and frontend have not been deployed. Hosted Checkout and real signed delivery are not yet demonstrated. No sandbox payment or live charge has been made.

Follow-ups:
- Execute the isolated CI reset/db lint/database tests/full local acceptance. No shared Mac lease needed.
- Deploy validated migration and frontend, confirm secret configuration, then complete and replay an actual sandbox Checkout webhook and verify ledger/tier/receipt.
- Confirm production environment/account and obtain explicit real-transaction authorization before live activation. Linked project name is UBI-Finder-dev but existing Production CI targets it.
- Refund/dispute revocation, guest account transfer and broader usage RLS (#30) remain outside this implementation.
- Commit uses authenticated GitHub account KazanderDad (verified id 98373366) and the same GitHub noreply identity as main, rather than the checkout’s generic UBI Finder Dev identity; no prior history rewritten.
- Preserve preexisting untracked `agent-context/session-log/main.md`.
