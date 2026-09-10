import { describe, expect, it } from "vitest";
import { matchesProgramStatus, getProgramSource, matchesProgramSource } from "@/lib/programStatus";

describe("matchesProgramStatus", () => {
  it.each([
    [{ status: "active_open" }, "accepting_applications", true],
    [{ application_status: "Accepting applications" }, "accepting_applications", true],
    [{ status: "active" }, "accepting_applications", true],
    [{ distribution_type: "daily_claim_protocol" }, "accepting_applications", true],
    [{ distribution_type: "lottery_raffle" }, "accepting_applications", true],
    [{ status: "planned" }, "planned", true],
    [{ application_status: "Planned launch" }, "planned", true],
    [{ status: "upcoming" }, "planned", true],
    [{ status: "closed" }, "closed_historical", true],
    [{ status: "completed" }, "closed_historical", true],
    [{ application_status: "Pilot completed" }, "closed_historical", true],
    [{ payout_status: "Completed" }, "closed_historical", true],
    [{ status: "active_closed" }, "closed_ongoing", true],
    [{ application_status: "Referral enrollment only" }, "closed_ongoing", true],
    [{ payout_status: "Ongoing", application_status: "No longer accepting" }, "closed_ongoing", true],
    [{ status: "active_open" }, "all", true],
    [{ status: "active_open" }, "unknown", true],
  ])("classifies %o as %s", (program, filter, expected) => {
    expect(matchesProgramStatus(program, filter)).toBe(expected);
  });

  it("does not classify planned, historical, or closed programs as accepting", () => {
    expect(matchesProgramStatus({ status: "planned" }, "accepting_applications")).toBe(false);
    expect(matchesProgramStatus({ status: "completed" }, "accepting_applications")).toBe(false);
    expect(matchesProgramStatus({ application_status: "No longer accepting" }, "accepting_applications")).toBe(false);
    expect(matchesProgramStatus({ status: "active" }, "planned")).toBe(false);
    expect(matchesProgramStatus({ distribution_type: "daily_claim_protocol", status: "upcoming", payout_status: "Planned" }, "planned")).toBe(true);
    expect(matchesProgramStatus({ distribution_type: "daily_claim_protocol", status: "upcoming", payout_status: "Planned" }, "accepting_applications")).toBe(false);
  });
});

describe("getProgramSource and matchesProgramSource", () => {
  it("classifies permanent_statewide as government", () => {
    const prog = { distribution_type: "permanent_statewide" };
    expect(getProgramSource(prog)).toBe("government");
    expect(matchesProgramSource(prog, "government")).toBe(true);
    expect(matchesProgramSource(prog, "community")).toBe(false);
    expect(matchesProgramSource(prog, "stanford")).toBe(false);
    expect(matchesProgramSource(prog, "all")).toBe(true);
  });

  it("classifies data_source = government_sites as government", () => {
    const prog = { data_source: "government_sites" };
    expect(getProgramSource(prog)).toBe("government");
    expect(matchesProgramSource(prog, "government")).toBe(true);
    expect(matchesProgramSource(prog, "community")).toBe(false);
  });

  it("classifies stanford_basic_income_lab or stanford_experiment_id as stanford", () => {
    const prog1 = { data_source: "stanford_basic_income_lab" };
    const prog2 = { stanford_experiment_id: 123 };
    expect(getProgramSource(prog1)).toBe("stanford");
    expect(getProgramSource(prog2)).toBe("stanford");
    expect(matchesProgramSource(prog1, "stanford")).toBe(true);
    expect(matchesProgramSource(prog2, "stanford")).toBe(true);
    expect(matchesProgramSource(prog1, "community")).toBe(false);
  });

  it("classifies other programs as community", () => {
    const prog = { data_source: "community_submission" };
    expect(getProgramSource(prog)).toBe("community");
    expect(matchesProgramSource(prog, "community")).toBe(true);
    expect(matchesProgramSource(prog, "government")).toBe(false);
    expect(matchesProgramSource(prog, "stanford")).toBe(false);
  });
});

