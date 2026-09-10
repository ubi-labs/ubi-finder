-- ============================================================================
-- Migration 00035: Review and enhance Phase 3 Open, Ongoing programs - Batch 3C (15 programs)
-- IDs: 248, 253, 256, 317, 162, 163, 164, 362, 379, 372, 380, 367, 373, 375, 376
-- ============================================================================

-- 1. RISE GMI - Warren County, Mississippi (ID: 248)
UPDATE public.programs
SET
  organization = 'Rural GMI Initiative & OpenResearch',
  description = 'The Rural Income for Self Empowerment Guaranteed Minimum Income Program (RISE GMI) in Warren County, Mississippi is a premier randomized basic income study evaluated by OpenResearch. Enrolling over 500 rural households living at or below 200% of the Federal Poverty Level, the pilot provides $1,500 per month in unconditional, unrestricted direct cash assistance for three years. The study investigates how substantial, sustained cash floors alleviate deep poverty, empower entrepreneurship, and improve health in rural communities.',
  eligibility = '• Resident of Warren County, Mississippi
• Age 18 or older
• Household income at or below 200% of the Federal Poverty Level
• Selected into the treatment cohort during baseline community enrollment
• Unrestricted cash: zero work stipulations or spending restrictions',
  amount_description = '$1,500 per month unconditionally for 3 years ($54,000 total)',
  monthly_amount_usd = 1500.00,
  currency = 'USD',
  website = 'https://www.openresearch.com/',
  apply_url = 'https://www.openresearch.com/',
  sources = ARRAY[
    'https://www.openresearch.com/',
    'https://basicincome.stanford.edu/research/basic-income-experiments/'
  ]::text[],
  payout_status = 'Ongoing active monthly direct deposits to enrolled cohort',
  application_status = 'Cohort closed; baseline randomized enrollment completed',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'philanthropic_grant',
  involvement_level = 'external_self_apply',
  stanford_experiment_id = 163,
  data_source = 'stanford_basic_income_lab'
WHERE program_id = 248;

-- 2. Growing Strong (ID: 253)
UPDATE public.programs
SET
  organization = 'Win (Women in Need) Homeless Shelter System',
  description = 'Growing Strong is a targeted maternal guaranteed income initiative in New York City operated by Win (Women in Need), the largest provider of shelter and supportive services for homeless women and children in the United States. The program provides $1,500 per month in unconditional cash assistance to unhoused mothers caring for infants and toddlers under age two residing in designated Win family shelters, evaluating how direct unconditional financial liquidity fosters housing exits, maternal well-being, and infant development.',
  eligibility = '• Mother caring for a child under age 2
• Currently residing in an eligible participating Win family shelter in New York City
• Enrolled through Win clinical intake and case management partners
• Zero spending oversight or work conditions',
  amount_description = '$1,500 per month in unrestricted direct cash assistance',
  monthly_amount_usd = 1500.00,
  currency = 'USD',
  website = 'https://winnyc.org/',
  apply_url = 'https://winnyc.org/',
  sources = ARRAY[
    'https://winnyc.org/',
    'https://basicincome.stanford.edu/research/basic-income-experiments/'
  ]::text[],
  payout_status = 'Ongoing active monthly direct cash disbursements to enrolled shelter residents',
  application_status = 'Partner referral only; intake conducted directly within Win family shelters',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'philanthropic_grant',
  involvement_level = 'external_self_apply',
  stanford_experiment_id = 168,
  data_source = 'stanford_basic_income_lab'
WHERE program_id = 253;

-- 3. RISE GMI - Beaufort County, North Carolina (ID: 256)
UPDATE public.programs
SET
  organization = 'Rural GMI Initiative & OpenResearch',
  description = 'The Rural Income for Self Empowerment Guaranteed Minimum Income Program (RISE GMI) in Beaufort County, North Carolina is a multi-year randomized basic income trial evaluated by OpenResearch. Providing $1,500 per month in unconditional, unrestricted direct cash assistance for three years to low-income rural households, the initiative studies how unconditional financial stability transforms family well-being, employment choices, and children''s education in rural North Carolina.',
  eligibility = '• Resident of Beaufort County, North Carolina
• Age 18 or older
• Household income at or below 200% of the Federal Poverty Level
• Enrolled in the randomized treatment cohort during baseline registration
• Strictly unconditional cash: zero employment or behavioral mandates',
  amount_description = '$1,500 per month unconditionally for 3 years ($54,000 total)',
  monthly_amount_usd = 1500.00,
  currency = 'USD',
  website = 'https://www.openresearch.com/',
  apply_url = 'https://www.openresearch.com/',
  sources = ARRAY[
    'https://www.openresearch.com/',
    'https://basicincome.stanford.edu/research/basic-income-experiments/'
  ]::text[],
  payout_status = 'Ongoing active monthly direct deposits to enrolled cohort',
  application_status = 'Cohort closed; baseline randomized enrollment completed',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'philanthropic_grant',
  involvement_level = 'external_self_apply',
  stanford_experiment_id = 171,
  data_source = 'stanford_basic_income_lab'
WHERE program_id = 256;

-- 4. RISE GMI - Mercer County, West Virginia (ID: 317)
UPDATE public.programs
SET
  organization = 'Rural GMI Initiative & OpenResearch',
  description = 'The Rural Income for Self Empowerment Guaranteed Minimum Income Program (RISE GMI) in Mercer County, West Virginia is an Appalachian rural guaranteed income trial evaluated by OpenResearch. Delivering $1,500 per month in unconditional direct cash assistance for three years to rural households living at or below 200% FPL, the project measures the macroeconomic and health impacts of guaranteed cash in coal-transition Appalachian communities.',
  eligibility = '• Resident of Mercer County, West Virginia
• Age 18 or older
• Household income at or below 200% of the Federal Poverty Level
• Randomized into treatment cohort during baseline enrollment
• Strictly unconditional: no drug screening, work requirements, or spending audits',
  amount_description = '$1,500 per month unconditionally for 3 years ($54,000 total)',
  monthly_amount_usd = 1500.00,
  currency = 'USD',
  website = 'https://www.openresearch.com/',
  apply_url = 'https://www.openresearch.com/',
  sources = ARRAY[
    'https://www.openresearch.com/',
    'https://basicincome.stanford.edu/research/basic-income-experiments/'
  ]::text[],
  payout_status = 'Ongoing active monthly direct deposits to enrolled cohort',
  application_status = 'Cohort closed; baseline randomized enrollment completed',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'philanthropic_grant',
  involvement_level = 'external_self_apply',
  stanford_experiment_id = 239,
  data_source = 'stanford_basic_income_lab'
WHERE program_id = 317;

-- 5. GBI for Unhoused High School Students (ID: 162)
UPDATE public.programs
SET
  organization = 'County of Santa Clara & Destination: Home',
  description = 'The Guaranteed Basic Income for Unhoused High School Students pilot is a municipal-philanthropic collaboration between the County of Santa Clara and Destination: Home, evaluated by the Center for Guaranteed Income Research at UPenn. The program provides $1,200 per month in unconditional cash assistance to unhoused high school seniors in Santa Clara County, enabling youth to complete high school graduation, access permanent housing, and bridge the gap to higher education or career pathways.',
  eligibility = '• High school senior attending school in Santa Clara County, California
• Experiencing homelessness or housing insecurity according to McKinney-Vento definitions
• Selected through school district homeless liaisons and partner youth providers
• Unrestricted direct cash: zero spending restrictions or grade-point mandates',
  amount_description = '$1,200 per month in unconditional direct cash assistance',
  monthly_amount_usd = 1200.00,
  currency = 'USD',
  website = 'https://destinationhomesv.org/',
  apply_url = 'https://destinationhomesv.org/',
  sources = ARRAY[
    'https://destinationhomesv.org/',
    'https://basicincome.stanford.edu/research/basic-income-experiments/'
  ]::text[],
  payout_status = 'Ongoing active monthly direct cash disbursements to enrolled students',
  application_status = 'Partner referral only; intake coordinated via Santa Clara County school liaisons',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'municipal_government',
  involvement_level = 'external_self_apply',
  stanford_experiment_id = 67,
  data_source = 'stanford_basic_income_lab'
WHERE program_id = 162;

-- 6. GBI for Young Parents (ID: 163)
UPDATE public.programs
SET
  organization = 'County of Santa Clara & Destination: Home',
  description = 'The Guaranteed Basic Income for Young Parents program is a targeted pilot administered by the County of Santa Clara Social Services Agency in partnership with Destination: Home. Providing $1,200 per month in unconditional cash to pregnant youth and young parents aged 14 to 26 in Santa Clara County, the initiative supports family stability, child development, and economic mobility during critical early years without traditional welfare work rules or benefit cliffs.',
  eligibility = '• Young parent or pregnant individual aged 14 to 26
• Resident of Santa Clara County, California
• Low-to-moderate household income meeting county program thresholds
• Enrolled through participating community youth and family service agencies
• Unrestricted cash: zero behavioral conditions',
  amount_description = '$1,200 per month in unconditional cash assistance',
  monthly_amount_usd = 1200.00,
  currency = 'USD',
  website = 'https://destinationhomesv.org/',
  apply_url = 'https://destinationhomesv.org/',
  sources = ARRAY[
    'https://destinationhomesv.org/',
    'https://basicincome.stanford.edu/research/basic-income-experiments/'
  ]::text[],
  payout_status = 'Ongoing active monthly direct cash disbursements to enrolled young parents',
  application_status = 'Partner referral only; intake conducted through Santa Clara County youth partners',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'municipal_government',
  involvement_level = 'external_self_apply',
  stanford_experiment_id = 68,
  data_source = 'stanford_basic_income_lab'
WHERE program_id = 163;

-- 7. Re-Entry Guaranteed Income (ID: 164)
UPDATE public.programs
SET
  organization = 'Destination: Home & County of Santa Clara Reentry Services',
  description = 'The Santa Clara County Re-Entry Guaranteed Income pilot is a justice-reform cash initiative administered by Destination: Home in collaboration with the County of Santa Clara Office of Diversion and Reentry Services. The pilot provides $1,200 per month in unconditional direct cash to formerly incarcerated individuals recently released from jail or prison who were incarcerated for at least six consecutive months. The program aims to reduce recidivism, prevent immediate post-release homelessness, and support autonomous reintegration.',
  eligibility = '• Adult resident of Santa Clara County, California
• Recently released from jail or state prison following at least six consecutive months of incarceration
• Referred and enrolled through Santa Clara County Reentry Resource Center or contracted re-entry providers
• Unrestricted cash: zero probation/parole drug testing or employment mandates tied to receipt',
  amount_description = '$1,200 per month in unconditional direct cash assistance',
  monthly_amount_usd = 1200.00,
  currency = 'USD',
  website = 'https://destinationhomesv.org/',
  apply_url = 'https://destinationhomesv.org/',
  sources = ARRAY[
    'https://destinationhomesv.org/',
    'https://basicincome.stanford.edu/research/basic-income-experiments/'
  ]::text[],
  payout_status = 'Ongoing active monthly cash disbursements to enrolled re-entry cohort',
  application_status = 'Partner referral only; intake coordinated via Santa Clara County Reentry Resource Center',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'municipal_government',
  involvement_level = 'external_self_apply',
  stanford_experiment_id = 69,
  data_source = 'stanford_basic_income_lab'
WHERE program_id = 164;

-- 8. Børne- og ungeydelse (Family / Youth Allowance) (ID: 362)
UPDATE public.programs
SET
  organization = 'Udbetaling Danmark & Danish Ministry of Taxation (Skatteministeriet)',
  description = 'Denmark''s Børne- og ungeydelse (child and youth allowance / børnepenge) is a universal statutory cash transfer administered by Udbetaling Danmark. Paid unconditionally to parents residing in Denmark for every child from birth up to age 17, the benefit provides quarterly payments for children aged 0–14 (børneydelse: ~DKK 3,200 to 5,100 quarterly / ~DKK 1,100 to 1,700 monthly, ~$160–$250 USD/mo) and monthly payments for youth aged 15–17 (ungeydelse: ~DKK 1,024/mo, ~$150 USD/mo). The payment is completely non-taxable and non-means-tested.',
  eligibility = '• Parent or legal guardian with full custody of a child under age 18
• Child and recipient must reside in Denmark and be registered in the CPR population register
• Recipient must be fully taxable in Denmark
• Fully universal: zero income ceilings or employment conditions',
  amount_description = '~1,600 to 4,900 DKK quarterly (~$160–$250 USD/mo average) depending on child''s age',
  monthly_amount_usd = 230.00,
  currency = 'DKK',
  website = 'https://www.borger.dk/familie-og-boern/Familieydelser-oversigt/Boerne-ungeydelse',
  apply_url = 'https://www.borger.dk/familie-og-boern/Familieydelser-oversigt/Boerne-ungeydelse',
  sources = ARRAY[
    'https://www.borger.dk/familie-og-boern/Familieydelser-oversigt/Boerne-ungeydelse'
  ]::text[],
  payout_status = 'Active quarterly payments (under 15) or monthly payments (ages 15–17) deposited into NemKonto',
  application_status = 'Automated enrollment upon birth registration in the Danish civil registry',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  data_source = 'government_sites'
WHERE program_id = 362;

-- 9. National Childcare Subsidy (China) (ID: 379)
UPDATE public.programs
SET
  organization = 'National Health Commission (NHC) & Ministry of Finance of the PRC',
  description = 'China''s universal childcare direct cash subsidy program is a nationwide family policy initiative established by the State Council and National Health Commission to alleviate child-rearing costs. Implemented across municipalities and provincial administrative regions, the program provides direct annual cash subsidies of 3,600 to 10,000 Yuan per child (~$500 to $1,400 USD annually / ~$42 to $120 USD monthly) for all children under age three. Paid directly to mothers, the subsidy establishes an unconditional family allowance floor to support early child nutrition and care.',
  eligibility = '• Legal resident parent of a child under age 3
• Child registered in the local household registration (Hukou) system
• Open to all households meeting municipal birth registration parameters regardless of parental income',
  amount_description = '3,600 to 10,000 Yuan annually per child under 3 (~$42 to $120 USD monthly equivalent)',
  monthly_amount_usd = 42.00,
  currency = 'CNY',
  website = 'https://english.www.gov.cn/',
  apply_url = 'https://english.www.gov.cn/',
  sources = ARRAY[
    'https://english.www.gov.cn/'
  ]::text[],
  payout_status = 'Active periodic direct bank disbursements administered by local municipal health commissions',
  application_status = 'Accepting applications through local community sub-district and civil affairs centers',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  data_source = 'government_sites'
WHERE program_id = 379;

-- 10. Universal Old Age Grant (Namibia) (ID: 372)
UPDATE public.programs
SET
  organization = 'Ministry of Gender Equality, Poverty Eradication and Social Welfare (Namibia)',
  description = 'Namibia''s Universal Old Age Grant is an iconic non-contributory universal basic income pension established after independence in 1990. Paid unconditionally to every Namibian citizen and permanent resident aged 60 and older, the grant delivers N$1,400 per month (~$75 USD) across all 14 regions of Namibia. Administered by the Ministry of Gender Equality, Poverty Eradication and Social Welfare, payments are disbursed universally via biometric smart cards, mobile post-office payment trucks, and direct bank deposits with zero means testing.',
  eligibility = '• Namibian citizen or legal permanent resident holding an official Namibian identity document
• Age 60 or older
• Residing in the Republic of Namibia
• Fully universal: zero means test, zero asset test, and no retirement or cessation-of-work requirement',
  amount_description = 'N$1,400 per month (~$75 USD) non-contributory universal basic pension',
  monthly_amount_usd = 75.00,
  currency = 'NAD',
  website = 'https://en.wikipedia.org/wiki/Pensions_in_Namibia',
  apply_url = 'https://en.wikipedia.org/wiki/Pensions_in_Namibia',
  sources = ARRAY[
    'https://en.wikipedia.org/wiki/Pensions_in_Namibia'
  ]::text[],
  payout_status = 'Active monthly cash disbursements distributed via biometric smart cards and commercial banks',
  application_status = 'Accepting registrations at regional and constituency social welfare offices upon turning 60',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  data_source = 'government_sites'
WHERE program_id = 372;

-- 11. Folkepension (Universal Basic Retirement Pension - Denmark) (ID: 380)
UPDATE public.programs
SET
  organization = 'Udbetaling Danmark & Ministry of Social Affairs and Housing',
  description = 'Denmark''s Folkepension is a statutory public old-age pension providing a foundational universal basic income floor for all resident seniors who reach the official pension age (currently 67). Administered by Udbetaling Danmark, the core basic amount (Grundbeløb) provides approximately DKK 7,000+ per month (~$1,020 USD/mo) unconditionally to all qualifying seniors, independent of personal wealth, savings, or private capital assets. Under recent historic reforms, income from continued employment no longer offsets the basic pension, enabling active seniors to work without penalty.',
  eligibility = '• Reached Danish statutory retirement age (currently 67)
• Danish citizen or EU/EEA national, or third-country national who has lived in Denmark for at least 10 years
• Resided in Denmark for at least 3 years between age 15 and retirement age (full pension earned with 40 years of residence)
• The basic amount (Grundbeløb) is paid unconditionally without private wealth testing',
  amount_description = 'Over DKK 7,000 monthly Grundbeløb basic pension (~$1,020 USD/mo) plus supplemental allowances',
  monthly_amount_usd = 1020.00,
  currency = 'DKK',
  website = 'https://www.borger.dk/pension-og-efterloen/Folkepension-oversigt/foer-du-gaar-paa-folkepension',
  apply_url = 'https://www.borger.dk/pension-og-efterloen/Folkepension-oversigt/foer-du-gaar-paa-folkepension',
  sources = ARRAY[
    'https://www.borger.dk/pension-og-efterloen/Folkepension-oversigt/foer-du-gaar-paa-folkepension'
  ]::text[],
  payout_status = 'Active monthly direct deposits into recipient NemKonto on the last banking day of each month',
  application_status = 'Accepting digital applications via Borger.dk up to 6 months prior to reaching pension age',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  data_source = 'government_sites'
WHERE program_id = 380;

-- 12. Barnbidrag (Universal Child Allowance) (ID: 367)
UPDATE public.programs
SET
  organization = 'Försäkringskassan (Swedish Social Insurance Agency)',
  description = 'Barnbidrag is Sweden''s universal statutory child allowance administered by Försäkringskassan. Every parent or guardian residing in Sweden receives a flat, unconditional, and non-taxable monthly cash payment of 1,250 SEK per child (~$120 USD) from birth until the quarter the child turns 16 (after which Studiebidrag continues the benefit for students). For families with two or more children, an automatic large-family supplement (flerbarnstillägg) is added, providing an escalating financial floor for growing households.',
  eligibility = '• Parent or legal guardian caring for a child residing in Sweden under age 16
• Both parent and child must be insured and registered in the Swedish population register
• Fully universal and non-means-tested: zero income ceilings or asset limits',
  amount_description = '1,250 SEK per month per child (~$120 USD) plus automatic large-family supplements (flerbarnstillägg)',
  monthly_amount_usd = 120.00,
  currency = 'SEK',
  website = 'https://www.forsakringskassan.se/privatperson/familj-och-barn/barnbidrag-och-flerbarnstillagg/barnbidrag-och-flerbarnstillagg-sa-funkar-det',
  apply_url = 'https://www.forsakringskassan.se/privatperson/familj-och-barn/barnbidrag-och-flerbarnstillagg/barnbidrag-och-flerbarnstillagg-sa-funkar-det',
  sources = ARRAY[
    'https://www.forsakringskassan.se/privatperson/familj-och-barn/barnbidrag-och-flerbarnstillagg/barnbidrag-och-flerbarnstillagg-sa-funkar-det',
    'https://www.forsakringskassan.se/english/parents/child-allowance'
  ]::text[],
  payout_status = 'Active monthly direct deposits disbursed by Försäkringskassan on the 20th of each month',
  application_status = 'Automated enrollment for children born or registered as resident in Sweden',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  data_source = 'government_sites'
WHERE program_id = 367;

-- 13. Renta Dignidad (Bolivia) (ID: 373)
UPDATE public.programs
SET
  organization = 'Gestora Pública de la Seguridad Social de Largo Plazo (Bolivia)',
  description = 'Renta Dignidad is Bolivia''s universal non-contributory basic income pension, established by Law 3791 in 2007 to succeed the pioneer Bonosol program of 1996. Financed through the Direct Tax on Hydrocarbons (IDH) and dividends from nationalized state enterprises, the program delivers an unconditional monthly cash pension of Bs 350 (~$50 USD) to all Bolivian citizens aged 60 and older living in the country (or Bs 300/mo for those with contributory pensions). Disbursed through the public Gestora network and military/mobile payment units in rural indigenous communities, it serves as a universal resource dividend.',
  eligibility = '• Bolivian citizen holding a valid national identity card (Cédula de Identidad)
• Age 60 or older
• Residing in the Plurinational State of Bolivia
• Universal: zero means testing, asset requirements, or retirement cessation conditions',
  amount_description = 'Bs 350 monthly (~$50 USD; Bs 300 for contributory pensioners) universal resource dividend',
  monthly_amount_usd = 50.00,
  currency = 'BOB',
  website = 'https://www.gestora.bo/',
  apply_url = 'https://www.gestora.bo/',
  sources = ARRAY[
    'https://www.gestora.bo/',
    'https://en.wikipedia.org/wiki/Pensions_in_Bolivia'
  ]::text[],
  payout_status = 'Active monthly cash disbursements through commercial banks, Gestora offices, and rural payment brigades',
  application_status = 'Accepting registrations at Gestora agencies nationwide upon attaining age 60',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  data_source = 'government_sites'
WHERE program_id = 373;

-- 14. Senior Citizens Allowance / Elderly Fund (Kiribati) (ID: 375)
UPDATE public.programs
SET
  organization = 'Ministry of Women, Youth, Sports and Social Affairs & Office of Te Beretitenti (Kiribati)',
  description = 'Kiribati''s Senior Citizens Allowance (Elderly Fund) is a universal non-contributory basic pension funded by sovereign revenue from the Revenue Equalisation Reserve Fund (RERF) and sustainable fisheries royalties. Administered by the Ministry of Women, Youth, Sports and Social Affairs alongside the Office of the President, the program provides an unconditional monthly cash allowance of AU$200 (~$135 USD) to all elderly citizens aged 65 and older across all 33 outer islands and atolls of Kiribati, guaranteeing a resilient economic floor against climate and isolation challenges.',
  eligibility = '• Citizen of the Republic of Kiribati
• Age 65 or older
• Resident of Kiribati across any of the Gilbert, Line, or Phoenix island groups
• Fully universal: zero means test, zero asset test, and no employment restrictions',
  amount_description = 'AU$200 monthly (~$135 USD) universal sovereign resource pension',
  monthly_amount_usd = 135.00,
  currency = 'AUD',
  website = 'https://president.gov.ki/',
  apply_url = 'https://president.gov.ki/',
  sources = ARRAY[
    'https://president.gov.ki/'
  ]::text[],
  payout_status = 'Active monthly cash disbursements transferred via island council offices and commercial bank branches',
  application_status = 'Accepting registrations through local Island Councils and Social Affairs officers',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  data_source = 'government_sites'
WHERE program_id = 375;

-- 15. Senior Citizens Allowance (Tuvalu) (ID: 376)
UPDATE public.programs
SET
  organization = 'Ministry of Finance & Department of Social Protection (Tuvalu)',
  description = 'Tuvalu''s Senior Citizens Allowance is a universal non-contributory cash transfer funded through the Tuvalu Trust Fund and national sovereign revenues. Administered by the Department of Social Protection, the scheme delivers an unconditional monthly cash transfer of AU$150 (~$100 USD) to all citizens aged 70 and older residing across Tuvalu''s nine atolls and reef islands. The allowance establishes a permanent economic floor for elder citizens, insulating island families from volatile import costs and environmental risks.',
  eligibility = '• Citizen of Tuvalu
• Age 70 or older
• Ordinarily resident in Tuvalu across any of the nine island atolls
• Fully universal: zero means-testing or retirement requirements',
  amount_description = 'AU$150 monthly (~$100 USD) non-contributory universal senior allowance',
  monthly_amount_usd = 100.00,
  currency = 'AUD',
  website = 'https://president.gov.ki/',
  apply_url = 'https://president.gov.ki/',
  sources = ARRAY[
    'https://president.gov.ki/'
  ]::text[],
  payout_status = 'Active monthly cash disbursements paid via Kaupule (island councils) and National Bank of Tuvalu',
  application_status = 'Accepting registrations at local Kaupule island offices and Department of Social Protection',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  data_source = 'government_sites'
WHERE program_id = 376;
