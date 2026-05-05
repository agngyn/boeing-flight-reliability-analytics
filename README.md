# boeing-flight-reliability-analytics
Uses BTS on‑time data Jan 2025 – Jan 2026, cross‑referenced with the FAA aircraft registry, to show U.S. Boeing operators’ reliability gaps, estimate their cost, and frame a $90M+ recurring services revenue pipeline for Boeing.

## Overview
This project analyzes U.S. flight on-time performance data to identify delay hotspots, understand major delay drivers, and validate the on-time KPI definition through a recalculation/audit workflow.

## Deliverables
- Exploratory analysis (EDA) with key insights and recommendations
- End-to-end KPI pipeline using SQL + Python
- A 2-page Power BI dashboard (executive overview + drilldowns)
- A KPI audit that rebuilds the "on-time" metric and documents edge cases (cancellations/diversions)
- One-page executive brief (PDF) summarizing results and recommendations

## Repo Structure
- `data/`: raw files (ignored) + processed datasets + data dictionary
- `sql/`: schema, cleaning steps, KPI queries, validation checks
- `notebooks/`: EDA, feature engineering, KPI audit notebooks
- `powerbi/`: dashboard file + screenshots
- `reports/`: one-page PDF brief
- `docs/`: metric definition log + assumptions/limitations

## KPI Definitions (high level)
- On-time arrival: arrival delay ≤ 15 minutes (definition documented in `/docs/metric_definition_log.md`)
- Delay minutes: summarized with median and P90 to capture "typical" vs "worst-case" delays
- Cancellations/diversions: handled explicitly in the KPI audit so the on-time rate is comparable and reproducible

## Status
Work in progress — starting with data cleaning + KPI definition log.
