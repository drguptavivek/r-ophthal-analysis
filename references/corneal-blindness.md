# Corneal Blindness

Load this for corneal opacity (CO) and corneal blindness burden, trachoma-related opacity, or keratoplasty-need estimates from population surveys. Survey estimation is in `clinical-raab-surveys.md` and `clinical-survey-prevalence.md`.

## Definitions

- Corneal blindness: blindness with corneal opacity as the cause. State the blindness threshold: WHO uses PVA below 3/60 in the better eye; older Indian studies used below 6/60 (Gupta 2013). Harmonise before comparing studies.
- Unilateral corneal blindness (one eye blind from CO, fellow eye not blind) is several times more common than bilateral and must be reported separately; better-eye definitions miss it.
- In RAAB, CO causes are trachomatous corneal opacity and other corneal opacity. Code both by value label and report them separately and combined.

## Levels of Burden (Gupta V et al. Br J Ophthalmol 2025)

Each level answers a different question; label which one a table reports. Thresholds follow ICD-11: blindness below 3/60, plus below 6/60, 6/18 and 6/12 in the better eye; report per 100 000 with survey-weighted 95% CIs.

| Level | Definition | Answers |
| --- | --- | --- |
| CO as a cause | Better-eye PVA below the threshold and CO marked as cause in either eye; split into unilateral and bilateral CO | How often CO contributes to VI |
| CO as principal cause | Better-eye PVA below the threshold and the person's principal cause is CO | Burden attributable to CO (RAAB standard) |
| Potentially amenable to keratoplasty | Better-eye PVA below the threshold, and either one CO eye with PVA below 3/60 whose fellow eye has a less avoidable cause, or both eyes CO with PVA below 3/60; at least one CO eye perceives light | Surgical need and donor-cornea demand |
| Unilateral CO without person-level VI | Better-eye PVA at or above the threshold, one eye CO with PVA below the threshold | Hidden monocular burden missed by better-eye definitions |

Avoidability ranking for the fellow eye (Gupta 2025): cataract, refractive error, aphakia and cataract surgical complications are more avoidable than CO; glaucoma, DR, AMD, other posterior segment disease, phthisis and globe or CNS abnormalities are less avoidable. Record the ranking used.

The principal-cause rule assigns the most treatable cause, so CO alongside cataract is under-counted at the principal-cause level.

## Keratoplasty Outcomes

- Primary endpoint: graft survival, analysed as time to graft failure (irreversible loss of graft clarity) with Kaplan-Meier and Cox models; confirm the protocol's failure definition.
- Secondary: BCVA, rejection episodes, endothelial cell loss, regraft.
- One graft per person, or cluster by person; report indication groups (keratitis, trauma, bullous keratopathy, regraft) separately.

Sources: Gupta V et al. Burden of blindness and visual impairment associated with corneal opacities in India. Br J Ophthalmol 2025;109:829-36. doi:10.1136/bjo-2024-325763. Gupta N, Tandon R, Gupta SK, Sreenivas V, Vashist P. Burden of corneal blindness in India. Indian J Community Med 2013.

Related: `clinical-raab-surveys.md`, `clinical-survey-prevalence.md`, `clinical-ophthalmology-guidelines.md`, `clinical-study-designs.md`, `burden-projection.md`.
