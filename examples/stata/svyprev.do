*! svyprev: design-based prevalence with 95% CI for a binary or multinomial
*! outcome, overall and by a grouping variable with any number of levels.
*
* Load:   do "svyprev.do"           (data must already be svyset)
* Use:    svyprev outcome [if] [in], saving(results.dta) [over(groupvar) multiplier(100)]
*
* outcome  numeric 0/1 or categorical with value labels; missing = not in denominator
* over()   optional numeric grouping variable (sex, age group, district ...)
*
* Each estimate uses svy, subpop() for correct domain variance and reads
* results by coefficient name, never by row position, so a level that is empty
* in a group gives estimate 0 with missing CI instead of shifted numbers.
* Saves one row per group x level: cases, denominator, estimate, logit CI
* (Stata proportion default), DEFF and estimable, all numeric.

cap program drop svyprev
program define svyprev, rclass
    version 16
    syntax varname(numeric) [if] [in], SAVing(string) [OVER(varname numeric) MULTiplier(real 100)]
    local y `varlist'
    marksample touse, novarlist
    qui svyset
    if "`r(settings)'" == ", clear" {
        di as error "data are not svyset"
        exit 119
    }

    qui levelsof `y' if `touse' & !missing(`y'), local(ylevels)
    if "`ylevels'" == "0 1" | "`ylevels'" == "0" | "`ylevels'" == "1" local ylevels 1
    local ylab : value label `y'
    local groups "total"
    if "`over'" != "" {
        qui levelsof `over' if `touse' & !missing(`y'), local(glevels)
        local groups `glevels' total
        local glab : value label `over'
    }

    tempname post
    tempfile results
    postfile `post' str60 group str60 level double(cases denominator estimate lci uci deff) byte estimable using `results'
    tempvar ind dom
    foreach lv of local ylevels {
        qui gen byte `ind' = (`y' == `lv') if !missing(`y')
        local lname "`lv'"
        if "`ylab'" != "" local lname : label `ylab' `lv'
        foreach g of local groups {
            qui gen byte `dom' = `touse' & !missing(`y')
            local gname "Total"
            if "`g'" != "total" {
                qui replace `dom' = `dom' & `over' == `g'
                local gname "`g'"
                if "`glab'" != "" local gname : label `glab' `g'
            }
            qui count if `dom' & `ind' == 1
            local cases = r(N)
            qui count if `dom'
            local denom = r(N)
            local est = .
            local lb = .
            local ub = .
            local de = .
            local ok = 0
            if `denom' > 0 local est = `multiplier' * `cases' / `denom'
            if `cases' > 0 & `cases' < `denom' {
                qui svy, subpop(`dom'): proportion `ind'
                tempname T D
                matrix `T' = r(table)
                local c = colnumb(`T', "1.`ind'")
                local est = `multiplier' * `T'[1, `c']
                local lb = `multiplier' * `T'[5, `c']
                local ub = `multiplier' * `T'[6, `c']
                qui estat effects
                matrix `D' = r(deff)
                local de = `D'[1, colnumb(`D', "1.`ind'")]
                local ok = 1
            }
            post `post' ("`gname'") ("`lname'") (`cases') (`denom') (`est') (`lb') (`ub') (`de') (`ok')
            drop `dom'
        }
        drop `ind'
    }
    postclose `post'
    preserve
    use `results', clear
    gen str32 outcome = "`y'"
    order outcome
    label var estimate "Estimate per `multiplier'"
    label var estimable "1 = CI estimable; 0 = no cases, all cases, or empty group"
    save `saving'
    restore
    return local saved `"`saving'"'
end
