# Data Sources

## Primary Dataset: BTS On‑Time Performance

- **Full name**: Reporting Carrier On‑Time Performance (1987–present)
- **Source**: Bureau of Transportation Statistics (BTS), TranStats portal  
  [https://www.transtats.bts.gov/DL_SelectFields.aspx?gnoyr_VQ=FGJ&QO_fu146_anzr=b0-gvzr](https://www.transtats.bts.gov/DL_SelectFields.aspx?gnoyr_VQ=FGJ&QO_fu146_anzr=b0-gvzr)
- **Time range used**: January 2025 to January 2026 (13 months)
- **Rows**: ~7 million domestic scheduled flights
- **Key fields**: Flight date, carrier, origin/destination, scheduled/actual times, delay causes, cancellation/diversion flags, tail number.

### Selection criteria
- **33 fields** selected (see `data/data_dictionary.md` for full list).
- Domestic flights only (both origin and destination within the 50 U.S. states or DC).
- Years 2025–2026 ensure up‑to‑date analysis and include the most recent full month available.

## Secondary Dataset: FAA Aircraft Registry

- **Full name**: Releasable Aircraft Database (civil aircraft registered in the U.S.)
- **Source**: Federal Aviation Administration (FAA)  
  [https://www.faa.gov/licenses_certificates/aircraft_certification/aircraft_registry/releasable_aircraft_download](https://www.faa.gov/licenses_certificates/aircraft_certification/aircraft_registry/releasable_aircraft_download)
- **Files used**: `MASTER.txt` (tail number, manufacturer/model code, year) and `ACFTREF.txt` (manufacturer/model code → manufacturer name, model, engines, seats).
- **Purpose**: Enrich flight records with aircraft manufacturer, model, family, and vintage so the analysis can distinguish Boeing from Airbus and identify fleet‑age effects.

### Processing steps
1. `MASTER.txt` and `ACFTREF.txt` are joined on `MFR MDL CODE`.
2. Manufacturer names are cleaned and mapped to OEM categories: Boeing, Airbus, Other.
3. Models are grouped into families (e.g., 737 Family, 787 Family, A320 Family).
4. Result saved as `data/processed/faa_lookup.parquet`.

## Additional reference (not directly loaded)

- **BTS T‑100 Segment Data** (passenger counts per route) – can be used in future to weight delay costs by passenger volume.
- **BTS Form 41 / P‑5.2** (airline financials) – used to cross‑check cost assumptions, not included in the core pipeline.

## Refresh cadence

The BTS data is published monthly with a ~3‑month lag. The FAA registry is updated daily. For a live dashboard, both should be refreshed quarterly, with the FAA lookup rebuilt each time to capture newly registered aircraft.
