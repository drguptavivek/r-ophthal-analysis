#!/usr/bin/env Rscript

script_arg <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
script_path <- sub("^--file=", "", script_arg[[1]])
repo_root <- normalizePath(file.path(dirname(script_path), ".."), mustWork = TRUE)
selftest <- file.path(repo_root, "scripts", "selftest.R")

if (!file.exists(selftest)) {
  stop("missing public self-test command: scripts/selftest.R", call. = FALSE)
}

output_file <- tempfile("r-ophthal-selftest-output-")
status <- system2(
  file.path(R.home("bin"), "Rscript"),
  c("--vanilla", shQuote(selftest)),
  stdout = output_file,
  stderr = output_file
)
output <- paste(readLines(output_file, warn = FALSE), collapse = "\n")

if (!identical(status, 0L)) stop(output, call. = FALSE)
stopifnot(grepl("Core skill checks: READY", output, fixed = TRUE))
stopifnot(grepl("Scaffold smoke test", output, fixed = TRUE))
stopifnot(grepl("Optional RStudio MCP", output, fixed = TRUE))
stopifnot(grepl("R executable", output, fixed = TRUE))
stopifnot(grepl("R library paths", output, fixed = TRUE))
stopifnot(grepl("Pandoc executable", output, fixed = TRUE))

python <- Sys.which("python3")
if (nzchar(python)) {
  pandoc_probe <- file.path(repo_root, "scripts", "check_pandoc.py")
  if (!file.exists(pandoc_probe)) {
    stop("missing dependency-free Python Pandoc probe", call. = FALSE)
  }
  python_output_file <- tempfile("r-ophthal-python-selftest-output-")
  python_status <- system2(
    file.path(R.home("bin"), "Rscript"),
    c("--vanilla", shQuote(selftest), "--python", shQuote(python)),
    stdout = python_output_file,
    stderr = python_output_file
  )
  python_output <- paste(readLines(python_output_file, warn = FALSE), collapse = "\n")
  if (!identical(python_status, 0L)) stop(python_output, call. = FALSE)
  stopifnot(grepl("Agent Python Pandoc access", python_output, fixed = TRUE))
}

cat("PASS: self-test reports core and optional readiness\n")
