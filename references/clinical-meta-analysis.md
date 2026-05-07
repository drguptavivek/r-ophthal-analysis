# Meta-Analysis and Systematic Review

Load this for meta-analysis or systematic review datasets.

Clarify:

- Review question and PICO/PECO.
- Study-level vs participant-level data.
- Effect measure: OR, RR, HR, mean difference, SMD, sensitivity/specificity, diagnostic odds ratio, or another measure.
- Adjusted vs unadjusted estimates.
- Fixed-effect vs random-effects rationale.
- Heterogeneity plan: I2, tau2, Q test, prediction interval when appropriate.
- Subgroup and sensitivity analyses planned a priori.
- Risk of bias variables and whether they inform summaries, subgroup analysis, or sensitivity analysis.
- Whether pooling is clinically and methodologically justified.

Use `meta` and `metafor` for standard meta-analysis. Report forest plots, pooled estimates with 95% CIs, heterogeneity, model choice, and sensitivity analyses.

For diagnostic-test meta-analysis, discuss the appropriate model before proceeding; do not simply pool sensitivity and specificity without checking whether bivariate/HSROC methods are needed.
