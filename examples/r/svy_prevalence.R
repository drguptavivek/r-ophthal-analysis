# Design-based prevalence with 95% CI for a binary or multinomial outcome,
# overall and by a grouping variable with any number of levels.
# Requires the survey package. Source this file, then call svy_prevalence().
#
# design   survey.design2 object (svydesign) built on the full sample
# outcome  name of a 0/1, factor, or labelled-integer variable; NA = not in denominator
# by       optional grouping variable name (sex, age group, district ...)
#
# Returns one row per group x outcome level with unweighted cases and
# denominator, estimate, logit CI (as Stata `proportion`), and DEFF, all
# numeric at full precision. Groups with no cases or all cases have
# estimable = FALSE and NA CI instead of a fabricated interval.

svy_prevalence <- function(design, outcome, by = NULL, multiplier = 100, level = 0.95) {
  if (!requireNamespace("survey", quietly = TRUE)) stop("install the survey package first", call. = FALSE)
  if (!inherits(design, "survey.design2")) stop("design must come from survey::svydesign()", call. = FALSE)
  vars <- design$variables
  if (!outcome %in% names(vars)) stop("outcome not found: ", outcome, call. = FALSE)
  if (!is.null(by) && !by %in% names(vars)) stop("by variable not found: ", by, call. = FALSE)

  y <- vars[[outcome]]
  outcome_levels <- if (is.factor(y)) levels(y) else sort(unique(y[!is.na(y)]))
  if (length(outcome_levels) < 2L && !all(outcome_levels %in% c(0, 1))) {
    stop("outcome needs at least two levels, or 0/1 coding", call. = FALSE)
  }
  if (all(outcome_levels %in% c(0, 1))) outcome_levels <- 1

  group_values <- if (is.null(by)) character() else {
    g <- vars[[by]]
    g <- g[!is.na(g) & !is.na(y)]  # as Stata: groups with no outcome data are omitted
    if (is.factor(g)) levels(droplevels(g)) else sort(unique(g))
  }
  groups <- c(as.list(group_values), list(NULL))

  rows <- list()
  for (lv in outcome_levels) {
    d_level <- design
    d_level$variables$.ind <- as.numeric(y == lv)
    for (gv in groups) {
      keep <- !is.na(y)
      if (!is.null(gv)) keep <- keep & !is.na(vars[[by]]) & vars[[by]] == gv
      cases <- sum(y[keep] == lv)
      denominator <- sum(keep)
      row <- data.frame(
        group = if (is.null(gv)) "Total" else as.character(gv),
        level = as.character(lv), cases = cases, denominator = denominator,
        estimate = NA_real_, lci = NA_real_, uci = NA_real_, deff = NA_real_,
        estimable = FALSE, stringsAsFactors = FALSE
      )
      if (denominator > 0L) {
        d <- d_level[keep, ]
        # As Stata: with-replacement SRS reference unless the design has an FPC
        deff_type <- if (is.null(design$fpc$popsize)) "replace" else TRUE
        mean_fit <- survey::svymean(~.ind, d, deff = deff_type)
        row$estimate <- unname(coef(mean_fit)) * multiplier
        row$estimable <- cases > 0L && cases < denominator
        if (row$estimable) {
          ci <- attr(survey::svyciprop(~.ind, d, method = "logit", level = level), "ci")
          row$lci <- unname(ci[1]) * multiplier
          row$uci <- unname(ci[2]) * multiplier
          row$deff <- unname(survey::deff(mean_fit))
        }
      }
      rows[[length(rows) + 1L]] <- row
    }
  }
  result <- do.call(rbind, rows)
  rownames(result) <- NULL
  result
}
