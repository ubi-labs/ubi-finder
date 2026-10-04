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
- Isolated CI run 37159645289 passed clean reset/seed, error-level SQL lint, concurrent donation/replay/rollback/browser-privilege regression and all seven browser acceptance scenarios. Quality CI 37159645170 passed.
- GitHub deployment run 37159865795 failed at linking because its Supabase access token was Unauthorized; it applied no migrations. The local CLI dry run confirmed only 00039 pending, and direct `supabase db push --linked --yes` applied that exact validated migration to the linked project.
- PR #39 is draft. Commit a73796163ab65861f6ba4223a10d74835cd8aea9 is pushed. Vercel preview is deployed but protected by Vercel sign-in; no hosted UI assertion made. Main frontend is unchanged. Hosted Checkout and actual signed payment delivery are not yet demonstrated. No sandbox payment or live charge has been made.

Follow-ups:
- Completed isolated CI reset/db lint/database tests/full local acceptance. No shared Mac lease needed.
- Confirm secret configuration and allow the exact preview origin for sandbox testing; then complete and replay an actual sandbox Checkout webhook and verify ledger/tier/receipt. Publish main frontend after review.
- Refresh the existing GitHub SUPABASE_ACCESS_TOKEN through an authorized account to restore automatic migration deployment. CLI function/database access works, but secret writes remain forbidden.
- Confirm production environment/account and obtain explicit real-transaction authorization before live activation. Linked project name is UBI-Finder-dev but existing Production CI targets it.
- Refund/dispute revocation, guest account transfer and broader usage RLS (#30) remain outside this implementation.
- Commit uses authenticated GitHub account KazanderDad (verified id 98373366) and the same GitHub noreply identity as main, rather than the checkout’s generic UBI Finder Dev identity; no prior history rewritten.
- Preserve preexisting untracked `agent-context/session-log/main.md`.

## 2026-10-03T22:55:10Z — deployment evidence and pending credentials

Agent: Codex
Branch: `codex/19-stripe-donations`
Pre-commit HEAD: `a73796163ab65861f6ba4223a10d74835cd8aea9`
Issue: https://github.com/ubi-labs/ubi-finder/issues/19

Summary: Recorded green implementation CI and seven browser scenarios, direct hosted migration deployment, hosted SQL lint success, draft PR #39, and the separate CI-token/secret-write limitations. All three Edge Functions and migration 00039 are deployed. Stripe sandbox webhook destination configured; actual payment remains gated on manual Supabase Stripe secrets. Main frontend remains unchanged.
Validation: Documentation-only change; retained implementation validation above, `git diff --check` passed. No additional application test run required for evidence-only prose.
Follow-ups: Manual secrets, exact sandbox preview origin allowance, actual sandbox Checkout/replay/receipt verification, reviewed main frontend publication, restored deployment token, then separately authorized live activation/transaction.


## 2026-10-04T01:43:18Z — fix deployment CI and diagnose absent review

Agent: Codex
Branch: `codex/19-stripe-donations`
Pre-commit HEAD: `68b883b154fea0c5d913914e53b1f89cd8903088`
Issue: https://github.com/ubi-labs/ubi-finder/issues/19
PR: https://github.com/ubi-labs/ubi-finder/pull/39

Summary:
- Current PR quality/database/Vercel checks were already green. Separate deployment run 37159865795 failed at linking with Unauthorized Supabase access token.
- Validated the working Supabase CLI Keychain credential against exact linked project `oinubdnkqnifeaaejmjl`, refreshed the existing Production GitHub secret through encrypted stdin without exposing its value, and reran the failed job.
- Attempt 2 passed project linking, migrations and all Edge Function deployments. Existing database password required no change. No application/workflow code change needed.
- Read-only Codex settings inspection: personal Automatic review enabled, Review trigger On PR open. PR opened as draft and became ready at 2026-10-03T22:59:45Z. No manual review request, bot reaction or review exists. Repository connection lookup failed twice with Unable to load GitHub connections, so repository review enablement and exact auto-trigger cause remain unverified. Draft opening is a plausible explanation, not a confirmed root cause. Review preferences were not changed and no review comment sent.

Validation: Deployment attempt 2 success verified from job steps; current implementation PR checks all passed. `git diff --check` passed; documentation-only update requires no repeated application tests.
Follow-ups: Verify repository-level automatic review configuration when GitHub connections load; a single explicit `@codex review` comment can test manual triggering if requested. Continue existing sandbox payment activation after secrets are configured.
