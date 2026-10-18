# Component: Data Management

Use this component with `component-project-layout.md` for project setup, package setup, loading source data, variable type audit, duplicates, missingness, recoding, labels, Stata/SPSS exports, and analytic dataset freeze.

## Standard Layout

- `data/raw/`: immutable source files. Never overwrite them during cleaning or analysis.
- `data/derived/`: reproducible intermediate and cleaned datasets.
- `data/frozen/`: versioned analytic datasets used for final tables and models.
- `data/exports/`: labelled `.dta`/`.sav` exports and optional CSV interoperability copies.
- `R/`: reusable helpers and `analysis_guidelines.R`.
- `figs/`: exported figures.
- `results/`: rendered reports, tables, model summaries, and final outputs.
- `lit-review/`: source papers, older literature, and review notes.

Scaffold folders, helper file, charter, and stage templates (`010_load.Rmd`, `020_explore_clean.Rmd`, `030_derive_label_freeze.Rmd`, `100_table1.Rmd`):

```bash
Rscript scripts/scaffold_analysis_guidelines.R /path/to/project
```

The scaffold adds `/data/` to the analysis project's `.gitignore`. Keep all patient-level datasets under `data/`, keep them local, and do not upload or share them without explicit approval. Do not place row-level identifiers in reports or figures.

Install/check packages from a clean R session or the setup chunk of `010_load.Rmd` after discussing with the user. Common package families include `tidyverse`, `readxl`, `haven`, `janitor`, `rmarkdown`, `gt`, `gtsummary`, `flextable`, `broom`, `epiR`, `survival`, `survey`, `lme4`, `geepack`, `pROC`, `yardstick`, `meta`, `metafor`, and `ggplot2`.

## Initial Data Audit

In `010_load` and `020_explore_clean`, report record count, variable count, row unit, candidate IDs, variable classes, duplicate rows, duplicated identifiers, missingness, unusual values, impossible dates, and unit inconsistencies. Record source filenames, checksums, dates received, and import assumptions without printing patient-level content.

## Codebook Verification

Before any recode or derived variable, in `020_explore_clean`:

1. List every categorical variable with its codes, value labels, and counts (Stata `describe`, `label list`, `codebook`; R `haven::print_labels()` or `levels()` with `table(useNA = "ifany")`).
2. Match each code to the survey's own protocol, questionnaire, or data dictionary. Record the source document and version.
3. Flag unlabelled numeric categories, codes with zero counts, codes present in the data but absent from the labels, labels that differ between survey rounds or sites, and missing-value codes (for example 8, 9, 99, -1).
4. Write the confirmed codebook to `results/` and present it in the Phase Report for researcher confirmation.
5. Only then derive variables, writing conditions against labels (`clinical-variable-coding.md`). When pooling surveys, harmonise every survey to one confirmed codebook first.

Do not reuse code meanings from another survey, an older script, or this skill's examples without checking them against the current dataset.

Read `clinical-variable-coding.md` before recoding, labelling, or exporting and `component-missing-data.md` before deciding how missing observations enter analysis. Before final tables and models, freeze the analytic dataset in `030_derive_label_freeze` with `write_freeze()` (Stata: `datasignature set`) and record the freeze identifier, source checksums, row unit, final N, exclusions, endpoint-definition version, creation date, and frozen filename.

Related: `component-project-layout.md`, `clinical-variable-coding.md`, `component-missing-data.md`.
