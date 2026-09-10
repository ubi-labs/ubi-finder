# Session Log: 2026-09-10 Enhance Open Ongoing Programs (Batch 3E - Final Batch)

- **Timestamp**: 2026-09-10T08:28:00Z
- **Agent**: Antigravity
- **Branch**: `feat/review-and-enhance-batch-3e`
- **Pre-commit HEAD**: `700f9a3c3eb66380c57ff0e48ee00ebaa8ec3fbe`
- **Linked Issue / Request**: Review and enhance every individual record with status Planned (2), Closed ongoing (9), and Open ongoing (75). Execute Batch 3E (final 15 programs).
- **Summary**:
  - Researched, verified live active URLs, corrected critical geographical and regional data errors, and enhanced the final 15 programs (completing all 86 target programs in the repository):
    1. **EBCI GenWell Program (ID: 194)**: Fixed critical geographic misclassification where tribe was placed in 'India' (similar to ID 193); corrected to United States, Western North Carolina (Qualla Boundary, Cherokee, NC at 35.4843, -83.3207). Confirmed EBCI $800/mo targeted guaranteed income transfer. Stanford ID 103.
    2. **Champaign County Guaranteed Income Project (CCGIP) (ID: 204)**: Verified University of Illinois Urbana-Champaign School of Social Work & ROE #9 proof-of-concept pilot ($750/mo unconditional cash for homeless/housing-insecure families with school-age kids under McKinney-Vento). Stanford ID 113.
    3. **Family Goal Fund — Chicago, IL (ID: 209)**: Verified LIFT national portal (`liftcommunities.org`); confirmed two-generation coaching model with $150 quarterly cash transfers ($50/mo; $1,200 over 2 years) for low-income parents in Chicago. Stanford ID 23.
    4. **Baby's First Years — Louisiana (ID: 219)**: Verified live site `babysfirstyears.com`; confirmed New Orleans study site of landmark randomized controlled trial evaluating cash gifts ($333/mo vs. $20/mo) on early infant brain development. Stanford ID 130.
    5. **Striving Towards Economic Prosperity (STEP) (ID: 226)**: Fixed organization name typo ("Unitd" -> "United South End Settlements - USES"); verified Boston $850/mo for 18 months unconditional cash pilot. Stanford ID 138.
    6. **CollegeBound Boost (ID: 241)**: Verified City of Saint Paul Office of Financial Empowerment portal; confirmed Mayor Melvin Carter's initiative providing 333 families with $500/mo for 24 months ($12,000) + $1,000 college savings bonus, studied by UPenn CGIR. Stanford ID 155.
    7. **Baby's First Years — Minnesota (ID: 244)**: Verified `babysfirstyears.com`; confirmed Twin Cities (Minneapolis & Saint Paul) study site of landmark brain development RCT ($333/mo vs. $20/mo on reloadable debit cards). Stanford ID 159.
    8. **Baby's First Years — Nebraska (ID: 259)**: Verified `babysfirstyears.com`; confirmed Greater Omaha study site of landmark pediatric RCT ($333/mo vs. $20/mo on reloadable debit cards). Stanford ID 174.
    9. **HudsonUP (ID: 273)**: Verified live portal `hudsonup.org`; confirmed historic 5-year pilot ($500/mo for 5 years; $30,000 total) to 75 low-income residents in Hudson, NY, studied by Jain Family Institute. Stanford ID 190.
    10. **Family Goal Fund — New York, NY (ID: 276)**: Verified LIFT portal (`liftcommunities.org`); confirmed two-generation coaching model with $150 quarterly cash transfers ($50/mo; $1,200 over 2 years) for low-income parents in NYC. Stanford ID 23.
    11. **Baby's First Years — New York (ID: 277)**: Verified `babysfirstyears.com`; confirmed New York City study site of seminal pediatric brain development RCT ($333/mo vs. $20/mo on reloadable debit cards). Stanford ID 194.
    12. **The Nest (Hummingbird Indigenous Family Services) (ID: 313)**: Located live portal `hummingbird-ifs.org/programs/nest/the-nest`; confirmed first US Indigenous guaranteed income program ($1,250/mo from pregnancy to child age 3; up to $45,000 total) for 150 Indigenous families in King/Pierce/Tulalip, WA. Stanford ID 234.
    13. **Novissi (ID: 320)**: Fixed critical geographic misclassification (was erroneously listed as 'United States'); corrected to Republic of Togo, West Africa (Lomé, Togo at 6.1375, 1.2125). Documented mobile money unconditional cash transfers (10,500–12,250 CFA francs/mo) to 819,972 informal workers, evaluated by UC Berkeley CEGA and J-PAL. Stanford ID 242.
    14. **Kalaignar Magalir Urimai Thogai Thittam (ID: 337)**: Verified official portal `kmut.tn.gov.in`; confirmed historic Tamil Nadu State Government basic income scheme providing ₹1,000 INR/mo (~$12 USD) direct bank transfer to over 11.5 million women heads of households. Stanford ID 263.
    15. **Strengthening Abilities and Journeys of Empowerment (SAJE) / Agreements with Young Adults (ID: 344)**: Verified British Columbia government portal `gov.bc.ca/SAJE`; documented transition from AYA to SAJE providing up to CAD $1,250/mo (~$925 USD) unconditional living support to youth aging out of care. Stanford ID 272.
  - Created migration `supabase/migrations/00037_enhance_open_ongoing_batch_3e.sql` and updated canonical `supabase/seed.sql`.
- **Validation**:
  - `npm run lint`
  - `npm run typecheck`
  - `npm run test:coverage`
  - `npm run build`
- **Follow-ups**:
  - Merge Batch 3E into `main` and finalize comprehensive walkthrough documenting the complete review of all 86 records.
