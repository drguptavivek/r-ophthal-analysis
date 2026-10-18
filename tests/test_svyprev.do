* Test for examples/stata/svyprev.do on synthetic data.
* Run from the skill root: do tests/test_svyprev.do "/absolute/scratch/dir"
args outdir
if "`outdir'" == "" local outdir "`c(tmpdir)'"
clear all
set seed 20261018
do "examples/stata/svyprev.do"

set obs 600
gen cluster = ceil(_n / 20)
gen district = ceil(_n / 200)
gen sex = 1 + (runiform() < 0.5)
label define sexlb 1 "Male" 2 "Female"
label values sex sexlb
gen wt = 0.5 + 1.5 * runiform()
gen vi = runiform() < 0.2
replace vi = . if runiform() < 0.07
gen va_cat = 1 + floor(3 * runiform())
replace va_cat = 2 if district == 3 & va_cat == 3
label define valb 1 "No VI" 2 "Mild" 3 "Moderate"
label values va_cat valb
svyset cluster [pweight = wt]

svyprev vi, over(sex) saving("`outdir'/svyprev_binary.dta", replace)
svyprev va_cat, over(district) saving("`outdir'/svyprev_multi.dta", replace)

* Binary: Female estimate equals the weighted proportion; CI brackets it
quietly summarize vi [aw = wt] if sex == 2
local manual = 100 * r(mean)
use "`outdir'/svyprev_binary.dta", clear
assert _N == 3
assert group[3] == "Total"
assert abs(estimate[2] - `manual') < 1e-8
assert lci < estimate & estimate < uci
assert level == "1"

* Multinomial: empty level gives 0, no CI; total levels sum to 100
use "`outdir'/svyprev_multi.dta", clear
assert _N == 12
assert estimate == 0 & estimable == 0 & missing(lci) if group == "3" & level == "Moderate"
quietly summarize estimate if group == "Total"
assert abs(r(sum) - 100) < 1e-8
assert !missing(deff) if estimable == 1

display "PASS: svyprev handles binary, multinomial, empty levels and totals"
