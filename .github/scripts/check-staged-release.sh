#!/usr/bin/env bash
set -euo pipefail

candidate_sha=${1:?Pass the staging commit SHA}
if [[ "$(git rev-parse 'HEAD^{tree}')" != "$(git rev-parse "$candidate_sha^{tree}")" ]]; then
  echo "::error::The release tree differs from dev. Merge main into dev and validate staging again."
  exit 1
fi

deployments=$(gh api --method GET "repos/$GITHUB_REPOSITORY/deployments" \
  -f sha="$candidate_sha" -f environment=Staging)
deployment_id=$(jq -r '[.[] | select(.ref == "dev" or .ref == "refs/heads/dev")][0].id // empty' <<< "$deployments")
if [[ -z "$deployment_id" ]]; then
  echo "::error::No Staging deployment exists for $candidate_sha."
  exit 1
fi

state=$(gh api "repos/$GITHUB_REPOSITORY/deployments/$deployment_id/statuses" --jq '.[0].state')
if [[ "$state" != success ]]; then
  echo "::error::The latest Staging deployment for $candidate_sha has not succeeded."
  exit 1
fi
