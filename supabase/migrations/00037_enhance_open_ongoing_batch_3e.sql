-- Migration 00037: Review and enhance Phase 3 Open Ongoing programs - Batch 3E (final 15 programs)
-- Programs: 194, 204, 209, 219, 226, 241, 244, 259, 273, 276, 277, 313, 320, 337, 344

-- Program 1: ID 194 - EBCI GenWell Program
UPDATE programs
SET
  name = 'EBCI GenWell Program',
  organization = 'Eastern Band of Cherokee Indians (EBCI)',
  description = 'The EBCI GenWell (Generational Wellness) Program is a guaranteed basic income and targeted economic security initiative launched in 2025 by the Eastern Band of Cherokee Indians on the Qualla Boundary in Western North Carolina. GenWell provides monthly unconditional cash payments of up to $800 to enrolled tribal citizens to strengthen generational financial resilience, support families, and build on the tribe''s long-standing dividend models.',
  amount_description = 'Up to $800 monthly unconditional economic security transfer',
  monthly_amount_usd = 800,
  currency = 'USD',
  eligibility = 'Enrolled members of the Eastern Band of Cherokee Indians (EBCI) meeting tribal program guidelines on the Qualla Boundary.',
  website = 'https://ebci.gov',
  apply_url = 'https://ebci.gov',
  data_source = 'stanford_basic_income_lab',
  stanford_experiment_id = 103,
  payout_status = 'Active monthly disbursements continuing through tribal administration',
  application_status = 'Open to enrolled tribal citizens via EBCI community services',
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
  status = 'active',
  updated_date = NOW()
WHERE id = '101ea99f-0a2e-42f3-b82e-2d341cab3271' OR program_id = 194;

-- Program 2: ID 204 - Champaign County Guaranteed Income Project
UPDATE programs
SET
  name = 'Champaign County Guaranteed Income Project (CCGIP)',
  organization = 'University of Illinois Urbana-Champaign School of Social Work & ROE #9',
  description = 'The Champaign County Guaranteed Income Project (CCGIP) is an innovative demonstration and proof-of-concept study led by researchers at the University of Illinois Urbana-Champaign School of Social Work in partnership with the Champaign/Ford Regional Office of Education. Funded through the Chancellor''s Call to Action initiative, the project provides $750 per month in unconditional cash to housing-insecure families with school-age children under the McKinney-Vento Act.',
  amount_description = '$750 per month unconditional basic income transfer',
  monthly_amount_usd = 750,
  currency = 'USD',
  eligibility = 'Housing-insecure and homeless families with school-age children in Champaign County, Illinois identified under the federal McKinney-Vento Homeless Assistance Act.',
  website = 'https://socialwork.illinois.edu',
  apply_url = 'https://socialwork.illinois.edu',
  data_source = 'stanford_basic_income_lab',
  stanford_experiment_id = 113,
  payout_status = 'Active demonstration disbursements and research tracking through 2026',
  application_status = 'Closed; cohort enrolled through regional school district liaisons',
  sources = ARRAY[
    'https://socialwork.illinois.edu',
    'https://basicincome.stanford.edu/research/basic-income-experiments/',
    'https://guaranteedincome.us/pilots'
  ],
  available_regions = ARRAY['United States'],
  required_states = ARRAY['Illinois'],
  state_province = 'Illinois',
  municipalities = ARRAY['Champaign County', 'Urbana', 'Champaign'],
  latitude = 40.1164,
  longitude = -88.2434,
  total_participants = 10,
  status = 'active',
  updated_date = NOW()
WHERE id = '61284131-105b-4384-8747-a4a19837ddeb' OR program_id = 204;

-- Program 3: ID 209 - Family Goal Fund — Chicago, IL
UPDATE programs
SET
  name = 'Family Goal Fund — Chicago, IL',
  organization = 'LIFT',
  description = 'The Family Goal Fund — Chicago is an unrestricted cash transfer program operating within LIFT''s two-generation coaching model in Chicago, Illinois. Low-income parents and primary caregivers partnering with LIFT receive $150 every three months ($50/month equivalent; $1,200 over two years) alongside personal coaching to reduce material stress, support emergency needs, and foster long-term educational and career progress.',
  amount_description = '$150 disbursed quarterly ($50/month equivalent; $1,200 total over 2 years)',
  monthly_amount_usd = 50,
  currency = 'USD',
  eligibility = 'Low-income parents and primary caregivers of young children under age eight enrolled in LIFT''s two-year coaching program in Chicago, Illinois.',
  website = 'https://www.liftcommunities.org',
  apply_url = 'https://www.liftcommunities.org',
  data_source = 'stanford_basic_income_lab',
  stanford_experiment_id = 23,
  payout_status = 'Ongoing quarterly disbursements to participating cohort families',
  application_status = 'Open to eligible parents enrolling in LIFT coaching cohorts in Chicago',
  sources = ARRAY[
    'https://www.liftcommunities.org',
    'https://basicincome.stanford.edu/research/basic-income-experiments/',
    'https://guaranteedincome.us/pilots'
  ],
  available_regions = ARRAY['United States'],
  required_states = ARRAY['Illinois'],
  state_province = 'Illinois',
  municipalities = ARRAY['Chicago', 'Cook County'],
  latitude = 41.8781,
  longitude = -87.6298,
  total_participants = 800,
  status = 'active',
  updated_date = NOW()
WHERE id = '6ad0b828-b3d1-4df2-8a16-c0349446e66a' OR program_id = 209;

-- Program 4: ID 219 - Baby's First Years — Louisiana
UPDATE programs
SET
  name = 'Baby''s First Years — Louisiana',
  organization = 'Teachers College, Columbia University & Baby''s First Years Consortium',
  description = 'Baby''s First Years — Louisiana is the New Orleans study site of the groundbreaking multi-site randomized controlled trial testing the causal impact of unconditional cash transfers on young children''s brain development, health, and family well-being. Mothers recruited shortly after childbirth in New Orleans hospitals are randomized to receive either $333/month (high cash gift) or $20/month (nominal gift) for the first several years of the child''s life.',
  amount_description = '$20 or $333 monthly unconditional cash transfer on reloadable debit cards',
  monthly_amount_usd = 333,
  currency = 'USD',
  eligibility = 'Low-income birthing mothers with incomes below federal poverty guidelines recruited in hospital postpartum wards in the Greater New Orleans area at the time of childbirth.',
  website = 'https://www.babysfirstyears.com/',
  apply_url = 'https://www.babysfirstyears.com/',
  data_source = 'stanford_basic_income_lab',
  stanford_experiment_id = 130,
  payout_status = 'Active multi-year study disbursements and developmental follow-up evaluations',
  application_status = 'Closed; cohort randomized at birth across study hospital sites',
  sources = ARRAY[
    'https://www.babysfirstyears.com/',
    'https://basicincome.stanford.edu/research/basic-income-experiments/',
    'https://guaranteedincome.us/pilots',
    'https://www.med.upenn.edu/cgir/research.html'
  ],
  available_regions = ARRAY['United States'],
  required_states = ARRAY['Louisiana'],
  state_province = 'Louisiana',
  municipalities = ARRAY['New Orleans', 'Orleans Parish', 'Jefferson Parish'],
  latitude = 29.9511,
  longitude = -90.0715,
  total_participants = 1000,
  is_rct = true,
  status = 'active',
  updated_date = NOW()
WHERE id = '6cdcdc16-395b-4ba2-b77c-4340c86b9360' OR program_id = 219;

-- Program 5: ID 226 - Striving Towards Economic Prosperity (STEP)
UPDATE programs
SET
  name = 'Striving Towards Economic Prosperity (STEP)',
  organization = 'United South End Settlements (USES)',
  description = 'Striving Towards Economic Prosperity (STEP) is an unconditional guaranteed income initiative administered by United South End Settlements (USES) in Boston, Massachusetts. Rooted in the belief that "families know best," STEP provides $800–$850 per month in direct, unrestricted cash for 18 months to low-income families connected to USES programs, paired with financial coaching and community supports to foster wealth-building and children''s enrichment.',
  amount_description = '$800 – $850 per month for 18 months ($15,000+ total unconditional cash)',
  monthly_amount_usd = 850,
  currency = 'USD',
  eligibility = 'Low-income families residing in Boston (South End, Lower Roxbury, and adjacent neighborhoods) earning at or below 50% Area Median Income (AMI) connected to USES programming.',
  website = 'https://www.uses.org',
  apply_url = 'https://www.uses.org',
  data_source = 'stanford_basic_income_lab',
  stanford_experiment_id = 138,
  payout_status = 'Ongoing cohort disbursements and program evaluation in Boston',
  application_status = 'Open by cohort selection to families engaged with USES services',
  sources = ARRAY[
    'https://www.uses.org',
    'https://basicincome.stanford.edu/research/basic-income-experiments/',
    'https://guaranteedincome.us/pilots'
  ],
  available_regions = ARRAY['United States'],
  required_states = ARRAY['Massachusetts'],
  state_province = 'Massachusetts',
  municipalities = ARRAY['Boston', 'South End', 'Roxbury'],
  latitude = 42.3424,
  longitude = -71.0744,
  total_participants = 32,
  status = 'active',
  updated_date = NOW()
WHERE id = '9f130444-8b03-404a-b797-d2da80b7139b' OR program_id = 226;

-- Program 6: ID 241 - CollegeBound Boost
UPDATE programs
SET
  name = 'CollegeBound Boost',
  organization = 'City of Saint Paul Office of Financial Empowerment',
  description = 'CollegeBound Boost is a guaranteed income and asset-building demonstration launched by Mayor Melvin Carter and the City of Saint Paul Office of Financial Empowerment. The program pairs 333 low-income families with $500 per month in unconditional cash for 24 months ($12,000 total) alongside a $1,000 initial bonus deposit into the child''s CollegeBound Saint Paul 529 college savings account, evaluated in partnership with the University of Pennsylvania CGIR.',
  amount_description = '$500 monthly for 24 months ($12,000 total) + $1,000 college savings bonus',
  monthly_amount_usd = 500,
  currency = 'USD',
  eligibility = 'Low-income Saint Paul families enrolled in CollegeBound Saint Paul with household incomes at or below 300% of the federal poverty level.',
  website = 'https://www.stpaul.gov/departments/financial-empowerment',
  apply_url = 'https://www.stpaul.gov/departments/financial-empowerment',
  data_source = 'stanford_basic_income_lab',
  stanford_experiment_id = 155,
  payout_status = 'Active monthly disbursements and college savings tracking through 2026',
  application_status = 'Closed; random selection from eligible CollegeBound Saint Paul accounts',
  sources = ARRAY[
    'https://www.stpaul.gov/departments/financial-empowerment',
    'https://basicincome.stanford.edu/research/basic-income-experiments/',
    'https://guaranteedincome.us/pilots'
  ],
  available_regions = ARRAY['United States'],
  required_states = ARRAY['Minnesota'],
  state_province = 'Minnesota',
  municipalities = ARRAY['Saint Paul', 'Ramsey County'],
  latitude = 44.9537,
  longitude = -93.0900,
  total_participants = 333,
  status = 'active',
  updated_date = NOW()
WHERE id = '9b662363-23df-424d-8ff7-164fe514c33c' OR program_id = 241;

-- Program 7: ID 244 - Baby's First Years — Minnesota
UPDATE programs
SET
  name = 'Baby''s First Years — Minnesota',
  organization = 'Teachers College, Columbia University & Baby''s First Years Consortium',
  description = 'Baby''s First Years — Minnesota is the Twin Cities (Minneapolis and Saint Paul) study site of the multi-site randomized controlled trial testing the effects of poverty reduction on early child brain development. Low-income mothers enrolled after giving birth in Twin Cities hospitals are randomized to receive either $333/month (high cash gift) or $20/month (nominal gift) via reloadable debit cards during the first several years of life.',
  amount_description = '$20 or $333 monthly unconditional cash transfer on reloadable debit cards',
  monthly_amount_usd = 333,
  currency = 'USD',
  eligibility = 'Low-income birthing mothers with incomes below federal poverty guidelines recruited in hospital postpartum units in Minneapolis and Saint Paul, MN.',
  website = 'https://www.babysfirstyears.com/',
  apply_url = 'https://www.babysfirstyears.com/',
  data_source = 'stanford_basic_income_lab',
  stanford_experiment_id = 159,
  payout_status = 'Active multi-year study disbursements and neurodevelopmental follow-ups',
  application_status = 'Closed; cohort randomized at birth across participating Twin Cities hospitals',
  sources = ARRAY[
    'https://www.babysfirstyears.com/',
    'https://basicincome.stanford.edu/research/basic-income-experiments/',
    'https://guaranteedincome.us/pilots',
    'https://www.med.upenn.edu/cgir/research.html'
  ],
  available_regions = ARRAY['United States'],
  required_states = ARRAY['Minnesota'],
  state_province = 'Minnesota',
  municipalities = ARRAY['Minneapolis', 'Saint Paul', 'Hennepin County', 'Ramsey County'],
  latitude = 44.9778,
  longitude = -93.2650,
  total_participants = 1000,
  is_rct = true,
  status = 'active',
  updated_date = NOW()
WHERE id = '0873eb83-dac7-47bc-a9b1-923ce4dd31df' OR program_id = 244;

-- Program 8: ID 259 - Baby's First Years — Nebraska
UPDATE programs
SET
  name = 'Baby''s First Years — Nebraska',
  organization = 'Teachers College, Columbia University & Baby''s First Years Consortium',
  description = 'Baby''s First Years — Nebraska is the Greater Omaha study site of the landmark randomized controlled trial investigating whether monthly unconditional cash transfers in early childhood alter brain development and socioemotional outcomes. Postpartum mothers in Omaha hospitals are randomized to receive either $333/month (high cash gift) or $20/month (nominal gift) on reloadable cards for the child''s earliest years.',
  amount_description = '$20 or $333 monthly unconditional cash transfer on reloadable debit cards',
  monthly_amount_usd = 333,
  currency = 'USD',
  eligibility = 'Low-income birthing mothers with incomes below federal poverty guidelines recruited in hospital postpartum wards across the Omaha, Nebraska metropolitan area.',
  website = 'https://www.babysfirstyears.com/',
  apply_url = 'https://www.babysfirstyears.com/',
  data_source = 'stanford_basic_income_lab',
  stanford_experiment_id = 174,
  payout_status = 'Active multi-year study disbursements and pediatric assessments',
  application_status = 'Closed; cohort randomized at birth across Omaha hospital partners',
  sources = ARRAY[
    'https://www.babysfirstyears.com/',
    'https://basicincome.stanford.edu/research/basic-income-experiments/',
    'https://guaranteedincome.us/pilots',
    'https://www.med.upenn.edu/cgir/research.html'
  ],
  available_regions = ARRAY['United States'],
  required_states = ARRAY['Nebraska'],
  state_province = 'Nebraska',
  municipalities = ARRAY['Omaha', 'Douglas County'],
  latitude = 41.2565,
  longitude = -95.9345,
  total_participants = 1000,
  is_rct = true,
  status = 'active',
  updated_date = NOW()
WHERE id = '06f4920c-8c68-41bf-aa79-70dcad853618' OR program_id = 259;

-- Program 9: ID 273 - HudsonUP
UPDATE programs
SET
  name = 'HudsonUP',
  organization = 'The Spark of Hudson & Jain Family Institute (JFI)',
  description = 'HudsonUP is the first small-city guaranteed basic income pilot in the United States, established in Hudson, New York in November 2020 by The Spark of Hudson in partnership with the Jain Family Institute (JFI) and Greater Hudson Promise Neighborhood. HudsonUP provides $500 per month in unconditional cash for five full years ($30,000 total) to 75 low-income residents, tracking long-term economic mobility and well-being.',
  amount_description = '$500 per month for 5 years ($30,000 total unconditional cash)',
  monthly_amount_usd = 500,
  currency = 'USD',
  eligibility = 'Hudson residents aged 18 and older earning below $35,000 annually, selected through a community lottery.',
  website = 'https://hudsonup.org/',
  apply_url = 'https://hudsonup.org/',
  data_source = 'stanford_basic_income_lab',
  stanford_experiment_id = 190,
  payout_status = 'Active 5-year cash payments ongoing through September 2026',
  application_status = 'Closed; cohorts established and receiving ongoing disbursements',
  sources = ARRAY[
    'https://hudsonup.org/',
    'https://basicincome.stanford.edu/research/basic-income-experiments/',
    'https://guaranteedincome.us/pilots'
  ],
  available_regions = ARRAY['United States'],
  required_states = ARRAY['New York'],
  state_province = 'New York',
  municipalities = ARRAY['Hudson', 'Columbia County'],
  latitude = 42.2529,
  longitude = -73.7910,
  total_participants = 75,
  status = 'active',
  updated_date = NOW()
WHERE id = 'c47e0ef8-9553-4194-803c-b68778a9253c' OR program_id = 273;

-- Program 10: ID 276 - Family Goal Fund — New York, NY
UPDATE programs
SET
  name = 'Family Goal Fund — New York, NY',
  organization = 'LIFT',
  description = 'The Family Goal Fund — New York is an unrestricted cash transfer program integrated into LIFT''s two-generation coaching model in New York City. Low-income parents and primary caregivers partnering with LIFT receive $150 every three months ($50/month equivalent; $1,200 over two years) alongside personal coaching to alleviate immediate financial constraints, cover essential child costs, and achieve career mobility goals.',
  amount_description = '$150 disbursed quarterly ($50/month equivalent; $1,200 total over 2 years)',
  monthly_amount_usd = 50,
  currency = 'USD',
  eligibility = 'Low-income parents and primary caregivers of young children under age eight enrolled in LIFT''s two-year coaching program in New York City.',
  website = 'https://www.liftcommunities.org',
  apply_url = 'https://www.liftcommunities.org',
  data_source = 'stanford_basic_income_lab',
  stanford_experiment_id = 23,
  payout_status = 'Ongoing quarterly disbursements to enrolled cohort families',
  application_status = 'Open to eligible parents enrolling in LIFT coaching cohorts in NYC',
  sources = ARRAY[
    'https://www.liftcommunities.org',
    'https://basicincome.stanford.edu/research/basic-income-experiments/',
    'https://guaranteedincome.us/pilots'
  ],
  available_regions = ARRAY['United States'],
  required_states = ARRAY['New York'],
  state_province = 'New York',
  municipalities = ARRAY['New York City', 'Bronx', 'Brooklyn', 'Manhattan'],
  latitude = 40.7128,
  longitude = -74.0060,
  total_participants = 800,
  status = 'active',
  updated_date = NOW()
WHERE id = 'a5fa8600-6bec-47be-9f7c-7285669f7884' OR program_id = 276;

-- Program 11: ID 277 - Baby's First Years — New York
UPDATE programs
SET
  name = 'Baby''s First Years — New York',
  organization = 'Teachers College, Columbia University & Baby''s First Years Consortium',
  description = 'Baby''s First Years — New York is the New York City study site of the seminal randomized controlled trial testing the neurodevelopmental and socioeconomic effects of unconditional cash transfers on young children. Low-income mothers recruited in New York City hospitals after childbirth are randomized to receive either $333/month (high cash gift) or $20/month (nominal gift) via debit cards through the child''s first four to five years.',
  amount_description = '$20 or $333 monthly unconditional cash transfer on reloadable debit cards',
  monthly_amount_usd = 333,
  currency = 'USD',
  eligibility = 'Low-income birthing mothers with incomes below federal poverty guidelines recruited in hospital postpartum units across New York City at the time of delivery.',
  website = 'https://www.babysfirstyears.com/',
  apply_url = 'https://www.babysfirstyears.com/',
  data_source = 'stanford_basic_income_lab',
  stanford_experiment_id = 194,
  payout_status = 'Active multi-year study disbursements and developmental assessments',
  application_status = 'Closed; cohort randomized at birth across participating New York City hospitals',
  sources = ARRAY[
    'https://www.babysfirstyears.com/',
    'https://basicincome.stanford.edu/research/basic-income-experiments/',
    'https://guaranteedincome.us/pilots',
    'https://www.med.upenn.edu/cgir/research.html'
  ],
  available_regions = ARRAY['United States'],
  required_states = ARRAY['New York'],
  state_province = 'New York',
  municipalities = ARRAY['New York City'],
  latitude = 40.7128,
  longitude = -74.0060,
  total_participants = 1000,
  is_rct = true,
  status = 'active',
  updated_date = NOW()
WHERE id = '1d3474e1-a342-49ac-b221-528d89642e77' OR program_id = 277;

-- Program 12: ID 313 - The Nest (Hummingbird Indigenous Family Services)
UPDATE programs
SET
  name = 'The Nest (Hummingbird Indigenous Guaranteed Basic Income)',
  organization = 'Hummingbird Indigenous Family Services',
  description = 'The Nest is the first guaranteed basic income program in the United States created exclusively for Indigenous families, launched in July 2023 by Hummingbird Indigenous Family Services. The program provides $1,250 per month in unconditional cash from pregnancy until the child''s third birthday (up to $45,000 total) to 150 Indigenous families in King County, Pierce County, and the Tulalip Reservation in Washington State.',
  amount_description = '$1,250 per month from pregnancy until age 3 (up to 36 months; up to $45,000 total)',
  monthly_amount_usd = 1250,
  currency = 'USD',
  eligibility = 'Pregnant individuals who identify as Indigenous (American Indian, Alaska Native, Native Hawaiian, or Pacific Islander) at least 12 weeks pregnant, planning to parent, residing in King County, Pierce County, or the Tulalip Reservation.',
  website = 'https://hummingbird-ifs.org/programs/nest/the-nest',
  apply_url = 'https://hummingbird-ifs.org/programs/nest/the-nest',
  data_source = 'stanford_basic_income_lab',
  stanford_experiment_id = 234,
  payout_status = 'Active monthly payments continuing through child age three (2023–2027)',
  application_status = 'Closed; initial cohort of 150 families fully enrolled',
  sources = ARRAY[
    'https://hummingbird-ifs.org/programs/nest/the-nest',
    'https://basicincome.stanford.edu/research/basic-income-experiments/',
    'https://guaranteedincome.us/pilots'
  ],
  available_regions = ARRAY['United States'],
  required_states = ARRAY['Washington'],
  state_province = 'Washington',
  municipalities = ARRAY['King County', 'Pierce County', 'Seattle', 'Tulalip Reservation'],
  latitude = 47.6062,
  longitude = -122.3321,
  total_participants = 150,
  status = 'active',
  updated_date = NOW()
WHERE id = 'a59106f8-c803-4690-bd7e-b4211127eb1a' OR program_id = 313;

-- Program 13: ID 320 - Novissi
UPDATE programs
SET
  name = 'Novissi',
  organization = 'Government of Togo (Ministry of Digital Economy and Transformation)',
  description = 'Novissi is Togo''s landmark digital cash transfer program launched by the Government of Togo in April 2020. Using machine learning, satellite imagery, and mobile phone metadata developed in collaboration with UC Berkeley and GiveDirectly, Novissi delivered unconditional monthly cash transfers of 10,500–12,250 CFA francs (~$17–$20 USD) via mobile money (T-Money / Flooz) to over 819,000 vulnerable informal workers across Togo.',
  amount_description = '10,500 – 12,250 CFA francs monthly (~$17–$20 USD) distributed via mobile money',
  monthly_amount_usd = 20,
  currency = 'XOF',
  eligibility = 'Informal workers and vulnerable citizens in Togo residing in pandemic-affected districts or identified via algorithmic targeting based on mobile and satellite poverty indicators.',
  website = 'https://www.povertyactionlab.org/evaluation/targeting-humanitarian-aid-machine-learning-during-covid-19-pandemic-togo',
  apply_url = 'https://www.povertyactionlab.org/evaluation/targeting-humanitarian-aid-machine-learning-during-covid-19-pandemic-togo',
  data_source = 'stanford_basic_income_lab',
  stanford_experiment_id = 242,
  payout_status = 'National mobile cash transfers disbursed to over 819,000 recipients; platform retained for emergency shock-responsive social protection',
  application_status = 'Accessed via national mobile USSD registration (*855#) on Togolese mobile networks',
  sources = ARRAY[
    'https://www.povertyactionlab.org/evaluation/targeting-humanitarian-aid-machine-learning-during-covid-19-pandemic-togo',
    'https://cega.berkeley.edu/research/togo-covid-19-machine-learning/',
    'https://basicincome.stanford.edu/research/basic-income-experiments/',
    'https://guaranteedincome.us/pilots'
  ],
  available_regions = ARRAY['Togo'],
  required_states = ARRAY[]::text[],
  state_province = 'National',
  municipalities = ARRAY['Lomé', 'Maritime Region', 'Plateaux', 'Centrale', 'Kara', 'Savanes'],
  latitude = 6.1375,
  longitude = 1.2125,
  total_participants = 819972,
  status = 'active',
  updated_date = NOW()
WHERE id = '9c7c34a9-342d-4151-b658-020c6344b0f0' OR program_id = 320;

-- Program 14: ID 337 - Kalaignar Magalir Urimai Thogai Thittam
UPDATE programs
SET
  name = 'Kalaignar Magalir Urimai Thogai Thittam (Women''s Basic Income Scheme)',
  organization = 'Government of Tamil Nadu',
  description = 'The Kalaignar Magalir Urimai Thogai Thittam is a historic basic income scheme launched in September 2023 by Chief Minister M.K. Stalin and the Government of Tamil Nadu, India. Providing ₹1,000 INR (~$12 USD) per month directly into the bank accounts of over 11.5 million women heads of households, the scheme formally recognizes and compensates women''s unpaid labor and constitutes one of the largest basic income transfers in world history.',
  amount_description = '₹1,000 INR monthly (~$12 USD) direct benefit transfer (DBT) to bank accounts',
  monthly_amount_usd = 12,
  currency = 'INR',
  eligibility = 'Women heads of households in Tamil Nadu aged 21 and older, whose family annual income is below ₹2.5 lakh, landholdings are under 5 acres (wetland) or 10 acres (dryland), and electricity consumption is under 3,600 units/year.',
  website = 'https://kmut.tn.gov.in',
  apply_url = 'https://kmut.tn.gov.in',
  data_source = 'stanford_basic_income_lab',
  stanford_experiment_id = 263,
  payout_status = 'Active monthly direct bank transfers paid to over 11.5 million women across Tamil Nadu',
  application_status = 'Open via e-Sevai service centers and district social welfare camps',
  sources = ARRAY[
    'https://kmut.tn.gov.in',
    'https://basicincome.stanford.edu/research/basic-income-experiments/',
    'https://guaranteedincome.us/pilots'
  ],
  available_regions = ARRAY['India'],
  required_states = ARRAY[]::text[],
  state_province = 'Tamil Nadu',
  municipalities = ARRAY['Chennai', 'Coimbatore', 'Madurai', 'Tiruchirappalli', 'Salem'],
  latitude = 13.0827,
  longitude = 80.2707,
  total_participants = 11500000,
  status = 'active',
  updated_date = NOW()
WHERE id = '67295a38-bcb0-4ae5-be26-73c0edf0d7a3' OR program_id = 337;

-- Program 15: ID 344 - Strengthening Abilities and Journeys of Empowerment (SAJE) / Agreements with Young Adults
UPDATE programs
SET
  name = 'Strengthening Abilities and Journeys of Empowerment (SAJE) / Agreements with Young Adults',
  organization = 'Government of British Columbia (Ministry of Children and Family Development)',
  description = 'British Columbia''s SAJE (Strengthening Abilities and Journeys of Empowerment) program, which expanded and transitioned the former Agreements with Young Adults (AYA) program, provides comprehensive financial and living support to young adults transitioning out of government care up to age 27. The program provides up to CAD $1,250 per month (~$925 USD) in unconditional monthly living income support to youth ages 19–20 and continuing supports through age 27.',
  amount_description = 'Up to CAD $1,250 monthly (~$925 USD) unconditional living support',
  monthly_amount_usd = 925,
  currency = 'CAD',
  eligibility = 'Young adults in British Columbia aged 19 to 27 who have reached adulthood while in the care of the Ministry of Children and Family Development or an Indigenous Child and Family Service Agency.',
  website = 'https://www.gov.bc.ca/SAJE',
  apply_url = 'https://www.gov.bc.ca/SAJE',
  data_source = 'stanford_basic_income_lab',
  stanford_experiment_id = 272,
  payout_status = 'Ongoing monthly living support transfers issued directly to eligible young adults',
  application_status = 'Open via SAJE Navigators and online application at sajeonline.gov.bc.ca',
  sources = ARRAY[
    'https://www.gov.bc.ca/SAJE',
    'https://basicincome.stanford.edu/research/basic-income-experiments/',
    'https://guaranteedincome.us/pilots'
  ],
  available_regions = ARRAY['Canada'],
  required_states = ARRAY['British Columbia'],
  state_province = 'British Columbia',
  municipalities = ARRAY['Vancouver', 'Victoria', 'Surrey', 'Burnaby', 'Kelowna'],
  latitude = 48.4284,
  longitude = -123.3656,
  status = 'active',
  updated_date = NOW()
WHERE id = '36fd507e-96e3-4f05-9a42-579cf85173a8' OR program_id = 344;
