-- ============================================================================
-- Migration 00033: Review and enhance Phase 3 Open, Ongoing programs - Batch 3A (15 programs)
-- IDs: 6, 18, 5, 363, 370, 377, 360, 361, 364, 146, 369, 371, 368, 374, 331
-- ============================================================================

-- 1. Preserving Our Diversity (ID: 6)
UPDATE public.programs
SET
  organization = 'City of Santa Monica Housing Authority',
  description = 'Preserving Our Diversity (POD) is an innovative municipal guaranteed income program created by the City of Santa Monica to safeguard housing stability for low-income, long-term senior renters residing in rent-controlled apartments. The program provides monthly unrestricted cash subsidies—up to $939 per month (benchmarking an average ~$700/month)—designed to bridge the gap between housing costs and living expenses so that seniors have sufficient residual after-rent income for essentials like nutrition, prescriptions, and healthcare.',
  eligibility = '• Age 65 or older
• Reside in the City of Santa Monica, California
• Resided in current rent-controlled apartment continuously since before January 1, 2000
• Household annual income at or below 50% Area Median Income (AMI; e.g., $44,150 for an individual)
• Total household liquid assets under $30,000 (excluding qualified retirement accounts)
• Rent burden exceeding 30% of gross household income',
  amount_description = 'Sliding monthly cash stipend up to $939 per month (average ~$700/mo) based on household rent gap',
  monthly_amount_usd = 700.00,
  currency = 'USD',
  website = 'https://www.santamonica.gov/housing-pod',
  apply_url = 'https://www.santamonica.gov/housing-pod',
  sources = ARRAY[
    'https://www.santamonica.gov/housing-pod',
    'https://www.santamonica.gov/housing-pod-faqs'
  ]::text[],
  payout_status = 'Ongoing active monthly direct deposits for enrolled participants',
  application_status = 'Accepting applications; waitlist and intake processed by Housing Authority',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'municipal_government',
  involvement_level = 'external_self_apply',
  stanford_experiment_id = 72,
  data_source = 'stanford_basic_income_lab'
WHERE program_id = 6;

-- 2. Mein Grundeinkommen Basic Income Raffle (ID: 18)
UPDATE public.programs
SET
  organization = 'Mein Grundeinkommen e.V.',
  description = 'Mein Grundeinkommen (My Basic Income) is a globally recognized non-profit initiative founded in Berlin in 2014 by Michael Bohmeyer. Funded entirely by over 200,000 monthly micro-donors, the organization crowdfunds unconditional basic incomes of €1,000 per month (approx. $1,100 USD/month) for one full year (€12,000 total) and awards them through regular, free public lotteries to registered individuals worldwide. The initiative operates with zero behavioral conditions, means tests, or spending restrictions, while conducting rigorous empirical research with the German Institute for Economic Research (DIW Berlin).',
  eligibility = '• Registered personal profile on Mein Grundeinkommen platform
• Must confirm ticket participation for the active open raffle draw
• Open universally to individuals worldwide regardless of nationality, employment status, or income
• Strictly unconditional: zero work requirements, spending oversight, or clawback provisions',
  amount_description = '€1,000 per month (~$1,100 USD) unconditionally for 12 months (€12,000 total package)',
  monthly_amount_usd = 1100.00,
  currency = 'EUR',
  website = 'https://www.mein-grundeinkommen.de/',
  apply_url = 'https://www.mein-grundeinkommen.de/',
  sources = ARRAY[
    'https://www.mein-grundeinkommen.de/',
    'https://basicincome.stanford.edu/research/basic-income-experiments/'
  ]::text[],
  payout_status = 'Ongoing active monthly distributions to current awardees',
  application_status = 'Accepting free registrations for upcoming monthly raffle drawings',
  distribution_type = 'lottery_raffle',
  payout_rail = 'direct_deposit',
  funding_source = 'community_crowdfund',
  involvement_level = 'external_self_apply',
  stanford_experiment_id = 266,
  data_source = 'stanford_basic_income_lab'
WHERE program_id = 18;

-- 3. Rx Kids (ID: 5)
UPDATE public.programs
SET
  organization = 'Michigan State University Pediatric Public Health Initiative & GiveDirectly',
  description = 'Rx Kids is the first citywide and expanding statewide maternal-infant cash prescription program in the United States, led by pediatrician Dr. Mona Hanna-Attisha at Michigan State University in partnership with GiveDirectly. Operating in Flint, Kalamazoo, Dearborn, Pontiac, and other Michigan communities, Rx Kids provides unconditional direct cash to every expectant mother and newborn without means-testing or bureaucratic friction: a $1,500 prenatal cash grant during the second trimester followed by $500 per month for the child''s first year ($7,500 total package), targeting maternal health and child poverty.',
  eligibility = '• Resident of an officially participating Michigan community (e.g. Flint, Kalamazoo, Dearborn, Pontiac)
• Expectant mother at least 20 weeks pregnant, or legal guardian caring for an infant born within the community enrollment window
• Universal eligibility within designated municipal boundaries regardless of household income
• Submission of pregnancy confirmation or child birth documentation via AidKit portal',
  amount_description = '$1,500 prenatal lump sum plus $500/month for infant''s first 12 months (up to $7,500 total package)',
  monthly_amount_usd = 500.00,
  currency = 'USD',
  website = 'https://rxkids.org/',
  apply_url = 'https://rxkids.aidkit.org/',
  sources = ARRAY[
    'https://rxkids.org/',
    'https://rxkids.org/communities/',
    'https://rxkids.aidkit.org/'
  ]::text[],
  payout_status = 'Ongoing monthly distributions via direct deposit or prepaid debit card',
  application_status = 'Accepting applications across active participating Michigan communities',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  stanford_experiment_id = 151,
  data_source = 'stanford_basic_income_lab'
WHERE program_id = 5;

-- 4. Child Benefit (United Kingdom) (ID: 363)
UPDATE public.programs
SET
  organization = 'HM Revenue & Customs (HMRC)',
  description = 'United Kingdom Child Benefit is a foundational national universal demogrant administered by HM Revenue & Customs. Paid every 4 weeks directly to parents or primary guardians, the benefit provides £25.60 per week for the eldest or only child (~£111 monthly, ~$145 USD) and £16.95 per week for each subsequent child (~£73.45 monthly, ~$96 USD), with no cap on the number of children. The benefit is payable for all children living in the UK until age 16 (or up to age 20 if enrolled in approved full-time secondary or non-advanced education).',
  eligibility = '• Primary caregiver responsible for a child under 16 (or under 20 in approved full-time education or training)
• Child must reside in the United Kingdom
• Claimant must live in the UK and satisfy the right-to-reside condition
• Open to all households regardless of employment status (high-income earners over £60,000 repay via income tax charge)',
  amount_description = '£25.60/week (£102.40/4-wks, ~$145/mo) for eldest/only child; £16.95/week (£67.80/4-wks, ~$96/mo) per additional child',
  monthly_amount_usd = 145.00,
  currency = 'GBP',
  website = 'https://www.gov.uk/child-benefit',
  apply_url = 'https://www.gov.uk/child-benefit',
  sources = ARRAY[
    'https://www.gov.uk/child-benefit',
    'https://www.gov.uk/child-benefit/what-youll-get'
  ]::text[],
  payout_status = 'Active routine payments delivered every 4 weeks (or weekly for eligible claimants)',
  application_status = 'Accepting applications via HMRC online portal or postal claim form CH2',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  data_source = 'government_sites'
WHERE program_id = 363;

-- 5. Allocation Familiale (Luxembourg Universal Child Allowance) (ID: 370)
UPDATE public.programs
SET
  organization = 'Caisse pour l''avenir des enfants (CAE / Zukunftskeess)',
  description = 'Luxembourg''s Allocation Familiale is a premier universal child demogrant administered by the Caisse pour l''avenir des enfants (CAE / Zukunftskeess). Every resident child in Luxembourg (or child of cross-border commuters affiliated with the Luxembourg social security system) receives a flat-rate universal monthly allowance of €299.86 (~$325 USD). The benefit includes age-based increases (+€22.61/mo from age 6, +€56.57/mo from age 12) and is paid unconditionally from birth until age 18, extendable up to age 25 for students in secondary or vocational education.',
  eligibility = '• Child legally resident in the Grand Duchy of Luxembourg, OR child of a parent affiliated with Luxembourg social security (cross-border workers)
• Under age 18 (extendable to age 25 for children in continuous secondary or vocational education)
• Universal non-means-tested benefit: zero household income thresholds',
  amount_description = '€299.86 monthly baseline per child (~$325 USD), plus age supplements (+€22.61 at age 6, +€56.57 at age 12)',
  monthly_amount_usd = 325.00,
  currency = 'EUR',
  website = 'https://cae.public.lu/fr/allocations/allocation-pour-lavenir-des-enfants.html',
  apply_url = 'https://cae.public.lu/fr/allocations/allocation-pour-lavenir-des-enfants.html',
  sources = ARRAY[
    'https://cae.public.lu/fr/allocations/allocation-pour-lavenir-des-enfants.html'
  ]::text[],
  payout_status = 'Active monthly direct deposits disbursed by CAE on the last business day of each month',
  application_status = 'Accepting applications; automatic enrollment for births registered in Luxembourg',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  data_source = 'government_sites'
WHERE program_id = 370;

-- 6. Jido Teate (Universal Child Allowance) (ID: 377)
UPDATE public.programs
SET
  organization = 'Children and Families Agency (Kodomo Katei-chō)',
  description = 'Japan''s Child Allowance (Jido Teate) is a nationwide universal cash entitlement administered by the Children and Families Agency (Kodomo Katei-chō) and local municipal city halls. Following comprehensive national reforms, income limits were completely abolished, establishing a fully universal basic income floor for all resident children through high school graduation (age 18). Benefit amounts provide ¥15,000/month (~$100 USD) for children under 3, ¥10,000/month (~$67 USD) for children aged 3 through 18, and a doubled rate of ¥30,000/month (~$200 USD) for the third child and all subsequent children.',
  eligibility = '• Legal resident parent or guardian raising a child in Japan up to the end of the high school year (age 18)
• Open to both Japanese citizens and registered foreign residents with valid resident status
• Completely universal: income caps abolished nationwide',
  amount_description = '¥10,000 to ¥15,000 monthly per child (~$67–$100 USD); ¥30,000 monthly (~$200 USD) for third child and beyond',
  monthly_amount_usd = 100.00,
  currency = 'JPY',
  website = 'https://www.cfa.go.jp/policies/kokoseido/jidouteate',
  apply_url = 'https://www.cfa.go.jp/policies/kokoseido/jidouteate',
  sources = ARRAY[
    'https://www.cfa.go.jp/policies/kokoseido/jidouteate'
  ]::text[],
  payout_status = 'Active bi-monthly direct bank deposits (February, April, June, August, October, December)',
  application_status = 'Accepting applications via local municipal offices (City Hall / Ward Office)',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  data_source = 'government_sites'
WHERE program_id = 377;

-- 7. Kindergeld (Universal Child Allowance) (ID: 360)
UPDATE public.programs
SET
  organization = 'Federal Central Tax Office & Familienkasse (Bundesagentur für Arbeit)',
  description = 'Kindergeld is Germany''s universal child benefit, providing a guaranteed monthly cash floor of €255 per child (~$275 USD) to all parents residing in Germany, regardless of income or employment status. Disbursed by the Familienkasse der Bundesagentur für Arbeit, Kindergeld is paid for all children from birth up to age 18, extendable up to age 25 for young adults in vocational training, university education, or recognized voluntary service (or without age limit for children with disabilities).',
  eligibility = '• Parent or guardian resident in Germany caring for a qualifying child
• Child under age 18 (extendable up to age 21 if seeking employment, or age 25 if in school/vocational training)
• German citizen, EU/EEA national, or third-country national with valid permanent residence/work permit
• Strictly universal and non-means-tested: identical entitlement for all households',
  amount_description = '€255 monthly per child (~$275 USD) paid unconditionally until at least age 18',
  monthly_amount_usd = 275.00,
  currency = 'EUR',
  website = 'https://www.arbeitsagentur.de/familie-und-kinder/infos-rund-um-kindergeld',
  apply_url = 'https://www.arbeitsagentur.de/familie-und-kinder/infos-rund-um-kindergeld',
  sources = ARRAY[
    'https://www.arbeitsagentur.de/familie-und-kinder/infos-rund-um-kindergeld',
    'https://www.arbeitsagentur.de/familie-und-kinder/kindergeld-anspruch-hoehe-dauer',
    'https://www.bmfsfj.de/bmfsfj/themen/familie/familienleistungen/kindergeld'
  ]::text[],
  payout_status = 'Active monthly direct deposits scheduled by final digit of applicant''s Kindergeldnummer',
  application_status = 'Accepting applications online through Familienkasse digital portal or paper application',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  data_source = 'government_sites'
WHERE program_id = 360;

-- 8. Barnetrygd (Universal Child Benefit) (ID: 361)
UPDATE public.programs
SET
  organization = 'Norwegian Labour and Welfare Administration (NAV)',
  description = 'Barnetrygd is Norway''s universal, non-means-tested child benefit administered by NAV. Paid unconditionally to parents or legal guardians residing in Norway with children under age 18, the benefit provides NOK 1,766 per month (~$165 USD) for children under age 6, and NOK 1,510 per month (~$140 USD) for children aged 6 to 18. The benefit is tax-free and automatically initiated upon the registration of birth in the Norwegian National Population Register.',
  eligibility = '• Resident of Norway caring for a child under age 18
• Both parent and child must reside or intend to reside in Norway for at least 12 continuous months
• Child legally registered with the Norwegian National Population Register
• Non-means-tested: zero income ceilings or employment obligations',
  amount_description = 'NOK 1,766/mo (~$165 USD) for children under 6; NOK 1,510/mo (~$140 USD) for children aged 6–18',
  monthly_amount_usd = 165.00,
  currency = 'NOK',
  website = 'https://www.nav.no/barnetrygd/en',
  apply_url = 'https://www.nav.no/barnetrygd/en',
  sources = ARRAY[
    'https://www.nav.no/barnetrygd',
    'https://www.nav.no/barnetrygd/en'
  ]::text[],
  payout_status = 'Active monthly disbursements on the last business day of each month',
  application_status = 'Accepting applications; automated for children born in Norway',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  data_source = 'government_sites'
WHERE program_id = 361;

-- 9. Child Benefit (Ireland) (ID: 364)
UPDATE public.programs
SET
  organization = 'Department of Social Protection (An Roinn Coimirce Sóisialaí)',
  description = 'Ireland''s Child Benefit is a universal statutory cash transfer paid to parents or guardians of resident children under age 18. Administered by the Department of Social Protection, the benefit provides a flat-rate, non-taxable cash payment of €140 per month per child (~$155 USD). Following recent legislation, coverage extends through age 18 for children in full-time education. For twins, Child Benefit is paid at 150% of the normal rate; for triplets or higher multiple births, it is paid at 200%.',
  eligibility = '• Parent or guardian responsible for a child under age 16 (or under age 19 in full-time education or with a disability)
• Claimant and child must satisfy the Habitual Residence Condition (HRC) in Ireland
• Fully universal and non-means-tested: not subject to Irish income tax and unaffected by household earnings',
  amount_description = '€140 per month per child (~$155 USD); higher multiples for twins (150%) and triplets (200%)',
  monthly_amount_usd = 155.00,
  currency = 'EUR',
  website = 'https://services.mywelfare.ie/en/topics/parents-children-family/child-benefit/',
  apply_url = 'https://services.mywelfare.ie/en/topics/parents-children-family/child-benefit/',
  sources = ARRAY[
    'https://services.mywelfare.ie/en/topics/parents-children-family/child-benefit/',
    'https://www.citizensinformation.ie/en/social-welfare/families-and-children/child-benefit/'
  ]::text[],
  payout_status = 'Active monthly payments transferred on the first Tuesday of every month',
  application_status = 'Accepting applications online via MyWelfare.ie or CB1 form',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  data_source = 'government_sites'
WHERE program_id = 364;

-- 10. It All Adds Up pilot (Bay Area Thriving Families study) (ID: 146)
UPDATE public.programs
SET
  organization = 'Compass Family Services & Hamilton Families (NYU Furman Center Study)',
  description = 'It All Adds Up is a landmark guaranteed basic income pilot in San Francisco and the wider Bay Area, conducted by Compass Family Services and Hamilton Families in collaboration with the NYU Furman Center, Google.org, and J-PAL North America. As part of the Bay Area Thriving Families longitudinal study, the initiative provides 225 low-income families who have recently transitioned out of homelessness with $1,000 per month in unconditional direct cash for 12 months ($12,000 total). The study investigates the role of unconditional financial security in achieving permanent housing stability and family well-being.',
  eligibility = '• Low-income families with dependent children who have recently experienced homelessness in San Francisco/Bay Area
• Enrolled through Compass Family Services or Hamilton Families rapid-rehousing and housing subsidy programs
• Must be participating in the affiliated NYU Furman Center Bay Area Thriving Families research cohort
• Unrestricted cash: zero spending restrictions or behavioral obligations',
  amount_description = '$1,000 per month in unconditional cash assistance for 12 months ($12,000 total)',
  monthly_amount_usd = 1000.00,
  currency = 'USD',
  website = 'https://www.italladdsupsf.org/',
  apply_url = 'https://www.italladdsupsf.org/',
  sources = ARRAY[
    'https://www.italladdsupsf.org/',
    'https://www.compass-sf.org/',
    'https://basicincome.stanford.edu/research/basic-income-experiments/'
  ]::text[],
  payout_status = 'Ongoing active monthly direct cash disbursements to enrolled cohort',
  application_status = 'Cohort closed; participants actively enrolled through partner housing agencies',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'philanthropic_grant',
  involvement_level = 'external_self_apply',
  stanford_experiment_id = 51,
  data_source = 'stanford_basic_income_lab'
WHERE program_id = 146;

-- 11. Familienbeihilfe (Universal Family Allowance) (ID: 369)
UPDATE public.programs
SET
  organization = 'Austrian Federal Chancellery & Austrian Tax Office (Finanzamt Österreich)',
  description = 'Familienbeihilfe is Austria''s cornerstone universal family demogrant administered by the Federal Chancellery (Bundeskanzleramt) and the Austrian Tax Office. Financed through the Family Burden Equalisation Fund (FLAF), the allowance is paid unconditionally for all resident children in Austria from birth until age 18 (or up to age 24 for students). Monthly amounts scale progressively with the child''s age—from €132.30 from birth to €191.60 from age 19—complemented by sibling multipliers for families with two or more children.',
  eligibility = '• Parent or guardian resident in Austria whose center of vital interest is in Austria
• Child living in the same household or predominantly supported by applicant
• Payable from birth up to age 18 (extendable to age 24 for students or vocational trainees)
• Austrian citizens, EU/EEA/Swiss citizens, and legally resident third-country nationals
• Non-means-tested: paid regardless of parental income',
  amount_description = '€132.30 to €191.60 monthly per child depending on age (~$145–$210 USD), plus progressive sibling multipliers',
  monthly_amount_usd = 160.00,
  currency = 'EUR',
  website = 'https://www.bundeskanzleramt.gv.at/agenda/familie/familienbeihilfe.html',
  apply_url = 'https://www.bundeskanzleramt.gv.at/agenda/familie/familienbeihilfe.html',
  sources = ARRAY[
    'https://www.bundeskanzleramt.gv.at/agenda/familie/familienbeihilfe.html'
  ]::text[],
  payout_status = 'Active monthly direct deposits into recipient bank accounts',
  application_status = 'Accepting applications; automated enrollment (antraglose Familienbeihilfe) for Austrian births',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  data_source = 'government_sites'
WHERE program_id = 369;

-- 12. Old Age Pension (Botswana) (ID: 371)
UPDATE public.programs
SET
  organization = 'Department of Social Protection, Ministry of Local Government and Rural Development',
  description = 'Botswana''s Old Age Pension is a universal non-contributory basic income pension established in 1996 by the Government of Botswana. Paid monthly to every Botswana citizen aged 65 and older, the program delivers P630 per month (~$45–$50 USD) unconditionally across urban centers and remote rural villages. Administered by the Department of Social Protection, payments provide a universal social security floor for elder citizens, distributed through BotswanaPost offices and digital smart cards with zero means testing.',
  eligibility = '• Citizen of Botswana holding a valid national identity card (Omang)
• Age 65 or older
• Fully universal: zero means test, zero asset test, and no retirement or work cessation required',
  amount_description = 'P630 monthly (~$45–$50 USD) non-contributory universal basic income pension',
  monthly_amount_usd = 50.00,
  currency = 'BWP',
  website = 'https://www.gov.bw/',
  apply_url = 'https://www.gov.bw/',
  sources = ARRAY[
    'https://www.gov.bw/'
  ]::text[],
  payout_status = 'Active monthly cash disbursements through BotswanaPost branches and smart cards',
  application_status = 'Accepting registrations at local District Commissioner and Social Protection offices',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  data_source = 'government_sites'
WHERE program_id = 371;

-- 13. Lapsilisä (Universal Child Benefit) (ID: 368)
UPDATE public.programs
SET
  organization = 'Kela (Social Insurance Institution of Finland / Kansaneläkelaitos)',
  description = 'Lapsilisä is Finland''s universal, tax-free monthly child benefit administered by Kela. Paid unconditionally for every child permanently resident in Finland from the month following birth until their 17th birthday, the benefit provides progressive tiers: €94.88/mo for the first child, €104.84 for the second, €133.79 for the third, €173.24 for the fourth, and €192.69 for the fifth and each additional child. Single parents receive an additional supplement of €73.30 per child monthly.',
  eligibility = '• Child permanently resident in Finland under age 17
• Parent or legal guardian who cares for the child
• Universal and tax-free: zero income ceilings or employment conditions',
  amount_description = '€94.88 to €192.69 monthly per child depending on birth order (~$105–$210 USD), plus single-parent supplement',
  monthly_amount_usd = 105.00,
  currency = 'EUR',
  website = 'https://www.kela.fi/child-benefit',
  apply_url = 'https://www.kela.fi/child-benefit',
  sources = ARRAY[
    'https://www.kela.fi/lapsilisa',
    'https://www.kela.fi/child-benefit'
  ]::text[],
  payout_status = 'Active monthly payments deposited directly by Kela on the 26th of each month',
  application_status = 'Accepting applications via OmaKela e-services or Kela form LL1',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  data_source = 'government_sites'
WHERE program_id = 368;

-- 14. Old Age Pension Scheme (Brunei) (ID: 374)
UPDATE public.programs
SET
  organization = 'Community Development Department (JAPEM), Ministry of Culture, Youth and Sports',
  description = 'Brunei''s Old Age Pension Scheme (Skim Pencen Umur Tua) is one of the world''s longest-running non-contributory universal basic pensions, enacted under the Old Age and Disability Pensions Act of 1954. Funded entirely from state revenues, the scheme delivers a universal, unconditional monthly cash payment of B$250 (~$190 USD) to all citizens and permanent residents of Brunei Darussalam aged 60 and older, ensuring a lifelong economic safety floor regardless of prior employment or wealth.',
  eligibility = '• Citizen or permanent resident of Brunei Darussalam
• Age 60 or older
• Resided in Brunei Darussalam for at least 10 years (citizens) or 20 years (permanent residents) prior to application
• Non-means-tested: payable regardless of personal wealth, employment status, or other pension income',
  amount_description = 'B$250 monthly (~$190 USD) universal non-contributory state pension',
  monthly_amount_usd = 190.00,
  currency = 'BND',
  website = 'https://www.kkbs.gov.bn/',
  apply_url = 'https://www.kkbs.gov.bn/',
  sources = ARRAY[
    'https://www.kkbs.gov.bn/',
    'http://www.japem.gov.bn/'
  ]::text[],
  payout_status = 'Active monthly direct bank transfers or district post disbursement',
  application_status = 'Accepting registrations at JAPEM district branches and online portal',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  data_source = 'government_sites'
WHERE program_id = 374;

-- 15. National Cash Subsidy (Iran Targeted Subsidies Reform) (ID: 331)
UPDATE public.programs
SET
  organization = 'Targeted Subsidies Organization of Iran (Sazman-e Hadafmandsazi-ye Yaranaha)',
  description = 'In December 2010, the Government of Iran implemented the historic Targeted Subsidies Reform Act, creating the first nationwide quasi-universal basic cash transfer in a developing nation. By cutting heavy universal price subsidies on petroleum, electricity, natural gas, and bread, the state replaced price distortions with direct monthly cash transfers distributed into individual bank accounts for over 90% of the population (~73 million people). The framework continues today as a core national income floor through monthly direct transfers and electronic commodity credits.',
  eligibility = '• Citizen or legal resident household of the Islamic Republic of Iran
• Registered with the national Civil Registration Organization and Targeted Subsidies Organization
• Active bank account linked to the designated household head (sarparast-e khanevar)
• Covers general population across designated income deciles',
  amount_description = 'Periodic monthly cash subsidy and electronic commodity credit (~3,000,000 to 4,000,000 Rials / 300,000–400,000 Tomans per person)',
  monthly_amount_usd = 45.00,
  currency = 'IRR',
  website = 'https://en.wikipedia.org/wiki/Iranian_targeted_subsidy_plan',
  apply_url = 'https://en.wikipedia.org/wiki/Iranian_targeted_subsidy_plan',
  sources = ARRAY[
    'https://en.wikipedia.org/wiki/Iranian_targeted_subsidy_plan',
    'https://basicincome.stanford.edu/research/basic-income-experiments/'
  ]::text[],
  payout_status = 'Active monthly electronic direct deposits into household head bank accounts',
  application_status = 'Ongoing national coverage; registry maintained by Targeted Subsidies Organization',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  stanford_experiment_id = 257,
  data_source = 'stanford_basic_income_lab'
WHERE program_id = 331;
