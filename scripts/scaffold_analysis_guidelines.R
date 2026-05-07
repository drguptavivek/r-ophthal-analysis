#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
project_dir <- if (length(args) >= 1 && nzchar(args[[1]])) args[[1]] else getwd()
project_dir <- normalizePath(project_dir, mustWork = FALSE)

target_dir <- file.path(project_dir, "R")
target_file <- file.path(target_dir, "analysis_guidelines.R")

standard_dirs <- file.path(project_dir, c("data", "R", "figs", "results", "lit-review"))
invisible(lapply(standard_dirs, dir.create, recursive = TRUE, showWarnings = FALSE))

if (file.exists(target_file)) {
  cat("Analysis guidelines file already exists:", target_file, "\n")
  cat("Ensured standard folders: data, R, figs, results, lit-review\n")
  quit(status = 0)
}

template <- c(
  "# Reusable clinical analysis and reporting helpers.",
  "# Source this file from the central R Markdown setup chunk:",
  "# source(\"R/analysis_guidelines.R\")",
  "",
  "format_1dp <- function(x) {",
  "  ifelse(is.na(x), NA_character_, formatC(x, format = \"f\", digits = 1))",
  "}",
  "",
  "format_3dp <- function(x) {",
  "  ifelse(is.na(x), NA_character_, formatC(x, format = \"f\", digits = 3))",
  "}",
  "",
  "format_p <- function(p) {",
  "  ifelse(",
  "    is.na(p),",
  "    NA_character_,",
  "    ifelse(p < 0.001, \"<0.001\", formatC(p, format = \"f\", digits = 3))",
  "  )",
  "}",
  "",
  "format_ci <- function(estimate, lower, upper, digits = 1, suffix = \"\") {",
  "  est <- formatC(estimate, format = \"f\", digits = digits)",
  "  lo <- formatC(lower, format = \"f\", digits = digits)",
  "  hi <- formatC(upper, format = \"f\", digits = digits)",
  "  paste0(est, suffix, \" (95% CI \", lo, \", \", hi, \")\")",
  "}",
  "",
  "format_percent_ci <- function(percent, lower, upper) {",
  "  format_ci(percent, lower, upper, digits = 1, suffix = \"%\")",
  "}",
  "",
  "check_n_consistency <- function(...) {",
  "  values <- unlist(list(...), use.names = TRUE)",
  "  unique_values <- unique(stats::na.omit(values))",
  "  list(",
  "    values = values,",
  "    consistent = length(unique_values) <= 1,",
  "    unique_values = unique_values",
  "  )",
  "}",
  "",
  "table_note <- function(...) {",
  "  paste(..., collapse = \" \")",
  "}",
  "",
  "binary_label <- function(event_name) {",
  "  c(\"0\" = paste(\"no\", event_name), \"1\" = event_name)",
  "}",
  "",
  "ordered_codes <- function(labels) {",
  "  stats::setNames(seq_along(labels) - 1L, labels)",
  "}"
)

writeLines(template, target_file)
cat("Ensured standard folders: data, R, figs, results, lit-review\n")
cat("Created analysis guidelines file:", target_file, "\n")
cat("Add this to the setup chunk of the central Rmd: source(\"R/analysis_guidelines.R\")\n")
