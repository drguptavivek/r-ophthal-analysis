# Clinical Reporting Guidelines

Use these guidelines for manuscript tables, figures, and statistical reporting.

## Core Standards

- Keep outputs reproducible from top to bottom in the central `.Rmd`, or the central `.do` plus raw log when Stata is explicitly requested. R chunk options below apply only to R Markdown.
- Structure the `.Rmd` in short sections: study setup, package/helper setup, data import, data audit, cleaning/recoding, analytic dataset freeze, simple tables, key outcomes, figures, deeper models, interpretation only when explicitly requested, and appendices.
- Use explicit headings and subheadings in the rendered report so each phase, table, figure, and interpretation section is easy to find.
- Show main analysis code by default so the analysis remains auditable.
- Use `echo=FALSE` for chunks that only produce table footnotes, figure legends, captions, styling, inline interpretation text, or formatting glue.
- Keep the result, essential footnote/legend, and supporting graph adjacent without unrelated printed code between them. Do not interpret results autonomously; interpretation requires an explicit researcher request.
- Use chunk labels and explicit chunk options. Prefer a setup chunk that sets defaults deliberately, for example `knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning = TRUE)`, then override specific helper/output chunks with `echo=FALSE`.
- Keep warnings visible until reviewed. Silence only a known, documented warning in the specific chunk that produces it.
- Prefer compact scientific publication style tables.
- Every table must have a clear heading. Add only absolutely essential footnotes: the test used, or a denominator, abbreviation, unit, or missing-data rule that is otherwise ambiguous. Do not repeat information already clear in the title, row label, column header, or caption; do not add interpretation, significance commentary, routine limitations, or explanatory essays.
- Do not use em dashes in tables or manuscript text.
- Save figures to readable filenames when the user asks where figures live.
- Save figures in `figs/` unless the project has a pre-existing figure directory.
- Save rendered outputs, manuscript tables, and model summaries in `results/` unless the project has a pre-existing results directory.
- Keep patient-level data local and do not upload or share it without explicit approval. Do not place row-level identifiers in reports or figures.
- Set and record seeds and relevant software versions; include `sessionInfo()` for R and the preserved native version/command record for Stata.

## Numeric Formatting

- Format percentages, means, SDs, incidence rates and other descriptive point estimates to 1 decimal place unless the user requests otherwise. Use 2 decimals for ORs, RRs, HRs and their confidence bounds, retaining more when needed to avoid rounding a positive bound to zero.
- Format p-values and standard errors to 3 decimal places. Display p < 0.001 as `<0.001`, never `0.000`. Keep all estimates and p-values at full numerical precision until display; retain enough decimals for clinically small scales such as ratios or logMAR.
- Estimate and report 95% confidence intervals for ORs, RRs, HRs, prevalences, incidences, incidence rates, and other important point estimates.
- For diagnostic-test analyses, report 95% CIs for all estimable metrics, including sensitivity, specificity, PPV, NPV, accuracy, F1, Youden index, LR+, LR-, diagnostic odds ratio, NNS, AUROC/AUC, and threshold-specific estimates. Bootstrap CIs are acceptable and often preferred for derived metrics without simple closed-form intervals.
- Present confidence intervals with comma-separated lower and upper bounds, not hyphens, to avoid confusion with negative numbers.
- Use examples such as `OR 1.4 (95% CI 1.1, 1.8)` and prevalence `23.5% (95% CI 19.1, 28.4)`.

## Table Refinement

- Build simple tables first, starting with background characteristics.
- During exploratory analysis, show both mean (SD) and median (p25, p75) for continuous variables to assess distribution and guide parametric versus non-parametric handling.
- For final publication tables, do not automatically report both summaries for every continuous variable. Discuss with the researcher whether to report mean (SD), median (p25, p75), or both, and keep the selected summary and test choice consistent.
- Use hierarchical tables with visibly indented categories and summaries by default in R and Stata; change to a flat layout only when explicitly requested. For categorical variables, use a hierarchical row layout in column 1: the first row is the variable label, and the second, third, and later rows are the category values within that variable.
- Do not split a variable and its category values across separate label columns or across awkward repeated labels. The reader should see one variable block with clear category-value subrows.
- Estimate key outcomes before deeper models.
- Refine tables one by one with user feedback.
- Add graphs only where they support results.
- Move to regression, regression diagnostics, and sensitivity analysis only after the basic tables and key outcome estimates are agreed.

## Opinionated Publication Table Layout

Apply this default to two-/three-group comparison tables. Keep the researcher's approved choice of mean (SD), median (p25, p75), or both; do not change the chosen test merely to match a display. The examples show both summaries.

| Outcome | Control | Moderate | Severe | Unadjusted p |
|:--|--:|--:|--:|--:|
| **Outcome label, unit (N=observed total)** | n=observed | n=observed | n=observed | raw p |
|   Mean (SD) | mean (SD) | mean (SD) | mean (SD) | |
|   Median (p25, p75) | median (p25, p75) | median (p25, p75) | median (p25, p75) | |
| **Categorical outcome (N=observed total)** | n=observed | n=observed | n=observed | raw p |
|   Category A | n (%) | n (%) | n (%) | |
|   Category B | n (%) | n (%) | n (%) | |

For two groups, omit the absent group column. This is a schematic, not fabricated study results. Actual summary/category rows must be visibly indented within the first column.

- Bold the outcome label on the parent row. Put total observed N in that label, observed group n in the group cells, and the unadjusted p-value on the same parent row. Leave p cells blank on subrows.
- Total N must equal the sum of observed group n for that outcome. Distinguish participant and eye denominators where relevant. Never reuse the recruited study N for an outcome with missing values.
- Category percentages use the corresponding observed group denominator. Print prespecified levels with zero observations as `0 (0.0%)`; do not invent unapproved levels. Indent category labels and avoid repeated parent labels or extra label columns.
- Name the median row `Median (p25, p75)` to make the displayed bounds explicit. If the researcher chooses `Median (IQR)`, define IQR as the displayed 25th/75th percentile bounds rather than silently switching to p75 minus p25.
- Show human-readable group/outcome labels and units. Hide variable names, collection dimensions and artificial row IDs. Use `Not estimable` for a genuinely non-estimable result rather than an empty fabricated estimate or p-value.
- Include group columns and **Unadjusted p only**. Do not add Holm or other adjusted-p columns to this layout. If multiplicity adjustment is agreed, record the method and family in the analytic record; alter the visible layout only on explicit researcher instruction.
- Use Times New Roman 10 pt, black text, white background, no vertical gridlines or shading, and three horizontal rules: above the header, below the header, and below the final row. Start with 35-40% width for the first column, 10-15% for p, and divide the rest among groups; adjust to avoid wrapping that obscures a variable block. Left-align labels and align numerical columns consistently.
- Repeat the complete column header on continued pages. Prevent individual rows from splitting and keep each outcome heading with its summary/category rows. Keep table titles with the first data rows. Page breaks or shorter table blocks are preferable to orphaned headings.
- Place each supporting graph immediately after its table block, before the next unrelated table. Use a short identifying caption; add a legend only for an otherwise ambiguous plot encoding.

## Table 1: Participant Characteristics

Start Table 1 with the approved baseline characteristics and explicit analysis unit. Use the comparison-table hierarchy above: a characteristic heading with observed N and group denominators, then indented continuous summaries or category n (%). Give group totals in column headings only when these differ from outcome-specific observed denominators. Do not automatically add significance tests to baseline tables: include unadjusted p only when the researcher requests comparisons and agrees the tests. Do not describe randomised groups as balanced on the basis of p-values.

## Logistic Regression Results

Use one label column with bold variable headings and indented category rows. The default columns are:

| Variable / category | N | Outcome (%) | Univariable OR [95% CI] | Multivariable OR [95% CI] |
|:--|--:|--:|--:|--:|
| **Variable label** | | | | |
|   Reference category | category N | observed outcome % | 1.0 [Reference] | 1.0 [Reference] |
|   Other category | category N | observed outcome % | OR [lower, upper] | OR [lower, upper] |

- N is the number analysed in that category; Outcome (%) is the percentage with the prespecified binary outcome within that category. State the outcome definition in the title or header. Do not substitute percentage of the entire study population.
- Use an explicitly defined common complete-case sample for the demonstration so N and outcome % correspond to both model columns. In real analyses follow the approved missing-data plan; if model samples differ, make this visible instead of claiming shared denominators.
- Fit each univariable model separately and fit the multivariable model with the approved adjustment set. Do not select covariates automatically using univariable significance. Keep reference categories and coding identical across columns.
- Display numeric OR and CI results from the fitted engine; exponentiate log-odds coefficients and confidence bounds, not standard errors. Label the CI method only if not already stated in the methods. Do not add p-values, Holm columns, interpretation or significance stars.
- Reference rows are explicit. Mark separation, non-convergence, omitted terms or unavailable estimates as `Not estimable`, investigate them, and preserve warnings. Never replace these with an apparently valid OR.
- Use the same three-rule, indented, unsplit publication styling. An essential note may identify the CI method or adjusted variables only when the table/methods do not already show them. Include a compact multivariable model-statistics note: actual N, likelihood-ratio chi-square with df and p, -2 log likelihood (-2LL), and explicitly named McFadden pseudo-R-squared. Retrieve these from the fitted model; do not call pseudo-R-squared ordinary R-squared. Add other diagnostics only when requested and appropriate to the approved model.

## Verification and Formatting Refreshes

- Validate the final displayed N, summaries, categories and p-values against the engine's numerical results; a successful export or valid DOCX package is insufficient.
- Fail on missing required fields and inconsistent denominators. Preserve numerical results, raw warnings/logs and source checksums; do not suppress unexpected errors because a report file was produced.
- Render/open final Word output and inspect every page for clipping, indentation, orphaned outcome headings, repeated headers, split rows and graph order.
- A pure formatting refresh may reuse verified expensive model/bootstrap results. Check source/result hashes, rerun the reporting code, and record that the combined analysis was not freshly rerun end to end. Recompute dependent results when data, definitions or analytic methods change.
