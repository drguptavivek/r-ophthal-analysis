# Regression Reporting

Load this for univariable and multivariable model tables of any type. Shared table styling and numeric formatting are in `clinical-reporting-guidelines.md`.

## Terminology

Write "univariable" (one predictor) and "multivariable" (several predictors), or "crude" and "adjusted". Use "multivariate" only for models with more than one outcome.

## Before Fitting

- Prespecify the adjustment set from the research question, clinical knowledge, prior literature, or a DAG, and record it in the charter decision log. Never select covariates by univariable p-value or stepwise procedures.
- Check events per parameter: count each dummy level, spline term, and interaction as a parameter. Flag fewer than about 10 outcome events (or the smaller outcome group) per parameter and propose fewer covariates or Firth penalized regression for approval.
- Check collinearity with VIF; raise values above about 5 with the researcher.
- Keep continuous predictors continuous unless categorization is approved with prespecified cut points. Check linearity (for example a restricted cubic spline or a categorized comparison) before reporting a single slope.
- Prespecify any interaction. Report stratum-specific estimates, with the interaction p in the note, rather than a raw product term.

## Generic Table Layout

One label column with bold variable headings and indented category rows, then:

| Variable / category | N | Outcome summary | Univariable estimate [95% CI] | Multivariable estimate [95% CI] |
|:--|--:|--:|--:|--:|
| **Variable label** | | | | |
|   Reference category | category N | summary | 1.0 [Reference] | 1.0 [Reference] |
|   Other category | category N | summary | estimate [lower, upper] | estimate [lower, upper] |
| **Continuous variable, per unit** | N | | estimate [lower, upper] | estimate [lower, upper] |

- Put the unit of change in the row label for continuous predictors, scaled to a clinically meaningful step, for example "Age, per 10 years" or "Baseline VA, per 0.1 logMAR".
- Reference rows read `1.0 [Reference]` for ratio measures and `0.0 [Reference]` for linear coefficients.
- No p-value columns, adjusted-p columns, or significance stars unless the researcher explicitly asks.

## Columns by Model Type

| Model | Outcome summary | Estimate | Model note |
| --- | --- | --- | --- |
| Logistic | Outcome (%) | OR | N, LR chi-square (df, p), -2LL, McFadden pseudo-R-squared |
| Linear | Mean (SD) of outcome | beta | N, R-squared, adjusted R-squared |
| Log-binomial or modified Poisson (robust SE) | Outcome (%) | RR | N, method used |
| Poisson or negative binomial for rates | Events / person-time | IRR | N, offset, overdispersion check |
| Cox | Events / N | HR | N, events, proportional-hazards check |
| Ordinal logistic | Distribution of outcome levels | OR (proportional odds) | N, proportional-odds check |

Name the model in the table title, for example "Logistic regression for any-eye DR".

## Clustered, Two-Eye, and Repeated Data

- For GEE or mixed models, the N column shows persons and eyes (or persons and visits), for example `412 / 798`, and the header says so.
- The note names the clustering unit and the working correlation (GEE, robust SE) or random effects (mixed model).
- Never present an eye-level model fitted without clustering adjustment as if eyes were independent.

## Survey-Weighted Models

- Show unweighted n beside weighted % in the outcome summary, and design-based 95% CIs.
- The note names the design elements: strata, PSU, weights, and FPC as applicable.

## Logistic Regression Details

Use one label column with bold variable headings and indented category rows. The default columns are:

| Variable / category | N | Outcome (%) | Univariable OR [95% CI] | Multivariable OR [95% CI] |
|:--|--:|--:|--:|--:|
| **Variable label** | | | | |
|   Reference category | category N | observed outcome % | 1.0 [Reference] | 1.0 [Reference] |
|   Other category | category N | observed outcome % | OR [lower, upper] | OR [lower, upper] |

- N is the number analysed in that category; Outcome (%) is the percentage with the prespecified binary outcome within that category. State the outcome definition in the title or header. Do not substitute percentage of the entire study population.
- Use an explicitly defined common complete-case sample for the demonstration so N and outcome % correspond to both model columns. In real analyses follow the approved missing-data plan; if model samples differ, make this visible instead of claiming shared denominators.
- Fit each univariable model separately and fit the multivariable model with the approved adjustment set. Do not select covariates automatically using univariable significance. Keep reference categories and coding identical across columns.
- Display numeric OR and CI results from the fitted engine; exponentiate log-odds coefficients and confidence bounds, not standard errors. Label the CI method only if not already stated in the methods. Do not add p-values, Holm columns, interpretation or significance stars.
- Reference rows are explicit. Mark separation, non-convergence, omitted terms or unavailable estimates as `Not estimable`, investigate them, and preserve warnings. Never replace these with an apparently valid OR.
- Use the same three-rule, indented, unsplit publication styling. An essential note may identify the CI method or adjusted variables only when the table/methods do not already show them. Include a compact multivariable model-statistics note: actual N, likelihood-ratio chi-square with df and p, -2 log likelihood (-2LL), and explicitly named McFadden pseudo-R-squared. Retrieve these from the fitted model; do not call pseudo-R-squared ordinary R-squared. Add other diagnostics only when requested and appropriate to the approved model.

Related: `clinical-reporting-guidelines.md`, `clinical-study-designs.md`, `clinical-longitudinal-repeated.md`.
