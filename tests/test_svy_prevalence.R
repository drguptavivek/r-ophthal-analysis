#!/usr/bin/env Rscript

if (!requireNamespace("survey", quietly = TRUE)) {
  cat("SKIP: survey package not installed; svy_prevalence() not tested\n")
  quit(status = 0)
}

script_arg <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
repo_root <- normalizePath(file.path(dirname(sub("^--file=", "", script_arg[[1]])), ".."), mustWork = TRUE)
source(file.path(repo_root, "examples", "r", "svy_prevalence.R"))

set.seed(20261018)
n <- 600
dat <- data.frame(
  cluster = rep(1:30, each = 20),
  district = rep(1:3, each = 200),
  sex = factor(sample(c("Male", "Female"), n, replace = TRUE), levels = c("Male", "Female")),
  wt = runif(n, 0.5, 2)
)
dat$vi <- rbinom(n, 1, 0.2)
dat$vi[sample(n, 40)] <- NA
dat$va_cat <- factor(sample(c("No VI", "Mild", "Moderate"), n, replace = TRUE),
                     levels = c("No VI", "Mild", "Moderate", "Blind"))
dat$va_cat[dat$district == 3 & dat$va_cat == "Moderate"] <- "Mild"
design <- survey::svydesign(ids = ~cluster, weights = ~wt, data = dat)

binary <- svy_prevalence(design, "vi", by = "sex")
stopifnot(identical(binary$group, c("Male", "Female", "Total")))
stopifnot(all(binary$level == "1"))
stopifnot(binary$denominator[3] == sum(!is.na(dat$vi)))
manual <- with(dat[!is.na(dat$vi) & dat$sex == "Female", ], sum(wt * vi) / sum(wt)) * 100
stopifnot(abs(binary$estimate[2] - manual) < 1e-8)
stopifnot(all(binary$lci < binary$estimate & binary$estimate < binary$uci))

multi <- svy_prevalence(design, "va_cat", by = "district")
stopifnot(nrow(multi) == 4L * 4L)
empty <- multi[multi$group == "3" & multi$level == "Moderate", ]
stopifnot(empty$cases == 0L, empty$estimate == 0, !empty$estimable, is.na(empty$lci))
blind <- multi[multi$level == "Blind", ]
stopifnot(all(blind$estimate == 0), all(!blind$estimable))
total_sum <- sum(multi$estimate[multi$group == "Total"])
stopifnot(abs(total_sum - 100) < 1e-8)

cat("PASS: svy_prevalence handles binary, multinomial, empty levels and totals\n")
