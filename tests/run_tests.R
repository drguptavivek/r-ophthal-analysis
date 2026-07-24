#!/usr/bin/env Rscript

script_arg <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
script_path <- sub("^--file=", "", script_arg[[1]])
repo_root <- normalizePath(file.path(dirname(script_path), ".."), mustWork = TRUE)
test_files <- file.path(repo_root, "tests", c("test_scaffold.R", "test_selftest.R"))

for (test_file in test_files) {
  cat("Running", basename(test_file), "\n")
  status <- system2(
    file.path(R.home("bin"), "Rscript"),
    c("--vanilla", shQuote(test_file))
  )
  if (!identical(status, 0L)) {
    stop(basename(test_file), " failed with status ", status, call. = FALSE)
  }
}

cat("All base-R tests passed\n")
