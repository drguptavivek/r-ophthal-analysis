# WHO ECIM Indicator Formulas

Use this reference for WHO ECIM ophthalmology indicators. These are public-health monitoring indicators; do not treat them as generic clinical coverage, service-quality, or individual-care adequacy formulas.

Keep the formula and component definitions visible in the `.Rmd` before coding derived variables.

## General Rules

- WHO ECIM indicators are usually person-level binary indicators with an explicit eligible denominator.
- Build and tabulate every component before the final indicator.
- Report numerator, denominator, percent, and 95% CI.
- For surveys, estimate indicators using the approved survey design object and preserve cluster, FPC, weight, and standardization decisions.
- If translating legacy Stata, keep original variable names nearby, for example `eCSC612pva612`, `cSC612`, `RECraab7`, or `eRECraab7`.

## CSC Companion Formula

Classical person-level cataract surgical coverage:

```text
CSC = (x + y) / (x + y + z)
```

Components:

- `x`: unilateral operated cataract, regardless of visual acuity in the operated eye, with the other eye meeting the operable cataract need threshold.
- `y`: bilateral operated cataract, regardless of visual acuity.
- `z`: bilateral operable cataract meeting the need threshold in both eyes.

Common local variants:

- `cSC612`: operable cataract threshold 6/12.
- `cSC618`: operable cataract threshold 6/18.
- `cSC660`: operable cataract threshold 6/60.
- `cSC360`: operable cataract threshold 3/60.

## WHO ECIM eCSC

Effective cataract surgical coverage:

```text
eCSC = (a + b) / (x + y + z)
```

Generic components:

- `a`: unilateral operated cataract with good postoperative presenting visual acuity in the operated eye and the other eye meeting the operable cataract need threshold.
- `b`: bilateral operated cataract with good postoperative presenting visual acuity in at least one eye.
- `x`: unilateral operated cataract, regardless of visual acuity in the operated eye, with the other eye meeting the operable cataract need threshold.
- `y`: bilateral operated cataract, regardless of visual acuity.
- `z`: bilateral operable cataract meeting the need threshold in both eyes.

In one project-specific WHO 2022 RAAB convention, the compact variable name encodes need threshold and effective outcome threshold:

| Variable | Need threshold | Effective outcome threshold |
| --- | --- | --- |
| `eCSC612pva612` | BCVA worse than 6/12 | PVA at least 6/12 |
| `eCSC618pva612` | BCVA worse than 6/18 | PVA at least 6/12 |
| `eCSC618pva618` | BCVA worse than 6/18 | PVA at least 6/18 |
| `eCSC660pva612` | BCVA worse than 6/60 | PVA at least 6/12 |
| `eCSC660pva618` | BCVA worse than 6/60 | PVA at least 6/18 |
| `eCSC360pva612` | BCVA worse than 3/60 | PVA at least 6/12 |
| `eCSC360pva618` | BCVA worse than 3/60 | PVA at least 6/18 |

Keel/Ramke legacy variants add cataract-cause restrictions to the need components. Do not silently mix WHO 2022, Keel, Ramke, and classical definitions in one table; label the definition in the table caption or footnote.

## REC Companion Formula and WHO ECIM eREC

For refractive error indicators, define met, undermet, and unmet need explicitly before estimating REC/eREC.

RAAB6 convention from project definition notes:

```text
RECraab6  = (A + B) / (A + B + C)
eRECraab6 = A / (A + B + C)
```

- `A`: presents with spectacles or contact lenses for distance and PVA is at least 6/12 in the better eye. This is met need.
- `B`: presents with spectacles or contact lenses for distance and PVA is worse than 6/12 in the better eye, but improves to at least 6/12 on pinhole VA in the better eye. This is undermet need.
- `C`: presents without spectacles or contact lenses for distance and PVA is worse than 6/12 in the better eye, but improves to at least 6/12 on pinhole VA in the better eye. This is unmet need.

RAAB7 convention from project definition notes:

```text
RECraab7  = (A + B) / (A + B + C)
eRECraab7 = A / (A + B + C)
```

- `A`: presents with spectacles or contact lenses for distance, UCVA is worse than 6/12 in the better eye, and corrected VA is at least 6/12 in the better eye. This is met need.
- `B`: presents with spectacles or contact lenses for distance, UCVA is worse than 6/12 in the better eye, corrected VA is worse than 6/12 in the better eye, but improves to at least 6/12 on pinhole VA. This is undermet need.
- `C`: presents without spectacles, UCVA is worse than 6/12 in the better eye, and pinhole VA is at least 6/12 in the better eye. This is unmet need.

WHO ECIM eREC convention from project definition notes:

```text
eRECwho = (A + B) / (A + B + C + D)
```

- `A`: UCVA worse than 6/12 in the better eye, presents with spectacles or contact lenses for distance vision, and PVA is at least 6/12 in the better eye.
- `B`: history of refractive surgery and UCVA is at least 6/12 in the better eye.
- `C`: UCVA worse than 6/12 in the better eye, presents with distance correction, PVA remains worse than 6/12 in the better eye, but improves to at least 6/12 on pinhole or BCVA. This is undermet need.
- `D`: UCVA worse than 6/12 in the better eye, no distance correction, and improves to at least 6/12 on pinhole or BCVA. This is unmet need.

### PVA-Based Alternative eREC Definitions

Some local eREC analyses use presenting visual acuity for the component rules instead of uncorrected visual acuity. Treat these as alternative definitions unless the analysis protocol explicitly names them as the primary WHO ECIM definition.

RAAB6-style PVA-based REC/eREC:

```text
RECpvaT  = (A + B) / (A + B + C)
eRECpvaT = A / (A + B + C)
```

Use `T` for the effective threshold, usually 6/12.

- `A`: presents with spectacles or contact lenses for distance and better-eye PVA is at least `T`. This is met need.
- `B`: presents with spectacles or contact lenses for distance and better-eye PVA is worse than `T`, but improves to at least `T` on pinhole VA or BCVA. This is undermet need.
- `C`: presents without spectacles or contact lenses for distance and better-eye PVA is worse than `T`, but improves to at least `T` on pinhole VA or BCVA. This is unmet need.

WHO-structure PVA-based alternative, if the local protocol keeps the refractive-surgery component:

```text
eRECpvaWhoT = (A + B) / (A + B + C + D)
```

- `A`: presents with spectacles or contact lenses for distance and better-eye PVA is at least `T`.
- `B`: has a history of refractive surgery and better-eye PVA is at least `T`.
- `C`: presents with spectacles or contact lenses for distance and better-eye PVA is worse than `T`, but improves to at least `T` on pinhole VA or BCVA. This is undermet need.
- `D`: presents without distance correction and better-eye PVA is worse than `T`, but improves to at least `T` on pinhole VA or BCVA. This is unmet need.

Do not name a PVA-based alternative `eRECwho` in outputs unless the definition text clearly states the substitution. Prefer explicit names such as `eRECpva612`, `eRECraab6`, or `eRECpvaWho612`.

For local RAAB/eREC projects, preserve these existing variable names when present:

- `canMeasureAltREC`, `denomRECraab6`, `eRECraab6`
- `canMeasureEREC`, `aRECraab7`, `bRECraab7`, `cRECraab7`, `denomRECraab7`, `eRECraab7`

Before modelling eREC, show the component counts (`A`, `B`, `C`, and `D` where applicable), the denominator, and the final binary indicator.
