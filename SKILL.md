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
- Data management: `references/component-data-management.md`, then `references/clinical-variable-coding.md` if recoding/exporting.
- R Markdown/reporting: `references/component-rmd-reporting.md`, then `references/clinical-reporting-guidelines.md` before any table/figure/result.
- Ophthalmology definitions: `references/component-ophthalmology.md`, then `references/clinical-ophthalmology-guidelines.md` when defining eye/person outcomes.
- WHO ECIM indicators: `references/component-who-ecim-indicators.md`, then `references/who-ecim-indicator-formulas.md` for WHO ECIM eCSC/eREC indicators and their CSC/REC companion formulas.
- Study designs and modelling: `references/component-study-designs.md`, then the relevant design reference only.

For portability, keep this whole folder as the repo. The only bundled script is optional project scaffolding: `scripts/scaffold_analysis_guidelines.R`, resolved relative to this skill root.

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
5. Recode and clean variables after approved definitions.
6. Categorize and generate derived variables.
7. Freeze the analytic dataset.
8. Build simple background tables.
9. Estimate key outcomes.
10. Refine tables and supporting graphs.
11. Move to deeper analysis only after the basics are agreed.

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
- Keep source data in `data/`, helper R code in `R/`, figures in `figs/`, outputs in `results/`, and literature in `lit-review/`.
- Do not define endpoints, exposures, or final analytic categories without researcher approval.
- Do not produce final Table 1, outcome tables, or models from raw or intermediate data.
- In exploratory analysis of continuous variables, compute both mean (SD) and median (p25, p75). Decide final reporting and parametric/non-parametric tests with the researcher.
- Before regression, survival, ML/prediction, diagnostic-threshold optimization, survey-weighted analysis, meta-analysis, or complex repeated-measures models, state the proposed method and wait for approval.
- If RStudio MCP is unavailable, use direct `Rscript` while preserving the same `.Rmd`, HTML rendering, and phase gates.
