import { describe, expect, it, vi } from "vitest";
import { persistProgramSubmission } from "@/lib/programSubmission";

function submissionClient({
  programResult = { data: { program_id: 431 }, error: null },
  managerResult = { error: null },
} = {}) {
  const programSingle = vi.fn().mockResolvedValue(programResult);
  const programSelect = vi.fn(() => ({ single: programSingle }));
  const programInsert = vi.fn(() => ({ select: programSelect }));
  const managerInsert = vi.fn().mockResolvedValue(managerResult);
  const from = vi.fn(table => {
    if (table === "programs") return { insert: programInsert };
    if (table === "program_managers") return { insert: managerInsert };
    throw new Error(`Unexpected table: ${table}`);
  });
  return { client: { from }, from, programInsert, programSelect, managerInsert };
}

const user = { id: "user-one", email: "owner@example.test" };
const program = { name: "A submitted program", verified: false };

describe("program submission persistence", () => {
  it("propagates the allocated ID and creator identity to the owner row", async () => {
    const fixture = submissionClient();

    await expect(persistProgramSubmission({
      client: fixture.client,
      program,
      user,
      userProfileId: "profile-one",
      addedDate: "2026-11-25T00:00:00.000Z",
    })).resolves.toBe(431);

    expect(fixture.programInsert).toHaveBeenCalledWith([{
      ...program,
      created_by_id: user.id,
    }]);
    expect(fixture.programSelect).toHaveBeenCalledWith("program_id");
    expect(fixture.managerInsert).toHaveBeenCalledWith([{
      program_id: 431,
      user_email: user.email,
      user_profile_id: "profile-one",
      role: "owner",
      added_date: "2026-11-25T00:00:00.000Z",
      created_by_id: user.id,
    }]);
  });

  it("creates the required owner row even when no profile ID is cached", async () => {
    const fixture = submissionClient();
    await persistProgramSubmission({ client: fixture.client, program, user });
    expect(fixture.managerInsert.mock.calls[0][0][0]).toMatchObject({
      program_id: 431,
      user_profile_id: null,
    });
  });

  it("reports program insertion errors without attempting ownership", async () => {
    const error = new Error("program insert denied");
    const fixture = submissionClient({ programResult: { data: null, error } });
    await expect(persistProgramSubmission({ client: fixture.client, program, user })).rejects.toBe(error);
    expect(fixture.managerInsert).not.toHaveBeenCalled();
  });

  it("rejects missing allocated IDs instead of writing an invalid owner row", async () => {
    const fixture = submissionClient({ programResult: { data: {}, error: null } });
    await expect(persistProgramSubmission({ client: fixture.client, program, user }))
      .rejects.toThrow("did not return an allocated ID");
    expect(fixture.managerInsert).not.toHaveBeenCalled();
  });

  it("reports ownership insertion errors instead of claiming success", async () => {
    const error = new Error("manager insert denied");
    const fixture = submissionClient({ managerResult: { error } });
    await expect(persistProgramSubmission({ client: fixture.client, program, user })).rejects.toBe(error);
  });

  it("requires an authenticated submitter", async () => {
    const fixture = submissionClient();
    await expect(persistProgramSubmission({ client: fixture.client, program, user: null }))
      .rejects.toThrow("authenticated submitter");
    expect(fixture.from).not.toHaveBeenCalled();
  });
});
