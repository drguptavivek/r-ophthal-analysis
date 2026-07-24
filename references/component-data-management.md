# Component: Data Management

Use this component for project setup, package setup, loading source data, variable type audit, duplicates, missingness, recoding, labels, Stata/SPSS exports, and analytic dataset freeze.

## Standard Layout

- `data/raw/`: immutable source files. Never overwrite them during cleaning or analysis.
- `data/derived/`: reproducible intermediate and cleaned datasets.
- `data/frozen/`: versioned analytic datasets used for final tables and models.
- `data/exports/`: labelled `.dta`/`.sav` exports and optional CSV interoperability copies.
- `R/`: reusable helpers and `analysis_guidelines.R`.
- `figs/`: exported figures.
- `results/`: rendered reports, tables, model summaries, and final outputs.
- `lit-review/`: source papers, older literature, and review notes.

Scaffold folders and helper file:

```bash
Rscript scripts/scaffold_analysis_guidelines.R /path/to/project
```

The scaffold adds `/data/` to the analysis project's `.gitignore`. Keep all patient-level datasets under `data/`, keep them local, and do not upload or share them without explicit approval. Do not place row-level identifiers in reports or figures.

Install/check packages from a clean R session or the setup chunk of the central `.Rmd` after discussing with the user. Common package families include `tidyverse`, `readxl`, `haven`, `janitor`, `rmarkdown`, `gt`, `gtsummary`, `flextable`, `broom`, `epiR`, `survival`, `survey`, `lme4`, `geepack`, `pROC`, `yardstick`, `meta`, `metafor`, and `ggplot2`.

## Initial Data Audit

In the central `.Rmd`, report record count, variable count, row unit, candidate IDs, variable classes, duplicate rows, duplicated identifiers, missingness, unusual values, impossible dates, and unit inconsistencies. Record source filenames, checksums, dates received, and import assumptions without printing patient-level content.

Read `clinical-variable-coding.md` before recoding, labelling, or exporting and `component-missing-data.md` before deciding how missing observations enter analysis. Before final tables and models, freeze the analytic dataset and record the freeze identifier, source checksums, row unit, final N, exclusions, endpoint-definition version, creation date, and frozen filename.
