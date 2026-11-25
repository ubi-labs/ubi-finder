import { expect, test } from '@playwright/test';
import { acceptanceUser } from './support/local-supabase.js';

test('legacy and mixed-case ecosystem links canonicalize while preserving query and fragment', async ({ page }) => {
  for (const legacy of ['/Ecosystem', '/ECOSYSTEM', '/eCoSyStEm']) {
    await page.goto(`${legacy}?reference=AbC%2FDeF#MixedAnchor`);
    await expect(page).toHaveURL(/\/ecosystem\?reference=AbC%2FDeF#MixedAnchor$/);
    await expect(page.locator('h1')).toBeVisible();
    const links = await page.locator('a[href^="/"]').evaluateAll((anchors) => anchors.map((anchor) => new URL(anchor.href).pathname));
    expect(links.length).toBeGreaterThan(0);
    expect(links.every((path) => path === path.toLowerCase())).toBe(true);
  }
});

test('client-side canonicalization preserves router state and history position', async ({ page }) => {
  await page.goto('/ecosystem');
  await page.evaluate(() => {
    history.pushState({ ...history.state, usr: { programId: 'CaseSensitive-ID' } }, '', '/EcOsYsTeM?ID=AbC#Anchor');
    window.dispatchEvent(new PopStateEvent('popstate', { state: history.state }));
  });
  await expect(page).toHaveURL(/\/ecosystem\?ID=AbC#Anchor$/);
  expect(await page.evaluate(() => history.state.usr)).toEqual({ programId: 'CaseSensitive-ID' });
  await page.goBack();
  await expect(page).toHaveURL(/\/ecosystem$/);
});

test('legacy login return destinations and protected routes become lowercase', async ({ page }) => {
  await page.goto('/LoGiN?redirectTo=%2FDaShBoArD%3Freference%3DAbC%23MixedAnchor');
  await expect(page).toHaveURL(/\/login\?redirectTo=/);
  await page.getByLabel('Email address').fill(acceptanceUser.email);
  await page.getByLabel('Password').fill(acceptanceUser.password);
  await page.getByRole('button', { name: 'Sign in', exact: true }).click();
  await expect(page).toHaveURL(/\/dashboard\?reference=AbC#MixedAnchor$/);
  await expect(page.getByRole('heading', { name: /Welcome back, Acceptance Tester/ })).toBeVisible();
  await page.goto('/DaShBoArD?reference=XyZ#AnotherAnchor');
  await expect(page).toHaveURL(/\/dashboard\?reference=XyZ#AnotherAnchor$/);
  await page.reload();
  await expect(page).toHaveURL(/\/dashboard\?reference=XyZ#AnotherAnchor$/);
  await expect(page.getByRole('heading', { name: /Welcome back, Acceptance Tester/ })).toBeVisible();
});
