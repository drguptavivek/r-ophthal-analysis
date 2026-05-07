# Ophthalmology Guidelines

Load this for ophthalmology datasets.

## Unit of Analysis

Be explicit about whether each analysis is eye-wise or person-wise.

Define whether rows represent persons, eyes, visits, images, scans, lesions, or procedures. Define laterality coding and whether both eyes can contribute.

For two-eye data, state whether analysis uses one selected eye, worse eye, better eye, both eyes with clustering adjustment, or person-level summary.

## Visual Acuity and Visual Impairment

Define whether visual acuity is presenting visual acuity (PVA/PV), uncorrected VA, BCVA, or another measure. Define scale: Snellen, LogMAR, ETDRS, decimal, or categorical.

State rules for converting visual acuity and handling CF, HM, LP, and NLP.

When discussing visual impairment, state whether based on better eye, worse eye, eye-wise acuity, presenting VA, or BCVA.

Use WHO visual impairment categories when appropriate: mild VI, moderate VI, severe VI, blindness. Define exact thresholds in the `.Rmd`; do not mix eye-wise and person-wise VI definitions without clear labels and footnotes.

## Person-Level Outcomes from Eye-Level Data

For refractive error, cataract, DR, glaucoma presence/suspect status, retinal disease, and other eye diseases, define the aggregation rule:

- Any-eye positive.
- Both-eye positive.
- Better-eye based.
- Worse-eye based.
- Right-eye or left-eye only.
- Eye-wise only, with clustering adjustment if both eyes are analyzed.

Document missing/ungradable eye handling. Do not label an outcome "person-level" unless the any-eye/both-eye/better-eye/worse-eye rule is stated.
