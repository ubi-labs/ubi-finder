-- ============================================================================
-- Migration 00038: Parent and Grouping Level for Related Programs
-- Introduces:
--   1. public.program_groups
--   2. public.program_group_members
--   3. programs.parent_program_id and programs.program_group_id
--   4. Seeds initial groups and member associations
-- ============================================================================

-- 1. Create program_groups table
CREATE TABLE IF NOT EXISTS public.program_groups (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL UNIQUE,
    slug TEXT NOT NULL UNIQUE,
    description TEXT,
    category TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Index on slug
CREATE INDEX IF NOT EXISTS idx_program_groups_slug ON public.program_groups(slug);

-- Enable RLS
ALTER TABLE public.program_groups ENABLE ROW LEVEL SECURITY;

-- Allow public read access to program_groups
DO $$ BEGIN
    CREATE POLICY "Allow public read access to program_groups"
        ON public.program_groups FOR SELECT
        USING (true);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- 2. Create program_group_members junction table
CREATE TABLE IF NOT EXISTS public.program_group_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id UUID NOT NULL REFERENCES public.program_groups(id) ON DELETE CASCADE,
    program_id INTEGER NOT NULL REFERENCES public.programs(program_id) ON DELETE CASCADE,
    relationship_type TEXT NOT NULL DEFAULT 'member',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (group_id, program_id)
);

-- Indexes on foreign keys
CREATE INDEX IF NOT EXISTS idx_pgm_group_id ON public.program_group_members(group_id);
CREATE INDEX IF NOT EXISTS idx_pgm_program_id ON public.program_group_members(program_id);

-- Enable RLS
ALTER TABLE public.program_group_members ENABLE ROW LEVEL SECURITY;

-- Allow public read access to program_group_members
DO $$ BEGIN
    CREATE POLICY "Allow public read access to program_group_members"
        ON public.program_group_members FOR SELECT
        USING (true);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- 3. Add parent_program_id and program_group_id to public.programs
ALTER TABLE public.programs
    ADD COLUMN IF NOT EXISTS parent_program_id INTEGER REFERENCES public.programs(program_id) ON DELETE SET NULL,
    ADD COLUMN IF NOT EXISTS program_group_id UUID REFERENCES public.program_groups(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_programs_parent_program_id ON public.programs(parent_program_id);
CREATE INDEX IF NOT EXISTS idx_programs_program_group_id ON public.programs(program_group_id);

-- 4. Seed Canonical Program Groups
INSERT INTO public.program_groups (name, slug, description, category)
VALUES
    (
        'Baby''s First Years',
        'babys-first-years',
        'A multi-site randomized controlled trial across four US metropolitan areas (New Orleans, Twin Cities, Omaha, New York City) testing the causal impact of monthly unconditional cash gifts on infant and toddler cognitive brain development.',
        'multisite_rct'
    ),
    (
        'DMV Regional Pilots',
        'dmv-regional-pilots',
        'Guaranteed income and economic mobility initiatives serving workers and families across the Washington, D.C. metropolitan region (District of Columbia, Suburban Maryland, and Northern Virginia).',
        'regional_cluster'
    ),
    (
        'Eastern Band of Cherokee Indians (EBCI)',
        'eastern-band-of-cherokee-indians',
        'Sovereign economic security, dividend, and guaranteed income programs established by the Eastern Band of Cherokee Indians on the Qualla Boundary in Western North Carolina.',
        'sovereign_nation'
    ),
    (
        'LIFT Family Goal Fund',
        'lift-family-goal-fund',
        'Two-generation coaching and direct cash transfer initiatives operated by LIFT across Los Angeles, Washington D.C., Chicago, and New York City providing quarterly financial cushions to parents of young children.',
        'national_initiative'
    ),
    (
        'OpenResearch Guaranteed Income Study (RISE GMI)',
        'openresearch-rise-gmi',
        'The comprehensive unconditional cash transfer study organized by OpenResearch evaluating the socioeconomic impacts of $1,500/month across rural and urban counties.',
        'multisite_rct'
    ),
    (
        'Santa Clara County & Destination: Home GBI Pilots',
        'santa-clara-destination-home',
        'A coordinated suite of guaranteed basic income pilots in Silicon Valley designed to prevent homelessness and promote economic stability for high school students, young parents, and justice-involved individuals.',
        'regional_cluster'
    ),
    (
        'Miracle Messages Miracle Money',
        'miracle-messages-miracle-money',
        'Direct cash transfer pilots paired with relational support (Miracle Friends) for unhoused individuals across California, evaluated in randomized controlled trials with USC.',
        'relational_cash'
    ),
    (
        'Cook County Promise Guaranteed Income',
        'cook-county-promise',
        'Cook County Government''s flagship guaranteed income initiatives in Illinois, encompassing the initial 2022–2025 pilot and the succeeding municipal phase.',
        'municipal_initiative'
    ),
    (
        'In Her Hands (GRO Fund & GiveDirectly)',
        'in-her-hands',
        'One of the largest guaranteed income pilots in the American South, providing unconditional cash transfers to women across Atlanta, Southwest Georgia, and neighboring communities.',
        'state_initiative'
    ),
    (
        'Philadelphia Maternal & Infant Pilots',
        'philadelphia-maternal-infant-pilots',
        'Guaranteed income demonstrations focused on reducing maternal and infant mortality and poverty among pregnant and postpartum mothers in Philadelphia.',
        'maternal_infant'
    ),
    (
        'Abundant Birth Project',
        'abundant-birth-project',
        'The nation''s first pregnancy guaranteed income program, pioneered by Expecting Justice in San Francisco and expanded across multiple California counties.',
        'maternal_infant'
    ),
    (
        'Point Source Youth Trust Youth Initiative',
        'point-source-youth-trust-youth',
        'Direct cash transfer initiatives providing unconditional income to young adults experiencing housing insecurity and homelessness.',
        'youth_transitions'
    ),
    (
        'United Way California Capital Region GBI',
        'united-way-california-capital-region',
        'Guaranteed income cohorts administered by United Way California Capital Region across Sacramento County and surrounding areas.',
        'regional_cluster'
    ),
    (
        'Decentralized & Web3 Universal Basic Income',
        'decentralized-web3-ubi',
        'Decentralized protocols and cryptographically verified proof-of-humanity networks delivering daily and recurring unconditional basic income.',
        'web3_defi'
    ),
    (
        'Gyeonggi Province Basic Income Programs',
        'gyeonggi-province-basic-income',
        'The Republic of Korea''s pioneering provincial basic income programs including youth, rural, and farmer dividends in Gyeonggi Province.',
        'provincial_dividend'
    ),
    (
        'Universal Child Benefits & Family Allowances',
        'universal-child-benefits',
        'Statutory, non-means-tested universal child allowances and family demogrants provided by national governments to ensure baseline child economic security.',
        'universal_demogrant'
    ),
    (
        'Universal Sovereign Old Age Pensions',
        'universal-old-age-pensions',
        'Non-contributory universal pensions funded from national revenues or sovereign wealth funds paid unconditionally to all citizens reaching senior eligibility age.',
        'universal_pension'
    )
ON CONFLICT (slug) DO UPDATE
SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    category = EXCLUDED.category,
    updated_at = now();

-- 5. Seed Program Group Members & primary group IDs

-- Helper macro: link program IDs to group slug
DO $$
DECLARE
    r RECORD;
BEGIN
    -- 1. Baby's First Years: IDs 219, 244, 259, 277
    FOR r IN SELECT id FROM public.program_groups WHERE slug = 'babys-first-years' LOOP
        INSERT INTO public.program_group_members (group_id, program_id, relationship_type)
        SELECT r.id, p.program_id, 'site'
        FROM public.programs p
        WHERE p.program_id IN (219, 244, 259, 277)
        ON CONFLICT (group_id, program_id) DO NOTHING;

        UPDATE public.programs SET program_group_id = r.id WHERE program_id IN (219, 244, 259, 277) AND program_group_id IS NULL;
    END LOOP;

    -- 2. DMV Regional Pilots: IDs 186, 188
    FOR r IN SELECT id FROM public.program_groups WHERE slug = 'dmv-regional-pilots' LOOP
        INSERT INTO public.program_group_members (group_id, program_id, relationship_type)
        SELECT r.id, p.program_id, 'regional_site'
        FROM public.programs p
        WHERE p.program_id IN (186, 188)
        ON CONFLICT (group_id, program_id) DO NOTHING;

        UPDATE public.programs SET program_group_id = r.id WHERE program_id = 186 AND program_group_id IS NULL;
    END LOOP;

    -- 3. Eastern Band of Cherokee Indians (EBCI): IDs 193, 194
    FOR r IN SELECT id FROM public.program_groups WHERE slug = 'eastern-band-of-cherokee-indians' LOOP
        INSERT INTO public.program_group_members (group_id, program_id, relationship_type)
        SELECT r.id, p.program_id, 'sovereign_program'
        FROM public.programs p
        WHERE p.program_id IN (193, 194)
        ON CONFLICT (group_id, program_id) DO NOTHING;

        UPDATE public.programs SET program_group_id = r.id WHERE program_id IN (193, 194) AND program_group_id IS NULL;
    END LOOP;

    -- 4. LIFT Family Goal Fund: IDs 120, 188, 209, 276
    FOR r IN SELECT id FROM public.program_groups WHERE slug = 'lift-family-goal-fund' LOOP
        INSERT INTO public.program_group_members (group_id, program_id, relationship_type)
        SELECT r.id, p.program_id, 'city_cohort'
        FROM public.programs p
        WHERE p.program_id IN (120, 188, 209, 276)
        ON CONFLICT (group_id, program_id) DO NOTHING;

        UPDATE public.programs SET program_group_id = r.id WHERE program_id IN (120, 209, 276) AND program_group_id IS NULL;
    END LOOP;

    -- 5. OpenResearch RISE GMI: IDs 248, 256, 317
    FOR r IN SELECT id FROM public.program_groups WHERE slug = 'openresearch-rise-gmi' LOOP
        INSERT INTO public.program_group_members (group_id, program_id, relationship_type)
        SELECT r.id, p.program_id, 'study_site'
        FROM public.programs p
        WHERE p.program_id IN (248, 256, 317)
        ON CONFLICT (group_id, program_id) DO NOTHING;

        UPDATE public.programs SET program_group_id = r.id WHERE program_id IN (248, 256, 317) AND program_group_id IS NULL;
    END LOOP;

    -- 6. Santa Clara County & Destination: Home: IDs 162, 163, 164
    FOR r IN SELECT id FROM public.program_groups WHERE slug = 'santa-clara-destination-home' LOOP
        INSERT INTO public.program_group_members (group_id, program_id, relationship_type)
        SELECT r.id, p.program_id, 'target_population_pilot'
        FROM public.programs p
        WHERE p.program_id IN (162, 163, 164)
        ON CONFLICT (group_id, program_id) DO NOTHING;

        UPDATE public.programs SET program_group_id = r.id WHERE program_id IN (162, 163, 164) AND program_group_id IS NULL;
    END LOOP;

    -- 7. Miracle Messages Miracle Money: IDs 128, 174
    FOR r IN SELECT id FROM public.program_groups WHERE slug = 'miracle-messages-miracle-money' LOOP
        INSERT INTO public.program_group_members (group_id, program_id, relationship_type)
        SELECT r.id, p.program_id, 'initiative_tier'
        FROM public.programs p
        WHERE p.program_id IN (128, 174)
        ON CONFLICT (group_id, program_id) DO NOTHING;

        UPDATE public.programs SET program_group_id = r.id WHERE program_id IN (128, 174) AND program_group_id IS NULL;
    END LOOP;

    -- 8. Cook County Promise: IDs 39, 218
    FOR r IN SELECT id FROM public.program_groups WHERE slug = 'cook-county-promise' LOOP
        INSERT INTO public.program_group_members (group_id, program_id, relationship_type)
        SELECT r.id, p.program_id, 'phase'
        FROM public.programs p
        WHERE p.program_id IN (39, 218)
        ON CONFLICT (group_id, program_id) DO NOTHING;

        UPDATE public.programs SET program_group_id = r.id WHERE program_id IN (39, 218) AND program_group_id IS NULL;
        UPDATE public.programs SET parent_program_id = 218 WHERE program_id = 39;
    END LOOP;

    -- 9. In Her Hands: IDs 199, 208
    FOR r IN SELECT id FROM public.program_groups WHERE slug = 'in-her-hands' LOOP
        INSERT INTO public.program_group_members (group_id, program_id, relationship_type)
        SELECT r.id, p.program_id, 'community_site'
        FROM public.programs p
        WHERE p.program_id IN (199, 208)
        ON CONFLICT (group_id, program_id) DO NOTHING;

        UPDATE public.programs SET program_group_id = r.id WHERE program_id IN (199, 208) AND program_group_id IS NULL;
    END LOOP;

    -- 10. Philadelphia Maternal & Infant Pilots: IDs 3, 4
    FOR r IN SELECT id FROM public.program_groups WHERE slug = 'philadelphia-maternal-infant-pilots' LOOP
        INSERT INTO public.program_group_members (group_id, program_id, relationship_type)
        SELECT r.id, p.program_id, 'city_pilot'
        FROM public.programs p
        WHERE p.program_id IN (3, 4)
        ON CONFLICT (group_id, program_id) DO NOTHING;

        UPDATE public.programs SET program_group_id = r.id WHERE program_id IN (3, 4) AND program_group_id IS NULL;
    END LOOP;

    -- 11. Abundant Birth Project: IDs 131, 132, 133, 134, 135
    FOR r IN SELECT id FROM public.program_groups WHERE slug = 'abundant-birth-project' LOOP
        INSERT INTO public.program_group_members (group_id, program_id, relationship_type)
        SELECT r.id, p.program_id, 'county_expansion'
        FROM public.programs p
        WHERE p.program_id IN (131, 132, 133, 134, 135)
        ON CONFLICT (group_id, program_id) DO NOTHING;

        UPDATE public.programs SET program_group_id = r.id WHERE program_id IN (131, 132, 133, 134, 135) AND program_group_id IS NULL;
    END LOOP;

    -- 12. Point Source Youth Trust Youth: IDs 156, 291
    FOR r IN SELECT id FROM public.program_groups WHERE slug = 'point-source-youth-trust-youth' LOOP
        INSERT INTO public.program_group_members (group_id, program_id, relationship_type)
        SELECT r.id, p.program_id, 'initiative_site'
        FROM public.programs p
        WHERE p.program_id IN (156, 291)
        ON CONFLICT (group_id, program_id) DO NOTHING;

        UPDATE public.programs SET program_group_id = r.id WHERE program_id IN (156, 291) AND program_group_id IS NULL;
    END LOOP;

    -- 13. United Way California Capital Region GBI: IDs 143, 144, 145
    FOR r IN SELECT id FROM public.program_groups WHERE slug = 'united-way-california-capital-region' LOOP
        INSERT INTO public.program_group_members (group_id, program_id, relationship_type)
        SELECT r.id, p.program_id, 'cohort'
        FROM public.programs p
        WHERE p.program_id IN (143, 144, 145)
        ON CONFLICT (group_id, program_id) DO NOTHING;

        UPDATE public.programs SET program_group_id = r.id WHERE program_id IN (143, 144, 145) AND program_group_id IS NULL;
    END LOOP;

    -- 14. Decentralized Web3 UBI: IDs 19, 21, 23
    FOR r IN SELECT id FROM public.program_groups WHERE slug = 'decentralized-web3-ubi' LOOP
        INSERT INTO public.program_group_members (group_id, program_id, relationship_type)
        SELECT r.id, p.program_id, 'protocol'
        FROM public.programs p
        WHERE p.program_id IN (19, 21, 23)
        ON CONFLICT (group_id, program_id) DO NOTHING;

        UPDATE public.programs SET program_group_id = r.id WHERE program_id IN (19, 21, 23) AND program_group_id IS NULL;
    END LOOP;

    -- 15. Gyeonggi Province Basic Income: IDs 9, 55, 322
    FOR r IN SELECT id FROM public.program_groups WHERE slug = 'gyeonggi-province-basic-income' LOOP
        INSERT INTO public.program_group_members (group_id, program_id, relationship_type)
        SELECT r.id, p.program_id, 'provincial_scheme'
        FROM public.programs p
        WHERE p.program_id IN (9, 55, 322)
        ON CONFLICT (group_id, program_id) DO NOTHING;

        UPDATE public.programs SET program_group_id = r.id WHERE program_id IN (9, 55, 322) AND program_group_id IS NULL;
    END LOOP;

    -- 16. Universal Child Benefits: IDs 360, 361, 362, 363, 364, 367, 368, 369, 370, 377, 378, 379, 381
    FOR r IN SELECT id FROM public.program_groups WHERE slug = 'universal-child-benefits' LOOP
        INSERT INTO public.program_group_members (group_id, program_id, relationship_type)
        SELECT r.id, p.program_id, 'national_policy'
        FROM public.programs p
        WHERE p.program_id IN (360, 361, 362, 363, 364, 367, 368, 369, 370, 377, 378, 379, 381)
        ON CONFLICT (group_id, program_id) DO NOTHING;

        UPDATE public.programs SET program_group_id = r.id WHERE program_id IN (360, 361, 362, 363, 364, 367, 368, 369, 370, 377, 378, 379, 381) AND program_group_id IS NULL;
    END LOOP;

    -- 17. Universal Old Age Pensions: IDs 365, 366, 371, 372, 373, 374, 375, 376, 380
    FOR r IN SELECT id FROM public.program_groups WHERE slug = 'universal-old-age-pensions' LOOP
        INSERT INTO public.program_group_members (group_id, program_id, relationship_type)
        SELECT r.id, p.program_id, 'national_policy'
        FROM public.programs p
        WHERE p.program_id IN (365, 366, 371, 372, 373, 374, 375, 376, 380)
        ON CONFLICT (group_id, program_id) DO NOTHING;

        UPDATE public.programs SET program_group_id = r.id WHERE program_id IN (365, 366, 371, 372, 373, 374, 375, 376, 380) AND program_group_id IS NULL;
    END LOOP;
END $$;
