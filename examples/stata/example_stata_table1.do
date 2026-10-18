version 18.0

/*
  Standalone Stata 18+ Table 1 publication-table example for ophthal-analysis.

  Usage:
      do example_stata_table1.do 3 "/private/tmp/out"

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
    di as error "Usage: do example_stata_table1.do 2|3 absolute_outdir"
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
capture confirm file `"`outdir'/example_stata_table1.log"'
if !_rc copy `"`outdir'/example_stata_table1.log"' `"`outdir'/example_stata_table1.log.bak"', replace
capture log close
log using `"`outdir'/example_stata_table1.log"', replace text
about

local report `"`outdir'/example_stata_table1_`ngroups'groups.docx"'
local marker `"`outdir'/STATA_TABLE1_EXAMPLE_OK.txt"'
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
    syntax, TITLE(string) NOTE(string) SAVE(string) NGROUPS(integer) PARENTROWS(numlist)
    putdocx paragraph, style(Heading2)
    putdocx text (`"`title'"')
    * First column carries the hierarchy; the last 10--15% is the p column.
    if `ngroups' == 2 matrix ex_width = (40, 22.5, 22.5, 15)
    else matrix ex_width = (35, 17, 17, 16, 15)
    collect style putdocx, width(ex_width) layout(fixed) headerrow(1)
    collect save `"`save'"', replace
    tempname t
    putdocx collect, tablename(`t')
    putdocx table `t'(1,1) = ("Characteristic / summary")
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

capture program drop example_post_graph
program define example_post_graph
    syntax, PATH(string) CAPTION(string)
    graph export `"`path'"', replace width(1600) height(950)
    putdocx pagebreak
    putdocx paragraph
    putdocx text (`"`caption'"')
    putdocx paragraph
    putdocx image `"`path'"', width(6.2)
end

* Deterministic 36-participant demonstration data; two-group mode retains 0/2.
set obs 36
gen long id = _n
gen byte group = cond(id <= 12, 0, cond(id <= 24, 1, 2))
label define ex_group 0 "Control" 1 "Moderate" 2 "Severe", replace
label values group ex_group
gen double marker = 10 + 0.4*id + 1.5*group + mod(id, 4)/10
gen double pressure = 14 + 0.2*id + 0.9*group + mod(id, 5)/10
replace marker = . if inlist(id, 4, 17, 30)
replace pressure = . if inlist(id, 7, 21, 34, 35)
gen byte response = cond(mod(id, 2), 1, 3)
label define ex_response 1 "Normal" 2 "Borderline" 3 "Abnormal", replace
label values response ex_response
if `ngroups' == 2 {
    keep if inlist(group, 0, 2)
    replace group = group == 2
    label define ex_group2 0 "Control" 1 "Severe", replace
    label values group ex_group2
}
assert !missing(id, group, response)
assert _N == cond(`ngroups' == 3, 36, 24)

local testname "Kruskal-Wallis"
if `ngroups' == 2 {
    local testname "asymptotic Wilcoxon rank-sum"
}

* Explicit namespaced scalar p-values; Stata's rank procedures handle ties.
foreach v in marker pressure response {
    scalar ex_p_`v'_raw = .
}
if `ngroups' == 3 {
    quietly kwallis marker, by(group)
    scalar ex_p_marker_raw = r(p)
    quietly kwallis pressure, by(group)
    scalar ex_p_pressure_raw = r(p)
}
else {
    quietly ranksum marker, by(group)
    scalar ex_p_marker_raw = r(p)
    quietly ranksum pressure, by(group)
    scalar ex_p_pressure_raw = r(p)
}
quietly tabulate response group, exact
scalar ex_p_response_raw = r(p_exact)

putdocx clear
putdocx begin, pagesize(A4) font("Times New Roman", 10) margin(top, 1.6cm) margin(bottom, 1.6cm) margin(left, 1.6cm) margin(right, 1.6cm)
putdocx paragraph, style(Title)
putdocx text ("Synthetic Stata collect example")
putdocx paragraph
putdocx text ("Publication-style descriptive tables; no clinical interpretation")

* First native dtable collection: baseline continuous and categorical blocks.
collect clear
if `ngroups' == 3 {
    dtable marker pressure i.response, by(group, nototals) nosample continuous(marker pressure, statistics(count mean sd median p25 p75)) factor(response, statistics(fvfrequency fvpercent))
}
else {
    dtable marker pressure i.response, by(group, nototals) nosample continuous(marker pressure, statistics(count mean sd median p25 p75)) factor(response, statistics(fvfrequency fvpercent))
}
collect style cell result[mean sd median p25 p75], nformat(%6.1f)
collect composite define ex_meansd = mean sd, delimiter(" ") trim override
collect composite define ex_quartiles = p25 p75, delimiter(", ") trim override
collect composite define ex_mediqr = median ex_quartiles, delimiter(" (") trim override
quietly count if !missing(marker)
local marker_N = r(N)
quietly count if !missing(pressure)
local pressure_N = r(N)
collect label levels var marker "Marker (arbitrary units; N=`marker_N')", modify
collect label levels var pressure "Pressure (arbitrary units; N=`pressure_N')", modify
collect label levels result ex_meansd "Mean (SD)" ex_mediqr "Median (p25, p75)" count "N", modify
collect style cell cell_type[item]#result[ex_mediqr], sformat("%s)")
collect style header result[count], level(hide)
collect style header result[ex_meansd ex_mediqr], level(label)
collect style header group, title(hide)
collect style row stack, nobinder
collect get count = scalar(ex_p_marker_raw), tags(var[marker] group[raw])
collect get count = scalar(ex_p_pressure_raw), tags(var[pressure] group[raw])
quietly count if !missing(response)
local response_N = r(N)
collect composite define ex_cat = fvfrequency fvpercent, delimiter(" ") trim override
collect label levels var response "Response (N=`response_N')", modify
collect label levels result ex_cat "n (%)", modify
collect label levels response 1 " Normal" 2 " Borderline" 3 " Abnormal", modify
foreach g of numlist 0/2 {
    if (`ngroups' == 2 & `g' == 2) continue
    quietly count if group == `g' & !missing(response)
    local den = r(N)
    collect get count = `den', tags(var[response] group[`g'])
    * dtable supplies levels 1 and 3; add only the approved zero row.
    collect get fvfrequency = 0, tags(var[2.response] response[2] group[`g'])
    collect get fvpercent = 0, tags(var[2.response] response[2] group[`g'])
}
collect get count = scalar(ex_p_response_raw), tags(var[response] group[raw])
collect label levels group raw "Unadjusted p", modify
collect style cell result[count]#group[raw], nformat(%5.3f) minimum(.001)
collect style cell result[count]#group[0 1 2], sformat("n=%s") nformat(%3.0f)
collect style cell result[fvfrequency], nformat(%3.0f)
collect style cell result[fvpercent], nformat(%5.1f) sformat("(%s%%)")
collect style header result[count], level(hide)
collect style header group, title(hide)
collect style row stack, nobinder
if `ngroups' == 2 {
    collect layout (var[marker pressure]#result[count ex_meansd ex_mediqr] var[response]#result[count] response[1 2 3]#result[ex_cat]) (group[0 1 raw])
}
else {
    collect layout (var[marker pressure]#result[count ex_meansd ex_mediqr] var[response]#result[count] response[1 2 3]#result[ex_cat]) (group[0 1 2 raw])
}
example_post_table, ngroups(`ngroups') parentrows(2 5 8) title("Table 1. Baseline characteristics") note("p: `testname' (continuous); Fisher's exact (categorical).") save(`"`outdir'/table_1_baseline.stjson"')

* A focused continuous comparison table precedes the graphs.
if `ngroups' == 2 {
    collect layout (var[marker pressure]#result[count ex_meansd ex_mediqr]) (group[0 1 raw])
}
else {
    collect layout (var[marker pressure]#result[count ex_meansd ex_mediqr]) (group[0 1 2 raw])
}
example_post_table, ngroups(`ngroups') parentrows(2 5) title("Table 2. Continuous outcomes") note("p: `testname'.") save(`"`outdir'/table_2_continuous.stjson"')

* Graphs follow the continuous table block.
graph box marker, over(group) ytitle("Marker (arbitrary units)") legend(off) name(ex_marker, replace)
example_post_graph, path(`"`outdir'/figure_1_marker.png"') caption("Figure 1. Marker by group")
graph box pressure, over(group) ytitle("Pressure (arbitrary units)") legend(off) name(ex_pressure, replace)
example_post_graph, path(`"`outdir'/figure_2_pressure.png"') caption("Figure 2. Pressure by group")
putdocx save `"`report'"', replace
confirm file `"`report'"'
confirm file `"`outdir'/table_1_baseline.stjson"'
confirm file `"`outdir'/table_2_continuous.stjson"'
confirm file `"`outdir'/figure_1_marker.png"'
confirm file `"`outdir'/figure_2_pressure.png"'
file open exok using `"`marker'"', write replace
file write exok "STATA_TABLE1_EXAMPLE_OK" _n
file write exok "ngroups=`ngroups'" _n
file write exok "word=`report'" _n
file close exok
log close
display as result "STATA_TABLE1_EXAMPLE_OK: `report'"
