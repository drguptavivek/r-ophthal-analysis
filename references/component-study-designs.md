# Component: Study Designs and Modelling

Use this component after study design, unit of analysis, outcomes, endpoints, exposures, comparison groups, and modelling purpose are clear.

Do not run deeper analysis until the researcher approves the proposed method.

## Dispatch

Read only the design reference needed:

- `clinical-study-designs.md`: cross-sectional, case-control, cohort, RCT/interventional, and survival.
- `clinical-complex-surveys.md`: cluster surveys, weights, direct standardization, post-stratification, DEFF, ICC.
- `clinical-longitudinal-repeated.md`: RM-ANOVA, mixed models, fixed effects, random intercept/slope, GEE, repeated events.
- `clinical-diagnostic-prediction.md`: diagnostic metrics, ROC/AUC, DCA, prediction modelling, train/test, cross-validation, ML.
- `clinical-meta-analysis.md`: meta-analysis and systematic reviews.

## Guardrails

- Match tests and models to study design.
- Prefer common statistical tests used in medical literature.
- Distinguish inferential modelling from prediction modelling.
- For RCTs, use ITT as primary when randomization data are available; report fidelity and adverse effects when data exist.
- For survival analysis, confirm time origin, event, censoring, follow-up unit, competing risks, and clustering.
- For diagnostic metrics, report 95% CIs for all estimable metrics; use bootstrap CIs where appropriate.
