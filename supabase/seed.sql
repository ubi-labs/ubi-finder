-- =====================================================================
-- UBI Finder — seed.sql
-- Seed data for programs, blog_posts, and community tables.
-- =====================================================================

-- =====================================================================
-- PROGRAMS (58 rows)
-- =====================================================================
INSERT INTO programs
 (program_id, name, organization, description, gender_requirement,
  min_age, max_age,
  monthly_amount_usd, currency, available_regions, required_states,
  payment_method, amount_description, max_household_income_usd, eligibility,
  status, website, verified, submitter_email,
  payout_status, application_status, apply_url, sources, internal_status,
  distribution_type, payout_rail, funding_source, state_province, municipalities,
  latitude, longitude)
VALUES
  (1, 'Evanston Guaranteed Income Program 2026', 'City of Evanston',
   'This program provides 102 qualifying Evanston households with $500 per month in unrestricted cash for six months. It targets low-income seniors and families caring for young children, with participants selected by lottery.',
   NULL, 18, NULL, 500.0, 'USD',
   ARRAY['United States']::text[],
   ARRAY['Illinois']::text[],
   'standard', '$500 per month for 6 months', NULL,
   '• Resident of Evanston
• Household income at or below 185% of the federal poverty level
• Age 55 or older, or full-time guardian of a child in second grade or younger
• One application per household
• Must not have participated in a previous Evanston guaranteed income program',
   'active', 'https://www.cityofevanston.org/residents/community_resources/guaranteed_income_program_2026.php', true, NULL,
   'Ongoing', 'No longer accepting applications', 'https://www.cityofevanston.org/residents/community_resources/guaranteed_income_program_2026.php',
   ARRAY['https://www.cityofevanston.org/residents/community_resources/guaranteed_income_program_2026.php']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   'IL', ARRAY['Evanston', 'Cook County']::text[],
   42.0451, -87.6877),

  (2, 'Howard County Guaranteed Basic Income 2', 'Howard County Government and Community Action Council of Howard County',
   'The second Howard County Guaranteed Basic Income program provides participating families with $500 per month in unrestricted cash for 12 months. An additional $500 per month is deposited into savings and released after participants complete financial-literacy requirements.',
   NULL, 18, NULL, 500.0, 'USD',
   ARRAY['United States']::text[],
   ARRAY['Maryland']::text[],
   'standard', '$500 per month for 12 months (plus $500 monthly savings deposit)', NULL,
   '• Resident of Howard County
• At least one child age 17 or younger in the household
• Household income between 150% and 300% of the federal poverty level
• Must not receive income-based housing assistance
• Must attend required Community Action Council meetings
• Must complete financial-literacy education',
   'active', 'https://cac-hc.org/gbi2/', true, NULL,
   'Ongoing', 'No longer accepting applications', 'https://cac-hc.org/gbi2/',
   ARRAY['https://cac-hc.org/gbi2/']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   'MD', ARRAY['Howard County', 'Columbia']::text[],
   39.2037, -76.861),

  (3, 'Healthy Mama, Healthy Baby', 'The Neighbors Trust and Puentes de Salud',
   'Healthy Mama, Healthy Baby provides $8,000 in unconditional cash over 18 months to selected prenatal patients in Philadelphia. It focuses primarily on low-income Latina mothers, including patients who cannot obtain health insurance, and distributes the funds through a debit card.',
   'female', 18, NULL, 444.44, 'USD',
   ARRAY['United States']::text[],
   ARRAY['Pennsylvania']::text[],
   'standard', '$8,000 distributed over 18 months (~$444.44 monthly)', NULL,
   '• Prenatal patient served by Puentes de Salud
• Pregnant
• Selected through the program''s enrollment process
• Priority given to low-income Latina patients and people without health-insurance access',
   'active', 'https://www.neighborstrust.org/program', true, NULL,
   'Ongoing', 'Referral enrollment only', 'https://www.neighborstrust.org/program',
   ARRAY['https://www.neighborstrust.org/program', 'https://www.pa.gov/agencies/dhs/resources/for-residents/guaranteed-income-pilot-projects']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   'PA', ARRAY['Philadelphia']::text[],
   39.9526, -75.1652),

  (4, 'Philly Joy Bank', 'Philadelphia Department of Public Health and Philadelphia City Fund',
   'The Philly Joy Bank provides pregnant Philadelphia residents with $1,000 per month from the second trimester of pregnancy through the child''s first birthday. The program is designed to improve birth outcomes and address racial and geographic disparities in infant mortality.',
   NULL, 18, NULL, 1000.0, 'USD',
   ARRAY['United States']::text[],
   ARRAY['Pennsylvania']::text[],
   'standard', '$1,000 per month during pregnancy and child''s first year', 100000.0,
   '• Age 18 or older
• Between 12 and 24 weeks pregnant at enrollment
• Annual household income below 100000 USD
• Resident of an eligible Philadelphia neighborhood
• Eligible neighborhoods include Nicetown-Tioga, Strawberry Mansion, and the qualifying portion of Cobbs Creek',
   'active', 'https://www.phillyjoybank.org/', true, NULL,
   'Ongoing', 'No longer accepting applications', 'https://www.phillyjoybank.org/',
   ARRAY['https://philacityfund.org/programs/philly-joy-bank/', 'https://www.phillyjoybank.org/', 'https://www.phillyjoybank.org/faqs']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   'PA', ARRAY['Philadelphia']::text[],
   39.9526, -75.1652),

  (5, 'Rx Kids', 'Michigan State University Rx Kids and GiveDirectly',
   'Rx Kids provides unconditional cash to pregnant mothers and families with infants in participating communities, without an income test. Enrolled families generally receive a $1,500 prenatal payment followed by $500 per month for six to twelve months, depending on the community.',
   'female', 18, NULL, 500.0, 'USD',
   ARRAY['United States']::text[],
   ARRAY['Michigan']::text[],
   'standard', '$1,500 prenatal grant plus $500 per month for 6 to 12 months', NULL,
   '• Resident of a currently participating community
• At least 16 weeks pregnant or caring for an infant within the local enrollment-age limit
• Child must meet the participating community''s birth-date requirements
• Must verify identity, residence, pregnancy, or birth as applicable
• No income requirement',
   'active', 'https://rxkids.aidkit.org/', true, NULL,
   'Ongoing', 'Accepting applications', 'https://rxkids.aidkit.org/',
   ARRAY['https://rxkids.org/', 'https://rxkids.org/communities/', 'https://rxkids.aidkit.org/']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   'MI', ARRAY['Flint', 'Genesee County']::text[],
   43.0125, -83.6875),

  (6, 'Preserving Our Diversity', 'City of Santa Monica',
   'Preserving Our Diversity provides monthly cash assistance to low-income, long-term senior renters living in rent-controlled Santa Monica apartments. Benefits vary according to household circumstances, with the maximum for a one-senior household listed at $939 per month.',
   NULL, 65, NULL, 939.0, 'USD',
   ARRAY['United States']::text[],
   ARRAY['California']::text[],
   'standard', 'Up to $939 per month based on household circumstances', NULL,
   '• Age 65 or older
• Resident of Santa Monica
• Must have occupied the current rent-controlled apartment since before January 1, 2010
• Income at or below the applicable very-low-income limit
• Must not already live in subsidized or income-restricted housing
• Income remaining after rent must fall below the program standard',
   'active', 'https://www.santamonica.gov/housing-pod', true, NULL,
   'Ongoing for enrolled participants', 'Accepting waitlist applications', 'https://www.santamonica.gov/housing-pod',
   ARRAY['https://www.santamonica.gov/housing-pod', 'https://www.santamonica.gov/housing-pod-faqs']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   'CA', ARRAY['Santa Monica']::text[],
   34.0195, -118.4912),

  (7, 'Supporting Transitional-Aged Youth and Survivors in Achieving Financial Empowerment Los Angeles', 'City of Los Angeles Community Investment for Families Department',
   'STAY SAFE Los Angeles provides unconditional cash to transitional-aged youth and survivors of intimate-partner violence who are connected to designated community organizations. Participants receive a total of $24,000, generally structured as $1,000 per month, with an alternative front-loaded payment option for some participants.',
   NULL, 18, NULL, 1000.0, 'USD',
   ARRAY['United States']::text[],
   ARRAY['California']::text[],
   'standard', '$24,000 total (structured as $1,000 per month)', NULL,
   '• Age 18 or older
• Resident of the City of Los Angeles
• Transitional-aged youth or survivor of intimate-partner violence
• Existing relationship with an approved community-based partner
• Must complete enrollment through a participating partner',
   'active', 'https://communityinvestment.lacity.gov/programs-resources', true, NULL,
   'Ongoing', 'Partner referral only', 'https://communityinvestment.lacity.gov/programs-resources',
   ARRAY['https://communityinvestment.lacity.gov/programs-resources', 'https://cityclerk.lacity.org/onlinedocs/2021/21-0717-S3_rpt_cao_06-04-25.pdf', 'https://lasentinel.net/price-leads-new-stay-safe-guaranteed-income-expansion.html']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   'CA', ARRAY['Los Angeles']::text[],
   34.0522, -118.2437),

  (8, 'Basic Income for the Arts Scheme 2026-2029', 'Government of Ireland Department of Culture, Communications and Sport',
   'Ireland''s new Basic Income for the Arts scheme will provide 2,000 professional artists and creative-arts workers with EUR 325 per week for three years. The program is intended to support sustained artistic practice and generate further evidence about the effects of basic income in the cultural sector.',
   NULL, 18, NULL, 1640.0, 'EUR',
   ARRAY['Ireland']::text[],
   ARRAY[]::text[],
   'standard', 'EUR 325 per week for 3 years (~$1,640 USD monthly)', NULL,
   '• Age 18 or older
• Professional practicing artist or creative-arts worker
• Primarily based in the Republic of Ireland
• Must provide evidence of professional artistic practice
• Must meet tax-compliance requirements',
   'upcoming', 'https://www.gov.ie/en/department-of-culture-communications-and-sport/publications/basic-income-for-the-arts-scheme-2026-2029-guidelines-for-application/', true, NULL,
   'Planned to begin by the end of 2026 and backdated to September 2026', 'No longer accepting applications', 'https://www.gov.ie/en/department-of-culture-communications-and-sport/publications/basic-income-for-the-arts-scheme-2026-2029-guidelines-for-application/',
   ARRAY['https://www.gov.ie/en/department-of-culture-communications-and-sport/publications/basic-income-for-the-arts-scheme-2026-2029-guidelines-for-application/', 'https://www.gov.ie/en/department-of-culture-communications-and-sport/publications/basic-income-for-the-arts-scheme-2026-2029-faq/', 'https://www.gov.ie/en/department-of-culture-communications-and-sport/press-releases/minister-odonovan-announces-the-new-basic-income-for-the-arts-scheme/', 'https://www.ecb.europa.eu/stats/policy_and_exchange_rates/euro_reference_exchange_rates/html/eurofxref-graph-usd.en.html']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   'Leinster', ARRAY['Dublin', 'Nationwide']::text[],
   53.3498, -6.2603),

  (9, 'Rural Basic Income Pilot Programme', 'Republic of Korea Ministry of Agriculture, Food and Rural Affairs',
   'South Korea''s rural basic-income pilot pays residents of ten participating counties KRW 150,000 per month in locally usable currency during 2026 and 2027. The program seeks to address rural depopulation, strengthen household stability, and stimulate local economic activity.',
   NULL, 18, NULL, 107.0, 'KRW',
   ARRAY['South Korea']::text[],
   ARRAY['Gyeonggi', 'Gangwon', 'North Chungcheong', 'South Chungcheong', 'North Jeolla', 'South Jeolla', 'North Gyeongsang', 'South Gyeongsang']::text[],
   'standard', 'KRW 150,000 per month in local currency (~$107 USD monthly)', NULL,
   '• Registered resident of one of the ten participating counties
• Must actually reside in the participating county
• Residents with uncertain residence may need to demonstrate presence at least three days per week
• New residents may need to complete a 90-day residence-verification period',
   'active', 'https://www.mafra.go.kr/english/756/subview.do?enc=Zm5jdDF8QEB8JTJGYmJzJTJGZW5nbGlzaCUyRjI1JTJGNTc3MjIzJTJGYXJ0Y2xWaWV3LmRvJTNG', true, NULL,
   'Ongoing', 'Accepting local applications and residence verification', 'https://www.mafra.go.kr/english/756/subview.do?enc=Zm5jdDF8QEB8JTJGYmJzJTJGZW5nbGlzaCUyRjI1JTJGNTc3MjIzJTJGYXJ0Y2xWaWV3LmRvJTNG',
   ARRAY['https://www.mafra.go.kr/english/756/subview.do?enc=Zm5jdDF8QEB8JTJGYmJzJTJGZW5nbGlzaCUyRjI1JTJGNTc3MjIzJTJGYXJ0Y2xWaWV3LmRvJTNG']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   'Gyeonggi', ARRAY['Participating Counties']::text[],
   37.4138, 127.5183),

  (10, 'ENRA Universal Basic Income Program', 'Republic of the Marshall Islands Ministry of Finance',
   'ENRA distributes quarterly, unconditional payments to eligible Marshallese citizens residing in the Marshall Islands. The long-term program is funded through Compact-related revenue and is expected to continue for approximately two decades, with the listed monthly value representing the equivalent of a roughly $200 quarterly payment.',
   NULL, 18, NULL, 66.67, 'USD',
   ARRAY['Marshall Islands']::text[],
   ARRAY[]::text[],
   'standard', 'Equivalent of ~$200 USD quarterly (~$66.67 USD monthly)', NULL,
   '• Marshallese citizen
• Resident of the Republic of the Marshall Islands
• Must enroll and maintain eligibility through the Marshall Islands Social Security Administration
• Must satisfy identity and residency verification requirements',
   'active', 'https://mof.gov.mh/usdm1/enra/', true, NULL,
   'Ongoing quarterly', 'Accepting enrollment through MISSA', 'https://mof.gov.mh/usdm1/enra/',
   ARRAY['https://mof.gov.mh/usdm1/enra/', 'https://mof.gov.mh/usdm1-whitepaper/', 'https://marshallislandsjournal.com/enra-bump-up/', 'https://eastasiaforum.org/2026/01/07/the-price-of-the-marshall-islands-universal-basic-income/']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   'Majuro', ARRAY['Majuro', 'Nationwide']::text[],
   7.1315, 171.1845),

  (11, 'Alaska Permanent Fund Dividend 2026', 'State of Alaska Permanent Fund Dividend Division',
   'The Alaska Permanent Fund Dividend distributes an annual cash payment to qualifying residents from state mineral-revenue investment earnings. The 2026 payment was set at a combined $1,200, including the dividend and energy rebate, which is shown here as a $100 monthly equivalent.',
   NULL, 18, NULL, 100.0, 'USD',
   ARRAY['United States']::text[],
   ARRAY['Alaska']::text[],
   'standard', '$1,200 annual payment (~$100 USD monthly equivalent)', NULL,
   '• Alaska resident throughout calendar year 2025
• Intent to remain an Alaska resident indefinitely
• Must not have claimed residency in another state or country after December 31, 2024
• Must satisfy allowable-absence rules
• Must satisfy applicable criminal-conviction and incarceration restrictions
• Must meet the required physical-presence test',
   'active', 'https://pfd.alaska.gov/', true, NULL,
   'Scheduled for October 2026', 'No longer accepting applications', 'https://pfd.alaska.gov/',
   ARRAY['https://pfd.alaska.gov/', 'https://pfd.alaska.gov/eligibility/eligibility-requirements', 'https://pfd.alaska.gov/application/filing-period', 'https://alaskabeacon.com/2026/05/18/alaska-lawmakers-reach-budget-deal-with-1000-pfd-and-200-energy-rebate-for-residents/']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   'AK', ARRAY['Statewide']::text[],
   64.2008, -149.4937),

  (12, 'Macao Wealth Partaking Scheme 2026', 'Government of the Macao Special Administrative Region',
   'The Wealth Partaking Scheme distributes an annual cash payment to qualifying Macao residents, with permanent residents receiving MOP 10,000 in 2026. The listed monthly amount is the approximate monthly equivalent of that annual payment, while residents with qualifying absences may submit an exception claim.',
   NULL, 18, NULL, 104.0, 'MOP',
   ARRAY['China']::text[],
   ARRAY['Macao Special Administrative Region']::text[],
   'standard', 'MOP 10,000 annual payment (~$104 USD monthly equivalent)', NULL,
   '• Holder of a valid or renewable Macao resident identity card
• Permanent-resident payment requires permanent resident status
• Generally present in Macao for at least 183 days during 2025
• Residents below the 183-day threshold must qualify for an approved exemption',
   'active', 'https://www.planocp.gov.mo/en/request/atleast183_2026', true, NULL,
   '2026 standard distribution completed; approved exception claims continue', 'Automatic for listed residents; residence-exception claims accepted', 'https://www.planocp.gov.mo/en/request/atleast183_2026',
   ARRAY['https://www.planocp.gov.mo/en/about/intro', 'https://www.planocp.gov.mo/en/timetable', 'https://www.planocp.gov.mo/en/faq', 'https://www.planocp.gov.mo/en/request/atleast183_2026']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   'Macao', ARRAY['Macao SAR']::text[],
   22.1987, 113.5439),

  (13, 'Québec Basic Income Program', 'Government of Québec',
   'Québec''s Basic Income Program provides an enhanced monthly income to people with severe and persistent health-related employment limitations. Eligible Social Solidarity recipients are generally enrolled automatically, and the 2026 base benefit is CAD 1,336 per month before possible adjustments.',
   NULL, 18, NULL, 961.0, 'CAD',
   ARRAY['Canada']::text[],
   ARRAY['Quebec']::text[],
   'standard', 'CAD 1,336 per month base benefit (~$961 USD monthly)', NULL,
   '• Recipient of Québec''s Social Solidarity Program
• Severe employment limitations
• Must have had severe employment limitations for at least 66 of the previous 72 months
• Must continue satisfying applicable income and asset rules',
   'active', 'https://www.quebec.ca/en/family-and-support-for-individuals/social-assistance-social-solidarity/basic-income-program', true, NULL,
   'Ongoing', 'Automatic enrollment', 'https://www.quebec.ca/en/family-and-support-for-individuals/social-assistance-social-solidarity/basic-income-program',
   ARRAY['https://www.quebec.ca/en/family-and-support-for-individuals/social-assistance-social-solidarity/basic-income-program', 'https://www.bankofcanada.ca/rates/exchange/daily-exchange-rates-lookup/']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   'QC', ARRAY['Province-wide']::text[],
   46.8139, -71.208),

  (14, 'Guaranteed Income Supplement', 'Government of Canada',
   'The Guaranteed Income Supplement is a monthly, tax-free payment for low-income seniors who receive the Old Age Security pension. The maximum payment for a single, widowed, or divorced recipient is approximately CAD 1,123.17 per month, although the actual amount depends on income and marital status.',
   NULL, 18, NULL, 808.0, 'CAD',
   ARRAY['Canada']::text[],
   ARRAY[]::text[],
   'standard', 'Up to CAD 1,123.17 per month (~$808 USD monthly)', NULL,
   '• Age 65 or older
• Receives or is eligible for the Old Age Security pension
• Annual income below the applicable threshold
• Must satisfy Old Age Security residence requirements
• Must file annual income-tax returns to maintain accurate benefit calculations',
   'active', 'https://www.canada.ca/en/services/benefits/publicpensions/old-age-security/guaranteed-income-supplement.html', true, NULL,
   'Ongoing', 'Automatic enrollment or accepting applications', 'https://www.canada.ca/en/services/benefits/publicpensions/old-age-security/guaranteed-income-supplement.html',
   ARRAY['https://www.canada.ca/en/services/benefits/publicpensions/old-age-security/guaranteed-income-supplement.html', 'https://www.bankofcanada.ca/rates/exchange/daily-exchange-rates-lookup/']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   'ON', ARRAY['Nationwide']::text[],
   45.4215, -75.6972),

  (15, 'Ingreso Mínimo Vital', 'Government of Spain Social Security Administration',
   'Ingreso Mínimo Vital is a national minimum-income benefit intended to prevent poverty and social exclusion among financially vulnerable individuals and households. In 2026, the guaranteed benchmark for a single adult is EUR 733.60 per month, with the actual payment calculated as the difference between the benchmark and countable household income.',
   NULL, 18, NULL, 851.0, 'EUR',
   ARRAY['Spain']::text[],
   ARRAY[]::text[],
   'standard', 'EUR 733.60 per month single-adult benchmark (~$851 USD monthly)', NULL,
   '• Legal and effective residence in Spain
• Generally at least one year of continuous residence, subject to exceptions
• Household income below the applicable guaranteed-income threshold
• Household assets below the applicable limit
• Individual applicants are generally age 23 or older, subject to exceptions
• Must satisfy household-formation and economic-vulnerability rules',
   'active', 'https://imv.seg-social.es/', true, NULL,
   'Ongoing', 'Accepting applications', 'https://imv.seg-social.es/',
   ARRAY['https://www.seg-social.es/wps/portal/wss/internet/Trabajadores/PrestacionesPensionesTrabajadores/65850d68-8d06-4645-bde7-05374ee42ac7', 'https://imv.seg-social.es/', 'https://www.ecb.europa.eu/stats/policy_and_exchange_rates/euro_reference_exchange_rates/html/eurofxref-graph-usd.en.html']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   'Madrid', ARRAY['Nationwide']::text[],
   40.4168, -3.7038),

  (16, 'Social Relief of Distress Grant', 'South African Social Security Agency',
   'South Africa''s Social Relief of Distress Grant provides ZAR 370 per month to working-age people with insufficient income or financial support. The national benefit has been extended through March 2027 and uses recurring income and identity checks to determine monthly eligibility.',
   NULL, 18, NULL, 23.0, 'ZAR',
   ARRAY['South Africa']::text[],
   ARRAY[]::text[],
   'standard', 'ZAR 370 per month (~$23 USD monthly)', NULL,
   '• Age 18 to 59
• South African citizen, permanent resident, refugee, asylum seeker, or qualifying special-permit holder
• Currently residing in South Africa
• Insufficient financial means under the program''s monthly assessment
• Must not receive a disqualifying social grant or other overlapping public support
• Must consent to identity, bank-account, and income verification',
   'active', 'https://srd.sassa.gov.za/', true, NULL,
   'Ongoing through March 2027', 'Accepting applications', 'https://srd.sassa.gov.za/',
   ARRAY['https://srd.sassa.gov.za/', 'https://srd.sassa.gov.za/said', 'https://www.sanews.gov.za/south-africa/public-comment-sought-special-covid-19-srd-amendments', 'https://www.sanews.gov.za/south-africa/social-grants-increase']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   'Gauteng', ARRAY['Nationwide']::text[],
   -25.7479, 28.2293),

  (17, 'GiveDirectly 12-Year Universal Basic Income Study', 'GiveDirectly',
   'GiveDirectly''s long-term Kenya study provides selected adults with approximately $22.50 per month for 12 years, making it one of the longest-running randomized basic-income experiments. Payments are unconditional and delivered through mobile money to eligible adults in selected rural villages.',
   NULL, 18, NULL, 22.5, 'KES',
   ARRAY['Kenya']::text[],
   ARRAY[]::text[],
   'standard', 'Approximately $22.50 USD per month for 12 years', NULL,
   '• Adult resident of a village selected for the long-term treatment group
• Must have been enrolled during the original village census and enrollment period
• Must maintain access to the registered mobile-money payment channel
• No work, spending, or repayment conditions',
   'active', 'https://www.givedirectly.org/ubi', true, NULL,
   'Ongoing', 'No longer accepting applications', 'https://www.givedirectly.org/ubi',
   ARRAY['https://www.givedirectly.org/ubi', 'https://www.givedirectly.org/2023-ubi-results']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   'Siaya', ARRAY['Bondo', 'Ugunja']::text[],
   -0.7821, 35.3416),

  (18, 'Mein Grundeinkommen Basic Income Raffle', 'Mein Grundeinkommen e.V.',
   'Mein Grundeinkommen uses crowdfunding to award unconditional basic incomes through free public raffles. Each winner receives EUR 1,000 per month for one year, and participation is open internationally subject to the organization''s registration and raffle rules.',
   NULL, 18, NULL, 1161.0, 'EUR',
   ARRAY['Global']::text[],
   ARRAY[]::text[],
   'standard', 'EUR 1,000 per month for 1 year (~$1,161 USD monthly)', NULL,
   '• Create a Mein Grundeinkommen account
• Register for or confirm participation in an upcoming raffle
• Comply with the raffle terms and identity-verification requirements
• No income or employment requirement',
   'active', 'https://www.mein-grundeinkommen.de/verlosung', true, NULL,
   'Ongoing', 'Accepting raffle entries', 'https://www.mein-grundeinkommen.de/verlosung',
   ARRAY['https://www.mein-grundeinkommen.de/', 'https://www.mein-grundeinkommen.de/verlosung', 'https://www.mein-grundeinkommen.de/infos/in-english', 'https://www.ecb.europa.eu/stats/policy_and_exchange_rates/euro_reference_exchange_rates/html/eurofxref-graph-usd.en.html']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   'Berlin', ARRAY['Berlin', 'Global']::text[],
   52.52, 13.405),

  (19, 'World WLD Airdrop Program', 'World Foundation',
   'World distributes recurring WLD token grants to eligible proof-of-human participants who enrolled in an airdrop cycle before the June 2026 cutoff. Existing cycles continue for up to 12 months, but installment sizes decline over time and vary by verification status and cycle.',
   NULL, 18, NULL, 0.59, 'WLD',
   ARRAY['Global']::text[],
   ARRAY[]::text[],
   'digital', 'Recurring WLD token grants (~$0.59 USD monthly equivalent)', NULL,
   '• Must be located in an eligible jurisdiction
• Must hold an eligible World account
• Must satisfy the applicable proof-of-human verification requirement
• Must have enrolled in an airdrop cycle before June 1, 2026
• Must claim each available installment within the applicable claim period',
   'active', 'https://support.world.org/hc/en-us/articles/30969185598739-Updates-to-the-Airdrop-Program', true, NULL,
   'Ongoing for existing cycles', 'No longer accepting new cycles', 'https://support.world.org/hc/en-us/articles/30969185598739-Updates-to-the-Airdrop-Program',
   ARRAY['https://support.world.org/hc/en-us/articles/30969185598739-Updates-to-the-Airdrop-Program', 'https://whitepaper.world.org/designing-for-scale/2026-03-24', 'https://www.kraken.com/prices/worldcoin']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   'Global', ARRAY['Global']::text[],
   35.0, -20.0),

  (20, 'Citizen Account Program', 'Government of Saudi Arabia Ministry of Human Resources and Social Development',
   'Saudi Arabia''s Citizen Account Program provides monthly cash support to eligible households to offset the effects of economic reforms and changes in living costs. Payment amounts vary by household income and composition, with a reported average family payment of approximately SAR 1,474 in early 2026.',
   NULL, 18, NULL, 393.0, 'SAR',
   ARRAY['Saudi Arabia']::text[],
   ARRAY[]::text[],
   'standard', 'Average SAR 1,474 per month (~$393 USD monthly)', NULL,
   '• Saudi citizen or otherwise within an expressly eligible beneficiary category
• Resident of Saudi Arabia
• Household or independent-individual status must be verified
• Income and assets must fall within the program''s eligibility calculations
• Must disclose household composition and income information
• Must maintain accurate information through the Citizen Account portal',
   'active', 'https://eservices.ca.gov.sa/', true, NULL,
   'Ongoing', 'Accepting registrations', 'https://eservices.ca.gov.sa/',
   ARRAY['https://www.hrsd.gov.sa/en/care-about-you/social-protection', 'https://www.hrsd.gov.sa/en/media-center/news/%D9%85%D9%86%D8%B8%D9%88%D9%85%D8%A9-%D8%A7%D9%84%D9%85%D9%88%D8%A7%D8%B1%D8%AF-%D8%A7%D9%84%D8%A8%D8%B4%D8%B1%D9%8A%D8%A9-%D8%AD%D9%82%D9%82%D8%AA-70-%D9%85%D9%86-%D9%85%D8%B3%D8%AA%D9%87%D8%AF%D9%81%D8%A7%D8%AA%D9%87%D8%A7', 'https://eservices.ca.gov.sa/', 'https://www.middleeastmonitor.com/20260112-9-8-million-saudis-receive-cash-support/']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   'Riyadh', ARRAY['Nationwide']::text[],
   24.7136, 46.6753),

  (21, 'GoodDollar', 'GoodDollar Foundation & GoodDAO',
   'GoodDollar is a decentralized, reserve-backed crypto basic income protocol and DAO. It generates yield through DeFi protocols and distributes daily G$ basic income directly to verified unique humans globally via smart contracts on Celo and Ethereum networks.',
   NULL, 18, NULL, 10.0, 'G$',
   ARRAY['Global']::text[],
   ARRAY[]::text[],
   'digital', 'Daily free G$ claims via GoodWallet (approx. $5–$15 USD/mo)', NULL,
   '• Unique human verification via FaceTec 3D liveness check
• Compatible Web3 wallet (GoodWallet / Celo / Ethereum)
• Claimable once every 24 hours
• No minimum income, location, or citizenship restriction',
   'active', 'https://wallet.gooddollar.org', true, NULL,
   'Ongoing daily', 'Accepting registrations', 'https://wallet.gooddollar.org',
   ARRAY['https://www.gooddollar.org', 'https://dashboard.gooddollar.org', 'https://docs.gooddollar.org']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   'Global', ARRAY['Global']::text[],
   32.0853, 34.7818),

  (22, 'European Digital Euro Pilot', 'European Central Bank (ECB) & Eurosystem',
   'The European Digital Euro initiative is the official Eurosystem framework exploring a retail central bank digital currency (CBDC) to complement physical cash. It aims to deliver a pan-European, cost-free, privacy-preserving digital payment instrument usable across all 20 euro area countries for in-store, online, and person-to-person transactions. The Eurosystem is currently in a preparatory testing and rulebook development phase; controlled technical and user pilots are targeted for 2027 ahead of potential formal issuance around 2029 pending EU legislative adoption.',
   NULL, 18, NULL, 47.0, 'EUR',
   ARRAY['Germany', 'France', 'Spain', 'Italy', 'Ireland', 'Netherlands', 'Belgium', 'Austria', 'Portugal', 'Finland', 'Greece']::text[],
   ARRAY[]::text[],
   'digital', '43 EUR (~$47 USD) testing allowance benchmark (planned holding limit / pilot transaction allocation)', NULL,
   '• Legal resident or citizen of a participating Eurozone member state
• Euro-denominated payment account with a licensed European Payment Service Provider (PSP) or credit institution
• Identity verification meeting European Union AML/CFT and consumer protection frameworks
• Technical pilot participation subject to Eurosystem cohort selection, supervised sandbox parameters, and holding-limit rules',
   'upcoming', 'https://www.ecb.europa.eu/euro/digital_euro/html/index.en.html', true, NULL,
   'Planned (Targeting 2027 Eurosystem pilot phase)', 'Planned; pilot cohort enrollment pending EU legislation', 'https://www.ecb.europa.eu/euro/digital_euro/html/index.en.html',
   ARRAY['https://www.ecb.europa.eu/euro/digital_euro/html/index.en.html', 'https://www.ecb.europa.eu/paym/digital_euro/', 'https://www.centralbank.ie/consumer-hub/explainers/what-is-the-digital-euro']::text[], 'active',
   'guaranteed_recurrent', 'crypto_wallet', 'state_federal',
   'Hesse', ARRAY['Eurozone']::text[],
   50.1109, 8.6821),

  (23, 'FundLoop', 'FundLoop Network',
   'FundLoop is a networked mutual-prosperity protocol where participating software platforms and startup founders pool a recurring share (e.g. 1%) of platform revenue into a community distribution fund. Operating in structured monthly epochs, FundLoop combines project commitment intake, Zero-Knowledge proof-of-personhood via CUBID, and governed allocation algorithms to distribute unconditional rewards and Citizen Salaries directly to active users, volunteers, and product champions. On-chain settlement operates on the Base network with fail-closed governance gates.',
   NULL, 18, NULL, 25.0, 'USD',
   ARRAY['Global']::text[],
   ARRAY[]::text[],
   'digital', 'Variable monthly revenue-share distribution based on pool size and contribution weighting (benchmark ~$25 USD/mo)', NULL,
   '• Verified uniqueness and proof-of-personhood via CUBID.me (zero-knowledge sybil resistance without exposing private identity data)
• Active participation, testing, feedback, or contribution within one or more participating network apps during the open monthly epoch
• Compatible EVM-compatible digital wallet (Base network) connected to recipient profile
• Account in good standing; open universally to participants worldwide regardless of nationality or geographic region',
   'upcoming', 'https://fundloop-website.vercel.app/en', true, 'kazanderdad@gmail.com',
   'Planned (Inaugural Cohort / Epoch 1 onboarding under way)', 'Planned; onboarding inaugural projects and participant registrations', 'https://fundloop-website.vercel.app/en/participation',
   ARRAY['https://fundloop-website.vercel.app/en', 'https://fundloop-website.vercel.app/en/participation', 'https://fundloop-website.vercel.app/en/founders', 'https://fundloop.org']::text[], 'active',
   'daily_claim_protocol', 'crypto_wallet', 'protocol_yield',
   'Global', ARRAY['Global']::text[],
   46.2044, 6.1432),

  (24, 'Community Support Initiative', 'Regional Development Council',
   'Quarterly support payments for local residents',
   NULL, 18, NULL, 123.0, 'USD',
   ARRAY['Australia', 'New Zealand']::text[],
   ARRAY[]::text[],
   'standard', '123 per month', NULL,
   'Local residents meeting income criteria',
   'active', 'https://example.com/program2', true, NULL,
   'Ongoing', 'Accepting applications', 'https://example.com/program2',
   ARRAY[]::text[], 'deleted',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   NULL, ARRAY[]::text[],
   NULL, NULL),

  (25, 'Digital Income Project', 'Future Foundation',
   'Monthly digital currency payments for eligible participants',
   NULL, 18, NULL, 234.0, 'USD',
   ARRAY['United States']::text[],
   ARRAY['California', 'New York']::text[],
   'digital', '234 per month', 40000.0,
   'Must be a resident of CA or NY',
   'active', 'https://example.com/digital-income', true, NULL,
   'Ongoing', 'Accepting applications', 'https://example.com/digital-income',
   ARRAY[]::text[], 'deleted',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   NULL, ARRAY[]::text[],
   NULL, NULL),

  (26, 'Global Basic Income', 'World UBI Initiative',
   'Worldwide basic income program with flexible payment options',
   NULL, 18, NULL, 329.0, 'USD',
   ARRAY[]::text[],
   ARRAY[]::text[],
   'both', '345', NULL,
   'Open to all globally',
   'upcoming', 'https://example.com/global-ubi', true, NULL,
   'Planned', 'Not open yet', 'https://example.com/global-ubi',
   ARRAY[]::text[], 'deleted',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   NULL, ARRAY[]::text[],
   NULL, NULL),

  (27, 'Women''s Empowerment Fund', 'Global Women''s Initiative',
   'Supporting women through monthly basic income',
   'female', 18, NULL, 800.0, 'USD',
   ARRAY['United States', 'Canada', 'United Kingdom']::text[],
   ARRAY[]::text[],
   'both', '$800 monthly', 50000.0,
   'Women in eligible countries',
   'active', 'https://example.com/wef', true, NULL,
   'Ongoing', 'Accepting applications', 'https://example.com/wef',
   ARRAY[]::text[], 'deleted',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   NULL, ARRAY[]::text[],
   NULL, NULL),

  (28, 'Youth Basic Income', 'Future Foundation',
   'Basic income for young adults',
   NULL, 18, NULL, 1000.0, 'USD',
   ARRAY['United States']::text[],
   ARRAY['California', 'New York']::text[],
   'digital', '$1,000 monthly', 30000.0,
   '18-25 year olds in CA or NY',
   'active', 'https://example.com/ybi', true, NULL,
   'Ongoing', 'Accepting applications', 'https://example.com/ybi',
   ARRAY[]::text[], 'deleted',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   NULL, ARRAY[]::text[],
   NULL, NULL),

  (29, 'Digital Income Project (Duplicate)', 'Future Economy Foundation',
   'A pilot program providing monthly digital currency payments to residents in select urban areas.',
   NULL, 18, NULL, 500.0, 'USD',
   ARRAY['United States']::text[],
   ARRAY['California', 'New York']::text[],
   'digital', '$500 monthly in digital currency', NULL,
   NULL,
   'active', 'https://example.com/digital-income', false, NULL,
   'Ongoing', 'Accepting applications', 'https://example.com/digital-income',
   ARRAY[]::text[], 'deleted',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   NULL, ARRAY[]::text[],
   NULL, NULL),

  (30, 'Community Support Initiative (Duplicate)', 'Regional Development Coalition',
   'Providing basic income to support local community resilience and economic development.',
   NULL, 18, NULL, 650.0, 'USD',
   ARRAY['United States']::text[],
   ARRAY['Michigan', 'Ohio', 'Pennsylvania']::text[],
   'standard', '$650 monthly via direct deposit', NULL,
   NULL,
   'active', 'https://example.com/community-support', false, NULL,
   'Ongoing', 'Accepting applications', 'https://example.com/community-support',
   ARRAY[]::text[], 'deleted',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   NULL, ARRAY[]::text[],
   NULL, NULL),

  (31, 'Rural Resilience Program', 'Agricultural Futures Institute',
   'Supporting rural communities with monthly income supplements to address economic challenges in agricultural regions.',
   NULL, 18, NULL, 450.0, 'USD',
   ARRAY['United States', 'Canada']::text[],
   ARRAY[]::text[],
   'both', '$450 monthly with payment options', NULL,
   NULL,
   'active', 'https://example.com/rural-resilience', false, NULL,
   'Ongoing', 'Accepting applications', 'https://example.com/rural-resilience',
   ARRAY[]::text[], 'deleted',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   NULL, ARRAY[]::text[],
   NULL, NULL),

  (32, 'Youth Opportunity Fund', 'Next Generation Alliance',
   'Providing financial support to young adults ages 18-24 to pursue education, training, or entrepreneurship.',
   NULL, 18, NULL, 800.0, 'USD',
   ARRAY['United Kingdom', 'Canada']::text[],
   ARRAY[]::text[],
   'standard', '$800 monthly stipend', NULL,
   NULL,
   'upcoming', 'https://example.com/youth-opportunity', false, NULL,
   'Planned', 'Not open yet', 'https://example.com/youth-opportunity',
   ARRAY[]::text[], 'deleted',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   NULL, ARRAY[]::text[],
   NULL, NULL),

  (33, 'asdf', 'asdf',
   'afsd',
   NULL, 18, NULL, 12.0, 'USD',
   ARRAY[]::text[],
   ARRAY[]::text[],
   'standard', 'asdf', NULL,
   'asdf',
   'active_open', 'https://asdf.com', false, 'kazanderdad@gmail.com',
   'Ongoing', 'Accepting applications', 'https://asdf.com',
   ARRAY[]::text[], 'deleted',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   NULL, ARRAY[]::text[],
   NULL, NULL),

  (34, 'Test 2', 'asdf',
   'asdf',
   NULL, 18, NULL, 0.0, 'USD',
   ARRAY[]::text[],
   ARRAY[]::text[],
   'standard', 'asdf', NULL,
   'asdf',
   'active_open', 'https://asdf.com', false, 'kazanderdad@gmail.com',
   'Ongoing', 'Accepting applications', 'https://asdf.com',
   ARRAY[]::text[], 'deleted',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   NULL, ARRAY[]::text[],
   NULL, NULL),

  (35, 'Women''s Economic Empowerment Initiative', 'Gender Equity Coalition',
   'Financial support program designed to promote economic independence and entrepreneurship for women.',
   'female', 18, NULL, 700.0, 'USD',
   ARRAY['United States', 'Canada', 'United Kingdom']::text[],
   ARRAY[]::text[],
   'standard', '$700 monthly grant', NULL,
   NULL,
   'active', 'https://example.com/womens-empowerment', false, NULL,
   'Ongoing', 'Accepting applications', 'https://example.com/womens-empowerment',
   ARRAY[]::text[], 'deleted',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   NULL, ARRAY[]::text[],
   NULL, NULL),

  (36, 'Universal Dividend Network', 'Global Commons Foundation',
   'Blockchain-based UBI available worldwide, using cryptocurrency for efficient borderless payments.',
   NULL, 18, NULL, 300.0, 'USD',
   ARRAY[]::text[],
   ARRAY[]::text[],
   'digital', 'Equivalent of $300 monthly in cryptocurrency', NULL,
   NULL,
   'active', 'https://example.com/universal-dividend', false, NULL,
   'Ongoing', 'Accepting applications', 'https://example.com/universal-dividend',
   ARRAY[]::text[], 'deleted',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   NULL, ARRAY[]::text[],
   NULL, NULL),

  (37, 'Senior Security Program', 'Elder Care Alliance',
   'Income supplement for seniors over 65 to help with rising costs of living and healthcare expenses.',
   NULL, 18, NULL, 550.0, 'USD',
   ARRAY['United States', 'Canada']::text[],
   ARRAY[]::text[],
   'standard', '$550 monthly payment', NULL,
   NULL,
   'active', 'https://example.com/senior-security', false, NULL,
   'Ongoing', 'Accepting applications', 'https://example.com/senior-security',
   ARRAY[]::text[], 'deleted',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   NULL, ARRAY[]::text[],
   NULL, NULL),

  (38, 'New Brunswick Youth Basic Income Pilot', 'Government of New Brunswick & Social Labs',
   'A regional basic income initiative delivering monthly financial floors to young adults transitioning into the workforce in Moncton and Saint John.',
   NULL, 18, 29, 750.0, 'CAD',
   ARRAY['Canada']::text[],
   ARRAY['NB', 'New Brunswick']::text[],
   'standard', '$1,000 CAD per month', NULL,
   NULL,
   'active', 'https://www2.gnb.ca', true, NULL,
   'Ongoing', 'Open', 'https://www2.gnb.ca/apply',
   ARRAY[]::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'municipal_government',
   'NB', ARRAY['Moncton', 'Saint John']::text[],
   46.0878, -64.7782),

  (39, 'Cook County Promise Guaranteed Income Program — Next Phase', 'Cook County Government, Bureau of Economic Development',
   'The next phase is a successor to Cook County''s 2022–2025 Promise pilot, which paid 3,250 low-to-moderate-income households $500 per month for two years. Cook County has appropriated $7.5 million for fiscal year 2026 and is designing the successor, but its payment amount, participant count, application process, and final eligibility rules have not been announced; the numeric amount is therefore recorded as 0 rather than assuming the prior $500 rate.',
   NULL, 18, NULL, 0.0, 'USD',
   ARRAY['United States']::text[],
   ARRAY['Illinois']::text[],
   'standard', 'Payment amount under design for FY2026', NULL,
   '• Intended for Cook County residents\n• Final income, household, and other eligibility requirements have not been announced\n• Program design is expected to be completed in late 2026',
   'upcoming', 'https://www.cookcountyil.gov/promise', true, NULL,
   'Planned; payment amount not announced', 'Accepting interest form; applications not open', 'https://www.cookcountyil.gov/promise',
   ARRAY['https://www.cookcountyil.gov/promise', 'https://arpa.cookcountyil.gov/promise-guaranteed-income-pilot-program']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'municipal_government',
   'IL', ARRAY['Cook County', 'Chicago']::text[],
   41.8781, -87.6298),

  (40, 'California Guaranteed Income Pilot Program for Older Californians (CASH SJC)', 'California Department of Social Services, Housing Authority of the County of San Joaquin, and GiveDirectly',
   'California''s Guaranteed Income Pilot Program for Older Californians is being implemented in San Joaquin County as CASH SJC by the county housing authority and GiveDirectly, with state funding. Selected seniors will receive $1,000 per month for 12 months with no spending restrictions; applications open August 24, 2026, and the first payment is scheduled for January 20, 2027.',
   NULL, 18, NULL, 1000.0, 'USD',
   ARRAY['United States']::text[],
   ARRAY['California']::text[],
   'standard', '$1,000 per month for 12 months', NULL,
   '• Age 60 or older\n• Resident of San Joaquin County\n• On the Housing Authority of the County of San Joaquin waitlist\n• Household income at or below the housing authority''s applicable limits\n• Not currently receiving payments from another guaranteed income program',
   'upcoming', 'https://cashsjc.aidkit.org/apply', true, NULL,
   'Planned; first payment scheduled for January 20, 2027', 'Not open yet; opens August 24, 2026', 'https://cashsjc.aidkit.org/apply',
   ARRAY['https://www.cdss.ca.gov/inforesources/guaranteed-income-pilot-program/older-californians', 'https://www.cdss.ca.gov/Portals/9/GIPP/2025-intent-award-final.pdf', 'https://www.givedirectly.org/cashsjc']::text[], 'active',
   'guaranteed_recurrent', 'prepaid_card', 'state_federal',
   'CA', ARRAY['San Joaquin County', 'Stockton']::text[],
   37.9577, -121.2908),

  (41, 'The Bridge Project', 'The Bridge Project',
   'The Bridge Project provides unrestricted cash to pregnant mothers and their babies to reduce childhood poverty and strengthen maternal and infant stability. Its standard three-year schedule includes a $1,125 prenatal stipend, $750 per month for the child''s first 15 months, and $375 per month for the next 21 months; the numeric field records the initial $750 monthly rate. Open enrollment currently covers Arkansas, selected Maryland ZIP codes, and ARC-designated counties in Kentucky, Ohio, West Virginia, and Tennessee, with Appalachia using an 18-month high-cash/low-cash research design.',
   'female', 18, NULL, 750.0, 'USD',
   ARRAY['United States']::text[],
   ARRAY['Arkansas', 'Maryland', 'Kentucky', 'Ohio', 'West Virginia', 'Tennessee']::text[],
   'standard', '$1,125 prenatal stipend + $750/mo for 15 mos + $375/mo for 21 mos', NULL,
   '• Pregnant mother\n• Arkansas cohort A: Arkansas resident, age 18–22, no more than 27 weeks pregnant, and annual household income of $44,000 or less\n• Arkansas cohort B: Arkansas resident age 18 or older, current or former U.S. Armed Forces member, no more than 27 weeks pregnant, and annual household income under $44,000 excluding specified veterans benefits\n• Maryland: age 18 or older, no more than 27 weeks pregnant, Medicaid eligible, and resident of ZIP code 21225, 21230, 21215, or 21740\n• Appalachia: age 18 or older, no more than 14 weeks pregnant, proof of pregnancy, and resident of an ARC-designated county in Kentucky, Ohio, West Virginia, or Tennessee',
   'active', 'https://www.bridgeproject.org/apply', true, NULL,
   'Ongoing', 'Accepting applications', 'https://www.bridgeproject.org/apply',
   ARRAY['https://www.bridgeproject.org/', 'https://www.bridgeproject.org/apply', 'https://governor.maryland.gov/news/press-releases/governor-moore-announces-partnership-bridge-project']::text[], 'active',
   'guaranteed_recurrent', 'prepaid_card', 'philanthropic_grant',
   'Multi-state', ARRAY['Baltimore', 'Appalachia']::text[],
   39.2904, -76.6122),

  (42, 'The Magnolia Mother’s Trust', 'Springboard to Opportunities',
   'The Magnolia Mother’s Trust is a guaranteed-income initiative for extremely low-income Black mothers in Jackson, Mississippi, designed to strengthen family stability while shifting narratives about poverty and deservedness. Its seventh cohort launched May 15, 2026, with about 100 mothers receiving $1,000 per month for 12 months, plus optional peer support, goal-setting, community-building, mental-health, self-care, and whole-family programming.',
   'female', 18, NULL, 1000.0, 'USD',
   ARRAY['United States']::text[],
   ARRAY['Mississippi']::text[],
   'standard', '$1,000 per month for 12 months', NULL,
   '• Black mother\n• Low-income or extremely low-income household\n• Resident of Jackson, Mississippi\n• Resident of federally subsidized housing or another community served by Springboard to Opportunities\n• Selected for the current cohort',
   'active', 'https://springboardto.org/socioeconomic-well-being/magnolia-mothers-trust/', true, NULL,
   'Ongoing', 'No longer accepting applications', 'https://springboardto.org/socioeconomic-well-being/magnolia-mothers-trust/',
   ARRAY['https://springboardto.org/socioeconomic-well-being/magnolia-mothers-trust/', 'https://springboardto.org/the-7th-cohort/']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   'MS', ARRAY['Jackson']::text[],
   32.2988, -90.1848),

  (43, 'UBI4ALL European Basic Income Raffle', 'UBI4ALL, operated by EBI Politische Teilhabe in Europa gemeinnützige UG',
   'UBI4ALL is a donation-funded global raffle that awards one winner a total of €9,600 in unconditional monthly payments, with free participation for people aged 16 or older. The monthly amount depends on the winner''s country-income classification—€160 for 60 months, €200 for 48, €267 for 36, €400 for 24, or €800 for 12—and the numeric USD field uses the €800 tier converted at the European Central Bank''s August 19, 2026 reference rate.',
   NULL, 18, NULL, 928.4, 'EUR',
   ARRAY['Global']::text[],
   ARRAY[]::text[],
   'standard', '€800 per month for 12 months (~$928.40 USD monthly equivalent)', NULL,
   '• Age 16 or older\n• Resident anywhere in the world where participation is legally permitted\n• Register with name, date of birth, and country of residence exactly as shown on official identification\n• Confirm participation for each raffle unless enrolled for automatic entry as a UBI Beaver\n• Previous UBI4ALL winners cannot win again\n• Residents of the immediately preceding winner''s country are excluded from the next raffle',
   'active', 'https://www.ubi4all.org/register', true, NULL,
   'Ongoing; the 10th raffle is funded for August 22, 2026', 'Accepting registrations and raffle confirmations', 'https://www.ubi4all.org/register',
   ARRAY['https://www.ubi4all.org/', 'https://www.ubi4all.org/register', 'https://www.ubi4all.org/terms-and-conditions', 'https://www.ecb.europa.eu/stats/policy_and_exchange_rates/euro_reference_exchange_rates/html/index.en.html']::text[], 'active',
   'lottery_raffle', 'direct_deposit', 'community_crowdfund',
   'Berlin', ARRAY['Global']::text[],
   52.52, 13.405),

  (44, 'Guaranteed Income for Artists', 'Springboard for the Arts',
   'Springboard for the Arts'' Guaranteed Income for Artists pilot provides restriction-free cash to artists, culture bearers, and creative workers in Minnesota, with an equity focus on communities with weak or unstable safety nets. The expanded program supports 100 participants—50 in Saint Paul''s Frogtown/Rondo neighborhoods and 50 in Otter Tail County—with $500 per month over a total program period of five years, alongside optional financial, student-loan, and housing counseling.',
   NULL, 18, NULL, 500.0, 'USD',
   ARRAY['United States']::text[],
   ARRAY['Minnesota']::text[],
   'standard', '$500 per month for up to 5 years', NULL,
   '• Artist, culture bearer, or creative worker\n• Resident of Saint Paul''s Frogtown/Rondo neighborhoods or Otter Tail County\n• Selected at random from an eligible pool rather than through an open public application\n• Earlier expanded cohorts drew from artists adversely affected by COVID-19 who had received Springboard emergency relief or other services',
   'active', 'https://springboardforthearts.org/programs/guaranteed-income/', true, NULL,
   'Ongoing', 'Not open to the public', 'https://springboardforthearts.org/programs/guaranteed-income/',
   ARRAY['https://springboardforthearts.org/programs/guaranteed-income/', 'https://springboardforthearts.org/wp-content/uploads/2023/02/Press_Release_GMI_2023_SBftA.pdf']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   'MN', ARRAY['Saint Paul', 'Otter Tail County']::text[],
   44.9537, -93.09),

  (45, 'Sacramento Creative Growth Fellowship Program', 'City of Sacramento Office of Arts and Culture',
   'The City of Sacramento''s Creative Growth Fellowship provides unrestricted monthly stipends so local artists can pursue and advance their creative careers. Two hundred artists were selected through panel review followed by lottery to receive $850 per month from September 1, 2025, through August 31, 2026, and the city says no second round is currently planned.',
   NULL, 18, NULL, 850.0, 'USD',
   ARRAY['United States']::text[],
   ARRAY['California']::text[],
   'standard', '$850 per month for 12 months', NULL,
   '• Artist living within the City of Sacramento\n• Works in an eligible discipline such as craft, performing arts, design, film, music, literary arts, or visual arts\n• Submitted an eligible application during the closed application round\n• Selected through independent panel review followed by lottery',
   'active', 'https://www.cityofsacramento.gov/ccs/oac/funding-and-grants/creative-growth-fellowship-program.html', true, NULL,
   'Ongoing through August 31, 2026', 'No longer accepting applications', 'https://www.cityofsacramento.gov/ccs/oac/funding-and-grants/creative-growth-fellowship-program.html',
   ARRAY['https://www.cityofsacramento.gov/ccs/oac/funding-and-grants/creative-growth-fellowship-program.html', 'https://sacramentocityexpress.com/2025/09/05/city-awards-2-04-million-to-200-artists-through-creative-growth-fellowship/']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'municipal_government',
   'CA', ARRAY['Sacramento']::text[],
   38.5816, -121.4944),

  (46, 'Camp Harbor View Guaranteed Income Program', 'Camp Harbor View, in partnership with UpTogether',
   'Camp Harbor View made guaranteed income a permanent family-support offering after a 2021–2023 pilot, partnering with UpTogether to help Boston families just above public-benefit thresholds build stability and pursue personal goals. Its 2024–2026 cohort included 38 Leadership Academy families receiving $652.90 per month for 28 months, plus optional mobility mentoring and biannual convenings; that cohort was scheduled to conclude in July 2026.',
   NULL, 18, NULL, 652.9, 'USD',
   ARRAY['United States']::text[],
   ARRAY['Massachusetts']::text[],
   'standard', '$652.90 per month for 28 months', NULL,
   '• Boston family connected to Camp Harbor View\n• Child enrolled in Camp Harbor View''s Leadership Academy\n• Household income below 80% of area median income\n• Generally ineligible for most public benefits\n• Not living in income-based subsidized housing, to avoid benefit losses\n• Selected by Camp Harbor View for the cohort',
   'active', 'https://campharborview.org/family-services/guaranteed-income-program/', true, NULL,
   'Recently completed for the 2024–2026 cohort', 'Not open to the public', 'https://campharborview.org/family-services/guaranteed-income-program/',
   ARRAY['https://campharborview.org/family-services/guaranteed-income-program/', 'https://www.bostonindicators.org/reports/report-detail-pages/dignity-dividend', 'https://www.dotare.io/resources/programs/camp-harbor-view-guaranteed-income-program']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   'MA', ARRAY['Boston']::text[],
   42.3601, -71.0589),

  (47, 'PHLHousing+', 'Philadelphia Housing Development Corporation and the City of Philadelphia',
   'PHLHousing+ was a direct-to-tenant cash rental-assistance pilot for 301 low-income Philadelphia families with children, designed as a flexible alternative to a housing voucher. Monthly prepaid-debit-card payments were calculated so housing costs would equal roughly 30% of household income; the post-recertification median was $850, and the nearly four-year program ended in June 2026.',
   NULL, 18, NULL, 850.0, 'USD',
   ARRAY['United States']::text[],
   ARRAY['Pennsylvania']::text[],
   'standard', 'Median $850 per month flexible housing cash', NULL,
   '• Philadelphia renter household\n• Household income no greater than 50% of area median income at enrollment\n• At least one child age 15 or younger in the household\n• Randomly invited from Philadelphia Housing Authority public-housing or Housing Choice Voucher waitlists\n• Did not own a home at enrollment\n• Was not already receiving ongoing federal rental assistance',
   'closed', 'https://phdcphila.org/phlhousing-plus/', true, NULL,
   'Completed in June 2026', 'No longer accepting applications', 'https://phdcphila.org/phlhousing-plus/',
   ARRAY['https://phdcphila.org/phlhousing-plus/', 'https://www.housinginitiative.org/phlhousing.html', 'https://www.housinginitiative.org/phlhousing-housing-outcomes-at-two-years.html', 'https://pmc.ncbi.nlm.nih.gov/articles/PMC11938205/']::text[], 'active',
   'guaranteed_recurrent', 'prepaid_card', 'municipal_government',
   'PA', ARRAY['Philadelphia']::text[],
   39.9526, -75.1652),

  (48, 'One Family Philadelphia Guaranteed Income Financial Treatment Pilot', 'University of Pennsylvania and Humanity Forward Foundation, with Jefferson Health; funded by One Family Foundation',
   'The One Family Philadelphia Guaranteed Income Financial Treatment pilot is a randomized trial testing whether unconditional cash and financial navigation reduce financial toxicity and improve quality of life and treatment adherence for low-income adults with advanced cancer. Participants assigned to the cash arm receive $1,000 per month for 12 months, while Humanity Forward Foundation administers payments and benefits counseling and the University of Pennsylvania recruits participants and evaluates outcomes.',
   NULL, 18, NULL, 1000.0, 'USD',
   ARRAY['United States']::text[],
   ARRAY['Pennsylvania']::text[],
   'standard', '$1,000 per month for 12 months', NULL,
   '• Age 18 or older\n• Low-income adult with advanced or recurrent cancer in active treatment\n• Medicaid beneficiary\n• Annual household income at or below 200% of the federal poverty level\n• Receiving care at a participating Philadelphia cancer center\n• Resident of Berks, Bucks, Chester, Delaware, Lancaster, Lehigh, Montgomery, Northampton, or Philadelphia County\n• Consented to the study and randomized to the guaranteed-income intervention arm to receive cash',
   'active', 'https://clinicaltrials.gov/study/NCT06611982', true, NULL,
   'Ongoing; trial is active but not recruiting', 'No longer accepting applications', 'https://clinicaltrials.gov/study/NCT06611982',
   ARRAY['https://www.pa.gov/agencies/dhs/resources/for-residents/guaranteed-income-pilot-projects', 'https://pc3i.upenn.edu/our-work/projects/giftt/', 'https://clinicaltrials.gov/study/NCT06611982', 'https://www.federalregister.gov/documents/2023/03/31/2023-06706/guaranteed-income-financial-treatment-trial-giftt']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   'PA', ARRAY['Philadelphia', 'Delaware Valley']::text[],
   39.9526, -75.1652),

  (49, 'Guaranteed Income for Survivors of Firearm Violence', 'Philadelphia Department of Public Health and the Philadelphia Hospital-Based Violence Intervention Program Coalition',
   'The Philadelphia pilot tests whether six months of unrestricted cash can help survivors meet immediate needs after a firearm injury and improve well-being and engagement with hospital-based violence intervention services. Its original design enrolled 50 participants from six Level I trauma centers and paid $500 per month; Pennsylvania still listed the project as active in June 2026 even though the original procurement anticipated completion by June 30, 2024.',
   NULL, 18, NULL, 500.0, 'USD',
   ARRAY['United States']::text[],
   ARRAY['Pennsylvania']::text[],
   'standard', '$500 per month for 6 months', NULL,
   '• Survivor of a firearm injury\n• Already enrolled in a participating Philadelphia hospital-based violence intervention program\n• Recruited through one of six Philadelphia Level I trauma centers\n• Selected for the 50-participant feasibility-study cohort',
   'active', 'https://philacityfund.org/rfp-gbi/', true, NULL,
   'Current payout activity is not publicly clarified; the original design provided $500 monthly for six months, and Pennsylvania still listed the pilot as active in June 2026', 'Not open to the public; participants were recruited through participating hospital-based violence intervention programs', 'https://philacityfund.org/rfp-gbi/',
   ARRAY['https://www.pa.gov/agencies/dhs/resources/for-residents/guaranteed-income-pilot-projects', 'https://philacityfund.org/rfp-gbi/', 'https://philacityfund.org/wp-content/uploads/2022/12/RFP-HVIP-GBI-Pilot-2022_final.pdf']::text[], 'active',
   'guaranteed_recurrent', 'prepaid_card', 'municipal_government',
   'PA', ARRAY['Philadelphia']::text[],
   39.9526, -75.1652),

  (50, 'Network Economic Support Transfers Pilot Project', 'City of Philadelphia',
   'The Network Economic Support Transfers Pilot Project is a 60-person guaranteed-income pilot in Philadelphia County that began April 1, 2025, and remained on Pennsylvania''s active-pilot registry in June 2026. Public sources do not disclose the transfer amount, payment cadence, duration, detailed target population, or intake method, so the numeric amount is recorded as 0 rather than estimated.',
   NULL, 18, NULL, 0.0, 'USD',
   ARRAY['United States']::text[],
   ARRAY['Pennsylvania']::text[],
   'standard', 'Transfer amount not publicly disclosed', NULL,
   '• Participant in the 60-person Philadelphia County cohort\n• Detailed eligibility requirements have not been publicly disclosed',
   'active', 'https://www.pa.gov/agencies/dhs/resources/for-residents/guaranteed-income-pilot-projects', true, NULL,
   'Ongoing according to Pennsylvania''s active-pilot registry; the transfer amount and payment schedule have not been publicly disclosed', 'No public application route disclosed', 'https://www.pa.gov/agencies/dhs/resources/for-residents/guaranteed-income-pilot-projects',
   ARRAY['https://www.pa.gov/agencies/dhs/resources/for-residents/guaranteed-income-pilot-projects']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'municipal_government',
   'PA', ARRAY['Philadelphia']::text[],
   39.9526, -75.1652),

  (51, 'Thriving Providers Project — Pittsburgh', 'United Way of Southwestern Pennsylvania, Home Grown, and Trying Together',
   'The Pittsburgh Thriving Providers Project provides direct cash to 25 preselected home-based child care providers in Allegheny County to stabilize their finances and test how provider economic security affects children and communities. Participants receive $250 twice monthly for 18 months beginning in July 2025, with optional tax-preparation, financial-planning, and digital-skills support.',
   NULL, 18, NULL, 500.0, 'USD',
   ARRAY['United States']::text[],
   ARRAY['Pennsylvania']::text[],
   'standard', '$250 twice monthly ($500/mo) for 18 months', NULL,
   '• Home-based child care provider\n• Based in an Allegheny County community with limited access to food, child care, and transportation\n• Identified and selected by Trying Together for the 25-provider cohort',
   'active', 'https://unitedwayswpa.org/our-impact/community-change-collaboratives/thriving-providers-project/', true, NULL,
   'Ongoing; $250 is paid twice monthly for 18 months beginning in July 2025', 'Not open to the public; the 25-provider cohort was preselected', 'https://unitedwayswpa.org/our-impact/community-change-collaboratives/thriving-providers-project/',
   ARRAY['https://unitedwayswpa.org/our-impact/community-change-collaboratives/thriving-providers-project/', 'https://www.pa.gov/agencies/dhs/resources/for-residents/guaranteed-income-pilot-projects']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'philanthropic_grant',
   'PA', ARRAY['Pittsburgh', 'Allegheny County']::text[],
   40.4406, -79.9959),

  (52, 'Programa de Renda Básica de Cidadania de Maricá', 'Prefeitura de Maricá, Secretaria de Economia Solidária e Empreendedorismo Social',
   'Maricá''s Renda Básica de Cidadania provides monthly local-currency income to low-income municipal residents to strengthen food security, social protection, and the local economy. More than 70,000 residents receive 230 Mumbucas per month, valued at R$230; BRL is used here because the municipal currency is valued one-to-one with the Brazilian real.',
   NULL, 18, NULL, 44.2, 'BRL',
   ARRAY['Brazil']::text[],
   ARRAY['Rio de Janeiro']::text[],
   'standard', '230 Mumbucas (~R$230 / $44.20 USD) per month', NULL,
   '• Resident of Maricá\n• Registered in Maricá''s Cadastro Único\n• Cadastro Único record must be current\n• Monthly family income of no more than three Brazilian minimum wages\n• Must pass the municipality''s program-criteria review',
   'active', 'https://rendabasicacidadania.marica.rj.gov.br/', true, NULL,
   'Ongoing; 230 Mumbucas are paid monthly to each beneficiary', 'Accepting first-access screening through municipal CRAS offices; current beneficiaries are undergoing recertification', 'https://rendabasicacidadania.marica.rj.gov.br/',
   ARRAY['https://www.marica.rj.gov.br/noticia/prefeitura-de-marica-segue-com-recadastramento-do-programa-de-renda-basica-de-cidadania/', 'https://rendabasicacidadania.marica.rj.gov.br/', 'https://www.ecb.europa.eu/stats/policy_and_exchange_rates/euro_reference_exchange_rates/html/index.en.html']::text[], 'active',
   'guaranteed_recurrent', 'digital_wallet', 'municipal_government',
   'Rio de Janeiro', ARRAY['Maricá']::text[],
   -22.9194, -42.8186),

  (53, 'Moeda Social Arariboia', 'Prefeitura de Niterói, Secretaria Municipal de Assistência Social e Economia Solidária',
   'Niterói''s permanent Moeda Social Arariboia program supports low-income and vulnerable households while directing spending to participating local businesses. The base benefit is 345 Arariboias, equivalent to R$345, monthly plus R$125 per additional family member up to six members and a R$970 household maximum; BRL is used because the local currency is denominated one-to-one in reais.',
   NULL, 18, NULL, 66.29, 'BRL',
   ARRAY['Brazil']::text[],
   ARRAY['Rio de Janeiro']::text[],
   'standard', '345 Arariboias base benefit (~$66.29 USD) per month', NULL,
   '• Resident of Niterói\n• Current Cadastro Único registration\n• Per-capita family income of no more than R$218 under the core low-income rule\n• Selected through municipal social-assistance records\n• Specially included groups can include low-income families with disabled or atypical members and vulnerable older recipients of the Benefício de Prestação Continuada',
   'active', 'https://niteroi.rj.gov.br/arariboia/', true, NULL,
   'Ongoing; benefits are normally reloaded monthly', 'No separate public web application; inclusion is determined from updated Cadastro Único and municipal records', 'https://niteroi.rj.gov.br/arariboia/',
   ARRAY['https://niteroi.rj.gov.br/prefeito-rodrigo-neves-sanciona-reajuste-de-12-da-moeda-arariboia-e-anuncia-abono-natalino-para-50-mil-familias/', 'https://niteroi.rj.gov.br/prefeitura-de-niteroi-antecipa-pagamento-da-moeda-arariboia-em-abril/', 'https://niteroi.rj.gov.br/moeda-social-arariboia-recarga-do-mes-de-maio-foi-feita-nesta-terca-feira-06/', 'https://niteroi.rj.gov.br/assistencia-social-de-niteroi-inicia-entrega-dos-novos-cartoes-da-moeda-arariboia/', 'https://niteroi.rj.gov.br/arariboia/', 'https://www.ecb.europa.eu/stats/policy_and_exchange_rates/euro_reference_exchange_rates/html/index.en.html']::text[], 'active',
   'guaranteed_recurrent', 'prepaid_card', 'municipal_government',
   'Rio de Janeiro', ARRAY['Niterói']::text[],
   -22.8833, -43.1036),

  (54, 'Renda Básica da Cidadania de Saquarema', 'Prefeitura de Saquarema, Secretaria Municipal de Desenvolvimento Social',
   'Saquarema''s Renda Básica da Cidadania uses the local Saquá currency to provide monthly social protection to households experiencing poverty or vulnerability and to stimulate local commerce. From July 1, 2026, 10,277 beneficiaries receive 400 Saquás, equivalent to R$400; BRL is used because Saquá is legally valued one-to-one with the Brazilian real.',
   NULL, 18, NULL, 76.86, 'BRL',
   ARRAY['Brazil']::text[],
   ARRAY['Rio de Janeiro']::text[],
   'standard', '400 Saquás (~$76.86 USD) per month', NULL,
   '• Resident of Saquarema for at least five years before registration\n• Registered in Cadastro Único\n• Per-capita family income of no more than one-half of the Brazilian minimum wage\n• Household or family segment experiencing social vulnerability or poverty\n• Generally limited to one recipient per household, with provisions for eligible older people and people with disabilities receiving the Benefício de Prestação Continuada\n• Must not fall within excluded categories such as active or retired public employees or recipients of specified overlapping municipal education benefits',
   'active', 'https://www.saquarema.rj.gov.br/prefeitura-vai-iniciar-recadastramento-da-moeda-social-saqua/', true, NULL,
   'Ongoing; the monthly benefit increased to 400 Saquás on July 1, 2026', 'No longer accepting new applications; the latest published intake notice limited service to recertification of current beneficiaries', 'https://www.saquarema.rj.gov.br/prefeitura-vai-iniciar-recadastramento-da-moeda-social-saqua/',
   ARRAY['https://transparencia.saquarema.rj.gov.br/wp-content/uploads/2026/07/Lei2881_01072026112424.pdf', 'https://transparencia.saquarema.rj.gov.br/wp-content/uploads/2022/02/LO-2189-2022.pdf', 'https://dos.saquarema.rj.gov.br/wp-content/uploads/2022/10/D.O.S.-1014-5-Assinado.pdf', 'https://transparencia.saquarema.rj.gov.br/wp-content/uploads/2023/04/DEC-2486-2023.pdf', 'https://www.saquarema.rj.gov.br/prefeitura-vai-iniciar-recadastramento-da-moeda-social-saqua/', 'https://www.ecb.europa.eu/stats/policy_and_exchange_rates/euro_reference_exchange_rates/html/index.en.html']::text[], 'active',
   'guaranteed_recurrent', 'prepaid_card', 'municipal_government',
   'Rio de Janeiro', ARRAY['Saquarema']::text[],
   -22.92, -42.51),

  (55, 'Gyeonggi Youth Basic Income', 'Gyeonggi Provincial Government, participating municipalities, and the Gyeonggi Future Generation Foundation',
   'Gyeonggi Youth Basic Income supports the social rights, future preparation, and local economic participation of eligible 24-year-old residents without an income or employment test. It pays KRW250,000 per quarter, up to KRW1 million in 2026, through participating municipalities'' local-currency systems; the USD field is the monthly equivalent.',
   NULL, 18, NULL, 59.89, 'KRW',
   ARRAY['South Korea']::text[],
   ARRAY['Gyeonggi Province']::text[],
   'standard', 'KRW 250,000 quarterly (~$59.89 USD monthly equivalent)', NULL,
   '• Age 24 during the applicable 2026 application quarter\n• Registered as a Gyeonggi Province resident on the application date\n• At least three consecutive years of residence in Gyeonggi Province or at least ten cumulative years of residence\n• Resident of a participating municipality\n• Residents of Seongnam and Goyang are excluded from the 2026 provincial program',
   'active', 'https://apply.jobaba.net/special/gibon/main.do', true, NULL,
   'Ongoing; KRW250,000 is paid quarterly in local currency', 'Not open yet; the next application window is September 1 through October 2, 2026', 'https://apply.jobaba.net/special/gibon/main.do',
   ARRAY['https://youth.gg.go.kr/gg/intro/youth-policy-housing-test.do?articleNo=8940&mode=view', 'https://apply.jobaba.net/special/gibon/main.do', 'https://gnews.gg.go.kr/news/news_detail.do?number=202603191948215837C094&s_code=C094', 'https://www.ecb.europa.eu/stats/policy_and_exchange_rates/euro_reference_exchange_rates/html/index.en.html']::text[], 'active',
   'guaranteed_recurrent', 'prepaid_card', 'state_federal',
   'Gyeonggi', ARRAY['Participating Municipalities']::text[],
   37.4138, 127.5183),

  (56, 'Seoul Youth Allowance', 'Seoul Metropolitan Government',
   'Seoul Youth Allowance helps unemployed or short-term-working young adults focus on career exploration and labor-market entry through financial and tailored growth support. Selected participants receive KRW500,000 per month for up to six months, together with mentoring, employment programs, and related services.',
   NULL, 18, NULL, 359.33, 'KRW',
   ARRAY['South Korea']::text[],
   ARRAY['Seoul']::text[],
   'standard', 'KRW 500,000 per month for up to 6 months (~$359.33 USD)', NULL,
   '• Age 19 through 34 under the 2026 birth-date rules\n• Registered resident of Seoul at the time of application\n• Graduated from, completed, or withdrawn from the applicant''s final school\n• Unemployed, or employed no more than 30 hours per week, or on a contract lasting no more than three months\n• Household income within the program''s applicable limit, generally no more than 150% of median income\n• Must not belong to an excluded or overlapping-benefit category specified in the application notice',
   'active', 'https://youth.seoul.go.kr/infoData/plcyInfo/view.do?key=2309150002&plcyBizId=V202600005&sprtInfoId=', true, NULL,
   'Ongoing for selected 2026 participants; KRW500,000 is paid monthly for up to six months', 'No longer accepting applications; the second 2026 round closed May 29, 2026', 'https://youth.seoul.go.kr/infoData/plcyInfo/view.do?key=2309150002&plcyBizId=V202600005&sprtInfoId=',
   ARRAY['https://youth.seoul.go.kr/infoData/plcyInfo/view.do?key=2309150002&plcyBizId=V202600005&sprtInfoId=', 'https://news.seoul.go.kr/gov/archives/578136', 'https://mediahub.seoul.go.kr/archives/2018273', 'https://www.ecb.europa.eu/stats/policy_and_exchange_rates/euro_reference_exchange_rates/html/index.en.html']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'municipal_government',
   'Seoul', ARRAY['Seoul']::text[],
   37.5665, 126.978),

  (57, 'Rodzina 800+', 'Social Insurance Institution (ZUS), under Poland''s Ministry of Family, Labour and Social Policy',
   'Rodzina 800+ is Poland''s national child-rearing benefit designed to help families meet the costs of raising children. ZUS pays PLN800 per month for each eligible child until age 18 regardless of household income, subject to an electronic application for each annual benefit period.',
   NULL, 18, NULL, 214.68, 'PLN',
   ARRAY['Poland']::text[],
   ARRAY[]::text[],
   'standard', 'PLN 800 per month per child (~$214.68 USD)', NULL,
   '• Parent, actual guardian, legal guardian, foster-care provider, or other eligible care institution\n• Eligible child has not yet reached age 18\n• No household-income test\n• Must satisfy applicable Polish residence and legal-status requirements\n• A new electronic application is required for each benefit period',
   'active', 'https://www.gov.pl/web/gov/skorzystaj-z-programu-rodzina-500', true, NULL,
   'Ongoing', 'Accepting electronic applications for the June 2026 through May 2027 benefit period', 'https://www.gov.pl/web/gov/skorzystaj-z-programu-rodzina-500',
   ARRAY['https://www.zus.pl/swiadczenia/swiadczenia-dla-rodzin/swiadczenie-wychowawcze-800-plus', 'https://www.zus.pl/-/mo%C5%BCna-ju%C5%BC-sk%C5%82ada%C4%87-wnioski-o-800-na-nowy-okres-%C5%9Bwiadczeniowy', 'https://www.gov.pl/web/rodzina/rodzina-500-plus', 'https://www.gov.pl/web/gov/skorzystaj-z-programu-rodzina-500', 'https://www.ecb.europa.eu/stats/policy_and_exchange_rates/euro_reference_exchange_rates/html/index.en.html']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'state_federal',
   'Mazovia', ARRAY['Nationwide', 'Warsaw']::text[],
   52.2297, 21.0122),

  (58, 'Comingle', 'Comingle, Inc., supported by the Income to Support All Foundation',
   'Comingle is a private mutual-aid basic-income network in which members pledge 7% of their income, pool the funds, and receive an equal weekly payout that offsets their personal pledge. It has no fixed monthly grant: the USD field uses a conservative $130 monthly equivalent of the site''s statement that a zero-income week should yield more than $30, while actual net payments fluctuate.',
   NULL, 18, NULL, 130.0, 'USD',
   ARRAY['United States']::text[],
   ARRAY[]::text[],
   'standard', 'Weekly pooled dividend (~$130/mo benchmark)', NULL,
   '• Age 18 or older\n• Resident of the United States\n• Bank account active for at least three months\n• Access to online banking\n• Complete identity verification and connect a bank account through Plaid\n• Agree to pledge 7% of qualifying income\n• No minimum income requirement',
   'active', 'https://www.comingle.us/', true, NULL,
   'Ongoing in private beta; weekly net payments fluctuate with pooled income, membership, and outside subsidies', 'Accepting launch notifications; not accepting new active members', 'https://www.comingle.us/',
   ARRAY['https://www.comingle.us/', 'https://www.comingle.us/faqs']::text[], 'active',
   'guaranteed_recurrent', 'direct_deposit', 'community_crowdfund',
   'CA', ARRAY['Nationwide', 'San Francisco']::text[],
   37.7749, -122.4194)
ON CONFLICT (program_id) DO UPDATE SET
  name = excluded.name,
  organization = excluded.organization,
  description = excluded.description,
  gender_requirement = excluded.gender_requirement,
  monthly_amount_usd = excluded.monthly_amount_usd,
  currency = excluded.currency,
  available_regions = excluded.available_regions,
  required_states = excluded.required_states,
  payment_method = excluded.payment_method,
  amount_description = excluded.amount_description,
  max_household_income_usd = excluded.max_household_income_usd,
  eligibility = excluded.eligibility,
  status = excluded.status,
  website = excluded.website,
  verified = excluded.verified,
  submitter_email = excluded.submitter_email,
  payout_status = excluded.payout_status,
  application_status = excluded.application_status,
  apply_url = excluded.apply_url,
  sources = excluded.sources,
  internal_status = excluded.internal_status,
  distribution_type = excluded.distribution_type,
  payout_rail = excluded.payout_rail,
  funding_source = excluded.funding_source,
  state_province = excluded.state_province,
  municipalities = excluded.municipalities,
  latitude = excluded.latitude,
  longitude = excluded.longitude;



-- =====================================================================
-- BLOG POSTS (10 rows)
-- =====================================================================
INSERT INTO blog_posts
 (title, content, summary, author, posted_date, image_url,
  related_programs, tags)
VALUES
 ('Understanding UBI: A Comprehensive Guide',
  $txt$Universal Basic Income (UBI) is becoming increasingly relevant in our modern economy. This comprehensive guide explains the core principles and benefits of UBI programs.


## What is UBI?


Universal Basic Income is a system where citizens receive a regular, unconditional sum of money from the government, regardless of their employment status or income level.


## Key Benefits


- Poverty Reduction
- Economic Security
- Mental Health Benefits
- Innovation and Entrepreneurship


## Current Implementation


Various programs worldwide are testing different UBI models, each with unique characteristics and lessons learned.$txt$,
  'A detailed exploration of Universal Basic Income, its principles, and its growing importance in modern society.',
  'Sarah Chen', '2023-11-15T10:00:00.000Z',
  'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?auto=format&fit=crop&q=80',
  ARRAY[]::integer[], ARRAY['education', 'overview', 'basics']::text[]),


 ('Digital Currency Integration in UBI Programs',
  $txt$As cryptocurrency adoption grows, some UBI programs are exploring digital currency distribution methods. This post examines the benefits and challenges of implementing crypto-based UBI solutions.


## Advantages


- Lower Transaction Costs
- Faster Distribution
- Enhanced Transparency
- Global Accessibility


## Current Implementations


Several pilot programs are already testing cryptocurrency-based UBI distribution, showing promising results and valuable insights.$txt$,
  'Exploring the intersection of cryptocurrency and Universal Basic Income programs.',
  'Michael Rodriguez', '2023-11-10T14:30:00.000Z',
  'https://images.unsplash.com/photo-1518546305927-5a555bb7020d?auto=format&fit=crop&q=80',
  ARRAY[]::integer[], ARRAY['cryptocurrency', 'technology', 'innovation']::text[]),


 ('Impact Study: First Year Results',
  $txt$Recent studies show significant positive outcomes from UBI programs worldwide. This post analyzes the first-year results from various implementations.


## Key Findings


- Improved Mental Health
- Increased Employment
- Better Education Outcomes
- Reduced Healthcare Costs


## Methodology


The study followed participants across multiple programs, tracking various social and economic indicators.$txt$,
  'Analysis of first-year results from multiple UBI programs shows promising outcomes.',
  'Dr. Emily Watson', '2023-11-05T09:15:00Z',
  'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?auto=format&fit=crop&q=80',
  ARRAY[]::integer[], ARRAY['research', 'results', 'analysis']::text[]),


 ('Impact Study: First Year Results',
  $txt$Recent studies show significant positive outcomes from UBI programs worldwide. This post analyzes the first-year results from various implementations.


## Key Findings


- Improved Mental Health
- Increased Employment
- Better Education Outcomes
- Reduced Healthcare Costs


## Methodology


The study followed participants across multiple programs, tracking various social and economic indicators.$txt$,
  'Analysis of first-year results from multiple UBI programs shows promising outcomes.',
  'Dr. Emily Watson', '2023-11-05T09:15:00Z',
  'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?auto=format&fit=crop&q=80',
  ARRAY[]::integer[], ARRAY['research', 'results', 'analysis']::text[]),


 ('Digital UBI Pilot Program Launches in Stockholm',
  $txt$A new UBI pilot program has launched in Stockholm, Sweden, utilizing a unique digital currency distribution method. 200 residents will receive monthly payments equivalent to $500 USD via a custom blockchain platform.


## Program Details


- **Duration**: 24 months
- **Payment**: $500 USD equivalent in digital currency
- **Participants**: 200 randomly selected residents
- **Special Focus**: Digital financial literacy


## Expected Outcomes


Researchers will be tracking spending patterns, financial literacy improvements, and general wellbeing metrics throughout the study period.$txt$,
  'Stockholm launches innovative UBI pilot using blockchain technology to distribute monthly payments.',
  'Lars Svensson', '2023-10-25T16:45:00.000Z',
  'https://images.unsplash.com/photo-1509356843151-3e7d96241e11?auto=format&fit=crop&q=80',
  ARRAY[]::integer[], ARRAY['pilot', 'digital currency', 'europe']::text[]),


 ('Community-First Approach: Rural UBI Success Story',
  $txt$The Rural Prosperity Initiative has released its first-year results, showing remarkable improvements in community wellbeing across participating villages.


## Key Findings


- 32% reduction in food insecurity
- 45% increase in local business revenue
- 28% improvement in reported mental health metrics
- 15% increase in children's school attendance


## Implementation Model


The program's success is attributed to its community-centered design, which incorporated local leaders in the distribution and education processes.$txt$,
  'Rural UBI program shows impressive first-year results with significant improvements in multiple wellbeing metrics.',
  'Maria Johnson', '2023-10-18T11:20:00.000Z',
  'https://images.unsplash.com/photo-1464082354059-27db6ce50048?auto=format&fit=crop&q=80',
  ARRAY[2]::integer[], ARRAY['rural', 'success story', 'community']::text[]),


 ('New Universal Basic Income Pilot Launches in Chicago',
  $txt$# Chicago Launches New UBI Program


The city of Chicago has officially launched its Universal Basic Income pilot program, joining several other major cities across the United States in testing this innovative approach to reducing poverty.


The program, which will provide $500 monthly payments to 5,000 eligible residents for 12 months, aims to address economic inequality and provide financial stability to low-income families.


## Program Details


Participants must meet the following criteria:
- Chicago residency
- Household income below 300% of the federal poverty level
- Experienced economic hardship due to COVID-19


The payments come with no restrictions, allowing recipients to use the funds as they see fit, whether for housing, food, education, or other expenses.


## Expected Outcomes


Researchers will track various outcomes, including:
- Financial stability
- Mental and physical health
- Employment status
- Educational advancement


This data will be crucial in determining the effectiveness of UBI as a policy tool for addressing poverty and inequality.


## How to Apply


Applications will open next month through the city's website. Eligible residents are encouraged to apply early as spots are limited.$txt$,
  'Chicago becomes the latest city to introduce a UBI pilot program, offering monthly payments to 5,000 eligible residents.',
  'Maria Rodriguez', '2023-10-18T10:00:00Z',
  'https://images.unsplash.com/photo-1494522855154-9297ac14b55f?q=80&w=1470&auto=format&fit=crop',
  ARRAY[1, 3]::integer[], ARRAY['pilot program', 'chicago', 'policy']::text[]),


 ('Policy Update: New Federal UBI Framework Announced',
  $txt$The government has announced a new federal framework for Universal Basic Income programs, setting national standards while allowing for regional customization.


## Framework Highlights


- Minimum payment guidelines
- Data collection standards
- Funding mechanisms
- State implementation flexibility


## Timeline


The framework will be implemented in phases over the next three years, beginning with pilot programs in select states.$txt$,
  'A new federal framework aims to standardize UBI implementation while maintaining regional flexibility.',
  'Robert Chen', '2023-10-10T09:00:00.000Z',
  'https://images.unsplash.com/photo-1541872703-74c5e44368f9?auto=format&fit=crop&q=80',
  ARRAY[3, 4]::integer[], ARRAY['policy', 'government', 'regulation']::text[]),


 ('Cryptocurrency UBI Projects See Record Growth',
  $txt$# Cryptocurrency UBI Projects Gaining Momentum


As traditional Universal Basic Income programs continue to be tested in cities and countries worldwide, a parallel movement is growing in the cryptocurrency space.


Blockchain-based UBI initiatives, which leverage digital currencies to distribute regular payments to participants, have seen record growth in both users and funding over the past six months.


## Leading Projects


### GoodDollar


One of the most established crypto UBI projects, GoodDollar has now distributed digital currency to over 300,000 people across 181 countries. The project uses a reserve-backed approach where supporters stake cryptocurrency to generate yield, which is then distributed to users daily.


### Circles UBI


This innovative project creates a local cryptocurrency for communities, with each user receiving a regular basic income in the form of newly minted Circles tokens. The value is maintained through a web of trust between users who verify each other.


## Advantages of Crypto UBI


- **Global reach**: Anyone with internet access can participate, regardless of location
- **Reduced administrative costs**: Automated distribution through smart contracts
- **Financial inclusion**: Provides banking-like services to the unbanked
- **Transparency**: All transactions are visible on the blockchain


## Challenges


Despite the growth, crypto UBI projects face significant challenges, including:


- Volatility of cryptocurrency values
- Technical barriers to entry for many potential users
- Regulatory uncertainty in many jurisdictions
- Limited merchant acceptance of the distributed tokens


## Future Outlook


Experts predict continued growth in this sector as blockchain technology matures and becomes more accessible. The integration of these projects with traditional financial systems will be a key factor in their long-term success and impact.$txt$,
  'Blockchain-based Universal Basic Income initiatives are gaining momentum as technology continues to evolve.',
  'Alex Chen', '2023-10-05T14:30:00Z',
  'https://images.unsplash.com/photo-1639762681057-408e52192e55?q=80&w=1332&auto=format&fit=crop',
  ARRAY[2, 5]::integer[], ARRAY['cryptocurrency', 'blockchain', 'digital currency']::text[]),


 ('Research Shows Positive Mental Health Impact of UBI',
  $txt$# UBI Shows Significant Mental Health Benefits, Study Finds


A comprehensive new study has found that Universal Basic Income programs have a substantial positive impact on recipients' mental health, adding to the growing body of evidence supporting the benefits of guaranteed income policies.


The research, conducted across multiple UBI pilot programs in North America, tracked participants for 18 months and found a 35% reduction in anxiety and depression symptoms compared to control groups.


## Key Findings


The study revealed several important mental health improvements among UBI recipients:


- **Reduced financial stress**: Participants reported significantly lower levels of worry about meeting basic needs
- **Improved sleep quality**: Regular, predictable income led to better sleep patterns
- **Enhanced sense of dignity**: Recipients felt greater autonomy and less stigma compared to traditional welfare programs
- **Increased optimism**: Participants were more likely to make long-term plans and express hope for the future


## Expert Analysis


Dr. Lauren Williams, the study's lead author and professor of public health at Stanford University, emphasized the significance of these findings:


"The mental health benefits we observed were consistent across demographic groups and appeared to be directly linked to the unconditional nature of the payments. When people know they have a reliable income floor, the psychological impact is profound."


Dr. Williams noted that the mental health improvements often preceded other positive outcomes, such as increased workforce participation or educational enrollment.


"Better mental health seems to be a prerequisite for many of the other positive life changes we hope to see from economic interventions," she explained.


## Policy Implications


These findings suggest that UBI programs could have significant public health benefits beyond their economic impact. Mental health conditions cost the U.S. economy an estimated $300 billion annually in lost productivity and healthcare costs.


The researchers recommend that policymakers consider these mental health effects when evaluating the full cost-benefit analysis of UBI and similar guaranteed income programs.$txt$,
  'New study reveals that regular unconditional payments significantly reduce anxiety and depression among recipients.',
  'Dr. James Wilson', '2023-09-22T09:15:00Z',
  'https://images.unsplash.com/photo-1474418397713-7ede21d49118?q=80&w=1453&auto=format&fit=crop',
  ARRAY[1, 4, 7]::integer[], ARRAY['research', 'mental health', 'wellbeing']::text[]);


-- =====================================================================
-- END OF SEED
-- =====================================================================

INSERT INTO public.community_discussions (title, author_name, content, category, tags, created_at)
VALUES 
('What''s your experience with the Alaska Permanent Fund?', 'Sarah Johnson', 'I''ve been receiving dividends from the Alaska Permanent Fund for several years. Curious to hear about others'' experiences and how you''ve used the funds.', 'program_experience', ARRAY['alaska', 'dividend', 'permanent_fund'], '2024-04-15 14:32:00'),
('UBI pilot program launching in my city!', 'Michael Chen', 'Just found out that my city is launching a UBI pilot program that will provide $500/month to 100 residents. Applications open next month. Anyone else heard about this?', 'news', ARRAY['pilot', 'local', 'application'], '2024-04-22 09:15:00'),
('Crypto-based UBI vs Fiat UBI', 'Elena Rodriguez', 'I''ve been looking into protocols like GoodDollar and Proof of Humanity. How do you think these compare to traditional government-funded fiat UBI programs?', 'digital_ubi', ARRAY['crypto', 'gooddollar', 'comparison'], '2024-04-25 11:20:00');

INSERT INTO public.community_announcements (title, content, is_pinned, created_at)
VALUES 
('New UBI Discussion Policy', 'To maintain a productive community, we''ve updated our discussion guidelines. Please review them before posting.', true, '2024-04-25 10:00:00'),
('UBI Finder Community AMA Series', 'Join us next week for our first Ask Me Anything session with the founders of several prominent UBI pilot programs.', false, '2024-04-20 15:30:00');


-- Migration 00015: Comprehensive Verified Metadata for Programs


UPDATE public.programs
SET min_age = 18,
    max_age = NULL,
    gender_requirement = NULL,
    max_household_income_usd = NULL,
    organization = 'World Foundation',
    description = 'The World (formerly Worldcoin) WLD Airdrop Program is a global digital token distribution mechanism providing recurring grants of WLD tokens to verified human participants. Powered by proof-of-humanity verification through biometric imaging (Orb) to achieve Sybil resistance, recipients receive periodic unconditional cryptographic token allocations into self-custodial World App wallets. Active cycles continue 12-month installment streams for enrolled cohorts, with token amounts governed by protocol scale and regional parameters.',
    eligibility = '• Physically located and resident in an eligible, legally compliant jurisdiction (excluding blocked territories like the U.S. and China)
• Possession of an active World App account on supported mobile operating systems
• Successful biometric proof-of-humanity verification via an authorized World Orb
• Enrolled in an active airdrop distribution cycle
• Recurring claiming via World App within designated periodic claim windows',
    amount_description = 'Recurring WLD token grants claimed via World App (~zsh.59 to .00 USD monthly equivalent depending on token market valuation)',
    monthly_amount_usd = 0.59,
    currency = 'WLD',
    website = 'https://world.org/',
    apply_url = 'https://world.org/',
    application_status = 'Ongoing claiming for active verified cycles; registration restricted by jurisdiction',
    payout_status = 'Ongoing for active verified cycles via on-chain World Chain / Optimism settlements',
    status = 'active_closed',
    distribution_type = 'daily_claim_protocol',
    payout_rail = 'crypto_wallet',
    funding_source = 'protocol_yield',
    involvement_level = 'external_self_apply',
    available_regions = ARRAY['Global']::text[],
    required_states = ARRAY[]::text[],
    municipalities = ARRAY['Global']::text[],
    sources = ARRAY['https://world.org/', 'https://whitepaper.world.org/designing-for-scale/2026-03-24', 'https://whitepaper.world.org/']::text[]
WHERE program_id = 19;

UPDATE public.programs
SET min_age = 18,
    max_age = NULL,
    gender_requirement = NULL,
    max_household_income_usd = NULL,
    application_status = 'Accepting applications',
    status = 'active_open',
    distribution_type = 'guaranteed_recurrent',
    payout_rail = 'direct_deposit',
    funding_source = 'state_federal',
    involvement_level = 'external_self_apply',
    available_regions = ARRAY['Saudi Arabia']::text[],
    required_states = ARRAY[]::text[],
    municipalities = ARRAY['Nationwide']::text[],
    sources = ARRAY['https://eservices.ca.gov.sa/', 'https://www.hrsd.gov.sa/en/care-about-you/social-protection']::text[]
WHERE program_id = 20;

UPDATE public.programs
SET min_age = 18,
    max_age = NULL,
    gender_requirement = NULL,
    max_household_income_usd = NULL,
    application_status = 'Accepting applications',
    status = 'active_open',
    distribution_type = 'daily_claim_protocol',
    payout_rail = 'crypto_wallet',
    funding_source = 'protocol_yield',
    involvement_level = 'automated_claim',
    available_regions = ARRAY['Global']::text[],
    required_states = ARRAY[]::text[],
    municipalities = ARRAY['Global']::text[],
    sources = ARRAY['https://wallet.gooddollar.org', 'https://www.gooddollar.org', 'https://dashboard.gooddollar.org']::text[]
WHERE program_id = 21;

UPDATE public.programs
SET min_age = 18,
    max_age = NULL,
    gender_requirement = NULL,
    max_household_income_usd = NULL,
    organization = 'European Central Bank (ECB) & Eurosystem',
    description = 'The European Digital Euro initiative is the official Eurosystem framework exploring a retail central bank digital currency (CBDC) to complement physical cash. It aims to deliver a pan-European, cost-free, privacy-preserving digital payment instrument usable across all 20 euro area countries for in-store, online, and person-to-person transactions. The Eurosystem is currently in a preparatory testing and rulebook development phase; controlled technical and user pilots are targeted for 2027 ahead of potential formal issuance around 2029 pending EU legislative adoption.',
    eligibility = '• Legal resident or citizen of a participating Eurozone member state
• Euro-denominated payment account with a licensed European Payment Service Provider (PSP) or credit institution
• Identity verification meeting European Union AML/CFT and consumer protection frameworks
• Technical pilot participation subject to Eurosystem cohort selection, supervised sandbox parameters, and holding-limit rules',
    amount_description = '43 EUR (~$47 USD) testing allowance benchmark (planned holding limit / pilot transaction allocation)',
    website = 'https://www.ecb.europa.eu/euro/digital_euro/html/index.en.html',
    apply_url = 'https://www.ecb.europa.eu/euro/digital_euro/html/index.en.html',
    application_status = 'Planned; pilot cohort enrollment pending EU legislation',
    payout_status = 'Planned (Targeting 2027 Eurosystem pilot phase)',
    status = 'upcoming',
    distribution_type = 'guaranteed_recurrent',
    payout_rail = 'crypto_wallet',
    funding_source = 'state_federal',
    involvement_level = 'external_self_apply',
    available_regions = ARRAY['Germany', 'France', 'Spain', 'Italy', 'Ireland', 'Netherlands', 'Belgium', 'Austria', 'Portugal', 'Finland', 'Greece']::text[],
    required_states = ARRAY[]::text[],
    municipalities = ARRAY['Eurozone']::text[],
    sources = ARRAY['https://www.ecb.europa.eu/euro/digital_euro/html/index.en.html', 'https://www.ecb.europa.eu/paym/digital_euro/', 'https://www.centralbank.ie/consumer-hub/explainers/what-is-the-digital-euro']::text[]
WHERE program_id = 22;

UPDATE public.programs
SET min_age = 18,
    max_age = NULL,
    gender_requirement = NULL,
    max_household_income_usd = NULL,
    organization = 'FundLoop Network',
    description = 'FundLoop is a networked mutual-prosperity protocol where participating software platforms and startup founders pool a recurring share (e.g. 1%) of platform revenue into a community distribution fund. Operating in structured monthly epochs, FundLoop combines project commitment intake, Zero-Knowledge proof-of-personhood via CUBID, and governed allocation algorithms to distribute unconditional rewards and Citizen Salaries directly to active users, volunteers, and product champions. On-chain settlement operates on the Base network with fail-closed governance gates.',
    eligibility = '• Verified uniqueness and proof-of-personhood via CUBID.me (zero-knowledge sybil resistance without exposing private identity data)
• Active participation, testing, feedback, or contribution within one or more participating network apps during the open monthly epoch
• Compatible EVM-compatible digital wallet (Base network) connected to recipient profile
• Account in good standing; open universally to participants worldwide regardless of nationality or geographic region',
    amount_description = 'Variable monthly revenue-share distribution based on pool size and contribution weighting (benchmark ~$25 USD/mo)',
    website = 'https://fundloop-website.vercel.app/en',
    apply_url = 'https://fundloop-website.vercel.app/en/participation',
    application_status = 'Planned; onboarding inaugural projects and participant registrations',
    payout_status = 'Planned (Inaugural Cohort / Epoch 1 onboarding under way)',
    status = 'upcoming',
    distribution_type = 'daily_claim_protocol',
    payout_rail = 'crypto_wallet',
    funding_source = 'protocol_yield',
    involvement_level = 'automated_claim',
    available_regions = ARRAY['Global']::text[],
    required_states = ARRAY[]::text[],
    municipalities = ARRAY['Global']::text[],
    sources = ARRAY['https://fundloop-website.vercel.app/en', 'https://fundloop-website.vercel.app/en/participation', 'https://fundloop-website.vercel.app/en/founders', 'https://fundloop.org']::text[]
WHERE program_id = 23;

UPDATE public.programs
SET min_age = 18,
    max_age = 29,
    gender_requirement = NULL,
    max_household_income_usd = NULL,
    application_status = 'Accepting applications',
    status = 'active_open',
    distribution_type = 'guaranteed_recurrent',
    payout_rail = 'direct_deposit',
    funding_source = 'state_federal',
    involvement_level = 'managed_application',
    available_regions = ARRAY['Canada']::text[],
    required_states = ARRAY['New Brunswick']::text[],
    municipalities = ARRAY['Moncton', 'Saint John']::text[],
    sources = ARRAY['https://www2.gnb.ca']::text[]
WHERE program_id = 38;

UPDATE public.programs
SET min_age = 18,
    max_age = NULL,
    gender_requirement = NULL,
    max_household_income_usd = NULL,
    application_status = 'Planned',
    status = 'upcoming',
    distribution_type = 'guaranteed_recurrent',
    payout_rail = 'direct_deposit',
    funding_source = 'municipal_government',
    involvement_level = 'external_self_apply',
    available_regions = ARRAY['United States']::text[],
    required_states = ARRAY['Illinois']::text[],
    municipalities = ARRAY['Cook County', 'Chicago']::text[],
    sources = ARRAY['https://www.cookcountyil.gov/promise', 'https://arpa.cookcountyil.gov/promise-guaranteed-income-pilot-program']::text[]
WHERE program_id = 39;

UPDATE public.programs
SET min_age = 60,
    max_age = NULL,
    gender_requirement = NULL,
    max_household_income_usd = NULL,
    application_status = 'Planned',
    status = 'upcoming',
    distribution_type = 'guaranteed_recurrent',
    payout_rail = 'prepaid_card',
    funding_source = 'state_federal',
    involvement_level = 'external_self_apply',
    available_regions = ARRAY['United States']::text[],
    required_states = ARRAY['California']::text[],
    municipalities = ARRAY['San Joaquin County', 'Stockton']::text[],
    sources = ARRAY['https://www.cdss.ca.gov/inforesources/guaranteed-income-pilot-program/older-californians', 'https://www.cdss.ca.gov/Portals/9/GIPP/2025-intent-award-final.pdf', 'https://www.givedirectly.org/cashsjc', 'https://cashsjc.aidkit.org/apply']::text[]
WHERE program_id = 40;

UPDATE public.programs
SET min_age = 18,
    max_age = NULL,
    gender_requirement = 'female',
    max_household_income_usd = 44000,
    application_status = 'Accepting applications',
    status = 'active_open',
    distribution_type = 'guaranteed_recurrent',
    payout_rail = 'prepaid_card',
    funding_source = 'philanthropic_grant',
    involvement_level = 'external_self_apply',
    available_regions = ARRAY['United States']::text[],
    required_states = ARRAY['New York', 'Arkansas', 'Maryland', 'Kentucky', 'Ohio', 'West Virginia', 'Tennessee']::text[],
    municipalities = ARRAY['New York', 'Baltimore', 'Appalachia']::text[],
    sources = ARRAY['https://www.bridgeproject.org/', 'https://www.bridgeproject.org/apply', 'https://governor.maryland.gov/news/press-releases/governor-moore-announces-partnership-bridge-project']::text[]
WHERE program_id = 41;

UPDATE public.programs
SET min_age = 18,
    max_age = NULL,
    gender_requirement = 'female',
    max_household_income_usd = 12000,
    application_status = 'Ongoing',
    status = 'active_closed',
    distribution_type = 'guaranteed_recurrent',
    payout_rail = 'direct_deposit',
    funding_source = 'philanthropic_grant',
    involvement_level = 'external_self_apply',
    available_regions = ARRAY['United States']::text[],
    required_states = ARRAY['Mississippi']::text[],
    municipalities = ARRAY['Jackson']::text[],
    sources = ARRAY['https://springboardto.org/socioeconomic-well-being/magnolia-mothers-trust/', 'https://springboardto.org/the-7th-cohort/']::text[]
WHERE program_id = 42;

UPDATE public.programs
SET min_age = 16,
    max_age = NULL,
    gender_requirement = NULL,
    max_household_income_usd = NULL,
    application_status = 'Accepting applications',
    status = 'active_open',
    distribution_type = 'lottery_raffle',
    payout_rail = 'direct_deposit',
    funding_source = 'community_crowdfund',
    involvement_level = 'external_self_apply',
    available_regions = ARRAY['Global']::text[],
    required_states = ARRAY[]::text[],
    municipalities = ARRAY['Global']::text[],
    sources = ARRAY['https://www.ubi4all.org/', 'https://www.ubi4all.org/register', 'https://www.ubi4all.org/terms-and-conditions']::text[]
WHERE program_id = 43;

UPDATE public.programs
SET min_age = 18,
    max_age = NULL,
    gender_requirement = NULL,
    max_household_income_usd = NULL,
    application_status = 'Ongoing',
    status = 'active_closed',
    distribution_type = 'guaranteed_recurrent',
    payout_rail = 'direct_deposit',
    funding_source = 'philanthropic_grant',
    involvement_level = 'external_self_apply',
    available_regions = ARRAY['United States']::text[],
    required_states = ARRAY['Minnesota']::text[],
    municipalities = ARRAY['Saint Paul', 'Otter Tail County']::text[],
    sources = ARRAY['https://springboardforthearts.org/programs/guaranteed-income/', 'https://springboardforthearts.org/wp-content/uploads/2023/02/Press_Release_GMI_2023_SBftA.pdf']::text[]
WHERE program_id = 44;

UPDATE public.programs
SET min_age = 18,
    max_age = NULL,
    gender_requirement = NULL,
    max_household_income_usd = NULL,
    application_status = 'Ongoing',
    status = 'active_closed',
    distribution_type = 'guaranteed_recurrent',
    payout_rail = 'direct_deposit',
    funding_source = 'municipal_government',
    involvement_level = 'external_self_apply',
    available_regions = ARRAY['United States']::text[],
    required_states = ARRAY['California']::text[],
    municipalities = ARRAY['Sacramento']::text[],
    sources = ARRAY['https://www.cityofsacramento.gov/ccs/oac/funding-and-grants/creative-growth-fellowship-program.html', 'https://sacramentocityexpress.com/2025/09/05/city-awards-2-04-million-to-200-artists-through-creative-growth-fellowship/']::text[]
WHERE program_id = 45;

UPDATE public.programs
SET min_age = 18,
    max_age = NULL,
    gender_requirement = NULL,
    max_household_income_usd = 80000,
    application_status = 'Pilot completed',
    status = 'closed',
    distribution_type = 'guaranteed_recurrent',
    payout_rail = 'direct_deposit',
    funding_source = 'philanthropic_grant',
    involvement_level = 'external_self_apply',
    available_regions = ARRAY['United States']::text[],
    required_states = ARRAY['Massachusetts']::text[],
    municipalities = ARRAY['Boston']::text[],
    sources = ARRAY['https://campharborview.org/family-services/guaranteed-income-program/', 'https://www.bostonindicators.org/reports/report-detail-pages/dignity-dividend', 'https://www.dotare.io/resources/programs/camp-harbor-view-guaranteed-income-program']::text[]
WHERE program_id = 46;

UPDATE public.programs
SET min_age = 18,
    max_age = NULL,
    gender_requirement = NULL,
    max_household_income_usd = 45000,
    application_status = 'Pilot completed',
    status = 'closed',
    distribution_type = 'guaranteed_recurrent',
    payout_rail = 'prepaid_card',
    funding_source = 'municipal_government',
    involvement_level = 'external_self_apply',
    available_regions = ARRAY['United States']::text[],
    required_states = ARRAY['Pennsylvania']::text[],
    municipalities = ARRAY['Philadelphia']::text[],
    sources = ARRAY['https://phdcphila.org/phlhousing-plus/', 'https://www.housinginitiative.org/phlhousing.html', 'https://www.housinginitiative.org/phlhousing-housing-outcomes-at-two-years.html', 'https://pmc.ncbi.nlm.nih.gov/articles/PMC11938205/']::text[]
WHERE program_id = 47;

UPDATE public.programs
SET min_age = 18,
    max_age = NULL,
    gender_requirement = NULL,
    max_household_income_usd = 30000,
    application_status = 'Ongoing',
    status = 'active_closed',
    distribution_type = 'guaranteed_recurrent',
    payout_rail = 'direct_deposit',
    funding_source = 'philanthropic_grant',
    involvement_level = 'external_self_apply',
    available_regions = ARRAY['United States']::text[],
    required_states = ARRAY['Pennsylvania']::text[],
    municipalities = ARRAY['Philadelphia', 'Delaware Valley']::text[],
    sources = ARRAY['https://clinicaltrials.gov/study/NCT06611982', 'https://pc3i.upenn.edu/our-work/projects/giftt/', 'https://www.pa.gov/agencies/dhs/resources/for-residents/guaranteed-income-pilot-projects', 'https://www.federalregister.gov/documents/2023/03/31/2023-06706/guaranteed-income-financial-treatment-trial-giftt']::text[]
WHERE program_id = 48;

UPDATE public.programs
SET min_age = 18,
    max_age = NULL,
    gender_requirement = NULL,
    max_household_income_usd = NULL,
    application_status = 'Ongoing',
    status = 'active_closed',
    distribution_type = 'guaranteed_recurrent',
    payout_rail = 'prepaid_card',
    funding_source = 'municipal_government',
    involvement_level = 'external_self_apply',
    available_regions = ARRAY['United States']::text[],
    required_states = ARRAY['Pennsylvania']::text[],
    municipalities = ARRAY['Philadelphia']::text[],
    sources = ARRAY['https://philacityfund.org/rfp-gbi/', 'https://www.pa.gov/agencies/dhs/resources/for-residents/guaranteed-income-pilot-projects', 'https://philacityfund.org/wp-content/uploads/2022/12/RFP-HVIP-GBI-Pilot-2022_final.pdf']::text[]
WHERE program_id = 49;

UPDATE public.programs
SET min_age = 18,
    max_age = NULL,
    gender_requirement = NULL,
    max_household_income_usd = NULL,
    application_status = 'Ongoing',
    status = 'active_closed',
    distribution_type = 'guaranteed_recurrent',
    payout_rail = 'direct_deposit',
    funding_source = 'municipal_government',
    involvement_level = 'external_self_apply',
    available_regions = ARRAY['United States']::text[],
    required_states = ARRAY['Pennsylvania']::text[],
    municipalities = ARRAY['Philadelphia']::text[],
    sources = ARRAY['https://www.pa.gov/agencies/dhs/resources/for-residents/guaranteed-income-pilot-projects']::text[]
WHERE program_id = 50;

UPDATE public.programs
SET min_age = 18,
    max_age = NULL,
    gender_requirement = NULL,
    max_household_income_usd = NULL,
    application_status = 'Ongoing',
    status = 'active_closed',
    distribution_type = 'guaranteed_recurrent',
    payout_rail = 'direct_deposit',
    funding_source = 'philanthropic_grant',
    involvement_level = 'external_self_apply',
    available_regions = ARRAY['United States']::text[],
    required_states = ARRAY['Pennsylvania']::text[],
    municipalities = ARRAY['Pittsburgh', 'Allegheny County']::text[],
    sources = ARRAY['https://unitedwayswpa.org/our-impact/community-change-collaboratives/thriving-providers-project/', 'https://www.pa.gov/agencies/dhs/resources/for-residents/guaranteed-income-pilot-projects']::text[]
WHERE program_id = 51;

UPDATE public.programs
SET min_age = NULL,
    max_age = NULL,
    gender_requirement = NULL,
    max_household_income_usd = 850,
    application_status = 'Accepting applications',
    status = 'active_open',
    distribution_type = 'guaranteed_recurrent',
    payout_rail = 'prepaid_card',
    funding_source = 'municipal_government',
    involvement_level = 'external_self_apply',
    available_regions = ARRAY['Brazil']::text[],
    required_states = ARRAY['Rio de Janeiro']::text[],
    municipalities = ARRAY['Maricá']::text[],
    sources = ARRAY['https://rendabasicacidadania.marica.rj.gov.br/', 'https://www.marica.rj.gov.br/noticia/prefeitura-de-marica-segue-com-recadastramento-do-programa-de-renda-basica-de-cidadania/']::text[]
WHERE program_id = 52;

UPDATE public.programs
SET min_age = 18,
    max_age = NULL,
    gender_requirement = NULL,
    max_household_income_usd = 500,
    application_status = 'Ongoing',
    status = 'active_closed',
    distribution_type = 'guaranteed_recurrent',
    payout_rail = 'prepaid_card',
    funding_source = 'municipal_government',
    involvement_level = 'external_self_apply',
    available_regions = ARRAY['Brazil']::text[],
    required_states = ARRAY['Rio de Janeiro']::text[],
    municipalities = ARRAY['Niterói']::text[],
    sources = ARRAY['https://niteroi.rj.gov.br/arariboia/', 'https://niteroi.rj.gov.br/assistencia-social-de-niteroi-inicia-entrega-dos-novos-cartoes-da-moeda-arariboia/', 'https://niteroi.rj.gov.br/prefeito-rodrigo-neves-sanciona-reajuste-de-12-da-moeda-arariboia-e-anuncia-abono-natalino-para-50-mil-familias/']::text[]
WHERE program_id = 53;

UPDATE public.programs
SET min_age = 18,
    max_age = NULL,
    gender_requirement = NULL,
    max_household_income_usd = 600,
    application_status = 'Ongoing',
    status = 'active_closed',
    distribution_type = 'guaranteed_recurrent',
    payout_rail = 'prepaid_card',
    funding_source = 'municipal_government',
    involvement_level = 'external_self_apply',
    available_regions = ARRAY['Brazil']::text[],
    required_states = ARRAY['Rio de Janeiro']::text[],
    municipalities = ARRAY['Saquarema']::text[],
    sources = ARRAY['https://www.saquarema.rj.gov.br/prefeitura-vai-iniciar-recadastramento-da-moeda-social-saqua/', 'https://transparencia.saquarema.rj.gov.br/wp-content/uploads/2026/07/Lei2881_01072026112424.pdf', 'https://transparencia.saquarema.rj.gov.br/wp-content/uploads/2022/02/LO-2189-2022.pdf']::text[]
WHERE program_id = 54;

UPDATE public.programs
SET min_age = 24,
    max_age = 24,
    gender_requirement = NULL,
    max_household_income_usd = NULL,
    application_status = 'Accepting applications',
    status = 'active_open',
    distribution_type = 'guaranteed_recurrent',
    payout_rail = 'prepaid_card',
    funding_source = 'state_federal',
    involvement_level = 'external_self_apply',
    available_regions = ARRAY['South Korea']::text[],
    required_states = ARRAY['Gyeonggi Province']::text[],
    municipalities = ARRAY['Participating Municipalities']::text[],
    sources = ARRAY['https://apply.jobaba.net/special/gibon/main.do', 'https://youth.gg.go.kr/gg/intro/youth-policy-housing-test.do?articleNo=8940&mode=view', 'https://gnews.gg.go.kr/news/news_detail.do?number=202603191948215837C094&s_code=C094']::text[]
WHERE program_id = 55;

UPDATE public.programs
SET min_age = 19,
    max_age = 34,
    gender_requirement = NULL,
    max_household_income_usd = 35000,
    application_status = 'Ongoing',
    status = 'active_closed',
    distribution_type = 'guaranteed_recurrent',
    payout_rail = 'direct_deposit',
    funding_source = 'municipal_government',
    involvement_level = 'external_self_apply',
    available_regions = ARRAY['South Korea']::text[],
    required_states = ARRAY['Seoul']::text[],
    municipalities = ARRAY['Seoul']::text[],
    sources = ARRAY['https://youth.seoul.go.kr/infoData/plcyInfo/view.do?key=2309150002&plcyBizId=V202600005&sprtInfoId=', 'https://news.seoul.go.kr/gov/archives/578136', 'https://mediahub.seoul.go.kr/archives/2018273']::text[]
WHERE program_id = 56;

UPDATE public.programs
SET min_age = NULL,
    max_age = 17,
    gender_requirement = NULL,
    max_household_income_usd = NULL,
    application_status = 'Accepting applications',
    status = 'active_open',
    distribution_type = 'guaranteed_recurrent',
    payout_rail = 'direct_deposit',
    funding_source = 'state_federal',
    involvement_level = 'external_self_apply',
    available_regions = ARRAY['Poland']::text[],
    required_states = ARRAY[]::text[],
    municipalities = ARRAY['Nationwide', 'Warsaw']::text[],
    sources = ARRAY['https://www.zus.pl/swiadczenia/swiadczenia-dla-rodzin/swiadczenie-wychowawcze-800-plus', 'https://www.zus.pl/-/mo%C5%BCna-ju%C5%BC-sk%C5%82ada%C4%87-wnioski-o-800-na-nowy-okres-%C5%9Bwiadczeniowy', 'https://www.gov.pl/web/gov/skorzystaj-z-programu-rodzina-500']::text[]
WHERE program_id = 57;

UPDATE public.programs
SET min_age = 18,
    max_age = NULL,
    gender_requirement = NULL,
    max_household_income_usd = NULL,
    application_status = 'Ongoing',
    status = 'active_closed',
    distribution_type = 'guaranteed_recurrent',
    payout_rail = 'direct_deposit',
    funding_source = 'community_crowdfund',
    involvement_level = 'external_self_apply',
    available_regions = ARRAY['United States']::text[],
    required_states = ARRAY[]::text[],
    municipalities = ARRAY['Nationwide', 'San Francisco']::text[],
    sources = ARRAY['https://www.comingle.us/', 'https://www.comingle.us/faqs']::text[]
WHERE program_id = 58;

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
