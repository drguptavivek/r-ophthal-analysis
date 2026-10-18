#!/usr/bin/env Rscript

script_arg <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
repo_root <- normalizePath(file.path(dirname(sub("^--file=", "", script_arg[[1]])), ".."), mustWork = TRUE)
dir <- file.path(repo_root, "reference-data", "india-population")
status <- system2(file.path(R.home("bin"), "Rscript"), c("--vanilla", shQuote(file.path(dir, "project_district_population.R")), "2026"), stdout = TRUE)
stopifnot(is.null(attr(status, "status")))
p <- read.csv(file.path(dir, "india_district_population_projection_2026.csv.gz"), colClasses = c(state_code = "character", district_code = "character"))
num <- c("rural_male", "rural_female", "urban_male", "urban_female")
stopifnot(nrow(unique(p[, c("state_code", "district_code")])) == 640, all(p[num] >= 0))
tot <- read.csv(file.path(dir, "india_mohfw_state_total_urban_annual_2011_2036.csv.gz"))
india <- sum(tot$pop_thousands[tot$state == "India" & tot$year == 2026 & tot$sex %in% c("male", "female")]) * 1000
stopifnot(abs(sum(p[num]) - india) / india < 1e-4)
stopifnot("0" %in% p$age_group, "1-4" %in% p$age_group, all(p$mohfw_state[p$district_code %in% sprintf("%03d", 532:541)] == "TELANGANA"))
cat("PASS: district projection matches MoHFW 2026 totals with under-1 kept separate\n")
