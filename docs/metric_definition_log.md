# Metric Definition Log — Boeing Flight Reliability Analytics

## Purpose
This document defines every KPI used in the analysis and dashboard so results are reproducible.

## Dataset
- Source: BTS TranStats — On-Time: Reporting Carrier On-Time Performance (1987–present)
- Time range: 2024-01-01 to 2024-12-31
- Unit of analysis: 1 row = 1 flight

---

## Core KPIs

### 1) On-time arrival rate
**Definition (base):**
- A flight is "on-time" if `arrival_delay_minutes <= 15`.

**Inclusions / exclusions:**
- Cancelled flights: [exclude from denominator] / [include separately]
- Diverted flights: [exclude from denominator] / [include separately]
- Missing arrival delay: [exclude] / [treat as not on-time] (choose one)

**Formula:**
`on_time_rate = on_time_flights / eligible_flights`

Where:
- eligible_flights = flights where Cancelled = 0 AND Diverted = 0 AND ArrDelayMinutes IS NOT NULL
- on_time_flights  = eligible_flights where ArrDelayMinutes <= 15


### 2) Delay minutes (arrival)
- `arrival_delay_minutes` summary stats: median, P90, mean
- Outlier handling: cap charts at [e.g., 180 minutes] for readability (do not change underlying data)

### 3) Cancellation rate
`cancellation_rate = cancelled_flights / total_scheduled_flights`

### 4) Diversion rate
`diversion_rate = diverted_flights / total_scheduled_flights`

### 5) Delay contribution (for hotspots)
**Definition:**
`total_delay_minutes = sum(max(arrival_delay_minutes, 0))` by airport/carrier/month
(negative delays do not reduce total delay minutes)

---

## Notes / Decisions
- Timezone handling:
- Any filters (e.g., domestic only):
- Any known limitations:
