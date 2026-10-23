///////////////////////////////////////////////////
// CREATES TABLES IN THE MAIN BODY OF THE PAPER  //
///////////////////////////////////////////////////

clear all
		
/////////////
// TABLE 1 //
/////////////

use data/harmony/content_cleaned.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

cap drop tag
egen tag=tag(stationID)								


eststo clear

// BASELINE, DID
eststo: reghdfe mention_place_pershow 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date) cluster(dma)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 			"\checkmark"
qui estadd local monthFE  			"\checkmark"
qui estadd local dmamonthFE			""
qui estadd local controls			""
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

// SELECTED CONTROLS, DID
eststo: reghdfe mention_place_pershow 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dma)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 			"\checkmark"
qui estadd local monthFE  			"\checkmark"
qui estadd local dmamonthFE			""
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

// BASELINE, TRIPLE DIFF
eststo: reghdfe mention_place_pershow 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date##dmacode) cluster(dma)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 			"\checkmark"
qui estadd local monthFE  			""
qui estadd local dmamonthFE			"\checkmark"
qui estadd local controls			""
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

// SELECTED CONTROLS, TRIPLE DIFF
eststo: reghdfe mention_place_pershow 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dma)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 			"\checkmark"
qui estadd local monthFE  			""
qui estadd local dmamonthFE			"\checkmark"
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

esttab, nogaps keep(station_ownedby_*)  ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle ///
		mgroups("Mentions/Shows", pattern(1 0 0 0 0 0 0 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(stationFE monthFE dmamonthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs" "DMA-By-Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray")) 

esttab using tables/content_main.tex, replace booktabs nogaps keep(station_ownedby_*)  ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle ///
		mgroups("Mentions/Shows", pattern(1 0 0 0 0 0 0 0 ) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(stationFE monthFE dmamonthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs" "DMA-By-Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray")) 


					
			
/////////////
// TABLE 2 //
/////////////

use data/harmony/content_cleaned.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

cap drop tag
egen tag=tag(stationID)								
	
g pol_local_dummy = (mention_pol_local_pershow>0) if mention_pol_local_pershow !=.
g pol_stateleg_dummy = (mention_pol_stateleg_pershow>0) if mention_pol_stateleg_pershow !=.
g pol_congress_dummy = (mention_pol_congress_pershow>0) if mention_pol_congress_pershow !=.

eststo clear

// 1. SELECTED CONTROLS, DID
eststo: reghdfe mention_pol_local_pershow		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA ///
												station_ownedby_gray_LMA ///
												, ///
												absorb(stationID date c.($station_controls)##i.date) cluster(dma)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 			"\checkmark"
qui estadd local monthFE  			"\checkmark"
qui estadd local dmamonthFE			""
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

// 2. SELECTED CONTROLS, TRIPLE DIFF
eststo: reghdfe mention_pol_local_pershow		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA ///
												station_ownedby_gray_LMA ///
												, ///
												absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dma)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 			"\checkmark"
qui estadd local monthFE  			""
qui estadd local dmamonthFE			"\checkmark"
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

// 3. SELECTED CONTROLS, DID
eststo: reghdfe mention_pol_stateleg_pershow		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA ///
													station_ownedby_gray_LMA ///
													, ///
													absorb(stationID date c.($station_controls)##i.date) cluster(dma)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 			"\checkmark"
qui estadd local monthFE  			"\checkmark"
qui estadd local dmamonthFE			""
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

// 4. SELECTED CONTROLS, TRIPLE DIFF
eststo: reghdfe mention_pol_stateleg_pershow 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA ///
													station_ownedby_gray_LMA ///
													, ///
													absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dma)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 			"\checkmark"
qui estadd local monthFE  			""
qui estadd local dmamonthFE			"\checkmark"
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

// 5. SELECTED CONTROLS, DID
eststo: reghdfe mention_pol_congress_pershow		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA ///
													station_ownedby_gray_LMA ///
													, ///
													absorb(stationID date c.($station_controls)##i.date) cluster(dma)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 			"\checkmark"
qui estadd local monthFE  			"\checkmark"
qui estadd local dmamonthFE			""
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

// 6. SELECTED CONTROLS, TRIPLE DIFF
eststo: reghdfe mention_pol_congress_pershow		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA ///
													station_ownedby_gray_LMA ///
													, ///
													absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dma)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 			"\checkmark"
qui estadd local monthFE  			""
qui estadd local dmamonthFE			"\checkmark"
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

esttab, nogaps keep(station_ownedby_*)  ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle ///
		mgroups("Mayors" "State Legislators" "Members of the House", pattern(1 0 1 0 1 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(stationFE monthFE dmamonthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray  pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs" "DMA-By-Month FEs" "Controls"  "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray")) 

esttab using tables/content_additional_outcomes.tex, replace nogaps keep(station_ownedby_*)  ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle ///
		mgroups("Mayors" "State Legislators"  "House Representatives", pattern(1 0 1 0 1 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(stationFE monthFE dmamonthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray  pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs" "DMA-By-Month FEs" "Controls"  "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray")) 

					
/////////////
// TABLE 3 //					
/////////////

use data/adintel/adintel_clean_updated.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

drop if year==2010
drop if year==2020

eststo clear

// 1. DURATION

eststo: reghdfe log_duration_perHH_news 	station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA, ///
											absorb(stationID date) cluster(dma)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		"\checkmark"
qui estadd local dmamonthFE		""
qui estadd local controls		""
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe log_duration_perHH_news		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dma)
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

eststo: reghdfe log_duration_perHH_news		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA, ///
											absorb(stationID date##dmacode) cluster(dma)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		""
qui estadd local dmamonthFE		"\checkmark"
qui estadd local controls 		""
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe log_duration_perHH_news		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dma)
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

eststo: reghdfe log_spend_perHH_news 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA, ///
											absorb(stationID date ) cluster(dma)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		"\checkmark"
qui estadd local dmamonthFE		""
qui estadd local controls		""
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe log_spend_perHH_news 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dma)
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

eststo: reghdfe log_spend_perHH_news 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA, ///
											absorb(stationID date##dmacode) cluster(dma)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		""
qui estadd local dmamonthFE		"\checkmark"
qui estadd local controls 		""
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe log_spend_perHH_news 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dma)
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
		mgroups("Log Duration" "Log Revenues", pattern(1 0 0 0 1 0 0 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(stationFE monthFE  dmamonthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray  pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs"  "DMA-By-Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray" )) 

esttab using tables/adintel_main.tex, replace nogaps keep(station_ownedby_*) ///
		noomitted nonotes se(%9.3f) b(%9.3f) nomtitles ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) ///
		mgroups("Log Duration" "Log Revenue", pattern(1 0 0 0 1 0 0 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(stationFE monthFE  dmamonthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray  pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs"  "DMA-By-Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray" )) 
	



/////////////
// TABLE 4 //					
/////////////

use data/adintel/adintel_clean_updated.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

drop if year==2010
drop if year==2020

eststo clear

eststo: reghdfe rating_total_news			station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date) cluster(dma)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		"\checkmark"
qui estadd local dmamonthFE		""
qui estadd local controls		""
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe rating_total_news			station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date  c.($station_controls)##i.date) cluster(dma)
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


eststo: reghdfe rating_total_news 			station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date##dmacode) cluster(dma)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		""
qui estadd local dmamonthFE		"\checkmark"
qui estadd local controls		""
test station_ownedby_sinclair_LMA = station_ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_LMA = station_ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_LMA = station_ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe rating_total_news 			station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date##dmacode  c.($station_controls)##i.date) cluster(dma)
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

eststo: reghdfe log_imp_total_news			station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date) cluster(dma)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		"\checkmark"
qui estadd local dmamonthFE		""
qui estadd local controls		""
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
											absorb(stationID date  c.($station_controls)##i.date) cluster(dma)
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


eststo: reghdfe log_imp_total_news			station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date##dmacode) cluster(dma)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		""
qui estadd local dmamonthFE		"\checkmark"
qui estadd local controls		""
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
											absorb(stationID date##dmacode  c.($station_controls)##i.date) cluster(dma)
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
		mgroups("News Ratings" "Log Impressions", pattern(1 0 0 0 1 0 0 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(stationFE monthFE dmamonthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray  pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f  %9.0f  %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs" "DMA-By-Month FEs" "Controls"  "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray" )) 

esttab using tables/ratings_main.tex, replace booktabs nogaps keep(station_ownedby_*)   ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle ///
		mgroups("News Ratings" "Log Impressions", pattern(1 0 0 0 1 0 0 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(stationFE monthFE dmamonthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray  pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f  %9.0f  %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs" "DMA-By-Month FEs" "Controls"  "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray" )) 

/////////////
// TABLE 5 // 
/////////////

use data/CCES/CCES_final.dta, clear

* Note: new versions without weights and with, SEPARATELY, dma FEs and cd_by_redistricting FEs (and including TRIBUNE) 

eststo clear

eststo: reghdfe recog_houserep_never_heardbroad 	ownedby_sinclair_LMA ///
													ownedby_nexstar_LMA ownedby_gray_LMA  ///
													$controls_CCES , ///
													absorb(dmacode cdID##redistricting  year) cluster(dma)
											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique cdID if e(sample)==1
qui scalar N_cds =  `r(unique)'
qui estadd scalar N_cds 
qui estadd local dmaFE 				"\checkmark"
qui estadd local cd_by_redist_FE    "\checkmark"
qui estadd local yearFE				"\checkmark"
qui estadd local controls			"\checkmark"
test ownedby_sinclair_LMA = ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test ownedby_sinclair_LMA = ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test ownedby_nexstar_LMA = ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

eststo: reghdfe dontknow_approval_housemember 	ownedby_sinclair_LMA ///
												ownedby_gray_LMA ownedby_nexstar_LMA ///
												$controls_CCES , ///
												absorb(dmacode cdID##redistricting year) cluster(dma)
											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique cdID if e(sample)==1
qui scalar N_cds =  `r(unique)'
qui estadd scalar N_cds 
qui estadd local dmaFE		"\checkmark"
qui estadd local cd_by_redist_FE    "\checkmark"
qui estadd local yearFE				"\checkmark"
qui estadd local controls			"\checkmark"
test ownedby_sinclair_LMA = ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test ownedby_sinclair_LMA = ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test ownedby_nexstar_LMA = ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

	
eststo: reghdfe no_prefencehouse 	ownedby_sinclair_LMA ///
											ownedby_gray_LMA ownedby_nexstar_LMA ///
											$controls_CCES , ///
											absorb(dmacode cdID##redistricting  year) cluster(dma)

qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique cdID if e(sample)==1
qui scalar N_cds =  `r(unique)'
qui estadd scalar N_cds 
qui estadd local dmaFE 				"\checkmark"
qui estadd local cd_by_redist_FE    "\checkmark"
qui estadd local yearFE				"\checkmark"
qui estadd local controls			"\checkmark"
test ownedby_sinclair_LMA = ownedby_nexstar_LMA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test ownedby_sinclair_LMA = ownedby_gray_LMA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test ownedby_nexstar_LMA = ownedby_gray_LMA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 


esttab, replace nogaps keep(ownedby_*)  ///
				noomitted nonotes se(%9.3f) b(%9.3f) nomtitle  ///
				label starlevels(* 0.10 ** 0.05 *** 0.01) ///
				mgroups("\shortstack{Never Heard of\\Representative}" "\shortstack{Not Able to Evaluate\\Representative}" "\shortstack{Has No Preference\\over Election}", pattern(1 0 1 0 1 0) ///
				prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
				compress ///
				stats(dmaFE cd_by_redist_FE yearFE  controls N N_cds N_clust ymean ///
					  pvalue_sinclair_nexstar pvalue_sinclair_gray pvalue_nexstar_gray, ///
					  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
					  labels("dma FE" "CD-By-Redistricting Cycle FEs" "Year FEs" "Controls" "\midrule Observations" "CDs" "DMAs (Clusters)" ///
							"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray")) 

esttab using tables/CCES_unweightednew.tex, replace nogaps keep(ownedby_*)  ///
				noomitted nonotes se(%9.3f) b(%9.3f) nomtitle  ///
				label starlevels(* 0.10 ** 0.05 *** 0.01) ///
				mgroups("\shortstack{Never Heard of\\Representative}" "\shortstack{Not Able to Evaluate\\Representative}" "\shortstack{Has No Preference\\over Election}", pattern(1 1 1) ///
				prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
				compress ///
				stats(dmaFE cd_by_redist_FE yearFE  controls N N_clust ymean ///
					  pvalue_sinclair_nexstar pvalue_sinclair_gray pvalue_nexstar_gray, ///
					  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
					  labels("DMA FE" "CD-By-Redistricting Cycle FEs" "Year FEs" "Controls" "\midrule Observations" "DMAs (Clusters)" ///
							"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray")) 


/////////////
// TABLE 6 //
/////////////

// PANEL A
	  
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
g dummy=(mentions_pol_congress_pershow>0) if mentions_pol_congress_pershow!=.
		
label var high_congruence  "High"

// RUNS THE REGRESSIONS

eststo clear

eststo: reghdfe dummy 							high_congruence, ///
												cluster(dmacode) absorb(date stationID c.($station_controls)##i.date)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui unique cdID if e(sample)==1
qui scalar N_CDs =  `r(unique)'
qui estadd scalar N_CDs 
qui estadd local monthFE			"\checkmark"
qui estadd local stationFE			"\checkmark"
qui estadd local cdFE				""
qui estadd local controls			"\checkmark"

eststo: reghdfe dummy 							high_congruence, cluster(dmacode) ///
												absorb(date stationID c.($station_controls)##i.date cdID)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui unique cdID if e(sample)==1
qui scalar N_CDs =  `r(unique)'
qui estadd scalar N_CDs 
qui estadd local monthFE			"\checkmark"
qui estadd local stationFE			"\checkmark"
qui estadd local cdFE				"\checkmark"
qui estadd local controls			"\checkmark"

esttab using tables/congruence_unweightedF.tex, replace fragment nogaps keep(high_congruence)  ///
				coeflabels(high_congruence "Above Median Congruence") ///
		label noomitted nonotes se(%9.3f) b(%9.3f) ///
		starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle extracols(3 4 5 6) ///
		prehead("{\def \sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{7}{c}} \toprule  \ & \multicolumn{6}{c}{Panel A: Content} \\\cmidrule(lr){2-7}") ///
		mgroups("Mentions/Show", pattern(1 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(stationFE cdFE monthFE  ////
			  controls N N_stations N_CDs N_clust ymean ///
			  , ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "CD FEs" "Month FEs" "Controls" "\midrule Observations" "Stations" "CDs" "DMAs (Clusters)" ///
					"Mean Dep. Variable")) 


// PANEL B

use data/CCES/CCES_final.dta, clear


eststo clear


eststo: reghdfe recog_houserep_never_heardbroad	above_median ///
									$controls_CCES , ///
									absorb(dma year) cluster(dma)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean = r(mean)
qui estadd scalar ymean
qui unique cdID if e(sample)==1
qui scalar N_cds = r(unique)
qui estadd scalar N_cds
qui estadd local dmaFE "\checkmark"
qui estadd local yearFE "\checkmark"
qui estadd local controls "\checkmark"
qui estadd local CD_by_redist_FEs ""


eststo: reghdfe recog_houserep_never_heardbroad	above_median ///
									$controls_CCES , ///
									absorb(dma cdID##redistricting year) cluster(dma)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean = r(mean)
qui estadd scalar ymean
qui unique cdID if e(sample)==1
qui scalar N_cds = r(unique)
qui estadd scalar N_cds
qui estadd local dmaFE 					"\checkmark"
qui estadd local yearFE 				"\checkmark"
qui estadd local controls 				"\checkmark"
qui estadd local CD_by_redist_FEs 		"\checkmark"

eststo: reghdfe dontknow_approval_housemember	above_median ///
									$controls_CCES , ///
									absorb(dma year) cluster(dma)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean = r(mean)
qui estadd scalar ymean
qui unique cdID if e(sample)==1
qui scalar N_cds = r(unique)
qui estadd scalar N_cds
qui estadd local dmaFE 					"\checkmark"
qui estadd local yearFE				 	"\checkmark"
qui estadd local controls 				"\checkmark"
qui estadd local CD_by_redist_FEs ""

eststo: reghdfe dontknow_approval_housemember	above_median ///
									$controls_CCES , ///
									absorb(dma cdID##redistricting year) cluster(dma)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean = r(mean)
qui estadd scalar ymean
qui unique cdID if e(sample)==1
qui scalar N_cds = r(unique)
qui estadd scalar N_cds
qui estadd local dmaFE 					"\checkmark"
qui estadd local yearFE 				"\checkmark"
qui estadd local controls 				"\checkmark"
qui estadd local CD_by_redist_FEs 		"\checkmark"
		
eststo: reghdfe no_prefencehouse	above_median ///
									$controls_CCES , ///
									absorb(dma year) cluster(dma)
	qui su `e(depvar)' if e(sample)==1
	qui scalar ymean = r(mean)
	qui estadd scalar ymean
	qui unique cdID if e(sample)==1
	qui scalar N_cds = r(unique)
	qui estadd scalar N_cds
	qui estadd local dmaFE 					"\checkmark"
	qui estadd local yearFE 				"\checkmark"
	qui estadd local controls 				"\checkmark"
	qui estadd local CD_by_redist_FEs 			""

eststo: reghdfe no_prefencehouse	above_median ///
									$controls_CCES , ///
									absorb(dma cdID##redistricting year) cluster(dma)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean = r(mean)
qui estadd scalar ymean
qui unique cdID if e(sample)==1
qui scalar N_cds = r(unique)
qui estadd scalar N_cds
qui estadd local dmaFE 							"\checkmark"
qui estadd local yearFE 						"\checkmark"
qui estadd local controls 						"\checkmark"
qui estadd local CD_by_redist_FEs 				"\checkmark"


esttab using tables/congruence_unweightedF.tex, append fragment nogaps keep(above_median) ///
    coeflabels(above_median "Above Median Congruence") ///
    noomitted nonotes se(%9.3f) b(%9.3f) nomtitle ///
    label starlevels(* 0.10 ** 0.05 *** 0.01) ///
    mgroups("\shortstack{Never Heard of\\Representative}" ///
            "\shortstack{Not Able to Evaluate\\Representative}" ///
            "\shortstack{Has No Preference\\over Election}", ///
            pattern(1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) ///
            suffix(}) span erepeat(\cmidrule(lr){@span})) ///
    prehead("\midrule \ & \multicolumn{6}{c}{Panel B: Political Knowledge} \\\cmidrule(lr){2-7}") ///
    postfoot("\bottomrule \end{tabular}}") ///
    compress ///
    stats(dmaFE yearFE controls CD_by_redist_FEs N N_cds N_clust ymean, ///
          fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f) ///
          labels("DMA FEs" "Year FEs" "Controls" "CD_by_redist FEs" ///
                 "\midrule Observations" "CDs" "DMAs (Clusters)" "Mean Dep. Variable"))

























			