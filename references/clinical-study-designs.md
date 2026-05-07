# Clinical Study Design Modules

Load the relevant section after the user identifies the study design.

## Study Design Drives Analysis

Do not choose tests or models without checking that they match the design.

- Cross-sectional: describe prevalence, distributions, group differences, and associations. Use prevalence estimates with 95% CIs. Avoid causal language.
- Case-control: describe case/control characteristics and estimate ORs with 95% CIs. Use logistic regression for adjusted associations. Do not estimate incidence or RR directly unless the sampling design supports it.
- Cohort: estimate risks, rates, RRs, incidence rates, HRs, and time-to-event outcomes as appropriate.
- RCT/interventional: follow intervention/comparator structure, baseline balance, prespecified outcomes, effect sizes with 95% CIs, and ITT/per-protocol distinctions.
- Diagnostic accuracy: use `clinical-diagnostic-prediction.md`.
- Meta-analysis/systematic review: use `clinical-meta-analysis.md`.
- Cluster survey: use `clinical-complex-surveys.md`.
- Repeated/longitudinal data: use `clinical-longitudinal-repeated.md`.

If design is unclear, stop and ask. If requested analysis does not match the design, explain the concern and ask whether to proceed, modify, or defer.

## Randomized Trials and Interventions

Ask whether data contain randomized allocation, treatment received, eligibility/exclusions, follow-up/withdrawals, protocol deviations, crossovers, intervention fidelity/adherence, adverse events, and prespecified outcomes.

Use ITT as the primary analysis when randomization data are available. Analyze participants in assigned groups regardless of adherence, crossover, or treatment received. Per-protocol/as-treated analyses are secondary or sensitivity analyses and must be labelled clearly.

Report intervention fidelity and adverse effects descriptively before interpreting efficacy.

## Survival Analysis

Use survival analysis only with a genuine time-to-event outcome, follow-up time, and censoring. Confirm time origin, event definition, censoring definition, follow-up time unit, event indicator coding, competing risks, and clustering.

Start with number at risk, events, median follow-up, Kaplan-Meier curves with risk tables, survival probabilities with 95% CIs, and log-rank tests only when appropriate.

For Cox regression, report HRs with 95% CIs and p-values, check proportional hazards assumptions, influential observations, functional form, overfitting risk, and do not interpret HRs as RRs.
