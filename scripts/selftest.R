#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
script_arg <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
script_path <- normalizePath(sub("^--file=", "", script_arg[[1]]), mustWork = TRUE)
repo_root <- normalizePath(file.path(dirname(script_path), ".."), mustWork = TRUE)
check_updates <- "--check-updates" %in% args
require_build_tools <- "--require-build-tools" %in% args

option_value <- function(name) {
  location <- match(name, args)
  if (is.na(location)) return(NULL)
  if (location == length(args) || startsWith(args[[location + 1L]], "--")) {
    stop(name, " requires a value", call. = FALSE)
  }
  args[[location + 1L]]
}

python_path <- option_value("--python")
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

find_pandoc <- function() {
  candidates <- character()
  on_path <- unname(Sys.which("pandoc"))
  if (nzchar(on_path)) candidates <- c(candidates, on_path)

  rstudio_dir <- Sys.getenv("RSTUDIO_PANDOC", unset = "")
  if (nzchar(rstudio_dir)) {
    candidates <- c(candidates, file.path(rstudio_dir, "pandoc"))
  }

  if (requireNamespace("rmarkdown", quietly = TRUE)) {
    found <- tryCatch(rmarkdown::find_pandoc(cache = FALSE), error = function(...) NULL)
    if (!is.null(found) && nzchar(found$dir)) {
      candidates <- c(candidates, file.path(found$dir, "pandoc"))
    }
  }

  candidates <- unique(candidates[file.exists(candidates)])
  for (candidate in candidates) {
    output <- tryCatch(
      system2(candidate, "--version", stdout = TRUE, stderr = TRUE),
      error = function(...) character()
    )
    status <- attr(output, "status")
    if (length(output) > 0L && (is.null(status) || status == 0L)) {
      return(normalizePath(candidate, mustWork = TRUE))
    }
  }
  ""
}

check_windows_build_tools <- function(required = FALSE) {
  if (.Platform$OS.type != "windows") {
    add_check(
      "Windows source build tools",
      "INFO",
      "not applicable on this operating system; Rtools is Windows-only"
    )
    return(invisible(NULL))
  }

  probe_dir <- tempfile("r-ophthal-rtools-")
  dir.create(probe_dir)
  on.exit(unlink(probe_dir, recursive = TRUE, force = TRUE), add = TRUE)
  writeLines(
    "void r_ophthal_build_probe(void) {}",
    file.path(probe_dir, "build_probe.c")
  )

  previous_dir <- getwd()
  on.exit(setwd(previous_dir), add = TRUE)
  setwd(probe_dir)
  r_executable <- file.path(R.home("bin"), "R.exe")
  output <- tryCatch(
    system2(
      r_executable,
      c("CMD", "SHLIB", "build_probe.c"),
      stdout = TRUE,
      stderr = TRUE
    ),
    error = function(condition) structure(conditionMessage(condition), status = 1L)
  )
  status <- attr(output, "status")
  library_created <- file.exists(file.path(probe_dir, paste0("build_probe", .Platform$dynlib.ext)))

  if ((is.null(status) || status == 0L) && library_created) {
    add_check(
      "Windows source build tools",
      "PASS",
      paste(
        "R CMD SHLIB compiled a disposable C source; toolchain works with R",
        as.character(getRversion())
      ),
      required = required
    )
  } else {
    diagnostic <- paste(output, collapse = " ")
    if (!nzchar(diagnostic)) diagnostic <- "R CMD SHLIB did not create a shared library"
    add_check(
      "Windows source build tools",
      if (required) "FAIL" else "WARN",
      paste0(
        "not ready for packages compiled from source: ", diagnostic,
        ". Binary CRAN packages generally remain usable. Check the current Rtools version at ",
        "https://cran.r-project.org/bin/windows/Rtools/"
      ),
      required = required
    )
  }
  invisible(NULL)
}

package_detail <- function(package) {
  description <- utils::packageDescription(package)
  built <- description$Built
  built_r <- if (is.null(built)) "unknown" else sub(";.*$", "", built)
  paste0(
    as.character(utils::packageVersion(package)),
    "; ", built_r,
    "; ", normalizePath(find.package(package), mustWork = TRUE)
  )
}

package_built_for_current_r <- function(package) {
  built <- utils::packageDescription(package)$Built
  if (is.null(built)) return(NA)
  built_version <- sub("^R[ ]+", "", sub(";.*$", "", built))
  built_parts <- strsplit(built_version, "[.]", fixed = FALSE)[[1]]
  current_parts <- strsplit(as.character(getRversion()), "[.]", fixed = FALSE)[[1]]
  if (length(built_parts) < 2L || length(current_parts) < 2L) return(NA)
  identical(built_parts[1:2], current_parts[1:2])
}

check_cran_updates <- function() {
  cran_repo <- getOption("repos")[["CRAN"]]
  if (is.null(cran_repo) || identical(cran_repo, "@CRAN@")) {
    cran_repo <- "https://cloud.r-project.org"
  }

  latest_r <- tryCatch(
    {
      base_url <- "https://cran.r-project.org/src/base/"
      base_index <- readLines(base_url, warn = FALSE)
      directory_matches <- regmatches(
        base_index,
        gregexpr("R-[0-9]+/", base_index, perl = TRUE)
      )
      directories <- unique(unlist(directory_matches, use.names = FALSE))
      directories <- directories[nzchar(directories)]
      versions <- character()
      for (directory in directories) {
        index <- readLines(paste0(base_url, directory), warn = FALSE)
        archive_matches <- regmatches(
          index,
          gregexpr("R-[0-9]+[.][0-9]+[.][0-9]+[.]tar[.]gz", index, perl = TRUE)
        )
        archives <- unique(unlist(archive_matches, use.names = FALSE))
        versions <- c(versions, sub("^R-", "", sub("[.]tar[.]gz$", "", archives)))
      }
      versions <- unique(versions[nzchar(versions)])
      if (length(versions) == 0L) stop("no R releases found")
      as.character(max(numeric_version(versions)))
    },
    error = function(condition) condition
  )

  if (inherits(latest_r, "condition")) {
    add_check("R update check", "WARN", paste("unavailable:", conditionMessage(latest_r)))
  } else if (numeric_version(latest_r) > getRversion()) {
    add_check(
      "R update check",
      "WARN",
      paste("installed", getRversion(), "and CRAN reports", latest_r, "; review before updating")
    )
  } else {
    add_check("R update check", "PASS", paste("installed R", getRversion(), "is current for CRAN", latest_r))
  }

  outdated <- tryCatch(
    utils::old.packages(repos = cran_repo),
    error = function(condition) condition
  )
  if (inherits(outdated, "condition")) {
    add_check("Package update check", "WARN", paste("unavailable:", conditionMessage(outdated)))
  } else if (is.null(outdated) || nrow(outdated) == 0L) {
    add_check("Package update check", "PASS", "installed CRAN packages are current")
  } else {
    package_names <- rownames(outdated)
    shown <- paste(utils::head(package_names, 12L), collapse = ", ")
    suffix <- if (length(package_names) > 12L) ", ..." else ""
    add_check(
      "Package update check",
      "WARN",
      paste0(length(package_names), " package update(s) available: ", shown, suffix, "; review before updating")
    )
  }
}

cat("R Ophthal Analysis self-test\n")
cat("============================\n")

rscript_name <- if (.Platform$OS.type == "windows") "Rscript.exe" else "Rscript"
rscript_path <- normalizePath(file.path(R.home("bin"), rscript_name), mustWork = TRUE)
add_check("R runtime", "PASS", paste(R.version$major, R.version$minor, sep = "."), required = TRUE)
add_check("R executable", "PASS", rscript_path, required = TRUE)
add_check("R library paths", "PASS", paste(.libPaths(), collapse = "; "), required = TRUE)
add_check("R package type", "PASS", getOption("pkgType"), required = TRUE)
check_windows_build_tools(required = require_build_tools)

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

pandoc_path <- find_pandoc()
if (nzchar(pandoc_path)) {
  add_check("Pandoc executable", "PASS", pandoc_path)
} else {
  add_check("Pandoc executable", "WARN", "not found on PATH or through RStudio/rmarkdown discovery")
}

for (package in c("rmarkdown", "knitr")) {
  if (requireNamespace(package, quietly = TRUE)) {
    compatible_build <- package_built_for_current_r(package)
    status <- if (identical(compatible_build, FALSE)) "WARN" else "PASS"
    suffix <- if (identical(compatible_build, FALSE)) "; built under a different R major/minor, review reinstall" else ""
    add_check(paste("R package", package), status, paste0(package_detail(package), suffix))
  } else {
    add_check(paste("R package", package), "WARN", "not installed; required for R Markdown rendering")
  }
}

if (!is.null(python_path)) {
  python_path <- normalizePath(path.expand(python_path), mustWork = FALSE)
  if (!file.exists(python_path)) {
    add_check("Agent Python Pandoc access", "WARN", paste("Python interpreter not found:", python_path))
  } else if (!nzchar(pandoc_path)) {
    add_check("Agent Python Pandoc access", "WARN", "Pandoc was not found for Python to invoke")
  } else {
    probe <- file.path(repo_root, "scripts", "check_pandoc.py")
    output <- tryCatch(
      system2(
        python_path,
        c("-I", "-S", shQuote(probe), "--pandoc", shQuote(pandoc_path)),
        stdout = TRUE,
        stderr = TRUE
      ),
      error = function(condition) structure(conditionMessage(condition), status = 1L)
    )
    status <- attr(output, "status")
    if (is.null(status) || status == 0L) {
      add_check("Agent Python Pandoc access", "PASS", paste(output, collapse = " "))
    } else {
      add_check("Agent Python Pandoc access", "WARN", paste(output, collapse = " "))
    }
  }
}

uvx_path <- unname(Sys.which("uvx"))
clauder_available <- requireNamespace("ClaudeR", quietly = TRUE)
if (nzchar(uvx_path) && clauder_available) {
  clauder_compatible <- package_built_for_current_r("ClaudeR")
  clauder_status <- if (identical(clauder_compatible, FALSE)) "WARN" else "PASS"
  clauder_suffix <- if (identical(clauder_compatible, FALSE)) "; built under a different R major/minor, review reinstall and client reconfiguration" else ""
  add_check(
    "Optional RStudio MCP",
    clauder_status,
    paste0("uvx ", normalizePath(uvx_path, mustWork = TRUE), "; ClaudeR ", package_detail("ClaudeR"), clauder_suffix)
  )
} else {
  missing_optional <- c(if (!nzchar(uvx_path)) "uvx", if (!clauder_available) "ClaudeR")
  add_check(
    "Optional RStudio MCP",
    "WARN",
    paste(paste(missing_optional, collapse = " and "), "not available; direct Rscript remains usable")
  )
}

if (check_updates) {
  check_cran_updates()
} else {
  add_check("R and package updates", "INFO", "not queried; use --check-updates for a non-installing CRAN comparison")
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
