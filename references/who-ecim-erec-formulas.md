# eREC and REC Formulas

Load this before coding effective refractive error coverage (eREC) or refractive error coverage (REC). These are person-level population monitoring indicators based on the better eye. Cataract indicators are in `who-ecim-ecsc-formulas.md`.

Sources (checked against the papers):

- WHO. Report of the 2030 targets on effective coverage of eye care. Geneva: WHO; 2022 (Table 3, Annex 1, Annex 2).
- McCormick I, Mactaggart I, Bastawrous A, Burton MJ, Ramke J. Effective refractive error coverage: an eye health indicator to measure progress towards universal health coverage. Ophthalmic Physiol Opt 2020. doi:10.1111/opo.12662.
- Bourne RRA, Cicinelli MV, Selby DA, et al. Effective refractive error coverage in adults: a systematic review and meta-analysis of updated estimates from population-based surveys in 76 countries. Lancet Glob Health 2025; 13: e1396-405 (PVA-based alternative).
- Vashist P, Grover S, Manna S, et al. Rapid survey for assessing eCSC and eREC. Indian J Ophthalmol 2024; 72: 1321-28 (WHO four-component form, including near eREC).
- Gupta V, Vashist P, Saxena R. Effective refractive error coverage: changing definitions influence estimates. Lancet Glob Health 2026; 14: e18.
- RAAB7 analysis code, `github.com/raabteam/raab7-analysis`.

Check the protocol's own definition before coding.

## Before Coding

Record in the charter: which definition below, threshold T (usually 6/12 distance, N6 near), whether component rules are UCVA-based or PVA-based, whether refractive surgery is a component, and how "corrected" VA is measured (with own spectacles, pinhole, or refraction). Never silently substitute PVA for UCVA; name PVA-based results as such.

PVA-based eREC overestimates UCVA-based eREC substantially: 1.1-3.4 times (Keel 2021) and 1.13-3.45 times, an absolute 10-25 percentage points, varying by age, in Indian district surveys (Gupta 2026). When UCVA was measured, use the UCVA-based definition as primary. If a PVA-based estimate is reported, label it in the table title, report the UCVA-based estimate alongside where possible, and never compare PVA-based and UCVA-based estimates across surveys or years as if they measured the same thing.

## Primary: Distance eREC, WHO 2022 (Table 3)

Use when UCVA was measured. This is the default for new surveys.

```text
eREC = (a + b) / (a + b + c + d)
```

- `a` met need: better-eye UCVA worse than T, presents with distance spectacles or contact lenses, and better-eye PVA at least T.
- `b` met need: history of refractive surgery and better-eye UCVA at least T.
- `c` undermet need: better-eye UCVA worse than T, presents with distance correction, PVA worse than T, but at least T on pinhole or BCVA.
- `d` unmet need: better-eye UCVA worse than T, no distance correction, at least T on pinhole or BCVA.

The report gives no REC formula. By analogy, REC = (a + b + c) / (a + b + c + d); label it as derived. The report's published REC/eREC quality gap used PVA at least 6/18 as the good outcome; state the threshold used.

## Current Variants

Choose by what the survey measured, and name the variant in every table title.

| Variant | Use when |
| --- | --- |
| McCormick / RAAB7 | UCVA measured but refractive-surgery history not recorded (RAAB7) |
| WHO Annex 2, PVA-based | UCVA not measured, for example pooling older surveys (Bourne 2025); secondary only |
| WHO Annex 1, near | near vision tested; report separately from distance eREC |

### Distance eREC, McCormick / RAAB7

```text
eREC = a / (a + b + c)        REC = (a + b) / (a + b + c)
```

- `a` met: wears distance spectacles, better-eye UCVA worse than T, better-eye corrected VA (with own spectacles) at least T.
- `b` undermet: wears distance spectacles, UCVA worse than T, corrected VA worse than T, pinhole at least T.
- `c` unmet: no distance spectacles, UCVA worse than T, pinhole at least T.

No refractive-surgery term. This is the McCormick 2020 definition, implemented in RAAB7, and equals the WHO definition without the refractive-surgery term. Name outputs `eREC_raab7` / `REC_raab7`.

### Distance eREC, PVA-Based Alternative (WHO Annex 2)

```text
eREC = a / (a + b + c)        REC = (a + b) / (a + b + c)
```

- `a` met: presents with distance spectacles or contact lenses (or has had refractive surgery) and better-eye PVA at least T.
- `b` undermet: same correction, better-eye PVA worse than T, but at least T on pinhole or refraction.
- `c` unmet: better-eye PVA worse than T, no correction, at least T on pinhole or refraction.

This is the definition used by Bourne 2025. It overestimates the UCVA-based indicator (see Before Coding). Name outputs `eREC_pva612`, never `eREC_who`.

### School-Age eREC (PVA-Based)

School studies often lack UCVA and refractive surgery history and use a PVA-based McCormick form (Prakash 2024, Telangana): met need = wearing correction with better-eye PVA 6/12 or better; undermet = wearing correction with PVA worse than 6/12; unmet = PVA worse than 6/12 without correction; eREC = met / (met + undermet + unmet). Label it PVA-based; it is not comparable with UCVA-based adult eREC.

### Near eREC (WHO Annex 1)

```text
eREC_near = a / (a + b + c)
```

WHO states the distance-BCVA restriction (at least 6/12 in at least one eye) for `b` and `c`; RAAB7 code applies it to `a` too, following the WHO supplementary flow chart. State which.

- `a` met: UCVA worse than N6 at 40 cm, presents with near spectacles, PVA at least N6.
- `b` undermet: presents with near spectacles, PVA worse than N6.
- `c` unmet: no near correction, UCVA worse than N6.

## Required Checks

- Show counts of every component (a, b, c, and d where used), the denominator, and the final binary indicator before any model.
- Components are mutually exclusive; persons outside the denominator have a missing indicator, not 0.
- eREC at most REC with the same components; met plus undermet plus unmet equals the denominator.
- Keep legacy names in a crosswalk when translating, for example `canMeasureEREC`, `aRECraab7`, `bRECraab7`, `cRECraab7`, `denomRECraab7`, `eRECraab7`. Older RAAB6-style `eRECraab6` variables are PVA-based (Annex 2 structure without refractive surgery); treat them as historical.

Related: `who-ecim-ecsc-formulas.md`, `myopia.md`, `clinical-raab-surveys.md`, `school-eye-health.md`, `refractive-error-vision-layers.md`.
