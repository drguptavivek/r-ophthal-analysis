#!/usr/bin/env Rscript

script_arg <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
repo_root <- normalizePath(file.path(dirname(sub("^--file=", "", script_arg[[1]])), ".."), mustWork = TRUE)
source(file.path(repo_root, "examples", "r", "incidence_from_prevalence.R"))

# Podgor and Leske 1986, Table II (Framingham senile cataract, 5-year rates)
p0 <- c(0.0123, 0.0283, 0.0469, 0.1048, 0.1380)
p1 <- c(0.0283, 0.0469, 0.1048, 0.1380, 0.3242)
q  <- c(0.0574, 0.0867, 0.1239, 0.1847, 0.2780)
equal <- c(0.016, 0.019, 0.063, 0.038, 0.243)
diff  <- c(0.018, 0.023, 0.073, 0.063, 0.321)
net_diff <- c(0.017, 0.022, 0.070, 0.061, 0.275)
for (i in seq_along(p0)) {
  e <- incidence_from_prevalence(p0[i], p1[i], q[i], rr = 1)
  d <- incidence_from_prevalence(p0[i], p1[i], q[i], rr = 2)
  stopifnot(abs(e[["rate"]] - equal[i]) < 0.0015, abs(d[["rate"]] - diff[i]) < 0.0015,
            abs(d[["net_risk"]] - net_diff[i]) < 0.0015)
}
# Equal mortality has a closed form
stopifnot(abs(incidence_from_prevalence(0.0123, 0.0283, 0.0574)[["rate"]] - (-log((1 - 0.0283) / (1 - 0.0123)))) < 1e-8)
cat("PASS: incidence from prevalence reproduces Podgor and Leske 1986 Table II\n")
