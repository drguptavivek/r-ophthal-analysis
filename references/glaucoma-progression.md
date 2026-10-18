# Glaucoma Progression

Load this for visual field or structural progression endpoints and severity staging. Case definitions, IOP and surgical endpoints are in `glaucoma-endpoints.md`; mixed-model methods in `clinical-longitudinal-repeated.md`.

Prespecify one primary approach: event-based (has significant change occurred?) analysed as time to confirmed progression, or trend-based (how fast?) analysed as a rate.

| Method | Definition | Source | Analysis |
| --- | --- | --- | --- |
| Field event | Same 3 or more points with significant deterioration from baseline (pattern deviation change probability) on 3 consecutive tests = definite; 2 consecutive = possible | EMGT (Heijl 2003) | Kaplan-Meier and Cox |
| Field trend, pointwise | 3 or more points with slope of -1 dB/year or worse at p below 0.05 on 3 consecutive tests | LoGTS (EGS 2025) | Time to event |
| Field trend, global | Linear regression of MD (dB/year) or VFI (%/year); not PSD or LV, which peak then fall | EGS 2025 | Mixed model, random intercept and slope per eye |
| Structural | RNFL or macular GCIPL thickness (um/year) on OCT, event or trend | Device-specific; confirm | Mixed model; floor effect in advanced disease |

Rates (Chauhan 2008): about -0.5 dB/year slow, -1 moderate, -2 fast. Untreated EMGT eyes averaged -1.08 dB/year.

## Severity Staging (EGS 2025, simplified Hodapp-Parrish-Anderson and Mills)

| Stage | Humphrey MD | Octopus MD (mean defect) |
| --- | --- | --- |
| Early | -6 dB or better | 4.5 dB or less |
| Moderate | worse than -6 to -12 dB | over 4.5 to 9.5 dB |
| Advanced | worse than -12 dB | over 9.5 dB |

Humphrey reports MD as negative, Octopus as positive; check the sign before staging.

## Rules

- Testing frequency drives power: three fields a year detect a 4 dB MD change over 2 years with average variability (Chauhan 2008); EGS 2025 suggests three a year for the first 2 years after diagnosis.
- Confirm every event; report confirmed and unconfirmed events separately.
- Reliability: EGS 2025 cautions that fixation losses and false negatives are weak indicators and false positives the most informative; prespecify any exclusion cut-off and report how many fields it removed.
- One test pattern (24-2, 10-2, 30-2) and strategy per slope; do not mix.
- Mixed models with eyes nested in persons; report slopes with 95% CI and fields per eye.

Sources: Heijl A et al. Acta Ophthalmol Scand 2003; Chauhan BC et al. Br J Ophthalmol 2008; European Glaucoma Society Terminology and Guidelines, 6th edition, 2025.

Related: `glaucoma-endpoints.md`, `clinical-longitudinal-repeated.md`.
