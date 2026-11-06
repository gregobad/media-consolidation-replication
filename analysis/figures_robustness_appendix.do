///////////////////////////////////////////////////
// CREATES THE FIGURES IN THE TWFE APPENDIX      //
///////////////////////////////////////////////////

clear all
	
/////////////////////////					
/////////////////////////
// APPENDIX FIGURE F1  //
/////////////////////////
/////////////////////////

use data/harmony/content_cleaned.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

g semester=ceil(month/6)

collapse (mean) balanced_sample mention_place_pershow mention_pol_local_pershow mention_pol_stateleg_pershow $station_controls (max) station_ownedby_* (min) date  dmacode, by(stationID year semester)

// CREATES ALL THE NECESSARY VARIABLES TO RUN EVENT STUDIES 

// 1. DUMMIES FOR TWFE ES

foreach group in sinclair nexstar gray {
	
	cap drop yearmonth_treated
	bysort stationID: egen yearmonth_treated=min(date/(station_ownedby_`group'_LMA==1))
	format yearmonth_treated %tm

	cap drop t
	g t=date-yearmonth_treated
	tab t, m
	tab t if yearmonth_treated!=636, m

	cap drop t6
	g t6=floor(t/6)
	tab t6, m
	tab t6 if yearmonth_treated!=636, m

	replace t6=-5 if t6<=-5
	replace t6=6 if t6>=6 & t6 != .

	cap drop `group'_minus* `group'_plus*
	levelsof t6, local(times)
	foreach time in `times' {
	di `time'
		if regexm("`time'","([-])([0-9]*)")==1 {
			g `group'_minus`=regexs(2)'=(t6==`time') 
			}
		else {
			g `group'_plus`time' =(t6==`time') 
			}
		}
		
	ren t6 `group'_t6

	cap drop `group'_yearmonth_treated
	g `group'_yearmonth_treated = yearmonth_treated	
	format `group'_yearmonth_treated %tm
				
	}

// 2. VARIABLES FOR dC&dH, CONTROLS

levelsof date, local(dates)
foreach var of varlist $station_controls {
	foreach date in `dates' {
		g `var'`date' = `var' * (date==`date')
		}
	g `var'_lintrend = `var' * date
	}

g todrop = 0
replace todrop = 1 if year(dofm(nexstar_yearmonth_treated))==2019&month(dofm(nexstar_yearmonth_treated))>=7&nexstar_yearmonth_treated!=.
replace todrop = 1 if year(dofm(sinclair_yearmonth_treated))==2019&month(dofm(sinclair_yearmonth_treated))>=7&sinclair_yearmonth_treated!=.
replace todrop = 1 if year(dofm(gray_yearmonth_treated))==2019&month(dofm(gray_yearmonth_treated))>=7&gray_yearmonth_treated!=.
	
//////////////////
// TWFE 		//
//////////////////

// DID

foreach group in sinclair nexstar gray {
	
	reghdfe mention_place_pershow 		`group'_minus5-`group'_minus2 `group'_plus0-`group'_plus6 ///
										if `group'_yearmonth_treated!=636&todrop==0, ///
										absorb(stationID date) cluster(dmacode)

	// saves results									
	preserve
	parmest, fast 
	tempfile `group'
	save ``group'', replace
	restore 
		
	}
	
preserve
clear
use `sinclair'
append using `nexstar'
append using `gray'

keep if regexm(parm,"gray_")==1|regexm(parm,"sinclair_")==1|regexm(parm,"nexstar_")==1

g sinclair = regexm(parm,"sinclair_")
g gray = regexm(parm,"gray_")
g nexstar = regexm(parm,"nexstar_")

g time=regexs(1) if regexm(parm,"([0-9]+)")==1		
destring time, replace	
replace time=time*-1 if regexm(parm,"minus")==1
keep if time>=-5&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ytick(, notick nolabel) xsize(5.5) ysize(4) ///
		ylabel(-7.5(2.5)5, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/mention_place_pershow_TWFEsemesters_DID.pdf, replace
restore

// TRIPLE

foreach group in sinclair nexstar gray {
	
	reghdfe mention_place_pershow 		`group'_minus5-`group'_minus2 `group'_plus0-`group'_plus6 ///
										if `group'_yearmonth_treated!=636&todrop==0, ///
										absorb(stationID date##dmacode) cluster(dmacode)

	// saves results									
	preserve
	parmest, fast 
	tempfile `group'
	save ``group'', replace
	restore 
		
	}
	
preserve
clear
use `sinclair'
append using `nexstar'
append using `gray'

keep if regexm(parm,"gray_")==1|regexm(parm,"sinclair_")==1|regexm(parm,"nexstar_")==1

g sinclair = regexm(parm,"sinclair_")
g gray = regexm(parm,"gray_")
g nexstar = regexm(parm,"nexstar_")

g time=regexs(1) if regexm(parm,"([0-9]+)")==1		
destring time, replace	
replace time=time*-1 if regexm(parm,"minus")==1
keep if time>=-5&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ytick(, notick nolabel) xsize(5.5) ysize(4) ///
		ylabel(-7.5(2.5)5, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/mention_place_pershow_TWFEsemesters_TRIPLEDIFF.pdf, replace
restore



//////////////////
// CDH	   		//
//////////////////
						
// DID

local iter = 1

foreach group in sinclair nexstar gray {
	
	did_multiplegt_dyn 	mention_place_pershow stationID date station_ownedby_`group'_LMA ///
						, ///
						cluster(dmacode) placebo(3) effects(6) 
	
	mat def results_`group' = J(9,4,.)
	
	forvalues effect=1(1)6 {
		mat def results_`group'[`effect',1] = `effect'
		mat def results_`group'[`effect',2] = e(Effect_`effect')
		mat def results_`group'[`effect',3] = e(se_effect_`effect')
		mat def results_`group'[`effect',4] = `iter'
		}
	forvalues placebo=1(1)3 {
		mat def results_`group'[`placebo'+6,1] = `placebo' * -1
		mat def results_`group'[`placebo'+6,2] = e(Placebo_`placebo')
		mat def results_`group'[`placebo'+6,3] = e(se_placebo_`placebo')
		mat def results_`group'[`placebo'+6,4] = `iter'
		}
	
	local ++iter
	}
	
matrix results = results_sinclair\results_nexstar\results_gray

preserve

clear
svmat results 

ren results1 time
ren results2 estimate
ren results3 estimate_se
ren results4 group
 
g sinclair = group==1
g nexstar = group==2
g gray = group==3

keep if time>=-3&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1
replace time = time - 1	// normalize time counter so that -1 -> last period before tmt changes as in TWFE

g min95 = estimate - 1.96*estimate_se
g max95 = estimate + 1.96*estimate_se

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) xsize(5.5) ysize(4) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ytick(, notick nolabel) ///
		ylabel(-7.5(2.5)5, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/mention_place_pershow_dCdH_DID.pdf, replace
restore

// TRIPLE DIFF

local iter = 1

foreach group in sinclair nexstar gray {
	
	did_multiplegt_dyn 	mention_place_pershow stationID date station_ownedby_`group'_LMA ///
						, ///
						cluster(dmacode) placebo(3) effects(6) ///
						trends_nonparam(dmacode) 
	
	mat def results_`group' = J(11,4,.)
	
	forvalues effect=1(1)6 {
		mat def results_`group'[`effect',1] = `effect'
		mat def results_`group'[`effect',2] = e(Effect_`effect')
		mat def results_`group'[`effect',3] = e(se_effect_`effect')
		mat def results_`group'[`effect',4] = `iter'
		}
	forvalues placebo=1(1)3 {
		mat def results_`group'[`placebo'+6,1] = `placebo' * -1
		mat def results_`group'[`placebo'+6,2] = e(Placebo_`placebo')
		mat def results_`group'[`placebo'+6,3] = e(se_placebo_`placebo')
		mat def results_`group'[`placebo'+6,4] = `iter'
		}
	
	local ++iter
	}
	
matrix results = results_sinclair\results_nexstar\results_gray

preserve

clear
svmat results 

ren results1 time
ren results2 estimate
ren results3 estimate_se
ren results4 group
 
g sinclair = group==1
g nexstar = group==2
g gray = group==3

keep if time>=-3&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1
replace time = time - 1	// normalize time counter so that -1 -> last period before tmt changes as in TWFE

g min95 = estimate - 1.96*estimate_se
g max95 = estimate + 1.96*estimate_se

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) xsize(5.5) ysize(4) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ytick(, notick nolabel) ///
		ylabel(-7.5(2.5)5, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/mention_place_pershow_dCdH_TRIPLEDIFF.pdf, replace
restore


///////////////////////
// CDH WITH CONTROLS //
///////////////////////
										  
// DID

local iter = 1

foreach group in sinclair nexstar gray {
	
	did_multiplegt_dyn 	mention_place_pershow stationID date station_ownedby_`group'_LMA ///
						, ///
						cluster(dmacode) placebo(3) effects(6) ///
						controls(log_duration_news_2010??? log_spend_news_2010??? rating_news_2010???)
	
	mat def results_`group' = J(9,4,.)
	
	forvalues effect=1(1)6 {
		mat def results_`group'[`effect',1] = `effect'
		mat def results_`group'[`effect',2] = e(Effect_`effect')
		mat def results_`group'[`effect',3] = e(se_effect_`effect')
		mat def results_`group'[`effect',4] = `iter'
		}
	forvalues placebo=1(1)3 {
		mat def results_`group'[`placebo'+6,1] = `placebo' * -1
		mat def results_`group'[`placebo'+6,2] = e(Placebo_`placebo')
		mat def results_`group'[`placebo'+6,3] = e(se_placebo_`placebo')
		mat def results_`group'[`placebo'+6,4] = `iter'
		}
	
	local ++iter
	}
	
matrix results = results_sinclair\results_nexstar\results_gray

preserve

clear
svmat results 

ren results1 time
ren results2 estimate
ren results3 estimate_se
ren results4 group
 
g sinclair = group==1
g nexstar = group==2
g gray = group==3

keep if time>=-3&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1
replace time = time - 1	// normalize time counter so that -1 -> last period before tmt changes as in TWFE

g min95 = estimate - 1.96*estimate_se
g max95 = estimate + 1.96*estimate_se

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) xsize(5.5) ysize(4) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ytick(, notick nolabel) ///
		ylabel(-7.5(2.5)5, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/mention_place_pershow_dCdH_DID_controls.pdf, replace
restore

// TRIPLE DIFF

local iter = 1

foreach group in sinclair nexstar gray {
	
	did_multiplegt_dyn 	mention_place_pershow stationID date station_ownedby_`group'_LMA ///
						, ///
						cluster(dmacode) placebo(3) effects(6) ///
						trends_nonparam(dmacode) ///
						controls(log_duration_news_2010??? log_spend_news_2010??? rating_news_2010???)
				
	
	mat def results_`group' = J(9,4,.)
	
	forvalues effect=1(1)6 {
		mat def results_`group'[`effect',1] = `effect'
		mat def results_`group'[`effect',2] = e(Effect_`effect')
		mat def results_`group'[`effect',3] = e(se_effect_`effect')
		mat def results_`group'[`effect',4] = `iter'
		}
	forvalues placebo=1(1)3 {
		mat def results_`group'[`placebo'+6,1] = `placebo' * -1
		mat def results_`group'[`placebo'+6,2] = e(Placebo_`placebo')
		mat def results_`group'[`placebo'+6,3] = e(se_placebo_`placebo')
		mat def results_`group'[`placebo'+6,4] = `iter'
		}
	
	local ++iter
	}
	
matrix results = results_sinclair\results_nexstar\results_gray

preserve

clear
svmat results 

ren results1 time
ren results2 estimate
ren results3 estimate_se
ren results4 group
 
g sinclair = group==1
g nexstar = group==2
g gray = group==3

keep if time>=-3&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

// cannot estimate placebo - 3 in this case
// HUGE CIs

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1
replace time = time - 1	// normalize time counter so that -1 -> last period before tmt changes as in TWFE

g min95 = estimate - 1.96*estimate_se
g max95 = estimate + 1.96*estimate_se

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) xsize(5.5) ysize(4) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ytick(, notick nolabel) ///
		ylabel(-12.5(2.5)12.5, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/mention_place_pershow_dCdH_TRIPLEDIFF_controls.pdf, replace
restore





//////////////////////////////
//////////////////////////////
// APPENDIX FIGURE F2  	   //
//////////////////////////////
//////////////////////////////

use data/adintel/adintel_clean_updated.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

drop if year==2010
drop if year==2020

g semester=ceil(month/6)

collapse (mean) duration_perHH_news spend_perHH_news $station_controls (max) station_ownedby_* (min) date  dmacode, by(stationID year semester)

g log_duration_perHH_news = log(duration_perHH_news)
g log_spend_perHH_news = log(spend_perHH_news)

// CREATES ALL THE NECESSARY VARIABLES TO RUN EVENT STUDIES 

// 1. DUMMIES FOR TWFE ES

foreach group in sinclair nexstar gray {
	
	cap drop yearmonth_treated
	bysort stationID: egen yearmonth_treated=min(date/(station_ownedby_`group'_LMA==1))
	format yearmonth_treated %tm

	cap drop t
	g t=date-yearmonth_treated
	tab t, m
	tab t if yearmonth_treated!=612, m

	cap drop t6
	g t6=floor(t/6)
	tab t6, m
	tab t6 if yearmonth_treated!=612, m

	replace t6=-5 if t6<=-5
	replace t6=6 if t6>=6 & t6 != .

	cap drop `group'_minus* `group'_plus*
	levelsof t6, local(times)
	foreach time in `times' {
	di `time'
		if regexm("`time'","([-])([0-9]*)")==1 {
			g `group'_minus`=regexs(2)'=(t6==`time') 
			}
		else {
			g `group'_plus`time' =(t6==`time') 
			}
		}

	ren t6 `group'_t6

	cap drop `group'_yearmonth_treated
	g `group'_yearmonth_treated = yearmonth_treated	
			
	}

// 2. VARIABLES FOR dC&dH, CONTROLS

levelsof date, local(dates)
foreach var of varlist $station_controls {
	foreach date in `dates' {
		g `var'`date' = `var' * (date==`date')
		}
	g `var'_lintrend = `var' * date
	}


g todrop = 0
replace todrop = 1 if year(dofm(nexstar_yearmonth_treated))==2019&month(dofm(nexstar_yearmonth_treated))>=7&nexstar_yearmonth_treated!=.
replace todrop = 1 if year(dofm(sinclair_yearmonth_treated))==2019&month(dofm(sinclair_yearmonth_treated))>=7&sinclair_yearmonth_treated!=.
replace todrop = 1 if year(dofm(gray_yearmonth_treated))==2019&month(dofm(gray_yearmonth_treated))>=7&gray_yearmonth_treated!=.

	
//////////////////
// TWFE 		//
//////////////////

// DID

foreach group in sinclair nexstar gray {
	
	reghdfe log_duration_perHH_news 	`group'_minus5-`group'_minus2 `group'_plus0-`group'_plus6 ///
										if `group'_yearmonth_treated!=612&todrop==0, ///
										absorb(stationID date) cluster(dmacode)

	// saves results									
	preserve
	parmest, fast 
	tempfile `group'
	save ``group'', replace
	restore 
		
	}
	
preserve
clear
use `sinclair'
append using `nexstar'
append using `gray'

keep if regexm(parm,"gray_")==1|regexm(parm,"sinclair_")==1|regexm(parm,"nexstar_")==1

g sinclair = regexm(parm,"sinclair_")
g gray = regexm(parm,"gray_")
g nexstar = regexm(parm,"nexstar_")

g time=regexs(1) if regexm(parm,"([0-9]+)")==1		
destring time, replace	
replace time=time*-1 if regexm(parm,"minus")==1
keep if time>=-5&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ytick(, notick nolabel) xsize(5.5) ysize(4) ///
		ylabel(-0.2(0.1)0.2, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/log_duration_TWFEsemesters_DID.pdf, replace
restore

// TRIPLE

foreach group in sinclair nexstar gray {
	
	reghdfe log_duration_perHH_news 	`group'_minus5-`group'_minus2 `group'_plus0-`group'_plus6 ///
										if `group'_yearmonth_treated!=612&todrop==0, ///
										absorb(stationID date##dmacode) cluster(dmacode)

	// saves results									
	preserve
	parmest, fast 
	tempfile `group'
	save ``group'', replace
	restore 
		
	}
	
preserve
clear
use `sinclair'
append using `nexstar'
append using `gray'

keep if regexm(parm,"gray_")==1|regexm(parm,"sinclair_")==1|regexm(parm,"nexstar_")==1

g sinclair = regexm(parm,"sinclair_")
g gray = regexm(parm,"gray_")
g nexstar = regexm(parm,"nexstar_")

g time=regexs(1) if regexm(parm,"([0-9]+)")==1		
destring time, replace	
replace time=time*-1 if regexm(parm,"minus")==1
keep if time>=-5&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ytick(, notick nolabel) xsize(5.5) ysize(4) ///
		ylabel(-0.2(0.1)0.2, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/log_duration_TWFEsemesters_TRIPLEDIFF.pdf, replace
restore


//////////////////
// CDH	   		//
//////////////////
						
// DID

local iter = 1

foreach group in sinclair nexstar gray {
	
	did_multiplegt_dyn 	log_duration_perHH_news stationID date station_ownedby_`group'_LMA ///
						, ///
						cluster(dmacode) placebo(3) effects(6) 
	
	mat def results_`group' = J(9,4,.)
	
	forvalues effect=1(1)6 {
		mat def results_`group'[`effect',1] = `effect'
		mat def results_`group'[`effect',2] = e(Effect_`effect')
		mat def results_`group'[`effect',3] = e(se_effect_`effect')
		mat def results_`group'[`effect',4] = `iter'
		}
	forvalues placebo=1(1)3 {
		mat def results_`group'[`placebo'+6,1] = `placebo' * -1
		mat def results_`group'[`placebo'+6,2] = e(Placebo_`placebo')
		mat def results_`group'[`placebo'+6,3] = e(se_placebo_`placebo')
		mat def results_`group'[`placebo'+6,4] = `iter'
		}
	
	local ++iter
	}
	
matrix results = results_sinclair\results_nexstar\results_gray

preserve

clear
svmat results 

ren results1 time
ren results2 estimate
ren results3 estimate_se
ren results4 group
 
g sinclair = group==1
g nexstar = group==2
g gray = group==3

keep if time>=-3&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1
replace time = time - 1	// normalize time counter so that -1 -> last period before tmt changes as in TWFE

g min95 = estimate - 1.96*estimate_se
g max95 = estimate + 1.96*estimate_se

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) xsize(5.5) ysize(4) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ytick(, notick nolabel) ///
		ylabel(-0.2(0.1)0.2, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/log_duration_dCdH_DID.pdf, replace
restore

// TRIPLE DIFF

local iter = 1

foreach group in sinclair nexstar gray {
	
	did_multiplegt_dyn 	log_duration_perHH_news stationID date station_ownedby_`group'_LMA ///
						, ///
						cluster(dmacode) placebo(3) effects(6) ///
						trends_nonparam(dmacode)
	
	mat def results_`group' = J(9,4,.)
	
	forvalues effect=1(1)6 {
		mat def results_`group'[`effect',1] = `effect'
		mat def results_`group'[`effect',2] = e(Effect_`effect')
		mat def results_`group'[`effect',3] = e(se_effect_`effect')
		mat def results_`group'[`effect',4] = `iter'
		}
	forvalues placebo=1(1)3 {
		mat def results_`group'[`placebo'+6,1] = `placebo' * -1
		mat def results_`group'[`placebo'+6,2] = e(Placebo_`placebo')
		mat def results_`group'[`placebo'+6,3] = e(se_placebo_`placebo')
		mat def results_`group'[`placebo'+6,4] = `iter'
		}
	
	local ++iter
	}
	
matrix results = results_sinclair\results_nexstar\results_gray

preserve

clear
svmat results 

ren results1 time
ren results2 estimate
ren results3 estimate_se
ren results4 group
 
g sinclair = group==1
g nexstar = group==2
g gray = group==3

keep if time>=-3&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1
replace time = time - 1	// normalize time counter so that -1 -> last period before tmt changes as in TWFE

g min95 = estimate - 1.96*estimate_se
g max95 = estimate + 1.96*estimate_se

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) xsize(5.5) ysize(4) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ytick(, notick nolabel) ///
		ylabel(-0.2(0.1)0.2, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/log_duration_dCdH_TRIPLEDIFF.pdf, replace
restore



///////////////////////
// CDH WITH CONTROLS //
///////////////////////
						
// DID

local iter = 1

foreach group in sinclair nexstar gray {
	
	did_multiplegt_dyn 	log_duration_perHH_news stationID date station_ownedby_`group'_LMA ///
						, ///
						cluster(dmacode) placebo(3) effects(6) ///
						controls(log_duration_news_2010??? log_spend_news_2010??? rating_news_2010???)
	
	mat def results_`group' = J(9,4,.)
	
	forvalues effect=1(1)6 {
		mat def results_`group'[`effect',1] = `effect'
		mat def results_`group'[`effect',2] = e(Effect_`effect')
		mat def results_`group'[`effect',3] = e(se_effect_`effect')
		mat def results_`group'[`effect',4] = `iter'
		}
	forvalues placebo=1(1)3 {
		mat def results_`group'[`placebo'+6,1] = `placebo' * -1
		mat def results_`group'[`placebo'+6,2] = e(Placebo_`placebo')
		mat def results_`group'[`placebo'+6,3] = e(se_placebo_`placebo')
		mat def results_`group'[`placebo'+6,4] = `iter'
		}
	
	local ++iter
	}
	
matrix results = results_sinclair\results_nexstar\results_gray

preserve

clear
svmat results 

ren results1 time
ren results2 estimate
ren results3 estimate_se
ren results4 group
 
g sinclair = group==1
g nexstar = group==2
g gray = group==3

keep if time>=-3&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1
replace time = time - 1	// normalize time counter so that -1 -> last period before tmt changes as in TWFE

g min95 = estimate - 1.96*estimate_se
g max95 = estimate + 1.96*estimate_se

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) xsize(5.5) ysize(4) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ytick(, notick nolabel) ///
		ylabel(-0.2(0.1)0.2, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/log_duration_dCdH_DID_controls.pdf, replace
restore

// TRIPLE DIFF

local iter = 1

foreach group in sinclair nexstar gray {
	
	did_multiplegt_dyn 	log_duration_perHH_news stationID date station_ownedby_`group'_LMA ///
						, ///
						cluster(dmacode) placebo(3) effects(6) ///
						trends_nonparam(dmacode) ///
						controls(log_duration_news_2010??? log_spend_news_2010??? rating_news_2010???)
				
	
	mat def results_`group' = J(9,4,.)
	
	forvalues effect=1(1)6 {
		mat def results_`group'[`effect',1] = `effect'
		mat def results_`group'[`effect',2] = e(Effect_`effect')
		mat def results_`group'[`effect',3] = e(se_effect_`effect')
		mat def results_`group'[`effect',4] = `iter'
		}
	forvalues placebo=1(1)3 {
		mat def results_`group'[`placebo'+6,1] = `placebo' * -1
		mat def results_`group'[`placebo'+6,2] = e(Placebo_`placebo')
		mat def results_`group'[`placebo'+6,3] = e(se_placebo_`placebo')
		mat def results_`group'[`placebo'+6,4] = `iter'
		}
	
	local ++iter
	}
	
matrix results = results_sinclair\results_nexstar\results_gray

preserve

clear
svmat results 

ren results1 time
ren results2 estimate
ren results3 estimate_se
ren results4 group
 
g sinclair = group==1
g nexstar = group==2
g gray = group==3

keep if time>=-3&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

// cannot estimate placebo - 3 in this case
// HUGE CIs

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1
replace time = time - 1	// normalize time counter so that -1 -> last period before tmt changes as in TWFE

g min95 = estimate - 1.96*estimate_se
g max95 = estimate + 1.96*estimate_se

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) xsize(5.5) ysize(4) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ytick(, notick nolabel) ///
		ylabel(-0.6(0.15)0.6, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/log_duration_dCdH_TRIPLEDIFF_controls.pdf, replace
restore





//////////////////////////////
//////////////////////////////
// APPENDIX FIGURE F3  	   //
//////////////////////////////
//////////////////////////////

use data/adintel/adintel_clean_updated.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

drop if year==2010
drop if year==2020

g semester=ceil(month/6)

collapse (mean) duration_perHH_news spend_perHH_news $station_controls (max) station_ownedby_* (min) date  dmacode, by(stationID year semester)

g log_spend_perHH_news = log(spend_perHH_news)

// CREATES ALL THE NECESSARY VARIABLES TO RUN EVENT STUDIES 

// 1. DUMMIES FOR TWFE ES

foreach group in sinclair nexstar gray {
	
	cap drop yearmonth_treated
	bysort stationID: egen yearmonth_treated=min(date/(station_ownedby_`group'_LMA==1))
	format yearmonth_treated %tm

	cap drop t
	g t=date-yearmonth_treated
	tab t, m
	tab t if yearmonth_treated!=612, m

	cap drop t6
	g t6=floor(t/6)
	tab t6, m
	tab t6 if yearmonth_treated!=612, m

	replace t6=-5 if t6<=-5|t6==.
	replace t6=6 if t6>=6

	cap drop `group'_minus* `group'_plus*
	levelsof t6, local(times)
	foreach time in `times' {
	di `time'
		if regexm("`time'","([-])([0-9]*)")==1 {
			g `group'_minus`=regexs(2)'=(t6==`time') 
			}
		else {
			g `group'_plus`time' =(t6==`time') 
			}
		}

	ren t6 `group'_t6

	cap drop `group'_yearmonth_treated
	g `group'_yearmonth_treated = yearmonth_treated	
			
	}

// 2. VARIABLES FOR dC&dH, CONTROLS

levelsof date, local(dates)
foreach var of varlist $station_controls {
	foreach date in `dates' {
		g `var'`date' = `var' * (date==`date')
		}
	g `var'_lintrend = `var' * date
	}


g todrop = 0
replace todrop = 1 if year(dofm(nexstar_yearmonth_treated))==2019&month(dofm(nexstar_yearmonth_treated))>=7&nexstar_yearmonth_treated!=.
replace todrop = 1 if year(dofm(sinclair_yearmonth_treated))==2019&month(dofm(sinclair_yearmonth_treated))>=7&sinclair_yearmonth_treated!=.
replace todrop = 1 if year(dofm(gray_yearmonth_treated))==2019&month(dofm(gray_yearmonth_treated))>=7&gray_yearmonth_treated!=.
	
	
//////////////////
// TWFE 		//
//////////////////

// DID

foreach group in sinclair nexstar gray {
	
	reghdfe log_spend_perHH_news 		`group'_minus5-`group'_minus2 `group'_plus0-`group'_plus6 ///
										if `group'_yearmonth_treated!=612&todrop==0, ///
										absorb(stationID date) cluster(dmacode)

	// saves results									
	preserve
	parmest, fast 
	tempfile `group'
	save ``group'', replace
	restore 
		
	}
	
preserve
clear
use `sinclair'
append using `nexstar'
append using `gray'

keep if regexm(parm,"gray_")==1|regexm(parm,"sinclair_")==1|regexm(parm,"nexstar_")==1

g sinclair = regexm(parm,"sinclair_")
g gray = regexm(parm,"gray_")
g nexstar = regexm(parm,"nexstar_")

g time=regexs(1) if regexm(parm,"([0-9]+)")==1		
destring time, replace	
replace time=time*-1 if regexm(parm,"minus")==1
keep if time>=-5&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ytick(, notick nolabel) xsize(5.5) ysize(4) ///
		ylabel(-0.3(0.1)0.4, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/log_spending_TWFEsemesters_DID.pdf, replace
restore

// TRIPLE

foreach group in sinclair nexstar gray {
	
	reghdfe log_spend_perHH_news 	`group'_minus5-`group'_minus2 `group'_plus0-`group'_plus6 ///
										if `group'_yearmonth_treated!=612&todrop==0, ///
										absorb(stationID date##dmacode) cluster(dmacode)

	// saves results									
	preserve
	parmest, fast 
	tempfile `group'
	save ``group'', replace
	restore 
		
	}
	
preserve
clear
use `sinclair'
append using `nexstar'
append using `gray'

keep if regexm(parm,"gray_")==1|regexm(parm,"sinclair_")==1|regexm(parm,"nexstar_")==1

g sinclair = regexm(parm,"sinclair_")
g gray = regexm(parm,"gray_")
g nexstar = regexm(parm,"nexstar_")

g time=regexs(1) if regexm(parm,"([0-9]+)")==1		
destring time, replace	
replace time=time*-1 if regexm(parm,"minus")==1
keep if time>=-4&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ytick(, notick nolabel) xsize(5.5) ysize(4) ///
		ylabel(-0.3(0.1)0.4, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/log_spending_TWFEsemesters_TRIPLEDIFF.pdf, replace
restore


//////////////////
// CDH	   		//
//////////////////
						
// DID

local iter = 1

foreach group in sinclair nexstar gray {
	
	did_multiplegt_dyn 	log_spend_perHH_news stationID date station_ownedby_`group'_LMA ///
						, ///
						cluster(dmacode) placebo(3) effects(6) 
	
	mat def results_`group' = J(9,4,.)
	
	forvalues effect=1(1)6 {
		mat def results_`group'[`effect',1] = `effect'
		mat def results_`group'[`effect',2] = e(Effect_`effect')
		mat def results_`group'[`effect',3] = e(se_effect_`effect')
		mat def results_`group'[`effect',4] = `iter'
		}
	forvalues placebo=1(1)3 {
		mat def results_`group'[`placebo'+6,1] = `placebo' * -1
		mat def results_`group'[`placebo'+6,2] = e(Placebo_`placebo')
		mat def results_`group'[`placebo'+6,3] = e(se_placebo_`placebo')
		mat def results_`group'[`placebo'+6,4] = `iter'
		}
	
	local ++iter
	}
	
matrix results = results_sinclair\results_nexstar\results_gray

preserve

clear
svmat results 

ren results1 time
ren results2 estimate
ren results3 estimate_se
ren results4 group
 
g sinclair = group==1
g nexstar = group==2
g gray = group==3

keep if time>=-3&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1

g min95 = estimate - 1.96*estimate_se
g max95 = estimate + 1.96*estimate_se

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) xsize(5.5) ysize(4) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ytick(, notick nolabel) ///
		ylabel(-0.3(0.1)0.4, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/log_spending_dCdH_DID.pdf, replace
restore

// TRIPLE DIFF

local iter = 1

foreach group in sinclair nexstar gray {
	
	did_multiplegt_dyn 	log_spend_perHH_news stationID date station_ownedby_`group'_LMA ///
						, ///
						cluster(dmacode) placebo(3) effects(6) ///
						trends_nonparam(dmacode)
	
	mat def results_`group' = J(9,4,.)
	
	forvalues effect=1(1)6 {
		mat def results_`group'[`effect',1] = `effect'
		mat def results_`group'[`effect',2] = e(Effect_`effect')
		mat def results_`group'[`effect',3] = e(se_effect_`effect')
		mat def results_`group'[`effect',4] = `iter'
		}
	forvalues placebo=1(1)3 {
		mat def results_`group'[`placebo'+6,1] = `placebo' * -1
		mat def results_`group'[`placebo'+6,2] = e(Placebo_`placebo')
		mat def results_`group'[`placebo'+6,3] = e(se_placebo_`placebo')
		mat def results_`group'[`placebo'+6,4] = `iter'
		}
	
	local ++iter
	}
	
matrix results = results_sinclair\results_nexstar\results_gray

preserve

clear
svmat results 

ren results1 time
ren results2 estimate
ren results3 estimate_se
ren results4 group
 
g sinclair = group==1
g nexstar = group==2
g gray = group==3

keep if time>=-3&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1
replace time = time - 1	// normalize time counter so that -1 -> last period before tmt changes as in TWFE

g min95 = estimate - 1.96*estimate_se
g max95 = estimate + 1.96*estimate_se

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) xsize(5.5) ysize(4) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ytick(, notick nolabel) ///
		ylabel(-0.3(0.1)0.4, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/log_spending_dCdH_TRIPLEDIFF.pdf, replace
restore



///////////////////////
// CDH WITH CONTROLS //
///////////////////////
						
// DID

local iter = 1

foreach group in sinclair nexstar gray {
	
	did_multiplegt_dyn 	log_spend_perHH_news stationID date station_ownedby_`group'_LMA ///
						, ///
						cluster(dmacode) placebo(3) effects(6) ///
						controls(log_duration_news_2010??? log_spend_news_2010??? rating_news_2010???)
	
	mat def results_`group' = J(9,4,.)
	
	forvalues effect=1(1)6 {
		mat def results_`group'[`effect',1] = `effect'
		mat def results_`group'[`effect',2] = e(Effect_`effect')
		mat def results_`group'[`effect',3] = e(se_effect_`effect')
		mat def results_`group'[`effect',4] = `iter'
		}
	forvalues placebo=1(1)3 {
		mat def results_`group'[`placebo'+6,1] = `placebo' * -1
		mat def results_`group'[`placebo'+6,2] = e(Placebo_`placebo')
		mat def results_`group'[`placebo'+6,3] = e(se_placebo_`placebo')
		mat def results_`group'[`placebo'+6,4] = `iter'
		}
	
	local ++iter
	}
	
matrix results = results_sinclair\results_nexstar\results_gray

preserve

clear
svmat results 

ren results1 time
ren results2 estimate
ren results3 estimate_se
ren results4 group
 
g sinclair = group==1
g nexstar = group==2
g gray = group==3

keep if time>=-3&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1
replace time = time - 1	// normalize time counter so that -1 -> last period before tmt changes as in TWFE

g min95 = estimate - 1.96*estimate_se
g max95 = estimate + 1.96*estimate_se

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) xsize(5.5) ysize(4) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ytick(, notick nolabel) ///
		ylabel(-0.3(0.1)0.4, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/log_spending_dCdH_DID_controls.pdf, replace
restore

// TRIPLE DIFF

local iter = 1

foreach group in sinclair nexstar gray {
	
	did_multiplegt_dyn 	log_spend_perHH_news stationID date station_ownedby_`group'_LMA ///
						, ///
						cluster(dmacode) placebo(3) effects(6) ///
						trends_nonparam(dmacode) ///
						controls(log_duration_news_2010??? log_spend_news_2010??? rating_news_2010???)
				
	mat def results_`group' = J(9,4,.)
	
	forvalues effect=1(1)6 {
		mat def results_`group'[`effect',1] = `effect'
		mat def results_`group'[`effect',2] = e(Effect_`effect')
		mat def results_`group'[`effect',3] = e(se_effect_`effect')
		mat def results_`group'[`effect',4] = `iter'
		}
	forvalues placebo=1(1)3 {
		mat def results_`group'[`placebo'+6,1] = `placebo' * -1
		mat def results_`group'[`placebo'+6,2] = e(Placebo_`placebo')
		mat def results_`group'[`placebo'+6,3] = e(se_placebo_`placebo')
		mat def results_`group'[`placebo'+6,4] = `iter'
		}

	
	local ++iter
	}
	
matrix results = results_sinclair\results_nexstar\results_gray

preserve

clear
svmat results 

ren results1 time
ren results2 estimate
ren results3 estimate_se
ren results4 group
 
g sinclair = group==1
g nexstar = group==2
g gray = group==3

keep if time>=-3&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

// cannot estimate placebo - 3 in this case
// HUGE CIs

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1
replace time = time - 1	// normalize time counter so that -1 -> last period before tmt changes as in TWFE

g min95 = estimate - 1.96*estimate_se
g max95 = estimate + 1.96*estimate_se

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) xsize(5.5) ysize(4) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ytick(, notick nolabel) ///
		ylabel(, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/log_spending_dCdH_TRIPLEDIFF_controls.pdf, replace
restore


//////////////////////////////
//////////////////////////////
// APPENDIX FIGURE F4       //
//////////////////////////////
//////////////////////////////
	
use data/adintel/adintel_clean_updated.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

drop if year==2010
drop if year==2020

g semester=ceil(month/6)

collapse (mean) rating_total_news $station_controls (max) station_ownedby_* (min) date  dmacode, by(stationID year semester)

// CREATES ALL THE NECESSARY VARIABLES TO RUN EVENT STUDIES 

// 1. DUMMIES FOR TWFE ES

foreach group in sinclair nexstar gray {
	
	cap drop yearmonth_treated
	bysort stationID: egen yearmonth_treated=min(date/(station_ownedby_`group'_LMA==1))
	format yearmonth_treated %tm

	cap drop t
	g t=date-yearmonth_treated
	tab t, m
	tab t if yearmonth_treated!=612, m

	cap drop t6
	g t6=floor(t/6)
	tab t6, m
	tab t6 if yearmonth_treated!=612, m

	replace t6=-5 if t6<=-5
	replace t6=6 if t6>=6 & t6 != .

	cap drop `group'_minus* `group'_plus*
	levelsof t6, local(times)
	foreach time in `times' {
	di `time'
		if regexm("`time'","([-])([0-9]*)")==1 {
			g `group'_minus`=regexs(2)'=(t6==`time') 
			}
		else {
			g `group'_plus`time' =(t6==`time') 
			}
		}

	cap drop `group'_yearmonth_treated
	g `group'_yearmonth_treated = yearmonth_treated	
	
			
	}

// 2. VARIABLES FOR dC&dH, CONTROLS

levelsof date, local(dates)
foreach var of varlist $station_controls {
	foreach date in `dates' {
		g `var'`date' = `var' * (date==`date')
		}
	g `var'_lintrend = `var' * date
	}


g todrop = 0
replace todrop = 1 if year(dofm(nexstar_yearmonth_treated))==2019&month(dofm(nexstar_yearmonth_treated))>=7&nexstar_yearmonth_treated!=.
replace todrop = 1 if year(dofm(sinclair_yearmonth_treated))==2019&month(dofm(sinclair_yearmonth_treated))>=7&sinclair_yearmonth_treated!=.
replace todrop = 1 if year(dofm(gray_yearmonth_treated))==2019&month(dofm(gray_yearmonth_treated))>=7&gray_yearmonth_treated!=.


//////////////////
// TWFE 		//
//////////////////

// DID

foreach group in sinclair nexstar gray {
	
	reghdfe rating_total_news			`group'_minus5-`group'_minus2 `group'_plus0-`group'_plus6 ///
										if `group'_yearmonth_treated!=612&todrop==0, ///
										absorb(stationID date) cluster(dmacode)

	// saves results									
	preserve
	parmest, fast 
	tempfile `group'
	save ``group'', replace
	restore 
		
	}
	
preserve
clear
use `sinclair'
append using `nexstar'
append using `gray'

keep if regexm(parm,"gray_")==1|regexm(parm,"sinclair_")==1|regexm(parm,"nexstar_")==1

g sinclair = regexm(parm,"sinclair_")
g gray = regexm(parm,"gray_")
g nexstar = regexm(parm,"nexstar_")

g time=regexs(1) if regexm(parm,"([0-9]+)")==1		
destring time, replace	
replace time=time*-1 if regexm(parm,"minus")==1
keep if time>=-5&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ytick(, notick nolabel) xsize(5.5) ysize(4) ///
		ylabel(-1.5(1.5)3, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/news_ratings_TWFEsemesters_DID.pdf, replace
restore

// TRIPLE

foreach group in sinclair nexstar gray {
	
	reghdfe rating_total_news 			`group'_minus5-`group'_minus2 `group'_plus0-`group'_plus6 ///
										if `group'_yearmonth_treated!=612&todrop==0, ///
										absorb(stationID date##dmacode) cluster(dmacode)

	// saves results									
	preserve
	parmest, fast 
	tempfile `group'
	save ``group'', replace
	restore 
		
	}
	
preserve
clear
use `sinclair'
append using `nexstar'
append using `gray'

keep if regexm(parm,"gray_")==1|regexm(parm,"sinclair_")==1|regexm(parm,"nexstar_")==1

g sinclair = regexm(parm,"sinclair_")
g gray = regexm(parm,"gray_")
g nexstar = regexm(parm,"nexstar_")

g time=regexs(1) if regexm(parm,"([0-9]+)")==1		
destring time, replace	
replace time=time*-1 if regexm(parm,"minus")==1
keep if time>=-5&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ytick(, notick nolabel) xsize(5.5) ysize(4) ///
		ylabel(-1.5(1.5)3, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/news_ratings_TWFEsemesters_TRIPLEDIFF.pdf, replace
restore

//////////////////
// CDH	   		//
//////////////////
						
// DID

local iter = 1

foreach group in sinclair nexstar gray {
	
	did_multiplegt_dyn 	rating_total_news stationID date station_ownedby_`group'_LMA ///
						, ///
						cluster(dmacode) placebo(3) effects(6) 
	
	mat def results_`group' = J(9,4,.)
	
	forvalues effect=1(1)6 {
		mat def results_`group'[`effect',1] = `effect'
		mat def results_`group'[`effect',2] = e(Effect_`effect')
		mat def results_`group'[`effect',3] = e(se_effect_`effect')
		mat def results_`group'[`effect',4] = `iter'
		}
	forvalues placebo=1(1)3 {
		mat def results_`group'[`placebo'+6,1] = `placebo' * -1
		mat def results_`group'[`placebo'+6,2] = e(Placebo_`placebo')
		mat def results_`group'[`placebo'+6,3] = e(se_placebo_`placebo')
		mat def results_`group'[`placebo'+6,4] = `iter'
		}
	
	local ++iter
	}
	
matrix results = results_sinclair\results_nexstar\results_gray

preserve

clear
svmat results 

ren results1 time
ren results2 estimate
ren results3 estimate_se
ren results4 group
 
g sinclair = group==1
g nexstar = group==2
g gray = group==3

keep if time>=-3&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1
replace time = time - 1	// normalize time counter so that -1 -> last period before tmt changes as in TWFE

g min95 = estimate - 1.96*estimate_se
g max95 = estimate + 1.96*estimate_se

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) xsize(5.5) ysize(4) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ytick(, notick nolabel) ///
		ylabel(-1.5(1.5)3, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/news_ratings_dCdH_DID.pdf, replace
restore


// TRIPLE DIFF

local iter = 1

foreach group in sinclair nexstar gray {
	
	did_multiplegt_dyn 	rating_total_news stationID date station_ownedby_`group'_LMA ///
						, ///
						cluster(dmacode) placebo(3) effects(6) ///
						trends_nonparam(dmacode)
	
	mat def results_`group' = J(9,4,.)
	
	forvalues effect=1(1)6 {
		mat def results_`group'[`effect',1] = `effect'
		mat def results_`group'[`effect',2] = e(Effect_`effect')
		mat def results_`group'[`effect',3] = e(se_effect_`effect')
		mat def results_`group'[`effect',4] = `iter'
		}
	forvalues placebo=1(1)3 {
		mat def results_`group'[`placebo'+6,1] = `placebo' * -1
		mat def results_`group'[`placebo'+6,2] = e(Placebo_`placebo')
		mat def results_`group'[`placebo'+6,3] = e(se_placebo_`placebo')
		mat def results_`group'[`placebo'+6,4] = `iter'
		}
	
	local ++iter
	}
	
matrix results = results_sinclair\results_nexstar\results_gray

preserve

clear
svmat results 

ren results1 time
ren results2 estimate
ren results3 estimate_se
ren results4 group
 
g sinclair = group==1
g nexstar = group==2
g gray = group==3

keep if time>=-3&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1
replace time = time - 1	// normalize time counter so that -1 -> last period before tmt changes as in TWFE

g min95 = estimate - 1.96*estimate_se
g max95 = estimate + 1.96*estimate_se

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) xsize(5.5) ysize(4) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ytick(, notick nolabel) ///
		ylabel(-1.5(1.5)3, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/news_ratings_dCdH_TRIPLEDIFF.pdf, replace
restore


///////////////////////
// CDH WITH CONTROLS //
///////////////////////
						
// DID

local iter = 1

foreach group in sinclair nexstar gray {
	
	did_multiplegt_dyn 	rating_total_news stationID date station_ownedby_`group'_LMA ///
						, ///
						cluster(dmacode) placebo(3) effects(6) ///
						controls(log_duration_news_2010??? log_spend_news_2010??? rating_news_2010???)
	
	mat def results_`group' = J(9,4,.)
	
	forvalues effect=1(1)6 {
		mat def results_`group'[`effect',1] = `effect'
		mat def results_`group'[`effect',2] = e(Effect_`effect')
		mat def results_`group'[`effect',3] = e(se_effect_`effect')
		mat def results_`group'[`effect',4] = `iter'
		}
	forvalues placebo=1(1)3 {
		mat def results_`group'[`placebo'+6,1] = `placebo' * -1
		mat def results_`group'[`placebo'+6,2] = e(Placebo_`placebo')
		mat def results_`group'[`placebo'+6,3] = e(se_placebo_`placebo')
		mat def results_`group'[`placebo'+6,4] = `iter'
		}
	
	local ++iter
	}
	
matrix results = results_sinclair\results_nexstar\results_gray

preserve

clear
svmat results 

ren results1 time
ren results2 estimate
ren results3 estimate_se
ren results4 group
 
g sinclair = group==1
g nexstar = group==2
g gray = group==3

keep if time>=-3&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1
replace time = time - 1	// normalize time counter so that -1 -> last period before tmt changes as in TWFE

g min95 = estimate - 1.96*estimate_se
g max95 = estimate + 1.96*estimate_se

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) xsize(5.5) ysize(4) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ytick(, notick nolabel) ///
		ylabel(-1.5(1.5)3, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/news_ratings_dCdH_DID_controls.pdf, replace
restore

// TRIPLE DIFF

local iter = 1

foreach group in sinclair nexstar gray {
	
	did_multiplegt_dyn 	rating_total_news stationID date station_ownedby_`group'_LMA ///
						, ///
						cluster(dmacode) placebo(3) effects(6) ///
						trends_nonparam(dmacode) ///
						controls(log_duration_news_2010??? log_spend_news_2010??? rating_news_2010???)
				
	
	mat def results_`group' = J(9,4,.)
	
	forvalues effect=1(1)6 {
		mat def results_`group'[`effect',1] = `effect'
		mat def results_`group'[`effect',2] = e(Effect_`effect')
		mat def results_`group'[`effect',3] = e(se_effect_`effect')
		mat def results_`group'[`effect',4] = `iter'
		}
	forvalues placebo=1(1)3 {
		mat def results_`group'[`placebo'+6,1] = `placebo' * -1
		mat def results_`group'[`placebo'+6,2] = e(Placebo_`placebo')
		mat def results_`group'[`placebo'+6,3] = e(se_placebo_`placebo')
		mat def results_`group'[`placebo'+6,4] = `iter'
		}
	
	local ++iter
	}
	
matrix results = results_sinclair\results_nexstar\results_gray

preserve

clear
svmat results 

ren results1 time
ren results2 estimate
ren results3 estimate_se
ren results4 group
 
g sinclair = group==1
g nexstar = group==2
g gray = group==3

keep if time>=-3&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

// cannot estimate placebo - 3 in this case
// HUGE CIs

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1
replace time = time - 1	// normalize time counter so that -1 -> last period before tmt changes as in TWFE

g min95 = estimate - 1.96*estimate_se
g max95 = estimate + 1.96*estimate_se

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) xsize(5.5) ysize(4) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ylabel(-1.5(1.5)3, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/news_ratings_dCdH_TRIPLEDIFF_controls.pdf, replace
restore







//////////////////////////////
//////////////////////////////
// APPENDIX FIGURE F4       //
//////////////////////////////
//////////////////////////////
	
use data/adintel/adintel_clean_updated.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

drop if year==2010
drop if year==2020

g semester=ceil(month/6)

collapse (mean) imp_total_news $station_controls (max) station_ownedby_* (min) date  dmacode, by(stationID year semester)

g log_imp_total_news = log(imp_total_news)

// CREATES ALL THE NECESSARY VARIABLES TO RUN EVENT STUDIES 

// 1. DUMMIES FOR TWFE ES

foreach group in sinclair nexstar gray {
	
	cap drop yearmonth_treated
	bysort stationID: egen yearmonth_treated=min(date/(station_ownedby_`group'_LMA==1))
	format yearmonth_treated %tm

	cap drop t
	g t=date-yearmonth_treated
	tab t, m
	tab t if yearmonth_treated!=612, m

	cap drop t6
	g t6=floor(t/6)
	tab t6, m
	tab t6 if yearmonth_treated!=612, m

	replace t6=-5 if t6<=-5|t6==.
	replace t6=6 if t6>=6

	cap drop `group'_minus* `group'_plus*
	levelsof t6, local(times)
	foreach time in `times' {
	di `time'
		if regexm("`time'","([-])([0-9]*)")==1 {
			g `group'_minus`=regexs(2)'=(t6==`time') 
			}
		else {
			g `group'_plus`time' =(t6==`time') 
			}
		}

	cap drop `group'_yearmonth_treated
	g `group'_yearmonth_treated = yearmonth_treated	
	
			
	}

// 2. VARIABLES FOR dC&dH, CONTROLS

levelsof date, local(dates)
foreach var of varlist $station_controls {
	foreach date in `dates' {
		g `var'`date' = `var' * (date==`date')
		}
	g `var'_lintrend = `var' * date
	}


g todrop = 0
replace todrop = 1 if year(dofm(nexstar_yearmonth_treated))==2019&month(dofm(nexstar_yearmonth_treated))>=7&nexstar_yearmonth_treated!=.
replace todrop = 1 if year(dofm(sinclair_yearmonth_treated))==2019&month(dofm(sinclair_yearmonth_treated))>=7&sinclair_yearmonth_treated!=.
replace todrop = 1 if year(dofm(gray_yearmonth_treated))==2019&month(dofm(gray_yearmonth_treated))>=7&gray_yearmonth_treated!=.


//////////////////
// TWFE 		//
//////////////////

// DID

foreach group in sinclair nexstar gray {
	
	reghdfe log_imp_total_news			`group'_minus5-`group'_minus2 `group'_plus0-`group'_plus6 ///
										if `group'_yearmonth_treated!=612&todrop==0, ///
										absorb(stationID date) cluster(dmacode)

	// saves results									
	preserve
	parmest, fast 
	tempfile `group'
	save ``group'', replace
	restore 
		
	}
	
preserve
clear
use `sinclair'
append using `nexstar'
append using `gray'

keep if regexm(parm,"gray_")==1|regexm(parm,"sinclair_")==1|regexm(parm,"nexstar_")==1

g sinclair = regexm(parm,"sinclair_")
g gray = regexm(parm,"gray_")
g nexstar = regexm(parm,"nexstar_")

g time=regexs(1) if regexm(parm,"([0-9]+)")==1		
destring time, replace	
replace time=time*-1 if regexm(parm,"minus")==1
keep if time>=-5&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ytick(, notick nolabel) xsize(5.5) ysize(4) ///
		ylabel(-0.1(0.1)0.3, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/log_imp_total_news_TWFEsemesters_DID.pdf, replace
restore

// TRIPLE

foreach group in sinclair nexstar gray {
	
	reghdfe log_imp_total_news 			`group'_minus5-`group'_minus2 `group'_plus0-`group'_plus6 ///
										if `group'_yearmonth_treated!=612&todrop==0, ///
										absorb(stationID date##dmacode) cluster(dmacode)

	// saves results									
	preserve
	parmest, fast 
	tempfile `group'
	save ``group'', replace
	restore 
		
	}
	
preserve
clear
use `sinclair'
append using `nexstar'
append using `gray'

keep if regexm(parm,"gray_")==1|regexm(parm,"sinclair_")==1|regexm(parm,"nexstar_")==1

g sinclair = regexm(parm,"sinclair_")
g gray = regexm(parm,"gray_")
g nexstar = regexm(parm,"nexstar_")

g time=regexs(1) if regexm(parm,"([0-9]+)")==1		
destring time, replace	
replace time=time*-1 if regexm(parm,"minus")==1
keep if time>=-5&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=-1 in `maxobs'
replace estimate=0 in `maxobs'
replace min95=0 in `maxobs'
replace max95=0 in `maxobs'		
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ytick(, notick nolabel) xsize(5.5) ysize(4) ///
		ylabel(-0.1(0.1)0.3, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/log_imp_total_news_TWFEsemesters_TRIPLEDIFF.pdf, replace
restore

//////////////////
// CDH	   		//
//////////////////
						
// DID

local iter = 1

foreach group in sinclair nexstar gray {
	
	did_multiplegt_dyn 	log_imp_total_news stationID date station_ownedby_`group'_LMA ///
						, ///
						cluster(dmacode) placebo(3) effects(6) 
	
	mat def results_`group' = J(9,4,.)
	
	forvalues effect=1(1)6 {
		mat def results_`group'[`effect',1] = `effect'
		mat def results_`group'[`effect',2] = e(Effect_`effect')
		mat def results_`group'[`effect',3] = e(se_effect_`effect')
		mat def results_`group'[`effect',4] = `iter'
		}
	forvalues placebo=1(1)3 {
		mat def results_`group'[`placebo'+6,1] = `placebo' * -1
		mat def results_`group'[`placebo'+6,2] = e(Placebo_`placebo')
		mat def results_`group'[`placebo'+6,3] = e(se_placebo_`placebo')
		mat def results_`group'[`placebo'+6,4] = `iter'
		}
	
	local ++iter
	}
	
matrix results = results_sinclair\results_nexstar\results_gray

preserve

clear
svmat results 

ren results1 time
ren results2 estimate
ren results3 estimate_se
ren results4 group
 
g sinclair = group==1
g nexstar = group==2
g gray = group==3

keep if time>=-3&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1
replace time = time - 1	// normalize time counter so that -1 -> last period before tmt changes as in TWFE

g min95 = estimate - 1.96*estimate_se
g max95 = estimate + 1.96*estimate_se

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) xsize(5.5) ysize(4) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ytick(, notick nolabel) ///
		ylabel(-0.1(0.1)0.3, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/log_imp_total_news_dCdH_DID.pdf, replace
restore


// TRIPLE DIFF

local iter = 1

foreach group in sinclair nexstar gray {
	
	did_multiplegt_dyn 	log_imp_total_news stationID date station_ownedby_`group'_LMA ///
						, ///
						cluster(dmacode) placebo(3) effects(6) ///
						trends_nonparam(dmacode)
	
	mat def results_`group' = J(9,4,.)
	
	forvalues effect=1(1)6 {
		mat def results_`group'[`effect',1] = `effect'
		mat def results_`group'[`effect',2] = e(Effect_`effect')
		mat def results_`group'[`effect',3] = e(se_effect_`effect')
		mat def results_`group'[`effect',4] = `iter'
		}
	forvalues placebo=1(1)3 {
		mat def results_`group'[`placebo'+6,1] = `placebo' * -1
		mat def results_`group'[`placebo'+6,2] = e(Placebo_`placebo')
		mat def results_`group'[`placebo'+6,3] = e(se_placebo_`placebo')
		mat def results_`group'[`placebo'+6,4] = `iter'
		}
	
	local ++iter
	}
	
matrix results = results_sinclair\results_nexstar\results_gray

preserve

clear
svmat results 

ren results1 time
ren results2 estimate
ren results3 estimate_se
ren results4 group
 
g sinclair = group==1
g nexstar = group==2
g gray = group==3

keep if time>=-3&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1
replace time = time - 1	// normalize time counter so that -1 -> last period before tmt changes as in TWFE

g min95 = estimate - 1.96*estimate_se
g max95 = estimate + 1.96*estimate_se

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) xsize(5.5) ysize(4) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ytick(, notick nolabel) ///
		ylabel(-0.1(0.1)0.3, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/log_imp_total_news_dCdH_TRIPLEDIFF.pdf, replace
restore


///////////////////////
// CDH WITH CONTROLS //
///////////////////////
						
// DID

local iter = 1

foreach group in sinclair nexstar gray {
	
	did_multiplegt_dyn 	log_imp_total_news stationID date station_ownedby_`group'_LMA ///
						, ///
						cluster(dmacode) placebo(3) effects(6) ///
						controls(log_duration_news_2010??? log_spend_news_2010??? rating_news_2010???)
	
	mat def results_`group' = J(9,4,.)
	
	forvalues effect=1(1)6 {
		mat def results_`group'[`effect',1] = `effect'
		mat def results_`group'[`effect',2] = e(Effect_`effect')
		mat def results_`group'[`effect',3] = e(se_effect_`effect')
		mat def results_`group'[`effect',4] = `iter'
		}
	forvalues placebo=1(1)3 {
		mat def results_`group'[`placebo'+6,1] = `placebo' * -1
		mat def results_`group'[`placebo'+6,2] = e(Placebo_`placebo')
		mat def results_`group'[`placebo'+6,3] = e(se_placebo_`placebo')
		mat def results_`group'[`placebo'+6,4] = `iter'
		}
	
	local ++iter
	}
	
matrix results = results_sinclair\results_nexstar\results_gray

preserve

clear
svmat results 

ren results1 time
ren results2 estimate
ren results3 estimate_se
ren results4 group
 
g sinclair = group==1
g nexstar = group==2
g gray = group==3

keep if time>=-3&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1
replace time = time - 1	// normalize time counter so that -1 -> last period before tmt changes as in TWFE

g min95 = estimate - 1.96*estimate_se
g max95 = estimate + 1.96*estimate_se

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) xsize(5.5) ysize(4) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ytick(, notick nolabel) ///
		ylabel(-0.1(0.1)0.3, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/log_imp_total_news_dCdH_DID_controls.pdf, replace
restore

// TRIPLE DIFF

local iter = 1

foreach group in sinclair nexstar gray {
	
	did_multiplegt_dyn 	log_imp_total_news stationID date station_ownedby_`group'_LMA ///
						, ///
						cluster(dmacode) placebo(3) effects(6) ///
						trends_nonparam(dmacode) ///
						controls(log_duration_news_2010??? log_spend_news_2010??? rating_news_2010???)
				
	
	mat def results_`group' = J(9,4,.)
	
	forvalues effect=1(1)6 {
		mat def results_`group'[`effect',1] = `effect'
		mat def results_`group'[`effect',2] = e(Effect_`effect')
		mat def results_`group'[`effect',3] = e(se_effect_`effect')
		mat def results_`group'[`effect',4] = `iter'
		}
	forvalues placebo=1(1)3 {
		mat def results_`group'[`placebo'+6,1] = `placebo' * -1
		mat def results_`group'[`placebo'+6,2] = e(Placebo_`placebo')
		mat def results_`group'[`placebo'+6,3] = e(se_placebo_`placebo')
		mat def results_`group'[`placebo'+6,4] = `iter'
		}
	
	local ++iter
	}
	
matrix results = results_sinclair\results_nexstar\results_gray

preserve

clear
svmat results 

ren results1 time
ren results2 estimate
ren results3 estimate_se
ren results4 group
 
g sinclair = group==1
g nexstar = group==2
g gray = group==3

keep if time>=-3&time<=6

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 1 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 1 in `maxobs'
replace nexstar = 0 in `maxobs'

qui count
loc maxobs=`r(N)'+1
set obs `maxobs'
replace time=0 in `maxobs'
replace estimate=0 in `maxobs'
replace estimate_se=0 in `maxobs'
replace sinclair = 0 in `maxobs'
replace gray = 0 in `maxobs'
replace nexstar = 1 in `maxobs'

// cannot estimate placebo - 3 in this case
// HUGE CIs

replace time = time + 0.15 if gray==1
replace time = time - 0.15 if sinclair==1
replace time = time - 1	// normalize time counter so that -1 -> last period before tmt changes as in TWFE

g min95 = estimate - 1.96*estimate_se
g max95 = estimate + 1.96*estimate_se

sort time 
	
twoway  (rspike max95 min95  time if gray==1, lc(gs11) lwidth(medium)) ///
		(rspike max95 min95  time if nexstar==1, lc("43 176 126") lwidth(medium)) ///
		(rspike max95 min95  time if sinclair==1,  lc("72 34 115") lwidth(medium)) ///
		(line estimate time if gray==1, lc(gs11) lp(dash)) ///
		(line estimate time if nexstar==1, lc("43 176 126") lp(dash)) ///
		(line estimate time if sinclair==1, lc("72 34 115") lp(dash)) ///
		(scatter estimate time if gray==1, mc(gs11) mfcolor(white) msymbol(square) msize(medium)) ///
		(scatter estimate time if nexstar==1, mc("43 176 126") mfcolor(white) msize(medium) msymbol(diamond)) ///
		(scatter estimate time if sinclair==1, mc("72 34 115") mfcolor(white) msize(medium) msymbol(circle) ///
		graphr(c(white)) ///
		bgcolor(white)  ///
		title("", c(black)) xsize(5.5) ysize(4) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		ylabel(, glc(gs12) glp(dot) format(%4.1f)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/log_imp_total_news_dCdH_TRIPLEDIFF_controls.pdf, replace
restore

