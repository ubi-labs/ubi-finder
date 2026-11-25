import { expect, test } from "@playwright/test";

test("public discovery uses summaries and full details require verified sign-in", async ({ page }) => {
  await page.goto("/");
  await expect(page.getByRole("heading", { name: "Find Income Support Programs" })).toBeVisible();

  await page.goto("/programs");
  await expect(page.getByRole("heading", { name: "Global UBI Programs Directory" })).toBeVisible();
  await expect(page.getByText("Available Programs", { exact: true })).toBeVisible();
  const firstProgram = page.locator("h3.text-xl").first();
  await expect(firstProgram).toBeVisible();
  const programName = (await firstProgram.textContent())?.trim();
  expect(programName).toBeTruthy();
  await firstProgram.click();
  await expect(page).toHaveURL(/\/program-details$/);
  await expect(page.getByText("Sign in with a verified account to see full program details.", { exact: true })).toBeVisible();
  await expect(page.getByRole("link", { name: "Sign in or create an account" })).toBeVisible();
});

test("eligibility answers persist across a reload", async ({ page }) => {
  await page.goto("/");
  await page.getByText("Select your country").click();
  await page.getByRole("option", { name: "Germany" }).click();
  await page.getByRole("button", { name: /Continue to Step 2/ }).click();
  await page.getByText("Select gender").click();
  await page.getByRole("option", { name: "Prefer not to disclose" }).click();
  await page.getByText("Select income range").click();
  await page.getByRole("option", { name: "$0 – $20,000" }).click();

  await page.reload();
  await expect(page.getByText("2. Household & Income")).toHaveClass(/text-green-700/);
  const pendingProfile = await page.evaluate(() => JSON.parse(localStorage.getItem("pendingProfile") || "{}"));
  expect(pendingProfile).toMatchObject({
    country: "Germany",
    gender: "abstain",
    income_range: "0-20k",
  });
});

test("a denied onboarding signup remains a draft rather than a saved profile", async ({ page }) => {
  await page.route("**/auth/v1/otp", route => route.fulfill({
    status: 400,
    contentType: "application/json",
    body: JSON.stringify({ msg: "CAPTCHA verification failed" }),
  }));

  await page.goto("/");
  await page.getByText("Select your country").click();
  await page.getByRole("option", { name: "Germany" }).click();
  await page.getByRole("button", { name: /Continue to Step 2/ }).click();
  await page.getByText("Select gender").click();
  await page.getByRole("option", { name: "Prefer not to disclose" }).click();
  await page.getByText("Select income range").click();
  await page.getByRole("option", { name: "$0 – $20,000" }).click();
  await page.getByRole("button", { name: /Continue to Step 3/ }).click();
  await page.getByLabel("Full Name").fill("Draft Applicant");
  await page.getByLabel("Email Address").fill("draft-applicant@example.test");
  await page.getByRole("button", { name: "Find Available Programs" }).click();

  await expect(page.getByText("CAPTCHA verification failed", { exact: true })).toBeVisible();
  await expect(page.getByRole("heading", { name: "Verification Email Sent!" })).toHaveCount(0);
  const storage = await page.evaluate(() => ({
    saved: localStorage.getItem("user_profile_data"),
    draft: JSON.parse(localStorage.getItem("pendingProfile") || "{}"),
  }));
  expect(storage.saved).toBeNull();
  expect(storage.draft).toMatchObject({
    name: "Draft Applicant",
    email: "draft-applicant@example.test",
  });
});
