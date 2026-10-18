---
name: ophthal-analysis
description: Stepwise, researcher-approved analysis of ophthalmology and eye-care research data in R/R Markdown (default) or native Stata when explicitly requested. Use for eye-wise vs person-wise outcomes, visual acuity/logMAR and WHO visual impairment, cataract, refractive error and myopia, diabetic retinopathy, glaucoma/IOP, corneal blindness, RAAB and cluster eye surveys, WHO ECIM eCSC/eREC indicators, diagnostic accuracy or AI grading studies, Table 1 and publication tables, regression, labelled Stata/SPSS exports, RStudio/ClaudeR MCP or Rscript setup, and Stata MCP setup (`setup-stata-mcp`). Not for general biostatistics without an eye-care context.
---

# Ophthal Analysis

## Role

Coordinate ophthalmology clinical research analysis. The researcher decides; AI suggestions are proposals. Work one phase at a time and do not start the next substantive phase until the researcher confirms.

R/R Markdown is the default. When the researcher explicitly requests Stata, use staged `.do` files, each with a preserved raw log and native reporting; no R translation or R installation is needed. The same source freeze, data safeguards, and approval gates apply. Present checked results without clinical or statistical interpretation unless the researcher explicitly asks.

## Index

The references form a network. Identify every theme the task touches, then load only the files under those themes; a file appears under each theme it serves. Each reference ends with a `Related:` line for neighbouring files. Paths are relative to `references/`.

| Theme | Load when | Files |
| --- | --- | --- |
| Setup and runtime | R, RStudio/ClaudeR MCP, Pandoc, Stata MCP (`setup-stata-mcp`) | `local-config.md` |
| Project and data | Scaffolding, stages, freeze, codebook, recoding, missing data, legacy Stata | `component-project-layout.md`, `component-data-management.md`, `clinical-variable-coding.md`, `component-missing-data.md`, `legacy-stata-translation.md` |
| Reporting | Tables, figures, rendering, regression tables | `component-rmd-reporting.md` or `component-stata-reporting.md`, `clinical-reporting-guidelines.md`, `clinical-regression-reporting.md` |
| Study design and statistics | Choosing tests and models after design, unit and purpose are clear | `clinical-study-designs.md`, `clinical-longitudinal-repeated.md`, `clinical-diagnostic-prediction.md`, `clinical-meta-analysis.md` |
| Vision core | VA, logMAR, WHO VI, eye vs person, two-eye analysis | `clinical-ophthalmology-guidelines.md` |
| Surveys | RAAB and cluster surveys, weights, standardisation, prevalence by group, cause-specific burden | `clinical-complex-surveys.md`, `clinical-raab-surveys.md`, `raab-weights.md`, `clinical-survey-prevalence.md` |
| WHO ECIM indicators | eCSC, CSC, eREC, REC, cataract surgical outcome | `who-ecim-ecsc-formulas.md`, `who-ecim-erec-formulas.md`, `clinical-raab-surveys.md`, `clinical-survey-prevalence.md` |
| Cataract | Coverage, surgical outcome, cataract VI, surgery projections | `who-ecim-ecsc-formulas.md`, `clinical-raab-surveys.md`, `burden-projection.md` |
| Refractive error | Case classification (myopia, hyperopia, astigmatism, which eye, exclusions), eREC/REC, spectacle coverage, near vision | `refractive-error-classification.md`, `refractive-error-vision-layers.md`, `who-ecim-erec-formulas.md`, `myopia.md`, `school-eye-health.md` |
| Myopia | Prevalence, incidence, myopia-control trials | `refractive-error-classification.md`, `refractive-error-vision-layers.md`, `myopia.md`, `clinical-longitudinal-repeated.md` |
| School eye health | School vision screening, referral uptake, spectacle provision and wear, school-based trials | `school-eye-health.md`, `refractive-error-classification.md`, `refractive-error-vision-layers.md`, `myopia.md`, `who-ecim-erec-formulas.md`, `clinical-diagnostic-prediction.md` |
| Glaucoma | Case definitions, IOP trials, surgery, AI screening, progression, mind-body trials, blindness burden | `glaucoma-endpoints.md`, `glaucoma-progression.md`, `glaucoma-mindbody-trials.md`, `clinical-raab-surveys.md` |
| Diabetic retinopathy | Grading, STDR, referable DR, DR in RAAB, screening | `diabetic-retinopathy.md`, `clinical-diagnostic-prediction.md`, `clinical-raab-surveys.md` |
| Corneal blindness | CO burden, trachomatous opacity, keratoplasty need and outcomes | `corneal-blindness.md`, `clinical-raab-surveys.md` |
| Burden projection | Future cases, surgeries or complications from survey rates and population projections | `burden-projection.md`, `raab-weights.md`, `clinical-survey-prevalence.md` |
| Screening and AI | Diagnostic accuracy, prediction, AI grading | `clinical-diagnostic-prediction.md`, plus the disease file |

Runnable examples: `examples/r/README.md`, `examples/stata/README.md` (Stata only on explicit request).

Use `scripts/scaffold_analysis_guidelines.R` for optional project scaffolding and `scripts/selftest.R` for a dependency-free readiness check.

## Runtime Preflight

Before the first R execution or environment-setup action in a task, run `Rscript scripts/selftest.R`. It reports R version, `Rscript` and library paths, package build locations, Pandoc, and optional RStudio MCP readiness without installing anything.

- After R is upgraded, moved, or loads a different library, run `Rscript scripts/selftest.R --check-updates` and review the result with the user. Never update R or packages automatically; rerun ClaudeR client configuration only with approval.
- For an agent that invokes Pandoc from Python, run `Rscript scripts/selftest.R --python /absolute/path/to/python` and use the reported absolute Pandoc path.
- R Markdown rendering needs `rmarkdown`, `knitr`, and Pandoc (system or RStudio-bundled).
- On Windows, let the self-test compile its C probe before any source package install. Use `--require-build-tools` only when source compilation is required; if it fails, consult the current CRAN Rtools page and never install Rtools without approval.

## Core Workflow

Before substantive analysis, clarify and record in `analysis_charter.md`: study design, dataset layout and row unit, unit of analysis, primary and secondary outcomes, endpoint and exposure definitions, comparison groups, and modelling purpose (inference, prediction, diagnostic accuracy, or description).

Each group of steps lives in its own stage file (see `references/component-project-layout.md`):

1. `010_load`: load the source data; understand record count and variable types.
2. `020_explore_clean`: check duplicates and missing data; agree how missing, unavailable, not-applicable, and ungradable observations are handled; apply approved cleaning.
3. `030_derive_label_freeze`: recode, categorize, and generate derived variables after approved definitions; apply labels; freeze the analytic dataset with source checksum, final N, exclusions, and definition version.
4. `100_table1`: simple background tables.
5. `110_` onward, one file per section: key outcomes first, then refined tables and supporting graphs, then deeper analysis only after the basics are agreed.

## Phase Report

End every phase by rendering that stage's `.Rmd` to HTML (or reviewing its raw log and native report for Stata), verifying technical consistency, and replying in this shape:

```text
Phase: <number and name>
Done: <what ran; output file paths>
N flow: <records/persons/eyes in -> out, with reasons for each drop>
Denominators: <per key result; persons vs eyes>
Checks: <warnings, inconsistencies, or "none">
Decisions needed: <numbered list of researcher choices, each with a proposed default>
Proposed next phase: <one line>
For your review: What do the results mean? Do they make clinical and statistical sense? Are Ns and denominators consistent? What does this imply for the next step?
```

Then stop and wait. Record each approved decision with its date in the decision log in `analysis_charter.md`.

## Non-Negotiables

- Use the staged layout: numbered prep stages, then one analysis file per section, each runnable on its own, with headings and subheadings. No master file.
- Keep immutable source data in `data/raw/`, derived data in `data/derived/`, frozen analytic data in `data/frozen/`, labelled exports in `data/exports/`, helpers in `R/`, figures in `figs/`, outputs in `results/`, and literature in `lit-review/`.
- Exclude the complete `data/` directory from Git. Keep patient-level data local, never upload or share it without explicit approval, and never put row-level identifiers in reports or figures.
- Never assume what a code means. Different surveys, survey versions, and exports use different codes for the same item (VA categories, lens status, cause, examination status). Build a codebook from this dataset's own value labels and protocol or questionnaire, confirm it with the researcher, then write every condition against labels, not integers. Codes in this skill's references are examples only.
- Do not define endpoints, exposures, or final analytic categories without researcher approval.
- Do not produce final Table 1, outcome tables, or models from raw or intermediate data.
- Use common, widely reported statistical methods and well-established packages: for example t-test/ANOVA, Wilcoxon/Kruskal-Wallis, chi-square/Fisher, linear/logistic/Poisson regression, Kaplan-Meier/Cox, GEE/mixed models, `survey`, `gtsummary`, `pROC`, `meta`/`metafor`, or native Stata commands. Do not propose obscure or niche tests, packages, or bespoke helpers when a standard method answers the question; if the design genuinely needs a less common method, say why and cite it before asking for approval.
- In exploratory analysis of continuous variables, compute both mean (SD) and median (p25, p75); agree final reporting and parametric/non-parametric tests with the researcher.
- Before regression, survival, ML/prediction, diagnostic-threshold optimization, survey-weighted analysis, meta-analysis, or complex repeated-measures models, state the proposed method and wait for approval.
- Use hierarchical tables with indented category/summary rows and only essential footnotes (details in `clinical-reporting-guidelines.md`).
- Record the seed and software versions: `sessionInfo()` in R; version and command/package availability in the Stata raw log.
- If RStudio MCP is unavailable, use direct `Rscript` with the same stage files, HTML rendering, and phase gates.
