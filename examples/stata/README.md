# Stata Collect Examples

- [Survey prevalence](svyprev.do): `svyprev` program for binary or multinomial prevalence with 95% logit CI and DEFF by group, read by coefficient name; see `../../references/clinical-survey-prevalence.md`.
- [Table 1](example_stata_table1.do): native `dtable`/`collect` for continuous and categorical blocks, observed Ns, group columns, unadjusted p and indented subrows; continuous table followed by graphs.
- [Logistic regression](example_stata_logistic.do): native logistic estimates collected into variable/category, N, outcome %, univariable OR [95% CI] and multivariable OR [95% CI], with reference rows and multivariable model statistics.

Each file is self-contained. Run from the skill root using an absolute scratch output directory:

```stata
do examples/stata/example_stata_table1.do 2 "/absolute/scratch/table1_two"
do examples/stata/example_stata_table1.do 3 "/absolute/scratch/table1_three"
do examples/stata/example_stata_logistic.do 2 "/absolute/scratch/logistic_two"
do examples/stata/example_stata_logistic.do 3 "/absolute/scratch/logistic_three"
```

Each preserves a raw log, numeric collection and editable Word output. See `../../references/component-stata-reporting.md` for requirements and verification. Data are synthetic; models/tests require researcher approval before clinical use. Hierarchical indented categories are the default; no Holm columns or automatic interpretation. Only essential notes, including requested multivariable N, LR chi-square (df, p), -2LL and McFadden pseudo-R-squared, are printed.
