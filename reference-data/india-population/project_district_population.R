# Project Census 2011 district populations to a target year by age group, sex and
# residence, calibrated to MoHFW state projections. Base R only; reads only the
# CSVs in this folder.
#
#   Rscript reference-data/india-population/project_district_population.R 2026
#   writes india_district_population_projection_2026.csv.gz beside this script.
#   Rscript reference-data/india-population/project_district_population.R 2026 un
#   also rescales so national sex x age totals equal UN WPP (file name ends _un.csv.gz).
#
# Method (references/raab-weights.md):
# 1. Seed: Census 2011 district x age group (0, 1-4, 5-9 ... 80+) x residence x sex.
# 2. State targets for the year, by sex and age group (MoHFW, thousands x 1000):
#    a. 22 states with MoHFW age projections: MoHFW age groups; 0 = MoHFW "0-1"
#       (under 1 year); 1-4 = MoHFW "0-4" minus "0-1".
#    b. Seven North-East states (Arunachal, Manipur, Meghalaya, Mizoram, Nagaland,
#       Sikkim, Tripura): state's Census 2011 age-sex counts x the North-East
#       aggregate's growth ratio (year / 2011) for that age-sex group, rescaled to
#       the state's MoHFW total for the year.
#    c. Goa, Ladakh and UTs (no MoHFW age detail): state's Census 2011 age-sex
#       distribution scaled to its MoHFW total for the year (age structure held at 2011).
#    Residence target: MoHFW projected urban percentage x total, by state and sex.
# 3. Within each state and sex, rake (iterative proportional fitting) the district
#    x age x residence seed to the age totals and the urban/rural totals. District
#    shares within each age-residence cell follow 2011.
# 4. Optional (argument "un"): multiply every cell of each sex x age group by
#    UN WPP national total / projected national total. State and district shares
#    within each sex-age group are kept; state totals then differ from MoHFW.
# Census 2011 Andhra Pradesh districts 532-541 are assigned to Telangana, and Leh and
# Kargil (Jammu & Kashmir 003, 004) to Ladakh.

args <- commandArgs(trailingOnly = TRUE)
target_year <- if (length(args) >= 1) as.integer(args[[1]]) else 2026L
use_un <- length(args) >= 2 && tolower(args[[2]]) == "un"
here <- dirname(normalizePath(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE)[1])))

census <- read.csv(file.path(here, "india_census2011_district_age_sex_residence.csv.gz"),
                   colClasses = c(state_code = "character", district_code = "character"))
raw <- read.csv(file.path(here, "india_mohfw_state_age_sex_raw_2011_2036.csv.gz"))
tot <- read.csv(file.path(here, "india_mohfw_state_total_urban_annual_2011_2036.csv.gz"))
if (!target_year %in% raw$year) stop("MoHFW age projections exist only for ", paste(sort(unique(raw$year)), collapse = ", "))

age_levels <- c("0", "1-4", paste0(seq(5, 75, 5), "-", seq(9, 79, 5)), "80+")
census_states <- c("01" = "JAMMU & KASHMIR", "02" = "HIMACHAL PRADESH", "03" = "PUNJAB", "04" = "CHANDIGARH",
  "05" = "UTTARAKHAND", "06" = "HARYANA", "07" = "NCT OF DELHI", "08" = "RAJASTHAN", "09" = "UTTAR PRADESH",
  "10" = "BIHAR", "11" = "SIKKIM", "12" = "ARUNACHAL PRADESH", "13" = "NAGALAND", "14" = "MANIPUR",
  "15" = "MIZORAM", "16" = "TRIPURA", "17" = "MEGHALAYA", "18" = "ASSAM", "19" = "WEST BENGAL",
  "20" = "JHARKHAND", "21" = "ODISHA", "22" = "CHHATTISGARH", "23" = "MADHYA PRADESH", "24" = "GUJARAT",
  "25" = "DAMAN & DIU", "26" = "DADRA & NAGAR HAVELI", "27" = "MAHARASHTRA", "28" = "ANDHRA PRADESH",
  "29" = "KARNATAKA", "30" = "GOA", "31" = "LAKSHADWEEP", "32" = "KERALA", "33" = "TAMIL NADU",
  "34" = "PUDUCHERRY", "35" = "ANDAMAN & NICOBAR ISLANDS")
census$mohfw_state <- unname(census_states[census$state_code])
census$mohfw_state[census$state_code == "28" & as.integer(census$district_code) %in% 532:541] <- "TELANGANA"
census$mohfw_state[census$state_code == "01" & census$district_code %in% c("003", "004")] <- "LADAKH"
stopifnot(!anyNA(census$mohfw_state), all(unique(census$mohfw_state) %in% tot$state))
census$age_group <- factor(census$age_group, levels = age_levels)

ne_states <- c("ARUNACHAL PRADESH", "MANIPUR", "MEGHALAYA", "MIZORAM", "NAGALAND", "SIKKIM", "TRIPURA")
ne_name <- "NORTH-EAST STATES EXCLUDING ASSAM"

# MoHFW age groups -> analysis age groups (persons, not thousands)
mohfw_ages <- function(state, year, sex) {
  r <- raw[raw$state == state & raw$year == year & raw$sex == sex, ]
  v <- setNames(r$pop_thousands * 1000, r$age_group)
  out <- c(v[["0-1"]], v[["0-4"]] - v[["0-1"]], v[age_levels[-(1:2)]])
  setNames(out, age_levels)
}
census_ages <- function(state, sex) {
  d <- census[census$mohfw_state == state, ]
  x <- if (sex == "male") d$rural_male + d$urban_male else d$rural_female + d$urban_female
  tapply(x, d$age_group, sum)[age_levels]
}
state_total <- function(state, year, sex) tot$pop_thousands[tot$state == state & tot$year == year & tot$sex == sex] * 1000
urban_share <- function(state, year, sex) tot$urban_pct[tot$state == state & tot$year == year & tot$sex == sex] / 100

age_targets <- function(state, sex) {
  if (state %in% raw$state) return(mohfw_ages(state, target_year, sex))
  base <- census_ages(state, sex)
  if (state %in% ne_states) base <- base * mohfw_ages(ne_name, target_year, sex) / mohfw_ages(ne_name, 2011, sex)
  base / sum(base) * state_total(state, target_year, sex)
}

results <- list()
for (st in unique(census$mohfw_state)) {
  d <- census[census$mohfw_state == st, ]
  d <- d[order(d$district_code, d$age_group), ]
  for (sx in c("male", "female")) {
    seed <- cbind(rural = d[[paste0("rural_", sx)]], urban = d[[paste0("urban_", sx)]])
    targets <- age_targets(st, sx)
    total <- sum(targets)
    u <- urban_share(st, target_year, sx)
    # Rake: (a) age totals across districts and residence, (b) urban/rural totals.
    cell_age <- as.character(d$age_group)
    x <- seed
    for (i in seq_len(1000)) {
      age_sum <- as.vector(tapply(rowSums(x), cell_age, sum)[cell_age])
      x <- x * ifelse(age_sum > 0, as.vector(targets[cell_age]) / age_sum, 0)
      cs <- colSums(x)
      x <- sweep(x, 2, ifelse(cs > 0, c(total * (1 - u), total * u) / cs, 0), "*")  # 100% urban states: rural column 0
      dev <- max(abs(tapply(rowSums(x), cell_age, sum)[age_levels] - targets) / targets)
      if (dev < 1e-10) break
    }
    if (dev >= 1e-10) stop("raking did not converge for ", st, " ", sx)
    d[[paste0("rural_", sx)]] <- x[, "rural"]
    d[[paste0("urban_", sx)]] <- x[, "urban"]
  }
  results[[st]] <- d
}
proj <- do.call(rbind, results)
proj <- proj[order(proj$state_code, proj$district_code, proj$age_group), ]
num <- c("rural_male", "rural_female", "urban_male", "urban_female")

# Checks: every state, sex and age group, and urban share, match the MoHFW targets
for (st in unique(proj$mohfw_state)) for (sx in c("male", "female")) {
  p <- proj[proj$mohfw_state == st, ]
  tt <- age_targets(st, sx)
  got <- tapply(p[[paste0("rural_", sx)]] + p[[paste0("urban_", sx)]], p$age_group, sum)[age_levels]
  stopifnot(max(abs(got - tt) / tt) < 1e-6)
  stopifnot(abs(sum(p[[paste0("urban_", sx)]]) / sum(tt) - urban_share(st, target_year, sx)) < 1e-6)
}
india_mohfw <- sum(tot$pop_thousands[tot$state == "India" & tot$year == target_year & tot$sex %in% c("male", "female")]) * 1000
cat(sprintf("Projected %d: districts %d; India total %.0f (MoHFW India %.0f; difference %.2f%%)\n",
            target_year, nrow(unique(proj[, c("state_code", "district_code")])), sum(proj[num]), india_mohfw,
            100 * (sum(proj[num]) - india_mohfw) / india_mohfw))

if (use_un) {
  un <- read.csv(file.path(here, "india_un_wpp2022_single_age_sex_2011_2050.csv.gz"))
  un <- un[un$year == target_year, ]
  if (nrow(un) == 0) stop("no UN WPP values for ", target_year)
  un$age_group <- cut(un$age, c(0, 1, seq(5, 80, 5), Inf), right = FALSE, labels = age_levels)
  for (sx in c("male", "female")) {
    un_tot <- tapply(un[[sx]], un$age_group, sum)[age_levels]
    cols <- paste0(c("rural_", "urban_"), sx)
    cur <- tapply(rowSums(proj[cols]), proj$age_group, sum)[age_levels]
    f <- as.vector((un_tot / cur)[as.character(proj$age_group)])
    proj[cols] <- proj[cols] * f
  }
  cat(sprintf("Rescaled to UN WPP %d national totals: India %.0f\n", target_year, sum(proj[num])))
}

out <- proj[, c("state_code", "district_code", "district_name", "mohfw_state", "age_group", num)]
out[num] <- round(out[num])
con <- gzfile(file.path(here, sprintf("india_district_population_projection_%d%s.csv.gz", target_year, if (use_un) "_un" else "")), "w")
write.csv(out, con, row.names = FALSE)
close(con)
