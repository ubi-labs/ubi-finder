import { describe, expect, it, vi } from "vitest";
import { loadManagedPrograms } from "@/lib/managedPrograms";

function query(result) {
  return {
    select: vi.fn().mockReturnThis(),
    eq: vi.fn().mockResolvedValue(result),
    in: vi.fn().mockResolvedValue(result),
  };
}

describe("loadManagedPrograms", () => {
  it("requires a signed-in email", async () => {
    await expect(loadManagedPrograms({ from: vi.fn() }, "")).rejects.toThrow("signed-in user email");
  });

  it("loads full pending and rejected programs from email-based owner/admin memberships", async () => {
    const memberships = query({
      data: [
        { program_id: 41, role: "owner", user_profile_id: null },
        { program_id: 42, role: "admin", user_profile_id: "unused-profile" },
        { program_id: 42, role: "admin" },
      ],
      error: null,
    });
    const programs = query({
      data: [
        { program_id: 41, name: "Pending", internal_status: "pending_review" },
        { program_id: 42, name: "Rejected", internal_status: "rejected" },
      ],
      error: null,
    });
    const client = { from: vi.fn((table) => table === "program_managers" ? memberships : programs) };

    await expect(loadManagedPrograms(client, "owner@example.test")).resolves.toEqual([
      { program_id: 41, name: "Pending", internal_status: "pending_review" },
      { program_id: 42, name: "Rejected", internal_status: "rejected" },
    ]);
    expect(memberships.eq).toHaveBeenCalledWith("user_email", "owner@example.test");
    expect(programs.in).toHaveBeenCalledWith("program_id", [41, 42]);
  });

  it("does not query programs without an owner or admin membership", async () => {
    const memberships = query({ data: [{ program_id: 99, role: "viewer" }], error: null });
    const client = { from: vi.fn(() => memberships) };

    await expect(loadManagedPrograms(client, "member@example.test")).resolves.toEqual([]);
    expect(client.from).toHaveBeenCalledTimes(1);
  });

  it.each([
    ["membership", { data: null, error: new Error("membership denied") }],
    ["program", { data: null, error: new Error("program denied") }],
  ])("surfaces a %s query failure", async (stage, failure) => {
    const memberships = query(stage === "membership" ? failure : {
      data: [{ program_id: 41, role: "owner" }], error: null,
    });
    const programs = query(failure);
    const client = { from: vi.fn((table) => table === "program_managers" ? memberships : programs) };

    await expect(loadManagedPrograms(client, "owner@example.test")).rejects.toThrow(`${stage} denied`);
  });
});
