# Clinical Reporting Guidelines

Use these guidelines for manuscript tables, figures, and statistical reporting.

## Core Standards

- Keep outputs reproducible from top to bottom in the central `.Rmd`.
- Structure the `.Rmd` in short sections: study setup, package/helper setup, data import, data audit, cleaning/recoding, analytic dataset freeze, simple tables, key outcomes, figures, deeper models, interpretation notes, and appendices.
- Use explicit headings and subheadings in the rendered report so each phase, table, figure, and interpretation section is easy to find.
- Show main analysis code by default so the analysis remains auditable.
- Use `echo=FALSE` for chunks that only produce table footnotes, figure legends, captions, styling, inline interpretation text, or formatting glue.
- Keep result, footnote/legend, and immediate interpretation adjacent in the rendered HTML without unrelated printed code between them.
- Use chunk labels and explicit chunk options. Prefer a setup chunk that sets defaults deliberately, for example `knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning = FALSE)`, then override specific helper/output chunks with `echo=FALSE`.
- Prefer compact scientific publication style tables.
- Every table must have a clear heading and a footnote.
- Table footnotes must define abbreviations, units, statistical tests, denominators, and missing-data handling when relevant.
- Do not use em dashes in tables or manuscript text.
- Save figures to readable filenames when the user asks where figures live.
- Save figures in `figs/` unless the project has a pre-existing figure directory.
- Save rendered outputs, manuscript tables, and model summaries in `results/` unless the project has a pre-existing results directory.
- Avoid row-level identifiers in reports unless necessary and explicitly requested.
- Preserve patient privacy in summaries.

## Numeric Formatting

- Format percentages, means, SDs, ORs, RRs, HRs, incidence rates, and other major point estimates to 1 decimal place unless the user requests otherwise.
- Format p-values and standard errors to 3 decimal places.
- Estimate and report 95% confidence intervals for ORs, RRs, HRs, prevalences, incidences, incidence rates, and other important point estimates.
- For diagnostic-test analyses, report 95% CIs for all estimable metrics, including sensitivity, specificity, PPV, NPV, accuracy, F1, Youden index, LR+, LR-, diagnostic odds ratio, NNS, AUROC/AUC, and threshold-specific estimates. Bootstrap CIs are acceptable and often preferred for derived metrics without simple closed-form intervals.
- Present confidence intervals with comma-separated lower and upper bounds, not hyphens, to avoid confusion with negative numbers.
- Use examples such as `OR 1.4 (95% CI 1.1, 1.8)` and prevalence `23.5% (95% CI 19.1, 28.4)`.

## Table Refinement

- Build simple tables first, starting with background characteristics.
- During exploratory analysis, show both mean (SD) and median (p25, p75) for continuous variables to assess distribution and guide parametric versus non-parametric handling.
- For final publication tables, do not automatically report both summaries for every continuous variable. Discuss with the researcher whether to report mean (SD), median (p25, p75), or both, and keep the selected summary and test choice consistent.
- For categorical variables, use a hierarchical row layout in column 1: the first row is the variable label, and the second, third, and later rows are the category values within that variable.
- Do not split a variable and its category values across separate label columns or across awkward repeated labels. The reader should see one variable block with clear category-value subrows.
- Estimate key outcomes before deeper models.
- Refine tables one by one with user feedback.
- Add graphs only where they support results.
- Move to regression, regression diagnostics, and sensitivity analysis only after the basic tables and key outcome estimates are agreed.
