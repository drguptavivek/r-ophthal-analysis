# Incidence from age-specific prevalence for an irreversible disease, allowing
# different death rates with and without the disease.
# Podgor MJ, Leske MC. Stat Med 1986;5:573-78 (equation 4). Base R only.
#
# For one age interval of t years (for example 5):
#   p0, p1  prevalence at the start and end of the interval (usually the
#           midpoints of consecutive age groups)
#   q_free  t-year probability of death without the disease (life table)
#   rr      death-rate ratio with vs without the disease (1 = equal mortality)
#   n0, n1  sample sizes behind p0 and p1 (for the standard error; use the
#           effective sample size n / DEFF for survey data)
# Returns the incidence rate per t years (lambda2), net risk 1 - exp(-lambda2),
# and delta-method standard errors (equation 9).

incidence_from_prevalence <- function(p0, p1, q_free, rr = 1, n0 = NA, n1 = NA) {
  l1 <- -log(1 - q_free)
  l3 <- rr * l1
  g <- function(l2, p0, p1) {
    lhs <- (1 - p0) * p1 * exp(-(l1 + l2)) / (1 - p1)
    rhs <- if (abs(l1 + l2 - l3) < 1e-12) {
      p0 * exp(-l3) + (1 - p0) * exp(-l3) * l2          # limit when l1 + l2 = l3
    } else {
      p0 * exp(-l3) + (1 - p0) * (exp(-l3) - exp(-(l1 + l2))) * l2 / (l1 + l2 - l3)
    }
    lhs - rhs
  }
  if (p1 <= p0) {
    warning("prevalence does not rise across the interval; incidence set to 0")
    return(c(rate = 0, net_risk = 0, se_rate = NA, se_net_risk = NA))
  }
  l2 <- uniroot(g, c(1e-10, 10), p0 = p0, p1 = p1, tol = 1e-12)$root
  se <- NA_real_
  if (!is.na(n0) && !is.na(n1)) {
    h <- 1e-6
    dg_dp0 <- (g(l2, p0 + h, p1) - g(l2, p0 - h, p1)) / (2 * h)
    dg_dp1 <- (g(l2, p0, p1 + h) - g(l2, p0, p1 - h)) / (2 * h)
    dg_dl2 <- (g(l2 + h, p0, p1) - g(l2 - h, p0, p1)) / (2 * h)
    v <- (dg_dp0^2 * p0 * (1 - p0) / n0 + dg_dp1^2 * p1 * (1 - p1) / n1) / dg_dl2^2
    se <- sqrt(v)
  }
  c(rate = l2, net_risk = 1 - exp(-l2), se_rate = se, se_net_risk = (exp(-l2)) * se)
}

if (sys.nframe() == 0L) {
  # Framingham Eye Study senile cataract (Podgor and Leske 1986, Tables I and II)
  fr <- data.frame(age = c(55, 60, 65, 70, 75),
                   p0 = c(0.0123, 0.0283, 0.0469, 0.1048, 0.1380),
                   p1 = c(0.0283, 0.0469, 0.1048, 0.1380, 0.3242),
                   q  = c(0.0574, 0.0867, 0.1239, 0.1847, 0.2780),
                   n0 = c(480, 583, 467, 316, 256), n1 = c(583, 467, 316, 256, 123))
  out <- t(sapply(seq_len(nrow(fr)), function(i) with(fr[i, ], c(
    age = age,
    equal = incidence_from_prevalence(p0, p1, q, 1, n0, n1)[c("rate", "se_rate")],
    differential = incidence_from_prevalence(p0, p1, q, 2, n0, n1)[c("rate", "se_rate", "net_risk")]))))
  print(round(out, 3))
}
