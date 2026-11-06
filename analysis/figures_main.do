///////////////////////////////////////////////////
// CREATES FIGURES IN THE MAIN BODY OF THE PAPER //
///////////////////////////////////////////////////

clear all

//////////////
//////////////
// FIGURE 1 //
//////////////
//////////////

// PANEL (A)

use "${PATH}/data/acquisitions/acquisition_panel_station_top3_FINAL.dta", clear

unique stationID
// 763

collapse (sum) station_ownedby_*_LMA , by(date)

tw  (line station_ownedby_gray_LMA date,     lc(gs10)  lw(medthick) lp(shortdash)) ///
    (line station_ownedby_nexstar_LMA date,  lc(gs6)   lw(medthick) lp(longdash))  ///
    (line station_ownedby_sinclair_LMA date, lc(black) lw(medthick) lp(solid)),    ///
    title("", color(black)) ///
    graphregion(color(white)) bgcolor(white) ///
    ytitle("Number of stations owned") ///
    xtitle("") xsize(5.5) ysize(4) ///
    xline(683.5, lc(gs15%50) lwidth(vvthick) lp(solid)) ///
    text(7.5 683.5 "Nexstar acquires" "Media General", size(small)) ///
    xline(707.5, lc(gs15%50) lwidth(vvthick) lp(solid)) ///
    text(7.5 707.5 "Gray acquires" "Raycom", size(small)) ///
    xlabel(600(12)730, valuelabel grid glc(gs12) glp(dot) format(%tmCY)) ///
    ylabel(0(20)125, grid valuel glc(gs12) glp(dot)) ///
    legend(on order(3 2 1) ring(0) col(1) pos(11) region(lc(white) fcolor(none)) ///
	symy(1) symx(10) textw(15) forces ///
	label(1 "Gray") label(2 "Nexstar") label(3 "Sinclair"))
graph export "${PATH}/figures/ownership_over_time_bygroup_top3.pdf", replace

// PANEL (B)

use data/adintel/adintel_clean_updated.dta, clear

drop if hh_total==.

cap drop tag
egen tag=tag(dmacode date)
keep if tag==1

keep dmacode date hh_total 

tempfile tv_hhs
save `tv_hhs'

use "${PATH}/data/acquisitions/acquisition_panel_dma_top3_FINAL.dta", clear

merge 1:1 dmacode date using  `tv_hhs'

//     Result                      Number of obs
//     -----------------------------------------
//     Not matched                           217
//         from master                       217  (_merge==1)
//         from using                          0  (_merge==2)
//
//     Matched                            26,975  (_merge==3)
//     -----------------------------------------

tab date if _m==1 // mostly driven by jan 2010

tab dma if _m==1&year>2010 // this is driven by missing data in adintel

//                         dma |      Freq.     Percent        Cum.
// ----------------------------+-----------------------------------
//     COLUMBIA-JEFFERSON CITY |          2        5.13        5.13
//                    GLENDIVE |         31       79.49       84.62 no conglomerate owned-stations
//                HARRISONBURG |          1        2.56       87.18
//                  JACKSON TN |          1        2.56       89.74
//                LAKE CHARLES |          2        5.13       94.87
//                 PANAMA CITY |          2        5.13      100.00
// ----------------------------+-----------------------------------
//                       Total |         39      100.00

bysort dmacode (date): ipolate hh_total date, generate(temp) epolate
drop hh_total
ren temp hh_total

mdesc hh_total

foreach group in sinclair nexstar gray {
	
	gen hh_total_`group' = hh_total * ownedby_`group'_LMA
	
	}

collapse (sum) hh_total_*, by(date)

foreach group in sinclair nexstar gray {
	
	replace hh_total_`group' = hh_total_`group' / 1000000
	
	}

tw  (line hh_total_gray date,     lc(gs10)  lw(medthick) lp(shortdash)) ///
    (line hh_total_nexstar date,  lc(gs6)   lw(medthick) lp(longdash))  ///
    (line hh_total_sinclair date, lc(black) lw(medthick) lp(solid)),    ///
    title("", color(black)) ///
    graphregion(color(white)) bgcolor(white) ///
    ytitle("TV households (millions)") ///
    xtitle("") xsize(5.5) ysize(4) ///
    xline(683.5, lc(gs15%50) lwidth(vvthick) lp(solid)) ///
    text(5 683.5 "Nexstar acquires" "Media General", size(small)) ///
    xline(707.5, lc(gs15%50) lwidth(vvthick) lp(solid)) ///
    text(5 707.5 "Gray acquires" "Raycom", size(small)) ///
    xlabel(600(12)730, valuelabel grid glc(gs12) glp(dot) format(%tmCY)) ///
    ylabel(0(10)60, grid valuel glc(gs12) glp(dot)) ///
    legend(on order(3 2 1) ring(0) col(1) pos(11) region(lc(white) fcolor(none)) ///
	symy(1) symx(10) textw(15) forces ///
	label(1 "Gray") label(2 "Nexstar") label(3 "Sinclair"))	
graph export "${PATH}/figures/populationreached_over_time_bygroup_top3.pdf", replace




//////////////
//////////////
// FIGURE 2 //
//////////////
//////////////

use data/harmony/content_cleaned.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

cap drop tag
egen tag=tag(stationID)								

// CREATES ES DUMMIES                   

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
	format `group'_yearmonth_treated %tm
			
	}

egen tag=tag(stationID)	

drop if year(dofm(nexstar_yearmonth_treated))==2019&month(dofm(nexstar_yearmonth_treated))>=7&nexstar_yearmonth_treated!=.
drop if year(dofm(sinclair_yearmonth_treated))==2019&month(dofm(sinclair_yearmonth_treated))>=7&sinclair_yearmonth_treated!=.
drop if year(dofm(gray_yearmonth_treated))==2019&month(dofm(gray_yearmonth_treated))>=7&gray_yearmonth_treated!=.
		
// DIFF-IN-DIFF

reghdfe mention_place_pershow 		sinclair_minus5-sinclair_minus2 sinclair_plus0-sinclair_plus6 ///
									gray_minus5-gray_minus2 gray_plus0-gray_plus6 ///
									nexstar_minus5-nexstar_minus2 nexstar_plus0-nexstar_plus6 ///
									if gray_yearmonth_treated!=636&sinclair_yearmonth_treated!=636&nexstar_yearmonth_treated!=636, ///
									absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)
									

unique stationID if e(sample)==1									
									
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
	
twoway  (rspike max95 min95 time if gray==1,     lc(gs10)  lwidth(medium)) ///
        (rspike max95 min95 time if nexstar==1,  lc(gs6)   lwidth(medium)) ///
        (rspike max95 min95 time if sinclair==1, lc(black) lwidth(medium)) ///
        (connected estimate time if gray==1,     lc(gs10)  lp(shortdash) mc(gs10)  mfcolor(white) msize(medium) msymbol(square)) ///
        (connected estimate time if nexstar==1,  lc(gs6)   lp(longdash) mc(gs6)   mfcolor(white) msize(medium) msymbol(diamond)) ///
        (connected estimate time if sinclair==1, lc(black) lp(solid) mc(black) mfcolor(white) msize(medium) msymbol(circle)), ///
        graphr(c(white)) ///
        bgcolor(white) xsize(5.5) ysize(4) ///
        title("", c(black)) ///
        xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
        xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
        ytick(, notick nolabel) ///
        ylabel(-7.5(2.5)5, glc(gs12) glp(dot) format(%4.1f)) ///
        yline(0, lc(black) lwidth(vthin) lp(solid)) ///
        ytitle("Coefficient estimates, 95% CI", c(black)) ///
        xtitle("Semesters since/to acquisition", c(black)) ///
        legend(on order(6 5 4) ring(0) col(3) pos(7) region(lc(white) fcolor(white)) symx(8) ///
        label(4 "Gray") label(5 "Nexstar") label(6 "Sinclair"))
graph export figures/mention_place_pershow_DID_bygroup.pdf, replace
restore

// TRIPLE

reghdfe mention_place_pershow 		sinclair_minus5-sinclair_minus2 sinclair_plus0-sinclair_plus6 ///
									gray_minus5-gray_minus2 gray_plus0-gray_plus6 ///
									nexstar_minus5-nexstar_minus2 nexstar_plus0-nexstar_plus6 ///
									if gray_yearmonth_treated!=636&sinclair_yearmonth_treated!=636&nexstar_yearmonth_treated!=636, ///
									absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)

unique stationID if e(sample)==1									

									
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
	
twoway  (rspike max95 min95 time if gray==1,     lc(gs10)  lwidth(medium)) ///
        (rspike max95 min95 time if nexstar==1,  lc(gs6)   lwidth(medium)) ///
        (rspike max95 min95 time if sinclair==1, lc(black) lwidth(medium)) ///
        (connected estimate time if gray==1,     lc(gs10)  lp(shortdash) mc(gs10)  mfcolor(white) msize(medium) msymbol(square)) ///
        (connected estimate time if nexstar==1,  lc(gs6)   lp(longdash) mc(gs6)   mfcolor(white) msize(medium) msymbol(diamond)) ///
        (connected estimate time if sinclair==1, lc(black) lp(solid) mc(black) mfcolor(white) msize(medium) msymbol(circle)), ///
        graphr(c(white)) ///
        bgcolor(white) xsize(5.5) ysize(4) ///
        title("", c(black)) ///
        xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
        xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
        ytick(, notick nolabel) ///
        ylabel(-7.5(2.5)5, glc(gs12) glp(dot) format(%4.1f)) ///
        yline(0, lc(black) lwidth(vthin) lp(solid)) ///
        ytitle("Coefficient estimates, 95% CI", c(black)) ///
        xtitle("Semesters since/to acquisition", c(black)) ///
        legend(on order(6 5 4) ring(0) col(3) pos(7) region(lc(white) fcolor(white)) symx(8) ///
        label(4 "Gray") label(5 "Nexstar") label(6 "Sinclair"))
graph export figures/mention_place_pershow_TRIPLEDIFF_bygroup.pdf, replace
restore
	


//////////////
//////////////
// FIGURE 3 //
//////////////
//////////////

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
	
reghdfe log_duration_perHH_news		sinclair_minus5-sinclair_minus2 sinclair_plus0-sinclair_plus6 ///
									gray_minus5-gray_minus2 gray_plus0-gray_plus6 ///
									nexstar_minus5-nexstar_minus2 nexstar_plus0-nexstar_plus6 ///
									if gray_yearmonth_treated!=612&sinclair_yearmonth_treated!=612&nexstar_yearmonth_treated!=612, ///
									absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)

unique stationID if e(sample)==1									
									
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
		
twoway  (rspike max95 min95 time if gray==1,     lc(gs10)  lwidth(medium)) ///
        (rspike max95 min95 time if nexstar==1,  lc(gs6)   lwidth(medium)) ///
        (rspike max95 min95 time if sinclair==1, lc(black) lwidth(medium)) ///
        (connected estimate time if gray==1,     lc(gs10)  lp(shortdash) mc(gs10)  mfcolor(white) msize(medium) msymbol(square)) ///
        (connected estimate time if nexstar==1,  lc(gs6)   lp(longdash) mc(gs6)   mfcolor(white) msize(medium) msymbol(diamond)) ///
        (connected estimate time if sinclair==1, lc(black) lp(solid) mc(black) mfcolor(white) msize(medium) msymbol(circle)), ///
        graphr(c(white)) ///
        bgcolor(white) xsize(5.5) ysize(4) ///
        title("", c(black)) ///
        xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
        xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
        ytick(, notick nolabel) ///
		ylabel(-0.2(0.1)0.2, glc(gs12) glp(dot) format(%4.1f)) ///
        yline(0, lc(black) lwidth(vthin) lp(solid)) ///
        ytitle("Coefficient estimates, 95% CI", c(black)) ///
        xtitle("Semesters since/to acquisition", c(black)) ///
        legend(on order(6 5 4) ring(0) col(3) pos(7) region(lc(white) fcolor(white)) symx(8) ///
        label(4 "Gray") label(5 "Nexstar") label(6 "Sinclair"))
graph export figures/log_duration_DID_bygroup.pdf, replace
restore

// TRIPLE DIFF

reghdfe log_duration_perHH_news		sinclair_minus5-sinclair_minus2 sinclair_plus0-sinclair_plus6 ///
									gray_minus5-gray_minus2 gray_plus0-gray_plus6 ///
									nexstar_minus5-nexstar_minus2 nexstar_plus0-nexstar_plus6 ///
									if gray_yearmonth_treated!=612&sinclair_yearmonth_treated!=612&nexstar_yearmonth_treated!=612, ///
									absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
	
unique stationID if e(sample)==1									
	
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

twoway  (rspike max95 min95 time if gray==1,     lc(gs10)  lwidth(medium)) ///
        (rspike max95 min95 time if nexstar==1,  lc(gs6)   lwidth(medium)) ///
        (rspike max95 min95 time if sinclair==1, lc(black) lwidth(medium)) ///
        (connected estimate time if gray==1,     lc(gs10)  lp(shortdash) mc(gs10)  mfcolor(white) msize(medium) msymbol(square)) ///
        (connected estimate time if nexstar==1,  lc(gs6)   lp(longdash) mc(gs6)   mfcolor(white) msize(medium) msymbol(diamond)) ///
        (connected estimate time if sinclair==1, lc(black) lp(solid) mc(black) mfcolor(white) msize(medium) msymbol(circle)), ///
        graphr(c(white)) ///
        bgcolor(white) xsize(5.5) ysize(4) ///
        title("", c(black)) ///
        xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
        xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
        ytick(, notick nolabel) ///
		ylabel(-0.2(0.1)0.2, glc(gs12) glp(dot) format(%4.1f)) ///
        yline(0, lc(black) lwidth(vthin) lp(solid)) ///
        ytitle("Coefficient estimates, 95% CI", c(black)) ///
        xtitle("Semesters since/to acquisition", c(black)) ///
        legend(on order(6 5 4) ring(0) col(3) pos(7) region(lc(white) fcolor(white)) symx(8) ///
        label(4 "Gray") label(5 "Nexstar") label(6 "Sinclair"))
graph export figures/log_duration_TRIPLEDID_bygroup.pdf, replace
restore


//////////////
//////////////
// FIGURE 4 //
//////////////
//////////////

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
	
reghdfe rating_total_news			sinclair_minus5-sinclair_minus2 sinclair_plus0-sinclair_plus6 ///
									gray_minus5-gray_minus2 gray_plus0-gray_plus6 ///
									nexstar_minus5-nexstar_minus2 nexstar_plus0-nexstar_plus6 ///
									if gray_yearmonth_treated!=612&sinclair_yearmonth_treated!=612&nexstar_yearmonth_treated!=612, ///
									absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)
	
unique stationID if e(sample)==1									
	
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
	
twoway  (rspike max95 min95 time if gray==1,     lc(gs10)  lwidth(medium)) ///
        (rspike max95 min95 time if nexstar==1,  lc(gs6)   lwidth(medium)) ///
        (rspike max95 min95 time if sinclair==1, lc(black) lwidth(medium)) ///
        (connected estimate time if gray==1,     lc(gs10)  lp(shortdash) mc(gs10)  mfcolor(white) msize(medium) msymbol(square)) ///
        (connected estimate time if nexstar==1,  lc(gs6)   lp(longdash) mc(gs6)   mfcolor(white) msize(medium) msymbol(diamond)) ///
        (connected estimate time if sinclair==1, lc(black) lp(solid) mc(black) mfcolor(white) msize(medium) msymbol(circle)), ///
        graphr(c(white)) ///
        bgcolor(white) xsize(5.5) ysize(4) ///
        title("", c(black)) ///
        xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
        xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
        ytick(, notick nolabel) ///
		ylabel(-0.5(0.5)1.5, glc(gs12) glp(dot) format(%4.1f)) ///
        yline(0, lc(black) lwidth(vthin) lp(solid)) ///
        ytitle("Coefficient estimates, 95% CI", c(black)) ///
        xtitle("Semesters since/to acquisition", c(black)) ///
        legend(on order(6 5 4) ring(0) col(3) pos(7) region(lc(white) fcolor(white)) symx(8) ///
        label(4 "Gray") label(5 "Nexstar") label(6 "Sinclair"))
graph export figures/news_rating_DID_bygroup.pdf, replace
restore 

// TRIPLE

reghdfe rating_total_news			sinclair_minus5-sinclair_minus2 sinclair_plus0-sinclair_plus6 ///
									gray_minus5-gray_minus2 gray_plus0-gray_plus6 ///
									nexstar_minus5-nexstar_minus2 nexstar_plus0-nexstar_plus6 ///
									if gray_yearmonth_treated!=612&sinclair_yearmonth_treated!=612&nexstar_yearmonth_treated!=612, ///
									absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
	
unique stationID if e(sample)==1									
	
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
	
twoway  (rspike max95 min95 time if gray==1,     lc(gs10)  lwidth(medium)) ///
        (rspike max95 min95 time if nexstar==1,  lc(gs6)   lwidth(medium)) ///
        (rspike max95 min95 time if sinclair==1, lc(black) lwidth(medium)) ///
        (connected estimate time if gray==1,     lc(gs10)  lp(shortdash) mc(gs10)  mfcolor(white) msize(medium) msymbol(square)) ///
        (connected estimate time if nexstar==1,  lc(gs6)   lp(longdash) mc(gs6)   mfcolor(white) msize(medium) msymbol(diamond)) ///
        (connected estimate time if sinclair==1, lc(black) lp(solid) mc(black) mfcolor(white) msize(medium) msymbol(circle)), ///
        graphr(c(white)) ///
        bgcolor(white) xsize(5.5) ysize(4) ///
        title("", c(black)) ///
        xlabel(-5 "{&le}-5" -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "{&ge}6", grid valuel glc(gs12) glp(dot)) ///
        xline(-1, lc(black) lwidth(vthin) lp(solid)) ///
        ytick(, notick nolabel) ///
		ylabel(-0.5(0.5)1.5, glc(gs12) glp(dot) format(%4.1f)) ///
        yline(0, lc(black) lwidth(vthin) lp(solid)) ///
        ytitle("Coefficient estimates, 95% CI", c(black)) ///
        xtitle("Semesters since/to acquisition", c(black)) ///
        legend(on order(6 5 4) ring(0) col(3) pos(7) region(lc(white) fcolor(white)) symx(8) ///
        label(4 "Gray") label(5 "Nexstar") label(6 "Sinclair"))
graph export figures/news_rating_TRIPLEDIFF_bygroup.pdf, replace

restore









