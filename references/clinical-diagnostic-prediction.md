# Diagnostic and Prediction Modelling

Load this for diagnostic accuracy, screening tests, AI classifiers, prognostic models, or ML prediction.

## Diagnostic Test Evaluation

Define index test/model score, reference standard, target condition, unit of analysis, thresholds, plausible prevalence range, and clustering.

At each clinically relevant threshold, report confusion matrix: TP, FP, TN, FN, total N, and reference-standard positive N.

Report all diagnostic metrics with 95% CIs whenever estimable:

- Sensitivity/recall.
- Specificity.
- PPV and NPV.
- Accuracy.
- F1 score.
- Youden index.
- LR+ and LR-.
- Diagnostic odds ratio when useful.
- NNS when clinically meaningful and clearly defined.
- AUROC/AUC and threshold-specific estimates.

Use exact/binomial CIs for proportions where appropriate. Use bootstrap CIs when closed-form intervals are not straightforward, especially for F1, Youden, NNS, derived threshold metrics, and DCA summaries. Document bootstrap unit, resamples, seed, and whether clustering is respected.

For continuous scores, plot ROC and report AUC with 95% CI. Report threshold metrics, not only AUC. Use calibration plots/metrics for predicted probabilities.

For PPV/NPV, clarify disease prevalence. If study prevalence is not representative, estimate PPV/NPV across plausible prevalence ranges.

For decision curve analysis, define plausible threshold probability range, show model/test vs treat-all/treat-none net benefit, and avoid interpreting outside plausible ranges.

Do not optimize thresholds on the test set.

## Inferential vs Prediction Modelling

Clarify whether the model goal is inferential/explanatory, prediction/prognostic, diagnostic classification, or descriptive only.

Inferential models start from clinical question, exposure, outcome, and confounding structure. Covariates are chosen by design and clinical knowledge; report effect estimates with 95% CIs. Avoid overadjustment/collider/post-treatment adjustment unless justified.

Prediction models require target outcome, prediction horizon, candidate predictors, intended use case, and validation plan. Do not interpret coefficients causally.

## Prediction and ML Workflow

Define train/test split before fitting when sample size permits. Keep test set untouched until final evaluation.

Use cross-validation inside training for model selection/tuning. Consider repeated k-fold CV or bootstrap validation for smaller datasets.

Prevent data leakage: preprocessing, imputation, scaling, feature selection, and threshold tuning must be learned inside training/resampling only.

Compare ML models against simple baselines. Report discrimination, calibration, clinical usefulness, confusion matrix metrics, RMSE/MAE for continuous outcomes, algorithm, tuning grid, resampling design, preprocessing recipe, final hyperparameters, and final validation performance.
