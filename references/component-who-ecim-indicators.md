# Component: WHO ECIM Indicators

Use this component when defining WHO ECIM / integrated eye care monitoring indicators such as effective cataract surgical coverage and effective refractive error coverage.

Read `who-ecim-indicator-formulas.md` before coding WHO ECIM eCSC/eREC indicators, or the companion CSC/REC formulas used to interpret them.

Always state:

- that these are WHO ECIM population monitoring indicators, not clinical coverage or individual-care quality formulas
- person-level versus eye-level indicator
- visual acuity variable: UCVA, PVA, BCVA, CVA, or pinhole VA
- for eREC, whether the component rules are UCVA-based or PVA-based
- threshold for need and threshold for effective outcome
- whether the indicator uses better eye, operated eye, fellow eye, any eye, or both eyes
- met, undermet, and unmet need components for refractive error indicators
- whether formulas come from the user's legacy Stata comments, definition PPT, WHO/IPCEC, RAAB6, RAAB7, Keel, Ramke, or another source

Do not implement a WHO ECIM indicator from memory alone. If local Stata or PPT comments exist, treat them as the working source and preserve their component names in the `.Rmd`.

For eREC, never silently substitute PVA for UCVA. If the project uses a PVA-based alternative, label it as PVA-based or RAAB6-style in code, tables, and captions.
