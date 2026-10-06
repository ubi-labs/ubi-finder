# Completed implementation evidence

Timestamp: 2026-10-06T04:55:46.800017+00:00
Agent: Codex
Branch: codex/40-free-abuse-controls
Pre-commit HEAD: 747662fc7e4325708a7b0591415d9eccd87a8a73
Issue: https://github.com/ubi-labs/ubi-finder/issues/40

Implemented free Turnstile integration for login/signup/reset and onboarding, server-owned signup and program quotas, bounded public summaries, verified detail access, management-only raw program reads, atomic submission IDs, keyed signup associations and minute cleanup of one-day counters. No Redis, paid log export/retention, premium bot protection, account deletion, or hosted changes.

Validation: npm lint/typecheck/test:coverage/build passed; 115 unit tests and 19 Deno tests passed; coverage 98.82% statements and 91.13% branches. Build retains the existing large-bundle warning. Local database reset/lint/acceptance were not run because the Local Supabase Coordinator queued the request while canonical runtime was unavailable. Added isolated CI reset, pgTAP privilege/hook/retention tests, concurrent quota integration tests, endpoint serving and browser acceptance. No hosted validation is claimed.

Deployment requirements and remaining work are tracked in GitHub issue #40 and the pull request, not in this session log.
