-- Migration 00036: Review and enhance Phase 3 Open Ongoing programs - Batch 3D (15 programs)
-- Programs: 378, 366, 110, 120, 126, 128, 188, 143, 149, 247, 160, 168, 174, 186, 193

-- Program 1: ID 378 - Prestación Universal por Crianza (Universal Child Benefit - Spain)
UPDATE programs
SET
  name = 'Prestación Universal por Crianza (Universal Child Benefit - Spain)',
  organization = 'Ministry of Social Rights, Consumer Affairs and 2030 Agenda (Spain)',
  description = 'Spain''s Universal Child Benefit (Prestación por Crianza), spearheaded by the Ministry of Social Rights, Consumer Affairs and 2030 Agenda, provides an unconditional monthly cash transfer of €200 (~$220 USD) per child under age 18. Designed to eradicate structural child poverty and guarantee an unconditional child subsistence floor across all autonomous communities, the policy reflects a nationwide expansion of universal family income guarantees.',
  amount_description = '€200 monthly per eligible child (~$220 USD) unconditionally until age 18',
  monthly_amount_usd = 220,
  currency = 'EUR',
  eligibility = 'Universal for families residing in Spain with children and dependent youth under 18 years of age, without means tests or employment prerequisites.',
  website = 'https://www.dsca.gob.es/',
  apply_url = 'https://www.dsca.gob.es/',
  data_source = 'government_sites',
  payout_status = 'Ongoing universal child benefit disbursements nationwide',
  application_status = 'Open to eligible families through national social security and ministry portals',
  sources = ARRAY[
    'https://www.dsca.gob.es/',
    'https://www.hrw.org/news/2025/02/06/spains-universal-child-benefit-could-transform-lives',
    'https://www.humanium.org/en/spains-2025-universal-child-benefit-aims-to-combat-child-poverty/'
  ],
  available_regions = ARRAY['Spain'],
  required_states = ARRAY[]::text[],
  state_province = 'National',
  latitude = 40.4168,
  longitude = -3.7038,
  min_age = 0,
  max_age = 18,
  status = 'active',
  updated_date = NOW()
WHERE id = '450a5970-d05a-47d8-a16d-69c162c3da6d' OR program_id = 378;

-- Program 2: ID 366 - Basic Retirement Pension (Mauritius)
UPDATE programs
SET
  name = 'Basic Retirement Pension (Mauritius)',
  organization = 'Ministry of Social Integration, Social Security and National Solidarity',
  description = 'The Mauritius Basic Retirement Pension (BRP) is a sovereign, non-contributory universal basic income pension provided unconditionally to all Mauritian citizens and permanent residents aged 60 and older. Established as a cornerstone of Mauritius''s comprehensive welfare state, the pension is paid monthly without any means test, past employment criteria, or contribution history, and was increased to Rs 13,500–14,000 per month.',
  amount_description = 'Rs 13,500 – Rs 14,000 MUR monthly (~$300 USD) universal non-contributory pension',
  monthly_amount_usd = 300,
  currency = 'MUR',
  eligibility = 'Universal for all Mauritian citizens aged 60 and older residing in Mauritius, as well as non-citizens meeting statutory residency requirements. Fully non-contributory and non-means-tested.',
  website = 'https://socialsecurity.govmu.org/socialsecurity/',
  apply_url = 'https://socialsecurity.govmu.org/socialsecurity/',
  data_source = 'government_sites',
  payout_status = 'Ongoing universal pension payments issued monthly to all eligible seniors',
  application_status = 'Open to residents upon reaching age 60 via local Social Security offices',
  sources = ARRAY[
    'https://socialsecurity.govmu.org/socialsecurity/',
    'https://statsmauritius.govmu.org/'
  ],
  available_regions = ARRAY['Mauritius'],
  required_states = ARRAY[]::text[],
  state_province = 'National',
  latitude = -20.1609,
  longitude = 57.5012,
  min_age = 60,
  max_age = NULL,
  status = 'active',
  updated_date = NOW()
WHERE id = 'e3fcf189-deb1-4d44-b422-a7684563b4b2' OR program_id = 366;

-- Program 3: ID 110 - Family Income for Empowerment Program (FIEP)
UPDATE programs
SET
  name = 'Family Income for Empowerment Program (FIEP)',
  organization = 'Jewish Family Service of San Diego & County of San Diego Child and Family Well-Being Department',
  description = 'The Family Income for Empowerment Program (FIEP) is a guaranteed basic income demonstration in San Diego County, California, administered by Jewish Family Service of San Diego in close partnership with the County''s Child and Family Well-Being Department. The initiative provides $500 monthly for 24 months to 485 families with children under 18 who have had contact with or are at risk of involvement with the child welfare system, rigorously testing how unconditional cash support stabilizes family units.',
  amount_description = '$500 per month for 24 consecutive months ($12,000 total unrestricted cash)',
  monthly_amount_usd = 500,
  currency = 'USD',
  eligibility = 'San Diego County families with children under 18 identified and referred directly by the County of San Diego Child and Family Well-Being Department; direct public applications are not accepted.',
  website = 'https://www.jfssd.org/our-services/economic-mobility-opportunity/family-income-for-empowerment-program/',
  apply_url = 'https://www.jfssd.org/our-services/economic-mobility-opportunity/family-income-for-empowerment-program/',
  data_source = 'stanford_basic_income_lab',
  stanford_experiment_id = 12,
  payout_status = 'Active 24-month disbursements ongoing through 2026',
  application_status = 'Closed; cohort fully enrolled via direct county agency referral',
  sources = ARRAY[
    'https://www.jfssd.org/our-services/economic-mobility-opportunity/family-income-for-empowerment-program/',
    'https://basicincome.stanford.edu/research/basic-income-experiments/',
    'https://guaranteedincome.us/pilots',
    'https://www.med.upenn.edu/cgir/research.html'
  ],
  available_regions = ARRAY['United States'],
  required_states = ARRAY['California'],
  state_province = 'California',
  municipalities = ARRAY['San Diego County'],
  latitude = 32.7157,
  longitude = -117.1611,
  total_participants = 485,
  is_rct = true,
  status = 'active',
  updated_date = NOW()
WHERE id = '37144243-eb01-415c-9ff2-9d0c7b2e4130' OR program_id = 110;

-- Program 4: ID 120 - Family Goal Fund (Los Angeles)
UPDATE programs
SET
  name = 'Family Goal Fund — Los Angeles',
  organization = 'LIFT',
  description = 'The Family Goal Fund is an unrestricted cash transfer initiative integrated into LIFT''s two-generation coaching model in Los Angeles, California. LIFT pairs low-income parents of young children with professional coaching and quarterly cash transfers of $150 ($50/month equivalent; $1,200 over two years) to provide financial breathing room, reduce acute material hardship, and accelerate long-term economic mobility and goal achievement.',
  amount_description = '$150 disbursed quarterly ($50/month equivalent; $1,200 total over 2 years)',
  monthly_amount_usd = 50,
  currency = 'USD',
  eligibility = 'Low-income parents and primary caregivers of young children under age eight enrolled in LIFT''s two-year coaching program in Los Angeles, committed to working toward self-defined career and educational goals.',
  website = 'https://www.liftcommunities.org',
  apply_url = 'https://www.liftcommunities.org',
  data_source = 'stanford_basic_income_lab',
  stanford_experiment_id = 23,
  payout_status = 'Ongoing quarterly cash disbursements to participating cohort families',
  application_status = 'Open to eligible parents enrolling in LIFT coaching cohorts',
  sources = ARRAY[
    'https://www.liftcommunities.org',
    'https://basicincome.stanford.edu/research/basic-income-experiments/',
    'https://guaranteedincome.us/pilots'
  ],
  available_regions = ARRAY['United States'],
  required_states = ARRAY['California'],
  state_province = 'California',
  municipalities = ARRAY['Los Angeles'],
  latitude = 34.0522,
  longitude = -118.2437,
  total_participants = 800,
  status = 'active',
  updated_date = NOW()
WHERE id = '46792a91-eb49-4ef9-b893-a5e3c21a2365' OR program_id = 120;

-- Program 5: ID 126 - Alas (Ventures)
UPDATE programs
SET
  name = 'Alas Guaranteed Income Program',
  organization = 'Ventures',
  description = 'Alas ("Wings") is a guaranteed income and financial resilience initiative operated by Ventures (formerly Santa Cruz Community Ventures) across California''s Central Coast. Born out of emergency disaster and relief work for rural farmworkers and undocumented families in the Pajaro Valley and Monterey Bay, Alas provides $500 per month in unconditional cash assistance for six months paired with cohort-based peer workshops and financial education to build lasting economic stability.',
  amount_description = '$500 monthly for 6 months ($3,000 total unconditional cash)',
  monthly_amount_usd = 500,
  currency = 'USD',
  eligibility = 'Working-class rural Latino families, immigrant workers, Latina farmworkers, and domestic violence survivors residing in the Monterey Bay region (Santa Cruz, Monterey, and San Benito counties).',
  website = 'https://www.sccvonline.org/alas',
  apply_url = 'https://www.sccvonline.org/alas',
  data_source = 'stanford_basic_income_lab',
  stanford_experiment_id = 29,
  payout_status = 'Ongoing cohort disbursements and evaluations in the Monterey Bay area',
  application_status = 'Open periodically by cohort selection via community partners and Ventures',
  sources = ARRAY[
    'https://www.sccvonline.org/alas',
    'https://basicincome.stanford.edu/research/basic-income-experiments/',
    'https://guaranteedincome.us/pilots'
  ],
  available_regions = ARRAY['United States'],
  required_states = ARRAY['California'],
  state_province = 'California',
  municipalities = ARRAY['Santa Cruz County', 'Monterey County', 'San Benito County', 'Watsonville'],
  latitude = 36.9741,
  longitude = -122.0308,
  total_participants = 60,
  status = 'active',
  updated_date = NOW()
WHERE id = 'a064c5da-31f0-4567-a8fe-1f7a2bb9b154' OR program_id = 126;

-- Program 6: ID 128 - Miracle Money — Thriving Community Fund (TCF) Expansion
UPDATE programs
SET
  name = 'Miracle Money — Thriving Community Fund (TCF) Expansion',
  organization = 'Miracle Messages',
  description = 'The Miracle Money Thriving Community Fund (TCF) expansion is a guaranteed basic income program led by Miracle Messages in partnership with community providers across California. The initiative provides unhoused individuals and families with $750 per month in unconditional cash for 12 months, paired with volunteer relational support via the Miracle Friends network. The program is evaluated in randomized controlled trials with University of Southern California (USC) researchers to measure housing exits and stability.',
  amount_description = '$750 per month for 12 consecutive months ($9,000 total unconditional cash)',
  monthly_amount_usd = 750,
  currency = 'USD',
  eligibility = 'Individuals and families experiencing homelessness or extreme housing vulnerability in California participating through partner service agencies within the Thriving Community Fund network.',
  website = 'https://www.miraclemessages.org/money',
  apply_url = 'https://www.miraclemessages.org/money',
  data_source = 'stanford_basic_income_lab',
  stanford_experiment_id = 31,
  payout_status = 'Ongoing 12-month disbursements across partner California communities',
  application_status = 'Enrollment coordinated through partner service agencies and research referrals',
  sources = ARRAY[
    'https://www.miraclemessages.org/money',
    'https://basicincome.stanford.edu/research/basic-income-experiments/',
    'https://guaranteedincome.us/pilots'
  ],
  available_regions = ARRAY['United States'],
  required_states = ARRAY['California'],
  state_province = 'California',
  municipalities = ARRAY['Multiple California Communities'],
  latitude = 37.7749,
  longitude = -122.4194,
  total_participants = 110,
  is_rct = true,
  status = 'active',
  updated_date = NOW()
WHERE id = '990389f0-c215-4351-81a7-a06de903e13e' OR program_id = 128;

-- Program 7: ID 188 - Family Goal Fund — Washington DC
UPDATE programs
SET
  name = 'Family Goal Fund — Washington DC',
  organization = 'LIFT',
  description = 'The Family Goal Fund — Washington DC is an unrestricted cash transfer program operating within LIFT''s two-generation coaching model in the District of Columbia. Low-income parents and caregivers partnering with LIFT receive $150 every three months ($50/month equivalent; $1,200 over two years) alongside one-on-one personal coaching to alleviate acute financial stress and build savings and educational advancement.',
  amount_description = '$150 disbursed quarterly ($50/month equivalent; $1,200 total over 2 years)',
  monthly_amount_usd = 50,
  currency = 'USD',
  eligibility = 'Low-income parents and primary caregivers of young children under age eight participating in LIFT''s two-year coaching program in Washington, D.C.',
  website = 'https://www.liftcommunities.org',
  apply_url = 'https://www.liftcommunities.org',
  data_source = 'stanford_basic_income_lab',
  stanford_experiment_id = 23,
  payout_status = 'Ongoing quarterly disbursements to enrolled cohort families',
  application_status = 'Open to eligible parents enrolling in LIFT coaching cohorts in Washington, DC',
  sources = ARRAY[
    'https://www.liftcommunities.org',
    'https://basicincome.stanford.edu/research/basic-income-experiments/',
    'https://guaranteedincome.us/pilots'
  ],
  available_regions = ARRAY['United States'],
  required_states = ARRAY['District of Columbia'],
  state_province = 'District of Columbia',
  municipalities = ARRAY['Washington DC'],
  latitude = 38.9072,
  longitude = -77.0369,
  total_participants = 800,
  status = 'active',
  updated_date = NOW()
WHERE id = '472df1c1-604f-4560-9ac6-cb6b89f0d64b' OR program_id = 188;

-- Program 8: ID 143 - Family First Economic Support Pilot
UPDATE programs
SET
  name = 'Family First Economic Support Pilot',
  organization = 'Sacramento County Department of Child, Family and Adult Services (DCFAS)',
  description = 'The Family First Economic Support Pilot is a guaranteed basic income pilot in Sacramento County, California, funded by the California Department of Social Services (CDSS) and administered by Sacramento County DCFAS in partnership with United Way California Capital Region. The initiative provides $725 monthly for 12 months to 200 low-income families with young children in target zip codes, evaluated by MEF Associates to study child welfare prevention and family stability.',
  amount_description = '$725 per month for 12 consecutive months ($8,700 total unconditional cash)',
  monthly_amount_usd = 725,
  currency = 'USD',
  eligibility = 'Sacramento County residents living in zip codes 95815, 95821, 95823, 95825, 95828, or 95838; parent or legal guardian of a Black/African American, American Indian, or Alaska Native child aged 0–5; household income below 200% FPL; and not participating in another guaranteed income pilot.',
  website = 'https://dcfas.saccounty.net/Admin/Pages/Family-First-Economic-Support-Pilot.aspx',
  apply_url = 'https://dcfas.saccounty.net/Admin/Pages/Family-First-Economic-Support-Pilot.aspx',
  data_source = 'stanford_basic_income_lab',
  stanford_experiment_id = 48,
  payout_status = 'Ongoing 12-month cash payments to selected participant families',
  application_status = 'Application periods completed; lottery selection conducted for active cohort',
  sources = ARRAY[
    'https://dcfas.saccounty.net/Admin/Pages/Family-First-Economic-Support-Pilot.aspx',
    'https://basicincome.stanford.edu/research/basic-income-experiments/',
    'https://guaranteedincome.us/pilots'
  ],
  available_regions = ARRAY['United States'],
  required_states = ARRAY['California'],
  state_province = 'California',
  municipalities = ARRAY['Sacramento County'],
  latitude = 38.5816,
  longitude = -121.4944,
  total_participants = 200,
  status = 'active',
  updated_date = NOW()
WHERE id = '150d705f-59e3-49eb-80c8-a024539edd0c' OR program_id = 143;

-- Program 9: ID 149 - Cash Transfers and Rapid Re-Housing
UPDATE programs
SET
  name = 'Cash Transfers and Rapid Re-Housing',
  organization = 'Abode Services',
  description = 'Cash Transfers and Rapid Re-Housing is a large-scale randomized controlled trial in the San Francisco Bay Area, California, led by Abode Services in partnership with the Wilson Sheehan Lab for Economic Opportunities (LEO) at Notre Dame and J-PAL North America. The study provides unconditional cash payments totaling $13,000 for individuals and $16,000 for households with children (averaging ~$1,100 monthly) over 12 months upon exiting rapid re-housing, testing whether cash transfers prevent returns to homelessness.',
  amount_description = '$800 – $2,000 monthly (~$1,100 average; $13,000–$16,000 total over 12 months)',
  monthly_amount_usd = 1100,
  currency = 'USD',
  eligibility = 'Individuals and families completing Abode Services Rapid Re-Housing programs across the San Francisco Bay Area and transitioning out of temporary housing subsidies into independent leases.',
  website = 'https://www.abodeservices.org',
  apply_url = 'https://www.abodeservices.org',
  data_source = 'stanford_basic_income_lab',
  stanford_experiment_id = 54,
  payout_status = 'Active trial disbursements ongoing through December 2027',
  application_status = 'Closed; cohort enrolled through Abode Services rapid re-housing exit pathways',
  sources = ARRAY[
    'https://www.abodeservices.org',
    'https://www.povertyactionlab.org/evaluation/cash-transfers-and-rapid-re-housing-evaluating-unconditional-cash-transfers-combat-homelessness',
    'https://basicincome.stanford.edu/research/basic-income-experiments/',
    'https://guaranteedincome.us/pilots',
    'https://www.med.upenn.edu/cgir/research.html'
  ],
  available_regions = ARRAY['United States'],
  required_states = ARRAY['California'],
  state_province = 'California',
  municipalities = ARRAY['San Francisco Bay Area', 'Alameda County', 'Santa Clara County'],
  latitude = 37.5485,
  longitude = -121.9886,
  total_participants = 990,
  is_rct = true,
  status = 'active',
  updated_date = NOW()
WHERE id = '4a41eec4-02be-4311-847f-519526f202d2' OR program_id = 149;

-- Program 10: ID 247 - Magnolia Mother's Trust
UPDATE programs
SET
  name = 'Magnolia Mother''s Trust',
  organization = 'Springboard to Opportunities',
  description = 'The Magnolia Mother''s Trust (MMT), initiated in 2018 in Jackson, Mississippi by Springboard to Opportunities under CEO Aisha Nyandoro, is the longest-running guaranteed basic income program in the United States. MMT provides $1,000 per month in unconditional cash for 12 months to Black mothers living in federally subsidized affordable housing, establishing an influential nationwide blueprint for dignity-centered, unconditional economic support.',
  amount_description = '$1,000 per month for 12 consecutive months ($12,000 total unconditional cash)',
  monthly_amount_usd = 1000,
  currency = 'USD',
  eligibility = 'Extremely low-income Black mothers who head households and reside in federally subsidized affordable housing communities managed by Springboard to Opportunities partners in Jackson, Mississippi.',
  website = 'https://springboardto.org/magnolia-mothers-trust/',
  apply_url = 'https://springboardto.org/magnolia-mothers-trust/',
  data_source = 'stanford_basic_income_lab',
  stanford_experiment_id = 162,
  payout_status = 'Ongoing multi-year cohort disbursements in Jackson, MS',
  application_status = 'Open to eligible resident mothers through annual cohort selection cycles',
  sources = ARRAY[
    'https://springboardto.org/magnolia-mothers-trust/',
    'https://basicincome.stanford.edu/research/basic-income-experiments/',
    'https://guaranteedincome.us/pilots'
  ],
  available_regions = ARRAY['United States'],
  required_states = ARRAY['Mississippi'],
  state_province = 'Mississippi',
  municipalities = ARRAY['Jackson'],
  latitude = 32.2988,
  longitude = -90.1848,
  total_participants = 100,
  status = 'active',
  updated_date = NOW()
WHERE id = 'df2f7ba6-7271-4380-a9c7-17e1d87fa9a2' OR program_id = 247;

-- Program 11: ID 160 - San Mateo County Baby Bonus Pilot Program
UPDATE programs
SET
  name = 'San Mateo County Baby Bonus Pilot Program',
  organization = 'First 5 San Mateo County',
  description = 'The San Mateo County Baby Bonus Pilot Program is a landmark guaranteed income and early childhood demonstration launched in March 2025 by First 5 San Mateo County in partnership with the Health Plan of San Mateo, Jackie Speier Foundation, Chan Zuckerberg Initiative, and Peninsula Health Care District. The initiative provides 400 families with $300 per month from birth until their child turns three (up to 36 months / $10,800 total), evaluated via randomized controlled trial with Stanford University School of Medicine.',
  amount_description = '$300 per month from childbirth until age three (up to 36 months; $10,800 total)',
  monthly_amount_usd = 300,
  currency = 'USD',
  eligibility = 'San Mateo County families who are pregnant or give birth and are enrolled in or eligible for Medi-Cal through the Health Plan of San Mateo (HPSM).',
  website = 'https://first5sanmateo.org/baby-bonus/',
  apply_url = 'https://first5sanmateo.org/baby-bonus/',
  data_source = 'stanford_basic_income_lab',
  stanford_experiment_id = 65,
  payout_status = 'Active monthly payments continuing through child age three (2025–2028)',
  application_status = 'Enrolling eligible birthing parents through Health Plan of San Mateo care pathways',
  sources = ARRAY[
    'https://first5sanmateo.org/baby-bonus/',
    'https://basicincome.stanford.edu/research/basic-income-experiments/',
    'https://guaranteedincome.us/pilots',
    'https://www.med.upenn.edu/cgir/research.html'
  ],
  available_regions = ARRAY['United States'],
  required_states = ARRAY['California'],
  state_province = 'California',
  municipalities = ARRAY['San Mateo County'],
  latitude = 37.5630,
  longitude = -122.3255,
  total_participants = 400,
  is_rct = true,
  status = 'active',
  updated_date = NOW()
WHERE id = 'e3031226-1f12-4a22-9b1e-79adff251360' OR program_id = 160;

-- Program 12: ID 168 - Mothers Rising for Guaranteed Basic Income
UPDATE programs
SET
  name = 'Mothers Rising for Guaranteed Basic Income',
  organization = 'Rising Communities',
  description = 'Mothers Rising for Guaranteed Basic Income is a community-led initiative in South Los Angeles, California, administered by Rising Communities (formerly Community Health Councils). Launched in March 2024, the program provides $500 per month (distributed as $250 twice monthly) for three full years (March 2024 – March 2027; $18,000 total) to 100 BIPOC pregnant women and mothers of children ages 0–5 to foster economic security, alleviate maternal health stress, and support wealth-building.',
  amount_description = '$500 per month ($250 twice monthly) for 36 months ($18,000 total unconditional cash)',
  monthly_amount_usd = 500,
  currency = 'USD',
  eligibility = 'BIPOC mothers and pregnant individuals residing in South Los Angeles with dependent children ages 0–5 who experience financial hardship and are committed to participating in community workshops.',
  website = 'https://www.risingcommunities.org/mothers-rising',
  apply_url = 'https://www.risingcommunities.org/mothers-rising',
  data_source = 'stanford_basic_income_lab',
  stanford_experiment_id = 75,
  payout_status = 'Active bi-weekly payments continuing through March 2027',
  application_status = 'Closed; active 3-year cohort established and receiving disbursements',
  sources = ARRAY[
    'https://www.risingcommunities.org/mothers-rising',
    'https://basicincome.stanford.edu/research/basic-income-experiments/',
    'https://guaranteedincome.us/pilots'
  ],
  available_regions = ARRAY['United States'],
  required_states = ARRAY['California'],
  state_province = 'California',
  municipalities = ARRAY['South Los Angeles', 'Los Angeles'],
  latitude = 33.9936,
  longitude = -118.2789,
  total_participants = 100,
  status = 'active',
  updated_date = NOW()
WHERE id = 'f295ee65-5f62-4643-9c4b-42eb22533b54' OR program_id = 168;

-- Program 13: ID 174 - Miracle Money — Dignity Fund Expansion
UPDATE programs
SET
  name = 'Miracle Money — Dignity Fund Expansion',
  organization = 'Miracle Messages',
  description = 'The Miracle Money Dignity Fund expansion is an unconditional basic income and relational support program created by Miracle Messages in California. Launched in December 2024, the fund distributes $300 per month for 12 months ($3,600 total) to 110 unhoused or deeply impoverished individuals who are actively paired with volunteer phone buddies in the Miracle Friends program, providing essential financial flexibility and social connection.',
  amount_description = '$300 per month for 12 consecutive months ($3,600 total unconditional cash)',
  monthly_amount_usd = 300,
  currency = 'USD',
  eligibility = 'Unhoused or housing-vulnerable individuals in California engaged in the Miracle Friends relational buddy program seeking economic dignity and connection.',
  website = 'https://www.miraclemessages.org/money',
  apply_url = 'https://www.miraclemessages.org/money',
  data_source = 'stanford_basic_income_lab',
  stanford_experiment_id = 81,
  payout_status = 'Active 12-month disbursements ongoing across California',
  application_status = 'Open to active participants in the Miracle Friends community program',
  sources = ARRAY[
    'https://www.miraclemessages.org/money',
    'https://basicincome.stanford.edu/research/basic-income-experiments/',
    'https://guaranteedincome.us/pilots'
  ],
  available_regions = ARRAY['United States'],
  required_states = ARRAY['California'],
  state_province = 'California',
  municipalities = ARRAY['California Statewide'],
  latitude = 37.7749,
  longitude = -122.4194,
  total_participants = 110,
  status = 'active',
  updated_date = NOW()
WHERE id = '581d6ad5-07f7-4efa-b22b-00f01d742406' OR program_id = 174;

-- Program 14: ID 186 - Let's Go DMV!
UPDATE programs
SET
  name = 'Let''s Go DMV!',
  organization = 'iF, A Foundation for Radical Possibility & ROC-DC',
  description = 'Let''s GO (Guarantee Opportunity) DMV! is a guaranteed basic income initiative in the Washington, D.C. metropolitan region (DMV), launched by iF, A Foundation for Radical Possibility in coalition with the Restaurant Opportunities Center of DC (ROC-DC), Greater Washington Community Foundation, and Amalgamated Foundation. The program provides $1,000 per month in unconditional cash to 75 low-wage hospitality and service workers who lost income during the pandemic.',
  amount_description = '$1,000 per month for 3 years ($36,000 total unconditional cash)',
  monthly_amount_usd = 1000,
  currency = 'USD',
  eligibility = 'Low-wage hospitality and service workers residing in the Washington, D.C. metropolitan area (District of Columbia, suburban Maryland, and Northern Virginia) excluded from federal relief or experiencing systemic wage volatility.',
  website = 'https://www.letsgodmv.org',
  apply_url = 'https://www.letsgodmv.org',
  data_source = 'stanford_basic_income_lab',
  stanford_experiment_id = 95,
  payout_status = 'Active monthly payments continuing through 2026',
  application_status = 'Closed; initial hospitality worker cohort selected and actively receiving transfers',
  sources = ARRAY[
    'https://www.letsgodmv.org',
    'https://basicincome.stanford.edu/research/basic-income-experiments/',
    'https://guaranteedincome.us/pilots'
  ],
  available_regions = ARRAY['United States'],
  required_states = ARRAY['District of Columbia', 'Maryland', 'Virginia'],
  state_province = 'District of Columbia',
  municipalities = ARRAY['Washington DC', 'Suburban Maryland', 'Northern Virginia'],
  latitude = 38.9072,
  longitude = -77.0369,
  total_participants = 75,
  status = 'active',
  updated_date = NOW()
WHERE id = '5a1bc99d-5d8f-4aba-ab9c-8050219bd9eb' OR program_id = 186;

-- Program 15: ID 193 - Eastern Band of Cherokee Indians Casino Revenue Fund
UPDATE programs
SET
  name = 'Eastern Band of Cherokee Indians Casino Revenue Fund',
  organization = 'Eastern Band of Cherokee Indians (EBCI)',
  description = 'The Eastern Band of Cherokee Indians Casino Revenue Fund is a sovereign per-capita dividend program established in 1996 in Western North Carolina. Funded by 50% of the net gaming revenues from tribal gaming enterprises on the Qualla Boundary, the tribe distributes equal bi-annual dividends (averaging $3,500–$6,000+ twice yearly, or ~$500–$1,000 monthly) unconditionally to all enrolled tribal members, with minors'' shares deposited into trust accounts until adulthood.',
  amount_description = '$3,500 – $6,000 bi-annually (~$500–$1,000/month equivalent; $7,000–$12,000+ annually)',
  monthly_amount_usd = 500,
  currency = 'USD',
  eligibility = 'Enrolled members of the Eastern Band of Cherokee Indians (EBCI). Distributions are unconditional for adult members; minors'' distributions are safeguarded in an investment trust until age 18 or high school completion.',
  website = 'https://ebci.gov',
  apply_url = 'https://ebci.gov',
  data_source = 'stanford_basic_income_lab',
  stanford_experiment_id = 102,
  payout_status = 'Ongoing sovereign per-capita distributions issued bi-annually since 1996',
  application_status = 'Automatic enrollment for all verified enrolled tribal members of the EBCI',
  sources = ARRAY[
    'https://ebci.gov',
    'https://basicincome.stanford.edu/research/basic-income-experiments/',
    'https://guaranteedincome.us/pilots'
  ],
  available_regions = ARRAY['United States'],
  required_states = ARRAY['North Carolina'],
  state_province = 'North Carolina',
  municipalities = ARRAY['Cherokee', 'Qualla Boundary', 'Swain County', 'Jackson County'],
  latitude = 35.4843,
  longitude = -83.3207,
  total_participants = 15414,
  status = 'active',
  updated_date = NOW()
WHERE id = 'b01981b1-2e99-4d3b-9110-5bc830638cc0' OR program_id = 193;
