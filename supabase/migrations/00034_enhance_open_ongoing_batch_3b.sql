-- ============================================================================
-- Migration 00034: Review and enhance Phase 3 Open, Ongoing programs - Batch 3B (15 programs)
-- IDs: 38, 381, 365, 9, 10, 13, 14, 15, 16, 20, 21, 199, 252, 298, 322
-- ============================================================================

-- 1. New Brunswick Youth Basic Income Pilot (ID: 38)
UPDATE public.programs
SET
  organization = 'Government of New Brunswick Department of Social Development',
  description = 'The New Brunswick Youth Basic Income Pilot is a provincial guaranteed income initiative administered by the Department of Social Development. The program provides young adults aged 18 to 24 who are transitioning out of provincial foster care or experiencing severe housing precarity with a guaranteed monthly financial floor of CAD $1,000 per month (~$750 USD/mo). By offering unconditional cash without punitive employment rules, the pilot enables vulnerable youth to secure safe housing, pursue vocational training, and transition stably to adulthood.',
  eligibility = '• Young adult aged 18 to 24 residing in New Brunswick, Canada
• Former youth in care of the Minister of Social Development or youth experiencing homelessness/severe income precarity
• Not receiving overlapping full social assistance benefits that duplicate basic income support
• Unrestricted cash: zero mandatory work or educational participation requirements',
  amount_description = 'CAD $1,000 per month (~$750 USD/mo) unconditional youth basic income',
  monthly_amount_usd = 750.00,
  currency = 'CAD',
  website = 'https://www2.gnb.ca/content/gnb/en/departments/social_development.html',
  apply_url = 'https://www2.gnb.ca/content/gnb/en/departments/social_development.html',
  sources = ARRAY[
    'https://www2.gnb.ca/content/gnb/en/departments/social_development.html',
    'https://www.gnb.ca/en.html'
  ]::text[],
  payout_status = 'Ongoing active monthly direct deposits to enrolled youth',
  application_status = 'Accepting applications via provincial Social Development intake offices',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  data_source = 'community_submission'
WHERE program_id = 38;

-- 2. Family 800+ (Rodzina 800+ - Universal Child Benefit Poland) (ID: 381)
UPDATE public.programs
SET
  organization = 'Social Insurance Institution (ZUS - Zakład Ubezpieczeń Społecznych)',
  description = 'Poland''s Family 800+ program (formerly Rodzina 500+, upgraded to 800 PLN in January 2024) is a nationwide universal child demogrant administered by ZUS. The program delivers an unconditional, non-means-tested monthly cash transfer of 800 PLN (~$210 USD) for every child living in Poland from birth until their 18th birthday. Financed from the national budget and transferred directly into parents'' bank accounts, the benefit is entirely tax-free and independent of parental income or labor market participation.',
  eligibility = '• Parent, legal guardian, or foster parent caring for a child under age 18
• Child and applicant must reside in Poland
• Open to Polish citizens and legal foreign residents with access to the Polish labor market
• Fully universal: zero income ceilings or employment conditions',
  amount_description = '800 PLN monthly per child (~$210 USD) unconditionally until age 18',
  monthly_amount_usd = 210.00,
  currency = 'PLN',
  website = 'https://www.zus.pl/swiadczenia/swiadczenia-dla-rodzin/swiadczenie-wychowawcze-800-plus',
  apply_url = 'https://www.zus.pl/swiadczenia/swiadczenia-dla-rodzin/swiadczenie-wychowawcze-800-plus',
  sources = ARRAY[
    'https://www.zus.pl/swiadczenia/swiadczenia-dla-rodzin/swiadczenie-wychowawcze-800-plus',
    'https://www.gov.pl/web/rodzina'
  ]::text[],
  payout_status = 'Active monthly direct deposits scheduled by ZUS payment date assigned to each family',
  application_status = 'Accepting digital applications via PUE ZUS portal, mZUS mobile app, or electronic banking',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  data_source = 'government_sites'
WHERE program_id = 381;

-- 3. New Zealand Superannuation (NZ Super) (ID: 365)
UPDATE public.programs
SET
  organization = 'Ministry of Social Development / Work and Income NZ',
  description = 'New Zealand Superannuation (NZ Super) is a world-renowned non-contributory universal basic income pension for all New Zealand seniors aged 65 and older. Funded entirely from general tax revenues, NZ Super delivers a regular fortnightly cash transfer—over NZ$1,080 fortnightly (~$1,420 USD monthly) for single individuals living alone, or ~NZ$830 fortnightly (~$1,090 USD/mo) per person in a relationship. Unlike conventional state pensions, NZ Super is completely non-means-tested: recipients can continue working full-time with zero benefit clawback.',
  eligibility = '• Age 65 or older
• New Zealand citizen or permanent resident who is ordinarily resident in New Zealand
• Resided in New Zealand for at least 10 years since age 20 (including at least 5 years since age 50, transitioning towards a 20-year requirement)
• Fully universal: zero income test, zero asset test, and no retirement or cessation-of-work obligation',
  amount_description = 'Over NZ$1,080 fortnightly (~$1,420 USD/mo single living alone; ~$1,090 USD/mo each for couples)',
  monthly_amount_usd = 1420.00,
  currency = 'NZD',
  website = 'https://www.workandincome.govt.nz/eligibility/seniors/superannuation/',
  apply_url = 'https://www.workandincome.govt.nz/eligibility/seniors/superannuation/',
  sources = ARRAY[
    'https://www.workandincome.govt.nz/eligibility/seniors/superannuation/',
    'https://www.workandincome.govt.nz/products/a-z-benefits/nz-superannuation.html'
  ]::text[],
  payout_status = 'Active fortnightly direct bank deposits paid on alternating Tuesdays',
  application_status = 'Accepting applications online via MyMSD or paper application up to 12 weeks before 65th birthday',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  data_source = 'government_sites'
WHERE program_id = 365;

-- 4. Rural Basic Income Pilot Programme (ID: 9)
UPDATE public.programs
SET
  organization = 'Republic of Korea Ministry of Agriculture, Food and Rural Affairs (MAFRA)',
  description = 'South Korea''s Rural Basic Income Pilot Programme is a groundbreaking national regional basic income initiative administered by the Ministry of Agriculture, Food and Rural Affairs. The program delivers KRW 150,000 per month (~$110 USD) in local community currency to every resident living in 10 designated depopulating rural counties across South Korea. Operating as a universal community-wide floor regardless of farming status, age, or income, the pilot evaluates basic income as a policy mechanism to reverse rural demographic decline and revitalize local economies.',
  eligibility = '• Registered resident in the resident registration system of one of the 10 designated pilot rural counties
• Actually living and residing within the designated rural county
• Fully universal within participating rural administrative districts: applies to all residents regardless of occupation or wealth',
  amount_description = 'KRW 150,000 per month (~$110 USD) disbursed in regional community currency cards',
  monthly_amount_usd = 110.00,
  currency = 'KRW',
  website = 'https://www.mafra.go.kr/english/756/subview.do?enc=Zm5jdDF8QEB8JTJGYmJzJTJGZW5nbGlzaCUyRjI1JTJGNTc3MjIzJTJGYXJ0Y2xWaWV3LmRvJTNG',
  apply_url = 'https://www.mafra.go.kr/english/756/subview.do?enc=Zm5jdDF8QEB8JTJGYmJzJTJGZW5nbGlzaCUyRjI1JTJGNTc3MjIzJTJGYXJ0Y2xWaWV3LmRvJTNG',
  sources = ARRAY[
    'https://www.mafra.go.kr/english/756/subview.do?enc=Zm5jdDF8QEB8JTJGYmJzJTJGZW5nbGlzaCUyRjI1JTJGNTc3MjIzJTJGYXJ0Y2xWaWV3LmRvJTNG',
    'https://www.mafra.go.kr/english/index.do'
  ]::text[],
  payout_status = 'Active monthly disbursements reloaded onto local currency cards usable at regional merchants',
  application_status = 'Accepting applications via participating township/eup/myeon administrative welfare centers',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'prepaid_card',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  data_source = 'government_sites'
WHERE program_id = 9;

-- 5. ENRA Universal Basic Income Program (ID: 10)
UPDATE public.programs
SET
  organization = 'Republic of the Marshall Islands Ministry of Finance',
  description = 'The ENRA Universal Basic Income Program is a sovereign direct cash distribution initiative created by the Republic of the Marshall Islands. Financed through national trust revenues and international climate adaptation funding, ENRA provides quarterly unconditional cash payments of ~$200 USD per quarter (~$66.67 USD monthly) directly to all eligible Marshallese citizens residing in the country. The program is designed to establish an unconditional baseline floor of social protection, enhance climate resilience, and reduce outer-island economic vulnerability.',
  eligibility = '• Marshallese citizen holding valid national identification
• Ordinarily resident in the Republic of the Marshall Islands
• Valid registration with the Ministry of Finance ENRA national beneficiary database
• Fully unconditional: zero work requirements, means-testing, or spending oversight',
  amount_description = '~$200 USD distributed quarterly (~$66.67 USD monthly equivalent) unconditionally',
  monthly_amount_usd = 66.67,
  currency = 'USD',
  website = 'https://mof.gov.mh/usdm1/enra/',
  apply_url = 'https://mof.gov.mh/usdm1/enra/',
  sources = ARRAY[
    'https://mof.gov.mh/usdm1/enra/',
    'https://mof.gov.mh/usdm1-whitepaper/',
    'https://marshallislandsjournal.com/enra-bump-up/'
  ]::text[],
  payout_status = 'Active quarterly direct deposits through the Bank of the Marshall Islands and digital wallets',
  application_status = 'Ongoing enrollment and census updates through Ministry of Finance',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  data_source = 'government_sites'
WHERE program_id = 10;

-- 6. Québec Basic Income Program (ID: 13)
UPDATE public.programs
SET
  organization = 'Government of Québec Ministère de l''Emploi et de la Solidarité sociale',
  description = 'The Québec Basic Income Program (Programme de revenu de base) is a landmark permanent provincial guaranteed income framework launched on January 1, 2023. Administered by the Ministère de l''Emploi et de la Solidarité sociale, it guarantees a basic monthly income floor of CAD $1,336+ per month (~$980 USD/mo) for single adults with severe, persistent employment limitations who have received Social Solidarity benefits for at least 66 of the prior 72 months. The program uniquely permits generous labor earnings without 1:1 benefit reductions and provides unprecedented liquid asset exemptions up to $20,000.',
  eligibility = '• Resident of Québec, Canada
• Recognized severe, persistent capacity limitations for employment
• Received benefits under Québec''s Social Solidarity Program for at least 66 of the previous 72 months
• Single adult or family unit meeting provincial qualification parameters',
  amount_description = 'CAD $1,336+ per month (~$980 USD/mo) base guaranteed income plus earnings exemptions',
  monthly_amount_usd = 980.00,
  currency = 'CAD',
  website = 'https://www.quebec.ca/en/family-and-support-for-individuals/social-assistance-social-solidarity/basic-income-program',
  apply_url = 'https://www.quebec.ca/en/family-and-support-for-individuals/social-assistance-social-solidarity/basic-income-program',
  sources = ARRAY[
    'https://www.quebec.ca/en/family-and-support-for-individuals/social-assistance-social-solidarity/basic-income-program'
  ]::text[],
  payout_status = 'Active monthly direct deposits on the first day of each month',
  application_status = 'Ongoing automatic enrollment for qualifying Social Solidarity recipients',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  data_source = 'government_sites'
WHERE program_id = 13;

-- 7. Guaranteed Income Supplement (ID: 14)
UPDATE public.programs
SET
  organization = 'Government of Canada / Service Canada (ESDC)',
  description = 'Canada''s Guaranteed Income Supplement (GIS) is a federal guaranteed minimum income for low-income seniors aged 65 and older who receive the Old Age Security (OAS) pension. Administered by Service Canada, the GIS provides up to CAD $1,123.17 per month (~$820 USD/mo) for single, widowed, or divorced seniors. The payment is completely non-taxable, indexed quarterly to the Consumer Price Index, and automatically recalculated annually based on tax return filings.',
  eligibility = '• Age 65 or older
• Resident of Canada receiving or eligible to receive the Old Age Security (OAS) pension
• Annual net income below the statutory threshold (e.g. under CAD $22,464 for single seniors)
• Timely filing of annual Canadian income tax returns',
  amount_description = 'Up to CAD $1,123.17 per month (~$820 USD/mo) non-taxable guaranteed income',
  monthly_amount_usd = 820.00,
  currency = 'CAD',
  website = 'https://www.canada.ca/en/services/benefits/publicpensions/old-age-security/guaranteed-income-supplement.html',
  apply_url = 'https://www.canada.ca/en/services/benefits/publicpensions/old-age-security/guaranteed-income-supplement.html',
  sources = ARRAY[
    'https://www.canada.ca/en/services/benefits/publicpensions/old-age-security/guaranteed-income-supplement.html'
  ]::text[],
  payout_status = 'Active monthly direct deposits disbursed by Service Canada on the third-to-last business day of each month',
  application_status = 'Accepting applications online via My Service Canada Account (MSCA) or automated enrollment with OAS',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  data_source = 'government_sites'
WHERE program_id = 14;

-- 8. Ingreso Mínimo Vital (ID: 15)
UPDATE public.programs
SET
  organization = 'Government of Spain Instituto Nacional de la Seguridad Social (INSS)',
  description = 'Ingreso Mínimo Vital (IMV) is Spain''s national guaranteed minimum income floor, established by the Ministry of Inclusion, Social Security and Migration in 2020. Administered by the Instituto Nacional de la Seguridad Social (INSS), IMV provides an unconditional non-contributory income floor ranging from €604 to over €1,400 per month (~$660 to $1,530 USD/mo) depending on household size and composition. Designed to eradicate structural poverty, the program operates an integrated employment incentive that prevents benefit loss when recipients gain wage employment.',
  eligibility = '• Legal and effective residence in Spain continuously for at least one year prior to application
• Age between 23 and 65 (or age 18+ with dependent minors)
• Household economic vulnerability: net income below the statutory guaranteed minimum threshold
• Household net assets below statutory limits (excluding primary residence)',
  amount_description = '€604.21 monthly single adult baseline (~$660 USD), scaling to €1,400+/mo for larger family units',
  monthly_amount_usd = 660.00,
  currency = 'EUR',
  website = 'https://imv.seg-social.es/',
  apply_url = 'https://imv.seg-social.es/',
  sources = ARRAY[
    'https://imv.seg-social.es/',
    'https://www.seg-social.es/'
  ]::text[],
  payout_status = 'Active monthly direct deposits into recipient Spanish bank accounts',
  application_status = 'Accepting applications via INSS electronic headquarters (Sede Electrónica) without digital certificate',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  data_source = 'government_sites'
WHERE program_id = 15;

-- 9. Social Relief of Distress Grant (ID: 16)
UPDATE public.programs
SET
  organization = 'South African Social Security Agency (SASSA) & Department of Social Development',
  description = 'South Africa''s COVID-19 Social Relief of Distress (SRD) Grant is a nationwide social assistance transfer administered by SASSA. Extended through March 2027 and currently reaching over 8 million recipients, the SRD grant pays ZAR 370 per month (~$21–$23 USD) to distressed working-age individuals aged 18 to 59 who have no income or support under the food poverty threshold. Serving as the primary policy bridge toward a permanent Basic Income Grant (BIG) in South Africa, the payment provides a vital survival floor for informal workers and job seekers.',
  eligibility = '• South African citizen, permanent resident, recognized refugee, or holder of special dispensation permit
• Age 18 to 59 years old
• Reside within the borders of South Africa
• Insufficient income: personal monthly earnings below the ZAR 624 food poverty threshold
• Not receiving UIF, NSFAS bursaries, or other overlapping social grants',
  amount_description = 'ZAR 370 per month (~$21–$23 USD) non-contributory distress transfer',
  monthly_amount_usd = 22.00,
  currency = 'ZAR',
  website = 'https://www.gov.za/services/services-residents/social-benefits/social-relief-distress',
  apply_url = 'https://www.gov.za/services/services-residents/social-benefits/social-relief-distress',
  sources = ARRAY[
    'https://www.gov.za/services/services-residents/social-benefits/social-relief-distress',
    'https://www.sassa.gov.za/'
  ]::text[],
  payout_status = 'Active monthly disbursements transferred to bank accounts, Postbank, or CashSend/e-Wallets',
  application_status = 'Accepting monthly digital applications and reconfirmations via SASSA SRD online portal',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  data_source = 'government_sites'
WHERE program_id = 16;

-- 10. Citizen Account Program (ID: 20)
UPDATE public.programs
SET
  organization = 'Kingdom of Saudi Arabia Ministry of Human Resources and Social Development',
  description = 'Saudi Arabia''s Citizen Account Program (Hissab Al-Mowaten) is a major national cash transfer system implemented by royal decree to offset the costs of fiscal reforms, energy price restructurings, and VAT. Administered by the Ministry of Human Resources and Social Development, the program provides monthly unconditional cash grants directly into household bank accounts, averaging SAR 1,474 per month (~$393 USD/mo). Benefit sizes are calculated using an equitable statutory formula accounting for total household income, family size, and ages of dependents.',
  eligibility = '• Saudi citizen holding a national identity card, or non-Saudi holding a mobility card or married to a citizen
• Primary resident within the Kingdom of Saudi Arabia (not residing outside the Kingdom for >90 days/year)
• Total household income within statutory threshold deciles
• Head of household or independent individual aged 18 or older',
  amount_description = 'Average SAR 1,474 per household per month (~$393 USD/mo) based on family size and income formula',
  monthly_amount_usd = 393.00,
  currency = 'SAR',
  website = 'https://eservices.ca.gov.sa/',
  apply_url = 'https://eservices.ca.gov.sa/',
  sources = ARRAY[
    'https://eservices.ca.gov.sa/',
    'https://www.hrsd.gov.sa/en/care-about-you/social-protection'
  ]::text[],
  payout_status = 'Active monthly direct deposits disbursed into commercial bank accounts on the 10th of every month',
  application_status = 'Accepting digital registrations and data updates via Citizen Account electronic portal',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  data_source = 'government_sites'
WHERE program_id = 20;

-- 11. GoodDollar (ID: 21)
UPDATE public.programs
SET
  organization = 'GoodDollar Foundation & GoodDAO',
  description = 'GoodDollar is a decentralized, reserve-backed crypto basic income protocol and DAO. Powered by DeFi yield farming and liquidity pools on Ethereum and Celo, the protocol generates and distributes daily claimable allocations of G$ tokens unconditionally to unique verified humans across the globe. Utilizing FaceTec 3D liveness detection for privacy-preserving Sybil resistance, GoodDollar creates a borderless, permissionless financial floor for hundreds of thousands of daily claimants.',
  eligibility = '• Successful one-time proof-of-humanity verification via FaceTec 3D biometric liveness check
• Compatible Web3 wallet (GoodWallet web app, MetaMask, or Celo-compatible wallet)
• Open universally to any individual worldwide regardless of nationality or geographic location
• Claim once every 24-hour cycle via the GoodDollar web application',
  amount_description = 'Daily free G$ token claims via GoodWallet (benchmark equivalent ~$5–$15 USD/mo)',
  monthly_amount_usd = 10.00,
  currency = 'G$',
  website = 'https://www.gooddollar.org/',
  apply_url = 'https://wallet.gooddollar.org/',
  sources = ARRAY[
    'https://www.gooddollar.org/',
    'https://wallet.gooddollar.org/',
    'https://dashboard.gooddollar.org/'
  ]::text[],
  payout_status = 'Active daily on-chain claims settling directly to recipient Web3 wallets on Celo',
  application_status = 'Open daily claiming available continuously on GoodWallet',
  distribution_type = 'daily_claim_protocol',
  payout_rail = 'crypto_wallet',
  funding_source = 'protocol_yield',
  involvement_level = 'automated_claim',
  data_source = 'community_submission'
WHERE program_id = 21;

-- 12. In Her Hands - Atlanta's Westside Neighborhoods (ID: 199)
UPDATE public.programs
SET
  organization = 'The GRO Fund (Georgia Resilience and Opportunity Fund) & GiveDirectly',
  description = 'In Her Hands is one of the largest guaranteed income initiatives in the American South, launched by The GRO Fund and GiveDirectly with academic evaluation by the Center for Guaranteed Income Research. The Atlanta Westside cohort (covering English Avenue, Vine City, and surrounding neighborhoods) provides unconditional cash payments totaling $20,400 over 24 months to Black women living below the poverty level. Participants select either $850/month across two years or a front-loaded option of $4,300 upfront plus $700/month, measuring the impact on housing, health, and debt.',
  eligibility = '• Female-identifying individual aged 18 or older
• Resident of designated Atlanta Westside neighborhoods (English Avenue, Vine City, Bankhead, or Washington Park)
• Household income at or below 200% of the Federal Poverty Level
• Unrestricted cash: zero spending requirements, drug tests, or employment stipulations',
  amount_description = '$20,400 total over 24 months: either $850/month or $4,300 upfront plus $700/month',
  monthly_amount_usd = 850.00,
  currency = 'USD',
  website = 'https://thegrofund.org/about-in-her-hands',
  apply_url = 'https://thegrofund.org/about-in-her-hands',
  sources = ARRAY[
    'https://thegrofund.org/about-in-her-hands',
    'https://basicincome.stanford.edu/research/basic-income-experiments/'
  ]::text[],
  payout_status = 'Ongoing active monthly direct deposits and prepaid debit disbursements to enrolled cohort',
  application_status = 'Cohort closed; participants actively receiving monthly distributions',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'philanthropic_grant',
  involvement_level = 'external_self_apply',
  stanford_experiment_id = 108,
  data_source = 'stanford_basic_income_lab'
WHERE program_id = 199;

-- 13. Bootstraps (ID: 252)
UPDATE public.programs
SET
  organization = 'Pale Blue Dot Media',
  description = 'Bootstraps is a groundbreaking nationwide guaranteed basic income media and research experiment produced by Pale Blue Dot Media, founded by documentary filmmakers Deia Schlosberg and Conrad Shaw. The project selected 21 diverse individuals and families across the United States—spanning varied geographies, political viewpoints, racial backgrounds, and economic circumstances—and provided each with $1,000 per month in unconditional cash for 2.5 years ($30,000 per household). The initiative captured an intimate, longitudinal chronicle of how unconditional economic security alters life choices, work, family, and health.',
  eligibility = '• Selected diverse participants across multiple US states representing cross-demographic diversity
• Enrolled in the intensive 2.5-year longitudinal documentary and financial tracking study
• Strictly unconditional: zero spending restrictions, labor stipulations, or behavioral conditions',
  amount_description = '$1,000 per month unconditionally for 2.5 years ($30,000 total per household)',
  monthly_amount_usd = 1000.00,
  currency = 'USD',
  website = 'https://palebluedotmedia.com/bootstraps',
  apply_url = 'https://palebluedotmedia.com/bootstraps',
  sources = ARRAY[
    'https://palebluedotmedia.com/bootstraps',
    'https://basicincome.stanford.edu/research/basic-income-experiments/'
  ]::text[],
  payout_status = 'Study disbursements ongoing / concluding for experimental cohort',
  application_status = 'Cohort closed; participant cohort fully enrolled for documentary study',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'philanthropic_grant',
  involvement_level = 'external_self_apply',
  stanford_experiment_id = 167,
  data_source = 'stanford_basic_income_lab'
WHERE program_id = 252;

-- 14. Black Music Action Coalition x Academy of Country Music Guaranteed Income Program (ID: 298)
UPDATE public.programs
SET
  organization = 'Black Music Action Coalition (BMAC) & Academy of Country Music (ACM)',
  description = 'The BMAC x ACM Guaranteed Income Program is a targeted artistic guaranteed income initiative established through a historic collaboration between the Black Music Action Coalition and the Academy of Country Music. Focused on Nashville, Tennessee, the program provides 20 early-career Black music artists and industry professionals with $1,000 per month in unconditional cash assistance for one full year ($12,000 total). Recipients also receive dedicated mentorship, financial literacy education, executive coaching, and direct access to country music industry networks to break down racial and economic barriers.',
  eligibility = '• Early-career Black artist, musician, songwriter, or music industry professional
• Based in Nashville, Tennessee, or actively operating within the Nashville country and roots music community
• Selected through a competitive jury application assessing creative promise and industry commitment
• Fully unconditional monthly cash transfer alongside optional professional development resources',
  amount_description = '$1,000 per month in unrestricted direct cash for 12 months ($12,000 total)',
  monthly_amount_usd = 1000.00,
  currency = 'USD',
  website = 'https://www.bmacoalition.org/',
  apply_url = 'https://www.bmacoalition.org/',
  sources = ARRAY[
    'https://www.bmacoalition.org/',
    'https://www.acmcountry.com/news',
    'https://basicincome.stanford.edu/research/basic-income-experiments/'
  ]::text[],
  payout_status = 'Ongoing active monthly direct cash disbursements to enrolled artist cohort',
  application_status = 'Cohort closed; inaugural awardees receiving disbursements and mentorship',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'direct_deposit',
  funding_source = 'philanthropic_grant',
  involvement_level = 'external_self_apply',
  stanford_experiment_id = 218,
  data_source = 'stanford_basic_income_lab'
WHERE program_id = 298;

-- 15. Basic Income for Farmers (ID: 322)
UPDATE public.programs
SET
  organization = 'Gyeonggi Provincial Government (경기도)',
  description = 'Gyeonggi Province''s Farmer Basic Income (농민기본소득) is an established agricultural basic income initiative in South Korea, pioneered under former Governor Lee Jae-myung. The program provides 50,000 KRW per month (paid quarterly as 150,000 KRW, or ~600,000 KRW annually / ~$45–$50 USD/mo) in regional local currency to every eligible farmer residing in participating Gyeonggi municipalities. The benefit is paid directly to individual farmers rather than per household, upholding the public-interest value of farming and protecting smallholder agricultural viability.',
  eligibility = '• Registered resident farmer living in a participating Gyeonggi Province municipality continuously for at least 2 to 3 years
• Actively engaged in actual agricultural production (registered on the national agricultural management entity register)
• Paid individually to every qualifying farmer in the household, rather than capped per household unit',
  amount_description = '50,000 KRW monthly (~$45–$50 USD; disbursed quarterly as 150,000 KRW) in local currency',
  monthly_amount_usd = 50.00,
  currency = 'KRW',
  website = 'https://apply.jobaba.net/special/gibon/main.do',
  apply_url = 'https://apply.jobaba.net/special/gibon/main.do',
  sources = ARRAY[
    'https://apply.jobaba.net/special/gibon/main.do',
    'https://www.gg.go.kr/',
    'https://basicincome.stanford.edu/research/basic-income-experiments/'
  ]::text[],
  payout_status = 'Active quarterly disbursements loaded onto Gyeonggi local currency cards (Jobaba portal)',
  application_status = 'Accepting regular annual and quarterly registrations via Jobaba or municipal agricultural centers',
  distribution_type = 'guaranteed_recurrent',
  payout_rail = 'prepaid_card',
  funding_source = 'state_federal',
  involvement_level = 'external_self_apply',
  stanford_experiment_id = 244,
  data_source = 'stanford_basic_income_lab'
WHERE program_id = 322;
