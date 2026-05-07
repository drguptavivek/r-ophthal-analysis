# Cluster Surveys and Complex Samples

Load this for cluster surveys or complex sample designs.

Ask whether data contain cluster/PSU ID, strata ID, sampling weights or sampling probabilities, population totals, FPC, survey stage information, and variables for direct standardization.

Use design-aware methods when survey design information is available. Prefer `survey::svydesign()` or `srvyr::as_survey_design()` with survey-weighted estimates, tests, and models.

## Weights

Use provided sampling weights when available. If weights must be estimated, document sampling probabilities and formula before applying. Check extreme weights and discuss trimming only with researcher approval.

## Direct Standardization

Confirm standard population and standardization variables. Report crude and directly standardized estimates when useful. Include 95% CIs for standardized prevalences/incidences/means when estimated.

## Post-Stratification

Confirm variables, external population margins/totals and source. Check every analytic post-stratum maps to a population total. Collapse sparse post-strata only with approval. Apply after defining base survey design and weights. Compare unweighted, weighted, and post-stratified distributions. Report variables and population source.

## DEFF and ICC

Report design effect for key estimates when possible. Estimate/report ICC for clustered outcomes when relevant and interpretable. Use DEFF and ICC to interpret precision loss due to clustering.

Do not ignore clustering or weights unless the researcher explicitly decides an unweighted/descriptive analysis is appropriate.
