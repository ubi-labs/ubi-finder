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

## 2026-11-08 — Verify project mapping and permissions

- **Agent and branch:** Codex, `codex/staging-production-pipeline`.
- **Pre-commit head:** `534d830`.
- **Issue:** User-requested Supabase production rename and staging provisioning. No linked issue.
- **Summary:** Confirmed the live frontend still uses project `oinubdnkqnifeaaejmjl` in the Free plan UBI-Finder Org in Canada Central. Supabase returned HTTP 403 for both the display-name rename and the separate staging project creation. Management API membership confirms the active account is a Developer. Both project changes need an organization Owner or Administrator.
- **Validation:** Read back the unchanged Supabase inventory and verified the live frontend returned HTTP 200. In GitHub, set the Production environment backend reference and the verified Vercel team and project identifiers for both environments. Read back the variable names. GitHub still defaults to main and Staging remains restricted to dev.
- **Follow-ups:** After the Supabase permission handoff, verify the production rename preserves the project reference. Configure the new staging ref and scoped CI credentials, then deploy and validate staging before the branch cutover.

## 2026-11-08 — Prepare staging branch and CI review

- **Agent and branch:** Codex, `codex/staging-production-pipeline`.
- **Pre-commit head:** Local pipeline rebased onto the guarded `dev` bootstrap commit `650edb0`.
- **Issue:** User-requested staging verification. No linked issue.
- **Summary:** Verified both Canada Central project identities and the production frontend reference. Set GitHub's Staging target to `vyfhercljsvhyfqfvuys`. Vercel requires an existing Git branch before accepting a branch-specific Preview variable. The initial dev commit disables automatic deployment so the new branch cannot build with shared production settings. This PR branch also disables its automatic Preview build.
- **Validation:** Read back Supabase status and GitHub environment scope. Verified the live site responds HTTP 200 with the production reference. Checked the workflow with actionlint.
- **Follow-ups:** Install dev-specific Vercel settings and staging CI secrets, merge the reviewed pipeline into dev, and validate the resulting deployment before changing the default.

## 2026-11-08 — Rehearse the hosted staging deployment

- **Agent and branch:** Codex, `codex/staging-production-pipeline`.
- **Pre-commit head:** `b4453ec8e902261b7da520a2487d5b3bb9b51e2e`.
- **Issue:** User-requested staging verification. PR #44.
- **Summary:** Created the guarded dev branch and verified its Vercel Preview settings. Deployed the baseline frontend and five Edge Functions to staging, and applied migrations 00001–00040. Staging's public catalog returned PostgreSQL 42501 because fresh projects require explicit Data API grants. Added migration 00041 to declare grants for existing client and service calls while preserving row-level policies.
- **Validation:** Applied only migration 00041 to staging after confirming its exact dry-run plan. Anonymous catalog, blog, and program group reads passed. The deployed Vercel preview served the homepage and /Programs and its JavaScript points to the staging backend. Local lint, typecheck, 98 unit tests, and build passed. Added an anonymous catalog assertion to the integration suite and preserved its private donation check for both legacy and explicit grants. Clean-reset and lint CI for this commit are pending.
- **Follow-ups:** Verify the reviewed PR and the automatic dev deployment before changing the GitHub default. PR #43 uses migration number 00041 in its draft and needs a distinct version when updated against dev.
