///////////////////////////////////////////////////
// CREATES THE FIGURES IN THE APPENDIX           //
///////////////////////////////////////////////////

clear all
	
	
	
///////////////////////		
///////////////////////
// APPENDIX FIGURE 1 //
///////////////////////
///////////////////////		

use "${PATH}/data/acquisitions/acquisition_panel_dma_top3_FINAL.dta", clear

ren dma dma_old
ren dma_kelseybia dma
replace dma=upper(dma)
replace dma="TAMPA-ST.PETERSBURG-SARASOTA, FL" if dma=="TAMPA-ST PETERSBURG-SARASOTA, FL"

merge m:1 dma using "${PATH}/data/dma_dmaID_xwalk.dta"

keep if _m==3
drop _m

keep if month==12

bysort dmaID: egen treatment_year = min(year/(ownedby_congl_LMA==1))
replace treatment_year=2022 if treatment_year==.

bysort dmaID: egen treatment_year_sinclair = min(year/(ownedby_sinclair_LMA==1))
replace treatment_year_sinclair=2022 if treatment_year_sinclair==.

bysort dmaID: egen treatment_year_gray = min(year/(ownedby_gray_LMA==1))
replace treatment_year_gray=2022 if treatment_year_gray==.

bysort dmaID: egen treatment_year_nexstar = min(year/(ownedby_nexstar_LMA==1))
replace treatment_year_nexstar=2022 if treatment_year_nexstar==.

egen tag=tag(dmaID)
keep if tag==1

merge 1:1 dmaID using "${PATH}/data/DMA_2008_database.dta"
drop _m
		
colorpalette viridis, n(12)   
local colors  "`r(p3)'" "`r(p5)'" "`r(p6)'" "`r(p7)'" "`r(p8)'" "`r(p9)'" "`r(p10)'" "`r(p11)'"   "`r(p12)'"   

spmap treatment_year using "${PATH}/data/DMA_2008_coords.dta", id(_ID) ///
		clmethod(custom)  clbreaks(2009.5 2010.5 2011.5 2012.5 2013.5 2014.5 2015.5 2016.5 2017.5 2019.5 2022.5) ///
		fcolor("`colors'") ///
		legend(cols(1) size(*0.75) colfirst bmargin(none) label(2 "Always treated") label(3 "2011") ///
		label(4 "2012") label(5 "2013") label(6 "2014") label(7 "2015") label(8 "2016") ///
		label(9 "2017") label(10 "2019") label(11 "Never treated"))
graph export "${PATH}/figures/map.pdf", replace
graph export "${PATH}/figures/map.png", replace

spmap treatment_year_sinclair using "${PATH}/data/DMA_2008_coords.dta", id(_ID) ///
		clmethod(custom)  clbreaks(2009.5 2010.5 2011.5 2012.5 2013.5 2014.5 2015.5 2016.5 2017.5 2019.5 2022.5) ///
		fcolor("`colors'") ///
		legend(cols(1) size(*0.75) colfirst bmargin(none) label(2 "Always Treated") label(3 "2011") ///
		label(4 "2012") label(5 "2013") label(6 "2014") label(7 "2015") label(8 "2016") ///
		label(9 "2017") label(10 "2019") label(11 "Never Treated"))
graph export "${PATH}/figures/map_sinclair.pdf", replace
graph export "${PATH}/figures/map_sinclair.png", replace
		
colorpalette viridis, n(12)   
local colors  "`r(p3)'" "`r(p5)'" "`r(p6)'" "`r(p7)'" "`r(p8)'" "`r(p9)'" "`r(p10)'" "`r(p11)'"   "`r(p12)'"   

spmap treatment_year_gray using "${PATH}/data/DMA_2008_coords.dta", id(_ID) ///
		clmethod(custom)  clbreaks(2009.5 2010.5 2011.5 2012.5 2013.5 2014.5 2015.5 2016.5 2017.5 2019.5 2022.5) ///
		fcolor("`colors'") ///
		legend(cols(1) size(*0.75) colfirst bmargin(none) label(2 "Always Treated") label(3 "2011") ///
		label(4 "2012") label(5 "2013") label(6 "2014") label(7 "2015") label(8 "2016") ///
		label(9 "2017") label(10 "2019") label(11 "Never Treated"))
graph export "${PATH}/figures/map_gray.pdf", replace
graph export "${PATH}/figures/map_gray.png", replace

colorpalette viridis, n(12)   
local colors  "`r(p3)'" "`r(p5)'" "`r(p6)'" "`r(p7)'" "`r(p8)'" "`r(p9)'" "`r(p10)'" "`r(p11)'"   "`r(p12)'"   
		
spmap treatment_year_nexstar using "${PATH}/data/DMA_2008_coords.dta", id(_ID) ///
		clmethod(custom)  clbreaks(2009.5 2010.5 2011.5 2012.5 2013.5 2014.5 2015.5 2016.5 2017.5 2019.5 2022.5) ///
		fcolor("`colors'") ///
		legend(cols(1) size(*0.75) colfirst bmargin(none) label(2 "Always Treated") label(3 "2011") ///
		label(4 "2012") label(5 "2013") label(6 "2014") label(7 "2015") label(8 "2016") ///
		label(9 "2017") label(10 "2019") label(11 "Never Treated"))
graph export "${PATH}/figures/map_nexstar.pdf", replace
graph export "${PATH}/figures/map_nexstar.png", replace




///////////////////////		
///////////////////////
// APPENDIX FIGURE 2 //
///////////////////////
///////////////////////		

// CONTENT VARIABLES

use data/harmony/content_cleaned.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

cap drop tag
egen tag=tag(stationID)


// MENTIONS, DENSITY
cap drop stationID_FEs
reghdfe mention_place_pershow, absorb(stationID_FEs = stationID date) cluster(dmacode)

preserve
keep if tag==1

kdensity 	stationID_FEs,  gen(x fx)	
su stationID_FEs, d
local p50_format: di %4.2f `r(p50)'

tw 	line fx x, 	lc(gs3) mc(gs3) mfcolor(white) msymbol(circle) msize(medium) ///
							graphr(c(white)) ///
							bgcolor(white) ///
							title("", c(black)) ///
							xline(`r(p50)', lc(black) lwidth(vthin) lp(solid)) ///
							text(0.07 `r(p50)' "Median = `p50_format'", size(small) placement(3) margin(small)) ///
							xlabel(, grid valuel glc(gs12) glp(dot)) ///
							ytick(, notick nolabel) ///
							ylabel(, glc(gs12) glp(dot) format(%04.2f)) ///
							ytitle("Density", c(black)) ///
							xtitle("Mentions/show fixed effects", c(black)) xsize(5.5) ysize(4) ///
							legend(off)
graph export "${PATH}/figures/descriptives_mentions_density.pdf", replace
restore

collapse 	(median) median = mention_place_pershow ///
			(p25) p25 = mention_place_pershow ///
			(p75) p75 = mention_place_pershow, ///
			by(date)

// MENTIONS, OVER TIME
tw 	rarea p25 p75 date, 	color(gs12%30)  || ///
	connected median date, 	lc(gs3) mc(gs3) mfcolor(white) msymbol(circle) msize(medium) ///
							graphr(c(white)) ///
							bgcolor(white) ///
							title("", c(black)) ///
							xlabel(612(12)719, grid valuel glc(gs12) glp(dot) format(%tmCY)) ///
							ytick(, notick nolabel) ///
							ylabel(0(5)20, glc(gs12) glp(dot)) ///
							ytitle("Mentions/show", c(black)) ///
							xtitle("", c(black)) xsize(5.5) ysize(4) ///
							legend(off)
graph export "${PATH}/figures/descriptives_mentions_overtime.pdf", replace


//////////////////////////		
//////////////////////////
// APPENDIX FIGURE 3, 4 //
//////////////////////////
//////////////////////////

// ADVERTISING VARIABLES

use data/adintel/adintel_clean_updated.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

drop if year==2010
drop if year==2020

replace spend_perHH_news = spend_perHH_news/1000

cap drop tag
egen tag=tag(stationID)

// DURATION, DENSITY
cap drop stationID_FEs
reghdfe duration_perHH_news, absorb(stationID_FEs = stationID date) cluster(dmacode)

preserve

keep if tag==1

cap drop x fx
kdensity 	stationID_FEs,  gen(x fx)	
su stationID_FEs, d
local p50_format: di %4.2f `r(p50)'

tw 	line fx x, 	lc(gs3) mc(gs3) mfcolor(white) msymbol(circle) msize(medium) ///
							graphr(c(white)) ///
							bgcolor(white) ///
							title("", c(black)) ///
							xlabel(, grid valuel glc(gs12) glp(dot) ) ///
							xline(`r(p50)', lc(black) lwidth(vthin) lp(solid)) ///
							text(0.00375 `r(p50)' "Median = `p50_format'", size(small) placement(3) margin(small)) ///
							ytick(, notick nolabel) ///
							ylabel(, glc(gs12) glp(dot) format(%9.3f)) ///
							ytitle("Density", c(black)) ///
							xtitle("Duration per half-hour of local news fixed effects", c(black)) xsize(5.5) ysize(4) ///
							legend(off)
graph export "${PATH}/figures/descriptives_adsduration_density.pdf", replace
restore

// REVENUE, DENSITY

cap drop stationID_FEs
reghdfe spend_perHH_news, absorb(stationID_FEs = stationID date) cluster(dmacode)

preserve 

keep if tag==1

cap drop x fx
kdensity 	stationID_FEs, nograph gen(x fx)	
su stationID_FEs, d
local p50_format: di %4.2f `r(p50)'

tw 	line fx x, 	lc(gs3) mc(gs3) mfcolor(white) msymbol(circle) msize(medium) ///
							graphr(c(white)) ///
							bgcolor(white) ///
							title("", c(black)) ///
							xlabel(, grid valuel glc(gs12) glp(dot) ) ///
							ytick(, notick nolabel) ///
							xline(`r(p50)', lc(black) lwidth(vthin) lp(solid)) ///
							text(0.095 `r(p50)' "Median = `p50_format'", size(small) placement(3) margin(small)) ///
							ylabel(, glc(gs12) glp(dot) format(%9.2f)) ///
							ytitle("Density", c(black)) ///
							xtitle("Revenue per half-hour of local news fixed effects (1000s)", c(black)) xsize(5.5) ysize(4) ///
							legend(off)
graph export "${PATH}/figures/descriptives_adsrevenue_density.pdf", replace
restore

collapse 	(median) median_duration = duration_perHH_news median_revenue = spend_perHH_news ///
			(p25) p25_duration = duration_perHH_news p25_revenue = spend_perHH_news ///
			(p75) p75_duration = duration_perHH_news p75_revenue = spend_perHH_news, ///
			by(date)

// DURATION, OVER TIME
tw 	rarea p25_duration p75_duration date, 	color(gs12%30)  || ///
	connected median_duration date, 	lc(gs3) mc(gs3) mfcolor(white) msymbol(circle) msize(medium) ///
										graphr(c(white)) ///
										bgcolor(white) ///
										title("", c(black)) ///
										xlabel(612(12)719, grid valuel glc(gs12) glp(dot) format(%tmCY)) ///
										ytick(, notick nolabel) ///
										ylabel(0(200)1000, glc(gs12) glp(dot)) ///
										ytitle("Duration per half-hour of local news", c(black)) ///
										xtitle("", c(black)) xsize(5.5) ysize(4) ///
										legend(off)
graph export "${PATH}/figures/descriptives_adsduration_overtime.pdf", replace

	
// REVENUE, OVER TIME
tw 	rarea p25_revenue p75_revenue date, 	color(gs12%30)  || ///
	connected median_revenue date, 	lc(gs3) mc(gs3) mfcolor(white) msymbol(circle) msize(medium) ///
										graphr(c(white)) ///
										bgcolor(white) ///
										title("", c(black)) ///
										xlabel(612(12)719, grid valuel glc(gs12) glp(dot) format(%tmCY)) ///
										ytick(, notick nolabel) ///
										ylabel(0(2.5)15, glc(gs12) glp(dot) format(%9.1f)) ///
										ytitle("Revenue per half-hour of local news (1000s)", c(black)) ///
										xtitle("", c(black)) xsize(5.5) ysize(4) ///
										legend(off)
graph export "${PATH}/figures/descriptives_adsrevenue_overtime.pdf", replace

	
//////////////////////////
//////////////////////////
// APPENDIX FIGURE 5, 6 //
//////////////////////////
//////////////////////////		
		
// RATINGS VARIABLES

use data/adintel/adintel_clean_updated.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

drop if year==2010
drop if year==2020

replace imp_total_news = imp_total_news/1000

cap drop tag
egen tag=tag(stationID)

// RATINGS, DENSITY
cap drop stationID_FEs
reghdfe rating_total_news, absorb(stationID_FEs = stationID date) cluster(dmacode)

preserve 

keep if tag==1

cap drop x fx
kdensity 	stationID_FEs, nograph gen(x fx)	
su stationID_FEs, d
local p50_format: di %4.2f `r(p50)'

tw 	line fx x, 	lc(gs3) mc(gs3) mfcolor(white) msymbol(circle) msize(medium) ///
							graphr(c(white)) ///
							bgcolor(white) ///
							title("", c(black)) ///
							xlabel(-5(5)20, grid valuel glc(gs12) glp(dot) ) ///
							xline(`r(p50)', lc(black) lwidth(vthin) lp(solid)) ///
							text(0.15 `r(p50)' "Median = `p50_format'", size(small) placement(3) margin(small)) ///
							ytick(, notick nolabel) ///
							ylabel(0(0.05)0.15, glc(gs12) glp(dot) format(%9.2f)) ///
							ytitle("Density", c(black)) ///
							xtitle("News ratings fixed effects", c(black)) xsize(5.5) ysize(4) ///
							legend(off)
graph export "${PATH}/figures/descriptives_ratings_density.pdf", replace
restore

// IMPRESSIONS, DENSITY
cap drop stationID_FEs
reghdfe imp_total_news, absorb(stationID_FEs = stationID date) cluster(dmacode)

preserve 

keep if tag==1

cap drop x fx
kdensity 	stationID_FEs, nograph gen(x fx)	
su stationID_FEs, d
local p50_format: di %4.2f `r(p50)'

tw 	line fx x, 	lc(gs3) mc(gs3) mfcolor(white) msymbol(circle) msize(medium) ///
							graphr(c(white)) ///
							bgcolor(white) ///
							title("", c(black)) ///
							xline(`r(p50)', lc(black) lwidth(vthin) lp(solid)) ///
							text(0.025 `r(p50)' "Median = `p50_format'", size(small) placement(3) margin(small)) ///
							xlabel(-100(100)400, grid valuel glc(gs12) glp(dot) ) ///
							ytick(, notick nolabel) ///
							ylabel(, glc(gs12) glp(dot) format(%9.2f)) ///
							ytitle("Density", c(black)) ///
							xtitle("Impressions fixed effects (1000s)", c(black)) xsize(5.5) ysize(4) ///
							legend(off)
graph export "${PATH}/figures/descriptives_impressions_density.pdf", replace
restore

collapse 	(median) median_ratings = rating_total_news median_imp = imp_total_news ///
			(p25) p25_ratings = rating_total_news p25_imp = imp_total_news ///
			(p75) p75_ratings = rating_total_news p75_imp = imp_total_news, ///
			by(date)

// RATINGS, OVER TIME
tw 	rarea p25_ratings p75_ratings date  if date>648, 	color(gs12%30)  || ///
	connected median_ratings date  if date>648, lc(gs3) mc(gs3) mfcolor(white) msymbol(circle) msize(medium) || ///
	rarea p25_ratings p75_ratings date  if date<643, 	color(gs12%30)  || ///
	connected median_ratings date  if date<643, lc(gs3) mc(gs3) mfcolor(white) msymbol(circle) msize(medium) ///
										graphr(c(white)) ///
										bgcolor(white) ///
										title("", c(black)) ///
										xlabel(612(12)719, grid valuel glc(gs12) glp(dot) format(%tmCY)) ///
										ytick(, notick nolabel) ///
										ylabel(0(2)8, glc(gs12) glp(dot)) ///
										ytitle("News ratings", c(black)) ///
										xtitle("", c(black)) xsize(5.5) ysize(4) ///
										legend(off)
graph export "${PATH}/figures/descriptives_ratings_overtime.pdf", replace
	
// IMPRESSIONS, OVER TIME
tw 	rarea p25_imp p75_imp date  if date>648, 	color(gs12%30)  || ///
	connected median_imp date  if date>648, lc(gs3) mc(gs3) mfcolor(white) msymbol(circle) msize(medium) || ///
	rarea p25_imp p75_imp date  if date<643, 	color(gs12%30)  || ///
	connected median_imp date  if date<643, lc(gs3) mc(gs3) mfcolor(white) msymbol(circle) msize(medium) ///
										graphr(c(white)) ///
										bgcolor(white) ///
										title("", c(black)) ///
										xlabel(612(12)719, grid valuel glc(gs12) glp(dot) format(%tmCY)) ///
										ytick(, notick nolabel) ///
										ylabel(0(10)50, glc(gs12) glp(dot)) ///
										ytitle("Impressions (1000s)", c(black)) ///
										xtitle("", c(black)) xsize(5.5) ysize(4) ///
										legend(off)
graph export "${PATH}/figures/descriptives_impressions_overtime.pdf", replace
			
		
///////////////////////		
///////////////////////
// APPENDIX FIGURE 7 //
///////////////////////		
///////////////////////		

use data/adintel/adintel_clean_updated.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

drop if year==2010
drop if year==2020

// CREATES ES DUMMIES                   

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
	replace t6=6 if t6>=6 & t6!=.

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
	
	format %tm `group'_yearmonth_treated
			
	}

cap drop tag
egen tag=tag(stationID)	

drop if year(dofm(nexstar_yearmonth_treated))==2019&month(dofm(nexstar_yearmonth_treated))>=7&nexstar_yearmonth_treated!=.
drop if year(dofm(sinclair_yearmonth_treated))==2019&month(dofm(sinclair_yearmonth_treated))>=7&sinclair_yearmonth_treated!=.
drop if year(dofm(gray_yearmonth_treated))==2019&month(dofm(gray_yearmonth_treated))>=7&gray_yearmonth_treated!=.


// DIFF-IN-DIFF

reghdfe log_spend_perHH_news 		sinclair_minus5-sinclair_minus2 sinclair_plus0-sinclair_plus6 ///
									gray_minus5-gray_minus2 gray_plus0-gray_plus6 ///
									nexstar_minus5-nexstar_minus2 nexstar_plus0-nexstar_plus6 ///
									if gray_yearmonth_treated!=612&sinclair_yearmonth_treated!=612&nexstar_yearmonth_treated!=612, ///
									absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)
	
preserve
parmest, fast 

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
		bgcolor(white) xsize(5.5) ysize(4) ///
		title("", c(black)) ///
		xlabel(-4(1)8, grid valuel glc(gs12) glp(dot)) ///
		ytick(, notick nolabel) ///
		xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
		xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
		yline(0, lc(black) lwidth(vthin) lp(solid)) ///
		ylabel(-0.3(0.1)0.4, glc(gs12) glp(dot) format(%4.1f)) ///
		ytitle("Coefficient estimates, 95% CI", c(black)) ///
		xtitle("Semesters since/to acquisition", c(black)) ///
		legend(on order(9 8 7) ring(0) col(3) pos(7) region(lc(white) fcolor(white))   ///
		label(8 "Nexstar") ///
		label(7 "Gray") ///
		label(9 "Sinclair") ///
		))
graph export figures/log_spending_DID_bygroup.pdf, replace
restore

// TRIPLE DIFF

reghdfe log_spend_perHH_news 		sinclair_minus5-sinclair_minus2 sinclair_plus0-sinclair_plus6 ///
									gray_minus5-gray_minus2 gray_plus0-gray_plus6 ///
									nexstar_minus5-nexstar_minus2 nexstar_plus0-nexstar_plus6 ///
									if gray_yearmonth_treated!=612&sinclair_yearmonth_treated!=612&nexstar_yearmonth_treated!=612, ///
									absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
	
preserve
parmest, fast 

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
		bgcolor(white) xsize(5.5) ysize(4) ///
		title("", c(black)) ///
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
graph export figures/log_spending_TRIPLEDID_bygroup.pdf, replace
restore


			
		
///////////////////////		
///////////////////////
// APPENDIX FIGURE 8 //
///////////////////////		
///////////////////////	

use data/adintel/adintel_clean_updated.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

drop if year==2010
drop if year==2020


// CREATES ES DUMMIES                   

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
	replace t6=6 if t6>=6 & t6 !=.

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
	
	format %tm `group'_yearmonth_treated
			
	}

cap drop tag
egen tag=tag(stationID)	

drop if year(dofm(nexstar_yearmonth_treated))==2019&month(dofm(nexstar_yearmonth_treated))>=7&nexstar_yearmonth_treated!=.
drop if year(dofm(sinclair_yearmonth_treated))==2019&month(dofm(sinclair_yearmonth_treated))>=7&sinclair_yearmonth_treated!=.
drop if year(dofm(gray_yearmonth_treated))==2019&month(dofm(gray_yearmonth_treated))>=7&gray_yearmonth_treated!=.


// DIFF-IN-DIFF
	
reghdfe log_imp_total_news			sinclair_minus5-sinclair_minus2 sinclair_plus0-sinclair_plus6 ///
									gray_minus5-gray_minus2 gray_plus0-gray_plus6 ///
									nexstar_minus5-nexstar_minus2 nexstar_plus0-nexstar_plus6 ///
									if gray_yearmonth_treated!=612&sinclair_yearmonth_treated!=612&nexstar_yearmonth_treated!=612, ///
									absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)
	
preserve
parmest, fast 

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
		bgcolor(white) xsize(5.5) ysize(4) ///
		title("", c(black)) ///
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
graph export figures/log_imp_total_news_DID_bygroup.pdf, replace

restore

// TRIPLE

reghdfe log_imp_total_news			sinclair_minus5-sinclair_minus2 sinclair_plus0-sinclair_plus6 ///
									gray_minus5-gray_minus2 gray_plus0-gray_plus6 ///
									nexstar_minus5-nexstar_minus2 nexstar_plus0-nexstar_plus6 ///
									if gray_yearmonth_treated!=612&sinclair_yearmonth_treated!=612&nexstar_yearmonth_treated!=612, ///
									absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
	
preserve
parmest, fast 

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
		bgcolor(white) xsize(5.5) ysize(4) ///
		title("", c(black)) ///
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
graph export figures/log_imp_total_news_TRIPLEDIFF_bygroup.pdf, replace

restore



















		