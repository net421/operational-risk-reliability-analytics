-- 01_schema.sql
-- Operational Risk & Reliability Analytics

DROP TABLE IF EXISTS operations;

CREATE TABLE operations (
    operation_id INTEGER,
    operation_date TEXT,
    region TEXT,
    country TEXT,
    shipment_mode TEXT,
    operation_type TEXT,
    weather_condition TEXT,
    shift TEXT,
    vendor_tier TEXT,
    distance_km REAL,
    load_factor REAL,
    load_band TEXT,
    delay_hours REAL,
    delay_band TEXT,
    operator_experience_years REAL,
    experience_band TEXT,
    maintenance_score REAL,
    cost_usd REAL,
    failure_probability REAL,
    failed INTEGER,
    severity TEXT,
    loss_usd REAL
);