-- Timer Discrepancies tables (Google Form responses)
-- Source: Google Form → Google Sheets → Drive API CSV export
-- Spreadsheet: YOUR_GOOGLE_ID

-- Raw table: stores each row as JSONB
CREATE TABLE IF NOT EXISTS data_raw.raw_timer_discrepancies (
    id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    run_id          TEXT NOT NULL,
    row_number      INT NOT NULL,          -- 1-based row from spreadsheet
    data            JSONB NOT NULL,         -- full row as {header: value}
    loaded_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_raw_timer_discrepancies_run_id
    ON data_raw.raw_timer_discrepancies (run_id);

-- Staging table: parsed columns from form responses
CREATE TABLE IF NOT EXISTS data_staging.stg_timer_discrepancies (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    submission_timestamp    TIMESTAMPTZ NOT NULL,
    email_address           TEXT,           -- Google account email
    internal_email             TEXT,           -- self-reported Internal email
    shift_schedule          TEXT,           -- Dayshift / Nightshift
    discrepancy_date        DATE,           -- when the error occurred
    asset_name              TEXT,           -- asset where error occurred
    task_name               TEXT,           -- task where error occurred
    correct_duration_minutes INT,           -- correct duration in minutes
    description             TEXT,           -- free text description
    row_number              INT NOT NULL,   -- 1-based row from spreadsheet
    run_id                  TEXT NOT NULL,
    loaded_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_stg_timer_discrepancies_row UNIQUE (row_number)
);

CREATE INDEX IF NOT EXISTS idx_stg_timer_discrepancies_timestamp
    ON data_staging.stg_timer_discrepancies (submission_timestamp);

CREATE INDEX IF NOT EXISTS idx_stg_timer_discrepancies_internal_email
    ON data_staging.stg_timer_discrepancies (internal_email);

CREATE INDEX IF NOT EXISTS idx_stg_timer_discrepancies_date
    ON data_staging.stg_timer_discrepancies (discrepancy_date);
