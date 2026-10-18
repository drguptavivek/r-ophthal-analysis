# Ophthalmology Definitions

Load this when defining ophthalmology variables, outcomes, denominators, or visual acuity classifications.

## Always State

Record each of these in `analysis_charter.md` before deriving variables:

- row unit: person, eye, visit, image, scan, lesion, or procedure; laterality coding and whether both eyes contribute
- eye-wise versus person-wise analysis, and for two-eye data: one selected eye, right/left only, better eye, worse eye, any eye, both eyes, or both eyes with clustering adjustment
- VA measure (PVA, UCVA, BCVA, pinhole), correction status, chart (Snellen, ETDRS, decimal, categorical), test distance, and scale used for analysis
- handling of CF, HM, LP, NLP values
- WHO visual impairment categories and exact thresholds
- missing, ungradable, absent, pseudophakic/aphakic, or excluded eyes

Do not label an outcome "person-level" unless its aggregation rule is stated.

## Visual Acuity

- Analyse VA on logMAR. Convert Snellen as `logMAR = -log10(numerator / denominator)`; decimal as `-log10(decimal)`. For ETDRS letter scores use `logMAR = 1.7 - 0.02 * letters` (85 letters = 0.0), and state any letter-by-letter vs line scoring.
- Off-chart values (CF, HM, LP, NLP) have no single standard logMAR. Common published conventions differ (for example CF 1.9-2.0 and HM 2.3-3.0; LP/NLP often excluded from means or analysed only categorically). Ask the researcher to choose one convention, cite its source in the `.Rmd`, and run a sensitivity analysis when off-chart eyes are a meaningful share.
- Keep the raw VA field alongside the derived logMAR so every conversion is auditable.

## WHO Visual Impairment Categories

Distance presenting VA in the better eye, ICD-11 / WHO World Report on Vision:

| Category | Worse than | Equal to or better than |
| --- | --- | --- |
| No VI | | 6/12 |
| Mild VI | 6/12 | 6/18 |
| Moderate VI | 6/18 | 6/60 |
| Severe VI | 6/60 | 3/60 |
| Blindness | 3/60 | |

Older and RAAB-style analyses may use other cut-offs (for example 6/18 as the lower limit of normal, or BCVA instead of PVA). Confirm the protocol's definition, encode thresholds as named constants, and never mix eye-wise and person-wise or PVA- and BCVA-based VI in one table without explicit labels.

## Person-Level Outcomes from Eye-Level Data

For refractive error, cataract, DR, glaucoma presence/suspect status, retinal disease, and other eye diseases, define the aggregation rule: any-eye positive, both-eye positive, better-eye based, worse-eye based, right-eye or left-eye only, or eye-wise with clustering adjustment. Document how a missing or ungradable fellow eye is handled (for example any-eye positive needs only one gradable positive eye; any-eye negative needs both eyes gradable).

## Analysing Both Eyes

When both eyes contribute, the inter-eye correlation must be modelled. Propose one of these and wait for approval:

- GEE with person as cluster and exchangeable working correlation (population-averaged effects).
- Mixed model with a person random intercept (subject-specific effects; add eye-level covariates as needed).
- Cluster (person-level) bootstrap for CIs of eye-level summaries or diagnostic metrics.
- One eye per person (random, right, or protocol-selected) when the clustering is not of interest.

Report both persons and eyes in denominators.

## Common Errors to Prevent

- Treating two eyes of one person as independent in a chi-square, t-test, or logistic model.
- Averaging Snellen fractions or decimal VA instead of logMAR.
- Reporting an eye-level p-value or prevalence as if it were person-level.
- Coding ungradable or not-examined eyes as disease-negative.
- Using the recruited N as the denominator for an outcome with missing eyes.

Related: `clinical-raab-surveys.md`, `who-ecim-ecsc-formulas.md`, `glaucoma-endpoints.md`, `diabetic-retinopathy.md`, `myopia.md`, `corneal-blindness.md`.
