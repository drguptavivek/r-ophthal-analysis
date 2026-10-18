# Refraction-dropout bias in two-stage school screening studies.
# Base R only. Run from the skill root:  Rscript examples/r/dropout_bias_simulation.R
# Or source() it and call dropout_bias() with your own study's values.
#
# Design: N children screened; a share s fail screening (screen-positive);
# a share d of screen-positives miss refraction (dropouts); among refracted
# screen-positives a share p have refractive error (RE). Dropouts have RE at
# r times the completers' rate (r = 1: dropouts resemble completers).
#
# The complete-case estimate excludes dropouts from numerator and denominator
# (refractive-error-vision-layers.md). With r = 1 its relative bias is
# -d(1 - s) / (1 - s * d), so the underestimate is about the dropout share.

dropout_bias <- function(N = 5000, s = c(0.05, 0.10, 0.20), p = 0.70,
                         d = c(0.05, 0.10, 0.20, 0.30, 0.40), r = c(0.5, 1, 1.5),
                         reps = 2000, seed = 20261018) {
  set.seed(seed)
  one_study <- function(s, p, d, r) {
    pos <- rbinom(1, N, s)
    drop <- rbinom(1, pos, d)
    re_ref <- rbinom(1, pos - drop, p)
    re_drop <- rbinom(1, drop, min(1, p * r))
    c(true = (re_ref + re_drop) / N, cc = re_ref / (N - drop))
  }
  grid <- expand.grid(screen_pos = s, dropout = d, dropout_re_ratio = r)
  rows <- lapply(seq_len(nrow(grid)), function(i) {
    g <- grid[i, ]
    sims <- replicate(reps, one_study(g$screen_pos, p, g$dropout, g$dropout_re_ratio))
    true_prev <- g$screen_pos * ((1 - g$dropout) * p + g$dropout * min(1, p * g$dropout_re_ratio))
    cc <- mean(sims["cc", ])
    data.frame(
      screen_pos_pct = 100 * g$screen_pos,
      dropout_pct = 100 * g$dropout,
      dropout_re_ratio = g$dropout_re_ratio,
      true_prev_pct = 100 * true_prev,
      complete_case_pct = 100 * cc,
      abs_bias_pts = 100 * (cc - true_prev),
      rel_bias_pct = 100 * (cc - true_prev) / true_prev,
      formula_rel_bias_pct = if (g$dropout_re_ratio == 1) {
        -100 * g$dropout * (1 - g$screen_pos) / (1 - g$screen_pos * g$dropout)
      } else NA_real_,
      bias_vs_ci_halfwidth = abs(cc - true_prev) / (1.96 * sd(sims["cc", ]))
    )
  })
  out <- do.call(rbind, rows)
  rownames(out) <- NULL
  out
}

if (sys.nframe() == 0L) {
  res <- dropout_bias()
  print(format(res, digits = 3), row.names = FALSE)
  random <- res[res$dropout_re_ratio == 1, ]
  stopifnot(max(abs(random$rel_bias_pct - random$formula_rel_bias_pct)) < 1)
  cat("\nRandom dropout: simulated relative bias matches the formula within 1 percentage point.\n")
}
