version 18.0

/*
  Standalone Stata 18+ logistic-regression collect example for ophthal-analysis.

  Usage:
      do example_stata_logistic.do 3 "/private/tmp/out"

  The do-file accepts the two required positional arguments because Stata's
  `do` command reserves comma options.

  The data are deterministic synthetic values.  The units are deliberately
  labelled arbitrary and the report makes no clinical interpretation.
*/

clear all
set more off
set linesize 255
set seed 20261011

args ngroups outdir
if `"`ngroups'"' == "" | `"`outdir'"' == "" {
    di as error "Usage: do example_stata_logistic.do 2|3 absolute_outdir"
    exit 198
}
local ngroups_n = real(`"`ngroups'"')
if missing(`ngroups_n') | !inlist(`ngroups_n', 2, 3) {
    di as error "ngroups() must be 2 or 3"
    exit 198
}
local ngroups = `ngroups_n'
if substr(`"`outdir'"', 1, 1) != "/" {
    di as error "outdir() must be an absolute path"
    exit 198
}

capture mkdir `"`outdir'"'
capture confirm file `"`outdir'/example_stata_logistic.log"'
if !_rc copy `"`outdir'/example_stata_logistic.log"' `"`outdir'/example_stata_logistic.log.bak"', replace
capture log close
log using `"`outdir'/example_stata_logistic.log"', replace text
about

local report `"`outdir'/example_stata_logistic_`ngroups'groups.docx"'
local marker `"`outdir'/STATA_LOGISTIC_EXAMPLE_OK.txt"'
capture erase `"`marker'"'

capture program drop example_table_style
program define example_table_style
    syntax namelist(min=1 max=1), [PARENTROWS(numlist)]
    local t `namelist'
    putdocx table `t'(.,.), border(all, nil)
    putdocx describe `t'
    local nr = r(nrows)
    putdocx table `t'(1,.), border(top, single, "000000", 0.5) border(bottom, single, "000000", 0.5)
    putdocx table `t'(`nr',.), border(bottom, single, "000000", 0.5)
    putdocx table `t'(.,.), font("Times New Roman", 10, black)
    putdocx table `t'(1,.), bold
    foreach pr of numlist `parentrows' {
        putdocx table `t'(`pr',.), bold
    }
    forvalues i = 1/`nr' {
        putdocx table `t'(`i',.), nosplit
    }
end

capture program drop example_post_table
program define example_post_table
    syntax, TITLE(string) NOTE(string) SAVE(string) PARENTROWS(numlist)
    putdocx paragraph, style(Heading2)
    putdocx text (`"`title'"')
    matrix ex_width = (35, 10, 15, 20, 20)
    collect style putdocx, width(ex_width) layout(fixed) headerrow(1)
    collect save `"`save'"', replace
    tempname t
    putdocx collect, tablename(`t')
    putdocx table `t'(1,1) = ("Variable / category")
    putdocx describe `t'
    local nc = r(ncols)
    putdocx table `t'(.,1), halign(left)
    forvalues j = 2/`nc' {
        putdocx table `t'(.,`j'), halign(center)
    }
    example_table_style `t', parentrows(`parentrows')
    putdocx paragraph
    putdocx text (`"`note'"')
end

* Deterministic 36-participant demonstration data; two-group mode retains 0/2.
set obs 36
gen long id = _n
gen byte group = cond(id <= 12, 0, cond(id <= 24, 1, 2))
label define ex_group 0 "Control" 1 "Moderate" 2 "Severe", replace
label values group ex_group
gen byte sex = mod(id, 2)
label define ex_sex 0 "Male" 1 "Female", replace
label values sex ex_sex
gen byte exposure = mod(id, 3) + 1
label define ex_exposure 1 "Level 1" 2 "Level 2" 3 "Level 3", replace
label values exposure ex_exposure
label define ex_outcome 0 "No event" 1 "Event", replace
if `ngroups' == 2 {
    keep if inlist(group, 0, 2)
    replace group = group == 2
    label define ex_group2 0 "Control" 1 "Severe", replace
    label values group ex_group2
}
gen byte outcome = mod(id + group + 2*sex + exposure, 7) < 3
label values outcome ex_outcome
assert !missing(id, group, sex, exposure)
assert _N == cond(`ngroups' == 3, 36, 24)
putdocx clear
putdocx begin, pagesize(A4) font("Times New Roman", 10) margin(top, 1.6cm) margin(bottom, 1.6cm) margin(left, 1.6cm) margin(right, 1.6cm)
putdocx paragraph, style(Title)
putdocx text ("Synthetic Stata collect logistic example")
putdocx paragraph
putdocx text ("Publication-style logistic regression table; no clinical interpretation")

* Native logistic models on the same complete-case sample.
quietly count if !missing(outcome, sex, exposure)
local logit_N = r(N)
assert `logit_N' > 0
assert inlist(outcome, 0, 1)
quietly count if !missing(outcome, sex, exposure) & outcome == 1
local logit_event_n = r(N)
local logit_event_pct = 100*`logit_event_n'/`logit_N'
local logit_event_pct_label : display %4.1f `logit_event_pct'
local logit_zcrit = invnormal(.975)
local cc !missing(outcome, sex, exposure)
foreach v in sex exposure {
    levelsof `v', local(levels)
    foreach k of local levels {
        quietly count if `cc' & `v' == `k'
        scalar ex_n_`v'`k' = r(N)
        assert ex_n_`v'`k' > 0
        quietly count if `cc' & `v' == `k' & outcome == 1
        scalar ex_pct_`v'`k' = 100*r(N)/ex_n_`v'`k'
    }
}
logistic outcome i.sex if `cc'
assert e(N) == `logit_N'
assert e(converged) == 1
assert e(rank) == 2
scalar ex_or_uv_sex1 = exp(_b[1.sex])
scalar ex_ll_uv_sex1 = exp(_b[1.sex] - `logit_zcrit'*_se[1.sex])
scalar ex_ul_uv_sex1 = exp(_b[1.sex] + `logit_zcrit'*_se[1.sex])
logistic outcome i.exposure if `cc'
assert e(N) == `logit_N'
assert e(converged) == 1
assert e(rank) == 3
scalar ex_or_uv_exp2 = exp(_b[2.exposure])
scalar ex_ll_uv_exp2 = exp(_b[2.exposure] - `logit_zcrit'*_se[2.exposure])
scalar ex_ul_uv_exp2 = exp(_b[2.exposure] + `logit_zcrit'*_se[2.exposure])
scalar ex_or_uv_exp3 = exp(_b[3.exposure])
scalar ex_ll_uv_exp3 = exp(_b[3.exposure] - `logit_zcrit'*_se[3.exposure])
scalar ex_ul_uv_exp3 = exp(_b[3.exposure] + `logit_zcrit'*_se[3.exposure])
logistic outcome i.sex i.exposure if `cc'
assert e(N) == `logit_N'
assert e(converged) == 1
assert e(rank) == 4
scalar ex_or_mv_sex1 = exp(_b[1.sex])
scalar ex_ll_mv_sex1 = exp(_b[1.sex] - `logit_zcrit'*_se[1.sex])
scalar ex_ul_mv_sex1 = exp(_b[1.sex] + `logit_zcrit'*_se[1.sex])
scalar ex_or_mv_exp2 = exp(_b[2.exposure])
scalar ex_ll_mv_exp2 = exp(_b[2.exposure] - `logit_zcrit'*_se[2.exposure])
scalar ex_ul_mv_exp2 = exp(_b[2.exposure] + `logit_zcrit'*_se[2.exposure])
scalar ex_or_mv_exp3 = exp(_b[3.exposure])
scalar ex_ll_mv_exp3 = exp(_b[3.exposure] - `logit_zcrit'*_se[3.exposure])
scalar ex_ul_mv_exp3 = exp(_b[3.exposure] + `logit_zcrit'*_se[3.exposure])
foreach s in ex_or_uv_sex1 ex_ll_uv_sex1 ex_ul_uv_sex1 ex_or_uv_exp2 ex_ll_uv_exp2 ex_ul_uv_exp2 ex_or_uv_exp3 ex_ll_uv_exp3 ex_ul_uv_exp3 ex_or_mv_sex1 ex_ll_mv_sex1 ex_ul_mv_sex1 ex_or_mv_exp2 ex_ll_mv_exp2 ex_ul_mv_exp2 ex_or_mv_exp3 ex_ll_mv_exp3 ex_ul_mv_exp3 {
    assert `s' > 0 & `s' < .
}

local model_N = e(N)
local model_neg2ll = -2*e(ll)
local model_lr = e(chi2)
local model_df = e(df_m)
local model_p = e(p)
local model_r2 = e(r2_p)
assert `model_neg2ll' < . & `model_lr' < . & `model_p' < . & `model_r2' < .
local model_neg2ll_label : display %6.2f `model_neg2ll'
local model_lr_label : display %6.2f `model_lr'
local model_r2_label : display %5.3f `model_r2'
local model_p_label : display %5.3f `model_p'
if `model_p' < .001 {
    local model_p_label "<0.001"
}

collect clear
foreach m in univariable multivariable {
    collect get or = 1, tags(model[`m'] predictor[sex] category[sex_ref])
    collect get or = 1, tags(model[`m'] predictor[exposure] category[exp_ref])
}
collect get N = scalar(ex_n_sex0), tags(predictor[sex] category[sex_ref])
collect get outcome_pct = scalar(ex_pct_sex0), tags(predictor[sex] category[sex_ref])
collect get N = scalar(ex_n_sex1), tags(predictor[sex] category[sex_female])
collect get outcome_pct = scalar(ex_pct_sex1), tags(predictor[sex] category[sex_female])
foreach k in 1 2 3 {
    local cat = cond(`k' == 1, "exp_ref", "exp`k'")
    collect get N = scalar(ex_n_exposure`k'), tags(predictor[exposure] category[`cat'])
    collect get outcome_pct = scalar(ex_pct_exposure`k'), tags(predictor[exposure] category[`cat'])
}
collect get or = scalar(ex_or_uv_sex1), tags(model[univariable] predictor[sex] category[sex_female])
collect get ll = scalar(ex_ll_uv_sex1), tags(model[univariable] predictor[sex] category[sex_female])
collect get ul = scalar(ex_ul_uv_sex1), tags(model[univariable] predictor[sex] category[sex_female])
collect get or = scalar(ex_or_mv_sex1), tags(model[multivariable] predictor[sex] category[sex_female])
collect get ll = scalar(ex_ll_mv_sex1), tags(model[multivariable] predictor[sex] category[sex_female])
collect get ul = scalar(ex_ul_mv_sex1), tags(model[multivariable] predictor[sex] category[sex_female])
foreach k in 2 3 {
    collect get or = scalar(ex_or_uv_exp`k'), tags(model[univariable] predictor[exposure] category[exp`k'])
    collect get ll = scalar(ex_ll_uv_exp`k'), tags(model[univariable] predictor[exposure] category[exp`k'])
    collect get ul = scalar(ex_ul_uv_exp`k'), tags(model[univariable] predictor[exposure] category[exp`k'])
    collect get or = scalar(ex_or_mv_exp`k'), tags(model[multivariable] predictor[exposure] category[exp`k'])
    collect get ll = scalar(ex_ll_mv_exp`k'), tags(model[multivariable] predictor[exposure] category[exp`k'])
    collect get ul = scalar(ex_ul_mv_exp`k'), tags(model[multivariable] predictor[exposure] category[exp`k'])
}
collect composite define ex_ci = ll ul, delimiter(", ") trim override
collect composite define ex_orci = or ex_ci, delimiter(" [") trim override
collect label levels model univariable "Univariable OR [95% CI]" multivariable "Multivariable OR [95% CI]", modify
collect label levels predictor sex "Sex" exposure "Exposure", modify
collect label levels category sex_ref "Male (reference)" sex_female "Female" exp_ref "Level 1 (reference)" exp2 "Level 2" exp3 "Level 3", modify
collect style cell result[or ll ul], nformat(%5.2f)
collect style cell result[ex_orci], nformat(%5.2f) sformat("%s]")
collect style cell category[sex_ref exp_ref]#result[ex_orci], sformat("%s [Reference]")
collect style header model, level(label)
collect label levels result N "N" outcome_pct "Outcome=1 (%)", modify
collect style cell result[N], nformat(%3.0f)
collect style cell result[outcome_pct], nformat(%5.1f) sformat("%s%%")
collect style header result[N outcome_pct], level(label)
collect style header result[ex_orci], level(hide)
collect style row stack, nobinder
collect layout (predictor#category) (result[N outcome_pct] model#result[ex_orci])
example_post_table, parentrows(2 5) title("Table 1. Logistic regression for outcome=1 (N=`logit_N'; outcome `logit_event_n'/`logit_N' [`logit_event_pct_label'%])") note("95% Wald CIs; adjusted for sex and exposure. Multivariable model: N=`model_N'; LR chi2(`model_df')=`model_lr_label', p=`model_p_label'; -2LL=`model_neg2ll_label'; McFadden pseudo-R2=`model_r2_label'.") save(`"`outdir'/table_3_logistic.stjson"')

putdocx save `"`report'"', replace
confirm file `"`report'"'
confirm file `"`outdir'/table_3_logistic.stjson"'

file open exok using `"`marker'"', write replace
file write exok "STATA_LOGISTIC_EXAMPLE_OK" _n
file write exok "ngroups=`ngroups'" _n
file write exok "word=`report'" _n
file close exok
log close
display as result "STATA_LOGISTIC_EXAMPLE_OK: `report'"
