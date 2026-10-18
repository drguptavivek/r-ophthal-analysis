#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
project_dir <- if (length(args) >= 1 && nzchar(args[[1]])) args[[1]] else getwd()
project_dir <- normalizePath(project_dir, mustWork = FALSE)

standard_dirs <- file.path(
  project_dir,
  c(
    "data/raw",
    "data/derived",
    "data/frozen",
    "data/exports",
    "R",
    "figs",
    "results",
    "lit-review"
  )
)
invisible(lapply(standard_dirs, dir.create, recursive = TRUE, showWarnings = FALSE))

gitignore_file <- file.path(project_dir, ".gitignore")
gitignore_lines <- if (file.exists(gitignore_file)) {
  readLines(gitignore_file, warn = FALSE)
} else {
  character()
}
if (!"/data/" %in% trimws(gitignore_lines)) {
  separator <- if (length(gitignore_lines) > 0L && nzchar(tail(gitignore_lines, 1L))) "" else character()
  writeLines(
    c(gitignore_lines, separator, "# Patient-level analysis data", "/data/"),
    gitignore_file
  )
  cat("Updated project .gitignore to exclude the complete data directory\n")
}

helper_file <- file.path(project_dir, "R", "analysis_guidelines.R")
helper_template <- c(
  "# Reusable clinical analysis and reporting helpers.",
  "# Source this file from the central R Markdown setup chunk:",
  "# source(\"R/analysis_guidelines.R\")",
  "",
  "format_1dp <- function(x) {",
  "  if (!is.numeric(x)) stop(\"x must be numeric\", call. = FALSE)",
  "  ifelse(is.na(x), NA_character_, formatC(x, format = \"f\", digits = 1))",
  "}",
  "",
  "format_3dp <- function(x) {",
  "  if (!is.numeric(x)) stop(\"x must be numeric\", call. = FALSE)",
  "  ifelse(is.na(x), NA_character_, formatC(x, format = \"f\", digits = 3))",
  "}",
  "",
  "format_p <- function(p) {",
  "  if (!is.numeric(p)) stop(\"p-values must be numeric\", call. = FALSE)",
  "  if (any(!is.na(p) & (p < 0 | p > 1))) {",
  "    stop(\"p-values must be between 0 and 1\", call. = FALSE)",
  "  }",
  "  ifelse(",
  "    is.na(p),",
  "    NA_character_,",
  "    ifelse(p < 0.001, \"<0.001\", formatC(p, format = \"f\", digits = 3))",
  "  )",
  "}",
  "",
  "format_ci <- function(estimate, lower, upper, digits = 1, suffix = \"\") {",
  "  values <- list(estimate = estimate, lower = lower, upper = upper)",
  "  if (!all(vapply(values, is.numeric, logical(1)))) {",
  "    stop(\"estimate and confidence limits must be numeric\", call. = FALSE)",
  "  }",
  "  lengths <- vapply(values, length, integer(1))",
  "  if (length(unique(lengths)) != 1L) {",
  "    stop(\"estimate and confidence limits must have equal lengths\", call. = FALSE)",
  "  }",
  "  invalid_order <- !is.na(lower) & !is.na(upper) & lower > upper",
  "  if (any(invalid_order)) stop(\"lower confidence limits cannot exceed upper limits\", call. = FALSE)",
  "  missing <- is.na(estimate) | is.na(lower) | is.na(upper)",
  "  result <- paste0(",
  "    formatC(estimate, format = \"f\", digits = digits), suffix,",
  "    \" (95% CI \", formatC(lower, format = \"f\", digits = digits),",
  "    \", \", formatC(upper, format = \"f\", digits = digits), \")\"",
  "  )",
  "  result[missing] <- NA_character_",
  "  result",
  "}",
  "",
  "format_percent_ci <- function(percent, lower, upper) {",
  "  values <- c(percent, lower, upper)",
  "  if (any(!is.na(values) & (values < 0 | values > 100))) {",
  "    stop(\"percentages and confidence limits must be between 0 and 100\", call. = FALSE)",
  "  }",
  "  format_ci(percent, lower, upper, digits = 1, suffix = \"%\")",
  "}",
  "",
  "check_n_consistency <- function(...) {",
  "  values <- unlist(list(...), use.names = TRUE)",
  "  if (length(values) == 0L) stop(\"provide at least one N\", call. = FALSE)",
  "  if (!is.numeric(values)) stop(\"N values must be numeric\", call. = FALSE)",
  "  if (any(!is.na(values) & (values < 0 | values != floor(values)))) {",
  "    stop(\"N values must be non-negative whole numbers\", call. = FALSE)",
  "  }",
  "  unique_values <- unique(stats::na.omit(values))",
  "  list(",
  "    values = values,",
  "    consistent = length(unique_values) <= 1L,",
  "    unique_values = unique_values",
  "  )",
  "}",
  "",
  "file_checksums <- function(paths) {",
  "  if (!is.character(paths) || length(paths) == 0L) {",
  "    stop(\"paths must contain at least one filename\", call. = FALSE)",
  "  }",
  "  if (any(!file.exists(paths))) stop(\"all source files must exist\", call. = FALSE)",
  "  information <- file.info(paths)",
  "  data.frame(",
  "    file = basename(paths),",
  "    bytes = unname(information$size),",
  "    md5 = unname(tools::md5sum(paths)),",
  "    stringsAsFactors = FALSE",
  "  )",
  "}",
  "",
  "table_note <- function(...) {",
  "  paste(..., collapse = \" \")",
  "}",
  "",
  "binary_label <- function(event_name) {",
  "  if (!is.character(event_name) || length(event_name) != 1L || !nzchar(event_name)) {",
  "    stop(\"event_name must be one non-empty label\", call. = FALSE)",
  "  }",
  "  c(\"0\" = paste(\"no\", event_name), \"1\" = event_name)",
  "}",
  "",
  "ordered_codes <- function(labels) {",
  "  if (!is.character(labels) || length(labels) == 0L || any(!nzchar(labels)) || anyDuplicated(labels)) {",
  "    stop(\"labels must be unique, non-empty text values\", call. = FALSE)",
  "  }",
  "  stats::setNames(seq_along(labels) - 1L, labels)",
  "}",
  "",
  "read_stage <- function(path) {",
  "  if (!file.exists(path)) {",
  "    stop(\"stage input not found: \", path, \"; render the stage that creates it first\", call. = FALSE)",
  "  }",
  "  readRDS(path)",
  "}",
  "",
  "write_freeze <- function(data, path, version, record = \"data/frozen/freeze_record.csv\") {",
  "  if (!is.data.frame(data)) stop(\"data must be a data frame\", call. = FALSE)",
  "  if (!is.character(version) || length(version) != 1L || !nzchar(version)) {",
  "    stop(\"version must be one non-empty label\", call. = FALSE)",
  "  }",
  "  saveRDS(data, path)",
  "  entry <- data.frame(",
  "    file = basename(path), version = version, n_rows = nrow(data), n_vars = ncol(data),",
  "    md5 = unname(tools::md5sum(path)), created = format(Sys.time(), \"%Y-%m-%d %H:%M:%S\"),",
  "    stringsAsFactors = FALSE",
  "  )",
  "  previous <- if (file.exists(record)) utils::read.csv(record, stringsAsFactors = FALSE) else NULL",
  "  utils::write.csv(rbind(previous, entry), record, row.names = FALSE)",
  "  invisible(entry)",
  "}",
  "",
  "read_frozen <- function(path, record = \"data/frozen/freeze_record.csv\") {",
  "  if (!file.exists(path)) stop(\"frozen dataset not found: \", path, call. = FALSE)",
  "  if (!file.exists(record)) stop(\"freeze record not found: \", record, call. = FALSE)",
  "  entries <- utils::read.csv(record, stringsAsFactors = FALSE)",
  "  entries <- entries[entries$file == basename(path), , drop = FALSE]",
  "  if (nrow(entries) == 0L) stop(\"no freeze record for \", basename(path), call. = FALSE)",
  "  latest <- entries[nrow(entries), ]",
  "  if (!identical(unname(tools::md5sum(path)), latest$md5)) {",
  "    stop(\"frozen dataset checksum does not match the freeze record: \", basename(path), call. = FALSE)",
  "  }",
  "  data <- readRDS(path)",
  "  if (nrow(data) != latest$n_rows) stop(\"frozen dataset N does not match the freeze record\", call. = FALSE)",
  "  attr(data, \"freeze\") <- latest",
  "  data",
  "}"
)

if (file.exists(helper_file)) {
  cat("Analysis guidelines file already exists; preserved:", helper_file, "\n")
} else {
  writeLines(helper_template, helper_file)
  cat("Created analysis guidelines file:", helper_file, "\n")
}

rmd_header <- function(title) {
  c(
    "---",
    paste0("title: \"", title, "\""),
    "output:",
    "  html_document:",
    "    toc: true",
    "    toc_float:",
    "      collapsed: false",
    "    toc_depth: 3",
    "    number_sections: false",
    "    code_folding: hide",
    "    df_print: kable",
    "---",
    "",
    "```{r setup}",
    "knitr::opts_chunk$set(echo = knitr::is_html_output(), message = FALSE, warning = TRUE, comment = NA)",
    "source(\"R/analysis_guidelines.R\")",
    "analysis_seed <- 20260725L",
    "set.seed(analysis_seed)",
    "```",
    ""
  )
}

session_footer <- c(
  "",
  "# Reproducibility record",
  "",
  "```{r session-info}",
  "sessionInfo()",
  "```"
)

project_files <- list(
  "analysis_charter.md" = c(
    "# Analysis charter",
    "",
    "> Complete with the researcher before substantive analysis. Not rendered; every stage follows it.",
    "",
    "- Study design: **TO CONFIRM**",
    "- Dataset row unit: **TO CONFIRM**",
    "- Unit of analysis: **TO CONFIRM**",
    "- Analysis population and exclusions: **TO CONFIRM**",
    "- Primary outcome and endpoint definition: **TO CONFIRM**",
    "- Secondary outcomes: **TO CONFIRM**",
    "- Exposure and comparison groups: **TO CONFIRM**",
    "- Modelling purpose: **TO CONFIRM**",
    "",
    "## Data governance",
    "",
    "All files under `data/` are excluded from Git. Keep patient-level data local. Do not upload or share patient-level data without explicit approval. Do not place row-level identifiers in reports or figures.",
    "",
    "## Decision log",
    "",
    "| Date | Stage | Decision | Approved by |",
    "| --- | --- | --- | --- |"
  ),
  "010_load.Rmd" = c(
    rmd_header("010 Load source data"),
    "# Source-data provenance",
    "",
    "<!-- Import files from data/raw/. Record filename, date received, row unit, record count, and import assumptions. Use file_checksums() without printing patient-level content. -->",
    "",
    "# Save stage output",
    "",
    "<!-- saveRDS(loaded, \"data/derived/010_loaded.rds\") -->",
    session_footer
  ),
  "020_explore_clean.Rmd" = c(
    rmd_header("020 Explore and clean"),
    "<!-- loaded <- read_stage(\"data/derived/010_loaded.rds\") -->",
    "",
    "# Initial data audit",
    "",
    "<!-- Record and variable counts, variable classes, candidate identifiers, duplicates, unusual values, impossible dates, unit inconsistencies. -->",
    "",
    "# Codebook verification",
    "",
    "<!-- Every categorical variable: codes, value labels, counts, and meaning confirmed against this survey's own protocol or questionnaire. Flag unlabelled codes and missing-value codes. Researcher confirms before any recode. -->",
    "",
    "# Missing-data assessment and plan",
    "",
    "<!-- Distinguish unavailable, not applicable, ungradable, and structurally missing observations by outcome, exposure, eye, visit, and group. Record the approved strategy in the charter decision log. -->",
    "",
    "# Cleaning decisions",
    "",
    "<!-- Each approved fix: old value, new value, affected N, verification check. -->",
    "",
    "# Save stage output",
    "",
    "<!-- saveRDS(clean, \"data/derived/020_clean.rds\") -->",
    session_footer
  ),
  "030_derive_label_freeze.Rmd" = c(
    rmd_header("030 Derive, label and freeze"),
    "<!-- clean <- read_stage(\"data/derived/020_clean.rds\") -->",
    "",
    "# Derived variables and recodes",
    "",
    "<!-- Each approved definition: source variables, rule, coding, affected N, cross-tab check. -->",
    "",
    "# Labels",
    "",
    "<!-- Variable labels with units and value labels in clinical order. -->",
    "",
    "# Analytic-dataset freeze",
    "",
    "<!-- write_freeze(analytic, \"data/frozen/analytic_v1.rds\", version = \"v1\"); export labelled .dta/.sav to data/exports/. Record row unit, final N, exclusions and definition version. -->",
    session_footer
  ),
  "100_table1.Rmd" = c(
    rmd_header("100 Table 1"),
    "```{r load-frozen}",
    "# analytic <- read_frozen(\"data/frozen/analytic_v1.rds\")",
    "```",
    "",
    "# Participant characteristics",
    "",
    "<!-- Hierarchical, indented table; observed N and group denominators; at most one short note. Copy this file to 110_, 120_ ... for each further analysis section. -->",
    session_footer
  )
)

for (name in names(project_files)) {
  target <- file.path(project_dir, name)
  if (file.exists(target)) {
    cat("Existing file preserved:", target, "\n")
  } else {
    writeLines(project_files[[name]], target)
    cat("Created:", target, "\n")
  }
}

cat("Ensured folders: data/raw, data/derived, data/frozen, data/exports, R, figs, results, lit-review\n")
