#!/usr/bin/env Rscript

script_arg <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
script_path <- normalizePath(sub("^--file=", "", script_arg[[1]]), mustWork = TRUE)
repo_root <- normalizePath(file.path(dirname(script_path), ".."), mustWork = TRUE)

checks <- list()

add_check <- function(name, status, detail, required = FALSE) {
  checks[[length(checks) + 1L]] <<- list(
    name = name,
    status = status,
    detail = detail,
    required = required
  )
}

run_scaffold_smoke_test <- function() {
  project_dir <- tempfile("r-ophthal-selftest-")
  dir.create(project_dir)
  scaffold <- file.path(repo_root, "scripts", "scaffold_analysis_guidelines.R")
  output <- system2(
    file.path(R.home("bin"), "Rscript"),
    c("--vanilla", shQuote(scaffold), shQuote(project_dir)),
    stdout = TRUE,
    stderr = TRUE
  )
  status <- attr(output, "status")
  if (!is.null(status) && status != 0L) {
    stop(paste(output, collapse = "\n"), call. = FALSE)
  }

  expected <- c(
    "analysis.Rmd",
    "R/analysis_guidelines.R",
    "data/raw",
    "data/derived",
    "data/frozen",
    "data/exports",
    "figs",
    "results",
    "lit-review"
  )
  missing <- expected[!file.exists(file.path(project_dir, expected))]
  if (length(missing) > 0L) {
    stop("missing scaffold outputs: ", paste(missing, collapse = ", "), call. = FALSE)
  }
  ignore_lines <- readLines(file.path(project_dir, ".gitignore"), warn = FALSE)
  if (!"/data/" %in% trimws(ignore_lines)) {
    stop("generated project does not ignore the complete data directory", call. = FALSE)
  }
  invisible(TRUE)
}

cat("R Ophthal Analysis self-test\n")
cat("============================\n")

add_check("R runtime", "PASS", paste(R.version$major, R.version$minor, sep = "."), required = TRUE)

skill_file <- file.path(repo_root, "SKILL.md")
if (!file.exists(skill_file)) {
  add_check("Skill entrypoint", "FAIL", "SKILL.md is missing", required = TRUE)
} else {
  skill_text <- paste(readLines(skill_file, warn = FALSE), collapse = "\n")
  matches <- regmatches(
    skill_text,
    gregexpr("`((references|scripts)/[^`]+)`", skill_text, perl = TRUE)
  )[[1]]
  referenced_paths <- if (identical(matches, "")) character() else gsub("`", "", matches, fixed = TRUE)
  missing_references <- referenced_paths[!file.exists(file.path(repo_root, referenced_paths))]
  if (length(missing_references) > 0L) {
    add_check(
      "Skill entrypoint",
      "FAIL",
      paste("missing:", paste(missing_references, collapse = ", ")),
      required = TRUE
    )
  } else {
    add_check("Skill entrypoint", "PASS", "SKILL.md and routed files are present", required = TRUE)
  }
}

scaffold_file <- file.path(repo_root, "scripts", "scaffold_analysis_guidelines.R")
syntax_error <- tryCatch(
  {
    parse(file = scaffold_file)
    NULL
  },
  error = function(condition) conditionMessage(condition)
)
if (is.null(syntax_error)) {
  add_check("Scaffold syntax", "PASS", "base-R script parses", required = TRUE)
} else {
  add_check("Scaffold syntax", "FAIL", syntax_error, required = TRUE)
}

smoke_error <- tryCatch(
  {
    run_scaffold_smoke_test()
    NULL
  },
  error = function(condition) conditionMessage(condition)
)
if (is.null(smoke_error)) {
  add_check("Scaffold smoke test", "PASS", "project contract created in a disposable directory", required = TRUE)
} else {
  add_check("Scaffold smoke test", "FAIL", smoke_error, required = TRUE)
}

pandoc_path <- Sys.which("pandoc")
quarto_path <- Sys.which("quarto")
if (nzchar(pandoc_path) || nzchar(quarto_path)) {
  renderer <- if (nzchar(pandoc_path)) pandoc_path else quarto_path
  add_check("Report renderer", "PASS", renderer)
} else {
  add_check("Report renderer", "WARN", "Pandoc or Quarto is needed to render reports")
}

for (package in c("rmarkdown", "knitr")) {
  if (requireNamespace(package, quietly = TRUE)) {
    add_check(paste("R package", package), "PASS", as.character(utils::packageVersion(package)))
  } else {
    add_check(paste("R package", package), "WARN", "not installed; required only for R Markdown rendering")
  }
}

uvx_path <- Sys.which("uvx")
clauder_available <- requireNamespace("ClaudeR", quietly = TRUE)
if (nzchar(uvx_path) && clauder_available) {
  add_check("Optional RStudio MCP", "PASS", "uvx and ClaudeR are available")
} else {
  missing_optional <- c(if (!nzchar(uvx_path)) "uvx", if (!clauder_available) "ClaudeR")
  add_check(
    "Optional RStudio MCP",
    "WARN",
    paste(paste(missing_optional, collapse = " and "), "not available; direct Rscript remains usable")
  )
}

for (check in checks) {
  cat(sprintf("[%s] %s: %s\n", check$status, check$name, check$detail))
}

required_failures <- vapply(
  checks,
  function(check) isTRUE(check$required) && identical(check$status, "FAIL"),
  logical(1)
)

if (any(required_failures)) {
  cat("Core skill checks: NOT READY\n")
  quit(status = 1L)
}

cat("Core skill checks: READY\n")
quit(status = 0L)
