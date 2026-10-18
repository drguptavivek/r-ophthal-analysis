#!/usr/bin/env Rscript

script_arg <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
repo_root <- normalizePath(file.path(dirname(sub("^--file=", "", script_arg[[1]])), ".."), mustWork = TRUE)
source(file.path(repo_root, "examples", "r", "dropout_bias_simulation.R"))

res <- dropout_bias(N = 5000, s = 0.10, p = 0.70, d = c(0, 0.10, 0.30), r = c(0.5, 1), reps = 500)
random <- res[res$dropout_re_ratio == 1, ]
stopifnot(max(abs(random$rel_bias_pct - random$formula_rel_bias_pct)) < 2)
stopifnot(abs(res$rel_bias_pct[res$dropout_pct == 0][1]) < 2)
stopifnot(all(res$complete_case_pct[res$dropout_pct > 0] < res$true_prev_pct[res$dropout_pct > 0]))
stopifnot(all(abs(res$rel_bias_pct[res$dropout_re_ratio == 0.5 & res$dropout_pct > 0]) <
              abs(res$rel_bias_pct[res$dropout_re_ratio == 1 & res$dropout_pct > 0])))
cat("PASS: dropout simulation matches formula and bias direction\n")
