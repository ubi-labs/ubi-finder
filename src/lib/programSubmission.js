export async function persistProgramSubmission({
  client,
  program,
  user,
  userProfileId = null,
  addedDate = new Date().toISOString(),
}) {
  if (!user?.id || !user.email) {
    throw new Error("An authenticated submitter is required.");
  }

  const { data: createdProgram, error: programError } = await client
    .from("programs")
    .insert([{ ...program, created_by_id: user.id }])
    .select("program_id")
    .single();

  if (programError) throw programError;
  if (!Number.isInteger(createdProgram?.program_id) || createdProgram.program_id < 1) {
    throw new Error("The submitted program did not return an allocated ID.");
  }

  const programId = createdProgram.program_id;
  const { error: managerError } = await client.from("program_managers").insert([{
    program_id: programId,
    user_email: user.email,
    user_profile_id: userProfileId,
    role: "owner",
    added_date: addedDate,
    created_by_id: user.id,
  }]);

  if (managerError) throw managerError;
  return programId;
}
