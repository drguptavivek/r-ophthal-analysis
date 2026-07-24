# Component: R Markdown and Reporting

Use this component before producing any table, figure, or result output.

## R Markdown Structure

Use headings and subheadings for the analysis charter, data governance, reproducibility setup, source-data provenance, data audit, missing-data plan, cleaning/recoding, analytic dataset freeze, simple tables, key outcomes, figures, deeper models, interpretation notes, and appendices.

Set chunk defaults deliberately:

```r
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning = TRUE)
```

Show main analysis code by default. Keep warnings visible until they have been reviewed; silence only a known, documented warning in the specific chunk that produces it. Use `echo=FALSE` for chunks that only create table footnotes, figure legends, captions, styling, inline interpretation text, or formatting glue. Keep each result adjacent to its footnote/legend and interpretation.

## Reporting Defaults

Read `clinical-reporting-guidelines.md` for full details.

- Render HTML at every step and review meaning, sense, Ns, denominators, and next step.
- Every table needs a heading and footnote.
- Categorical variables use hierarchical rows: variable label, then category-value subrows.
- Exploratory continuous summaries show both mean (SD) and median (p25, p75).
- Final reporting and parametric/non-parametric tests are agreed with the researcher.
- Use 1 decimal for major estimates, 3 decimals for p values and standard errors, and 95% CIs for important estimates.
- Set and record seeds for stochastic analysis, record relevant package versions, and include `sessionInfo()` at the end of the report.
