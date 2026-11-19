// Only application routes are canonicalized. Asset paths and unknown URLs retain their case.
export const pagePaths = [
  "/",
  "/about",
  "/accessibility",
  "/admin/review",
  "/admin/submissions",
  "/admin/users",
  "/blog",
  "/blogpost",
  "/claim/circles",
  "/claim/fundloop",
  "/claim/gooddollar",
  "/community",
  "/cookie-policy",
  "/dashboard",
  "/disclaimer",
  "/donate/success",
  "/ecosystem",
  "/editprofile",
  "/home",
  "/login",
  "/manage-program",
  "/my-programs",
  "/my-report",
  "/privacy",
  "/profile",
  "/program-details",
  "/programs",
  "/projects",
  "/report",
  "/services",
  "/submit-program",
  "/submitprogram",
  "/terms"
];

const knownPaths = new Set(pagePaths);

export function canonicalizePathname(pathname) {
  const lowercase = pathname.toLowerCase();
  const route = lowercase.endsWith('/') && lowercase !== '/' ? lowercase.slice(0, -1) : lowercase;
  return knownPaths.has(route) ? lowercase : pathname;
}

export function canonicalizePageUrl(url) {
  const boundary = url.search(/[?#]/);
  const pathname = boundary === -1 ? url : url.slice(0, boundary);
  const suffix = boundary === -1 ? '' : url.slice(boundary);
  return canonicalizePathname(pathname) + suffix;
}
