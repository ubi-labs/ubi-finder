# Session Log: 2026-09-10 Enhance Open Ongoing Programs (Batch 3A)

- **Timestamp**: 2026-09-10T07:43:00Z
- **Agent**: Antigravity
- **Branch**: `feat/review-and-enhance-batch-3a`
- **Pre-commit HEAD**: `06fc92e90d31010d22f3991bb084c548ed6b3bac`
- **Linked Issue / Request**: Review and enhance every individual record with status Planned (2), Closed ongoing (9), and Open ongoing (75). Execute Batch 3A (15 programs).
- **Summary**:
  - Researched, verified live active URLs, resolved 404s/redirects, and enhanced all 15 programs in Batch 3A:
    1. **Preserving Our Diversity (ID: 6)**: Verified Santa Monica Housing Authority portals; confirmed up to $939/mo ($700 benchmark) for seniors 65+ in rent-controlled apartments with rent burden >30%. Stanford ID 72.
    2. **Mein Grundeinkommen Basic Income Raffle (ID: 18)**: Verified German crowdfunding platform, €1,000/mo ($1,100 USD) unconditional 1-year award, worldwide eligibility, DIW Berlin research collaboration. Stanford ID 266.
    3. **Rx Kids (ID: 5)**: Verified MSU and GiveDirectly portals, AidKit registration; confirmed $1,500 prenatal transfer + $500/mo for 12 months ($7,500 package) across Michigan communities without income testing. Stanford ID 151.
    4. **Child Benefit (UK) (ID: 363)**: Verified HMRC portals; confirmed £25.60/wk for eldest child and £16.95/wk per additional child (~$145 / ~$96 monthly equivalent) under 16/20.
    5. **Allocation Familiale (Luxembourg) (ID: 370)**: Replaced broken 404 URL with active CAE portal (`/allocations/allocation-pour-lavenir-des-enfants.html`); confirmed universal flat allowance of €299.86/mo per child with age escalators at ages 6 and 12.
    6. **Jido Teate (Japan) (ID: 377)**: Replaced broken 404 URL with active Children and Families Agency portal (`/policies/kokoseido/jidouteate`); confirmed complete elimination of income caps, coverage through age 18, ¥10,000–¥15,000/mo (¥30,000 for 3rd child+).
    7. **Kindergeld (Germany) (ID: 360)**: Verified Arbeitsagentur and BMFSFJ federal family portals; confirmed universal €255/mo per child through age 18/25.
    8. **Barnetrygd (Norway) (ID: 361)**: Verified official NAV portals in Norwegian and English; confirmed NOK 1,766/mo (<6) and NOK 1,510/mo (6–18) universal non-means-tested child benefit.
    9. **Child Benefit (Ireland) (ID: 364)**: Replaced broken 404 gov.ie URL with official DSP active portal on Services MyWelfare (`services.mywelfare.ie/en/topics/parents-children-family/child-benefit/`); confirmed €140/mo per child through age 18.
    10. **It All Adds Up pilot (ID: 146)**: Discovered dedicated live domain (`italladdsupsf.org`) affiliated with Compass Family Services, Hamilton Families, and NYU Furman Center; confirmed 225 families receiving $1,000/mo for 12 months. Stanford ID 51.
    11. **Familienbeihilfe (Austria) (ID: 369)**: Replaced broken 404 URL with active Austrian Federal Chancellery portal (`/agenda/familie/familienbeihilfe.html`); confirmed universal age-scaled child allowance from €132.30 to €191.60/mo plus sibling multipliers.
    12. **Old Age Pension (Botswana) (ID: 371)**: Verified Department of Social Protection universal P630/mo pension for all citizens aged 65+ with Omang national ID.
    13. **Lapsilisä (Finland) (ID: 368)**: Verified official Kela portals in Finnish and English; confirmed universal progressive child benefit from €94.88 to €192.69/mo through age 17 plus single-parent supplement.
    14. **Old Age Pension Scheme (Brunei) (ID: 374)**: Verified JAPEM and Ministry of Culture, Youth and Sports portals; confirmed universal B$250/mo (~$190 USD) pension for citizens and PRs aged 60+.
    15. **National Cash Subsidy (Iran) (ID: 331)**: Verified nationwide universal cash subsidy framework replacing energy/food price supports, active since 2010 for ~73M citizens. Stanford ID 257.
  - Created migration `supabase/migrations/00033_enhance_open_ongoing_batch_3a.sql` and updated canonical `supabase/seed.sql`.
- **Validation**:
  - `npm run lint` (passed)
  - `npm run typecheck` (passed)
  - `npm run test:coverage` (100% pass, 4 test suites, 44 tests passed)
  - `npm run build` (built cleanly)
- **Follow-ups**:
  - Merge Batch 3A into `main` and proceed to Batch 3B (15 programs: IDs 38, 381, 365, 9, 10, 13, 14, 15, 16, 20, 21, 199, 252, 298, 322).
