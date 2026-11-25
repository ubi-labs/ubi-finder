export class ProgramOwnerAssociationError extends Error {
  constructor(programId, cause) {
    super(`Program ${programId} was saved, but owner access could not be linked.`);
    this.name = "ProgramOwnerAssociationError";
    this.programId = programId;
    this.cause = cause;
  }
}

export async function persistProgramSubmission({
  client,
  program,
  user,
  userProfileId = null,
  addedDate = new Date().toISOString(),
  savedProgramId = null,
}) {
  if (!user?.id || !user.email) {
    throw new Error("An authenticated submitter is required.");
  }

  let programId = savedProgramId;
  if (programId === null) {
    const { data: createdProgram, error: programError } = await client
      .from("programs")
      .insert([{ ...program, created_by_id: user.id }])
      .select("program_id")
      .single();

    if (programError) throw programError;
    programId = createdProgram?.program_id;
  }

  if (!Number.isInteger(programId) || programId < 1) {
    throw new Error("The submitted program did not return an allocated ID.");
  }

  const { error: managerError } = await client.from("program_managers").insert([{
    program_id: programId,
    user_email: user.email,
    user_profile_id: userProfileId,
    role: "owner",
    added_date: addedDate,
    created_by_id: user.id,
  }]);

  if (managerError) throw new ProgramOwnerAssociationError(programId, managerError);
  return programId;
}
