# Changelog

All notable changes to this skill are documented here.

## [Unreleased]

### Added

- `setup-stata-mcp` action in `local-config.md`: install the hanlulong/stata-mcp IDE extension, set Stata path and edition (MP/SE/BE; extension defaults to MP), register Claude Code/Codex/VS Code/Claude Desktop, and verify with `c(edition_real)`.
- Windows Rtools readiness probe that compiles a disposable C source, plus a strict source-build mode and Windows CI coverage.
- Fixed Phase Report template so every approval gate has a checkable shape.
- Rule to prefer common, widely reported statistical methods and packages over obscure tests.
- Ophthalmology reference: logMAR conversions, off-chart VA conventions, WHO VI threshold table, two-eye analysis options, and common errors.
- `legacy-stata-translation.md`, moved out of `SKILL.md` so it loads only when translating.
- Staged project layout for R and Stata (`component-project-layout.md`): `010_load`, `020_explore_clean`, `030_derive_label_freeze`, then one analysis file per section from `100_`, numbered in gaps, each runnable independently with no master file.
- `write_freeze()`, `read_frozen()` and `read_stage()` helpers that record and verify the frozen dataset's checksum and N; Stata uses `datasignature`.
- `clinical-regression-reporting.md`: generic univariable/multivariable layout, columns by model type, clustered two-eye and survey-weighted models, covariate prespecification, events per parameter, VIF, interactions, continuous-predictor units, and univariable/multivariate terminology.
- Hard limits on table notes (one line, about 25 words) and on prose between results.
- No-raw-output rule for rendered reports.
- Themed network index in `SKILL.md` (setup, project and data, reporting, design and statistics, vision core, surveys, WHO ECIM indicators, cataract, refractive error, myopia, glaucoma, diabetic retinopathy, corneal blindness, screening and AI); files listed under every theme they serve, and every reference ends with a `Related:` line. The self-test now validates index entries.
- Disease references checked against source papers: `glaucoma-endpoints.md` (ISGEO, IOP trials, surgical success, AI), `glaucoma-progression.md` (EMGT, LoGTS, rates, staging), `glaucoma-mindbody-trials.md` (MBSR, yoga, pranayama), `diabetic-retinopathy.md` (ICDR, NHS England, Scottish, RAAB7 DR module), `myopia.md` (IMI definitions, which-eye rules, two-stage school screening, NIM, outdoor and myopia-control trials), `corneal-blindness.md` (Gupta 2025 burden levels, keratoplasty outcomes).
- Refractive error conventions from Indian school studies (NIM, REACH multistate, LV Prasad): thresholds, which-eye rules (including "better eye" meaning lower refractive error), screening thresholds, and a PVA-based school-age eREC variant.
- `school-eye-health.md`: WHO 2025 school screening protocol and referral criteria, IAPB frequency rules, screener models, WHO programme indicators, unannounced spectacle-wear classification, and school cluster-trial design.
- Adopted outcome definitions for school programmes (spectacle compliance, assessment method, timing, denominator, non-compliance reasons, screening validation, referral uptake) from Morjaria 2019, Shukla 2018 and Pawar 2023; NICER and RESC-variant refractive error thresholds.
- `refractive-error-classification.md`: software-neutral case classification with Joseph et al. 2022 (REACH) as default: per-eye SE and astigmatism typing, lower-error-eye person classification, either-eye secondary, anisometropia and antimetropia, BCVA-based referral exclusions, denominators and flow; logic verified on edge cases. Adopted definition: cylinders standardised to negative, myopia SE-based, hyperopia SE-based or sphere-based when not myopic. Per eye, four exclusive categories: myopia, hyperopia, astigmatism only, emmetropia, with an astigmatism flag across all. Person level: nine categories from the eye pair (bilateral, unilateral, unilateral with fellow-eye astigmatism for myopia and hyperopia; astigmatism alone; antimetropia; emmetropia), with not-classifiable rows; lower-error-eye rule kept as a secondary analysis. Collapsed four-level summary: myopia, hyperopia, astigmatism/antimetropia, emmetropia. Three layers kept separate: screening (India 6/9, WHO 6/12 presenting VA, research 6/9.5), refractive status (dioptric), and visually significant refractive error (unaided VA below threshold in either eye, improving to threshold or by 2 lines, in an ametropic eye), with met and unmet need. These layers, exclusions and denominators live in `refractive-error-vision-layers.md`, split from the classification file to keep each file small. Two-stage screening studies: outcome named as vision-reducing refractive error at the screening threshold; passed and retest-normal children are No RE; screening and refraction dropouts reported separately; complete-case analysis reported as a conservative estimate, with dropout counts beside it. Simulation-based rule: relative underestimate approximately equals refraction dropout percentage; above 10% dropout add an upper estimate counting all refraction dropouts as RE. Runnable example `examples/r/dropout_bias_simulation.R` with a test.
- `raab-weights.md`: two-stage RAAB weights (district to target, person within district x sex x age cell), calibration to the analysis year with UN national totals and MoHFW state projections, 5- or 10-year age groups by cell size, optional rural-urban strata within districts, weight checks, and weighting versus external standardisation.
- `reference-data/india-population/`: UN WPP 2022 (single-age 2011-2050; 5-year with 80% and 95% bounds 2015-2040), MoHFW state x sex x 5-year projections 2011-2036 with urban share, and Census 2011 district x residence x sex x 5-year age, as CSVs with a provenance README and build script; totals cross-checked.
- `burden-projection.md`: projecting cases, surgeries and complications from survey rates and population projections: recall-window apportioning for annual event rates, persons-to-eyes conversion, age smoothing and extrapolation limits, Podgor-Leske incidence from prevalence, Monte Carlo uncertainty combining population bounds, rate prediction intervals and complication probabilities. Runnable `examples/r/incidence_from_prevalence.R` (Podgor and Leske 1986, equation 4 with delta-method SEs) tested against the paper's Table II. UN Data Portal API documented (token request, endpoints, indicator codes 46, 47, 49, 77, 78, 81, 82, 91, 92) for refreshing population and life-table data.
- `reference-data/india-population/project_district_population.R` and 2026 outputs: Census 2011 districts projected by age group (under 1 separate), sex and residence, raked to MoHFW state targets (North-East via the aggregate's age ratios; Goa, Ladakh and UTs via 2011 structure), with an optional UN WPP national rescaling; Telangana and Ladakh districts reassigned; raw MoHFW tables added. All raw sources stored in `source/` (UN xlsx and zip, Census 2011 C-13 and MoHFW tables gzipped); `build_tables.R` rebuilds every table from them, and all tables are gzip-compressed CSV.
- Cataract surgical outcome categories (RAAB7, Ramke) and cause-specific burden rules (RAAB principal-cause underestimation).
- Codebook verification gate in `020_explore_clean`: confirm every categorical code against the survey's own labels and protocol before deriving variables; codes are never assumed across surveys or versions.
- Rule to write category conditions against value labels, resolved once and asserted, instead of bare integer codes (Stata `"label":lblname`, R `haven::as_factor()`).
- `svyprev` (Stata) and `svy_prevalence()` (R) helpers for design-based prevalence with 95% logit CI and DEFF, binary or multinomial, by any grouping variable; results read by name, empty levels reported as non-estimable; tests in both languages and verified to agree.
- `clinical-raab-surveys.md`: RAAB5/6 vs RAAB7 codes, two-stage design, weight construction, age-sex standardisation, and Bennett CIs for matching RAAB reports.
- `clinical-survey-prevalence.md`: use of the prevalence helpers and positional-indexing pitfalls.

### Changed

- Sharper trigger description naming eye-care terms and a negative scope.
- Merged single-hop `component-mcp`, `component-ophthalmology`, `component-who-ecim-indicators`, and `component-study-designs` into their targets; `SKILL.md` now points directly to each reference.
- Removed rules repeated across reference files.
- Scaffold creates `analysis_charter.md` and staged `.Rmd` templates instead of one central `analysis.Rmd`.
- R Markdown output uses a left floating table of contents, unnumbered headings, folded code, and no echoed code in Word; the example no longer prints raw `cat()` output.
- WHO ECIM formulas split into `who-ecim-ecsc-formulas.md` and `who-ecim-erec-formulas.md` and checked against the WHO 2022 report and RAAB7 analysis code: corrected eCSC `x` (other eye unoperated, any cause) and `z` (both eyes worse than threshold, cataract cause in one or both); added McCormick/RAAB7 and WHO Annex 2 PVA-based eREC, near eREC, operated-eye rules, threshold naming crosswalk, and component checks.
- ECIM references cite and were checked against WHO 2022, McCormick 2020 and 2022, Ramke 2017 (with S1 code), Bourne 2025, Vashist 2024 and Gupta 2026: corrected the Ramke structure and reorganised both files as WHO 2022 primary plus current variants (eCSC threshold pairs; McCormick/RAAB7, PVA-based and near eREC, each with when to use it), with Ramke, Keel, classical CSC and RAAB6 eREC as brief historical notes, added RAAB5 VA-code differences, the couching exclusion, the No View with surgical complications as operated rule, and the PVA-based eREC overestimation warning.
- Logistic regression details moved from `clinical-reporting-guidelines.md` into `clinical-regression-reporting.md`.

## [1.0.0] - 2026-07-25

### Added

- Initial public release of the stepwise R/R Markdown ophthalmology analysis skill.
- Progressive guidance for data management, reporting, ophthalmology definitions, study designs, and WHO ECIM indicators.
- Optional base-R project scaffold.
- Central `analysis.Rmd` template with decision gates, missing-data planning, freeze metadata, and reproducibility output.
- Git-ignored raw, derived, frozen, and export data directories.
- Validated publication-formatting helpers and base-R regression tests.
- Dependency-free readiness self-test and continuous validation workflow.
- Non-installing R/CRAN package update checks, R path diagnostics, RStudio-bundled Pandoc discovery, and an isolated Python-to-Pandoc access probe.
- Agent-facing metadata, installation instructions, and MIT licensing.
