const MANAGER_ROLES = new Set(["owner", "admin"]);

export async function loadManagedPrograms(client, userEmail) {
  if (!userEmail) {
    throw new Error("A signed-in user email is required to load managed programs.");
  }

  const { data: memberships, error: membershipError } = await client
    .from("program_managers")
    .select("program_id, role")
    .eq("user_email", userEmail);

  if (membershipError) throw membershipError;

  const programIds = [...new Set(
    (memberships || [])
      .filter(({ role }) => MANAGER_ROLES.has(role))
      .map(({ program_id }) => program_id),
  )];

  if (programIds.length === 0) return [];

  const { data: programs, error: programError } = await client
    .from("programs")
    .select("*")
    .in("program_id", programIds);

  if (programError) throw programError;
  return programs || [];
}
