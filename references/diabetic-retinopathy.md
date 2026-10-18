# Diabetic Retinopathy

Load this for DR and diabetic macular oedema (DME) prevalence, grading, screening, or DR modules in RAAB surveys. Screening accuracy methods are in `clinical-diagnostic-prediction.md`; survey estimation in `clinical-survey-prevalence.md` and `clinical-raab-surveys.md`.

## Grading Scales

State the scale, the grading method (dilated ophthalmoscopy, fundus photography, number of fields, OCT), and the grader masking before analysis. Never pool grades from different scales without a stated crosswalk.

ICDR scale (Wilkinson 2003), per eye:

| Level | Findings on dilated ophthalmoscopy |
| --- | --- |
| No apparent retinopathy | No abnormalities |
| Mild NPDR | Microaneurysms only |
| Moderate NPDR | More than microaneurysms, less than severe NPDR |
| Severe NPDR | Any of: more than 20 intraretinal haemorrhages in each of 4 quadrants; definite venous beading in 2 or more quadrants; prominent IRMA in 1 or more quadrant; and no PDR |
| PDR | Neovascularisation, or vitreous or preretinal haemorrhage |

ICDR DME: apparently absent or present (retinal thickening or hard exudates in the posterior pole); if present, mild (distant from the macular centre), moderate (approaching but not involving the centre), severe (involving the centre). OCT centre-involved DME is a separate, device-based definition; state it if used.

### Screening Programme Scales

Screening programmes grade photographs into referral-driven categories, not ICDR levels. Name the scheme and keep its own codes.

| Scheme | Retinopathy | Maculopathy | Ungradable |
| --- | --- | --- | --- |
| NHS England (Harding 2003; Scanlon 2017) | R0 none; R1 background (microaneurysms, haemorrhages, venous loop, exudate or cotton wool spots with other non-referable features); R2 pre-proliferative (venous beading or reduplication, IRMA, multiple deep round or blot haemorrhages); R3A active proliferative (NVD, NVE, pre-retinal or vitreous haemorrhage, pre-retinal fibrosis with or without tractional detachment); R3S stable treated proliferative | M1 if any: exudate within 1 disc diameter of the foveal centre; circinate or group of exudates within the macula; microaneurysm or haemorrhage within 1 disc diameter with best VA 6/12 or worse | U |
| Scottish (2007 scheme) | R0 none; R1 mild; R2 observable; R3 referable; R4 proliferative | M0 none; M1 observable; M2 referable | R6 not adequately visualised |

The Scottish row gives the category structure only; take lesion criteria from the scheme document itself. RAAB7's DR module uses the same Scottish-style labels (none, mild, observable, referable, proliferative; maculopathy none, observable, referable; not visualised).

Referral: England refers R2, R3A or M1 (R3A urgently). Scotland refers R3, R4 or M2 (R4 urgently); its observable grades (R2, M1) are rescreened earlier, not referred. Confirm intervals against the current programme documents.

## Person-Level Outcomes

- Any DR: any retinopathy or maculopathy above none in either eye.
- Sight-threatening DR (STDR): define explicitly. RAAB7 code uses proliferative retinopathy or referable maculopathy in either eye; other studies include severe NPDR or any DME. Name the definition in the table title.
- Referable DR: define explicitly (commonly moderate NPDR or worse and/or DME on ICDR); it drives screening accuracy and referral-load estimates.
- Person grade = worse eye. Ungradable or not-visualised eyes are a separate category: a person with one ungradable eye and one graded eye has an unknown worse-eye grade unless the graded eye is already at the highest level. Do not code ungradable as the lowest grade, which RAAB7 code does implicitly (not visualised = 0 under `pmax`).

## Denominators

- Prevalence of DR is among people with diabetes, not the whole sample. In RAAB7: known diabetes, or newly suspected by random blood glucose of 200 mg/dL or more among consenters; DR denominator = those examined by dilated fundoscopy or fundus camera.
- Report the diabetes cascade first: enrolled, examined, diabetes status assessed, known or suspected diabetes, dilated examination done, gradable.
- Also report: laser scars, last eye examination (never, 0-12, 13-24, over 24 months), and VI among people with diabetes.
- Population prevalence of DR = DR among people with diabetes x diabetes prevalence; carry both uncertainties (design-based estimate on the full sample with DR as a domain, not a product of two CIs).

## Analysis Rules

- Eye-level analyses cluster within person; person-level is the default for prevalence.
- Code grades by value label; scales and code orders differ by survey and device.
- Report grader agreement (kappa, weighted kappa for ordered grades) for the grading process.

Sources: Wilkinson CP et al. Ophthalmology 2003 (ICDR); Harding S et al. Diabet Med 2003 and Scanlon PH. Acta Diabetol 2017 (NHS England); Scottish Diabetic Retinopathy Grading Scheme 2007 v1.1; RAAB7 analysis code, `github.com/raabteam/raab7-analysis`.

Related: `clinical-raab-surveys.md`, `clinical-survey-prevalence.md`, `clinical-diagnostic-prediction.md`, `clinical-ophthalmology-guidelines.md`.
