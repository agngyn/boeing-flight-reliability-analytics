# Data Dictionary — Boeing Flight Reliability Analytics

The primary analysis table is **`flights_enriched`**, which contains one row per domestic U.S. scheduled flight.

## Enriched Flights Table (flights_enriched)

| Column | Description | Type |
|--------|-------------|------|
| `flight_date` | Date of flight (local) | DATE |
| `reporting_airline` | Unique carrier code | TEXT |
| `dot_id_reporting_airline` | DOT identifier for the airline | INT |
| `tail_number` | Aircraft registration number (N‑number) | TEXT |
| `origin_airport_id` | DOT origin airport ID | INT |
| `origin` | Origin airport code (e.g., ORD) | TEXT |
| `origin_city_name` | Origin city | TEXT |
| `origin_state` | Origin state abbreviation | TEXT |
| `dest_airport_id` | DOT destination airport ID | INT |
| `dest` | Destination airport code | TEXT |
| `dest_city_name` | Destination city | TEXT |
| `dest_state` | Destination state abbreviation | TEXT |
| `crs_dep_time` | Scheduled gate departure time (hhmm, local) | INT |
| `dep_time` | Actual gate departure time (hhmm, local) | INT |
| `dep_delay` | Departure delay (minutes, negative = early) | REAL |
| `crs_arr_time` | Scheduled gate arrival time (hhmm, local) | INT |
| `arr_time` | Actual gate arrival time (hhmm, local) | INT |
| `arr_delay` | Arrival delay (minutes, negative = early) | REAL |
| `cancelled` | Flight was cancelled (TRUE/FALSE) | BOOLEAN |
| `cancellation_code` | Reason for cancellation (A=carrier, B=weather, etc.) | TEXT |
| `diverted` | Flight was diverted (TRUE/FALSE) | BOOLEAN |
| `distance` | Distance between airports (miles) | REAL |
| `carrier_delay` | Delay minutes attributed to the carrier | REAL |
| `weather_delay` | Delay minutes attributed to weather | REAL |
| `nas_delay` | Delay minutes attributed to National Airspace System | REAL |
| `security_delay` | Delay minutes attributed to security | REAL |
| `late_aircraft_delay` | Delay caused by late inbound aircraft | REAL |
| `manufacturer` | Aircraft manufacturer (from FAA registry) | TEXT |
| `model` | Aircraft model (e.g., 737-800) | TEXT |
| `num_engines` | Number of engines | INT |
| `num_seats` | Number of seats (as registered) | INT |
| `aircraft_year` | Year of manufacture | INT |
| `oem` | Original equipment manufacturer: 'Boeing', 'Airbus', or 'Other' | TEXT |
| `aircraft_family` | Aircraft family: '737 Family', '787 Family', 'A320 Family', 'Other' | TEXT |

## FAA Lookup Table (faa_lookup)

| Column | Description | Type |
|--------|-------------|------|
| `tail_num` | Aircraft N‑number (primary key) | TEXT |
| `manufacturer` | Manufacturer name | TEXT |
| `model` | Model designator | TEXT |
| `num_engines` | Number of engines | INT |
| `num_seats` | Authorised number of seats | INT |
| `aircraft_year` | Year of manufacture | INT |
| `oem` | 'Boeing', 'Airbus', or 'Other' | TEXT |
| `aircraft_family` | Aircraft family group | TEXT |
