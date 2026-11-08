# Supabase Environments

The root `supabase/` directory is the only migration, seed, function, and local configuration source.

## Frontend modes

- `local-supabase`: uses `.env.local-supabase.local` and an allocated local Supabase runtime.
- `remote-supabase`: uses `.env.remote-supabase.local` for an explicitly selected hosted project.

The coordinator-reserved UBI Finder family is `6032x`: shadow database
`60320`, API `60321`, database `60322`, Studio `60323`, Inbucket `60324`,
reserved SMTP/POP3 `60325`/`60326`, analytics `60327`, and pooler `60329`.
These ports distinguish UBI Finder from other repositories sharing the local
Docker host; they do not authorize starting a stack without a lease.

Copy the corresponding tracked `.example` file, populate its public URL and anon key, and never commit the `.local` file. The application fails at startup when either variable is absent; it does not infer a hosted project or substitute a placeholder key.

## Database validation and delivery

Pull requests that change Supabase migrations, seeds, functions, configuration, or their workflow rebuild an isolated local database and run database linting. This proves replayability only.

Merges to `main` trigger the production migration/function workflow. That workflow requires the Production environment, `SUPABASE_ACCESS_TOKEN`, `SUPABASE_DB_PASSWORD`, and `SUPABASE_PROJECT_ID`; no project identifier is embedded in repository code. A successful PR validation does not prove production deployment.

Local work in the shared `codex-supabase` environment requires the local-Supabase coordinator. Use only the granted port family and command scope, stop project-owned resources, and release the lease when finished.

## Staging and production cutover

This section describes the staged release workflow and its activation steps.
Verify the live GitHub and Vercel settings before treating the cutover as complete.

| Branch | GitHub environment | Supabase | Vercel |
| --- | --- | --- | --- |
| `dev` | Staging | Separate staging project | Preview with variables scoped to `dev` |
| `main` | Production | The project currently serving the live site | Production on the existing project and domains |

Feature PRs go to `dev`. CI validates PRs to both branches. A push to
`dev` that passes CI builds the staging frontend, applies migrations,
deploys the Edge Functions, and publishes the preview. To release, open
a PR from `dev` to `main`. Use a merge commit. The release check requires
a successful Staging deployment for that exact `dev` commit and verifies
that the proposed merge tree matches the staging tree. If main has changes
that alter the release tree, merge main back into dev and stage it again.
Re-run the promotion check if it ran before staging completed.

On `main`, the workflow repeats the release check, builds with production
configuration, and creates a Vercel deployment without assigning the live
domains. It applies database migrations and deploys functions before
assigning the domains to the new frontend.

### Activation sequence

1. Record the current live frontend deployment and the production Supabase
   migration and function inventory. Use current `main` as the initial
   baseline for `dev`. The initial dev commit disables automatic Vercel
   Git deployment while its staging-specific variables are installed. Keep
   current `main` as the production branch. The older
   `main-new` pointer predates the live Stripe fix.
2. Configure a separate staging Supabase project. Prepare staging-specific
   seed data, Auth settings, provider sandbox credentials and redirect URLs
   as needed for the release. Keep production customer data and credentials
   out of staging.
3. Scope the GitHub **Staging** environment to `dev` and **Production** to
   `main`. Require Production reviewers before enabling delivery.
   In each environment, set `DEPLOY_SUPABASE_PROJECT_ID`, `VERCEL_ORG_ID`,
   and `VERCEL_PROJECT_ID`, and set secrets `SUPABASE_ACCESS_TOKEN`,
   `SUPABASE_DB_PASSWORD`, and `VERCEL_TOKEN`. The repository-level
   `SUPABASE_PROJECT_ID` anchors the live backend identity. Keep that name
   reserved at repository scope.
4. Keep Vercel's production branch explicitly set to `main`. Add
   branch-specific Preview variables for `dev`, including
   `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY`. Confirm that
   Production uses the existing live values. The workflow checks the
   frontend URL against the backend target before deployment.
5. Land the workflow on `dev`, run CI and validate the actual staging
   frontend, backend, and Auth paths. Before setting `dev` as the default,
   protect both branches with PR and CI requirements. Require the
   `Verify staged release` check on `main` and allow merge commits
   for production PRs. Retarget draft feature PRs to `dev` and inspect
   their diffs again before review.
6. Open the first promotion PR from `dev` to `main` and verify that
   Vercel's Git-triggered deployment is disabled for both release branches.
   After the reviewed production run, check the deployed SHA, migration
   ledger, function inventory, domain assignment, and live smoke tests.
   Keep the abuse-control rollout in PR #43 separate from this bootstrap.

### Recovery during a release

If production fails before domain assignment, inspect migration and function
state before retrying the same `main` head. A backend step may have applied
some changes before a later step failed. Plan migrations and functions to
support the previous frontend during the release. Reassigning the previous
frontend deployment rolls back frontend traffic. Database migrations and
Edge Functions require their own reviewed recovery steps.
