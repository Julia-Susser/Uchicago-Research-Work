cd "~/Dropbox/thesis/4_CPS/clean_HPV/src"

import delimited "../input/cps_00054.csv", clear

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// 1970 Census OCC codes --> occ1990dd, deming
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
gen occ70 = occly if inrange(year, 1971, 1982)

drop if occ70 == 999 // unemployed
drop if occ70 == 0 // seem to be unemployed; tab incwage if occ70 == 0

merge m:1 occ70 using "../../../3_Notes/deming_xwalk_occ/occ1970_occ1990dd"

// These are the 1970 occ codes which need to find an occ1990dd code. 
// Drop if no good home. 
tab occ70 if _merge == 1
drop _merge occ70

/* 
      occ70 |      Freq.     Percent        Cum.
------------+-----------------------------------
         92 |         11       13.92       13.92
        156 |         27       34.18       48.10
        572 |         19       24.05       72.15
        659 |          1        1.27       73.42
        775 |          6        7.59       81.01
        924 |         15       18.99      100.00
------------+-----------------------------------
      Total |         79      100.00

 */

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// 1980 Census OCC codes --> occ1990dd, deming
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
gen occ = occly if inrange(year, 1983, 1991)

merge m:1 occ using "../../../3_Notes/deming_xwalk_occ/occ1980_occ1990dd", update   
tab occ if _merge ==1 
/* 
        occ |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |    676,828       99.52       99.52
        905 |      3,274        0.48      100.00
------------+-----------------------------------
      Total |    680,102      100.00

       */
drop if occ == 0 | occ == 905 // unemployed
drop occ _merge

count if mi(occ1990dd) & inrange(year, 1983, 1991)
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// 1990 Census OCC codes --> occ1990dd, deming
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
gen occ = occly if inrange(year, 1992, 2002)

merge m:1 occ using "../../../3_Notes/deming_xwalk_occ/occ1990_occ1990dd",  update
tab occ if _merge == 1

/* 
        occ |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |    809,795       99.30       99.30
        905 |      5,697        0.70      100.00
------------+-----------------------------------
      Total |    815,492      100.00
 */
drop if occ == 0 | occ == 905  // unemployed
drop occ _merge

drop if year > 2002
drop if occly==999
// drop if mi(occ1990dd)
export delimited "../input/cps_00054_occ1990dd.csv", replace
// end