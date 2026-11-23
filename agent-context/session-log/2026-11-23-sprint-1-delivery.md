# Sprint 1: deliver #27, #41 and #47 to dev staging

- Timestamp: 2026-11-23, America/Toronto.
- Agent: codex:01a1b2bd-ec7d-76c2-98d3-0851cfd83848, UbiFinder HBIC; sole integration writer.
- Scope: Noak explicitly approved publication, review/CI, protected dev merge and staging verification. Production must remain unchanged.
- Ledger: sprint proposals S37–S41 retain the ranked roadmap and acceptance/dependencies/decisions. S37 records direct approval; M744 asks Hubert to record acceptance through his supported role. Delivery task T883. Other sprint proposals are inactive.
- Repository/worktree: ubi-labs/ubi-finder; /Users/botmaster/src/scratch/ubi-finder-sprint-1-staging, codex/sprint-1-staging.
- Base/pre-commit head: base0fd345a04b71ebb5cb21057de838b461f5c2eb67; assembled sourcecf8a364. Original #27/#41/#47 branches and unrelated dirty canonical files retained.
- Source assembly: preserved separate #27 implementation/repair commits, #41 profile fix and #47 lowercase routing commit. The only content conflict was Vitest's adjacent coverage includes; retained supporterPoints, pendingProfile and route helpers plus the100% supporter-points ratchet and unchanged global thresholds. An initial cherry-pick in the canonical #27 checkout was aborted immediately; HEAD and pre-existing dirty state were verified unchanged before proceeding in the isolated worktree.
- Preview guard: disabled automatic Vercel Git deployment for this exact integration branch. Staging remains the explicit dev CI deployment; no unverified feature-preview backend is invoked.
- Local validation: reproducible npm ci; lint, typecheck,226 unit tests/coverage and build pass on the combined source. Existing large-chunk warning remains. Prior #41 clean42-migration reset/SQL lint/21 pgTAP and browser evidence is preserved; combined database/browser validation will run in PR CI before merge.
- Live preflight: dev protected at0fd345a, main at936cb000; merge commits allowed and squash disabled. Staging targets vyfhercljsvhyfqfvuys, distinct from productionoinubdnkqnifeaaejmjl; three required Staging secret names present. No credential values printed or stored in the repository.
- Pending: independent source risk/acceptance review, final-head PR checks and automatic Codex review, authorized non-squash merge to dev, exact merge-SHA staging delivery and hosted redirect/profile checks. Do not claim On dev before deployment verification or On main in this sprint.
