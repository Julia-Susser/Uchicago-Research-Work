cd "~/Dropbox/thesis/5_APST/z_compute_distance/src"

// j = 3digit occupations
// l = 2digit occupations (1digit occupations)

// 1. Merge N_jt = # of workers who work in occ j in decade t with PCA output.
// ROW is {occ j} x {decade}
// COL is {PCA 1} x {PCA 2} ..., N_jt

// 2. GET DISSIMILARITY
// 	- Normal PCA and Sparse
// 	- Decade level-pca and everything-pca 
// 	- 3,4,7 p.c.
// 	- 1digit and 2digit 

// 3. Plot over time (scatter or line plot)

// y = dissimilarity
// x = decade 
// dot = 2digit occupation 

/*----------------------------------------------------*/
   /* [>   1..  Employment weights   <] */ 
/*----------------------------------------------------*/

import delimited "../input/current_values.csv", clear
rename digitoccupation occ1990dd
rename digitindustry ind1
rename v4 occ1990dd_2digit
rename v5 occ1990dd_1digit
rename education educ

gen period = "."
replace period = "(1976,1980]" if inrange(year, 1976, 1980)
replace period = "(1981,1985]" if inrange(year, 1981, 1985)
replace period = "(1986,1990]" if inrange(year, 1986, 1990)
replace period = "(1991,1995]" if inrange(year, 1991, 1995)
replace period = "(1996,2000]" if inrange(year, 1996, 2000)
encode period, gen(yearbin)
drop if mi(period) | mi(educ)

// COMPUTE EMPLOYMENT WEIGHTS
preserve
	gen i = 1
	collapse (sum) N=i [aw=asecwt], by(period occ1990dd)  
	replace N = round(N)
	save "../output/emp_weights", replace
restore 

gen lwage  = log(wage)
gen lhours = log(annualhours)

// Worker skill
recode educ   (10/73 = 1) (74/109 = 2) (110/126 = 3) (nonmissing=.) (missing=.), gen(worker_skill)
gen worker_lowskill 	= (worker_skill==1)  	// High school or less
gen worker_medskill 	= (worker_skill==2) 	// Some college
gen worker_highskill 	= (worker_skill==3) 	// 4 years of college or more

drop if mi(yearbin)
qui reg lwage i.yearbin i.ind1 i.worker_skill i.big_firm i.white i.male exp exp2 lhours [aw=asecwt]
predict resid

gen i = 1
gcollapse (sd) sd_wage=resid (mean) lwage lhours year (firstnm) occ1990dd_1digit (sum) emp=i [aw=asecwt], by(period occ1990dd_2digit)

keep if inlist(period, "(1976,1980]", "(1996,2000]")

sort occ1990dd_2digit year
bys occ1990dd_2digit: gen d_sd_wage = sd_wage - sd_wage[_n-1]
bys occ1990dd_2digit: gen d_lhour = lhours - lhours[_n-1]
bys occ1990dd_2digit: gen d_lwage = lwage - lwage[_n-1]
bys occ1990dd_2digit: gen d_lemp  = log(emp) - log(emp[_n-1])
// keep if period == "(1996,2000]"


twoway ///
	(scatter d_sd_wage occ1990dd_2digit if inlist(occ1990dd_1digit,1,2), mcolor(blue) mlabel(occ1990dd_2digit)) ///
	(scatter d_sd_wage occ1990dd_2digit if occ1990dd_1digit==3, mcolor(red) mlabel(occ1990dd_2digit)) ///
	(scatter d_sd_wage occ1990dd_2digit if inlist(occ1990dd_1digit,4,5,6), mcolor(black) mlabel(occ1990dd_2digit) mlabcolor(black)) ///
	, legend(pos("10") order(1 "Manage/Office" 2 "Service" 3 "Production")) ytitle("Change in variance of wages")

// Rank 1980 wages
sort period lwage
gen rank_wage80 = _n if period == "(1976,1980]"
gsort occ1990dd_2digit period
by occ1990dd_2digit: replace rank_wage80 = rank_wage80[_n-1] if mi(rank_wage80)
by occ1990dd_2digit: gen wage80 = lwage[_n-1]

rename d_sd_wage resid_diff
save "../output/resid_differences", replace
 
/*----------------------------------------------------*/
   /* [>   2.  Compute distance   <] */ 
/*----------------------------------------------------*/

local num_pc 4
global pcatype "fullpanel_sparse`num_pc'"
global file "../../dimension_reduction/output/${pcatype}.csv"
import delimited ${file}, clear
//drop v? index

// Typo earlier
replace period = "(1976,1980]" if period == "(1975, 1980]"
replace period = "(1981,1985]" if period == "(1980, 1985]"
replace period = "(1986,1990]" if period == "(1985, 1990]"
replace period = "(1991,1995]" if period == "(1990, 1995]"
replace period = "(1996,2000]" if period == "(1995, 2000]"

/*
recode occ1990dd_2digit ///
(01/03  = 01)   ///
(04/06  = 02)   ///
(07/12  = 03)   /// 
(13     = 04)   ///
(14/17  = 05)   ///
(18/19  = 06)   ///
(nonmissing = .)  ///
(missing  = .)  ///
, gen(occ1990dd_1digit)
 */

#delimit;
label define occ1990dd_1_label
01 "Manage/Professional"
02 "Tech/Sales/Admin"
03 "Service"
04 "Farm/Fish/Forest"
05 "Production"
06 "Operators";
#delimit cr
label values occ1990dd_1digit occ1990dd_1_label

#delimit;
label define occ1990dd_2_label
01 "Exec/Admin/Manage"
02 "Management"
03 "Professional"
04 "Technicians"
05 "Sales"
06 "Admin"
07 "Cleaning"
08 "Protection"
09 "Food prep."
10 "Health supp."
11 "Maintenance"
12 "Personal care"
13 "Farm/Fish/Forest"
14 "Mechanic/Repair"
15 "Construction"
16 "Extraction"
17 "Production"
18 "Machinists"
19 "Transport/Material moving";
#delimit cr
label values occ1990dd_2digit occ1990dd_2_label

// 2. WANT DISSIMILARITY (l, t)
// For each p.c. k 
// 		DISTANCE_tjk = abs( score_tjk - AVERAGE_tlk )
 
// Demean
merge 1:1 period occ1990dd using "../output/emp_weights"
gen distance_jp = 0

forvalues p = 1(1)`num_pc' {

	// COMPUTE 2DIGIT WTD. MEAN OF THAT P.C.
	egen mean_pc`p' = wtmean(pc`p'), weight(N) by(occ1990dd_2digit period)

	// COMPUTE DEVIATION OF 3DIGIT FROM 2DIGIT FOR PC K 
	replace pc`p' = abs(pc`p' - mean_pc`p')

	// DISTANCE_tj = dev_pc1 + dev_pc2 + dev_pc3 +...
	replace distance_jp = distance_jp + pc`p'
	drop mean_pc`p'	
} 

// DISSSIMILARITY_tl is a weighted average of deviations. 
collapse (mean) dissimilarity_j2p=distance_jp (firstnm) occ1990dd_1digit (rawsum) N [fw=N], by(occ1990dd_2digit period)

gen year = .
replace year = 1978 if period == "(1976,1980]"
replace year = 1983 if period == "(1981,1985]"
replace year = 1988 if period == "(1986,1990]"
replace year = 1993 if period == "(1991,1995]"
replace year = 1998 if period == "(1996,2000]"

// drop if occ1990dd_2digit == 7
tsset occ1990dd_2digit year, yearly

// replace dissimilarity_j2p = log(dissimilarity_j2p)
graph drop _all
xtline dissimilarity_j2p , t(year) i(occ1990dd_2digit) overlay ///
  legend(order(1 "Exec" 2 "Manage" 3 "Prof")) name(A1)


keep if inlist(period, "(1976,1980]", "(1996,2000]")
sort occ1990dd_2digit period
bys occ1990dd_2digit: gen diff = dissimilarity_j2p - dissimilarity_j2p[_n-1]

twoway ///
	(scatter diff occ1990dd_2digit if inlist(occ1990dd_1digit,1,2), mcolor(blue) mlabel(occ1990dd_2digit)) ///
	(scatter diff occ1990dd_2digit if occ1990dd_1digit==3, mcolor(red) mlabel(occ1990dd_2digit)) ///
	(scatter diff occ1990dd_2digit if inlist(occ1990dd_1digit,4,5,6), mcolor(black) mlabel(occ1990dd_2digit) mlabcolor(black)) ///
	, legend(pos("10") order(1 "Manage/Office" 2 "Service" 3 "Production")) name(A2) ytitle("Change in dissimilarity")

graph export "../output/diff_${pcatype}.png", replace

rename diff dissimilarity_diff
merge 1:1 period occ1990dd_2digit using "../output/resid_differences"

twoway ///
	(scatter resid_diff dissimilarity_diff, mlabel(occ1990dd_2digit)) ///
	(lfit resid_diff dissimilarity_diff [fw=N])

twoway ///
	(scatter d_lemp dissimilarity_diff if inlist(occ1990dd_1digit,2), mcolor(green) mlabel(occ1990dd_2digit) mlabcolor(green) ) ///
	(scatter d_lemp dissimilarity_diff if occ1990dd_1digit==3, mcolor(red) mlabel(occ1990dd_2digit) mlabcolor(red)) ///
	(scatter d_lemp dissimilarity_diff if inlist(occ1990dd_1digit,4,5,6) , mcolor(black) mlabel(occ1990dd_2digit) mlabcolor(black)) ///
	(lfit d_lemp dissimilarity_diff if inrange(occ1990dd_1digit,2,6) [fw=N] , lcolor(gs8) lwidth(thick)) ///
	, ylabel(, format(%2.1f)) legend(pos("8") order(1 "Manage/Prof" 2 "Service" 3 "Production")) ///
	ytitle("Change in log wages 1976-2000") xtitle("Change in dissimilarity index 1976-2000")


// Rank Change in dissimilarity
sort period dissimilarity_diff
gen rank_dis = _n if period == "(1996,2000]"

// Drop Manage prof + Farm
// drop if occ1990dd_1digit == 1 | occ1990dd_1digit == 4

summ rank_dis
local dmax = `r(max)'
local dmin = `r(min)'
replace rank_dis = (rank_dis - `dmin') / (`dmax' - `dmin')


summ rank_wage80
local wmax = `r(max)'
local wmin = `r(min)'
replace rank_wage80 = (rank_wage80 - `wmin') / (`wmax' - `wmin')
 
summ d_lwage
local wmax = `r(max)'
local wmin = `r(min)'
replace d_lwage = (d_lwage - `wmin') / (`wmax' - `wmin')


summ dissimilarity_diff
local wmax = `r(max)'
local wmin = `r(min)'
replace dissimilarity_diff = (dissimilarity_diff - `wmin') / (`wmax' - `wmin')

graph drop _all

twoway ///
	///(scatter diff_wage rank_wage80 if inlist(occ1990dd_1digit,1), mcolor(blue) mlabcolor(blue) mlabel(occ1990dd_2digit)) ///
	(scatter d_lwage rank_wage80 if inlist(occ1990dd_1digit,2), mcolor(blue) mlabcolor(blue) mlabel(occ1990dd_2digit)  mlabsize(medlarge) msymbol(T)) ///
	(scatter d_lwage rank_wage80 if occ1990dd_1digit==3, mcolor(red) mlabcolor(red) mlabel(occ1990dd_2digit) msymbol(X) msize(vlarge) mlabsize(medlarge)) ///
	(scatter d_lwage rank_wage80 if inlist(occ1990dd_1digit,5,6), mcolor(black) mlabel(occ1990dd_2digit) mlabcolor(black) mlabposition("9") mlabsize(medlarge)) ///
 	(lfit d_lwage rank_wage80 if inlist(occ1990dd_1digit,2,3,5,6) [fw=N], lcolor(gs8) lwidth(thick)) ///
	, ylabel(, format(%2.1f)) legend(pos("8") order(1 "Sales/Admin" 2 "Service" 3 "Production/Operators")) ///
	ytitle("Change in log wages 1976-2000, rescaled") xtitle("Average wages 1976-1980, ranked") ///
	xlabel(, format(%2.1f)) name(A1) ///
	title("A. Occupation skill 1980") nodraw

twoway ///
	///(scatter diff_wage rank_dis if inlist(occ1990dd_1digit,1), mcolor(blue) mlabel(occ1990dd_2digit) mlabcolor(blue) ) ///
	(scatter d_lwage dissimilarity_diff if inlist(occ1990dd_1digit,2) & occ1990dd_2digit!=5, mcolor(blue) mlabel(occ1990dd_2digit) mlabcolor(blue) msymbol(T) mlabsize(medlarge)) ///
	(scatter d_lwage dissimilarity_diff if occ1990dd_2digit==5, mcolor(blue) mlabel(occ1990dd_2digit) mlabcolor(blue) msymbol(T) mlabsize(medlarge) mlabposition("8")) ///
	(scatter d_lwage dissimilarity_diff if occ1990dd_1digit==3, mcolor(red) mlabel(occ1990dd_2digit) mlabcolor(red) msymbol(X) msize(vlarge) mlabsize(medlarge)) ///
	(scatter d_lwage dissimilarity_diff if inlist(occ1990dd_1digit,5,6) , mcolor(black) mlabel(occ1990dd_2digit) mlabcolor(black) mlabposition("3") mlabsize(medlarge)) ///
	(lfit d_lwage dissimilarity_diff if inlist(occ1990dd_1digit,2,3,5,6) [fw=N], lcolor(gs8) lwidth(thick)) ///
	, ylabel(, format(%2.1f)) legend(off) ///
	ytitle("Change in log wages 1976-2000, rescaled") ///
	xtitle("Change in dissimilarity 1976-2000, rescaled") xlabel(, format(%2.1f)) name(A2) ///
	title("B. Changes in diversity") nodraw

graph combine A1 A2, xcommon
graph export "../output/occ2_dlogwage_${pcatype}.png", replace

graph drop _all

twoway ///
	(scatter d_lemp rank_wage80 if inlist(occ1990dd_1digit,1), mcolor(blue) mlabcolor(blue) mlabposition("9") mlabel(occ1990dd_2digit) mlabsize(medlarge)) ///
	(scatter d_lemp rank_wage80 if inlist(occ1990dd_1digit,2), mcolor(green) mlabcolor(green) mlabel(occ1990dd_2digit)  mlabsize(medlarge) msymbol(T)) ///
	(scatter d_lemp rank_wage80 if occ1990dd_1digit==3, mcolor(red) mlabcolor(red) mlabel(occ1990dd_2digit) msymbol(X) msize(vlarge) mlabsize(medlarge)) ///
	(scatter d_lemp rank_wage80 if inlist(occ1990dd_1digit,5,6), mcolor(black) mlabel(occ1990dd_2digit) mlabcolor(black) mlabposition("9") mlabsize(medlarge)) ///
 	(lfit d_lemp rank_wage80 if inlist(occ1990dd_1digit,2,3,5,6) [fw=N], lcolor(gs8) lwidth(thick)) ///
	, ylabel(, format(%2.1f)) legend(pos("10") order(1 "Exec/Manage" 2 "Sales/Admin" 3 "Service" 4 "Production/Operators")) ///
	ytitle("Change in log emp. 1976-2000") xtitle("Average wages 1976-1980, ranked") ///
	xlabel(, format(%2.1f)) name(B1) ///
	title("A. Occupation skill") nodraw

twoway ///
	(scatter d_lemp rank_dis if inlist(occ1990dd_1digit,1), mcolor(blue) mlabcolor(blue) mlabel(occ1990dd_2digit) mlabposition("9") mlabsize(medlarge)) ///
	(scatter d_lemp rank_dis if inlist(occ1990dd_1digit,2), mcolor(green) mlabcolor(green) mlabel(occ1990dd_2digit)  mlabsize(medlarge) msymbol(T)) ///
	(scatter d_lemp rank_dis if occ1990dd_1digit==3, mcolor(red) mlabcolor(red) mlabel(occ1990dd_2digit) msymbol(X) msize(vlarge) mlabsize(medlarge)) ///
	(scatter d_lemp rank_dis if inlist(occ1990dd_1digit,5,6), mcolor(black) mlabel(occ1990dd_2digit) mlabcolor(black) mlabposition("3") mlabsize(medlarge)) ///
 	(lfit d_lemp rank_dis if inlist(occ1990dd_1digit,1,2,3,5,6) [fw=N], lcolor(gs8) lwidth(thick)) ///
	, ylabel(, format(%2.1f)) ///
	legend(off) ///
	///legend(pos("8") order(1 "Exec/Manage" 2 "Sales/Admin" 3 "Service" 4 "Production/Operators")) ///
	ytitle("Change in log emp. 1976-2000") xtitle("Change in specialization 1976-1980, ranked") ///
	xlabel(, format(%2.1f)) name(B2) ///
	title("B. Specialization") nodraw

graph combine B1 B2, xcommon
graph export "../output/occ2_dlogemp_${pcatype}.png", replace
// end

// end
