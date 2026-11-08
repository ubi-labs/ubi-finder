# Staging and production pipeline

## 2026-11-08 — Prepare release workflow

- **Agent and branch:** Codex, `codex/staging-production-pipeline`.
- **Pre-commit head:** `936cb000b12d50acf8bf66b04777afc224771ed5`.
- **Issue:** User-requested branch and CI/CD cutover. No linked issue.
- **Summary:** Drafted isolated staging delivery from `dev` and production promotion from `main`. The production check ties the merge tree to a successful Staging deployment, validates frontend and backend targeting, and delays Vercel domain assignment until backend delivery succeeds. Current live main includes PR #42 and is two commits ahead of `main-new`. Keep the live baseline during bootstrap.
- **Validation:** Actionlint, ShellCheck, six mocked release-gate cases, git diff checks, application lint and typecheck, 98 unit tests with coverage, build, and 16 Deno payment tests passed. The build used placeholder public Supabase settings and emitted its existing bundle-size warning. Hosted workflow and staging acceptance are pending.
- **Follow-ups:** Resolve the staging backend selection and configure branch-scoped environments. Verify staging end to end before changing the default branch or promoting to production. Keep the separate PR #43 cutover out of the bootstrap.

## 2026-11-08 — Reserve the staging environment

- **Agent and branch:** Codex, `codex/staging-production-pipeline`.
- **Pre-commit head:** `c2e2c12`.
- **Issue:** User-requested branch and CI/CD cutover. No linked issue.
- **Summary:** Created the GitHub Staging environment and restricted deployments to branch `dev`. No credentials were installed and the default branch remains `main`.
- **Validation:** Read back the custom deployment branch policy and the sole `dev` branch rule.
- **Follow-ups:** Select and verify the staging Supabase project before installing credentials, publishing the pipeline, or changing the default branch.
