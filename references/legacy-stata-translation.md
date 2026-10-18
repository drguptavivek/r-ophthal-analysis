# Translating Legacy Stata Projects to R

Load this only when translating the user's older Stata projects into R. Preserve the working-analysis style unless the user asks for a clean-room redesign. If the user requests native Stata instead, keep the do-file/log workflow in `component-stata-reporting.md`.

- Treat numbered scripts as an execution map. Map them onto the staged layout in `component-project-layout.md`: preparation scripts to `010`-`030` stages, analysis scripts to one `1x0_` file per section. Keep the original numbers in a mapping table in the charter.
- Preserve visible checkpoints. Replace repeated Stata `.dta` saves with deliberate cleaned and frozen datasets in `data/`, plus compact intermediate tables in `results/` when they are used for audit or manuscript review.
- Keep path setup portable. Do not copy hardcoded `cap cd` fallback blocks into R; use project-root detection and relative paths, but document any source path assumption in the setup section.
- Keep helper logic local and readable. Translate repeated Stata `program define` helpers into `R/` functions, source them from each stage file, and keep function names close to the original analytic intent.
- Preserve survey design decisions. For RAAB-like work, explicitly map Stata `svyset`, FPC, cluster, district, age-sex standardization, DEFF, and weight variables into `survey` design objects before estimating results.
- Preserve table/figure auditability. Replace `log using`, `htput`, `htsummary`, `export excel`, and `graph export` with rendered `.Rmd` tables, saved workbook/table outputs, and figures in `figs/`, keeping denominators and footnotes adjacent to each result.
- Respect versioned trial/final variants. When multiple old scripts exist, identify the likely source-of-truth script with the user before consolidating, especially files named `NEW`, `final`, `trial`, `conflicted copy`, reviewer comments, or dated variants.
- Replace positional `r(table)` helpers (for example `clustercibysex`-style programs reading `all[3,1]`) with `svyprev` (Stata) or `svy_prevalence()` (R) from `clinical-survey-prevalence.md`, and map `htput`/`htsummary`/`htopen` output to `collect`/`putdocx` or `flextable`.
- Keep external Stata package assumptions visible when translating legacy code, for example `esttab`, `estout`, `metan`, or custom project helpers.
- Reproduce key legacy numbers (N, main prevalences, model estimates) in R before extending the analysis, and list any discrepancy for the researcher.

Related: `component-project-layout.md`, `clinical-survey-prevalence.md`, `component-stata-reporting.md`.
