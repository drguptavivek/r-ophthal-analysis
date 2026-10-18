# India Population Reference Tables

Aggregate public population tables for calibrating survey weights and estimating burden in India (`references/raab-weights.md`). No individual-level data. Other countries need the same structure from their own sources.

All tables are gzip-compressed CSV (`.csv.gz`); R reads them directly with `read.csv("file.csv.gz")`, and Stata after `gunzip` or with a decompressed copy.

| File | Content | Units | Source |
| --- | --- | --- | --- |
| `india_un_wpp2022_single_age_sex_2011_2050.csv.gz` | National, single year of age 0-100 (100 = 100+), male and female, 2011-2050 | Persons | UN World Population Prospects 2022, median variant, UN data portal extract of 17 Aug 2023 |
| `india_un_wpp2022_5y_age_sex_intervals_2015_2040.csv.gz` | National, 5-year age groups, male and female, 2015-2040; median with 80% and 95% prediction bounds | Persons | UN World Population Prospects 2022, UN data portal download, Oct 2023 |
| `india_census2011_district_age_sex_residence.csv.gz` | 640 districts x age group (0, 1-4, then 5-year to 80+) x rural/urban x male/female | Persons | Census of India 2011, table C-13 (single-year age by residence and sex), aggregated |
| `india_mohfw_state_age_sex_raw_2011_2036.csv.gz` | 22 states and the North-East aggregate x sex x age group, including under-1 ("0-1"), 2011-2036 quinquennial | Thousands | MoHFW Report of the Technical Group on Population Projections 2011-2036 (revised 2020), as published |
| `india_mohfw_state_total_urban_annual_2011_2036.csv.gz` | All states and UTs (and India) x sex, annual 2011-2036, with projected urban percentage | Thousands | Same report |
| `india_district_population_projection_2026.csv.gz` | 640 Census 2011 districts x age group (0, 1-4, 5-year to 80+) x rural/urban x sex, projected to 2026 and calibrated to MoHFW | Persons | `project_district_population.R 2026` |
| `india_district_population_projection_2026_un.csv.gz` | The same, rescaled so national sex x age totals equal UN WPP 2022 | Persons | `project_district_population.R 2026 un` |

## Raw Sources (`source/`)

| File | What it is |
| --- | --- |
| `un_wpp2022_india_single_age_sex_dataportal_20230817.xlsx` | UN data portal download: India, single-year age x sex, 2011-2050 |
| `un_wpp2022_india_5y_age_sex_annual_variants.csv.zip` | UN data portal download: India, 5-year age x sex, annual, all projection variants |
| `census2011_c13_single_age_residence_sex.dta.gz` | Census 2011 table C-13 for all states and districts, single-year age by total/rural/urban and sex |
| `mohfw_2020_state_age_sex_projection.dta.gz` | MoHFW state x sex x age-group projections, transcribed from the 2020 report |
| `mohfw_2020_state_total_urban_projection.dta.gz` | MoHFW state x sex annual totals and urban percentage, transcribed from the 2020 report |

The MoHFW report itself (PDF, about 22 MB) is not stored; it is published by the National Commission on Population, MoHFW.

## Rebuilding

From the skill root (R packages `haven` and `readxl` needed for the source formats):

```
Rscript reference-data/india-population/build_tables.R
Rscript reference-data/india-population/project_district_population.R 2026
Rscript reference-data/india-population/project_district_population.R 2026 un
```

Rebuilds are byte-identical to the stored files (verified 2026-10-18), so rerunning creates no spurious changes.

## Transformations and Assumptions

- MoHFW publishes age detail for 22 states and a North-East aggregate only; the district projection derives age structure for the other states and UTs (see District Projections).
- Census 2011: single years aggregated to under 1, 1-4, then 5-year groups with 80+ open; "age not stated" (about 4.5 million persons) is excluded, so district totals sum to 1,206,365,175 rather than the census total of 1,210,854,977.
- UN: values as published; the single-age and 5-year files agree (India 50+ in 2023: 290,151,310 and 290,151,288; 95% interval 288.3 to 291.9 million).
- Interpolate MoHFW quinquennial years linearly to the analysis year; use UN annual values directly.
- A local 2024 single-age file with rural-urban splits had its rural male column equal to total male (rural males overstated by about 268.7 million). It was corrected at source on 2026-10-18 (rural male = total male - urban male; original kept as a backup) and is not included here; rebuild 2024 rural-urban splits from these tables.

## District Projections

`project_district_population.R` projects every Census 2011 district to a MoHFW projection year (2011, 2016, 2021, 2026, 2031, 2036) by age group (under 1 kept separate), sex and residence, using only the tables in this folder:

1. Seed: Census 2011 district x age group x residence x sex.
2. State targets for the year: MoHFW age-sex projections for 22 states (under 1 = MoHFW "0-1"; 1-4 = "0-4" minus "0-1"); for the seven North-East states, their 2011 census age-sex counts grown by the North-East aggregate's age-sex ratios and rescaled to each state's MoHFW total; for Goa, Ladakh and UTs, their 2011 age-sex distribution scaled to their MoHFW total (age structure held at 2011). Urban target = MoHFW urban percentage x total, by state and sex.
3. Within each state and sex, rake the district x age x residence seed to the age totals and urban/rural totals; district shares within each age-residence cell follow 2011.
4. Optional `un` argument: rescale each national sex x age group to UN WPP, keeping state and district shares (state totals then differ from MoHFW).

Census 2011 districts 532-541 of Andhra Pradesh go to Telangana, and Leh and Kargil to Ladakh. The script checks every state x sex x age total and urban share against MoHFW. For 2026: India 1,425,902,000 (MoHFW 1,425,908,000; the difference is rounding of MoHFW thousands); 50+ population 307.4 million (UN WPP 317.4 million, matched by the `un` version); urban share 36.0% (Census 2011: 31.1%).

Limitations: districts are Census 2011 boundaries; differential growth between districts within a state is not modelled; ages are held at the 2011 structure for Goa, Ladakh and UTs; MoHFW projections are rounded to thousands.

## Fetching Newer UN Data (UN Data Portal API)

Use the API when a newer World Population Prospects revision is released or other years, countries or indicators are needed. Checked 2026-10-18.

- Token: request a free bearer token at <https://population.un.org/dataportalapi/token/index.html>. It is emailed, never shown in the browser. Keep it out of the repository and out of scripts; read it from an environment variable (for example `UNPD_TOKEN`).
- Base URL: `https://population.un.org/dataportalapi/api/v1/`. Interactive documentation (Swagger): `https://population.un.org/dataportalapi/index.html`.
- Open without a token: `locations` (India = 356) and `indicators`.
- Needs the token (header `Authorization: Bearer <token>`): `data/indicators/{indicator}/locations/{location}/start/{year}/end/{year}`. Results are paged (`pageNumber`, `pageSize`); follow `nextPage` until it is empty.
- Indicator codes used here:

| Code | Indicator |
| --- | --- |
| 46 | Population by 5-year age groups and sex |
| 47 | Population by 1-year age groups and sex |
| 49 | Total population by sex |
| 81 | Probability of dying q(x,n), abridged life table (for incidence from prevalence) |
| 82 | Probability of dying q(x,n), complete life table |
| 77, 78 | Survivors l(x), abridged and complete |
| 91, 92 | Population and percentage by national urban definition |

- Each row carries `variant` (keep Median, and the 80% and 95% bounds when carrying uncertainty), `sex`, `ageStart`, `ageEnd`, `timeLabel` and `value`. Record the revision and download date in this README, rebuild the CSVs with the same columns, and rerun the totals checks above.

## Licences and Attribution

- UN World Population Prospects: United Nations, Department of Economic and Social Affairs, Population Division; CC BY 3.0 IGO. Cite the revision used.
- Census of India 2011 and MoHFW projections: Government of India public releases; cite the Office of the Registrar General and Census Commissioner, and the MoHFW National Commission on Population Technical Group report.

Update these tables when a new UN revision or MoHFW projection is released, and record the revision in this README.
