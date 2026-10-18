# Survey Prevalence with CIs

Load this to estimate prevalence or coverage with 95% CIs for a binary or multinomial outcome, overall and by any grouping variable (sex, age group, district, risk factor with 2 or more levels).

## Helpers

| | Stata | R |
| --- | --- | --- |
| File | `examples/stata/svyprev.do` | `examples/r/svy_prevalence.R` |
| Load | `do "svyprev.do"` after `svyset` | `source("svy_prevalence.R")`; needs `survey` |
| Call | `svyprev outcome, over(group) saving(file.dta, replace)` | `svy_prevalence(design, "outcome", by = "group")` |
| Test | `tests/test_svyprev.do` | `tests/test_svy_prevalence.R` |

Copy the helper into the project's `R/` (or a `programs/` folder for Stata) and load it from each analysis file.

Both return one row per group x outcome level, plus a Total row, with: unweighted cases, unweighted denominator, estimate (per 100 by default), 95% logit CI, DEFF, and `estimable`. Values stay numeric at full precision; format only in the table step.

- Binary 0/1 outcomes report level 1; multinomial outcomes report every level, including prespecified levels with no cases.
- A level with no cases (or all cases) in a group gives the exact estimate (0 or 100) with a missing CI and `estimable = 0`. Display it as `0 (0.0%)` with "Not estimable" for the CI; never fabricate an interval.
- Missing outcome = not in the denominator. A group with no non-missing outcome is omitted from the output in both helpers; report it separately if it matters. Code the eligible population first (for example eCSC is missing outside x, y, z).
- Domains use `svy, subpop()` (Stata) or a subset of the design object (R), so the variance is correct for subgroups.
- Results are read by coefficient name, so an empty cell cannot shift other rows.

On identical data the two helpers agree on estimates and CIs; the Total-row DEFF matches, and subgroup DEFF can differ by under 1% because Stata uses a different SRS reference variance for subpopulations.

## Do Not

- Read `r(table)` or matrix results by row position (`all[3,1]`): when a level is empty in one group, every later row shifts and the numbers are silently wrong.
- Store results as formatted strings (`di %4.1f`) before the table step.
- Use `if` or `keep if` to restrict a survey estimate to a subgroup.

## Two-Way Groups and Tables

For sex within district, build one grouping variable (`egen g = group(district sex), label` or `interaction(district, sex)`), or loop over districts with `subpop()`. Turn the results dataset into the publication table with `collect`/`putdocx` (Stata) or `flextable` (R), following `clinical-reporting-guidelines.md`: observed denominator in the heading row, indented level rows, and estimate (95% CI) cells.

For age-sex standardised RAAB-style estimates or Bennett CIs, see `clinical-raab-surveys.md`.

Related: `clinical-raab-surveys.md`, `clinical-complex-surveys.md`, `clinical-reporting-guidelines.md`.
