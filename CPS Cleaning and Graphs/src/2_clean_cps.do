
cd "~/Dropbox/thesis/4_CPS/clean_HPV/src"

// CPI
// --------------------------------

import delimited "../input/cpi_2.csv", clear

rename real_cpis cpi
summ cpi if year == 2000
local cpi2000 = `r(mean)'

replace cpi = cpi / `cpi2000'
save "../input/cpi", replace


// FEDMINWAGE
// --------------------------------

import delimited "../input/Fedminwage.csv", clear
save "../input/fedminwage", replace


import delimited "../input/cps_00054_occ1990dd.csv", clear
drop occly occ90ly occ10ly
drop serial pernum wtfinl cpsid asecflag hflag asecwth
drop hwtfinl marst paidgh 

// Sample Selection - HPV Sample C
// --------------------------------

replace year = year - 1  // income questions ask about 'last year'
replace age  = age  - 1  // income questions ask about 'last year'

// Prime age
drop if age < 25
drop if age > 60

// Employed at firm
keep if classwly == 22
     
// Drop if missing values    
drop if mi(occ1990dd) | mi(ind90ly) | mi(age)
drop if mi(race) | mi(incwage) | mi(wkswork1)
drop if mi(educ) | mi(year) | mi(sex)
keep if incwage < 99999998

// Variables
// --------------------------------

gen male = 1 if (sex==1)
gen female = 1 if (sex==2)

// Big firm has 1000+ employees (=9, 500-999 = 8)
gen bigfirm = (firmsize==9)
replace bigfirm = . if mi(firmsize)

// Race 
gen white = (race==100)        

// Occupation

// occ2
recode occ1990dd ///
(3/22 		= 01) 	///
(23/37  	= 02) 	///
(43/200 	= 03) 	/// 
(203/235 	= 04) 	///
(243/283 	= 05) 	///
(303/389    = 06)   ///
(405/408    = 07)   ///
(415/427 	= 08) 	///
(433/444 	= 09) 	///
(445/447 	= 10) 	///
(448/455 	= 11) 	///
(457/472 	= 12) 	///
(473/498 	= 13) 	///
(503/549 	= 14) 	///
(558/599 	= 15) 	///
(614/617 	= 16) 	///
(628/699 	= 17) 	///
(703/799 	= 18) 	///
(803/889 	= 19) 	///
(nonmissing = .) 	///
(missing 	= .) 	///
, gen(occ1990dd_2digit)

#delimit;
label define occ1990dd_2_label
01 "Exec, Admin, and Managerial"
02 "Management"
03 "Professional"
04 "Technicians"
05 "Sales"
06 "Admin"
07 "Cleaning"
08 "Protection"
09 "Food prep."
10 "Health supp."
11 "Building maintenance"
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

recode occ1990dd ///
(4/199 		= 01) 	///
(203/389  	= 02) 	///
(405/472 	= 03) 	/// 
(473/498 	= 04) 	///
(503/699 	= 05) 	///
(703/889    = 06)   ///
(nonmissing = .) 	///
(missing 	= .) 	///
, gen(occ1990dd_1digit)

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
// =====================================================

// Industry
recode ind90ly ///
(0/199 			= 01) 	///
(200/390	  	= 02) 	///
(391/472	 	= 03) 	/// 
(473/497	 	= 04) 	///
(498/889 		= 05) 	///
(890/1000	  	= 06) 	///
(nonmissing = .) 	///
(missing 	= .) 	///
, gen(ind1)


// Education 
merge m:1 educ using "../input/educ_years_school.dta"
drop if _merge==2
drop _merge

recode years_school ///
(0/11 			= 01) 	///
(12			  	= 02) 	///
(13/15		 	= 03) 	/// 
(16/17		 	= 04) 	///
(18/20	 		= 05) 	///
(nonmissing = .) 	///
(missing 	= .) 	///
, gen(EDUC)

#delimit;
label define EDUC_label
01 "HS Dropout"
02 "HS Grad"
03 "Some college"
04 "College grad"
05 "Adv. Degree";
#delimit cr
label values EDUC EDUC_label
// =====================================================

drop if mi(occ1990dd) | mi(occ1990dd_1digit) | mi(occ1990dd_2digit)

// Experience
gen exp  = age - max(years_school, 12) - 6
gen exp2 = exp ^ 2
drop if exp <=0

// Hours
gen annual_hours = wkswork1 * uhrsworkly
drop if annual_hours < 260

// Drop if report income, but no hours.
drop if incwage > 0 & annual_hours==0

// Earnings
gen inc_self = 0		// # df['OINCBUS'] + df['OINCFARM']   
gen earnings = (2/3) * inc_self + incwage


// Adjust for inflation
// --------------------------------

// Merge in cpi data
merge m:1 year using "../input/cpi"
drop if _merge ==2 
drop _merge

// FED MIN WAGE
// --------------------------------

merge m:1 year using "../input/fedminwage"
drop if _merge ==2 
drop _merge


replace earnings = earnings / cpi
replace fedminwage = fedminwage / cpi 

gen wage = earnings / annual_hours
drop if wage < 0.5 * fedminwage

// PERIOD
egen period = cut(year), at(1940, 1945, 1950, 1955, 1960, 1970, 1975, 1980, 1985, 1990, 1995, 2000, 2005, 2010, 2015, 2020) 

gen i = 1

// // WAGES - EDUCATION
// // --------------------------------

preserve
	keep if male 
	collapse (sum) N=i (mean) wage (firstnm) year [aw=asecwt], by(EDUC period)
	save "../output/wages_educ_period", replace
restore


// WAGES - 2 Digit
// --------------------------------


preserve
	collapse (sum) N=i (mean) wage (firstnm) year [aw=asecwt], by(occ1990dd_2digit period)
		
	recode occ1990dd_2digit ///
	(1/4 		= 01) 	///
	(5/6	  	= 02) 	///
	(7/11	 	= 03) 	/// 
	(12/19	 	= 04) 	///
	(nonmissing = .) 	///
	(missing 	= .) 	///
	, gen(occ1990dd_1digit)

	save "../output/wages_2digit_period", replace
restore

// WAGES - 3 Digit
// --------------------------------


preserve
	collapse (sum) N=i (mean) wage (firstnm) occ1990dd_1digit year [aw=asecwt] ///
	, by(occ1990dd period)
	
	bys occ1990dd: gen n80 = N if period==1980 // 1980
	bys occ1990dd: gen w80 = wage if period==1980

	sort occ1990dd period
	by occ1990dd: replace n80 = n80[_n-1] if mi(n80)
	by occ1990dd: replace w80 = w80[_n-1] if mi(w80)

	gen dlogn = log(N) - log(n80)
	gen dlogw = log(wage) - log(w80)
		
	save "../output/wages_3digit_period", replace
restore


// PLOT - WAGES - 2 Digit
// --------------------------------

use "../output/wages_2digit_period", clear

graph drop _all
twoway ///
	///(scatter wage year if occ1990dd_1digit==1, mcolor(blue)) ///
	///(line wage year if occ1990dd_1digit==1, lcolor(blue) ) ///
	///(scatter wage year if occ1990dd_1digit==2, mcolor(green)) ///
	///(line wage year if occ1990dd_1digit==2, lcolor(green) ) ///
	(scatter wage year if occ1990dd_1digit==3, mcolor(red)) ///
	(line wage year if occ1990dd_1digit==3, lcolor(red) ) ///
	///(scatter dissimilarity year if occ1990dd==4, mcolor(black)) ///
	///(line dissimilarity year if occ1990dd==4, lcolor(black) ) ///
	(scatter wage year if occ1990dd_1digit==4, mcolor(black)) ///
	(line wage year if occ1990dd_1digit==4, lcolor(black) ) ///
	, legend(pos("10") order(1 "Manage/Office" 3 "Sales/Admin" 5 "Service" 7 "Production/Operators")) ylabel(, format(%2.1f)) 


// SANITY CHECK 1 - Binder and Bound fig 1
// ----------------------------------------

use "../output/wages_educ_period", clear 

graph drop _all
twoway ///
	(scatter wage year if EDUC==1, mcolor(blue)) ///
	(line wage year if EDUC==1, lcolor(blue) ) ///
	(scatter wage year if EDUC==2, mcolor(green)) ///
	(line wage year if EDUC==2, lcolor(green) ) ///
	(scatter wage year if EDUC==3, mcolor(black)) ///
	(line wage year if EDUC==3, lcolor(black) ) ///
	(scatter wage year if EDUC==4, mcolor(maroon)) ///
	(line wage year if EDUC==4, lcolor(maroon) ) ///
	(scatter wage year if EDUC==5, mcolor(orange) ) ///
	(line wage year if EDUC==5, lcolor(orange) ) ///
	, legend(pos("10") cols(2) order(1 "HS Dropout" 3 "HS Grad" 5 "Some college" 7 "College grad" 9 "Adv. Degree")) ylabel(, format(%2.1f)) 
// nice


// SANITY CHECK 2 - Autor and Dorn fig 1
// ----------------------------------------

use "../output/wages_3digit_period", clear


keep if period == 2000 // year=2000

sort w80 
// gen skillrank = _n

// summ w80 
// local wmin = `r(min)'
// local wmax = `r(max)'

// gen skillrank = (w80 - `wmin') / (`wmax' - `wmin')

graph drop _all

twoway scatter dlogn skillrank


graph drop _all

twoway scatter dlogw skillrank


// fine.











































// end
