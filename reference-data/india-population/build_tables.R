# Builds the CSV tables in this folder from the raw source files in source/.
# Run from anywhere:  Rscript reference-data/india-population/build_tables.R
# Then project districts:  Rscript reference-data/india-population/project_district_population.R 2026 [un]
# Needs the R packages haven (Stata files) and readxl (Excel file).

here <- dirname(normalizePath(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE)[1])))
src <- file.path(here, "source")
write_gz <- function(df, name) {           # plain CSV inside gzip; read.csv() reads .csv.gz directly
  con <- gzfile(file.path(here, name), "w"); on.exit(close(con)); write.csv(df, con, row.names = FALSE)
}
read_dta_gz <- function(name) {            # haven needs a file path, so unpack to a temporary file
  tmp <- tempfile(fileext = ".dta"); on.exit(unlink(tmp))
  con <- gzfile(file.path(src, name), "rb"); writeBin(readBin(con, "raw", n = 5e7), tmp); close(con)
  haven::read_dta(tmp)
}

# 1. UN World Population Prospects 2022, India, single year of age x sex, 2011-2050
#    (UN data portal download of 17 Aug 2023; median variant, VariantId 4)
un <- readxl::read_excel(file.path(src, "un_wpp2022_india_single_age_sex_dataportal_20230817.xlsx"))
un <- un[un$Sex %in% c("Male", "Female"), ]
un <- reshape(data.frame(year = un$Time, age = un$Age, sex = tolower(un$Sex), pop = un$tp),
              idvar = c("year", "age"), timevar = "sex", direction = "wide")
names(un) <- sub("^pop\\.", "", names(un))
un <- un[order(un$year, un$age), c("year", "age", "male", "female")]
write_gz(un, "india_un_wpp2022_single_age_sex_2011_2050.csv.gz")

# 2. UN World Population Prospects 2022, India, annual, 5-year age x sex, 2015-2040,
#    median with 80% and 95% prediction bounds (UN data portal download, Oct 2023)
un5 <- read.delim(unz(file.path(src, "un_wpp2022_india_5y_age_sex_annual_variants.csv.zip"),
                      "Annual population by 5-year age groups and by sex.csv"), sep = "|", check.names = FALSE)
keep <- c("Median", "80% lower bound", "80% upper bound", "95% lower bound", "95% upper bound")
un5 <- un5[un5$Variant %in% keep & un5$Sex %in% c("Male", "Female"), ]
un5 <- data.frame(year = un5$TimeLabel, variant = un5$Variant, sex = tolower(un5$Sex),
                  age_group = un5$AgeLabel, age_start = un5$AgeStart, population = un5$Value)
un5 <- un5[order(un5$variant, un5$year, un5$sex, un5$age_start), ]
write_gz(un5, "india_un_wpp2022_5y_age_sex_intervals_2015_2040.csv.gz")

# 3. Census 2011 table C-13: district x age group (0, 1-4, then 5-year to 80+) x residence x sex
#    ("age not stated" excluded)
c11 <- read_dta_gz("census2011_c13_single_age_residence_sex.dta.gz")
c11 <- c11[c11$disttcode != "000", ]
age <- suppressWarnings(as.numeric(sub("\\+", "", c11$age)))
lab <- c("0", "1-4", paste0(seq(5, 75, 5), "-", seq(9, 79, 5)), "80+")
c11$age_group <- as.character(cut(age, c(0, 1, seq(5, 80, 5), Inf), right = FALSE, labels = lab))
for (v in c("rm", "rf", "um", "uf")) c11[[v]] <- as.numeric(c11[[v]])
agg <- aggregate(cbind(rural_male = rm, rural_female = rf, urban_male = um, urban_female = uf) ~
                   statecode + disttcode + areaname + age_group, data = c11, FUN = sum)
agg$age_group <- factor(agg$age_group, levels = lab)
agg <- agg[order(agg$statecode, agg$disttcode, agg$age_group), ]
names(agg)[1:3] <- c("state_code", "district_code", "district_name")
write_gz(agg, "india_census2011_district_age_sex_residence.csv.gz")

# 4. MoHFW Technical Group projections (2020): 22 states and the North-East aggregate
#    (Arunachal, Manipur, Meghalaya, Mizoram, Nagaland, Sikkim, Tripura) x sex x age group,
#    including the under-1 group "0-1"; thousands; 2011-2036 quinquennial
ra <- read_dta_gz("mohfw_2020_state_age_sex_projection.dta.gz")
ra <- data.frame(year = ra$year, state = ra$state, sex = tolower(ra$grp), age_group = gsub("'", "", ra$ageGroup),
                 pop_thousands = ra$ageGrpPop)
ra$state[grepl("NORTH-EAST", ra$state)] <- "NORTH-EAST STATES EXCLUDING ASSAM"
ra <- ra[order(ra$state, ra$year, ra$sex), ]
write_gz(ra, "india_mohfw_state_age_sex_raw_2011_2036.csv.gz")

# 5. MoHFW annual totals by state (all states, UTs and India) x sex, thousands, with projected
#    urban percentage, 2011-2036
tu <- read_dta_gz("mohfw_2020_state_total_urban_projection.dta.gz")
tu <- data.frame(year = tu$year, state = tu$state, sex = tolower(tu$grp), pop_thousands = tu$totpop, urban_pct = tu$percturban)
tu <- tu[order(tu$state, tu$year, tu$sex), ]
write_gz(tu, "india_mohfw_state_total_urban_annual_2011_2036.csv.gz")
