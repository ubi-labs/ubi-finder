-- ============================================================================
-- Migration 00031: Review and enhance Phase 1 Planned programs (IDs 22, 23)
-- ============================================================================

-- 1. Enhance European Digital Euro Pilot (ID: 22)
UPDATE public.programs
SET
  organization = 'European Central Bank (ECB) & Eurosystem',
  description = 'The European Digital Euro initiative is the official Eurosystem framework exploring a retail central bank digital currency (CBDC) to complement physical cash. It aims to deliver a pan-European, cost-free, privacy-preserving digital payment instrument usable across all 20 euro area countries for in-store, online, and person-to-person transactions. The Eurosystem is currently in a preparatory testing and rulebook development phase; controlled technical and user pilots are targeted for 2027 ahead of potential formal issuance around 2029 pending EU legislative adoption.',
  eligibility = '• Legal resident or citizen of a participating Eurozone member state
• Euro-denominated payment account with a licensed European Payment Service Provider (PSP) or credit institution
• Identity verification meeting European Union AML/CFT and consumer protection frameworks
• Technical pilot participation subject to Eurosystem cohort selection, supervised sandbox parameters, and holding-limit rules',
  amount_description = '43 EUR (~$47 USD) testing allowance benchmark (planned holding limit / pilot transaction allocation)',
  website = 'https://www.ecb.europa.eu/euro/digital_euro/html/index.en.html',
  apply_url = 'https://www.ecb.europa.eu/euro/digital_euro/html/index.en.html',
  sources = ARRAY[
    'https://www.ecb.europa.eu/euro/digital_euro/html/index.en.html',
    'https://www.ecb.europa.eu/paym/digital_euro/',
    'https://www.centralbank.ie/consumer-hub/explainers/what-is-the-digital-euro'
  ]::text[],
  payout_status = 'Planned (Targeting 2027 Eurosystem pilot phase)',
  application_status = 'Planned; pilot cohort enrollment pending EU legislation',
  funding_source = 'state_federal',
  payout_rail = 'crypto_wallet',
  involvement_level = 'external_self_apply',
  data_source = 'community_submission'
WHERE program_id = 22;

-- 2. Enhance FundLoop (ID: 23)
UPDATE public.programs
SET
  organization = 'FundLoop Network',
  description = 'FundLoop is a networked mutual-prosperity protocol where participating software platforms and startup founders pool a recurring share (e.g. 1%) of platform revenue into a community distribution fund. Operating in structured monthly epochs, FundLoop combines project commitment intake, Zero-Knowledge proof-of-personhood via CUBID, and governed allocation algorithms to distribute unconditional rewards and Citizen Salaries directly to active users, volunteers, and product champions. On-chain settlement operates on the Base network with fail-closed governance gates.',
  eligibility = '• Verified uniqueness and proof-of-personhood via CUBID.me (zero-knowledge sybil resistance without exposing private identity data)
• Active participation, testing, feedback, or contribution within one or more participating network apps during the open monthly epoch
• Compatible EVM-compatible digital wallet (Base network) connected to recipient profile
• Account in good standing; open universally to participants worldwide regardless of nationality or geographic region',
  amount_description = 'Variable monthly revenue-share distribution based on pool size and contribution weighting (benchmark ~$25 USD/mo)',
  website = 'https://fundloop-website.vercel.app/en',
  apply_url = 'https://fundloop-website.vercel.app/en/participation',
  sources = ARRAY[
    'https://fundloop-website.vercel.app/en',
    'https://fundloop-website.vercel.app/en/participation',
    'https://fundloop-website.vercel.app/en/founders',
    'https://fundloop.org'
  ]::text[],
  payout_status = 'Planned (Inaugural Cohort / Epoch 1 onboarding under way)',
  application_status = 'Planned; onboarding inaugural projects and participant registrations',
  distribution_type = 'daily_claim_protocol',
  payout_rail = 'crypto_wallet',
  funding_source = 'protocol_yield',
  involvement_level = 'automated_claim',
  data_source = 'community_submission'
WHERE program_id = 23;
