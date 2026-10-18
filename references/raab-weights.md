# RAAB Survey Weights

Load this to build or check weights for multi-district RAAB-type surveys, or to estimate national prevalence and burden. Design declaration and codes are in `clinical-raab-surveys.md`; estimation helpers in `clinical-survey-prevalence.md`. Record every choice below in the charter.

## Weight Construction (Two Stages)

Weighting cells are district x sex x age group, optionally x residence (rural, urban) within each district.

1. **District to target population (stage 1):** target 50+ population divided by the 50+ population of all sampled districts. One constant for all districts; it assumes the sampled districts together represent the target (state or country). District size enters through stage 2.
2. **Person within district (stage 2):** target population of the cell divided by the number examined (enrolled) in that cell. This corrects for selection and non-response within the cell and equals the RAAB age-sex adjustment (cell population divided by examined) applied district by district.
3. **Final weight:** stage 1 x stage 2. Weights must sum to the target population in every cell.

Assumption to state: non-response is random within each cell (examined people represent non-examined people of the same district, sex, age group and residence).

## Calibration Target (Population and Year)

Calibrate to the population of the analysis year, not to the census year; an older age structure understates age-related conditions, and a total-only inflation factor does not fix the age structure.

| Level | Source |
| --- | --- |
| National control totals by sex and age | UN World Population Prospects (latest revision) for the analysis year |
| State by sex by 5-year age group | MoHFW Technical Group on Population Projections (2011-2036, revised 2020), quinquennial; interpolate linearly to the analysis year |
| States and UTs projected only as totals | Split the projected total by that state's 2011 census age-sex distribution |
| Urban share | Projected state urban percentage, by sex |
| District by residence by sex by age | Census 2011 district tables, scaled to the projected state cell (district 2011 cell x state projected cell / state 2011 cell) |

India tables for all four rows are in `reference-data/india-population/` (UN WPP 2022 single-age 2011-2050 and 5-year with 80% and 95% prediction bounds 2015-2040; MoHFW state projections; Census 2011 district by residence), with sources, units and assumptions in its README. Use the UN prediction bounds to carry projection uncertainty into burden estimates. District-level targets for any MoHFW projection year (district x age group with under 1 separate x residence x sex) are produced by `reference-data/india-population/project_district_population.R`; 2026 files are included, MoHFW-calibrated and UN-calibrated.

When both MoHFW (state structure) and UN (national totals) are used, rake (iterative proportional fitting) the district cells so state cells match MoHFW and national sex-by-age totals match UN; report which source controls which margin. Applying one urban percentage to every age group assumes the same age structure in rural and urban areas; prefer district census rural-urban age distributions where available.

Burden (number affected) = weighted total with weights calibrated to the analysis year; no separate inflation factor is then needed.

## Age Groups: 5-Year or 10-Year

Prespecify a minimum number examined per cell (for example 20).

- Use 5-year groups (50-54 ... 80+) when every district x sex (x residence) cell meets the minimum; preferred for outcomes that rise steeply with age.
- Otherwise use 10-year groups (50-59, 60-69, 70-79, 80+).
- If some cells still fall short, collapse adjacent age groups within that district and sex only, and report which cells were collapsed.

## Rural-Urban Strata (Optional)

Add residence as a cell dimension within each district when clusters were classified rural or urban in the sampling frame and district residence-specific populations are available. Cells double: apply the minimum-size rule after adding residence, and collapse residence before age if needed. Report estimates by residence only when residence was a weighting dimension or a design stratum.

## Checks Before Use

- No cell with zero examined (weight undefined); collapse first.
- Weight dispersion: maximum / minimum, coefficient of variation (CV), and design effect from weighting (1 + CV squared). Prespecify any trimming rule; report trimmed weights separately.
- Weights sum to the target population overall and by sex and age group.
- Weighted sample age-sex distribution matches the target; unweighted shows the non-response pattern.

## Weighting Versus Standardisation

- Calibrated weights already standardise to the target population's age-sex (and residence) structure: call the result "weighted (calibrated to [source], [year])".
- For international comparison, also report direct standardisation to a named external standard (for example WHO or GBD world population); never apply both to one estimate.
- Report crude (unweighted), weighted, and externally standardised estimates in separate columns, each labelled.

## Use in Analysis

- Declare both stages in the survey design (district PSU with finite population correction; clusters within district) with the stage-specific weights; see `clinical-raab-surveys.md`.
- Mixed models need level-specific weights; the constant stage-1 weight with a district random intercept works where an overall person weight fails.
- A survey with few districts (for example one per zone) has very few first-stage units; report the number of PSUs and interpret design-based CIs cautiously.

Sources: Gupta V et al. Br J Ophthalmol 2025 (corneal opacity) and J Glaucoma 2026 (glaucoma), which used district-wise sex- and age-group-specific sampling and non-response weights from the 2011 census with inflation to 2023; the user's RAAB weights and population-estimation code; MoHFW Report of the Technical Group on Population Projections 2011-2036 (2020); UN World Population Prospects.

Related: `clinical-raab-surveys.md`, `clinical-complex-surveys.md`, `clinical-survey-prevalence.md`, `burden-projection.md`.
