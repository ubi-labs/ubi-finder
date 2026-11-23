import { supabase } from '@/lib/supabaseClient';

// Auth refresh may replay an older onboarding draft. Only explicit profile
// editing may replace the name on an existing public profile.
export async function savePendingProfile(userId, profile, profileId) {
  let lookup = supabase.from('user_profiles').select('id');
  if (profileId) {
    lookup = lookup.eq('id', profileId);
  } else {
    lookup = lookup.eq('created_by_id', userId)
      .order('created_date', { ascending: false }).limit(1);
  }

  const { data: existing, error: lookupError } = await lookup.maybeSingle();
  if (lookupError) throw lookupError;

  let result;
  if (existing) {
    const updates = { ...profile };
    delete updates.name;
    result = await supabase.from('user_profiles').update(updates)
      .eq('id', existing.id).select().single();
  } else {
    if (profileId) throw new Error('The saved profile could not be loaded.');
    result = await supabase.from('user_profiles')
      .insert([{ ...profile, created_by_id: userId }]).select().single();
    if (result.error && (result.error.code === '23503' || result.error.message?.includes('foreign key'))) {
      result = await supabase.from('user_profiles').insert([profile]).select().single();
    }
  }

  if (result.error) throw result.error;
  if (!result.data?.id) throw new Error('The profile was not saved.');
  return result.data;
}
