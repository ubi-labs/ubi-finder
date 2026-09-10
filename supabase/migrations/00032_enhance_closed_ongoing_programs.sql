-- ============================================================================
-- Migration 00032: Review and enhance Phase 2 Closed, Ongoing programs (9 programs)
-- IDs: 8, 17, 7, 1, 2, 3, 4, 19, 11
-- ============================================================================

-- 1. Basic Income for the Arts Scheme 2026-2029 (ID: 8)
UPDATE public.programs
SET
  organization = 'Government of Ireland Department of Culture, Communications and Sport',
  description = 'Ireland''s Basic Income for the Arts (BIA) 2026–2029 scheme is the official national successor to Ireland''s landmark 2022–2025 pilot RCT. Backed by an €18.27m allocation in Budget 2026, the scheme provides 2,000 randomly selected professional practicing artists and creative arts workers with an unconditional basic payment of €325 per week (approximately €1,408 monthly) for three years, concluding with a three-month tapering-off transition phase. The program is designed to alleviate financial precarity in the cultural sector, sustain creative practice, and evaluate the longitudinal impacts of basic income under a structured 3-out-of-6-year cyclical entitlement model.',
  eligibility = '• Age 18 or older
• Professional practicing artist or creative arts worker (writers, visual artists, performers, musicians, allied technical creative workers)
• Primarily resident in the Republic of Ireland and tax-compliant (valid PPSN and tax clearance)
• Verifiable evidence of active professional creative practice or accredited arts body membership
• Random selection via lottery among verified applicants
• Participants from the 2022–2025 pilot who meet criteria are eligible to reapply',
  amount_description = '€325 per week (~€1,408 / ~$1,530 USD monthly) for 3 years, followed by a 3-month tapering transition',
  monthly_amount_usd = 1530.00,
  currency = 'EUR',
  website = 'https://www.gov.ie/en/department-of-culture-communications-and-sport/publications/basic-income-for-the-arts-scheme-2026-2029-guidelines-for-application/',
  apply_url = 'https://www.gov.ie/en/department-of-culture-communications-and-sport/publications/basic-income-for-the-arts-scheme-2026-2029-guidelines-for-application/',
  sources = ARRAY[
    'https://www.gov.ie/en/department-of-culture-communications-and-sport/publications/basic-income-for-the-arts-scheme-2026-2029-guidelines-for-application/',
    'https://www.gov.ie/en/department-of-culture-communications-and-sport/publications/basic-income-for-the-arts-scheme-2026-2029-faq/',
    'https://www.gov.ie/en/department-of-culture-communications-and-sport/press-releases/minister-odonovan-announces-the-new-basic-income-for-the-arts-scheme/'
  ]::text[],
  payout_status = 'Selected cohort onboarding; payments start late 2026 backdated to September 2026',
  application_status = 'Applications closed; cohort lottery and verification underway',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  stanford_experiment_id = 256,
  data_source = 'stanford_basic_income_lab'
WHERE program_id = 8;

-- 2. GiveDirectly 12-Year Universal Basic Income Study (ID: 17)
UPDATE public.programs
SET
  organization = 'GiveDirectly & MIT / UC San Diego Research Team',
  description = 'GiveDirectly''s landmark 12-year randomized controlled trial in rural Kenya (Bomet and Siaya counties) is the world''s largest and longest-running universal basic income study, running from 2018 through 2030. Spanning nearly 300 villages and over 20,000 individuals, the study evaluates the sustained socioeconomic effects of universal, unconditional cash. In the long-term treatment cohort, approximately 5,000 adults across 44 villages receive ~$22.50 USD (~2,250 KES, sized to meet baseline basic needs) every month delivered directly via M-Pesa mobile money, comparing outcomes against two-year short-term payments, equivalent lump-sum transfers, and control groups.',
  eligibility = '• Adult (age 18 or older) residing in one of the 44 rural treatment villages in Bomet or Siaya counties, Kenya
• Registered during the baseline village-wide universal census and biometric/mobile enrollment period
• Active Safaricom M-Pesa mobile money account registered to recipient
• Strictly unconditional: zero work requirements, spending restrictions, or repayment obligations
• Universal coverage within designated treatment villages regardless of baseline income or gender',
  amount_description = '~$22.50 USD (approx. 2,250 KES) per month unconditionally for 12 years (2018–2030)',
  monthly_amount_usd = 22.50,
  currency = 'KES',
  website = 'https://www.givedirectly.org/ubi',
  apply_url = 'https://www.givedirectly.org/ubi',
  sources = ARRAY[
    'https://www.givedirectly.org/ubi',
    'https://www.givedirectly.org/2023-ubi-results',
    'https://www.nber.org/papers/w31929'
  ]::text[],
  payout_status = 'Ongoing active monthly disbursements through 2030',
  application_status = 'Closed; baseline village universal enrollment completed in 2018',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'mobile_money',
  funding_source = 'philanthropic_grant',
  involvement_level = 'external_self_apply',
  stanford_experiment_id = 252,
  data_source = 'stanford_basic_income_lab'
WHERE program_id = 17;

-- 3. Supporting Transitional-Aged Youth and Survivors in Achieving Financial Empowerment (STAY SAFE) (ID: 7)
UPDATE public.programs
SET
  name = 'Supporting Transitional-Aged Youth and Survivors in Achieving Financial Empowerment (STAY SAFE)',
  organization = 'City of Los Angeles Community Investment for Families Department (CIFD) & Mayor''s Fund for Los Angeles',
  description = 'The STAY SAFE Los Angeles program is a targeted guaranteed income initiative providing unconditional cash assistance to transitional-aged youth (TAY) aging out of foster care and survivors of intimate partner violence (IPV). Administered by CIFD''s Office of Community Wealth in partnership with the Mayor''s Fund for Los Angeles and UPenn''s Center for Guaranteed Income Research (CGIR), the program provides $24,000 total per participant—either through $1,000 monthly disbursements for 24 months, or a $6,000 front-loaded lump sum followed by $1,000 monthly for 18 months—coupled with supportive wrap-around services via 22 designated community partner organizations.',
  eligibility = '• Age 18 or older
• Resident of the City of Los Angeles (prioritizing Council Districts 9 and 13)
• Transitional-aged youth (TAY, often transitioning out of foster care) or survivor of intimate partner violence (IPV)
• Established client relationship with one of the 22 pre-approved CIFD community partner organizations (e.g. 1736 Family Crisis, Safe Place for Youth, Coalition to Abolish Trafficking, Covenant House, Rainbow Services, Jenesse Center)
• Referral and intake submitted through participating partner agency via the Forward application portal',
  amount_description = '$24,000 total: either $1,000/month for 24 months or $6,000 lump sum + $1,000/month for 18 months',
  monthly_amount_usd = 1000.00,
  currency = 'USD',
  website = 'https://communityinvestment.lacity.gov/programs-resources',
  apply_url = 'https://communityinvestment.lacity.gov/programs-resources',
  sources = ARRAY[
    'https://communityinvestment.lacity.gov/programs-resources',
    'https://cityclerk.lacity.org/onlinedocs/2021/21-0717-S3_rpt_cao_06-04-25.pdf',
    'https://cifd.lacity.gov/'
  ]::text[],
  payout_status = 'Ongoing disbursements via ACH direct deposit or Angeleno MoCaFi cards',
  application_status = 'Partner referral only; designated community agencies coordinate intake',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'prepaid_card',
  funding_source = 'municipal_government',
  involvement_level = 'external_self_apply',
  data_source = 'community_submission'
WHERE program_id = 7;

-- 4. Evanston Guaranteed Income Program 2026 (ID: 1)
UPDATE public.programs
SET
  organization = 'City of Evanston',
  description = 'The Evanston Guaranteed Income Program 2026 is a municipal direct cash initiative providing 102 qualifying low-income Evanston households with $500 per month in unconditional, unrestricted cash assistance for six months ($3,000 total). Designed to provide financial security and economic stability to households facing high living costs, the pilot specifically targets older adults aged 55 and older and families with young children, with cohort selection determined through a randomized lottery among verified eligible applicants.',
  eligibility = '• Resident of the City of Evanston, Illinois
• Household income at or below 185% of the Federal Poverty Level (e.g. $28,952.50 for individual, $59,477.50 for household of 4)
• Must be either age 55 or older, OR a full-time guardian of a child in second grade or younger
• Limit of one application per household
• Proof of 2025 tax return or IRS non-filing transcript required
• Must not have previously participated in an Evanston guaranteed income pilot',
  amount_description = '$500 per month in unrestricted cash for 6 months ($3,000 total)',
  monthly_amount_usd = 500.00,
  currency = 'USD',
  website = 'https://www.cityofevanston.org/residents/community_resources/guaranteed_income_program_2026.php',
  apply_url = 'https://www.cityofevanston.org/residents/community_resources/guaranteed_income_program_2026.php',
  sources = ARRAY[
    'https://www.cityofevanston.org/residents/community_resources/guaranteed_income_program_2026.php',
    'https://www.cityofevanston.org/residents/community_resources/guaranteed_income.php'
  ]::text[],
  payout_status = 'Ongoing monthly distributions through 2026',
  application_status = 'Closed; selection lottery conducted June 1, 2026',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'prepaid_card',
  funding_source = 'municipal_government',
  involvement_level = 'external_self_apply',
  stanford_experiment_id = 121,
  data_source = 'stanford_basic_income_lab'
WHERE program_id = 1;

-- 5. Howard County Guaranteed Basic Income 2 (ID: 2)
UPDATE public.programs
SET
  organization = 'Community Action Council of Howard County (CAC) & Howard County Government',
  description = 'Howard County''s Guaranteed Basic Income 2 (GBI2) Pilot Program is an innovative municipal guaranteed income and matched-asset building initiative. Led by the Community Action Council of Howard County (CAC) in partnership with County Executive Calvin Ball, GBI2 provides participating low-to-moderate-income families with $500 per month in direct unrestricted cash for 12 months, paired with an additional $500 per month deposited into an escrow savings account at a local bank ($12,000 total benefit). The accumulated $6,000 savings balance is disbursed upon participants completing a designated financial literacy education curriculum.',
  eligibility = '• Reside in Howard County, MD for the full duration of the 12-month program
• Biological/adoptive parent or guardian with full or partial caretaking responsibilities for at least one child aged 17 or younger
• Household income between 150% and 300% of the Federal Poverty Level
• Must NOT receive income-based housing assistance (Housing Choice Voucher, BRHP, MIHU property, or LIHTC housing)
• Willingness to meet monthly with a CAC case manager (in person or virtually)
• Commitment to complete a designated financial literacy education program by June 2027',
  amount_description = '$500/month direct cash for 12 months plus $500/month into savings released upon financial literacy completion ($12,000 total)',
  monthly_amount_usd = 500.00,
  currency = 'USD',
  website = 'https://cac-hc.org/gbi2/',
  apply_url = 'https://cac-hc.org/gbi2/',
  sources = ARRAY[
    'https://cac-hc.org/gbi2/',
    'https://cac-hc.org/',
    'https://www.howardcountymd.gov/'
  ]::text[],
  payout_status = 'Ongoing monthly cash disbursements (July 2026 – June 2027)',
  application_status = 'Closed; application lottery closed May 29, 2026',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'municipal_government',
  involvement_level = 'external_self_apply',
  data_source = 'community_submission'
WHERE program_id = 2;

-- 6. Healthy Mama, Healthy Baby (ID: 3)
UPDATE public.programs
SET
  organization = 'The Neighbors Trust & Puentes de Salud',
  description = 'Healthy Mama, Healthy Baby is a philanthropic guaranteed income initiative in Philadelphia created through a trust-based partnership between The Neighbors Trust and Puentes de Salud (Bridges to Health) clinic. Officially registered with the Pennsylvania Department of Human Services, the program provides $8,000 in unconditional cash over 18 months (~$444.44/month) loaded directly onto debit cards for pregnant Latina and immigrant patients who lack access to public healthcare and health insurance. Enrolled at the end of their second trimester, mothers receive steady financial stability during the critical prenatal, birth, and infant stages.',
  eligibility = '• Prenatal patient actively receiving clinical care at Puentes de Salud in South Philadelphia
• Currently pregnant, selected at the end of the second trimester
• Priority focus on low-income Latina mothers and patients excluded from standard health insurance or federal safety-net benefits
• Selected through rolling partner clinical intake as philanthropic funding allows
• Zero spending restrictions or work requirements',
  amount_description = '$8,000 total distributed unconditionally over 18 months (~$444.44 monthly)',
  monthly_amount_usd = 444.44,
  currency = 'USD',
  website = 'https://www.neighborstrust.org/program',
  apply_url = 'https://www.neighborstrust.org/program',
  sources = ARRAY[
    'https://www.neighborstrust.org/program',
    'https://www.pa.gov/agencies/dhs/resources/for-residents/guaranteed-income-pilot-projects',
    'https://puentesdesalud.org/'
  ]::text[],
  payout_status = 'Ongoing monthly debit card disbursements',
  application_status = 'Clinic referral; rolling enrollment of prenatal patients as funding allows',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'prepaid_card',
  funding_source = 'philanthropic_grant',
  involvement_level = 'external_self_apply',
  data_source = 'community_submission'
WHERE program_id = 3;

-- 7. Philly Joy Bank (ID: 4)
UPDATE public.programs
SET
  organization = 'Philadelphia Department of Public Health & Philadelphia City Fund',
  description = 'The Philly Joy Bank is a groundbreaking guaranteed income pilot administered by the Philadelphia Department of Public Health''s Division of Maternal, Child and Family Health alongside the Philadelphia City Fund. Designed to reduce racial disparities in infant mortality and improve maternal-infant health in Philadelphia, the program provides 250 pregnant residents with $1,000 per month in unconditional direct cash from the second trimester through their baby''s first birthday (~18 months, up to $18,000 total). The pilot focuses on neighborhoods with the highest rates of low birth weight and infant mortality: Cobbs Creek, Strawberry Mansion, and Nicetown-Tioga.',
  eligibility = '• Age 18 or older
• Currently pregnant in the second trimester (between 12 weeks and 24 weeks gestation at enrollment)
• Total annual household income under $100,000
• Resident of designated Philadelphia neighborhoods: Nicetown-Tioga, Strawberry Mansion, or qualifying Cobbs Creek (West of 50th St between Market St & Baltimore Ave)
• Open to all eligible residents regardless of citizenship or immigration status',
  amount_description = '$1,000 per month from second trimester through infant''s first birthday (~18 months, up to $18,000 total)',
  monthly_amount_usd = 1000.00,
  currency = 'USD',
  website = 'https://www.phillyjoybank.org/',
  apply_url = 'https://www.phillyjoybank.org/',
  sources = ARRAY[
    'https://www.phillyjoybank.org/',
    'https://www.phillyjoybank.org/faqs',
    'https://philacityfund.org/programs/philly-joy-bank/',
    'https://www.pa.gov/agencies/dhs/resources/for-residents/guaranteed-income-pilot-projects'
  ]::text[],
  payout_status = 'Ongoing monthly cash disbursements',
  application_status = 'Closed; cohort enrolled across target neighborhoods',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'municipal_government',
  involvement_level = 'external_self_apply',
  data_source = 'community_submission'
WHERE program_id = 4;

-- 8. World WLD Airdrop Program (ID: 19)
UPDATE public.programs
SET
  organization = 'World Foundation',
  description = 'The World (formerly Worldcoin) WLD Airdrop Program is a global digital token distribution mechanism providing recurring grants of WLD tokens to verified human participants. Powered by proof-of-humanity verification through biometric imaging (Orb) to achieve Sybil resistance, recipients receive periodic unconditional cryptographic token allocations into self-custodial World App wallets. Active cycles continue 12-month installment streams for enrolled cohorts, with token amounts governed by protocol scale and regional parameters.',
  eligibility = '• Physically located and resident in an eligible, legally compliant jurisdiction (excluding blocked territories like the U.S. and China)
• Possession of an active World App account on supported mobile operating systems
• Successful biometric proof-of-humanity verification via an authorized World Orb
• Enrolled in an active airdrop distribution cycle
• Recurring claiming via World App within designated periodic claim windows',
  amount_description = 'Recurring WLD token grants claimed via World App (~$0.59 to $5.00 USD monthly equivalent depending on token market valuation)',
  monthly_amount_usd = 0.59,
  currency = 'WLD',
  website = 'https://world.org/',
  apply_url = 'https://world.org/',
  sources = ARRAY[
    'https://world.org/',
    'https://whitepaper.world.org/designing-for-scale/2026-03-24',
    'https://whitepaper.world.org/'
  ]::text[],
  payout_status = 'Ongoing for active verified cycles via on-chain World Chain / Optimism settlements',
  application_status = 'Ongoing claiming for active verified cycles; registration restricted by jurisdiction',
  distribution_type = 'daily_claim_protocol',
  payout_rail = 'crypto_wallet',
  funding_source = 'protocol_yield',
  involvement_level = 'external_self_apply',
  data_source = 'community_submission'
WHERE program_id = 19;

-- 9. Alaska Permanent Fund Dividend 2026 (ID: 11)
UPDATE public.programs
SET
  organization = 'State of Alaska Permanent Fund Dividend Division',
  description = 'The Alaska Permanent Fund Dividend (PFD) is the world''s premier, longest-running sovereign wealth resource dividend, in continuous operation since 1982. Funded by state mineral, oil, and gas royalties and investment revenues from the Alaska Permanent Fund Corporation (APFC), the PFD delivers an annual, unconditional cash dividend directly to every eligible Alaska resident—including children. Annual payments (historically between $1,000 and $3,284 per person, representing ~$100–$270/month equivalent) provide a universal economic floor and direct public ownership of shared natural resources.',
  eligibility = '• Alaska resident throughout the entire preceding calendar year (January 1 through December 31, 2025)
• Intent to remain an Alaska resident indefinitely at the time of application
• Has not claimed residency or benefits in another state or country after December 31, 2024
• Meets physical presence requirements with no unexcused absences exceeding statutory limits
• Not sentenced or incarcerated as a result of a felony conviction during the qualifying year
• Timely application filed during the statutory window (January 1 – March 31, 2026)',
  amount_description = 'Annual unconditional dividend (statutorily budgeted; benchmark ~$1,300–$1,750 per Alaskan resident, ~$110–$145/month equivalent)',
  monthly_amount_usd = 145.00,
  currency = 'USD',
  website = 'https://pfd.alaska.gov/',
  apply_url = 'https://pfd.alaska.gov/',
  sources = ARRAY[
    'https://pfd.alaska.gov/',
    'https://apfc.org/',
    'https://en.wikipedia.org/wiki/Alaska_Permanent_Fund'
  ]::text[],
  payout_status = 'Scheduled for October 2026 mass disbursement',
  application_status = 'Closed for 2026 cycle; applications closed March 31, 2026',
  distribution_type = 'permanent_statewide',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  stanford_experiment_id = 1,
  data_source = 'government_sites'
WHERE program_id = 11;
