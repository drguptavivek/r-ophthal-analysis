# Component: R Markdown and Reporting

Use this component for R Markdown output. For explicitly requested native Stata, use `component-stata-reporting.md`. Both follow `clinical-reporting-guidelines.md`.

Use `../examples/r/publication_tables.Rmd` for runnable, parameterised two-/three-group publication tables in HTML and Word. The example uses synthetic data and includes a unified Table 1, continuous outcome comparisons with an adjacent graph, and hierarchical logistic regression results. Comparison tables have unadjusted p only; models show N, outcome %, univariable OR [95% CI] and multivariable OR [95% CI], with no p columns. It contains no automatic interpretation.

## R Markdown Structure

Use headings and subheadings for the analysis charter, data governance, reproducibility setup, source-data provenance, data audit, missing-data plan, cleaning/recoding, analytic dataset freeze, simple tables, key outcomes, figures, deeper models, interpretation only when explicitly requested, and appendices.

Set chunk defaults deliberately:

```r
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning = TRUE)
```

Show main analysis code by default. Keep warnings visible until they have been reviewed; silence only a known, documented warning in the specific chunk that produces it. Use `echo=FALSE` for chunks that only create table footnotes, figure legends, captions, styling, inline interpretation text, or formatting glue. Keep each result adjacent to its essential footnote/legend and supporting graph. Do not add interpretive prose unless explicitly requested.

## Reporting Defaults

Read `clinical-reporting-guidelines.md` for full details.

- Render HTML at every step and review meaning, sense, Ns, denominators, and next step.
- Every table needs a heading; add only absolutely essential footnotes.
- Categorical variables use hierarchical rows: variable label, then category-value subrows.
- Exploratory continuous summaries show both mean (SD) and median (p25, p75).
- Final reporting and parametric/non-parametric tests are agreed with the researcher.
- Use 1 decimal for descriptive estimates, 2 for ORs and confidence bounds, and 3 for p values and standard errors. Include 95% CIs for important estimates.
- Set and record seeds for stochastic analysis, record relevant package versions, and include `sessionInfo()` at the end of the report.

## Render the Opinionated Example

Use the `ngroups` parameter for two or three groups; render from the skill root into a scratch directory. The example requires installed `flextable`, `officer`, `ggplot2`, `knitr` and `rmarkdown`; do not install missing packages without approval.

```r
rmarkdown::render(
  "examples/r/publication_tables.Rmd", output_format = "word_document",
  params = list(ngroups = 2), output_file = "two_group_example.docx",
  output_dir = "/absolute/scratch/path", envir = new.env()
)
```

Use `ngroups = 3` for three groups and `output_format = "html_document"` for review. The logistic example uses separate `glm(..., family = binomial())` fits and a prespecified joint model on the same complete-case sample, with `confint.default()` Wald bounds exponentiated alongside coefficients. It checks convergence, model N and finite estimates before printing. Researcher-approved study methods override the demonstration choices.
