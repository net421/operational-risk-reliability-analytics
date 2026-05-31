-- 03_kpi_queries.sql
-- Core analytical queries for operational risk and reliability.

-- 1. Executive risk summary.
SELECT
    COUNT(*) AS total_operations,
    ROUND(100.0 * AVG(failed), 2) AS failure_rate_pct,
    ROUND(SUM(loss_usd), 2) AS total_loss_usd,
    ROUND(AVG(cost_usd), 2) AS avg_operation_cost,
    ROUND(AVG(delay_hours), 2) AS avg_delay_hours,
    ROUND(AVG(load_factor), 3) AS avg_load_factor
FROM operations;

-- 2. Failure rate by shipment mode.
SELECT
    shipment_mode,
    COUNT(*) AS total_operations,
    ROUND(100.0 * AVG(failed), 2) AS failure_rate_pct,
    ROUND(SUM(loss_usd), 2) AS total_loss_usd,
    ROUND(AVG(delay_hours), 2) AS avg_delay_hours,
    ROUND(AVG(load_factor), 3) AS avg_load_factor
FROM operations
GROUP BY shipment_mode
ORDER BY failure_rate_pct DESC;

-- 3. Failure rate by load band.
SELECT
    load_band,
    COUNT(*) AS total_operations,
    ROUND(100.0 * AVG(failed), 2) AS failure_rate_pct,
    ROUND(SUM(loss_usd), 2) AS total_loss_usd,
    ROUND(AVG(delay_hours), 2) AS avg_delay_hours
FROM operations
GROUP BY load_band
ORDER BY failure_rate_pct DESC;

-- 4. Failure rate by delay band.
SELECT
    delay_band,
    COUNT(*) AS total_operations,
    ROUND(100.0 * AVG(failed), 2) AS failure_rate_pct,
    ROUND(SUM(loss_usd), 2) AS total_loss_usd,
    ROUND(AVG(load_factor), 3) AS avg_load_factor
FROM operations
GROUP BY delay_band
ORDER BY failure_rate_pct DESC;

-- 5. Risk by operation type.
SELECT
    operation_type,
    COUNT(*) AS total_operations,
    ROUND(100.0 * AVG(failed), 2) AS failure_rate_pct,
    ROUND(SUM(loss_usd), 2) AS total_loss_usd,
    ROUND(AVG(cost_usd), 2) AS avg_cost_usd
FROM operations
GROUP BY operation_type
ORDER BY failure_rate_pct DESC;

-- 6. Risk by weather condition.
SELECT
    weather_condition,
    COUNT(*) AS total_operations,
    ROUND(100.0 * AVG(failed), 2) AS failure_rate_pct,
    ROUND(SUM(loss_usd), 2) AS total_loss_usd,
    ROUND(AVG(delay_hours), 2) AS avg_delay_hours
FROM operations
GROUP BY weather_condition
ORDER BY failure_rate_pct DESC;

-- 7. Risk by vendor tier.
SELECT
    vendor_tier,
    COUNT(*) AS total_operations,
    ROUND(100.0 * AVG(failed), 2) AS failure_rate_pct,
    ROUND(SUM(loss_usd), 2) AS total_loss_usd
FROM operations
GROUP BY vendor_tier
ORDER BY failure_rate_pct DESC;

-- 8. Country-level risk exposure.
SELECT
    country,
    region,
    COUNT(*) AS total_operations,
    ROUND(100.0 * AVG(failed), 2) AS failure_rate_pct,
    ROUND(SUM(loss_usd), 2) AS total_loss_usd,
    ROUND(AVG(cost_usd), 2) AS avg_cost_usd
FROM operations
GROUP BY country, region
ORDER BY total_loss_usd DESC
LIMIT 15;

-- 9. Severity distribution.
SELECT
    severity,
    COUNT(*) AS total_operations,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM operations), 2) AS share_pct,
    ROUND(SUM(loss_usd), 2) AS total_loss_usd
FROM operations
GROUP BY severity
ORDER BY total_loss_usd DESC;

-- 10. Combined risk: load band + delay band.
SELECT
    load_band,
    delay_band,
    COUNT(*) AS total_operations,
    ROUND(100.0 * AVG(failed), 2) AS failure_rate_pct,
    ROUND(SUM(loss_usd), 2) AS total_loss_usd
FROM operations
GROUP BY load_band, delay_band
ORDER BY failure_rate_pct DESC;

-- 11. Operator experience and failure.
SELECT
    experience_band,
    COUNT(*) AS total_operations,
    ROUND(100.0 * AVG(failed), 2) AS failure_rate_pct,
    ROUND(AVG(maintenance_score), 2) AS avg_maintenance_score,
    ROUND(SUM(loss_usd), 2) AS total_loss_usd
FROM operations
GROUP BY experience_band
ORDER BY failure_rate_pct DESC;

-- 12. Top high-risk individual operations.
SELECT
    operation_id,
    country,
    shipment_mode,
    operation_type,
    load_factor,
    delay_hours,
    maintenance_score,
    failure_probability,
    failed,
    severity,
    loss_usd
FROM operations
ORDER BY failure_probability DESC
LIMIT 25;