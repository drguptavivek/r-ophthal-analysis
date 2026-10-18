# Refractive Error Case Classification

Load this before deriving myopia, hyperopia, astigmatism or "refractive error" variables in school or population studies. Screening, visually significant refractive error, met and unmet need, exclusions and denominators are in `refractive-error-vision-layers.md`. Thresholds by study are in `myopia.md`; programme outcomes in `school-eye-health.md`. Record every choice below in the charter before coding; each changes prevalence.

## Default Scheme: Joseph et al. 2022 (REACH)

Use this unless the protocol names another; it is the largest Indian school dataset with fully stated rules (Joseph E et al. Br J Ophthalmol 2022, doi:10.1136/bjo-2022-322123).

| Element | Joseph 2022 rule |
| --- | --- |
| Screening | 6/9.5 (logMAR 0.2) optotypes at 3 m, plus a +1.50 D lens test for latent hyperopia, plus torch light examination |
| Refraction | Retinoscopy and subjective refraction; cycloplegic retinoscopy for children aged 10 or under, or with esodeviation, hyperopia with asthenopia, more than 2 D difference from existing spectacles, fluctuating retinoscopy, myopia with more than 0.75 D retinoscopy-subjective discrepancy, or dynamic retinoscopy lag over 1.00 D |
| Recorded as | Both SE and the unadjusted spherical component; minus-cylinder form |
| Myopia | SE -0.50 D or worse |
| Hyperopia | SE +1.00 D or more (this skill adds: or sphere +1.00 D or more, if not myopic; see Adopted Case Definition) |
| Astigmatism | Cylinder 0.50 D or more; typed as simple myopic (sphere 0), compound myopic (negative sphere), "mixed" (positive sphere) |
| Anisometropia | Absolute interocular SE difference over 1.00 D |
| Refractive error | Myopia plus hyperopia (SE); astigmatism reported separately |
| Person level | Joseph: eye with the lower refractive error ("better eye"). This skill: nine categories from the eye pair as primary, Joseph's rule as secondary (section 3) |
| Referral, excluded from refractive classification | Vision not improving beyond logMAR 0.2 in either eye with refraction, or cause of VI undetermined |
| Denominators | Report prevalence over all children screened and over children given detailed evaluation |

Joseph's "mixed" (any positive sphere with cylinder) includes compound hyperopic astigmatism; the optical definition of mixed astigmatism (one meridian myopic, the other hyperopic) is narrower. Label which is used.

## 1. Inputs Per Eye

- Sphere (S), cylinder (C), axis, from cycloplegic refraction (agent stated); UCVA, PVA, BCVA (or pinhole) on a stated chart; spectacles worn and their power (focimetry).
- Use one cylinder sign convention. Convert plus-cylinder to minus-cylinder before deriving anything: S' = S + C, C' = -C, axis' = axis +/- 90.
- Use the final prescription source consistently (cycloplegic retinoscopy, autorefraction, or post-cycloplegic subjective), never a mix.

## 2. Per-Eye Classification

| Variable | Rule (prespecify thresholds; examples in `myopia.md`) |
| --- | --- |
| SE | S + C/2 |
| Myopia | SE at or below the myopia threshold (IMI: -0.50 D) |
| Hyperopia | SE at or above the hyperopia threshold (+0.50, +1.00 or +2.00 D; age-dependent; cycloplegic only) |
| Emmetropia | Neither myopia nor hyperopia |
| Astigmatism | Absolute cylinder at or above its threshold (0.50, 0.75 or 1.00 D), judged on C, not on SE |
| Astigmatism type | Simple (one meridian plano), compound (both meridians myopic or both hyperopic), mixed (S and S + C of opposite signs) |
| Magnitude band | For example low or high myopia (high at -6.00 D or worse); prespecify bands |

Spherical status (myopia, emmetropia, hyperopia) and astigmatism are separate axes: an eye can be myopic and astigmatic. Report astigmatism as its own flag, and only build mutually exclusive categories with an explicit rule (section 3).

### Adopted Case Definition (Joseph 2022, Adapted)

All cylinders are first standardised to negative (step 1 of section 4). Then, per eye:

| Category | Rule |
| --- | --- |
| Myopia | SE -0.50 D or worse |
| Hyperopia | Not myopic, and SE +1.00 D or more or sphere +1.00 D or more |
| Astigmatism only | Neither myopic nor hyperopic, and absolute cylinder 0.50 D or more |
| Emmetropia | Neither myopic nor hyperopic, and cylinder below 0.50 D |
| Astigmatism (flag) | Absolute cylinder 0.50 D or more, in any category; counts astigmatism alongside myopia or hyperopia |
| Any ametropia | Myopia, hyperopia or astigmatism only |

The first four rows are mutually exclusive and cover every refracted eye. Subtype astigmatism only as simple myopic (sphere 0), mixed (sphere and sphere plus cylinder of opposite signs) or simple hyperopic; "mixed" is used only in this optical sense, never for the whole group. For example 0.00 / -0.75 (SE -0.375) and +0.50 / -1.50 (SE -0.25) are astigmatism only.

- Myopia stays SE-based, as in Joseph. In minus-cylinder form a sphere-based myopia rule would add no cases, because a sphere of -0.50 D or worse always gives an SE of -0.50 D or worse.
- Hyperopia adds sphere-based cases to Joseph's SE-based rule. It captures eyes whose hyperopic meridian is hidden by SE averaging, for example +2.00 / -2.50 (SE +0.75). The myopia check comes first, so +1.00 / -3.50 (SE -0.75) stays myopic.
- Report the number of hyperopic eyes or children added by the sphere rule, so results stay comparable with Joseph's SE-only hyperopia.
- Avoid "ametropic refractive error"; ametropia already means refractive error.

## 3. Person-Level Classification

Prespecify one rule; name it in every table title.

| Rule | Person classified by | Used by |
| --- | --- | --- |
| Either eye | Any eye meeting the definition | NIM, NIM-R (myopia) |
| Worse eye | The eye with the larger ametropia for that outcome (most negative SE for myopia, most positive for hyperopia) | Prakash 2022, 2024 |
| Lower-error eye | The eye with the smaller absolute SE (called "better eye" in REACH) | Joseph 2022 |
| Right eye | Right eye only | NICER; Guangzhou trial |
| Both eyes | Eye-level analysis clustered within child | Models |

Either-eye and worse-eye rules can place one child in two categories (antimetropia: one eye myopic, the other hyperopic). Fix a hierarchy for a mutually exclusive variable, for example myopia, then hyperopia, then astigmatism only, then emmetropia, and report the number of children reclassified. Anisometropia (interocular SE difference above a stated threshold, often 1.00 D) is a separate flag.

### Adopted Person-Level Classification

Cross the two eyes' categories (myopia M, hyperopia H, astigmatism only A, emmetropia E). The 16 right-left combinations reduce to 10 unordered pairs and 9 person categories, which are the primary person-level output:

| Person category | Eye pair |
| --- | --- |
| Bilateral myopia | M + M |
| Unilateral myopia | M + E |
| Unilateral myopia with astigmatism | M + A (astigmatism only in the fellow eye) |
| Bilateral hyperopia | H + H |
| Unilateral hyperopia | H + E |
| Unilateral hyperopia with astigmatism | H + A (astigmatism only in the fellow eye) |
| Astigmatism alone | A + A or A + E (report bilateral and unilateral as sub-rows) |
| Antimetropia | M + H |
| Emmetropia | E + E |

Collapsed four-level summary (derived from the nine categories; report both):

| Summary category | Person categories included |
| --- | --- |
| Myopia | Bilateral myopia, unilateral myopia, unilateral myopia with astigmatism |
| Hyperopia | Bilateral hyperopia, unilateral hyperopia, unilateral hyperopia with astigmatism |
| Astigmatism / antimetropia | Astigmatism alone, antimetropia |
| Emmetropia | Emmetropia (both eyes); not "normal", since vision may still be reduced from other causes |

Antimetropic children appear in neither myopia nor hyperopia in this summary, so also report "any myopia" and "any hyperopia" (below) when comparing with other studies.

- Any myopia = the three myopia categories plus antimetropia; any hyperopia = the three hyperopia categories plus antimetropia; any ametropia = every category except emmetropia.
- "With astigmatism" in these names refers to the fellow eye. Astigmatism in the myopic or hyperopic eye itself is carried by the per-eye astigmatism flag; report it as a separate cross-tabulation.
- Add a fifth eye state, not classifiable (not refracted, unreliable refraction, BCVA below threshold, hyperopia not assessable without cycloplegia). Children with one or two such eyes go in their own rows ("myopia + not classifiable" and so on), never into a category by assumption.
- The lower-error-eye rule (Joseph) and the either-eye rule in section 3 are secondary analyses for comparison with published studies.

## 4. Derivation Logic (Software-Neutral)

Map the dataset's own variable names to these concepts in the charter, then apply in order. Defaults are Joseph 2022; replace thresholds if the protocol differs.

1. Put every refraction in minus-cylinder form: if a record is in plus-cylinder, new sphere = sphere + cylinder, new cylinder = minus the old cylinder, axis rotated by 90 degrees.
2. For each eye with a refraction: SE = sphere + half the cylinder.
3. For each eye: myopic if SE is -0.50 D or lower; otherwise hyperopic if SE is +1.00 D or higher or the sphere is +1.00 D or higher; otherwise astigmatism only if the absolute cylinder is 0.50 D or more; otherwise emmetropic. Separately, flag astigmatism (absolute cylinder 0.50 D or more) in every category. Flag hyperopic eyes that qualified only by sphere. An eye with no refraction stays missing on all of these, never "no".
4. Astigmatism type per astigmatic eye: sphere exactly 0 = simple myopic; sphere negative = compound myopic; sphere positive = "mixed" (Joseph). Separately flag optical mixed astigmatism when the sphere and sphere-plus-cylinder have opposite signs.
5. Lower-error eye ("better eye", Joseph; secondary analysis only): the eye whose SE is closer to zero; if only one eye was refracted, use that eye and record that the person was classified on one eye.
6. Lower-error-eye myopia and hyperopia (secondary, Joseph-comparable): apply the step 3 rules to the lower-error eye.
7. Myopia in either eye (equals "any myopia" from the person categories): yes if either eye is myopic; no only if both eyes were refracted and neither is myopic; otherwise missing.
8. Anisometropia: both eyes refracted and absolute SE difference over 1.00 D; missing if either eye is missing.
9. Any ametropia: myopic, hyperopic or astigmatism only. Report the count of hyperopia added by the sphere rule and of astigmatism-only eyes with their subtypes.
10. Person category: cross the two eyes' categories and assign one of the nine person categories (section 3, Adopted Person-Level Classification); a child with any not-classifiable eye goes in a not-classifiable row. Antimetropia is the M + H pair and needs both eyes refracted.
11. Before step 3, set aside children whose vision did not improve beyond logMAR 0.2 (6/9.5) in either eye with refraction, or whose cause of VI was undetermined: they are referred and reported as their own category, not classified as refractive error.
12. Some software treats missing values as true in logical tests: always test "equals yes" explicitly, and check counts of missing at every step.

Tabulate each per-eye flag against the person-level variable, and the excluded categories, before any model.

Sources: Joseph E et al. Br J Ophthalmol 2022, doi:10.1136/bjo-2022-322123 (default scheme); other definitions as cited in `myopia.md`: Saxena R et al. (NIM, NIM-R); Gupta V et al. Optom Vis Sci 2019; Joseph E et al. Br J Ophthalmol 2022; Prakash WD et al. 2022, 2024; O'Donoghue L et al. 2012 (NICER); He M et al. JAMA 2015; Wolffsohn JS et al. IOVS 2019 (IMI).

Related: `refractive-error-vision-layers.md`, `myopia.md`, `school-eye-health.md`, `who-ecim-erec-formulas.md`, `clinical-variable-coding.md`, `clinical-ophthalmology-guidelines.md`.
