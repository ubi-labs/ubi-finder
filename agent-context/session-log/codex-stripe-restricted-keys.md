# Restricted Stripe key compatibility

## 2026-10-06T03:37:53.639005+00:00
Agent: Codex
Branch: codex/stripe-restricted-keys
Pre-commit HEAD:747662fc7e4325708a7b0591415d9eccd87a8a73
Issue:https://github.com/ubi-labs/ubi-finder/issues/19
Summary: Reproduced hosted HTTP503 environment mismatch; live mode configured but user confirmed rk_live key. Accept restricted/standard secret keys only in matching mode; reject publishable/mismatched keys. Document API scope.
Validation: lint/typecheck/98unit coverage/build and16Deno tests passed. Initial Deno invocation lacked dependency resolution; reran with nodeModulesDir none and alltests passed. No real transaction performed.
Completed database audit before deployment:335/339 names match16–24 alphabetic pattern, all335 match Auth full_name/display_name;274 unconfirmed,61signedin. August–October chronology predates Stripe work. Current/original signup copies input; live trigger copiesmetadata on every Auth update. No hosted user writes. Evidence and futurework recorded in GitHub40(signup investigation) and41(nameoverwrite), both added toProject.
