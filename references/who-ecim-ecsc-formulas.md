# eCSC and CSC Formulas

Load this before coding effective cataract surgical coverage (eCSC) or cataract surgical coverage (CSC). These are person-level population monitoring indicators, not clinical quality measures. Refractive error indicators are in `who-ecim-erec-formulas.md`; survey estimation is in `clinical-raab-surveys.md`.

Sources (checked against the papers):

- WHO. Report of the 2030 targets on effective coverage of eye care. Geneva: WHO; 2022 (Table 2).
- McCormick I, Butcher R, et al. Effective cataract surgical coverage in adults aged 50 years and older: estimates from population-based surveys in 55 countries. Lancet Glob Health 2022. doi:10.1016/S2214-109X(22)00419-3.
- Ramke J, Gilbert CE, Lee AC, et al. Effective cataract surgical coverage: an indicator for measuring quality-of-care in the context of Universal Health Coverage. PLoS One 2017; 12: e0172342, with S1 Table (RAAB variable code).
- RAAB7 analysis code, `github.com/raabteam/raab7-analysis` (McCormick, Butcher).
- Indian application: Gupta V, Vashist P, et al. Effective cataract surgical coverage in India: evidence from 31 districts. Indian J Ophthalmol 2024.

The Keel row below comes from project definition notes; confirm it against the original paper before citing it. Check the protocol's own definition before coding; never implement from memory.

## Before Coding

Use the WHO 2022 definition for all new analyses. Record in the charter: definition and source, need threshold T, good-outcome threshold O, VA variable for need (BCVA; in RAAB this is pinhole VA) and for outcome (PVA), operated-eye rule, and denominator population (examined participants only).

## Primary: WHO 2022 eCSC (also McCormick 2022, RAAB7)

```text
eCSC = (a + b) / (x + y + z)        CSC = (x + y) / (x + y + z)
Relative quality gap = (CSC - eCSC) / CSC
```

WHO labels the denominator components c, d, e; most code uses x, y, z.

- `a`: one eye operated with PVA at least O in that eye, and the other eye unoperated with BCVA worse than T.
- `b`: both eyes operated, with PVA at least O in at least one eye.
- `x`: one eye operated (any VA), and the other eye unoperated with BCVA worse than T. No cataract-cause condition on the other eye.
- `y`: both eyes operated, any VA.
- `z`: BCVA worse than T in both eyes, with cataract as the main cause of VI in one or both eyes. RAAB7 also requires both eyes unoperated and lens opacity in the cataract eye.

## Current Variants

The WHO structure is fixed; variants differ only in thresholds and implementation. Report the primary pair and name every variant in the table title.

| Variant | Need threshold T (BCVA/pinhole) | Good outcome O (PVA) | Use |
| --- | --- | --- | --- |
| WHO 2022 definition | worse than 6/12 | 6/12 or better | primary |
| WHO 2022 published estimates; McCormick 2022 main analysis | worse than 6/18 | 6/18 or better | comparison with global estimates |
| Mixed thresholds | 6/12 or 6/18 | 6/18 or 6/12 | sensitivity; quality gap by threshold |
| Severe-need thresholds | worse than 6/60 or 3/60 | 6/12 or 6/18 | comparison with older RAAB reports |

RAAB7 implements this structure with the operational rules below; its code names components `a_case_[O]_[T]`.

## Cataract Surgical Outcome (Eye-Level)

Surgical outcome describes operated eyes, separately from coverage. Report it with presenting VA (includes refractive and spectacle effects) and with pinhole VA (best achievable), so poor outcomes can be split into correctable and non-correctable.

| Category | RAAB7 code | Ramke 2017 (historical) |
| --- | --- | --- |
| Good | PVA 6/12 or better | PVA 6/18 or better |
| Borderline | worse than 6/12, 6/60 or better | worse than 6/18, 6/60 or better |
| Poor | worse than 6/60 | worse than 6/60 |

- RAAB7 counts eyes (each operated eye contributes); Ramke used the operated eye for unilateral and the better eye for bilateral surgery. State the unit and use person-level clustering when both eyes count.
- Cross-tabulate poor outcomes by cause (RAAB cause codes, by label) and by time since surgery, place and type of surgery.
- Couched eyes: report separately; they are not operated for coverage.

## Historical Definitions

Ramke 2017 (classical eCSC: for a and x, the other eye has lens opacity, cataract as cause, and pinhole worse than T; for z, both eyes have lens opacity and pinhole worse than T, with no cause condition in its S1 code), Keel (project notes), and classical CSC (Limburg) are of historical significance only. Use them solely to reproduce or compare with earlier published estimates, label them, and never mix them with WHO 2022 in one table. Name legacy author-labelled variables by their thresholds.

## Operational Rules

- Operated eye (RAAB7): aphakia without couching, pseudophakia with or without PCO, or No View with cataract surgical complications as the cause. Couched eyes are excluded from x, y, a and b (McCormick 2022).
- No View eye with cataract surgical complications as the cause counts as operated. Defining operated as lens codes 3-5 alone misses these eyes, so a person with one pseudophakic eye and one such eye falls out of y and can land in x or z instead. Write it against value labels, not integers (pattern in `clinical-variable-coding.md`): operated = aphakia or pseudophakia lens labels, or the No View lens label with the cataract-surgical-complications cause label.
- No View with any other cause is a documented choice; record it in the charter. RAAB7 treats it as unoperated; some local code excludes it from "unoperated" conditions. The two give different x and z counts.
- Before coding, tabulate lens status by cause for each eye (`tab lere causere if lere == "No View":lens`) and report how many No View eyes were reclassified as operated.
- Denominator: examined participants only. Persons outside x, y and z have a missing indicator, not 0.
- Code cause, lens and VA conditions by value label, not integer (`clinical-variable-coding.md`). A wrong integer (uncorrected aphakia instead of untreated cataract) silently empties `a` and `x`; a wrong label stops the run. VA codes also change between RAAB versions: in Ramke 2017 S1 (RAAB5) `pva == 1` means 6/18 or better, while in RAAB6 exports 1 commonly means 6/12 or better; see `clinical-raab-surveys.md`.
- Thresholds grid: T in 6/12, 6/18, 6/60, 3/60; O in 6/12, 6/18. Name variables so both are visible, for example `eCSC_T612_O612`, and keep a crosswalk to legacy names (`eCSC612pva612` = need 6/12, outcome 6/12; RAAB7 `a_case_612_618` = outcome 6/12, need 6/18).

## Required Checks

Tabulate a, b, x, y, z before the indicator and assert:

- `a` implies `x`; `b` implies `y`; numerator at most denominator.
- eCSC at most CSC at the same T and O; eCSC with O = 6/18 at least eCSC with O = 6/12.
- Every component count is above 0, or the zero is explained.
- No View eyes with cataract surgical complications are counted as operated, and their number is reported.
- Persons in neither numerator nor denominator have a missing indicator.

Related: `who-ecim-erec-formulas.md`, `clinical-raab-surveys.md`, `clinical-survey-prevalence.md`, `burden-projection.md`.
