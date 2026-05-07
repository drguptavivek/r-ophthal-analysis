# Component: Data Management

Use this component for project setup, package setup, loading source data, variable type audit, duplicates, missingness, recoding, labels, Stata/SPSS exports, and analytic dataset freeze.

## Standard Layout

- `data/`: raw data, cleaned data, frozen analytic datasets, labelled `.dta`/`.sav` exports, optional CSV copies.
- `R/`: reusable helpers and `analysis_guidelines.R`.
- `figs/`: exported figures.
- `results/`: rendered reports, tables, model summaries, and final outputs.
- `lit-review/`: source papers, older literature, and review notes.

Scaffold folders and helper file:

```bash
Rscript scripts/scaffold_analysis_guidelines.R /path/to/project
```

Install/check packages from a clean R session or the setup chunk of the central `.Rmd` after discussing with the user. Common package families include `tidyverse`, `readxl`, `haven`, `janitor`, `rmarkdown`, `gt`, `gtsummary`, `flextable`, `broom`, `epiR`, `survival`, `survey`, `lme4`, `geepack`, `pROC`, `yardstick`, `meta`, `metafor`, and `ggplot2`.

## Initial Data Audit

In the central `.Rmd`, report record count, variable count, row unit, candidate IDs, variable classes, duplicate rows, duplicated identifiers, missingness, unusual values, impossible dates, and unit inconsistencies.

Read `clinical-variable-coding.md` before recoding, labelling, or exporting. Freeze the analytic dataset before final tables and models.
