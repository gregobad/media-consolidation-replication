///////////////////////////////////////////////////
// CREATES TABLES IN THE APPENDIX                //
///////////////////////////////////////////////////

clear all
	
//////////////////////
// APPENDIX TABLE 1 //
//////////////////////

use "${PATH}/data/acquisitions/acquisition_panel_station_top3_FINAL.dta", clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

gen analytical_sample = (_m==3)

foreach group in sinclair nexstar gray {
	
	bysort stationID: egen ever_`group' = max(station_ownedby_`group'_LMA)
	bysort stationID: egen min_`group' = min(station_ownedby_`group'_LMA)
	gen new_`group' = (min_`group' == 0 & ever_`group' == 1)

	replace ever_`group' = . if ever_`group' == 0
	replace ever_`group' = 0 if analytical_sample == 0 & ever_`group' !=.
	
	
	replace new_`group' = . if new_`group' == 0
	replace new_`group' = 0 if analytical_sample == 0 & new_`group' !=.
	
	}

cap drop tag
egen tag=tag(stationID)		

keep if tag==1

label var analytical_sample	"Stations"

label var ever_sinclair		"\\ Sinclair:\\Ever Owned"
label var ever_nexstar		"\\ Nexstar:\\Ever Owned"
label var ever_gray			"\\ Gray:\\Ever Owned"

label var new_sinclair		"Acquired 2010-2020"
label var new_nexstar		"Acquired 2010-2020"
label var new_gray			"Acquired 2010-2020"
				
tabstat analytical_sample ever_sinclair new_sinclair ever_nexstar new_nexstar ever_gray new_gray, statistics(N sum) columns(statistics)
	
estpost tabstat analytical_sample ever_sinclair new_sinclair ever_nexstar new_nexstar ever_gray new_gray, statistics(N sum) columns(statistics)

esttab . using tables/sample_stats.tex, replace collabels("\shortstack{Acquisition\\Sample}" "\shortstack{Analytical\\Sample}") ///
										cells("count sum") label noobs nonotes nomtitles nonum 

	
//////////////////////
// APPENDIX TABLE 2 //
//////////////////////

cap program drop add_unique
program define add_unique
    syntax varlist
    tempname S D
    matrix `S' = e(count)          // same column names (your variables) as estpost
    matrix `D' = e(count)
    local j 0
    foreach v of local varlist {
        local ++j
        tempvar t1 t2
        qui egen `t1' = tag(stationID) if !missing(`v')
        qui count if `t1' == 1
        matrix `S'[1, `j'] = r(N)
        qui egen `t2' = tag(dmacode) if !missing(`v')
        qui count if `t2' == 1
        matrix `D'[1, `j'] = r(N)
        drop `t1' `t2'
    }
    estadd matrix stations = `S'
    estadd matrix dmas     = `D'
end

// CONTENT VARIABLES

use data/harmony/content_cleaned.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

cap drop tag
egen tag=tag(stationID)								

label var mention_place_pershow 			"Mentions/Shows"
label var mention_pol_local_pershow 		"Mayors' Mentions/Shows"
label var mention_pol_stateleg_pershow 		"State Legislators' Mentions/Shows"
label var mention_pol_congress_pershow 		"House Representatives' Mentions/Shows"

local vars 	mention_place_pershow 	mention_pol_local_pershow  	mention_pol_stateleg_pershow 	mention_pol_congress_pershow

estpost tabstat `vars', statistics(N mean sd min median max) columns(statistics)
add_unique `vars'

esttab . using tables/descriptives.tex, replace collabels("Stations" "DMAs" "N" "Mean" "SD" "Min" "Median" "Max") ///
				cells("stations dmas count mean(fmt(3)) sd(fmt(3)) min(fmt(3)) p50(fmt(3)) max(fmt(3))") ///
				label booktabs nonotes noobs nomtitles nonum fragment ///
				prehead("{\def \sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{8}{c}} \toprule") ///
				posthead("\midrule \ & \multicolumn{8}{c}{Panel A: Content (2013-2019)} \\\cmidrule(lr){2-9}") 

				
								
// ADVERTISING VARIABLES

use data/adintel/adintel_clean_updated.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

drop if year==2010
drop if year==2020

label var duration_perHH_news 			"Duration"
label var spend_perHH_news 				"Revenue"
label var log_duration_perHH_news 		"Log Duration"
label var log_spend_perHH_news 			"Log Revenue"

local vars 	duration_perHH_news log_duration_perHH_news spend_perHH_news log_spend_perHH_news

tabstat `vars', statistics(N mean sd min median max) columns(statistics)
estpost tabstat `vars', statistics(N mean sd min median max) columns(statistics)
add_unique `vars'

esttab . using tables/descriptives.tex,  	append	 cells("stations dmas count mean(fmt(3)) sd(fmt(3)) min(fmt(3)) p50(fmt(3)) max(fmt(3))") ///
				 label booktabs nonotes noobs nomtitles nonum   nodepvars fragment collabels(none) ///
				 posthead("\midrule \ & \multicolumn{8}{c}{Panel B: Advertising (2011-2019)} \\\cmidrule(lr){2-9}") 

// gets values to be manually added to the table
unique stationID if log_duration_perHH_news != .
unique dmacode if log_duration_perHH_news != .
				 
	
// RATINGS VARIABLES

use data/adintel/adintel_clean_updated.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

drop if year==2010
drop if year==2020

label var rating_total_news 		"News Ratings"
label var imp_total_news 			"Impressions"
label var log_imp_total_news 		"Log Impressions"

local vars 	rating_total_news imp_total_news log_imp_total_news

tabstat `vars', statistics(N mean sd min median max) columns(statistics)
estpost tabstat `vars', statistics(N mean sd min median max) columns(statistics)
add_unique `vars'

esttab . using tables/descriptives.tex,  	append	 cells("stations dmas count mean(fmt(3)) sd(fmt(3)) min(fmt(3)) p50(fmt(3)) max(fmt(3))") ///
				 label booktabs nonotes noobs nomtitles nonum   nodepvars fragment collabels(none) ///
				 posthead("\midrule \ & \multicolumn{8}{c}{Panel C: Viewership (2011-2019)} \\\cmidrule(lr){2-9}") ///
				 postfoot("\bottomrule \end{tabular}}") 

// gets values to be manually added to the table
unique stationID if rating_total_news != .
unique dmacode if rating_total_news != .
				

//////////////////////
// APPENDIX TABLE 3 //
//////////////////////

use data/CCES/CCES_final.dta, clear

label var recog_houserep_never_heardbroad 	"Never Heard of Representative"
label var dontknow_approval_housemember 	"Not Able to Evaluate Representative"
label var no_prefencehouse 					"Has No Preference over Election"
label var gender_male						"Male"
label var employed							"Employed"
label var race_black						"Race: Black"
label var race_hispanic						"Race: Hispanic"
label var race_asian						"Race: Asian"
label var race_others						"Race: Other"
label var college_grad						"Has Graduated College"
label var married							"Married"
label var income_high						"Family Income Above $\\$$60,000"
label var age								"Age"	

local vars recog_houserep_never_heardbroad  dontknow_approval_housemember no_prefencehouse $controls_CCES

tabstat `vars', statistics(N mean sd) columns(statistics)
estpost tabstat `vars', statistics(N mean sd) columns(statistics)

esttab . using "tables/CCES_descriptives.tex", collabels("Observations" "Mean" "SD") ///
				cells("count mean(fmt(3)) sd(fmt(3))") label booktabs nonotes replace  noobs nomtitles nonum 

	
//////////////////////
// APPENDIX TABLE 4 //
//////////////////////

use data/adintel/adintel_clean_updated.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

drop if year==2010
drop if year==2020

eststo clear

eststo: reghdfe log_duration_perHH_MM_news 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
												station_ownedby_gray_LMA, ///
												absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		"\checkmark"
qui estadd local dmamonthFE		""
qui estadd local controls 		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe log_duration_perHH_MM_news 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
												station_ownedby_gray_LMA, ///
												absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		""
qui estadd local dmamonthFE		"\checkmark"
qui estadd local controls 		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe log_duration_perHH_SM_news 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
												station_ownedby_gray_LMA, ///
												absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		"\checkmark"
qui estadd local dmamonthFE		""
qui estadd local controls 		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe log_duration_perHH_SM_news 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
												station_ownedby_gray_LMA, ///
												absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		""
qui estadd local dmamonthFE		"\checkmark"
qui estadd local controls 		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

// REVENUES

eststo: reghdfe log_spend_perHH_MM_news 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
												station_ownedby_gray_LMA, ///
												absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		"\checkmark"
qui estadd local dmamonthFE		""
qui estadd local controls 		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe log_spend_perHH_MM_news 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
												station_ownedby_gray_LMA, ///
												absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		""
qui estadd local dmamonthFE		"\checkmark"
qui estadd local controls 		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe log_spend_perHH_SM_news 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
												station_ownedby_gray_LMA, ///
												absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		"\checkmark"
qui estadd local dmamonthFE		""
qui estadd local controls 		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe log_spend_perHH_SM_news 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
												station_ownedby_gray_LMA, ///
												absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		""
qui estadd local dmamonthFE		"\checkmark"
qui estadd local controls 		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

esttab, nogaps keep(station_ownedby_*) ///
		noomitted nonotes se(%9.3f) b(%9.3f) nomtitles ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) ///
		mgroups("Multi-Market" "Single-Market" "Multi-Market" "Single-Market", pattern(1 0 1 0 1 0 1 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(stationFE monthFE dmamonthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray  pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs" "DMA-By-Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray" )) 

esttab using tables/adintel_by_multi_and_single_market.tex, replace nogaps keep(station_ownedby_*)  ///
		prehead("{\def \sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{9}{c}} \toprule \ &\multicolumn{4}{c}{Log Duration}&\multicolumn{4}{c}{Log Revenue}  \\\cmidrule(lr){2-5} \cmidrule(lr){6-9}") ///
		noomitted nonotes se(%9.3f) b(%9.3f) nomtitles ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) ///
		mgroups("Multi-Market" "Single-Market" "Multi-Market" "Single-Market", pattern(1 0 1 0 1 0 1 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(stationFE monthFE dmamonthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray  pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs" "DMA-By-Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray" )) 




//////////////////////
// APPENDIX TABLE 5 //
//////////////////////

use data/adintel/adintel_clean_updated.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

drop if year==2010
drop if year==2020

eststo clear

g share_MM_duration_news 	= total_duration_MM_news / (total_duration_MM_news + total_duration_SM_news)
g share_MM_spend_news		= total_spend_MM_news / (total_spend_MM_news + total_spend_SM_news)
g share_MM_duration_nonnews = total_duration_MM_nonnews / (total_duration_MM_nonnews + total_duration_SM_nonnews)
g share_MM_spend_nonnews	= total_spend_MM_nonnews / (total_spend_MM_nonnews + total_spend_SM_nonnews)

eststo clear

// 1. DURATION

eststo: reghdfe share_MM_duration_news		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
qui estadd local dmamonthFE		""
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

// 3. PER MINUTE

eststo: reghdfe share_MM_duration_news		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		""
qui estadd local dmamonthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

// 2. TOTAL REVENUES

eststo: reghdfe  share_MM_spend_news		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
qui estadd local dmamonthFE		""
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

// 1. DURATION

eststo: reghdfe share_MM_spend_news			station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		""
qui estadd local dmamonthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 



esttab, nogaps keep(station_ownedby_*)  ///
		noomitted nonotes se(%9.3f) b(%9.3f) nomtitles ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) ///
		mgroups("Duration" "Revenue", pattern(1 0 1 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(stationFE monthFE dmamonthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray  pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs" "DMA-By-Month FEs" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray" )) 

					
					
esttab using tables/adintel_share_local.tex, replace nogaps keep(station_ownedby_*)  ///
		prehead("{\def \sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{5}{c}} \toprule \ & \multicolumn{4}{c}{Share Multi-Market Advertisers} \\\cmidrule(lr){2-5}") ///
		noomitted nonotes se(%9.3f) b(%9.3f) nomtitles ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) ///
		mgroups("By Duration" "By Revenue", pattern(1 0 1 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(stationFE monthFE dmamonthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray  pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs" "DMA-By-Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray" )) 
	

			  
			  
			  
//////////////////////////
// APPENDIX TABLE 5     //
//////////////////////////

use data/adintel/adintel_clean_updated.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

drop if year==2010
drop if year==2020

eststo clear

eststo clear

eststo: reghdfe cpm_news						station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
												station_ownedby_gray_LMA, ///
												absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		"\checkmark"
qui estadd local dmamonthFE		""
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe cpm_news						station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
												station_ownedby_gray_LMA, ///
												absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		""
qui estadd local dmamonthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe cpm_MM_news						station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
												station_ownedby_gray_LMA, ///
												absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		"\checkmark"
qui estadd local dmamonthFE		""
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe cpm_MM_news						station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
												station_ownedby_gray_LMA, ///
												absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		""
qui estadd local dmamonthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe cpm_SM_news						station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
												station_ownedby_gray_LMA, ///
												absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		"\checkmark"
qui estadd local dmamonthFE		""
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe cpm_SM_news						station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
												station_ownedby_gray_LMA, ///
												absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		""
qui estadd local dmamonthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

esttab, nogaps keep(station_ownedby_*) ///
		noomitted nonotes se(%9.3f) b(%9.3f) nomtitles ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) ///
		mgroups("All" "Multi-Market" "Single-Market", pattern(1 0 1 0 1 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(stationFE monthFE  dmamonthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray  pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f  %9.0f  %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f) ///
			  labels("Station FEs" "Month FEs"  "DMA-By-Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray" )) 

esttab using tables/cpm.tex, replace nogaps keep(station_ownedby_*) ///
		prehead("{\def \sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{7}{c}} \toprule \ & \multicolumn{6}{c}{Cost-per-Mille} \\\cmidrule(lr){2-7}") ///
		noomitted nonotes se(%9.3f) b(%9.3f) nomtitles ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) ///
		mgroups("All" "Multi-Market" "Single-Market", pattern(1 0 1 0 1 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress  ///
		stats(stationFE monthFE  dmamonthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray  pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f  %9.0f  %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs"  "DMA-By-Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray" )) 





	

//////////////////////
// APPENDIX TABLE 7 //
//////////////////////

use data/adintel/adintel_clean_updated.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

drop if year==2010
drop if year==2020

eststo clear

// 1. DURATION

eststo: reghdfe log_duration_perHH_nonnews 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
												station_ownedby_gray_LMA, ///
												absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		"\checkmark"
qui estadd local dmamonthFE		""
qui estadd local controls 		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe log_duration_perHH_nonnews		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
												station_ownedby_gray_LMA, ///
												absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		""
qui estadd local dmamonthFE		"\checkmark"
qui estadd local controls 		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

// 2. TOTAL REVENUES

eststo: reghdfe log_spend_perHH_nonnews		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		"\checkmark"
qui estadd local dmamonthFE		""
qui estadd local controls 		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe log_spend_perHH_nonnews 	station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		""
qui estadd local dmamonthFE		"\checkmark"
qui estadd local controls 		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

esttab, nogaps keep(station_ownedby_*) ///
		noomitted nonotes se(%9.3f) b(%9.3f) nomtitles ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) ///
		mgroups("Log Duration" "Log Revenues", pattern(1 0 1 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(stationFE monthFE dmamonthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray  pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs" "DMA-By-Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray" )) 

esttab using tables/adintel_main_nonnews.tex, replace nogaps keep(station_ownedby_*)  ///
		noomitted nonotes se(%9.3f) b(%9.3f) nomtitles ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) ///
		mgroups("Log Duration" "Log Revenue", pattern(1 0 1 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(stationFE monthFE dmamonthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray  pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs" "DMA-By-Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray" )) 




//////////////////////
// APPENDIX TABLE 8 //
//////////////////////

use data/adintel/adintel_clean_updated.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

drop if year==2010
drop if year==2020

// DID

eststo clear

eststo: reghdfe rating_total_news			station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe rating_lt_50_news				station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
												station_ownedby_gray_LMA ///
												, ///
												absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe rating_50_plus_news					station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
													station_ownedby_gray_LMA ///
													, ///
													absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe rating_m_news						station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
													station_ownedby_gray_LMA ///
													, ///
													absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe rating_f_news						station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
													station_ownedby_gray_LMA ///
													, ///
													absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe log_imp_total_news			station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date  c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe log_imp_lt_50_news			station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date  c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe log_imp_50_plus_news		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date  c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe log_imp_m_news	 			station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date  c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe log_imp_f_news				station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date  c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

esttab, nogaps keep(station_ownedby_*)  ///
		rename(	station_ownedby_sinclair_SSA station_ownedby_sinclair_LMA ///
				station_ownedby_gray_SSA station_ownedby_gray_LMA ///
				station_ownedby_nexstar_SSA station_ownedby_nexstar_LMA ///
				station_ownedby_sinclair_OO station_ownedby_sinclair_LMA ///
				station_ownedby_gray_OO station_ownedby_gray_LMA ///
				station_ownedby_nexstar_OO station_ownedby_nexstar_LMA ///
				) ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01)  nonumbers ///
		mlabels("Full" "50-" "50+" "50+, M" "50+, F" "Full" "50-" "50+" "50+, M" "50+,F \\ \  & (1) & (2) & (3) & (4) & (5) & (6) & (7) & (8) & (9) & (10)") ///
		mgroups("News Ratings" "Impressions", pattern(1 0 0 0 0 1 0 0 0 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(stationFE monthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray   pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f  %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray"  "Nexstar = Gray" )) 

esttab using tables/ratings_byagegroup.tex, replace nogaps keep(station_ownedby_*)  ///
		fragment /// 
		prehead("{\def \sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{11}{c}} \toprule") ///
		posthead("\midrule \ & \multicolumn{10}{c}{Panel A: Differences-in-Differences} \\\cmidrule(lr){2-11}") ///
		noomitted nonotes se(%9.3f) b(%9.3f)   ///
		label  starlevels(* 0.10 ** 0.05 *** 0.01)  nonumbers ///
		mlabels("Full" "50-" "50+" "M" "F" "Full" "50-" "50+" "M" "F \\ \  & (1) & (2) & (3) & (4) & (5) & (6) & (7) & (8) & (9) & (10)") ///
		mgroups("News Ratings" "Log Impressions", pattern(1 0 0 0 0 1 0 0 0 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(stationFE monthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray   pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f  %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray"  "Nexstar = Gray" )) 

// TRIPLE DIFFERENCES
					
eststo clear

eststo: reghdfe rating_total_news			station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe rating_lt_50_news				station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
												station_ownedby_gray_LMA ///
												, ///
												absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe rating_50_plus_news					station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
													station_ownedby_gray_LMA ///
													, ///
													absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe rating_m_news						station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
													station_ownedby_gray_LMA ///
													, ///
													absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe rating_f_news						station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
													station_ownedby_gray_LMA ///
													, ///
													absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe log_imp_total_news			station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date##dmacode  c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe log_imp_lt_50_news			station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date##dmacode  c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe log_imp_50_plus_news		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date##dmacode  c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe log_imp_m_news	 			station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date##dmacode  c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe log_imp_f_news				station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date##dmacode  c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

esttab, nogaps keep(station_ownedby_*)  ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01)  nonumbers ///
		mlabels("Full" "50-" "50+" "50+, M" "50+, F" "Full" "50-" "50+" "50+, M" "50+,F \\ \  & (1) & (2) & (3) & (4) & (5) & (6) & (7) & (8) & (9) & (10)") ///
		mgroups("News Ratings" "Impressions", pattern(1 0 0 0 0 1 0 0 0 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(stationFE monthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray   pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f  %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "DMA-By-Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray"  "Nexstar = Gray" )) 

esttab using tables/ratings_byagegroup.tex, fragment append nogaps keep(station_ownedby_*)  ///
		posthead("\midrule \ & \multicolumn{10}{c}{Panel B: Within-Market Differences-in-Differences} \\\cmidrule(lr){2-11}") ///
		postfoot("\bottomrule \end{tabular}}") ///
		label noomitted nonotes se(%9.3f) b(%9.3f) starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle nonumbers ///
		compress ///
		stats(stationFE monthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray   pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f  %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "DMA-By-Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray"  "Nexstar = Gray" )) 





//////////////////////
// APPENDIX TABLE 9 //
//////////////////////

use data/adintel/adintel_clean_updated.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

drop if year==2010
drop if year==2020



eststo clear

eststo: reghdfe rating_total_nonnews		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date  c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		"\checkmark"
qui estadd local dmamonthFE		""
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe rating_total_nonnews 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date##dmacode  c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		""
qui estadd local dmamonthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe log_imp_total_nonnews		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date  c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		"\checkmark"
qui estadd local dmamonthFE		""
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe log_imp_total_nonnews	 	station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date##dmacode  c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		""
qui estadd local dmamonthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

esttab, nogaps keep(station_ownedby_*)  ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle ///
		mgroups("Ratings" "Log Impressions", pattern(1 0 1 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(stationFE monthFE dmamonthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f  %9.0f  %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs" "DMA-By-Month FEs" "Controls"  "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray" )) 

esttab using tables/ratings_nonnews.tex, replace nogaps keep(station_ownedby_*)  ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle ///
		mgroups("Ratings" "Log Impressions", pattern(1 0 1 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(stationFE monthFE dmamonthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f  %9.0f  %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs" "DMA-By-Month FEs" "Controls"  "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray" )) 

	
			  
///////////////////////
// APPENDIX TABLE 10 //
///////////////////////

import delimited "data/harmony/harmony_mentions_station_cong_district_month.csv", clear 

ren date date_str

gen date=ym(year,month)
format date %tm

cap drop dup
duplicates tag state district callsign date, g(dup)
qui count if dup!=0
assert `r(N)'==0

// HARMONY LABS DATA FIXES //

// fix callsigns

drop if callsign=="KOTI"&year>2014
drop if callsign=="KOTI"&year==2014&month>10

drop if callsign=="KOBI"&year<2014
drop if callsign=="KOBI"&year==2014&month<=10

replace callsign="KOBI" if callsign=="KOTI"

// fix dmacode for WHIZ
replace dmacode=596 if callsign=="WHIZ"

// fix dmacode for Palm Springs stations
replace dmacode=804 if callsign=="KPSP"
replace dmacode=804 if callsign=="KDFX"

drop year month

merge m:1 callsign date using data/acquisitions/acquisition_panel_station_top3_FINAL.dta

//    Result                      Number of obs
//     -----------------------------------------
//     Not matched                        61,703
//         from master                    30,990  (_merge==1)
//         from using                     30,713  (_merge==2)
//
//     Matched                            69,330  (_merge==3)
//     -----------------------------------------

drop if year(dofm(date))>2020
drop if year(dofm(date))<2013

tab _m

//    Matching result from |
//                   merge |      Freq.     Percent        Cum.
// ------------------------+-----------------------------------
//         Master only (1) |     10,926        9.85        9.85
//          Using only (2) |     30,713       27.68       37.52
//             Matched (3) |     69,330       62.48      100.00
// ------------------------+-----------------------------------
//                   Total |    110,969      100.00

keep if _m==3
drop _m

unique callsign // 729 stations

// gets number of programs to implement per show normalization
preserve
use data/harmony/content_cleaned.dta, clear

keep stationID date n_progs

tempfile content
save `content'
restore

merge m:1 stationID date using `content'

keep if _m==3
drop _m

// merges in baseline characteristics
merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

cap drop tag

// CLEANS VARIABLES

egen cdID=group(state district)
egen tag=tag(cdID)

su share_of_dma if tag==1, d
g high_congruence = (share_of_dma>=`r(p50)') 

g mentions_pol_congress_pershow = mentions_pol_congress_total / n_progs
		
label var high_congruence  "High"

g dummy=(mentions_pol_congress_pershow>0) if mentions_pol_congress_pershow!=.

eststo clear

eststo: reghdfe dummy 							station_ownedby_sinclair_LMA station_ownedby_gray_LMA station_ownedby_nexstar_LMA, ///
												cluster(dmacode) absorb(date cdID dmacode stationID c.($station_controls)##i.date)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local monthFE			"\checkmark"
qui estadd local stationFE			"\checkmark"
qui estadd local dmaFE				"\checkmark"
qui estadd local dmamonthFE			""
qui estadd local cdFE				"\checkmark"
qui estadd local controls			"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe dummy 							station_ownedby_sinclair_LMA station_ownedby_gray_LMA station_ownedby_nexstar_LMA, ///
												cluster(dmacode) absorb(date##dmacode cdID stationID c.($station_controls)##i.date)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local monthFE			""
qui estadd local stationFE			"\checkmark"
qui estadd local dmaFE				""
qui estadd local dmamonthFE			"\checkmark"
qui estadd local cdFE				"\checkmark"
qui estadd local controls			"\checkmark"
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

esttab, nogaps keep(station_ownedby_*)  order(station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA station_ownedby_gray_LMA) ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle ///
		mgroups("Members of Congress", pattern(1 0 0 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(cdFE stationFE monthFE dmamonthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray  pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("CD FEs" "Station FEs" "Month FEs" "DMA-By-Month FEs" "Controls"  "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray")) 

esttab using tables/content_additional_outcomes_dummy.tex, replace nogaps keep(station_ownedby_*)  ///
		order(station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA station_ownedby_gray_LMA) ///
		nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle ///
		mgroups("House Representative", pattern(1 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(cdFE stationFE monthFE dmamonthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray  pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("CD FEs" "Station FEs" "Month FEs" "DMA-By-Month FEs" "Controls"  "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray")) 

 
 
////////////////////////
// APPENDIX TABLE B11 //
////////////////////////
		
// To define median news ratings, use the sample of stations in the AdIntel analysis (the most comprehensive one)

use data/acquisitions/acquisition_panel_station_top3_FINAL.dta, clear
	
// IDENTIFIES STATIONS EVER CONTROLLED BY EACH GROUP

	foreach group in sinclair nexstar gray {

		cap drop max
		bysort stationID: egen ever_`group'=max(station_ownedby_`group'_LMA)

		}
		
	cap drop tag
	egen tag=tag(stationID)	

	keep if tag==1	
	
	keep stationID ever_* dmacode 
	
	tempfile stations
	save `stations'
	
	use data/adintel/adintel_clean_updated.dta, clear

	merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

	keep if _m==3
	drop _merge

	cap drop tag
	egen tag=tag(stationID)	
		
	keep if tag==1	
		
	merge m:1 stationID using `stations'
	
	g no_rating = (_m==2)
	
	drop _m
	
	foreach group in sinclair nexstar gray {
		
		bysort dmacode: egen total_`group' = total(ever_`group')
		bysort dmacode: egen total_norating_`group' = total(ever_`group'*no_rating)
		
		unique dmacode if total_`group' == total_norating_`group' & total_`group'!=0
		
		gen noratings_`group' = (total_`group' == total_norating_`group' & total_`group'!=0)
		
		}
	
	// CREATES THE DUMMIES FOR BEING HIGH MARKET SHARE
	su rating_news_2010, d
	scalar define median = `r(p50)'
	g high_ratings_v1 = (rating_news_2010>=`r(p50)') if 	rating_news_2010!=.

	gen ever_group = 0
	replace ever_group = 1 if ever_sinclair == 1
	replace ever_group = 1 if ever_nexstar == 1
	replace ever_group = 1 if ever_gray == 1

	su rating_news_2010 if ever_group==1, d
	local median_groups = `r(p50)'
	g high_ratings_v2 = (rating_news_2010>=`r(p50)') if 	rating_news_2010!=.
 
// MAKES THEM GROUP SPECIFIC AND AGGREGATE AT THE DMA LEVEL
foreach group in sinclair nexstar gray {
	
	cap drop temp
	g temp = ever_`group' * high_ratings_v1
	bysort dmacode: egen high_ratings_`group'_v1 = max(temp)
	
	cap drop temp
	g temp = ever_`group' * high_ratings_v2
	bysort dmacode: egen high_ratings_`group'_v2 = max(temp)

	}
	

	su rating_news_2010, d
	local median = `r(p50)'
	su rating_news_2010 if ever_group==1, d
	local median_groups = `r(p50)'

	colorpalette viridis, ipolate(3) nograph

// descriptive figure
tw  (kdensity 	rating_news_2010 if ever_sinclair==1, lc("`r(p1)'") lw(medthick))  ///
	(kdensity 	rating_news_2010 if ever_nexstar==1, lc("`r(p2)'") lw(medthick))  ///
	(kdensity 	rating_news_2010 if ever_gray==1, lc("`r(p3)'") lw(medthick)) ///
	(kdensity 	rating_news_2010, lc(gs10) lw(medthick) ///
	title("", color(black)) ///
	graphregion(color(white)) bgcolor(white) ///
	ytitle("Density") ///
	xtitle("News ratings") xsize(5.5) ysize(4)  ///
	xline(`median', lc(gs5) lwidth(thin)  lp(solid)) ///
	text(.20 `median' " Median",  size(small) place(3)) ///
	xline(`median_groups', lc(gs5) lwidth(thin)  lp(solid)) ///
	text(.19 `median_groups' "Median, ever acquired stations", place(3) size(small)) ///
	xlabel(, valuelabel grid glc(gs12) glp(dot))  ///
	ylabel(, grid valuel glc(gs12) glp(dot)) ///
	legend(on order(3 2 1 4) ring(0) col(1) pos(2) region(lc(white) fcolor(none))   ///
	symy(1) symx(5) textw(15) forces ///
	label(1 "Sinclair") ///
	label(2 "Nexstar") ///
	label(3 "Gray") ///
	label(4 "All Stations") ///
	))

	cap drop tag
	egen tag=tag(dmacode)
	keep if tag==1

	keep dmacode dma high_ratings_*_v1 high_ratings_*_v2 noratings_*
		
		
	tempfile heterog
	save `heterog'
	
	use data/CCES/CCES_final.dta, clear

	merge m:1 dmacode using `heterog'

		
 *   Result                      Number of obs
 *   -----------------------------------------
 *   Not matched                             1
 *       from master                         0  (_merge==1)
  *      from using                          1  (_merge==2)

  *  Matched                           434,782  (_merge==3)
  *  -----------------------------------------



**********************************************
* TABLE: Interaction of ownership × newsrating
**********************************************

eststo clear

*-------------------------------*
* Model 1: Never Heard of Rep
*-------------------------------*
	eststo: reghdfe recog_houserep_never_heardbroad ownedby_sinclair_LMA##high_ratings_sinclair_v2 ///
													ownedby_nexstar_LMA##high_ratings_nexstar_v2 ///
													ownedby_gray_LMA##high_ratings_gray_v2 ///
													ownedby_sinclair_LMA##noratings_sinclair ///
													ownedby_nexstar_LMA##noratings_nexstar ///
													ownedby_gray_LMA##noratings_gray ///
													$controls_CCES , absorb(dmacode cdID##redistricting  year) cluster(dmacode)

	qui su `e(depvar)' if e(sample)==1
	qui scalar ymean = `r(mean)'
	qui estadd scalar ymean

	qui unique cdID if e(sample)==1
	qui scalar N_cds = `r(unique)'
	qui estadd scalar N_cds
	

	qui estadd local dmaFE						 		"\checkmark"
	qui estadd local CD_by_redistricting_FE 			"\checkmark"
	qui estadd local yearFE								"\checkmark"
	qui estadd local controls							"\checkmark"

*-------------------------------*
* Model 2: Don't Know Approval
*-------------------------------*

	eststo: reghdfe dontknow_approval_housemember 	ownedby_sinclair_LMA##high_ratings_sinclair_v2 ///
													ownedby_nexstar_LMA##high_ratings_nexstar_v2 ///
													ownedby_gray_LMA##high_ratings_gray_v2 ///
													ownedby_sinclair_LMA##noratings_sinclair ///
													ownedby_nexstar_LMA##noratings_nexstar ///
													ownedby_gray_LMA##noratings_gray ///
													$controls_CCES , absorb(dmacode cdID##redistricting  year)cluster(dmacode)

	qui su `e(depvar)' if e(sample)==1
	qui scalar ymean = `r(mean)'
	qui estadd scalar ymean

	qui unique cdID if e(sample)==1
	qui scalar N_cds = `r(unique)'
	qui estadd scalar N_cds

	qui estadd local dmaFE						 		"\checkmark"
	qui estadd local CD_by_redistricting_FE 			"\checkmark"
	qui estadd local yearFE								"\checkmark"
	qui estadd local controls							"\checkmark"

*-------------------------------*
* Model 3: No Preference over Election
*-------------------------------*

	eststo: reghdfe no_prefencehouse 			ownedby_sinclair_LMA##high_ratings_sinclair_v2 ///
												ownedby_nexstar_LMA##high_ratings_nexstar_v2 ///
												ownedby_gray_LMA##high_ratings_gray_v2 ///
												ownedby_sinclair_LMA##noratings_sinclair ///
												ownedby_nexstar_LMA##noratings_nexstar ///
												ownedby_gray_LMA##noratings_gray ///
												$controls_CCES , absorb(dmacode cdID##redistricting  year) cluster(dmacode)

	qui su `e(depvar)' if e(sample)==1
	qui scalar ymean = `r(mean)'
	qui estadd scalar ymean

	qui unique cdID if e(sample)==1
	qui scalar N_cds = `r(unique)'
	qui estadd scalar N_cds

	qui estadd local dmaFE						 		"\checkmark"
	qui estadd local CD_by_redistricting_FE 			"\checkmark"
	qui estadd local yearFE								"\checkmark"
	qui estadd local controls							"\checkmark"


esttab using tables/market_concentration_final.tex, replace nogaps ///
    keep(1.ownedby_sinclair_LMA 1.ownedby_sinclair_LMA#1.high_ratings_sinclair_v2 ///
         1.ownedby_nexstar_LMA 1.ownedby_nexstar_LMA#1.high_ratings_nexstar_v2 ///
         1.ownedby_gray_LMA 1.ownedby_gray_LMA#1.high_ratings_gray_v2) ///
	noomitted nonotes se(%9.3f) b(%9.3f) nomtitle  ///
	mgroups("Never Heard" "Cannot Evaluate" "No Preference", pattern(1 1 1) ///
	prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	coeflabels(1.ownedby_sinclair_LMA  "Post-Acquisition, Sinclair" ///
				1.ownedby_sinclair_LMA#1.high_ratings_sinclair_v2 "Post-Acquisition, Sinclair $\times$ High Ratings Sinclair" ///
				1.ownedby_nexstar_LMA  "Post-Acquisition, Nexstar" ///
				1.ownedby_nexstar_LMA#1.high_ratings_nexstar_v2 "Post-Acquisition, Nexstar $\times$ High Ratings Nexstar" ///
				1.ownedby_gray_LMA  "Post-Acquisition, Gray" ///
				1.ownedby_gray_LMA#1.high_ratings_gray_v2 "Post-Acquisition, Gray $\times$ High Ratings Gray") ///
    se star(* 0.10 ** 0.05 *** 0.01)  ///
    booktabs nonotes compress ///
    stats(dmaFE CD_by_redistricting_FE yearFE controls N N_clust ymean, ///
          labels("DMA FEs" "CD-By-Redistricting-Cycle FEs" "Year FEs" "Controls" ///
				"\midrule Observations" "DMAs (Clusters)" "Mean Dep. Variable") ///
          fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f))
	
	