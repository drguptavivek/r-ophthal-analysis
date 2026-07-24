# Ophthalmology Clinical Analysis Workflow

Use the main `SKILL.md` as the coordinator when helping an ophthalmologist analyze clinical research datasets. Use the RStudio MCP connection when available, with direct `Rscript` as the reproducible fallback.

Load the relevant components directly from the main skill:

- `component-data-management.md` for phased analysis, dataset audit, recoding, and analytic dataset freeze.
- `clinical-reporting-guidelines.md` for manuscript table/figure style, decimal places, confidence intervals, and publication formatting.

Do not begin substantive analysis until the study design, data layout, key outcomes, comparison groups, and unit of analysis are understood and recorded in the central `.Rmd`.

Stop after each substantive phase and wait for explicit user confirmation before continuing.
