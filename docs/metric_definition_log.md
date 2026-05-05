# Metric Definition Log — Boeing Flight Reliability Analytics

## Purpose

This document defines every KPI used in the analysis and dashboard so results are reproducible.

## Dataset

- Source: BTS TranStats — Reporting Carrier On-Time Performance  
- Time range: 2025-01-01 to 2026-01-31  
- Unit of analysis: 1 row = 1 flight (domestic U.S. scheduled passenger flights)  
- Enrichment: FAA Aircraft Registry cross-referenced via tail number to add manufacturer, model, aircraft family, and vintage.

---

## Core KPIs

### 1) On-time arrival rate

**Definition (DOT standard):**  
A flight is **on-time** if `ArrDelay` ≤ 15 minutes, the flight is not cancelled, and the flight is not diverted.

**Inclusions / exclusions (final decisions):**  
- **Cancelled flights** → excluded from the on‑time denominator because no arrival time exists. They are measured separately via the cancellation rate.  
- **Diverted flights** → excluded from the on‑time denominator for the same reason; tracked via the diversion rate.  
- **Missing arrival delay** → treated as missing; excluded from both numerator and denominator of the on‑time rate. (These are extremely rare in BTS data for non‑cancelled flights.)

**Formula:**  
`on_time_rate = on_time_flights / eligible_flights`  

Where:  
- `eligible_flights = flights WHERE Cancelled = 0 AND Diverted = 0 AND ArrDelay IS NOT NULL`  
- `on_time_flights = eligible_flights WHERE ArrDelay <= 15`

**Rationale:**  
This matches the U.S. Department of Transportation’s public reporting standard, ensuring comparability. By removing cancelled and diverted flights from the on‑time calculation and tracking them separately, the metric cleanly reflects operational punctuality.

---

### 2) Delay minutes (arrival)

- `ArrDelay` (in minutes) is summarized using **median**, **P90**, and **mean** across the eligible (non‑cancelled, non‑diverted) flights.  
- Negative arrival delays (early arrivals) are kept as is in the underlying data; for charts they are included.  
- Outlier handling: visualisations may cap the scale (e.g., at 180 minutes) for readability, but the underlying data is never changed.

---

### 3) Cancellation rate

**Definition:**  
`cancellation_rate = COUNT(Cancelled = 1) / COUNT(*)`  
All scheduled flights are in the denominator. Cancelled flights have no arrival delay and are excluded from the on‑time rate but included here.

---

### 4) Diversion rate

**Definition:**  
`diversion_rate = COUNT(Diverted = 1) / COUNT(*)`  
Diverted flights are handled identically to cancellations for the on‑time metric.

---

### 5) Delay contribution (for hotspots)

**Definition:**  
`total_delay_minutes = SUM( GREATEST(ArrDelay, 0) )` grouped by airport, carrier, month, or route.  
Negative delays (early arrivals) do not offset positive delays; they are set to zero for contribution aggregation to avoid masking real delays.

---

## Notes / Decisions

- **Timezone handling:** All times are local to the departure/arrival airport, which is the BTS standard. No timezone conversion is applied; delays are calculated locally and directly from the scheduled vs. actual times.  
- **Domestic‑only filter:** The analysis is restricted to flights where both OriginAirportID and DestAirportID are within the 50 U.S. states (using a reference list).  
- **Tail number matching:** FAA lookup is case‑insensitive and trimmed. Unmatched tail numbers (e.g., foreign‑registered aircraft) are tagged as `OEM = 'Other'` and are excluded from Boeing‑vs‑Airbus comparisons but remain in overall summaries.  
- **Cost model:** A standard cost of $31 per delay‑minute is used for financial estimates, drawn from industry benchmarks (crew, fuel, maintenance, passenger goodwill). Details in `docs/cost_model_assumptions.md`.  
- **Known limitations:** The BTS “cause of delay” fields are self‑reported by airlines and may under‑represent maintenance‑related delays (often coded under carrier delay). Cancellation codes provide only broad categories. The FAA registry reflects the current registered owner; some aircraft may have changed configuration since manufacture.
