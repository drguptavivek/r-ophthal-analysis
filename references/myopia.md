# Myopia and Refractive Error Studies

Load this for refractive error or myopia prevalence, incidence, progression, school screening, spectacle coverage, outdoor-time or myopia-control trials. Coverage indicators (eREC, REC) are in `who-ecim-erec-formulas.md`; repeated-measures methods in `clinical-longitudinal-repeated.md`.

## Classification

The step-by-step case classification (per eye, person level, exclusions, Joseph 2022 default) is in `refractive-error-classification.md`.

- Spherical equivalent (SE) = sphere + cylinder / 2, from cycloplegic refraction in children. Record agent, dose, wait, completeness check, and instrument (NIM: 2% homatropine, cycloplegia complete at pupil 6 mm or more; Guangzhou trial: 1% cyclopentolate, 3 drops).
- Myopia: SE -0.50 D or more myopic; high myopia: -6.00 D or more myopic; premyopia: +0.75 D or less and more than -0.50 D in children at risk (IMI, Wolffsohn 2019).
- Hyperopia, astigmatism and magnitude bands have no single standard; Indian school studies differ:

| Study | Myopia | Hyperopia | Astigmatism | Bands |
| --- | --- | --- | --- | --- |
| IMI (Wolffsohn 2019) | -0.50 D or worse | | | high -6.00 D or worse |
| REACH multistate (Joseph 2022) | -0.50 D or worse | +1.00 D or more | 0.50 D or more cylinder | anisometropia over 1.00 D SE |
| LV Prasad schools (Prakash 2022, 2024) | -0.50 D or worse | +2.00 D or more | | low myopia -0.50 to -5.75 D, high -6.00 D or worse; low hyperopia +2.00 to +5.00 D, high +5.25 D or more |

  Other definitions in use: NICER (O'Donoghue 2012) defines significant refractive error on the right eye as myopia 1.00 D or more, hyperopia over +3.50 D, astigmatism over 1.50 DC. Studies citing the RESC protocol also differ (astigmatism 0.75 or 1.00 D; myopia -0.50 or -1.50 D), so check the cited paper rather than assuming "RESC definitions". Prespecify thresholds with their source, and report a second threshold as sensitivity when comparing across studies.

## Which Eye

Prespecify one rule and state it in every table; studies differ, so results are not comparable without it. "Better eye" can mean better VA or lower refractive error; always say which.

| Rule | Example |
| --- | --- |
| Either eye | NIM and NIM-R: myopia if SE -0.50 D or worse in either eye |
| Worse eye | Shanghai outdoor trial (He 2019): myopia defined on the worse eye |
| Right eye only | Guangzhou outdoor trial (He 2015): right-eye data for analysis |
| Worse eye (SE) | LV Prasad school studies (Prakash 2022, 2024) |
| "Better eye" = lower refractive error | REACH multistate (Joseph 2022): the eye with the lower SE, not the better VA |
| Better eye (VA) | Refractive-error VI and eREC: the eye with the better presenting VA |
| Both eyes, clustered | Eye-level models with child as cluster |

## Refractive Error and Vision Impairment

- Refractive error VI: presenting VA worse than the threshold in the better eye that improves to the threshold or better with correction or pinhole. NIM used presenting VA below 6/12 in the better eye, with mild VI as below 6/12 to 6/19.
- Report uncorrected and presenting VI separately; spectacle wearers with adequate correction are not VI.
- Spectacle coverage among children with refractive error: define the refractive error case, the denominator, the wear criterion and the follow-up time; Gupta 2019 (subsidised spectacles, Delhi) is the worked model, detailed in `school-eye-health.md`.

## Two-Stage School Screening Designs

NIM, NIM-R and REACH-type programmes screen VA first and refract only those who fail.

- Screening thresholds differ: NIM, unaided VA below 6/9.5 or wearing spectacles, plus a random 10% of children with normal vision; REACH, 6/9.5 optotype plus a +1.50 D lens test for latent hyperopia; LV Prasad, 6/12 tumbling E at 3 m. Report the threshold and the confirmatory test (cycloplegic retinoscopy or autorefraction).
- Low myopia that still passes the screening threshold is missed, so screened prevalence underestimates true prevalence. Use the normal-vision subsample to estimate and report the missed fraction, and state that the estimate is screen-positive prevalence otherwise.
- Schools are clusters: estimate with the design (`clinical-survey-prevalence.md`) and report the ICC.

## Incidence and Progression

- Incidence: new myopia among children non-myopic at baseline over a stated interval (NIM: 1 year), same cycloplegic protocol at each round.
- Progression: define the threshold. NIM used any increase in myopic SE over 1 year; many studies use 0.50 D per year or more. Report mean change in SE (D/year) and, where measured, axial length (mm/year), with the proportion above a prespecified threshold.

## Trials (Outdoor Time and Myopia Control)

- Outdoor-time trials are school-cluster randomised (He 2015 Guangzhou, 12 schools; He 2022 Shanghai, 24 schools, 3 arms, examiner-masked). Primary outcomes: incident myopia and myopic shift in SE; analyse at the cluster level or with mixed models, and power with the ICC.
- Myopia-control trials (IMI 2019): primary outcomes are change in cycloplegic SE and/or axial length (non-contact interferometry); secondary are patient- and parent-reported outcomes and compliance. No minimum percentage reduction is agreed as clinically meaningful: report absolute differences (D, mm) with 95% CI; percentage efficacy is secondary.
- Adjust for baseline SE or AL and age; report rebound after stopping when the design includes it.
- Measure outdoor exposure objectively where possible (He 2022 used wearable light and time monitors).

Sources: Wolffsohn JS et al. IOVS 2019 (IMI); Saxena R et al. PLoS One 2015 (NIM prevalence) and 2017 (NIM incidence and progression); Saxena R et al. 2022 (NIM-R); He M et al. JAMA 2015; He X et al. 2019 (Shanghai protocol) and Ophthalmology 2022; Gupta V et al. Optom Vis Sci 2019 (spectacle coverage); Sil A et al. 2022 (REACH programme design, not read in full); Joseph E et al. Br J Ophthalmol 2022 (REACH multistate prevalence); Prakash WD et al. 2022 (school VI and RE, Andhra Pradesh) and 2024 (eREC and spectacle coverage, Telangana).

Related: `who-ecim-erec-formulas.md`, `clinical-longitudinal-repeated.md`, `clinical-survey-prevalence.md`, `clinical-study-designs.md`, `clinical-ophthalmology-guidelines.md`, `school-eye-health.md`, `refractive-error-classification.md`, `refractive-error-vision-layers.md`.
