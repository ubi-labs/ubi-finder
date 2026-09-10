-- ============================================================================
-- Migration 00030: Add 'government_sites' data_source classification
-- Move all programs with distribution_type = 'permanent_statewide' to this source.
-- ============================================================================

UPDATE public.programs
SET data_source = 'government_sites'
WHERE distribution_type = 'permanent_statewide';
