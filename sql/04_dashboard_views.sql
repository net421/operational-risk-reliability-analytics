DROP VIEW IF EXISTS vw_mode_risk_summary;
CREATE VIEW vw_mode_risk_summary AS
SELECT
  shipment_mode,
  COUNT(*) AS total_operations,
  ROUND(100.0 * AVG(failed), 2) AS failure_rate_pct,
  ROUND(SUM(loss_usd), 2) AS total_loss_usd,
  ROUND(AVG(loss_usd), 2) AS avg_loss_usd,
  ROUND(AVG(delay_hours), 2) AS avg_delay_hours,
  ROUND(AVG(load_factor), 3) AS avg_load_factor
FROM operations
GROUP BY shipment_mode;

DROP VIEW IF EXISTS vw_country_risk_summary;
CREATE VIEW vw_country_risk_summary AS
SELECT
  country,
  region,
  COUNT(*) AS total_operations,
  ROUND(100.0 * AVG(failed), 2) AS failure_rate_pct,
  ROUND(SUM(loss_usd), 2) AS total_loss_usd,
  ROUND(AVG(cost_usd), 2) AS avg_cost_usd
FROM operations
GROUP BY country, region;

DROP VIEW IF EXISTS vw_load_band_risk;
CREATE VIEW vw_load_band_risk AS
SELECT
  load_band,
  COUNT(*) AS total_operations,
  ROUND(100.0 * AVG(failed), 2) AS failure_rate_pct,
  ROUND(SUM(loss_usd), 2) AS total_loss_usd,
  ROUND(AVG(delay_hours), 2) AS avg_delay_hours
FROM operations
GROUP BY load_band;

DROP VIEW IF EXISTS vw_delay_band_risk;
CREATE VIEW vw_delay_band_risk AS
SELECT
  delay_band,
  COUNT(*) AS total_operations,
  ROUND(100.0 * AVG(failed), 2) AS failure_rate_pct,
  ROUND(SUM(loss_usd), 2) AS total_loss_usd,
  ROUND(AVG(load_factor), 3) AS avg_load_factor
FROM operations
GROUP BY delay_band;