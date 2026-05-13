-- Trial Quality Intelligence Platform initial PostgreSQL schema draft
-- This file is a production-migration starting point. The current Streamlit apps still default to SQLite.

CREATE TABLE IF NOT EXISTS companies (
    id SERIAL PRIMARY KEY,
    company_name TEXT UNIQUE NOT NULL,
    company_type TEXT,
    contact_person TEXT,
    contact_phone TEXT,
    status TEXT DEFAULT '启用',
    created_at TEXT
);

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role TEXT,
    display_name TEXT,
    status TEXT DEFAULT '启用',
    created_at TEXT
);

CREATE TABLE IF NOT EXISTS projects (
    id SERIAL PRIMARY KEY,
    project_name TEXT NOT NULL,
    sponsor_name TEXT,
    protocol_no TEXT,
    indication TEXT,
    phase TEXT,
    planned_subjects INTEGER DEFAULT 0,
    actual_subjects INTEGER DEFAULT 0,
    site_count INTEGER DEFAULT 0,
    pm_name TEXT,
    qa_name TEXT,
    cro_name TEXT,
    smo_name TEXT,
    expected_inspection_date TEXT,
    project_status TEXT DEFAULT '进行中',
    created_at TEXT,
    updated_at TEXT
);

CREATE TABLE IF NOT EXISTS project_company_map (
    id SERIAL PRIMARY KEY,
    project_id INTEGER UNIQUE REFERENCES projects(id),
    company_id INTEGER REFERENCES companies(id),
    created_at TEXT,
    updated_at TEXT
);

CREATE TABLE IF NOT EXISTS findings (
    id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(id),
    site_no TEXT,
    site_name TEXT,
    subject_no TEXT,
    category TEXT,
    severity TEXT,
    description TEXT,
    basis TEXT,
    capa TEXT,
    capa_status TEXT,
    risk_score INTEGER,
    risk_level TEXT,
    ai_suggestion TEXT,
    evidence_gap TEXT,
    fingerprint TEXT UNIQUE,
    created_at TEXT
);

CREATE TABLE IF NOT EXISTS tasks (
    id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(id),
    task_name TEXT,
    priority TEXT,
    owner TEXT,
    due_date TEXT,
    status TEXT DEFAULT '未开始',
    source TEXT,
    created_at TEXT
);

CREATE TABLE IF NOT EXISTS review_queue (
    id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(id),
    item_type TEXT,
    item_id INTEGER,
    title TEXT,
    risk_level TEXT,
    review_status TEXT DEFAULT '待复核',
    reviewer TEXT,
    review_comment TEXT,
    created_at TEXT,
    updated_at TEXT
);

CREATE TABLE IF NOT EXISTS ai_extractions (
    id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(id),
    file_id INTEGER,
    extraction_type TEXT,
    source_name TEXT,
    raw_result TEXT,
    structured_json TEXT,
    review_status TEXT DEFAULT '待复核',
    reviewer TEXT,
    review_comment TEXT,
    created_by TEXT,
    created_at TEXT,
    updated_at TEXT
);

CREATE TABLE IF NOT EXISTS mapped_fields (
    id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(id),
    extraction_id INTEGER REFERENCES ai_extractions(id),
    field_group TEXT,
    field_name TEXT,
    field_value TEXT,
    source_name TEXT,
    review_status TEXT DEFAULT '待复核',
    created_at TEXT
);

CREATE TABLE IF NOT EXISTS template_center (
    id SERIAL PRIMARY KEY,
    template_name TEXT UNIQUE,
    template_type TEXT,
    description TEXT,
    status TEXT DEFAULT '启用',
    created_at TEXT
);

CREATE TABLE IF NOT EXISTS template_files (
    id SERIAL PRIMARY KEY,
    template_id INTEGER REFERENCES template_center(id),
    template_name TEXT,
    file_name TEXT,
    file_type TEXT,
    file_path TEXT,
    version_no TEXT,
    status TEXT DEFAULT '启用',
    uploaded_by TEXT,
    created_at TEXT
);

CREATE TABLE IF NOT EXISTS icf_checks (
    id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(id),
    site_no TEXT,
    site_name TEXT,
    subject_no TEXT,
    icf_version TEXT,
    irb_approval_date TEXT,
    effective_date TEXT,
    signed_date TEXT,
    screening_date TEXT,
    issue TEXT,
    risk_level TEXT,
    created_at TEXT
);

CREATE TABLE IF NOT EXISTS sae_checks (
    id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(id),
    site_no TEXT,
    site_name TEXT,
    subject_no TEXT,
    sae_event TEXT,
    aware_date TEXT,
    report_date TEXT,
    followup_status TEXT,
    medical_assessment TEXT,
    report_hours REAL,
    issue TEXT,
    risk_level TEXT,
    created_at TEXT
);

CREATE TABLE IF NOT EXISTS center_file_scores (
    id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(id),
    site_no TEXT,
    site_name TEXT,
    domain TEXT,
    status TEXT,
    score INTEGER,
    comment TEXT,
    created_at TEXT
);

CREATE TABLE IF NOT EXISTS audit_logs (
    id SERIAL PRIMARY KEY,
    username TEXT,
    action TEXT,
    target TEXT,
    detail TEXT,
    created_at TEXT
);
