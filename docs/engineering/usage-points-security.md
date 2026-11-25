# Usage points security

Guest supporter points, prompts, and profile-reset halving are browser-local. The browser-local identifier and counters are telemetry; they are not proof of an IP address, payment, account ownership, or quota authority. Anonymous Data API access to `public.user_usage_points` is revoked at both table and column level.

Signed-in clients may insert, update, and read only their own usage rows through Row Level Security. The browser sanitizes counters to nonnegative PostgreSQL integers before synchronization. The database independently rejects negative counters and accepts only bounded browser identifiers (`ip_` or `anon_` plus lowercase base-36), the trusted `verified_donor` sentinel, and verified guest donation capabilities.

The counter and identifier constraints were added as `NOT VALID`. They protect every new or changed row without scanning, rewriting, or deleting historical browser-provided data during deployment. Before validating either constraint in a later approved migration, use service-owned read access to count and classify violations, decide explicitly how historical rows should be retained or repaired, and record the audit evidence. Until then, an update to a legacy violating row will fail unless the row is made valid in the same authorized operation.

Payment fields remain service-owned. Stripe and reviewed crypto fulfillment continue through their existing restricted functions; browser usage writes cannot set `has_donated` or `total_donated_usd`.
