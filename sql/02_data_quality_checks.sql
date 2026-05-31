-- 02_data_quality_checks.sql
-- Basic validation checks.

SELECT COUNT(*) AS total_rows FROM operations;

SELECT
    SUM(CASE WHEN operation_id IS NULL THEN 1 ELSE 0 END) AS missing_operation_id,
    SUM(CASE WHEN country IS NULL OR country = '' THEN 1 ELSE 0 END) AS missing_country,
    SUM(CASE WHEN shipment_mode IS NULL OR shipment_mode = '' THEN 1 ELSE 0 END) AS missing_shipment_mode,
    SUM(CASE WHEN failed IS NULL THEN 1 ELSE 0 END) AS missing_failed,
    SUM(CASE WHEN loss_usd IS NULL THEN 1 ELSE 0 END) AS missing_loss
FROM operations;

SELECT
    MIN(load_factor) AS min_load_factor,
    MAX(load_factor) AS max_load_factor,
    MIN(delay_hours) AS min_delay_hours,
    MAX(delay_hours) AS max_delay_hours,
    MIN(failure_probability) AS min_failure_probability,
    MAX(failure_probability) AS max_failure_probability
FROM operations;

SELECT operation_id, COUNT(*) AS duplicate_count
FROM operations
GROUP BY operation_id
HAVING COUNT(*) > 1;