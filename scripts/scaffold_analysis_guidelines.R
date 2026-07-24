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
  "}"
)

if (file.exists(helper_file)) {
  cat("Analysis guidelines file already exists; preserved:", helper_file, "\n")
} else {
  writeLines(helper_template, helper_file)
  cat("Created analysis guidelines file:", helper_file, "\n")
}

analysis_file <- file.path(project_dir, "analysis.Rmd")
analysis_template <- c(
  "---",
  "title: \"Ophthalmology clinical analysis\"",
  "output:",
  "  html_document:",
  "    toc: true",
  "    toc_depth: 3",
  "---",
  "",
  "# Analysis charter",
  "",
  "> Complete this section with the researcher before substantive analysis.",
  "",
  "- Study design: **TO CONFIRM**",
  "- Dataset row unit: **TO CONFIRM**",
  "- Unit of analysis: **TO CONFIRM**",
  "- Analysis population and exclusions: **TO CONFIRM**",
  "- Primary outcome and endpoint definition: **TO CONFIRM**",
  "- Secondary outcomes: **TO CONFIRM**",
  "- Exposure and comparison groups: **TO CONFIRM**",
  "- Modelling purpose: **TO CONFIRM**",
  "- Researcher approval date: **TO CONFIRM**",
  "",
  "# Data governance",
  "",
  "All files under `data/` are excluded from Git. Keep patient-level data local. Do not upload or share patient-level data without explicit approval. Do not place row-level identifiers in reports or figures.",
  "",
  "# Reproducibility setup",
  "",
  "```{r setup}",
  "knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning = TRUE)",
  "source(\"R/analysis_guidelines.R\")",
  "analysis_seed <- 20260725L",
  "set.seed(analysis_seed)",
  "```",
  "",
  "# Source-data provenance",
  "",
  "Record each source filename, date received, checksum, row unit, record count, and any import assumptions. Use `file_checksums()` without printing patient-level content.",
  "",
  "# Initial data audit",
  "",
  "Report record and variable counts, variable classes, candidate identifiers, duplicates, missingness, unusual values, impossible dates, and unit inconsistencies.",
  "",
  "# Missing-data assessment and plan",
  "",
  "Distinguish unavailable, not applicable, ungradable, and structurally missing observations. Summarize missingness by outcome, exposure, predictor, eye, visit, and comparison group as relevant. Record the approved analysis and sensitivity strategy before modelling.",
  "",
  "# Cleaning and recoding decisions",
  "",
  "Record each approved definition, old and new coding, rationale, affected N, and verification check.",
  "",
  "# Analytic-dataset freeze",
  "",
  "Before final tables or models, record the freeze identifier, source checksums, row unit, final N, exclusions, endpoint-definition version, creation date, and frozen filename under `data/frozen/`.",
  "",
  "# Background characteristics",
  "",
  "# Key outcomes",
  "",
  "# Figures",
  "",
  "# Approved deeper analyses",
  "",
  "# Interpretation notes",
  "",
  "# Reproducibility record",
  "",
  "```{r session-info}",
  "sessionInfo()",
  "```"
)

if (file.exists(analysis_file)) {
  cat("Central analysis file already exists; preserved:", analysis_file, "\n")
} else {
  writeLines(analysis_template, analysis_file)
  cat("Created central analysis file:", analysis_file, "\n")
}

cat("Ensured folders: data/raw, data/derived, data/frozen, data/exports, R, figs, results, lit-review\n")
