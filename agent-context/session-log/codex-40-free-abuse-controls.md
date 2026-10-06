# Completed implementation evidence

Timestamp: 2026-10-06T04:55:46.800017+00:00
Agent: Codex
Branch: codex/40-free-abuse-controls
Pre-commit HEAD: 747662fc7e4325708a7b0591415d9eccd87a8a73
Issue: https://github.com/ubi-labs/ubi-finder/issues/40

Implemented free Turnstile integration for login/signup/reset and onboarding, server-owned signup and program quotas, bounded public summaries, verified detail access, management-only raw program reads, atomic submission IDs, keyed signup associations and minute cleanup of one-day counters. No Redis, paid log export/retention, premium bot protection, account deletion, or hosted changes.

Validation: npm lint/typecheck/test:coverage/build passed; 115 unit tests and 19 Deno tests passed; coverage 98.82% statements and 91.13% branches. Build retains the existing large-bundle warning. Local database reset/lint/acceptance were not run because the Local Supabase Coordinator queued the request while canonical runtime was unavailable. Added isolated CI reset, pgTAP privilege/hook/retention tests, concurrent quota integration tests, endpoint serving and browser acceptance. No hosted validation is claimed.

Deployment requirements and remaining work are tracked in GitHub issue #40 and the pull request, not in this session log.

2026-10-06T04:59:24.590180+00:00 — Codex — branch codex/40-free-abuse-controls — pre-commit HEAD 74219fb — issue #40: isolated CI reset, error-level lint, 19 pgTAP checks and existing donation integration passed. Concurrent tests observed the exact 120/IP and 30/user acceptances, then a test assumed array item zero was among accepted requests. Corrected that scheduling-dependent assertion to inspect an accepted response and assert quota errors on every rejected response. Validation: node syntax check; full isolated CI rerun pending.

2026-10-06T05:04:55.988425+00:00 — Codex — branch codex/40-free-abuse-controls — pre-commit HEAD 6fecc66 — issue #40: current isolated CI passed reset/lint/19 SQL assertions, donation integration, concurrent-quota integration and endpoint serving; 15 browser tests passed. New verified-detail test expected the wrong default login destination (Dashboard is established behavior). Corrected it to request an explicit Programs redirect. Validation: syntax check; acceptance rerun pending. No product behavior changed.

2026-10-06T05:10:41.342721+00:00 — Codex — branch codex/40-free-abuse-controls — pre-commit HEAD 2547ba9 — issue #40: run37416781792 passed clean reset/lint/19 SQL assertions, donation/concurrent-quota integration, endpoint serving and all16 browser scenarios. Included existing commit0976514 from PR42 so a whole-function deployment cannot restore the old restricted-key rejection. No frontend source changed in this merge; its lint/typecheck/coverage/build checks remain unchanged. Combined Deno suite passed20 tests. Stopped a redundant unchanged-frontend lint rerun; exact merged-head CI will run all checks. No hosted settings or accounts changed.

2026-10-06T05:14:17.028280+00:00 — Codex — branch codex/40-free-abuse-controls — pre-commit HEAD 00565c6 — issue #40: added two database acceptance assertions proving creators and authorized managers retain program access under the new RLS policy. No source behavior changed. Existing reset/lint/19 SQL assertions/16 browser tests passed; expanded21-assertion CI rerun pending.
