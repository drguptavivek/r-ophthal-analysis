# Longitudinal, Repeated Measures, and Repeated Events

Load this for repeated measures, longitudinal data, repeated events, two-eye data, or multiple images per patient.

First define subject/cluster ID, repeated unit, time variable and spacing, outcome type, within-subject correlation structure, and missing follow-up mechanism.

## Model Options

- RM-ANOVA: only for balanced continuous outcomes at common fixed timepoints with assumptions reasonably met.
- Linear mixed-effects models: continuous repeated outcomes, especially unbalanced or irregular data.
- Random intercept models: participants/eyes/clusters have different baseline levels.
- Random slope models: change over time varies by participant/eye/cluster and data support estimating it.
- Fixed-effects models: controlling for time-invariant subject-level confounding is the primary goal.
- GLMM or GEE: binary, count, or non-normal repeated outcomes.
- Recurrent-event survival models: repeated time-to-event outcomes after defining event process and censoring.

Before fitting random-effects models, specify random-effects structure. Check convergence, singular fits, residual patterns, and overcomplication.

Report fixed effects, random effects, clustering unit, time variable, covariance/correlation structure, number of subjects/clusters, number of observations, and missing follow-up.
