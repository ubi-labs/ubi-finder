import { expect, test } from "@playwright/test";
import { acceptanceUser } from "./support/local-supabase.js";

test("password authentication opens protected dashboard and report paths", async ({ page }) => {
  await page.goto("/Dashboard");
  await expect(page).toHaveURL(/\/login$/);

  await page.getByLabel("Email address").fill(acceptanceUser.email);
  await page.getByLabel("Password").fill(acceptanceUser.password);
  await page.getByRole("button", { name: "Sign in", exact: true }).click();

  await expect(page).toHaveURL(/\/Dashboard$/i);
  await expect(page.getByRole("heading", { name: /Welcome back, Acceptance Tester/ })).toBeVisible();

  await page.getByRole("link", { name: /View Personalized Report/ }).click();
  await expect(page).toHaveURL(/\/My-Report$/i);
  await expect(page.getByRole("heading", { name: "Personalized UBI Income Portfolio" })).toBeVisible();
});

test('verified account opens controlled program detail', async ({ page }) => {
  await page.goto('/login');
  await page.getByLabel('Email address').fill(acceptanceUser.email);
  await page.getByLabel('Password').fill(acceptanceUser.password);
  await page.getByRole('button', { name: 'Sign in', exact: true }).click();
  await expect(page).toHaveURL(/\/Programs$/i);
  const first = page.locator('h3.text-xl').first();
  await expect(first).toBeVisible();
  const name = (await first.textContent()).trim();
  await first.click();
  await expect(page.getByText(name,{exact:true}).first()).toBeVisible();
  await expect(page.getByText('Program not found.',{exact:true})).toHaveCount(0);
});
