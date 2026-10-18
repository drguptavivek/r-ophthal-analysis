# Refractive Error: Vision Layers, Exclusions and Denominators

Load this with `refractive-error-classification.md` (dioptric classification) whenever a study reports refractive error that needs correction, screening results, met or unmet need, or prevalence denominators. Record every choice in the charter.

## Three Layers

Dioptric classification gives the type of refractive error; visual acuity decides whether it matters. Keep three layers separate and never mix them in one prevalence.

### Layer 1: Screening (who is referred)

| Programme | Rule |
| --- | --- |
| India school programme | Snellen 6/9 optotype, each eye; teachers screen middle-school children (primary school at 6/12 in the Shukla 2018 pilot) |
| WHO 2025 handbook | Presenting VA with distance spectacles on, each eye, 3 m; pass = 3 or more symbols on the 6/12 line; refer if either eye fails or the child cannot be screened |
| Research cohorts (NIM, Joseph, Gupta 2019) | Unaided VA below 6/9.5 (logMAR 0.2) in either eye, or wearing spectacles |

WHO defines screening only: no dioptric, BCVA or prescribing criteria. Screening on presenting VA cannot count met need, because children with adequate spectacles pass.

### Layer 2: Refractive Status (dioptric)

Myopia, hyperopia, astigmatism only or emmetropia per eye, and the person categories (`refractive-error-classification.md`), among all children refracted, regardless of vision.

### Layer 3: Visually Significant Refractive Error (needs correction)

A child has visually significant refractive error when all of these hold:

1. Unaided VA worse than the threshold in either eye (primary) or in the better eye (VI-comparable, secondary).
2. That eye improves with correction to 6/9 or 6/9.5 or better, or by at least 2 lines over unaided VA. Improvement to "6/12 or better" alone is not enough, because an eye at 6/12 unaided and 6/12 corrected has not improved.
3. That eye is ametropic by the dioptric classification (myopia, hyperopia or astigmatism only). Its type comes from the person categories.

Threshold: India's 6/9 Snellen and the research cohorts' 6/9.5 (logMAR 0.2) are the same cut-off on different charts; use the one matching the chart, as primary. Report WHO's 6/12 as a sensitivity analysis for international comparison. Use unaided VA, never presenting VA, for this layer.

| | Unaided VA below threshold, improves with correction | Unaided VA at or above threshold |
| --- | --- | --- |
| Ametropic | Visually significant refractive error | Refractive error without VA reduction (refractive status only) |
| Emmetropic | Inconsistent: recheck refraction and accommodation | Normal vision, emmetropic |

Unaided VA below threshold that does not improve goes to Exclusions below (referral: amblyopia or other cause).

### Met and Unmet Need

Among children with visually significant refractive error: met need = already wearing spectacles that give presenting VA at threshold or better in both eyes (Gupta 2019: 6/9.5 or better); unmet need = no spectacles; inadequate current spectacles = undermet need, not met. These feed school-age eREC (`who-ecim-erec-formulas.md`).

## Exclusions and Separate Categories

Report every one of these in the flow diagram with counts; never drop silently.

- BCVA below the threshold despite refraction (Gupta 2019: BCVA not reaching 6/12 in either eye): non-refractive or mixed cause (amblyopia, organic disease). Refer, and exclude from the refractive error analysis or report as its own category; state which.
- Refused or failed cycloplegia; non-cycloplegic refraction cannot classify hyperopia.
- Referred to ophthalmology before refraction (strabismus, media opacity, injury): classify by final diagnosis if available, otherwise "referred, unclassified".
- Not refracted because they passed screening: they are presumed non-cases only to the extent the validation subsample supports (NIM: random 10% of passes examined); report the missed fraction.
- Absent at examination, lost to follow-up, ungradable or unreliable VA.

## Two-Stage Screening Studies

School studies that screen first and refract only screen-positives measure **vision-reducing refractive error at the screening threshold**, not refractive error prevalence. Title results that way (for example "refractive error reducing unaided VA below 6/9") and do not compare them directly with fully refracted surveys.

Classify every child into exactly one row:

| Group | Classification |
| --- | --- |
| Not referred at screening (passed) | No RE (at the screening threshold) |
| Referred, but vision at or above threshold on retest | No RE (screening false positive) |
| Referred and refracted | Person category from `refractive-error-classification.md` (myopia, hyperopia, astigmatism/antimetropia, emmetropia), with the vision rules of Layer 3 |
| Referred, vision does not improve to threshold | Referred for other cause (see Exclusions); not RE |
| Dropped out at screening (absent, refused) | Reported separately; excluded from numerator and denominator |
| Dropped out at refraction (screen-positive, not refracted) | Reported separately; excluded from numerator and denominator (conservative estimate) |

Low myopia, hyperopia masked by accommodation and astigmatism with good unaided vision are counted as No RE by design. If a random sample of screen-passes was refracted (NIM: 10%), report how many of them had refractive error.

### Dropout at Refraction

Refraction-stage dropouts are screen-positives, so excluding them makes the prevalence conservative (a minimum estimate). Accept this and say so: report the complete-case estimate, state in the table note that it is conservative, and report the number and percentage of refraction dropouts beside it. No imputation or weighting for dropouts is needed while dropout is small.

Size of the underestimate (simulation in `examples/r/dropout_bias_simulation.R`, 2,000 replicates per scenario; screen-positive rate 5-20%, 70% of refracted screen-positives with RE; rerun `dropout_bias()` with a study's own values):

- If dropouts resemble completers, the relative underestimate is about equal to the refraction dropout percentage: relative bias = -d(1 - s)/(1 - s*d), where d is dropout among screen-positives and s the screen-positive rate. For example, at 10% dropout a true 7.0% prevalence is reported as 6.4%; at 20% dropout, as 5.7%.
- If dropouts have less RE than completers (for example, mild cases skipping refraction), the bias is about halved; if they have more, it is about 1.5 times larger.
- With 5,000 children screened, the bias exceeds the 95% CI half-width at about 10% dropout; with smaller samples the CI is wider, so larger dropout is tolerated before the bias exceeds sampling error.

Rule: up to 10% refraction dropout, report the complete-case estimate as conservative, with the dropout count. Above 10%, also report the upper estimate counting every refraction dropout as RE and compare dropouts with completers by age, sex and school; the complete-case estimate stays primary. Prespecify this cut-off in the charter.

## Denominators and Flow

Report the cascade: enrolled; screened (and screening dropouts); passed; referred; retested at or above threshold; refracted (and refraction dropouts); vision not improving (referred for other cause); classified by person category. State which denominator each estimate uses. Use the survey design for school clusters (`clinical-survey-prevalence.md`).

Sources: WHO. Vision and hearing screening for school-age children: implementation handbook. 2025. Shukla P, Vashist P, et al. Indian J Ophthalmol 2018 (India school programme, teacher screening). Gupta V et al. Optom Vis Sci 2019. Joseph E et al. Br J Ophthalmol 2022. Saxena R et al. (NIM).

Related: `refractive-error-classification.md`, `school-eye-health.md`, `who-ecim-erec-formulas.md`, `myopia.md`.
