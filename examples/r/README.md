# R Examples

- [Publication tables](publication_tables.Rmd): unified hierarchical Table 1, two-/three-group outcome tables followed by their graph, and logistic regression with category N, outcome %, univariable and multivariable OR [95% CI].

Render from the skill root to an absolute scratch directory:

```r
rmarkdown::render("examples/r/publication_tables.Rmd",
  output_format = "word_document", params = list(ngroups = 2),
  output_file = "r_two_groups.docx", output_dir = "/absolute/scratch/r",
  envir = new.env())
```

Use `ngroups = 3` for three groups and `html_document` for review. See `../../references/component-rmd-reporting.md` for dependencies and validation. Data are synthetic; models/tests require researcher approval before clinical use. Tables default to indented hierarchy, no Holm columns, no automatic interpretation and only essential notes. The logistic note reports multivariable N, LR chi-square (df, p), -2LL and McFadden pseudo-R-squared.
