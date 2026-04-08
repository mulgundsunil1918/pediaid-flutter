-- =============================================================================
-- Migration : 0001_pediaid-academics.sql
-- Module    : PediAid Academics
-- Target    : PostgreSQL 15+
-- Created   : 2026-04-08
-- Description:
--   Creates the complete PediAid Academics schema for the PediAid / neoapp
--   platform. All objects are prefixed with `acad_` to avoid collisions with
--   existing tables.
-- =============================================================================

BEGIN;

-- =============================================================================
-- SECTION 0 — EXTENSIONS
-- =============================================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;   -- gen_random_uuid()
CREATE EXTENSION IF NOT EXISTS ltree;      -- threaded comment paths
CREATE EXTENSION IF NOT EXISTS pg_trgm;    -- trigram similarity search


-- =============================================================================
-- SECTION 1 — ENUMS
-- =============================================================================

CREATE TYPE acad_user_role AS ENUM (
    'reader',
    'author',
    'moderator',
    'admin'
);

CREATE TYPE acad_chapter_status AS ENUM (
    'draft',
    'pending',
    'approved',
    'rejected',
    'archived'
);

CREATE TYPE acad_event_type AS ENUM (
    'webinar',
    'workshop',
    'conference',
    'course'
);

CREATE TYPE acad_event_status AS ENUM (
    'upcoming',
    'live',
    'completed',
    'cancelled'
);


-- =============================================================================
-- SECTION 2 — TAXONOMY  (admin-seeded; users cannot create rows)
-- =============================================================================

CREATE TABLE acad_subjects (
    id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    name            VARCHAR(100) NOT NULL,
    code            VARCHAR(10)  NOT NULL UNIQUE,          -- e.g. 'NEO'
    description     TEXT,
    display_order   SMALLINT    NOT NULL DEFAULT 0,
    is_active       BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by      UUID                                   -- FK added after acad_users
);

CREATE TABLE acad_systems (
    id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    subject_id      UUID        NOT NULL REFERENCES acad_subjects(id) ON DELETE RESTRICT,
    name            VARCHAR(100) NOT NULL,
    code            VARCHAR(20),
    description     TEXT,
    display_order   SMALLINT    NOT NULL DEFAULT 0,
    is_active       BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (subject_id, name)
);

CREATE TABLE acad_topics (
    id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    system_id       UUID        NOT NULL REFERENCES acad_systems(id) ON DELETE RESTRICT,
    name            VARCHAR(150) NOT NULL,
    description     TEXT,
    display_order   SMALLINT    NOT NULL DEFAULT 0,
    is_active       BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (system_id, name)
);


-- =============================================================================
-- SECTION 3 — USERS & AUTH
-- =============================================================================

CREATE TABLE acad_users (
    id                  UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    email               VARCHAR(255)    NOT NULL UNIQUE,
    password_hash       VARCHAR(72)     NOT NULL,          -- bcrypt; max 72 bytes
    role                acad_user_role  NOT NULL DEFAULT 'reader',
    is_verified         BOOLEAN         NOT NULL DEFAULT FALSE,
    is_active           BOOLEAN         NOT NULL DEFAULT TRUE,
    last_login          TIMESTAMPTZ,
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    neoapp_user_id      VARCHAR(100)                       -- nullable; links to existing user table
);

-- Now that acad_users exists, add the FK on acad_subjects.created_by
ALTER TABLE acad_subjects
    ADD CONSTRAINT fk_acad_subjects_created_by
    FOREIGN KEY (created_by) REFERENCES acad_users(id) ON DELETE SET NULL;

CREATE TABLE acad_profiles (
    user_id                 UUID            PRIMARY KEY REFERENCES acad_users(id) ON DELETE CASCADE,
    full_name               VARCHAR(200)    NOT NULL,
    qualification           VARCHAR(100),                  -- e.g. 'MD', 'MBBS', 'DNB'
    specialty               VARCHAR(150),
    subspecialty            VARCHAR(150),
    institution             VARCHAR(200),
    department              VARCHAR(150),
    bio                     TEXT,
    profile_image_url       TEXT,
    orcid_id                VARCHAR(30),                   -- e.g. '0000-0002-1825-0097'
    credentials_verified    BOOLEAN         NOT NULL DEFAULT FALSE,  -- admin-set
    verification_documents  JSONB           NOT NULL DEFAULT '[]'::JSONB,
    public_visibility       BOOLEAN         NOT NULL DEFAULT TRUE,
    updated_at              TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

CREATE TABLE acad_refresh_tokens (
    id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID        NOT NULL REFERENCES acad_users(id) ON DELETE CASCADE,
    token_hash  VARCHAR(128) NOT NULL,                     -- SHA-256 hex of the raw token
    issued_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    expires_at  TIMESTAMPTZ  NOT NULL,
    revoked_at  TIMESTAMPTZ,                               -- NULL → still valid
    user_agent  TEXT,
    ip_address  INET
);


-- =============================================================================
-- SECTION 4 — CHAPTERS  (core content entity)
-- =============================================================================

CREATE TABLE acad_chapters (
    -- Identity
    id                  UUID            PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Taxonomy (denormalized for query performance)
    subject_id          UUID            NOT NULL REFERENCES acad_subjects(id) ON DELETE RESTRICT,
    system_id           UUID            NOT NULL REFERENCES acad_systems(id)  ON DELETE RESTRICT,
    topic_id            UUID            NOT NULL REFERENCES acad_topics(id)   ON DELETE RESTRICT,

    -- Content
    title               VARCHAR(200)    NOT NULL,
    slug                TEXT            NOT NULL UNIQUE,   -- format: subject-code/system/topic/chapter
    content             JSONB           NOT NULL DEFAULT '{"blocks": []}'::JSONB,
    plain_text          TEXT,                              -- auto-extracted by trigger for FTS
    featured_image_url  TEXT,
    attachments         JSONB           NOT NULL DEFAULT '[]'::JSONB,

    -- References / Citations
    chapter_references  JSONB           NOT NULL DEFAULT '[]'::JSONB,
    -- Each element: { id, title, authors[], journal, year, volume, issue, pages, doi, url }

    -- Authorship
    author_id           UUID            NOT NULL REFERENCES acad_users(id) ON DELETE RESTRICT,
    co_authors          UUID[]          NOT NULL DEFAULT '{}',

    -- Workflow
    status              acad_chapter_status NOT NULL DEFAULT 'draft',
    submitted_at        TIMESTAMPTZ,
    reviewed_at         TIMESTAMPTZ,
    reviewed_by         UUID            REFERENCES acad_users(id) ON DELETE SET NULL,
    moderator_notes     TEXT,
    moderation_history  JSONB           NOT NULL DEFAULT '[]'::JSONB,
    -- Append-only array of { at, by, action, notes }

    -- Versioning
    version             INT             NOT NULL DEFAULT 1,
    parent_version_id   UUID            REFERENCES acad_chapters(id) ON DELETE SET NULL,
    is_latest_version   BOOLEAN         NOT NULL DEFAULT TRUE,

    -- Metrics
    view_count          BIGINT          NOT NULL DEFAULT 0,
    reading_time_minutes INT            NOT NULL DEFAULT 1,

    -- Timestamps
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    published_at        TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT chk_content_has_blocks
        CHECK (jsonb_typeof(content) = 'object' AND (content ? 'blocks')),

    CONSTRAINT chk_reviewed_by_requires_reviewed_at
        CHECK (
            (reviewed_by IS NULL AND reviewed_at IS NULL)
            OR
            (reviewed_by IS NOT NULL AND reviewed_at IS NOT NULL)
        )
);


-- =============================================================================
-- SECTION 5 — COMMENTS  (threaded via ltree)
-- =============================================================================

CREATE TABLE acad_comments (
    id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    chapter_id      UUID        NOT NULL REFERENCES acad_chapters(id) ON DELETE CASCADE,
    parent_id       UUID        REFERENCES acad_comments(id) ON DELETE CASCADE,
    author_id       UUID        NOT NULL REFERENCES acad_users(id) ON DELETE RESTRICT,
    content         TEXT        NOT NULL,
    CONSTRAINT chk_comment_length CHECK (char_length(content) BETWEEN 1 AND 5000),

    -- ltree threading (auto-set by trigger)
    path            LTREE       NOT NULL,
    depth           SMALLINT    NOT NULL DEFAULT 0,
    CONSTRAINT chk_depth_range CHECK (depth BETWEEN 0 AND 5),

    -- Moderation
    is_flagged      BOOLEAN     NOT NULL DEFAULT FALSE,
    flagged_reason  TEXT,
    flagged_by      UUID        REFERENCES acad_users(id) ON DELETE SET NULL,
    flagged_at      TIMESTAMPTZ,

    -- Soft delete
    is_deleted      BOOLEAN     NOT NULL DEFAULT FALSE,
    deleted_at      TIMESTAMPTZ,

    -- Edit tracking
    is_edited       BOOLEAN     NOT NULL DEFAULT FALSE,
    edited_at       TIMESTAMPTZ,

    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


-- =============================================================================
-- SECTION 6 — CME EVENTS
-- =============================================================================

CREATE TABLE acad_cme_events (
    id                          UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    title                       VARCHAR(300)    NOT NULL,
    description                 TEXT,
    event_type                  acad_event_type NOT NULL,

    -- Speaker
    speaker_name                VARCHAR(200),
    speaker_credentials         VARCHAR(200),
    speaker_bio                 TEXT,
    speaker_image_url           TEXT,

    -- Scheduling
    start_time                  TIMESTAMPTZ     NOT NULL,
    end_time                    TIMESTAMPTZ     NOT NULL,
    timezone                    VARCHAR(50)     NOT NULL DEFAULT 'Asia/Kolkata',
    is_recurring                BOOLEAN         NOT NULL DEFAULT FALSE,
    recurrence_pattern          JSONB,          -- null when not recurring

    -- Content
    learning_objectives         TEXT[]          NOT NULL DEFAULT '{}',
    target_audience             TEXT[]          NOT NULL DEFAULT '{}',
    prerequisites               TEXT,
    meeting_url                 TEXT,
    recording_url               TEXT,
    presentation_slides_url     TEXT,
    handout_url                 TEXT,

    -- Accreditation
    cme_credits                 NUMERIC(3,1),
    accreditation_body          VARCHAR(150),
    accreditation_number        VARCHAR(100),

    -- Workflow
    status                      acad_event_status NOT NULL DEFAULT 'upcoming',
    max_attendees               INT,

    -- Meta
    created_by                  UUID            NOT NULL REFERENCES acad_users(id) ON DELETE RESTRICT,
    created_at                  TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at                  TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

CREATE TABLE acad_cme_registrations (
    event_id                UUID        NOT NULL REFERENCES acad_cme_events(id) ON DELETE CASCADE,
    user_id                 UUID        NOT NULL REFERENCES acad_users(id)      ON DELETE CASCADE,
    registered_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    attended                BOOLEAN     NOT NULL DEFAULT FALSE,
    attendance_verified_at  TIMESTAMPTZ,
    certificate_issued      BOOLEAN     NOT NULL DEFAULT FALSE,
    certificate_url         TEXT,
    PRIMARY KEY (event_id, user_id)
);


-- =============================================================================
-- SECTION 7 — AUDIT LOG  (append-only; no UPDATE/DELETE should ever run here)
-- =============================================================================

CREATE TABLE acad_audit_log (
    id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_type     VARCHAR(50) NOT NULL,                  -- e.g. 'acad_chapters'
    entity_id       UUID        NOT NULL,
    action          VARCHAR(50) NOT NULL,                  -- e.g. 'status_change', 'delete'
    performed_by    UUID        REFERENCES acad_users(id) ON DELETE SET NULL,
    details         JSONB,
    ip_address      INET,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


-- =============================================================================
-- SECTION 8 — INDEXES
-- =============================================================================

-- acad_subjects
CREATE INDEX idx_acad_subjects_active_order
    ON acad_subjects (is_active, display_order);

-- acad_systems
CREATE INDEX idx_acad_systems_subject_active_order
    ON acad_systems (subject_id, is_active, display_order);

-- acad_topics
CREATE INDEX idx_acad_topics_system_active_order
    ON acad_topics (system_id, is_active, display_order);

-- acad_users
CREATE INDEX idx_acad_users_email        ON acad_users (email);
CREATE INDEX idx_acad_users_role_active  ON acad_users (role, is_active);

-- acad_refresh_tokens
CREATE INDEX idx_acad_refresh_tokens_user_expires
    ON acad_refresh_tokens (user_id, expires_at)
    WHERE revoked_at IS NULL;
CREATE INDEX idx_acad_refresh_tokens_hash
    ON acad_refresh_tokens (token_hash);

-- acad_chapters — general
CREATE INDEX idx_acad_chapters_topic_status_created
    ON acad_chapters (topic_id, status, created_at DESC);
CREATE INDEX idx_acad_chapters_author_status
    ON acad_chapters (author_id, status);

-- acad_chapters — moderation queue
CREATE INDEX idx_acad_chapters_pending
    ON acad_chapters (status, submitted_at)
    WHERE status = 'pending';

-- acad_chapters — versioning
CREATE INDEX idx_acad_chapters_topic_latest
    ON acad_chapters (topic_id, is_latest_version)
    WHERE is_latest_version = TRUE;

-- acad_chapters — public browsing
CREATE INDEX idx_acad_chapters_approved_published
    ON acad_chapters (topic_id, published_at DESC)
    WHERE status = 'approved' AND is_latest_version = TRUE;

-- acad_chapters — full-text search
CREATE INDEX idx_acad_chapters_fts
    ON acad_chapters
    USING GIN (to_tsvector('english', coalesce(title, '') || ' ' || coalesce(plain_text, '')));

-- acad_chapters — trigram similarity on title
CREATE INDEX idx_acad_chapters_title_trgm
    ON acad_chapters
    USING GIN (title gin_trgm_ops);

-- acad_comments
CREATE INDEX idx_acad_comments_chapter_created
    ON acad_comments (chapter_id, created_at)
    WHERE is_deleted = FALSE;
CREATE INDEX idx_acad_comments_path
    ON acad_comments USING GIST (path);
CREATE INDEX idx_acad_comments_parent
    ON acad_comments (parent_id);
CREATE INDEX idx_acad_comments_flagged
    ON acad_comments (is_flagged, created_at)
    WHERE is_flagged = TRUE;

-- acad_cme_events
CREATE INDEX idx_acad_cme_events_upcoming
    ON acad_cme_events (status, start_time)
    WHERE status = 'upcoming';
CREATE INDEX idx_acad_cme_events_start_time
    ON acad_cme_events (start_time DESC);

-- acad_cme_registrations
CREATE INDEX idx_acad_cme_reg_user     ON acad_cme_registrations (user_id);
CREATE INDEX idx_acad_cme_reg_attended ON acad_cme_registrations (event_id, attended);

-- acad_audit_log
CREATE INDEX idx_acad_audit_entity
    ON acad_audit_log (entity_type, entity_id, created_at DESC);
CREATE INDEX idx_acad_audit_performer
    ON acad_audit_log (performed_by, created_at DESC);


-- =============================================================================
-- SECTION 9 — TRIGGER FUNCTIONS
-- =============================================================================

-- ---------------------------------------------------------------------------
-- 9a. Extract plain_text from chapter content blocks
--     Handles block types: paragraph, heading (field: 'text')
--                          list              (field: 'items' TEXT[])
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION acad_fn_extract_plain_text()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_block     JSONB;
    v_parts     TEXT[] := '{}';
    v_item      JSONB;
BEGIN
    -- Only run when content actually changed
    IF TG_OP = 'UPDATE' AND NEW.content IS NOT DISTINCT FROM OLD.content THEN
        RETURN NEW;
    END IF;

    FOR v_block IN SELECT * FROM jsonb_array_elements(NEW.content -> 'blocks')
    LOOP
        CASE v_block ->> 'type'
            WHEN 'paragraph', 'heading' THEN
                IF v_block ? 'text' AND (v_block ->> 'text') IS NOT NULL THEN
                    v_parts := v_parts || (v_block ->> 'text');
                END IF;
            WHEN 'list' THEN
                IF v_block ? 'items' THEN
                    FOR v_item IN SELECT * FROM jsonb_array_elements(v_block -> 'items')
                    LOOP
                        v_parts := v_parts || (v_item #>> '{}');
                    END LOOP;
                END IF;
            ELSE
                -- Unknown block types are silently skipped
                NULL;
        END CASE;
    END LOOP;

    NEW.plain_text := array_to_string(v_parts, ' ');
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_acad_chapters_extract_plain_text
    BEFORE INSERT OR UPDATE OF content
    ON acad_chapters
    FOR EACH ROW
    EXECUTE FUNCTION acad_fn_extract_plain_text();


-- ---------------------------------------------------------------------------
-- 9b. Calculate reading_time_minutes from plain_text
--     Formula: ceil(word_count / 200), minimum 1
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION acad_fn_calc_reading_time()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_word_count INT;
BEGIN
    IF NEW.plain_text IS NULL OR NEW.plain_text = '' THEN
        NEW.reading_time_minutes := 1;
        RETURN NEW;
    END IF;

    -- array_length on string_to_array gives word count
    v_word_count := array_length(
        string_to_array(trim(NEW.plain_text), ' '),
        1
    );

    NEW.reading_time_minutes := GREATEST(1, ceil(v_word_count::NUMERIC / 200)::INT);
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_acad_chapters_reading_time
    BEFORE INSERT OR UPDATE OF plain_text
    ON acad_chapters
    FOR EACH ROW
    EXECUTE FUNCTION acad_fn_calc_reading_time();


-- ---------------------------------------------------------------------------
-- 9c. Chapter lifecycle: set published_at on approval; always stamp updated_at
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION acad_fn_chapter_lifecycle()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Stamp updated_at unconditionally
    NEW.updated_at := NOW();

    -- Set published_at the first time status moves to 'approved'
    IF NEW.status = 'approved' AND (OLD.status IS DISTINCT FROM 'approved') THEN
        NEW.published_at := NOW();
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_acad_chapters_lifecycle
    BEFORE UPDATE
    ON acad_chapters
    FOR EACH ROW
    EXECUTE FUNCTION acad_fn_chapter_lifecycle();


-- ---------------------------------------------------------------------------
-- 9d. Auto-set LTREE path and depth on comment INSERT
--     Root comment  → path = id with hyphens replaced by underscores
--     Child comment → path = parent.path || own_ltree_id
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION acad_fn_comment_path()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_own_label  TEXT;
    v_parent_row acad_comments%ROWTYPE;
BEGIN
    -- Produce a valid ltree label from the UUID (replace hyphens with underscores)
    v_own_label := replace(NEW.id::TEXT, '-', '_');

    IF NEW.parent_id IS NULL THEN
        -- Root-level comment
        NEW.path  := v_own_label::LTREE;
        NEW.depth := 0;
    ELSE
        SELECT * INTO v_parent_row
        FROM acad_comments
        WHERE id = NEW.parent_id;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'parent comment % does not exist', NEW.parent_id;
        END IF;

        IF v_parent_row.depth >= 5 THEN
            RAISE EXCEPTION 'maximum comment nesting depth (5) reached';
        END IF;

        NEW.path  := (v_parent_row.path::TEXT || '.' || v_own_label)::LTREE;
        NEW.depth := v_parent_row.depth + 1;
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_acad_comments_path
    BEFORE INSERT
    ON acad_comments
    FOR EACH ROW
    EXECUTE FUNCTION acad_fn_comment_path();


-- =============================================================================
-- SECTION 10 — ROW-LEVEL SECURITY
-- =============================================================================

-- ---------------------------------------------------------------------------
-- Helper functions — read session variables set by the application layer:
--   SET LOCAL app.current_user_id   = '<uuid>';
--   SET LOCAL app.current_user_role = 'author';
-- ---------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION acad_current_user_id()
RETURNS UUID
LANGUAGE sql
STABLE
AS $$
    SELECT nullif(current_setting('app.current_user_id', TRUE), '')::UUID;
$$;

CREATE OR REPLACE FUNCTION acad_current_user_role()
RETURNS acad_user_role
LANGUAGE sql
STABLE
AS $$
    SELECT nullif(current_setting('app.current_user_role', TRUE), '')::acad_user_role;
$$;

-- ---------------------------------------------------------------------------
-- Enable RLS
-- ---------------------------------------------------------------------------

ALTER TABLE acad_chapters  ENABLE ROW LEVEL SECURITY;
ALTER TABLE acad_comments  ENABLE ROW LEVEL SECURITY;
ALTER TABLE acad_profiles  ENABLE ROW LEVEL SECURITY;

-- Force RLS even for table owners (important for superuser connections that
-- represent the app service account)
ALTER TABLE acad_chapters  FORCE ROW LEVEL SECURITY;
ALTER TABLE acad_comments  FORCE ROW LEVEL SECURITY;
ALTER TABLE acad_profiles  FORCE ROW LEVEL SECURITY;

-- ---------------------------------------------------------------------------
-- acad_chapters policies
-- ---------------------------------------------------------------------------

-- SELECT: approved chapters, or own chapters, or moderator/admin
CREATE POLICY acad_chapters_select ON acad_chapters
    FOR SELECT
    USING (
        status = 'approved'
        OR author_id = acad_current_user_id()
        OR acad_current_user_role() IN ('moderator', 'admin')
    );

-- INSERT: author/moderator/admin; author_id must match the session user
CREATE POLICY acad_chapters_insert ON acad_chapters
    FOR INSERT
    WITH CHECK (
        acad_current_user_role() IN ('author', 'moderator', 'admin')
        AND author_id = acad_current_user_id()
    );

-- UPDATE: own draft chapters, or moderator/admin
CREATE POLICY acad_chapters_update ON acad_chapters
    FOR UPDATE
    USING (
        (author_id = acad_current_user_id() AND status = 'draft')
        OR acad_current_user_role() IN ('moderator', 'admin')
    );

-- DELETE: admin only
CREATE POLICY acad_chapters_delete ON acad_chapters
    FOR DELETE
    USING (
        acad_current_user_role() = 'admin'
    );

-- ---------------------------------------------------------------------------
-- acad_comments policies
-- ---------------------------------------------------------------------------

-- SELECT: non-deleted, or own, or moderator/admin
CREATE POLICY acad_comments_select ON acad_comments
    FOR SELECT
    USING (
        is_deleted = FALSE
        OR author_id = acad_current_user_id()
        OR acad_current_user_role() IN ('moderator', 'admin')
    );

-- INSERT: any authenticated user (acad_current_user_id() must not be null)
CREATE POLICY acad_comments_insert ON acad_comments
    FOR INSERT
    WITH CHECK (
        acad_current_user_id() IS NOT NULL
        AND author_id = acad_current_user_id()
    );

-- UPDATE: own comment within 15 minutes and not flagged, or moderator/admin
CREATE POLICY acad_comments_update ON acad_comments
    FOR UPDATE
    USING (
        (
            author_id = acad_current_user_id()
            AND created_at > NOW() - INTERVAL '15 minutes'
            AND is_flagged = FALSE
        )
        OR acad_current_user_role() IN ('moderator', 'admin')
    );

-- ---------------------------------------------------------------------------
-- acad_profiles policies
-- ---------------------------------------------------------------------------

-- SELECT: public profiles, or own, or moderator/admin
CREATE POLICY acad_profiles_select ON acad_profiles
    FOR SELECT
    USING (
        public_visibility = TRUE
        OR user_id = acad_current_user_id()
        OR acad_current_user_role() IN ('moderator', 'admin')
    );

-- UPDATE: own profile, or admin
CREATE POLICY acad_profiles_update ON acad_profiles
    FOR UPDATE
    USING (
        user_id = acad_current_user_id()
        OR acad_current_user_role() = 'admin'
    );


-- =============================================================================
-- SECTION 11 — VIEWS
-- =============================================================================

-- ---------------------------------------------------------------------------
-- 11a. acad_v_chapter_detail
--      Full chapter with subject, system, topic, author and moderator details
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW acad_v_chapter_detail AS
SELECT
    ch.id,
    ch.slug,
    ch.title,
    ch.content,
    ch.plain_text,
    ch.featured_image_url,
    ch.attachments,
    ch.chapter_references,
    ch.status,
    ch.version,
    ch.is_latest_version,
    ch.view_count,
    ch.reading_time_minutes,
    ch.submitted_at,
    ch.reviewed_at,
    ch.moderator_notes,
    ch.published_at,
    ch.created_at,
    ch.updated_at,

    -- Taxonomy
    sub.id          AS subject_id,
    sub.name        AS subject_name,
    sub.code        AS subject_code,

    sys.id          AS system_id,
    sys.name        AS system_name,

    top.id          AS topic_id,
    top.name        AS topic_name,

    -- Author
    ch.author_id,
    ap.full_name    AS author_full_name,
    ap.qualification AS author_qualification,
    ap.institution  AS author_institution,
    ap.profile_image_url AS author_image_url,

    -- Moderator (nullable)
    ch.reviewed_by  AS moderator_id,
    mp.full_name    AS moderator_full_name

FROM acad_chapters ch
JOIN acad_subjects   sub ON sub.id = ch.subject_id
JOIN acad_systems    sys ON sys.id = ch.system_id
JOIN acad_topics     top ON top.id = ch.topic_id
JOIN acad_profiles   ap  ON ap.user_id = ch.author_id
LEFT JOIN acad_profiles mp ON mp.user_id = ch.reviewed_by;


-- ---------------------------------------------------------------------------
-- 11b. acad_v_moderation_queue
--      Pending chapters in FIFO order with hours_in_queue
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW acad_v_moderation_queue AS
SELECT
    ch.id,
    ch.title,
    ch.slug,
    ch.submitted_at,
    EXTRACT(EPOCH FROM (NOW() - ch.submitted_at)) / 3600 AS hours_in_queue,

    sub.code        AS subject_code,
    sub.name        AS subject_name,
    sys.name        AS system_name,
    top.name        AS topic_name,

    ch.author_id,
    ap.full_name    AS author_full_name,
    ap.qualification AS author_qualification,
    ap.credentials_verified AS author_credentials_verified

FROM acad_chapters ch
JOIN acad_subjects  sub ON sub.id = ch.subject_id
JOIN acad_systems   sys ON sys.id = ch.system_id
JOIN acad_topics    top ON top.id = ch.topic_id
JOIN acad_profiles  ap  ON ap.user_id = ch.author_id
WHERE ch.status = 'pending'
ORDER BY ch.submitted_at ASC;  -- FIFO


-- ---------------------------------------------------------------------------
-- 11c. acad_v_author_stats
--      Per-author chapter counts and total views
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW acad_v_author_stats AS
SELECT
    u.id                                                    AS author_id,
    ap.full_name,
    ap.qualification,
    ap.institution,

    COUNT(*) FILTER (WHERE ch.status = 'approved')          AS chapters_published,
    COUNT(*) FILTER (WHERE ch.status = 'pending')           AS chapters_pending,
    COUNT(*) FILTER (WHERE ch.status = 'draft')             AS chapters_draft,
    COUNT(*) FILTER (WHERE ch.status = 'rejected')          AS chapters_rejected,
    COALESCE(SUM(ch.view_count) FILTER (WHERE ch.status = 'approved'), 0) AS total_views

FROM acad_users  u
JOIN acad_profiles ap ON ap.user_id = u.id
LEFT JOIN acad_chapters ch ON ch.author_id = u.id AND ch.is_latest_version = TRUE
WHERE u.role IN ('author', 'moderator', 'admin')
GROUP BY u.id, ap.full_name, ap.qualification, ap.institution;


-- =============================================================================
-- SECTION 12 — SEED DATA
-- =============================================================================

-- ---------------------------------------------------------------------------
-- 12a. Admin user
--      IMPORTANT: Replace the password_hash value before deploying to
--      production. Generate with: SELECT crypt('your-password', gen_salt('bf'));
-- ---------------------------------------------------------------------------
INSERT INTO acad_users (
    id, email, password_hash, role, is_verified, is_active
)
VALUES (
    gen_random_uuid(),
    'admin@pediaid.app',
    -- REPLACE BEFORE PRODUCTION: this is a bcrypt hash of 'changeme_immediately'
    '$2a$12$PLACEHOLDER.REPLACE.BEFORE.PRODUCTION.xxxxxxxxxxxxxx',
    'admin',
    TRUE,
    TRUE
)
ON CONFLICT (email) DO NOTHING;

-- ---------------------------------------------------------------------------
-- 12b. Admin profile
-- ---------------------------------------------------------------------------
INSERT INTO acad_profiles (user_id, full_name, credentials_verified, public_visibility)
SELECT id, 'PediAid Admin', TRUE, FALSE
FROM acad_users
WHERE email = 'admin@pediaid.app'
ON CONFLICT (user_id) DO NOTHING;

-- ---------------------------------------------------------------------------
-- 12c. Subject: Neonatology
-- ---------------------------------------------------------------------------
INSERT INTO acad_subjects (name, code, description, display_order, created_by)
SELECT
    'Neonatology',
    'NEO',
    'Clinical reference for neonatal and perinatal medicine',
    1,
    id
FROM acad_users
WHERE email = 'admin@pediaid.app'
ON CONFLICT (code) DO NOTHING;

-- ---------------------------------------------------------------------------
-- 12d. Systems under Neonatology
-- ---------------------------------------------------------------------------
INSERT INTO acad_systems (subject_id, name, display_order)
SELECT
    s.id,
    sys.name,
    sys.ord
FROM acad_subjects s
CROSS JOIN (
    VALUES
        ('Respiratory',        1),
        ('Cardiovascular',     2),
        ('Neurology',          3),
        ('Nutrition & GI',     4),
        ('Infections',         5),
        ('Haematology',        6),
        ('Pharmacology',       7),
        ('General & Metabolic',8)
) AS sys(name, ord)
WHERE s.code = 'NEO'
ON CONFLICT (subject_id, name) DO NOTHING;

-- ---------------------------------------------------------------------------
-- 12e. Topics under Respiratory
-- ---------------------------------------------------------------------------
INSERT INTO acad_topics (system_id, name, display_order)
SELECT
    sys.id,
    t.name,
    t.ord
FROM acad_systems sys
JOIN acad_subjects sub ON sub.id = sys.subject_id
CROSS JOIN (
    VALUES
        ('RDS',                        1),
        ('BPD',                        2),
        ('Pneumothorax',               3),
        ('Meconium Aspiration Syndrome',4),
        ('Apnea of Prematurity',        5),
        ('Pulmonary Hypertension',      6)
) AS t(name, ord)
WHERE sub.code = 'NEO'
  AND sys.name = 'Respiratory'
ON CONFLICT (system_id, name) DO NOTHING;

-- ---------------------------------------------------------------------------
-- 12f. Topics under Infections
-- ---------------------------------------------------------------------------
INSERT INTO acad_topics (system_id, name, display_order)
SELECT
    sys.id,
    t.name,
    t.ord
FROM acad_systems sys
JOIN acad_subjects sub ON sub.id = sys.subject_id
CROSS JOIN (
    VALUES
        ('Neonatal Sepsis',              1),
        ('Congenital Infections (TORCH)', 2),
        ('Neonatal Meningitis',          3)
) AS t(name, ord)
WHERE sub.code = 'NEO'
  AND sys.name = 'Infections'
ON CONFLICT (system_id, name) DO NOTHING;

-- ---------------------------------------------------------------------------
-- 12g. Topics under Neurology
-- ---------------------------------------------------------------------------
INSERT INTO acad_topics (system_id, name, display_order)
SELECT
    sys.id,
    t.name,
    t.ord
FROM acad_systems sys
JOIN acad_subjects sub ON sub.id = sys.subject_id
CROSS JOIN (
    VALUES
        ('HIE',               1),
        ('IVH',               2),
        ('Neonatal Seizures',  3)
) AS t(name, ord)
WHERE sub.code = 'NEO'
  AND sys.name = 'Neurology'
ON CONFLICT (system_id, name) DO NOTHING;


-- =============================================================================
-- END OF MIGRATION
-- =============================================================================

COMMIT;
