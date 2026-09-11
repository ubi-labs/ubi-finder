import { describe, expect, it, vi } from "vitest";
import {
  filterAndDeduplicateRelatedPrograms,
  getRelatedPrograms
} from "@/lib/programGroupingService";

describe("filterAndDeduplicateRelatedPrograms", () => {
  it("returns empty array for invalid input", () => {
    expect(filterAndDeduplicateRelatedPrograms(123, null)).toEqual([]);
    expect(filterAndDeduplicateRelatedPrograms(123, undefined)).toEqual([]);
    expect(filterAndDeduplicateRelatedPrograms(123, "invalid")).toEqual([]);
  });

  it("filters out the current program ID", () => {
    const rawList = [
      {
        program_id: 219,
        name: "Baby's First Years — Louisiana",
        organization: "Teachers College"
      },
      {
        program_id: 244,
        name: "Baby's First Years — Minnesota",
        organization: "Teachers College"
      }
    ];

    const result = filterAndDeduplicateRelatedPrograms(219, rawList);
    expect(result).toHaveLength(1);
    expect(result[0].program_id).toBe(244);
    expect(result[0].name).toBe("Baby's First Years — Minnesota");
  });

  it("filters out programs marked as deleted", () => {
    const rawList = [
      {
        program_id: 100,
        name: "Archived Program",
        internal_status: "deleted"
      },
      {
        program_id: 101,
        name: "Active Program",
        internal_status: "active"
      }
    ];

    const result = filterAndDeduplicateRelatedPrograms(99, rawList);
    expect(result).toHaveLength(1);
    expect(result[0].program_id).toBe(101);
  });

  it("deduplicates programs that appear in multiple groups", () => {
    const rawList = [
      {
        programs: {
          program_id: 188,
          name: "Family Goal Fund — Washington DC",
          organization: "LIFT",
          monthly_amount_usd: 50,
          currency: "USD"
        },
        group_name: "DMV Regional Pilots"
      },
      {
        programs: {
          program_id: 188,
          name: "Family Goal Fund — Washington DC",
          organization: "LIFT",
          monthly_amount_usd: 50,
          currency: "USD"
        },
        group_name: "LIFT Family Goal Fund"
      },
      {
        programs: {
          program_id: 120,
          name: "Family Goal Fund — Los Angeles",
          organization: "LIFT",
          monthly_amount_usd: 50
        },
        group_name: "LIFT Family Goal Fund"
      }
    ];

    const result = filterAndDeduplicateRelatedPrograms(186, rawList);
    expect(result).toHaveLength(2);
    expect(result.map(r => r.program_id)).toEqual([188, 120]);
    expect(result[0].group_name).toBe("DMV Regional Pilots");
  });

  it("handles both flat program structures and nested join structures", () => {
    const rawList = [
      {
        programs: {
          id: "uuid-1",
          program_id: 244,
          name: "Baby's First Years — Minnesota",
          organization: "Teachers College",
          monthly_amount_usd: 333,
          currency: "USD",
          state_province: "Minnesota",
          available_regions: ["United States"]
        },
        group_name: "Baby's First Years",
        relationship_type: "site"
      }
    ];

    const result = filterAndDeduplicateRelatedPrograms(219, rawList);
    expect(result).toHaveLength(1);
    expect(result[0]).toEqual({
      id: "uuid-1",
      program_id: 244,
      name: "Baby's First Years — Minnesota",
      organization: "Teachers College",
      monthly_amount_usd: 333,
      currency: "USD",
      state_province: "Minnesota",
      available_regions: ["United States"],
      municipalities: [],
      group_name: "Baby's First Years",
      group_slug: null,
      relationship_type: "site"
    });
  });
});

describe("getRelatedPrograms", () => {
  it("returns empty array if supabase or programId is missing", async () => {
    expect(await getRelatedPrograms(null, 123)).toEqual([]);
    expect(await getRelatedPrograms({}, null)).toEqual([]);
    expect(await getRelatedPrograms({}, "not-a-number")).toEqual([]);
  });

  it("fetches sibling programs from groups", async () => {
    const mockSupabase = {
      from: vi.fn((table) => {
        if (table === "program_group_members") {
          return {
            select: vi.fn(() => ({
              eq: vi.fn(() => Promise.resolve({
                data: [{ group_id: "grp-1", relationship_type: "site", program_groups: { name: "Baby's First Years" } }],
                error: null
              })),
              in: vi.fn(() => ({
                neq: vi.fn(() => Promise.resolve({
                  data: [
                    {
                      program_id: 244,
                      group_id: "grp-1",
                      relationship_type: "site",
                      programs: {
                        program_id: 244,
                        name: "Baby's First Years — Minnesota",
                        organization: "Teachers College"
                      },
                      program_groups: { name: "Baby's First Years" }
                    },
                    {
                      program_id: 259,
                      group_id: "grp-1",
                      relationship_type: "site",
                      programs: {
                        program_id: 259,
                        name: "Baby's First Years — Nebraska",
                        organization: "Teachers College"
                      },
                      program_groups: { name: "Baby's First Years" }
                    }
                  ],
                  error: null
                }))
              }))
            }))
          };
        }
        if (table === "programs") {
          return {
            select: vi.fn(() => ({
              eq: vi.fn(() => Promise.resolve({ data: [], error: null }))
            }))
          };
        }
        return {};
      })
    };

    const result = await getRelatedPrograms(mockSupabase, 219, null);
    expect(result).toHaveLength(2);
    expect(result[0].program_id).toBe(244);
    expect(result[1].program_id).toBe(259);
    expect(result[0].group_name).toBe("Baby's First Years");
  });

  it("fetches direct parent program if parent_program_id is set", async () => {
    const mockSupabase = {
      from: vi.fn((table) => {
        if (table === "program_group_members") {
          return {
            select: vi.fn(() => ({
              eq: vi.fn(() => Promise.resolve({ data: [], error: null }))
            }))
          };
        }
        if (table === "programs") {
          return {
            select: vi.fn(() => ({
              eq: vi.fn((col, val) => {
                if (col === "program_id") {
                  return {
                    single: vi.fn(() => Promise.resolve({
                      data: { program_id: 218, name: "Cook County Promise Pilot (Phase 1)" },
                      error: null
                    }))
                  };
                }
                if (col === "parent_program_id") {
                  return Promise.resolve({ data: [], error: null });
                }
                return Promise.resolve({ data: null, error: null });
              })
            }))
          };
        }
        return {};
      })
    };

    const currentProg = { program_id: 39, parent_program_id: 218 };
    const result = await getRelatedPrograms(mockSupabase, 39, currentProg);
    expect(result).toHaveLength(1);
    expect(result[0].program_id).toBe(218);
    expect(result[0].relationship_type).toBe("parent_program");
  });

  it("fetches child programs when current program has children", async () => {
    const mockSupabase = {
      from: vi.fn((table) => {
        if (table === "program_group_members") {
          return {
            select: vi.fn(() => ({
              eq: vi.fn(() => Promise.resolve({ data: [], error: null }))
            }))
          };
        }
        if (table === "programs") {
          return {
            select: vi.fn(() => ({
              eq: vi.fn((col, val) => {
                if (col === "parent_program_id") {
                  return Promise.resolve({
                    data: [{ program_id: 39, name: "Cook County Promise Next Phase" }],
                    error: null
                  });
                }
                return Promise.resolve({ data: [], error: null });
              })
            }))
          };
        }
        return {};
      })
    };

    const result = await getRelatedPrograms(mockSupabase, 218, { program_id: 218 });
    expect(result).toHaveLength(1);
    expect(result[0].program_id).toBe(39);
    expect(result[0].relationship_type).toBe("child_program");
  });

  it("returns empty array and logs error gracefully if database query throws", async () => {
    const mockSupabase = {
      from: vi.fn(() => {
        throw new Error("Network connection dropped");
      })
    };

    const consoleSpy = vi.spyOn(console, "error").mockImplementation(() => {});
    const result = await getRelatedPrograms(mockSupabase, 123);
    expect(result).toEqual([]);
    consoleSpy.mockRestore();
  });
});
