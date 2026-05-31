# Operational Risk & Reliability Analytics

End-to-end analytics project using **Python, SQLite, SQL, and Power BI** to model operational risk, reliability, failure probability, and loss exposure.

## Project Purpose

This project simulates 100,000 operational scenarios and analyzes which conditions are associated with higher failure rates and expected losses. It is designed as a portfolio project for roles such as Data Analyst, Operations Analyst, Risk Analyst, Supply Chain Analyst, and Business Analyst.

Hands-on analytics projects are frequently recommended for demonstrating real applied skills in SQL, Python, Power BI, storytelling, and portfolio readiness. citeturn149699search4

## Tools

- Python
- Pandas / NumPy
- SQLite
- SQL
- Power BI
- GitHub

## Dataset

The dataset is generated with Python.

Rows: **100,000**

Main table:

```text
operations
```

Main columns:

- operation_id
- country
- region
- shipment_mode
- operation_type
- weather_condition
- vendor_tier
- distance_km
- load_factor
- delay_hours
- operator_experience_years
- maintenance_score
- cost_usd
- failure_probability
- failed
- severity
- loss_usd

## Business Questions

1. Which shipment modes have the highest failure rate?
2. Which load conditions generate the highest reliability risk?
3. How does delay severity affect operational failure?
4. Which countries or regions create the largest loss exposure?
5. Which operation types are associated with higher severity?
6. Which risk conditions should management prioritize?

## Project Workflow

```text
Python
→ simulated operational data
→ CSV dataset
→ SQLite database
→ SQL analysis
→ Power BI dashboard
→ business recommendations
```

## Initial Dataset Metrics

- Total operations: **100,000**
- Failure rate: **2.42%**
- Total loss exposure: **$6,716,769.77**
- Average delay: **21.91 hours**
- Average load factor: **0.715**

## Power BI Dashboard Plan

### Page 1 — Executive Risk Overview

Cards:
- Total Operations
- Failure Rate
- Total Loss
- Average Delay

Charts:
- Failure Rate by Shipment Mode
- Total Loss by Country

### Page 2 — Reliability Drivers

Charts:
- Failure Rate by Load Band
- Failure Rate by Delay Band
- Failure Rate by Weather Condition
- Failure Rate by Vendor Tier

### Page 3 — Risk Exposure

Charts:
- Total Loss by Operation Type
- Severity Distribution
- High-Risk Operations Table
- Failure Rate by Experience Band

## SQL Analysis Included

- Executive summary
- Failure rate by mode
- Failure rate by load band
- Failure rate by delay band
- Country-level risk exposure
- Severity distribution
- Combined load-delay risk
- Operator experience analysis
- High-risk operation ranking

## Repository Structure

```text
operational-risk-reliability-analytics/
├── data/
│   ├── raw/
│   └── processed/
├── database/
├── scripts/
├── sql/
├── powerbi/
├── screenshots/
└── docs/
```

## How to Rebuild the Dataset

```bash
pip install -r requirements.txt
python scripts/generate_dataset.py
```

## Portfolio Positioning

This project demonstrates:

- Python-based data generation
- Risk simulation
- SQL aggregation and KPI analysis
- SQLite database workflow
- Power BI dashboard planning
- Operational reliability analysis
- Business insight generation
