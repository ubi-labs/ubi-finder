import { expect, test } from "@playwright/test";
import { acceptanceUser, findAcceptanceUser, getLocalAdminClient } from "./support/local-supabase.js";

test("password authentication opens protected dashboard and report paths", async ({ page }) => {
  await page.goto("/dashboard");
  await expect(page).toHaveURL(/\/login$/);

  await page.getByLabel("Email address").fill(acceptanceUser.email);
  await page.getByLabel("Password").fill(acceptanceUser.password);
  await page.getByRole("button", { name: "Sign in", exact: true }).click();

  await expect(page).toHaveURL(/\/dashboard$/i);
  await expect(page.getByRole("heading", { name: /Welcome back, Acceptance Tester/ })).toBeVisible();

  await page.getByRole("link", { name: /View Personalized Report/ }).click();
  await expect(page).toHaveURL(/\/my-report$/i);
  await expect(page.getByRole("heading", { name: "Personalized UBI Income Portfolio" })).toBeVisible();
});

test('verified account opens controlled program detail', async ({ page }) => {
  await page.goto('/login?redirectTo=%2FPrograms');
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

test("program submission persists its allocated ID and owner relationship", async ({ page }) => {
  const admin = getLocalAdminClient();
  const acceptanceAccount = await findAcceptanceUser(admin);
  const programName = `Acceptance owned submission ${Date.now()}`;
  let programId;

  expect(acceptanceAccount).toBeTruthy();
  try {
    await page.goto("/login?redirectTo=%2Fsubmit-program");
    await page.getByLabel("Email address").fill(acceptanceUser.email);
    await page.getByLabel("Password").fill(acceptanceUser.password);
    await page.getByRole("button", { name: "Sign in", exact: true }).click();
    await expect(page).toHaveURL(/\/submit-program$/i);

    await page.getByText("I have searched through the database and didn't find my program").click();
    await page.getByRole("button", { name: /Continue to Submission Form/ }).click();
    await page.getByPlaceholder("Enter program name").fill(programName);
    await page.getByPlaceholder("Organization or municipal entity running the program").fill("Acceptance Organization");
    await page.getByPlaceholder("https://...").fill("https://example.test/acceptance-program");
    await page.getByPlaceholder("Detailed description of the program, objectives, and target population")
      .fill("A local acceptance fixture that verifies program ownership persistence.");
    await page.getByPlaceholder("e.g., $500 monthly for 12 months, or 10 G$ daily tokens").fill("$25 monthly");
    await page.getByPlaceholder("e.g. 500").fill("25");
    await page.getByLabel("Globally Available / Worldwide (Open to all countries)").check();
    await page.getByRole("button", { name: "Submit Program", exact: true }).click();

    await expect(page.getByRole("heading", { name: "Success!" })).toBeVisible();
    const { data: createdProgram, error: programError } = await admin.from("programs")
      .select("program_id, created_by_id").eq("name", programName).single();
    expect(programError).toBeNull();
    expect(createdProgram.created_by_id).toBe(acceptanceAccount.id);
    programId = createdProgram.program_id;

    const { data: manager, error: managerError } = await admin.from("program_managers")
      .select("program_id, user_email, role, created_by_id")
      .eq("program_id", programId).eq("user_email", acceptanceUser.email).single();
    expect(managerError).toBeNull();
    expect(manager).toMatchObject({
      program_id: programId,
      user_email: acceptanceUser.email,
      role: "owner",
      created_by_id: acceptanceAccount.id,
    });
  } finally {
    if (programId) {
      await admin.from("program_managers").delete().eq("program_id", programId);
      await admin.from("admin_notifications").delete().eq("program_id", programId);
      await admin.from("programs").delete().eq("program_id", programId);
    } else {
      await admin.from("programs").delete().eq("name", programName);
    }
  }
});
