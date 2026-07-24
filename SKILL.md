---
name: r-ophthal-analysis
description: One portable skill for stepwise ophthalmology clinical research analysis in R/R Markdown. Use for RStudio/ClaudeR MCP setup, Rscript fallback, project setup, data audit, recoding, analytic dataset freeze, eye-wise/person-wise ophthalmology definitions, study-design-specific analysis, R Markdown rendering, publication tables, figures, and labelled Stata/SPSS exports.
---

# R Ophthal Analysis

## Role

Use this as the coordinating skill for ophthalmology clinical research analysis. Keep the researcher in charge: AI suggestions are proposals, not decisions.

Work one phase at a time. Do not move to the next substantive phase until the researcher confirms.

## Components

This is one skill with internal components. Load only the component reference needed for the current task:

- MCP/setup: `references/component-mcp.md`, then `references/local-config.md` if needed.
- Data management: `references/component-data-management.md`, then `references/clinical-variable-coding.md` if recoding/exporting and `references/component-missing-data.md` when deciding how missing observations enter analysis.
- R Markdown/reporting: `references/component-rmd-reporting.md`, then `references/clinical-reporting-guidelines.md` before any table/figure/result.
- Ophthalmology definitions: `references/component-ophthalmology.md`, then `references/clinical-ophthalmology-guidelines.md` when defining eye/person outcomes.
- WHO ECIM indicators: `references/component-who-ecim-indicators.md`, then `references/who-ecim-indicator-formulas.md` for WHO ECIM eCSC/eREC indicators and their CSC/REC companion formulas.
- Study designs and modelling: `references/component-study-designs.md`, then the relevant design reference only.

For portability, keep this whole folder as the repo. Use `scripts/scaffold_analysis_guidelines.R` for optional project scaffolding and `scripts/selftest.R` for a dependency-free readiness check, resolving both relative to this skill root.

## Runtime Preflight

Before the first R execution or environment-setup action in a task, run `Rscript scripts/selftest.R`. It reports the active R version, `Rscript` and library paths, package build locations, Pandoc, and optional RStudio MCP readiness without installing anything.

- When R has been upgraded, moved, or starts loading a different library, run `Rscript scripts/selftest.R --check-updates`. Review the result with the user; never update R or packages automatically. After a major/minor R change, recheck required packages and rerun ClaudeR client configuration only with approval because R library paths may change.
- For an agent that will invoke Pandoc from Python, pass that exact interpreter to the self-test: `Rscript scripts/selftest.R --python /absolute/path/to/python`. The check uses `scripts/check_pandoc.py`, which requires only the Python standard library. Use the reported absolute Pandoc executable rather than assuming it is on the Python sandbox's `PATH`.
- R Markdown rendering requires `rmarkdown`, `knitr`, and an executable Pandoc. The self-test also discovers Pandoc bundled with RStudio through `rmarkdown::find_pandoc()`.

## Core Workflow

Before substantive analysis, clarify and record in the central `.Rmd`:

- study design
- dataset layout and row unit
- unit of analysis
- primary and secondary outcomes
- endpoint definitions
- exposure definitions
- comparison groups
- modelling purpose: inference, prediction, diagnostic accuracy, or description

Follow this sequence:

1. Load initial dataset.
2. Understand record count and variable types.
3. Check duplicates.
4. Check missing data.
5. Agree how missing, unavailable, not-applicable, and ungradable observations will be handled.
6. Recode and clean variables after approved definitions.
7. Categorize and generate derived variables.
8. Freeze the analytic dataset with a recorded source checksum, final N, exclusions, and definition version.
9. Build simple background tables.
10. Estimate key outcomes.
11. Refine tables and supporting graphs.
12. Move to deeper analysis only after the basics are agreed.

At each step, render the `.Rmd` to HTML and review:

- What do the results mean?
- Do they make clinical and statistical sense?
- Are Ns and denominators consistent?
- What does this imply for the next step?

## User Workflow Translation Patterns

When modernizing or extending the user's older Stata ophthalmology projects, preserve the working-analysis style unless the user asks for a clean-room redesign:

- Treat numbered scripts as an execution map. Convert `00`, `01`, `05.2`, `10.2b`, etc. into ordered `.Rmd` sections or explicitly named helper functions.
- Preserve visible checkpoints. Replace repeated Stata `.dta` saves with deliberate cleaned and frozen datasets in `data/`, plus compact intermediate tables in `results/` when they are used for audit or manuscript review.
- Keep path setup portable. Do not copy hardcoded `cap cd` fallback blocks into R; use project-root detection and relative paths, but document any source path assumption in the setup section.
- Keep helper logic local and readable. Translate repeated Stata `program define` helpers into `R/` functions, source them from the central `.Rmd`, and keep function names close to the original analytic intent.
- Preserve survey design decisions. For RAAB-like work, explicitly map Stata `svyset`, FPC, cluster, district, age-sex standardization, DEFF, and weight variables into `survey` design objects before estimating results.
- Preserve table/figure auditability. Replace `log using`, `htput`, `htsummary`, `export excel`, and `graph export` with rendered `.Rmd` tables, saved workbook/table outputs, and figures in `figs/`, keeping denominators and footnotes adjacent to each result.
- Respect versioned trial/final variants. When multiple old scripts exist, identify the likely source-of-truth script with the user before consolidating, especially files named `NEW`, `final`, `trial`, `conflicted copy`, reviewer comments, or dated variants.
- Keep external Stata package assumptions visible when translating legacy code, for example `esttab`, `estout`, `metan`, or custom project helpers.

## Non-Negotiables

- Keep all commands, decisions, and results in one centralized `.Rmd`.
- Use headings and subheadings in the rendered report.
- Keep immutable source data in `data/raw/`, derived data in `data/derived/`, frozen analytic data in `data/frozen/`, labelled data exports in `data/exports/`, helper R code in `R/`, figures in `figs/`, outputs in `results/`, and literature in `lit-review/`.
- Exclude the complete `data/` directory from Git. Keep patient-level data local, do not upload or share it without explicit approval, and do not place row-level identifiers in reports or figures.
- Do not define endpoints, exposures, or final analytic categories without researcher approval.
- Do not produce final Table 1, outcome tables, or models from raw or intermediate data.
- In exploratory analysis of continuous variables, compute both mean (SD) and median (p25, p75). Decide final reporting and parametric/non-parametric tests with the researcher.
- Before regression, survival, ML/prediction, diagnostic-threshold optimization, survey-weighted analysis, meta-analysis, or complex repeated-measures models, state the proposed method and wait for approval.
- Record the analysis seed, relevant package versions, and `sessionInfo()` in the central report.
- If RStudio MCP is unavailable, use direct `Rscript` while preserving the same `.Rmd`, HTML rendering, and phase gates.
