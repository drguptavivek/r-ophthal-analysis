# Burden and Service Projection

Load this to project future numbers of people affected, services needed (for example cataract surgeries) or complications (for example pseudophakic bullous keratopathy, PBK) from survey rates and population projections. Population tables are in `reference-data/india-population/`; survey estimation in `clinical-survey-prevalence.md`.

## General Structure

Projected count in year t = sum over age (and sex) of projected population in that age x rate in that age. Each piece is estimated separately and its uncertainty carried through.

| Piece | Source | Notes |
| --- | --- | --- |
| Population by single age and sex, year t | UN WPP (median with 80% and 95% bounds) or national projections | `reference-data/india-population/`; newer revisions and life tables via the UN Data Portal API (its README) |
| Age-specific rate | Population surveys (RAAB, RAAVI, others), smoothed over age | Rate type must match the quantity projected (annual event rate vs prevalence) |
| Conversion factors | For example eyes per person-operation, complication probability | From cohort or hospital data, age-specific where possible |

## Annual Event Rates from Surveys (Recall Window)

Surveys record when surgery happened, usually as a calendar year or a time band. Build "event in the last 12 months" per person:

- Calendar year recorded: count all events in the survey year, plus the fraction of the previous year's events inside the 12-month window. For an interview in month m (mid-month), that fraction is 1 - (m - 0.5)/12 (for example mid-May: 1 - 4.5/12 = 0.625). Apply by random selection of that fraction of previous-year events, with a fixed seed, or as a fractional weight.
- Time band recorded (for example "1-2 years ago"): assign half of that band to the last 12 months, stated as an assumption.
- Report persons with an event and eyes operated (one or both) separately; both-eye surgery in the same year turns persons into eye counts: eye surgeries = persons operated x (1 + proportion with both eyes operated in the year).
- Recall error (telescoping) and missing dates bias these rates; report the share of operated eyes with no date and exclude or impute them by a stated rule.

## Smoothing and Extrapolating Rates Over Age

- Pool age-group rates from comparable surveys (state survey, year and region), fit a smooth function of mid-age (for example cubic polynomial or restricted cubic spline), and predict single-year rates with standard errors.
- Polynomials can turn implausibly at the oldest ages: cap at the last observed age group or use splines with linear tails; never extrapolate beyond the data's age range without saying so.
- Surveys from different years and regions estimate different rates; treat each as a scenario (low, central, high) rather than averaging silently.

## Prevalence, Incidence and Mortality

- Projected prevalent cases = population x age-specific prevalence; this assumes age-specific prevalence stays constant.
- Incidence of an irreversible condition from age-specific prevalence (Podgor and Leske 1986), per age interval of t years (usually the 5-year step between age-group midpoints):
    1. Inputs: prevalence at the start (P0) and end (P1) of the interval; the t-year probability of death without the disease, Q, from life tables (UN qx or SRS abridged life tables), giving the death rate lambda1 = -ln(1 - Q); and the death-rate ratio R for people with the disease (lambda3 = R x lambda1). R = 1 means equal mortality; the paper's cataract example used R = 2.
    2. Solve for the incidence rate lambda2 (per t years) in: (1 - P0) x P1 x exp(-(lambda1 + lambda2)) / (1 - P1) = P0 x exp(-lambda3) + (1 - P0) x [exp(-lambda3) - exp(-(lambda1 + lambda2))] x lambda2 / (lambda1 + lambda2 - lambda3), by a numerical root finder.
    3. With equal mortality this reduces to lambda2 = -ln[(1 - P1) / (1 - P0)].
    4. Report the incidence rate and the net risk, 1 - exp(-lambda2) (probability of developing the disease in the interval in the absence of death), with delta-method standard errors from the prevalence sampling variances (use effective sample sizes for survey data).
    5. Assumptions to state: irreversible disease, stable age-specific prevalence over time (no cohort effect), exponential times to disease and death, and the chosen R. Prevalence must rise across the interval; otherwise incidence is not estimable.
  Worked implementation: `examples/r/incidence_from_prevalence.R` (reproduces the paper's Framingham cataract Table II).

## Uncertainty

Combine, by Monte Carlo simulation with a fixed seed:

1. Population: draw between UN 80% or 95% bounds (or use bounds as scenarios).
2. Rates: draw from the rate model's prediction distribution (prediction interval, not only the confidence interval of the mean).
3. Conversion factors (complication probabilities): draw from their sampling distribution.

Report median and 2.5th-97.5th percentiles per year; show scenarios (survey rate sets) separately rather than inside one interval.

## Reporting

- State the base year, projection horizon, population source and revision, rate sources and their years, smoothing model, and every assumption (constant rates, recall apportioning, bilateral proportion).
- Present counts by year with uncertainty, and age-specific contributions for the first and last projection years.
- Projections of complications must name the complication model and its population (for example PBK probability by surgery age, sex, surgery type, lens grade and Fuchs dystrophy from hospital data).

Sources: methods as implemented in the maintainer's cataract surgery and PBK projection code (RAAVI, Theni, Bharatpur 1999 and Navsari 2007 surveys; UN WPP 2022 population; LVPEI PBK data); Podgor MJ, Leske MC. Estimating incidence from age-specific prevalence for irreversible diseases with differential mortality. Stat Med 1986;5:573-78 (PMID 3823665).

Related: `who-ecim-ecsc-formulas.md`, `corneal-blindness.md`, `clinical-raab-surveys.md`, `raab-weights.md`, `clinical-survey-prevalence.md`.
