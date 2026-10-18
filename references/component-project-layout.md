# Component: Staged Project Layout

Load this when setting up a project, adding a stage or analysis section, or translating a legacy project. R and Stata use the same layout.

## Stages

Split work into numbered files so each stays manageable. Number in gaps of 10 so new files fit between existing ones later.

| File | Purpose | Reads | Writes |
| --- | --- | --- | --- |
| `analysis_charter.md` | Charter and dated decision log; not run | | |
| `010_load` | Import raw files, record checksums | `data/raw/` | `data/derived/010_loaded` |
| `020_explore_clean` | Audit, duplicates, missingness, approved cleaning | `010` output | `data/derived/020_clean` |
| `030_derive_label_freeze` | Derived variables, recodes, labels, freeze, labelled exports | `020` output | `data/frozen/analytic_v1`, `data/exports/` |
| `100_table1` | Analysis section | frozen dataset only | `results/`, `figs/` |
| `110_primary_outcome`, `120_...` | One file per further analysis section | frozen dataset only | `results/`, `figs/` |

Extensions are `.Rmd` for R and `.do` for Stata. Add a prep stage such as `015_merge_visits` or an analysis such as `115_sensitivity` without renumbering.

## Independent Runs

There is no master file. Each file must run on its own:

- Start from a clean session; set the seed and record software versions in that file.
- Read only the saved output of an earlier stage, never objects left in memory. Stop with a clear message if that input is missing.
- Write one rendered report (R) or one raw text log (Stata) per file to `results/`, named after the file.
- Never let an analysis file read `data/raw/` or `data/derived/`. Final tables and models come only from the frozen dataset.

## Freeze Handoff

- R: `030` calls `write_freeze(analytic, "data/frozen/analytic_v1.rds", version = "v1")`, which saves the data and appends file, version, N, variable count, MD5 and time to `data/frozen/freeze_record.csv`. Every analysis file starts with `analytic <- read_frozen("data/frozen/analytic_v1.rds")`, which stops if the checksum or N does not match the record. Both helpers are in the scaffolded `R/analysis_guidelines.R`.
- Stata: `030` runs `datasignature set, reset` before `save "data/frozen/analytic_v1.dta", replace` and notes the expected N. Every analysis do-file starts with `use "data/frozen/analytic_v1.dta", clear`, `datasignature confirm`, and `assert _N == <frozen N>`.
- A new definition creates a new version (`analytic_v2`); never overwrite a frozen file that analyses have used. Record the change in the charter decision log and rerun every analysis file that depends on it.

## Phase Gates

Prep stages gate at each step: audit, missing-data plan, recodes, freeze. Analysis files gate once per section. Render or run only the file being worked on, then give the Phase Report from `SKILL.md`.

Related: `component-data-management.md`, `component-rmd-reporting.md`, `component-stata-reporting.md`, `legacy-stata-translation.md`.
