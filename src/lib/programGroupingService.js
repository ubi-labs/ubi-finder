import { programSummaries } from './programCatalog';
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
  const pid = Number(programId);
  if (!Number.isSafeInteger(pid)) return [];
  try {
    const programs = await programSummaries();
    const { data: memberships } = await supabase.from('program_group_members')
      .select('group_id').eq('program_id', pid);
    const ids = (memberships || []).map(m => m.group_id);
    const { data: siblings } = ids.length ? await supabase.from('program_group_members')
      .select('program_id, relationship_type, program_groups(name, slug)').in('group_id', ids) : { data: [] };
    const related = (siblings || []).map(s => ({ ...s, programs: programs.find(p => p.program_id === s.program_id) })).filter(s => s.programs);
    for (const p of programs) {
      if (p.program_id === currentProgramData?.parent_program_id || p.parent_program_id === pid) related.push({ programs: p, relationship_type: p.parent_program_id === pid ? 'child_program' : 'parent_program' });
    }
    return filterAndDeduplicateRelatedPrograms(pid, related);
  } catch { return []; }
}
