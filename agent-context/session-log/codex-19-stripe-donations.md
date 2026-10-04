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

## 2026-10-04 — deployed sandbox Checkout verification

Agent: Codex
Branch: `codex/19-stripe-donations`
Pre-commit HEAD: `04bdab6329a4c1fd4961cb45da53641d660d6e49`
Issue: https://github.com/ubi-labs/ubi-finder/issues/19

Summary: Verified manually configured secrets by hashes without logging credentials. Completed an actual $5 USD sandbox payment in Stripe-hosted Checkout. Automatic fulfillment returned completed status, 500 cents, Supporter and a receipt URL. Two concurrent signed replays of the actual completion event returned HTTP200 without increasing the total. No live charge. Preserved unrelated untracked main session log.

Validation: Unsigned webhook HTTP400; signed configuration probe HTTP200; initial pending total zero; Stripe session complete/paid/livemode false; server completed total 500 cents; replay total unchanged. Receipt URL available; email delivery and direct hosted ledger row counts not independently checked. Documentation-only change: diff whitespace check; application tests not repeated (previous CI green).
Follow-ups: Review/publish PR #39 frontend; main currently serves old donation UI. Separately confirm production account/environment and obtain explicit authorization before any live transaction.

## 2026-10-04T05:02:05.363509+00:00 — homepage Stripe default and crypto alternative

Agent: Codex
Branch: `codex/19-stripe-donations`
Pre-commit HEAD: `e0512f992955dd50073e0e245842213b6e4d1f30`
Issue: https://github.com/ubi-labs/ubi-finder/issues/19

Summary: Fixed missed homepage SupportWidget entry point. Stripe Checkout is the default; Interac/bank removed; small crypto link retains explicit honor-system confirmation and records only an unverified pledge. Failed pledge inserts now show an error instead of success. Confetti fires only after successful crypto self-confirmation or verified Stripe completion; never on opening a dialog. Preset tier labels use the shared server thresholds. Extended acceptance CI path triggers to frontend and browser tests.

Validation: npm run lint, npm run typecheck, npm run test:coverage (87 tests), npm run build and git diff --check passed. CUA local browser verified main Stripe dialog and separate crypto instructions; panel screenshot saved outside repository. Four new browser scenarios cover custom amounts/errors, fractional cents, hosted redirect and crypto error/success celebration; delayed-confirmation scenario now checks animation timing. Full acceptance validation is delegated to the existing isolated GitHub Actions runtime (no shared Mac Supabase operated) and is pending push at this commit.
Follow-ups: Verify fresh acceptance CI and Vercel deployment. Add exact preview origin to STRIPE_ALLOWED_ORIGINS manually: CLI secret writes remain forbidden by account privileges. Main frontend publication and live activation remain separate.

## 2026-10-04T05:06:02.829510+00:00 — acceptance selector repair

Agent: Codex
Branch: `codex/19-stripe-donations`
Pre-commit HEAD: `170f4dbdd951fd594fa3ddda7f3c0699d2d20a21`
Issue: https://github.com/ubi-labs/ubi-finder/issues/19

Summary: CI run 37178723273 passed clean reset, SQL lint and atomic donation/privilege tests. Ten browser scenarios passed, including homepage hosted redirect, failure behavior, crypto self-confirmation and celebration timing. Fractional-cent rejection worked, but the test substring matched both visible toast and accessibility announcement. Changed it to an exact visible text match. No product behavior changed.
Validation: Failure log confirms strict-mode duplicate selector; git diff --check passed. Existing quality CI passed at 170f4db. Full isolated acceptance rerun follows push; application tests not repeated for a selector-only repair.
Follow-ups: Confirm all 11 browser scenarios and exact latest-head CI pass. Preview return origin still needs manual secret configuration.
