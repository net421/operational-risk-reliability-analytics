"""
Operational Risk & Reliability Analytics
Generate a simulated operational risk dataset and SQLite database.

Run:
    python scripts/generate_dataset.py

Outputs:
    data/raw/operations_simulated.csv
    data/processed/operations_clean.csv
    database/operational_risk.db
"""
from pathlib import Path
import re
import sqlite3
import numpy as np
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw" / "operations_simulated.csv"
PROCESSED = ROOT / "data" / "processed" / "operations_clean.csv"
DB = ROOT / "database" / "operational_risk.db"

rng = np.random.default_rng(421)
n = 100_000

countries = np.array(["Mexico","USA","Canada","Brazil","Colombia","Chile","Germany","Netherlands","China","India","South Africa","Nigeria"])
modes = np.array(["Truck","Air","Ocean","Rail"])
operation_types = np.array(["Standard Shipment","Cold Chain","Hazardous Goods","High Value Cargo","Emergency Replenishment"])
weather = np.array(["Clear","Rain","Storm","Extreme Heat","Cold"])
shifts = np.array(["Morning","Evening","Night"])
vendor_tiers = np.array(["Tier 1","Tier 2","Tier 3"])
country_region = {
    "Mexico":"North America", "USA":"North America", "Canada":"North America",
    "Brazil":"Latin America","Colombia":"Latin America","Chile":"Latin America",
    "Germany":"Europe","Netherlands":"Europe",
    "China":"Asia","India":"Asia",
    "South Africa":"Africa","Nigeria":"Africa"
}

country = rng.choice(countries, n, p=[.12,.10,.05,.08,.08,.05,.06,.04,.12,.12,.08,.10])
region = np.array([country_region[c] for c in country])
mode = rng.choice(modes, n, p=[.48,.25,.20,.07])
op_type = rng.choice(operation_types, n, p=[.55,.18,.08,.14,.05])
weather_state = rng.choice(weather, n, p=[.62,.18,.06,.09,.05])
shift = rng.choice(shifts, n, p=[.48,.32,.20])
vendor_tier = rng.choice(vendor_tiers, n, p=[.45,.38,.17])

distance_km = np.round(rng.gamma(shape=2.1, scale=650, size=n) + rng.normal(0,80,n), 1)
distance_km = np.clip(distance_km, 30, 9000)
load_factor = np.clip(rng.beta(5,2,size=n) + rng.normal(0,0.05,n), 0.25, 1.15)
operator_experience_years = np.round(np.clip(rng.gamma(2.2, 2.0, n), .1, 25),1)
maintenance_score = np.round(np.clip(rng.normal(82, 12, n), 30, 100),1)

map_mode_delay = pd.Series(mode).map({"Truck":9,"Air":5,"Ocean":18,"Rail":11}).to_numpy()
map_weather_delay = pd.Series(weather_state).map({"Clear":0,"Rain":5,"Storm":18,"Extreme Heat":7,"Cold":4}).to_numpy()
delay_hours = np.round(np.clip(
    map_mode_delay + map_weather_delay + np.maximum(load_factor-0.75,0)*35
    + np.maximum(3-operator_experience_years,0)*2.2 + rng.gamma(1.6, 4.0, n) + rng.normal(0,3,n),
    0, 240
),1)

def score(arr, mapping):
    return pd.Series(arr).map(mapping).to_numpy()

mode_cost_rate = score(mode, {"Truck":1.2,"Air":5.8,"Ocean":0.55,"Rail":0.8})
type_multiplier = score(op_type, {"Standard Shipment":1.0,"Cold Chain":1.7,"Hazardous Goods":1.9,"High Value Cargo":1.6,"Emergency Replenishment":2.6})
cost_usd = np.round((350 + distance_km*mode_cost_rate*type_multiplier + load_factor*900 + delay_hours*9 + rng.normal(0,250,n)).clip(100),2)

z = (
    -5.1
    + 3.1*np.maximum(load_factor-0.78,0)
    + 0.018*delay_hours
    - 0.055*operator_experience_years
    - 0.025*(maintenance_score-80)
    + score(weather_state, {"Clear":0,"Rain":0.28,"Storm":0.95,"Extreme Heat":0.55,"Cold":0.35})
    + score(mode, {"Truck":0.22,"Air":0.05,"Ocean":0.45,"Rail":0.16})
    + score(op_type, {"Standard Shipment":0,"Cold Chain":0.48,"Hazardous Goods":0.65,"High Value Cargo":0.25,"Emergency Replenishment":0.75})
    + score(shift, {"Morning":0,"Evening":0.12,"Night":0.32})
    + score(vendor_tier, {"Tier 1":0,"Tier 2":0.28,"Tier 3":0.72})
)
failure_probability = 1/(1+np.exp(-z))
failed = rng.binomial(1, failure_probability)

sev_score = failed * (
    0.6 + 0.015*delay_hours + 0.00012*cost_usd
    + score(op_type, {"Standard Shipment":0,"Cold Chain":0.5,"Hazardous Goods":0.7,"High Value Cargo":0.4,"Emergency Replenishment":0.55})
    + rng.normal(0,.4,n)
)
severity = np.where(failed==0, "None", np.where(sev_score<1.6, "Low", np.where(sev_score<2.8, "Medium", "High")))
loss_usd = np.where(failed==1, np.round(cost_usd*(rng.uniform(.08,.35,n) + (severity=="Medium")*.25 + (severity=="High")*.65),2), 0)

load_band = pd.cut(load_factor, bins=[0,.6,.75,.9,1.15], labels=["Low","Moderate","High","Critical"], include_lowest=True).astype(str)
delay_band = pd.cut(delay_hours, bins=[-1,12,24,48,240], labels=["0-12h","12-24h","24-48h","48h+"], include_lowest=True).astype(str)
experience_band = pd.cut(operator_experience_years, bins=[0,2,5,10,100], labels=["0-2y","2-5y","5-10y","10y+"], include_lowest=True).astype(str)

df = pd.DataFrame({
    "operation_id": np.arange(1,n+1),
    "operation_date": pd.date_range("2024-01-01", periods=n, freq="h").date.astype(str),
    "region": region,
    "country": country,
    "shipment_mode": mode,
    "operation_type": op_type,
    "weather_condition": weather_state,
    "shift": shift,
    "vendor_tier": vendor_tier,
    "distance_km": distance_km,
    "load_factor": np.round(load_factor,3),
    "load_band": load_band,
    "delay_hours": delay_hours,
    "delay_band": delay_band,
    "operator_experience_years": operator_experience_years,
    "experience_band": experience_band,
    "maintenance_score": maintenance_score,
    "cost_usd": cost_usd,
    "failure_probability": np.round(failure_probability,4),
    "failed": failed,
    "severity": severity,
    "loss_usd": loss_usd
})

RAW.parent.mkdir(parents=True, exist_ok=True)
PROCESSED.parent.mkdir(parents=True, exist_ok=True)
DB.parent.mkdir(parents=True, exist_ok=True)

df.to_csv(RAW, index=False)
df.to_csv(PROCESSED, index=False)

conn = sqlite3.connect(DB)
df.to_sql("operations", conn, if_exists="replace", index=False)
views_sql = (ROOT / "sql" / "04_dashboard_views.sql").read_text(encoding="utf-8")
conn.executescript(views_sql)
conn.commit()
conn.close()

print(f"Rows generated: {len(df):,}")
print(f"CSV: {PROCESSED}")
print(f"SQLite DB: {DB}")
print(f"Failure rate: {df['failed'].mean()*100:.2f}%")
print(f"Total expected loss: ${df['loss_usd'].sum():,.2f}")
