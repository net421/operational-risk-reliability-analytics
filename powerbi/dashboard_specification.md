# Power BI Dashboard Specification

Use:

```text
data/processed/operations_clean.csv
```

or connect to:

```text
database/operational_risk.db
```

## Page 1 — Executive Risk Overview

### Cards

1. Total Operations
   - Visual: Card
   - Field: operation_id
   - Aggregation: Count

2. Failure Rate
   - Visual: Card
   - Field: failed
   - Aggregation: Average
   - Format as percentage

3. Total Loss
   - Visual: Card
   - Field: loss_usd
   - Aggregation: Sum

4. Average Delay
   - Visual: Card
   - Field: delay_hours
   - Aggregation: Average

### Charts

1. Failure Rate by Shipment Mode
   - Visual: Clustered Bar Chart
   - Y-axis: shipment_mode
   - X-axis: failed
   - Aggregation: Average
   - Format as percentage

2. Total Loss by Country
   - Visual: Clustered Bar Chart
   - Y-axis: country
   - X-axis: loss_usd
   - Aggregation: Sum
   - Top N: 10

## Page 2 — Reliability Drivers

1. Failure Rate by Load Band
   - Visual: Clustered Bar Chart
   - Y-axis: load_band
   - X-axis: failed
   - Aggregation: Average

2. Failure Rate by Delay Band
   - Visual: Clustered Bar Chart
   - Y-axis: delay_band
   - X-axis: failed
   - Aggregation: Average

3. Failure Rate by Weather Condition
   - Visual: Clustered Bar Chart
   - Y-axis: weather_condition
   - X-axis: failed
   - Aggregation: Average

4. Failure Rate by Vendor Tier
   - Visual: Clustered Bar Chart
   - Y-axis: vendor_tier
   - X-axis: failed
   - Aggregation: Average

## Page 3 — Risk Exposure

1. Total Loss by Operation Type
   - Visual: Clustered Bar Chart
   - Y-axis: operation_type
   - X-axis: loss_usd
   - Aggregation: Sum

2. Severity Distribution
   - Visual: Treemap or Donut Chart
   - Group/Legend: severity
   - Values: operation_id
   - Aggregation: Count

3. Failure Rate by Experience Band
   - Visual: Clustered Bar Chart
   - Y-axis: experience_band
   - X-axis: failed
   - Aggregation: Average

4. High-Risk Operations
   - Visual: Table
   - Fields:
     - operation_id
     - country
     - shipment_mode
     - operation_type
     - load_factor
     - delay_hours
     - failure_probability
     - severity
     - loss_usd
   - Sort by failure_probability descending