import { readFileSync } from 'node:fs';
import { describe, expect, it } from 'vitest';
import { canonicalizePageUrl, canonicalizePathname, pagePaths } from '../../src/lib/routePaths';
import { createPageUrl } from '../../src/utils/index';

describe('lowercase page URLs', () => {
  it.each(pagePaths)('canonicalizes known route %s for any casing', (path) => {
    expect(canonicalizePathname(path.toUpperCase())).toBe(path);
    expect(canonicalizePathname(path)).toBe(path);
  });

  it('preserves query values, encoded IDs and fragments', () => {
    expect(canonicalizePageUrl('/EcOsYsTeM?program=AbC%2FDeF&token=XyZ#MixedAnchor'))
      .toBe('/ecosystem?program=AbC%2FDeF&token=XyZ#MixedAnchor');
    expect(canonicalizePageUrl('/Dashboard')).toBe('/dashboard');
    expect(canonicalizePathname('/EcOsYsTeM/')).toBe('/ecosystem/');
  });

  it.each(['/Brand/LOGO.svg', '/assets/AbCd.js', '/Unknown/Case', '/%45cosystem'])('preserves unknown or asset path %s', (path) => {
    expect(canonicalizePathname(path)).toBe(path);
  });

  it('builds lowercase links without lowercasing their payload', () => {
    expect(createPageUrl('Ecosystem')).toBe('/ecosystem');
    expect(createPageUrl('My Report')).toBe('/my-report');
    expect(createPageUrl('BlogPost?id=CaseSensitive#MixedAnchor')).toBe('/blogpost?id=CaseSensitive#MixedAnchor');
  });

  it('keeps the canonical route inventory in sync with the router', () => {
    const app = readFileSync(new URL('../../src/App.jsx', import.meta.url), 'utf8');
    const paths = [...app.matchAll(/<Route path="([^"*]+)"/g)].map((match) => match[1]);
    expect(paths).toEqual([...new Set(paths)]);
    expect(paths.every((path) => path === path.toLowerCase())).toBe(true);
    expect([...paths].sort()).toEqual([...pagePaths].sort());
  });

  it('permanently redirects legacy URLs without a lowercase self-redirect', () => {
    const config = JSON.parse(readFileSync(new URL('../../vercel.json', import.meta.url), 'utf8'));
    expect(config.redirects).toContainEqual({ source: '/Ecosystem', destination: '/ecosystem', permanent: true });
    for (const redirect of config.redirects) {
      expect(redirect.source).not.toBe(redirect.destination);
      expect(redirect.destination).toBe(redirect.source.toLowerCase());
      expect(pagePaths).toContain(redirect.destination);
      expect(redirect.permanent).toBe(true);
    }
  });

  it('publishes only lowercase sitemap paths', () => {
    const sitemap = readFileSync(new URL('../../public/sitemap.xml', import.meta.url), 'utf8');
    const paths = [...sitemap.matchAll(/<loc>([^<]+)<\/loc>/g)].map((match) => new URL(match[1]).pathname);
    expect(paths.length).toBeGreaterThan(0);
    expect(paths.every((path) => path === path.toLowerCase())).toBe(true);
  });
});
