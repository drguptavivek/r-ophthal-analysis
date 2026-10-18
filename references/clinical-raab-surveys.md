# RAAB and Cluster Eye Surveys

Load this for Rapid Assessment of Avoidable Blindness (RAAB) or similar multistage eye surveys. General survey methods are in `clinical-complex-surveys.md`; indicator formulas in `who-ecim-ecsc-formulas.md` and `who-ecim-erec-formulas.md`; prevalence helpers in `clinical-survey-prevalence.md`.

## Know the RAAB Version

Codes differ by version. Read the value labels before coding any definition.

| Item | RAAB5/6 (integer codes, typical) | RAAB7 (Peek, logMAR categories) |
| --- | --- | --- |
| VA codes vary | RAAB5 (as in Ramke 2017 S1): 1 = sees 6/18; 2 = <6/18 to 6/60; 3 or more = worse than 6/60 | |
| Examined | `status == 1` | `exam_status == "exam_status_examined"` |
| VA category | 1 = sees 6/12; 2 = <6/12 to 6/18; 3 = <6/18 to 6/60; 4 = <6/60 to 3/60; 5 = <3/60 to 1/60; 6 = PL; 7 = NPL | 0.3 = sees 6/12; 0.47 = <6/12 to 6/18; 1.0 = <6/18 to 6/60; 1.3 = <6/60 to 3/60; 1.8 or more = <3/60 |
| Lens | 1 normal; 2 opacity; 3 aphakia; 4-5 pseudophakia; 6 no view | text codes, plus surgery type (couching) |
| Cause | 1 refractive error; 2 uncorrected aphakia; 3 untreated cataract; 4 surgical complications; ... | text codes |
| "BCVA" | pinhole VA | pinhole VA |

The same integer can mean 6/12 in one export and 6/18 in another. These codes are examples; confirm every threshold against the project's value labels and record the mapping in the charter. Write all conditions against labels, not integers (`clinical-variable-coding.md`).

## Survey Design

RAAB samples clusters with probability proportional to size, within one or more districts. Declare the design once and reuse it.

```stata
* Several districts sampled from a larger frame: district stage with FPC, then clusters
svyset district, fpc(n_districts_in_frame) weight(w_district) || cluster, weight(w_person) vce(linearized) singleunit(missing)
* One district or district-wise analysis
svyset cluster [pweight = w_person], vce(linearized) singleunit(certainty)
```

```r
des <- survey::svydesign(ids = ~district + cluster, fpc = ~n_districts_in_frame,
                         weights = ~w_final, data = examined, nest = TRUE)
# Warning "stages without fpc were treated as with replacement" is expected and matches Stata
```

- Estimate domains (sex, age group, district) with `subpop()` in Stata or by subsetting the design object in R. Never drop rows before `svyset`/`svydesign` for a domain estimate.
- District-wise estimates may instead use a district-only design when each district is its own target population. State which approach was used.

## Weights

Build, calibrate and check weights with `raab-weights.md` (two-stage construction, calibration to UN and MoHFW projections for the analysis year, 5- or 10-year age groups, optional rural-urban strata within districts).

Keep separate weights for national, multi-district, and district-level targets, and record which one each analysis uses. For weighted mixed models, supply level-specific weights (district, then person): Stata `melogit` with `pweight` at each level via `svyset`, or in R `WeMix::mix()` or `svylme::svy2lme()`. `lme4::glmer()` treats `weights` as precision weights and is not valid for sampling weights; a single overall weight is not valid in any of them.

## Cause-Specific Burden

Cause-specific blindness or VI = better-eye PVA below the threshold and the person-level principal cause equal to that cause, among examined participants. Code the cause by value label.

- RAAB assigns the most easily treatable or preventable cause as principal and does not test visual fields, so glaucoma, DR and other posterior-segment causes are underestimated (Gupta and Dada 2025, commenting on Bourne et al. 2024). State this in every cause-specific table note.
- Report blindness (below 3/60) and MSVI (below 6/18 to 3/60) separately, plus each cause's share of all blindness and MSVI.

## Standardisation and CIs

- RAAB reports age-sex standardise to the survey area's 50+ population: each age-sex cell is weighted by population / examined, then CIs use the Bennett et al. (1991) cluster formula (1.96 x SE, clipped to 0-100). Use this only when results must match an official RAAB report.
- Otherwise use design-based estimation (`svy: proportion` / `svyciprop`), with direct standardisation via `svy: proportion ..., stdize() stdweight()` in Stata or `survey::svystandardize()` in R. Report crude and standardised estimates and name the standard population.
- Report DEFF for key estimates.

Related: `clinical-survey-prevalence.md`, `who-ecim-ecsc-formulas.md`, `who-ecim-erec-formulas.md`, `glaucoma-endpoints.md`, `diabetic-retinopathy.md`, `corneal-blindness.md`, `raab-weights.md`.
