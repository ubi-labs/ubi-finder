# Lowercase application URLs

Application paths use lowercase, for example `/ecosystem`, `/programs` and `/my-report`. `src/lib/routePaths.js` lists the recognized paths. Keep that inventory synchronized with `src/App.jsx`; unit tests enforce the correspondence.

`createPageUrl` lowercases the generated pathname and replaces spaces with hyphens. It preserves query values and fragments. Internal links, authentication destinations and the sitemap use lowercase paths directly.

The router's `CanonicalPath` boundary replaces mixed-case recognized locations before rendering navigation or protected pages. It preserves search, hash and router state, and replaces the history entry so Back does not revisit the uppercase alias. Unknown paths, encoded paths and case-sensitive asset filenames are not rewritten.

`vercel.json` declares permanent redirects for the 26 historical uppercase route spellings, including `/Ecosystem` → `/ecosystem`. Vercel's redirects use case-sensitive sources, preventing a lowercase self-redirect. Other mixed-case spellings are normalized by the SPA boundary. See [Vercel case sensitivity](https://vercel.com/docs/project-configuration/vercel-json#case-sensitivity).

The local browser suite covers mixed-case direct entry, query/fragment preservation, router state/history, and login return destinations. Hosting redirects require separate deployed readback; a local Vite acceptance pass does not establish a hosted HTTP 308.
