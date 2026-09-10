-- ============================================================================
-- Migration 00029: Move FundLoop from ongoing to Planned status
-- ============================================================================

UPDATE public.programs
SET
  payout_status = 'Planned',
  status = 'upcoming',
  application_status = 'Planned; registration not open'
WHERE name = 'FundLoop';
