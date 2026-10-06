import { programSummaries } from "@/lib/programCatalog";
vi.mock("@/lib/programCatalog", () => ({ programSummaries: vi.fn() }));
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
  const emptyMemberships = { from: vi.fn(() => ({ select: () => ({ eq: async () => ({ data: [] }) }) })) };
  it("does not request nested full program data", async () => {
    programSummaries.mockResolvedValue([{ program_id: 244, name: "Sibling" }]);
    const selects = [];
    const client = { from: vi.fn(table => ({ select: columns => {
      selects.push(columns);
      return { eq: async () => ({ data: [{ group_id: "group" }] }), in: async () => ({ data: [{ program_id: 244, relationship_type: "site", program_groups: { name: "Group" } }] }) };
    } })) };
    const result = await getRelatedPrograms(client, 219);
    expect(result[0]).toMatchObject({ program_id: 244, group_name: "Group", relationship_type: "site" });
    expect(client.from.mock.calls.every(([table]) => table === "program_group_members")).toBe(true);
    expect(selects.join(',')).not.toContain('programs(');
  });
  it("resolves parents and children from public summaries", async () => {
    programSummaries.mockResolvedValue([{ program_id: 218, name: "Parent" }, { program_id: 40, parent_program_id: 39, name: "Child" }]);
    const result = await getRelatedPrograms(emptyMemberships, 39, { parent_program_id: 218 });
    expect(result.map(p => [p.program_id,p.relationship_type])).toEqual([[218,'parent_program'],[40,'child_program']]);
  });
  it("handles unavailable catalogs and invalid identifiers", async () => {
    programSummaries.mockRejectedValue(new Error('Unavailable'));
    expect(await getRelatedPrograms(emptyMemberships, 123)).toEqual([]);
    expect(await getRelatedPrograms(null, 123)).toEqual([]);
    expect(await getRelatedPrograms(emptyMemberships, 'not-an-id')).toEqual([]);
  });
});
