# Component: R Markdown and Reporting

Use this component for R Markdown output. For explicitly requested native Stata, use `component-stata-reporting.md`. Both follow `clinical-reporting-guidelines.md`.

Use `../examples/r/publication_tables.Rmd` for runnable, parameterised two-/three-group publication tables in HTML and Word. The example uses synthetic data and includes a unified Table 1, continuous outcome comparisons with an adjacent graph, and hierarchical logistic regression results. Comparison tables have unadjusted p only; models show N, outcome %, univariable OR [95% CI] and multivariable OR [95% CI], with no p columns. It contains no automatic interpretation.

## Output Settings

Every stage and analysis `.Rmd` uses a left floating table of contents, unnumbered headings, and folded code:

```yaml
output:
  html_document:
    toc: true
    toc_float:
      collapsed: false
    toc_depth: 3
    number_sections: false
    code_folding: hide
    df_print: kable
```

```r
knitr::opts_chunk$set(echo = knitr::is_html_output(), message = FALSE,
                      warning = TRUE, comment = NA)
```

Folded code stays in the HTML for audit behind "Code" buttons; Word output has no code. Render each file into `results/`, for example `rmarkdown::render("110_primary_outcome.Rmd", output_dir = "results")`.

## No Raw Output

The rendered report shows only headings, formatted tables, figures, and short text.

- Computing chunks assign results and print nothing.
- Never print model objects, `summary()`, `str()`, `head()`, `glimpse()`, bare data frames or tibbles, `table()` output, or package start-up messages. Put every result through `flextable`, `gt`, `gtsummary`, or `knitr::kable()`, or a figure.
- Use inline R for single values in text, for example N or a seed.
- Warnings remain visible until reviewed; silence only a known, documented warning in the chunk that produces it.
- The only permitted console-style output is `sessionInfo()` in the final Reproducibility record section.

## Reporting Defaults

Follow `clinical-reporting-guidelines.md` for tables, numeric formatting, CIs, footnotes and text limits, `clinical-regression-reporting.md` for model tables, and the Phase Report in `SKILL.md` at every step.

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

Related: `clinical-reporting-guidelines.md`, `clinical-regression-reporting.md`, `component-project-layout.md`.
