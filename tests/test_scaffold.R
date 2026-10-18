#!/usr/bin/env Rscript

`%||%` <- function(x, y) {
  if (is.null(x) || !nzchar(x)) y else x
}

script_arg <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
script_path <- sub("^--file=", "", script_arg[[1]] %||% "tests/test_scaffold.R")
repo_root <- normalizePath(file.path(dirname(script_path), ".."), mustWork = TRUE)

run_scaffold <- function(project_dir) {
  script <- file.path(repo_root, "scripts", "scaffold_analysis_guidelines.R")
  status <- system2(file.path(R.home("bin"), "Rscript"), c("--vanilla", shQuote(script), shQuote(project_dir)))
  if (!identical(status, 0L)) {
    stop("scaffold command failed with status ", status, call. = FALSE)
  }
}

expect_error <- function(expression, pattern) {
  message <- tryCatch(
    {
      force(expression)
      NULL
    },
    error = function(condition) conditionMessage(condition)
  )
  if (is.null(message) || !grepl(pattern, message, fixed = TRUE)) {
    stop("expected error containing: ", pattern, call. = FALSE)
  }
}

project_dir <- tempfile("r-ophthal-scaffold-test-")
dir.create(project_dir)
writeLines("/custom-output/", file.path(project_dir, ".gitignore"))
run_scaffold(project_dir)

helpers <- new.env(parent = baseenv())
sys.source(file.path(project_dir, "R", "analysis_guidelines.R"), envir = helpers)

stopifnot(identical(helpers$format_p(c(0.5, NA_real_)), c("0.500", NA_character_)))
expect_error(helpers$format_p(-0.1), "p-values must be between 0 and 1")
expect_error(helpers$format_p(1.2), "p-values must be between 0 and 1")
stopifnot(identical(helpers$format_ci(1.4, 1.1, 1.8), "1.4 (95% CI 1.1, 1.8)"))
stopifnot(is.na(helpers$format_ci(NA_real_, 1.1, 1.8)))
expect_error(helpers$format_ci(1.4, 1.9, 1.8), "lower confidence limits cannot exceed upper limits")
expect_error(helpers$format_percent_ci(101, 90, 100), "between 0 and 100")
expect_error(helpers$check_n_consistency(), "provide at least one N")
expect_error(helpers$check_n_consistency(10, -1), "non-negative whole numbers")

source_file <- file.path(project_dir, "source-file.txt")
writeLines("synthetic test content", source_file)
manifest <- helpers$file_checksums(source_file)
stopifnot(identical(manifest$file, "source-file.txt"))
stopifnot(nchar(manifest$md5) == 32L)

old_wd <- setwd(project_dir)
frozen <- data.frame(id = 1:3, eye = c(1L, 2L, 1L))
helpers$write_freeze(frozen, "data/frozen/analytic_v1.rds", version = "v1")
stopifnot(identical(nrow(helpers$read_frozen("data/frozen/analytic_v1.rds")), 3L))
saveRDS(frozen[1:2, ], "data/frozen/analytic_v1.rds")
expect_error(helpers$read_frozen("data/frozen/analytic_v1.rds"), "checksum does not match")
expect_error(helpers$read_stage("data/derived/missing.rds"), "render the stage that creates it")
setwd(old_wd)

cat("PASS: reporting helpers validate publication inputs\n")

expected_dirs <- file.path(
  project_dir,
  c("data/raw", "data/derived", "data/frozen", "data/exports", "R", "figs", "results", "lit-review")
)
stopifnot(all(dir.exists(expected_dirs)))
stage_files <- c("analysis_charter.md", "010_load.Rmd", "020_explore_clean.Rmd",
                 "030_derive_label_freeze.Rmd", "100_table1.Rmd")
stopifnot(all(file.exists(file.path(project_dir, stage_files))))
clean_text <- paste(readLines(file.path(project_dir, "020_explore_clean.Rmd"), warn = FALSE), collapse = "\n")
freeze_text <- paste(readLines(file.path(project_dir, "030_derive_label_freeze.Rmd"), warn = FALSE), collapse = "\n")
stopifnot(grepl("# Missing-data assessment and plan", clean_text, fixed = TRUE))
stopifnot(grepl("# Analytic-dataset freeze", freeze_text, fixed = TRUE))
stopifnot(grepl("toc_float", freeze_text, fixed = TRUE))
stopifnot(grepl("code_folding: hide", freeze_text, fixed = TRUE))
stopifnot(grepl("sessionInfo()", freeze_text, fixed = TRUE))

ignore_lines <- readLines(file.path(project_dir, ".gitignore"), warn = FALSE)
stopifnot("/custom-output/" %in% ignore_lines)
stopifnot("/data/" %in% ignore_lines)

writeLines("USER ANALYSIS CONTENT", file.path(project_dir, "100_table1.Rmd"))
writeLines("USER HELPER CONTENT", file.path(project_dir, "R", "analysis_guidelines.R"))
run_scaffold(project_dir)
stopifnot(identical(readLines(file.path(project_dir, "100_table1.Rmd")), "USER ANALYSIS CONTENT"))
stopifnot(identical(readLines(file.path(project_dir, "R", "analysis_guidelines.R")), "USER HELPER CONTENT"))
ignore_lines_after_rerun <- readLines(file.path(project_dir, ".gitignore"), warn = FALSE)
stopifnot(sum(trimws(ignore_lines_after_rerun) == "/data/") == 1L)

cat("PASS: scaffold creates the project contract and preserves existing files\n")
