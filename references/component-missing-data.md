# Component: Missing Data

Use this component after the initial missingness audit and before the analytic-dataset freeze or any model.

## Required assessment

- Distinguish missing, unavailable, not applicable, ungradable, and structurally absent observations. Do not recode these states as a negative result.
- Summarize missingness for outcomes, exposures, predictors, eyes, visits, and comparison groups as relevant.
- For longitudinal or survival data, distinguish missing visits, dropout, administrative censoring, loss to follow-up, and competing events.
- Check whether the analysis method must preserve clustering, survey design, repeated measures, or eye-within-person structure.

## Decision gate

Propose the primary handling strategy and wait for researcher approval. State the analysis population, variables affected, assumptions, and planned sensitivity analysis.

- Justify complete-case analysis rather than using it automatically.
- If multiple imputation is proposed, define the imputation unit, variables, auxiliary information, number of imputations, diagnostics, pooling, and how survey or clustering structure is preserved.
- In prediction work, learn imputation only within training or resampling data to prevent leakage.
- Report the actual N and denominator used for every principal result.

Record the approved plan and deviations in the central `.Rmd`.
