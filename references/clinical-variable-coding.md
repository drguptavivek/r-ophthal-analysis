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
- Document labels, value labels, units, and coding decisions in `030_derive_label_freeze` and the charter decision log.
- Before freezing/exporting, check categorical order and labels match clinical meaning.

## Refer to Categories by Label

Write conditions against value labels, never bare integers: the same integer means different things across datasets and survey versions, and a wrong integer fails silently while a wrong label fails loudly. Resolve each label to its code once at the top of the file and stop if any is missing.

```stata
local CATARACT = "Cataract, untreated":causelb
local SURGCOMP = "Cataract surg. complications":causelb
local NOVIEW   = "No View":lens
assert !missing(`CATARACT', `SURGCOMP', `NOVIEW')   // a misspelt label resolves to missing
gen byte op_re = inlist(lere, "Aphakia":lens, "Pseudophakia without PCO":lens, "Pseudophakia wit PCO":lens) | ///
    (lere == `NOVIEW' & causere == `SURGCOMP')
```

```r
cause_re <- haven::as_factor(raab$causere, levels = "labels")
stopifnot(c("Cataract, untreated", "Cataract surg. complications") %in% levels(cause_re))
cataract_re <- cause_re == "Cataract, untreated"
```

Copy label text exactly from the dataset (`label list`, `levels()`), including typos in the original labels. Show the resolved code-label mapping in the report.

## Export

For frozen analytic datasets, prefer rich labelled formats such as Stata `.dta` or SPSS `.sav` over CSV-only exports.

For Stata, keep variable names Stata-compatible and use `haven::write_dta()`. For SPSS, use `haven::write_sav()`. Document labelled-value conversion and user-defined missing values before export.

If the user also needs CSV, export CSV as a secondary interoperability copy and state that labels/value labels are preserved in `.dta`/`.sav`, not in CSV.

Related: `component-data-management.md`, `clinical-raab-surveys.md`.
