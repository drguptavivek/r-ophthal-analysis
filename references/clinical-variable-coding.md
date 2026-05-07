# Clinical Variable Coding and Labels

Load this during recoding, analytic dataset freeze, or export to Stata/SPSS.

## Coding and Labelling

- Use short, consistent, human-readable variable labels.
- Include units where applicable, for example `IOP, mmHg`, `Age, years`, `CCT, um`.
- Use numeric scales for categorical variables in analytic/export datasets.
- Preserve logical ordering, for example `0 = none`, `1 = mild`, `2 = moderate`, `3 = severe`.
- Collapse sparse categories with clinically adjacent/logically adjacent categories when needed, preserving order and documenting the reason. Researcher approval is required.
- For binary variables, use `0 = no event` and `1 = event`.
- Use variable-specific value labels, for example `0 = no progression`, `1 = progression`.
- Document labels, value labels, units, and coding decisions in the central `.Rmd`.
- Before freezing/exporting, check categorical order and labels match clinical meaning.

## Export

For frozen analytic datasets, prefer rich labelled formats such as Stata `.dta` or SPSS `.sav` over CSV-only exports.

For Stata, keep variable names Stata-compatible and use `haven::write_dta()`. For SPSS, use `haven::write_sav()`. Document labelled-value conversion and user-defined missing values before export.

If the user also needs CSV, export CSV as a secondary interoperability copy and state that labels/value labels are preserved in `.dta`/`.sav`, not in CSV.
