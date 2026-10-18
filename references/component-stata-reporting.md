# Component: Native Stata Reporting

Use this route only when the researcher explicitly requests Stata. R/R Markdown remains the default. Follow the same analysis charter, data audit, frozen dataset, missing-data plan and researcher phase approvals in `SKILL.md`; follow `clinical-reporting-guidelines.md` for the shared publication layout.

## One Reproducible Native Analysis

Verify the installed Stata version and availability of `dtable`, `collect` and `putdocx`; `dtable` requires Stata 18 or later. Use the Stata MCP (`stata_run_file`, `stata_run_selection`) or the installed Stata executable; if the MCP is missing or reports the wrong edition, follow `setup-stata-mcp` in `local-config.md`. Do not assume a server port, platform or patient-data path. Native Stata work does not require an R installation or R preflight.

Use the staged layout in `component-project-layout.md`: `010_load.do`, `020_explore_clean.do`, `030_derive_label_freeze.do`, then one do-file per analysis section (`100_table1.do`, `110_...`), each runnable on its own with no master do-file. Analysis do-files open only the frozen `.dta` and run `datasignature confirm`. In each do-file, start a raw text log (`log using "results/<file>.log", text replace`) before substantive commands, record version and seed, preserve warnings and errors, and close the log only after checking required output files. Check the raw log and completion marker; an MCP response marked successful is not proof that Stata finished without an error.

Use `dtable`'s numeric descriptive results directly. Do not run it decoratively and reconstruct all means, quartiles and category frequencies as manually formatted strings. Keep full numerical precision until display. Use `collect get` for additional model/test results, outcome denominators and explicitly approved absent categories; save collections with `collect save`.

## Continuous Comparison Collection

The runnable example in `../examples/stata/example_stata_table1.do` demonstrates this pattern on synthetic data:

```stata
dtable marker pressure, by(group, nototals) nosample ///
    continuous(marker pressure, statistics(count mean sd median p25 p75))
collect composite define meansd = mean sd, delimiter(" ") trim override
collect composite define quartiles = p25 p75, delimiter(", ") trim override
collect composite define mediqr = median quartiles, delimiter(" (") trim override
collect style cell cell_type[item]#result[mediqr], sformat("%s)")
collect label levels result meansd "Mean (SD)" ///
    mediqr "Median (p25, p75)", modify
collect style header result[count], level(hide)
collect style header group, title(hide)
collect style row stack, nobinder
```

Capture each approved test result immediately after its estimation command, before another command changes `r()`. For example, after `ranksum marker, by(group)` store `r(p)`; after `kwallis` use its reported tie-adjusted p-value. Store each result in a namespaced scalar, then add it only to the outcome heading:

```stata
collect get count = scalar(ex_p_marker_raw), tags(var[marker] group[raw])
collect label levels group raw "Unadjusted p", modify
collect style cell result[count]#group[raw], nformat(%5.3f) minimum(.001)
collect style cell result[count]#group[0 1 2], nformat(%3.0f) sformat("n=%s")
collect layout (var[marker pressure]#result[count meansd mediqr]) ///
    (group[0 1 2 raw])
```

These fragments assume the example's group codes and previously captured scalar; adapt them to the validated dataset. Compute total observed N separately for each outcome and include it in its human-readable parent label. Hide technical dimensions and indent summary labels. Two-group layouts omit the third group. Do not add Holm or other adjusted-p columns.

## Table 1 and Logistic Regression

For Table 1, use native continuous results and `fvfrequency`/`fvpercent` from `dtable` for hierarchical category n (%). Preserve approved zero-count levels explicitly, but do not invent new levels. Use the observed group denominator, and verify total N equals the sum of group n for each characteristic. Baseline p-values are optional and require the researcher's requested comparison plan.

The separate `../examples/stata/example_stata_logistic.do` example generates a hierarchical logistic table with **Variable / category**, **N**, **Outcome (%)**, **Univariable OR [95% CI]** and **Multivariable OR [95% CI]**. It fits separate univariable models and one prespecified multivariable model on a common analysis sample. Retrieve actual coefficients/variances or native estimation results, exponentiate coefficient and CI bounds, and keep numeric values in `collect` until display. Label reference rows explicitly. Do not silently omit non-estimable terms or select adjustment variables based on p-values. Report the model's actual sample and preserve convergence/separation warnings.

## Word Export and Checks

Use `putdocx collect` for editable native Word tables. Apply controlled column widths, left-aligned labels, consistently aligned numbers, Times New Roman 10 pt, black text and white background. Remove cell borders, then add only the top and bottom header rules and the final-row bottom rule. Repeat headers and prevent rows from splitting. Keep variable headings with their subrows. Place each graph immediately after its supporting table block, with only an identifying caption and an essential legend.

Validate required variables, group codes, binary outcome, analysis unit and model sample before analysis. For imported CSV contracts use `import delimited ..., asdouble case(preserve)` when appropriate; confirm numeric required fields and assert denominator consistency. Fail on missing required fields rather than silently skipping them. Use brace-delimited `if`/`else` blocks around conditional expressions: Stata can expand macros in single-line branches that are not executed. Avoid reserved-name collisions such as `_N`.

Check displayed cell values against the numerical engine, save collections and preserve raw logs. Render/open every final Word page: a valid DOCX package does not establish correct widths, indentation, pagination or graph order. A formatting-only refresh may reuse verified expensive results only after checking source/result hashes and recording that a full analysis was not freshly rerun. Changes to data, definitions or methods require dependent analyses to be recomputed.

## Run the Synthetic Example

Use an absolute scratch directory, never a clinical-data directory. The example creates synthetic data only and writes namespaced demonstration files:

```stata
do examples/stata/example_stata_table1.do 2 "/absolute/scratch/table1_two"
do examples/stata/example_stata_table1.do 3 "/absolute/scratch/table1_three"
do examples/stata/example_stata_logistic.do 2 "/absolute/scratch/logistic_two"
do examples/stata/example_stata_logistic.do 3 "/absolute/scratch/logistic_three"
```

The example's demonstration tests and adjustment set are not defaults for an actual study. Agree these with the researcher before clinical analysis.

## Native Command References

- [Stata: separate descriptive statistics using dtable and collect](https://www.stata.com/support/faqs/reporting/display-multiple-descriptive-statistics/)
- [Stata: adding a custom statistic to a collection](https://www.stata.com/support/faqs/reporting/customized-statistic-new-column-row/)
- [Stata: putdocx collect manual](https://www.stata.com/manuals/rptputdocxcollect.pdf)

Related: `clinical-reporting-guidelines.md`, `clinical-regression-reporting.md`, `component-project-layout.md`.
