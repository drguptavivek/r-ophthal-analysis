# Glaucoma Endpoints

Load this for glaucoma case definitions, IOP trials, surgical outcomes, or glaucoma AI and screening studies. Progression is in `glaucoma-progression.md`; MBSR, yoga and pranayama trials in `glaucoma-mindbody-trials.md`; glaucoma blindness burden from RAAB in `clinical-raab-surveys.md`. Every number below is a default to confirm against the protocol and source; record the chosen definitions in the charter.

| Study type | Primary unit | Typical analysis |
| --- | --- | --- |
| Population survey | Person (eye counts reported too) | Survey-weighted prevalence with 95% CI |
| Drug or laser trial | Eye, clustered within person | Baseline-adjusted mixed model on IOP |
| Surgical outcome study | Eye, usually one per person | Kaplan-Meier and Cox time to failure |
| AI or screening study | Person or eye, stated in advance | Sensitivity, specificity, AUC with 95% CI |

## Case Definitions (ISGEO, Foster 2002)

Cut-offs come from the survey's own normal population.

| Category | Criteria |
| --- | --- |
| 1: structural and functional | CDR or CDR asymmetry above the 97.5th percentile, or rim below 0.1 CDR (11-1 or 5-7 o'clock), with a definite glaucomatous field defect |
| 2: advanced structural, field unproved | Field not completed; CDR or CDR asymmetry above the 99.5th percentile |
| 3: disc not seen, field impossible | VA below 3/60 with IOP above the 99.5th percentile, or VA below 3/60 with filtering surgery or records of glaucomatous loss |

- Categories 1 and 2 need no alternative explanation for the disc or field finding.
- Glaucoma suspect (not glaucoma): disc suspect, field suspect, disc haemorrhage, IOP above the 97.5th percentile, or occludable angle with otherwise normal findings.
- Angle closure (eye-level): PACS (iridotrabecular contact possible; in epidemiology usually more than 270 degrees of posterior trabecular meshwork not visible), PAC (plus PAS, raised IOP or other signs of obstruction, normal disc), PACG (PAC with glaucoma).
- Person has glaucoma if either eye meets a category; report percentiles used, counts per category, and ocular hypertension separately.

## IOP Endpoints (Drug and Laser Trials)

- Primary: mean IOP at prespecified visits and clock times, analysed with baseline IOP as covariate (ANCOVA or mixed model for repeated measures), not raw change, to handle regression to the mean.
- Secondary: percentage reduction; responders at a prespecified reduction (landmark targets: OHTS at least 20% and below 24 mmHg, EMGT 25%, CNTGS 30%); target IOP attained; medication count.
- Both eyes treated: mixed model or GEE with person as cluster. Report adjusted differences with 95% CI per visit.
- Non-inferiority margins of 1.5 mmHg at all visits and 1.0 mmHg at most visits are a common regulatory convention; confirm against current regulator guidance.
- Handle rescue treatment and dropout by the prespecified estimand, never by last observation carried forward.

## Surgical Success (TVT and Primary TVT, via EGS 2025)

Analyse time to failure (Kaplan-Meier, Cox), not success at one visit. Failure is the first of:

1. IOP above the upper limit (default 21 mmHg) or less than 20% reduction, on two consecutive visits after 3 months.
2. IOP 5 mmHg or less on two consecutive visits after 3 months.
3. Reoperation for glaucoma.
4. Loss of light perception.

Complete success: no medication; qualified success: with medication. Report several upper limits (21, 18, 15 mmHg); date failure at the first qualifying visit; define whether needling, bleb revision, suture lysis and cyclophotocoagulation count as reoperation; one eye per person or Cox with person-clustered variance.

## AI and Screening

- Fix the target condition (any, referable, suspect or worse, angle closure) and the reference standard (ISGEO or masked expert grading with disc, OCT and fields); a photo-only grade is an imperfect reference.
- Person-level for screening decisions; eye-level CIs by person-level cluster bootstrap.
- Report ungradable images and their prespecified handling; report test-set prevalence and PPV/NPV across plausible prevalences.
- Fix thresholds on training data; require external validation. Metrics and CIs follow `clinical-diagnostic-prediction.md`.

## Common Rules

- Two eyes: prespecified study-eye rule, or both eyes with person-level clustering. Persons and eyes in every denominator.
- Record tonometer, perimeter, test pattern and strategy, OCT device and software version; a mid-study change breaks comparisons.
- Code categories by value label (`clinical-variable-coding.md`). Follow STROBE, CONSORT, STARD or TRIPOD+AI as fits.

Sources: Foster PJ et al. Br J Ophthalmol 2002; European Glaucoma Society Terminology and Guidelines, 6th edition, 2025.

Related: `glaucoma-progression.md`, `glaucoma-mindbody-trials.md`, `clinical-raab-surveys.md`, `clinical-diagnostic-prediction.md`.
