import { randomUUID } from "node:crypto";
import { expect, test } from "@playwright/test";
import { acceptanceUser, getLocalAdminClient } from "./support/local-supabase.js";

test("an intentional profile name survives stale drafts, sign-in and token refresh", async ({ page }) => {
  const admin = getLocalAdminClient();
  const email = `profile-name-${randomUUID()}@example.test`;
  const profileId = randomUUID();
  const signupName = "Original signup name";
  const chosenName = "Deliberately chosen profile name";
  const publicName = "Deliberately chosen public name";
  const { data, error } = await admin.auth.admin.createUser({
    email, password: acceptanceUser.password, email_confirm: true,
    user_metadata: { full_name: signupName, profile_id: profileId },
  });
  expect(error).toBeNull();
  const userId = data.user.id;
  const profile = {
    id: profileId, name: signupName, country: "Germany", gender: "abstain",
    household_size: 1, income_range: "0-20k", currency: "EUR", created_by_id: userId,
  };
  try {
    const inserted = await admin.from("user_profiles").insert(profile);
    expect(inserted.error).toBeNull();
    // This surface is independently editable; UserForm edits user_profiles.name.
    const edited = await admin.from("users").update({ full_name: publicName }).eq("id", userId);
    expect(edited.error).toBeNull();

    await page.goto("/login");
    await page.getByLabel("Email address").fill(email);
    await page.getByLabel("Password").fill(acceptanceUser.password);
    await page.getByRole("button", { name: "Sign in", exact: true }).click();
    await expect(page).not.toHaveURL(/\/login/);
    await page.evaluate((draft) => {
      localStorage.setItem("user_profile_id", draft.id);
      localStorage.setItem("pendingProfile", JSON.stringify(draft));
    }, profile);
    await page.goto("/");
    await page.getByRole("button", { name: /Continue to Step 2/ }).click();
    await page.getByRole("button", { name: /Continue to Step 3/ }).click();
    await page.getByLabel("Full Name", { exact: false }).fill(chosenName);
    await page.getByRole("button", { name: "Save & View Personalized Report", exact: true }).click();
    await expect.poll(async () => {
      const result = await admin.from("user_profiles").select("name").eq("id", profileId).single();
      if (result.error) throw result.error;
      return result.data.name;
    }).toBe(chosenName);

    // Import the same Vite module used by the mounted AuthProvider, not a second client.
    await page.evaluate(async (draft) => {
      const { supabase } = await import("/src/lib/supabaseClient.js");
      window.__nameTestEvents = [];
      supabase.auth.onAuthStateChange((event) => { window.__nameTestEvents.push(event); });
      localStorage.setItem("pendingProfile", JSON.stringify(draft));
      const { error } = await supabase.auth.refreshSession();
      if (error) throw error;
    }, profile);
    await expect.poll(() => page.evaluate(() => window.__nameTestEvents)).toContain("TOKEN_REFRESHED");
    await expect.poll(() => page.evaluate(() => JSON.parse(localStorage.getItem("user_profile_data") || "{}").name)).toBe(chosenName);
    await expect.poll(() => page.evaluate(() => JSON.parse(localStorage.getItem("pendingProfile") || "{}").name)).toBe(chosenName);

    // Replaying the draft on a real sign-in must also preserve the saved name.
    await page.evaluate(async ({ draft, email, password }) => {
      const { supabase } = await import("/src/lib/supabaseClient.js");
      localStorage.setItem("pendingProfile", JSON.stringify(draft));
      window.__nameTestEvents = [];
      const { error } = await supabase.auth.signInWithPassword({ email, password });
      if (error) throw error;
    }, { draft: profile, email, password: acceptanceUser.password });
    await expect.poll(() => page.evaluate(() => window.__nameTestEvents)).toContain("SIGNED_IN");
    await expect.poll(() => page.evaluate(() => JSON.parse(localStorage.getItem("pendingProfile") || "{}").name)).toBe(chosenName);

    const saved = await admin.from("user_profiles").select("name").eq("id", profileId).single();
    expect(saved.error).toBeNull();
    expect(saved.data.name).toBe(chosenName);
    const publicUser = await admin.from("users").select("full_name").eq("id", userId).single();
    expect(publicUser.error).toBeNull();
    expect(publicUser.data.full_name).toBe(publicName);
    await page.goto("/Dashboard");
    await page.reload();
    await expect(page.getByRole("heading", { name: new RegExp(`Welcome back, ${chosenName}`) })).toBeVisible();
  } finally {
    const deleted = await admin.auth.admin.deleteUser(userId);
    expect(deleted.error).toBeNull();
    const removed = await admin.from("user_profiles").delete().eq("id", profileId);
    expect(removed.error).toBeNull();
    const publicRemoved = await admin.from("users").delete().eq("id", userId);
    expect(publicRemoved.error).toBeNull();
  }
});
