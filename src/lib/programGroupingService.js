/**
 * Program Grouping & Related Programs Service
 * Handles querying and formatting related or sibling programs for a given program.
 */

/**
 * Filter and deduplicate a list of raw related program objects.
 * Excludes the current program itself and any archived/deleted records.
 * 
 * @param {number|string} currentProgramId 
 * @param {Array} relatedList 
 * @returns {Array} Cleaned list of unique related programs
 */
export function filterAndDeduplicateRelatedPrograms(currentProgramId, relatedList = []) {
  if (!Array.isArray(relatedList)) return [];

  const currId = parseInt(String(currentProgramId), 10);
  const seenIds = new Set();
  const result = [];

  for (const item of relatedList) {
    if (!item) continue;
    
    // Support either flat program object or nested structure
    const prog = item.programs || item;
    const pid = parseInt(String(prog.program_id), 10);

    if (isNaN(pid) || pid === currId) {
      continue;
    }

    if (prog.internal_status === 'deleted') {
      continue;
    }

    if (!seenIds.has(pid)) {
      seenIds.add(pid);
      result.push({
        id: prog.id,
        program_id: pid,
        name: prog.name,
        organization: prog.organization,
        monthly_amount_usd: prog.monthly_amount_usd,
        currency: prog.currency || 'USD',
        state_province: prog.state_province,
        available_regions: prog.available_regions || [],
        municipalities: prog.municipalities || [],
        group_name: item.group_name || item.program_groups?.name || null,
        group_slug: item.group_slug || item.program_groups?.slug || null,
        relationship_type: item.relationship_type || 'related'
      });
    }
  }

  return result;
}

/**
 * Fetch all related programs for a given program ID via Supabase client.
 * 
 * @param {Object} supabase 
 * @param {number|string} programId 
 * @param {Object} [currentProgramData] 
 * @returns {Promise<Array>}
 */
export async function getRelatedPrograms(supabase, programId, currentProgramData = null) {
  if (!supabase || !programId) return [];

  const pid = parseInt(String(programId), 10);
  if (isNaN(pid)) return [];

  try {
    const rawList = [];

    // 1. Query groups this program belongs to via program_group_members
    const { data: memberRows, error: memberErr } = await supabase
      .from('program_group_members')
      .select('group_id, relationship_type, program_groups(id, name, slug, description)')
      .eq('program_id', pid);

    if (!memberErr && memberRows && memberRows.length > 0) {
      const groupIds = memberRows.map(r => r.group_id).filter(Boolean);

      if (groupIds.length > 0) {
        // Find all other programs in these groups
        const { data: siblingRows, error: siblingErr } = await supabase
          .from('program_group_members')
          .select('program_id, group_id, relationship_type, programs(*), program_groups(id, name, slug)')
          .in('group_id', groupIds)
          .neq('program_id', pid);

        if (!siblingErr && siblingRows) {
          rawList.push(...siblingRows);
        }
      }
    }

    // 2. Query direct parent program if parent_program_id is set
    const parentId = currentProgramData?.parent_program_id;
    if (parentId && parentId !== pid) {
      const { data: parentData, error: parentErr } = await supabase
        .from('programs')
        .select('*')
        .eq('program_id', parseInt(String(parentId), 10))
        .single();

      if (!parentErr && parentData) {
        rawList.push({
          programs: parentData,
          relationship_type: 'parent_program',
          group_name: 'Preceding / Parent Program'
        });
      }
    }

    // 3. Query direct children programs where parent_program_id is this program
    const { data: childPrograms, error: childErr } = await supabase
      .from('programs')
      .select('*')
      .eq('parent_program_id', pid);

    if (!childErr && childPrograms && childPrograms.length > 0) {
      for (const cp of childPrograms) {
        rawList.push({
          programs: cp,
          relationship_type: 'child_program',
          group_name: 'Successor / Sub-Program'
        });
      }
    }

    return filterAndDeduplicateRelatedPrograms(pid, rawList);
  } catch (err) {
    console.error('Error fetching related programs:', err);
    return [];
  }
}
