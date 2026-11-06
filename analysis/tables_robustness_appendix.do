///////////////////////////////////////////////////
// CREATES TABLES IN THE ROBUSTENSS APPENDIX     //
///////////////////////////////////////////////////

clear all
	
///////////////////////
///////////////////////
// APPENDIX TABLE F1 //
///////////////////////
///////////////////////

use data/harmony/content_cleaned.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

g insample = (_m==3)
drop if _m==2
drop _merge

cap drop tag
egen tag=tag(stationID)								

g log_mention_place_total = log(mention_place)

// TRIPLE DIFF

eststo clear

// 1. BASELINE
eststo: reghdfe mention_place_pershow 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA ///
											station_ownedby_gray_LMA ///
											if insample==1, ///
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

// 2. WINSORIZED
eststo: reghdfe mention_place_pershow_w99	station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA ///
											station_ownedby_gray_LMA ///
											if insample==1, ///
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

// 3. LOG MENTIONS
eststo: reghdfe log_mention_place_total		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA ///
											station_ownedby_gray_LMA ///
											if insample==1, ///
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

// 4. PPLM COUNTS
eststo: ppmlhdfe mention_place				station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA ///
											station_ownedby_gray_LMA ///
											c.($station_controls)#i.date ///
											if insample==1, ///
											absorb(stationID date) cluster(dmacode)
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

// 5. PER WORD
eststo: reghdfe mention_place_perword 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA ///
											station_ownedby_gray_LMA ///
											if insample==1, ///
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

// 6. FULL SAMPLE (NO CONTROLS)
eststo: reghdfe mention_place_pershow 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
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

// 7. BALANCED SAMPLE
eststo: reghdfe mention_place_pershow 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA ///
											station_ownedby_gray_LMA ///
											if insample==1&balanced_sample==1, ///
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

// 7. O&O
eststo: reghdfe mention_place_pershow 		station_ownedby_sinclair_OO station_ownedby_nexstar_OO  ///
											station_ownedby_gray_OO ///
											if insample==1, ///
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
test station_ownedby_sinclair_OO = station_ownedby_nexstar_OO
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_OO = station_ownedby_gray_OO
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_OO = station_ownedby_gray_OO
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 


// 8. INCLUDES SSA
eststo: reghdfe mention_place_pershow 		station_ownedby_sinclair_SSA station_ownedby_nexstar_SSA ///
											station_ownedby_gray_SSA ///
											if insample==1, ///
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
test station_ownedby_sinclair_SSA = station_ownedby_nexstar_SSA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_SSA = station_ownedby_gray_SSA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_SSA = station_ownedby_gray_SSA
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
		label starlevels(* 0.10 ** 0.05 *** 0.01)  nomtitle nonumber ///
		mlabels(" " "Winsor." "Mentions" "Mentions" "Mentions/" "Balanced" "O\&O" "SSA/JSA \\ \ & \ & \  & (Log) & (Poisson) & Word*100 & \ & \ & \ \\ \  & (1) & (2) & (3) & (4) & (5) & (6)  & (7)  & (8)") ///
		mgroups("Baseline" "Outcome" "Sample" "Treatment", pattern(1 1 0 0 0 1 0 1 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span)	///
		posthead("\ & \multicolumn{8}{c}{Panel A: Differences-in-Differences}") ///
		compress ///					
		stats(stationFE monthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar  pvalue_sinclair_gray pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray")) 
					
esttab using tables/content_robustness.tex, replace nogaps keep(station_ownedby_*)   ///
		fragment ///
		rename(	station_ownedby_sinclair_SSA station_ownedby_sinclair_LMA ///
				station_ownedby_gray_SSA station_ownedby_gray_LMA ///
				station_ownedby_nexstar_SSA station_ownedby_nexstar_LMA ///
				station_ownedby_sinclair_OO station_ownedby_sinclair_LMA ///
				station_ownedby_gray_OO station_ownedby_gray_LMA ///
				station_ownedby_nexstar_OO station_ownedby_nexstar_LMA ///
				) ///
		prehead("{\def \sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{10}{c}} \toprule") ///
		posthead("\midrule \ & \multicolumn{9}{c}{Panel A: Differences-in-Differences} \\\cmidrule(lr){2-10}") ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01)  nomtitle nonumber ///
		mlabels(" " "Winsor." "Mentions" "Mentions" "Mentions/" "Full" "Balanced" "O\&O" "SSA/JSA \\ \ & \ & \ & (Log) & (Poisson) & Word*100  & \ & \ & \ & \ \\ \  & (1) & (2) & (3) & (4) & (5) & (6)  & (7)  & (8) & (9)") ///
		mgroups("Baseline" "Outcome" "Sample" "Treatment", pattern(1 1 0 0 0 1 0 1 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(stationFE monthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar  pvalue_sinclair_gray pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray")) 
	
// TRIPLE DIFF

eststo clear

// 1. BASELINE
eststo: reghdfe mention_place_pershow 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA ///
											station_ownedby_gray_LMA ///
											if insample==1, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
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

// 2. WINSORIZED
eststo: reghdfe mention_place_pershow_w99	station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA ///
											station_ownedby_gray_LMA ///
											if insample==1, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
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

// 3. LOG MENTIONS
eststo: reghdfe log_mention_place_total		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA ///
											station_ownedby_gray_LMA ///
											if insample==1, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
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

// 4. PPLM COUNTS
eststo: ppmlhdfe mention_place				station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA ///
											station_ownedby_gray_LMA ///
											c.($station_controls)#i.date ///
											if insample==1, ///
											absorb(stationID date##dmacode) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
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

// 5. PER WORD
eststo: reghdfe mention_place_perword 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA ///
											station_ownedby_gray_LMA ///
											if insample==1, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
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

// 6. ALL STATIONS
eststo: reghdfe mention_place_pershow 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA ///
											station_ownedby_gray_LMA  ///
											, ///
											absorb(stationID date##dmacode) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
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

// 6. ALL STATIONS
eststo: reghdfe mention_place_pershow 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA ///
											station_ownedby_gray_LMA  ///
											if insample==1&balanced_sample==1, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
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

// 7. O&O
eststo: reghdfe mention_place_pershow 		station_ownedby_sinclair_OO station_ownedby_nexstar_OO  ///
											station_ownedby_gray_OO ///
											if insample==1, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local dmamonthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_OO = station_ownedby_nexstar_OO
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_OO = station_ownedby_gray_OO
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_OO = station_ownedby_gray_OO
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 


// 8. INCLUDES SSA
eststo: reghdfe mention_place_pershow 		station_ownedby_sinclair_SSA station_ownedby_nexstar_SSA  ///
											station_ownedby_gray_SSA ///
											if insample==1, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local dmamonthFE		"\checkmark"
qui estadd local controls		"\checkmark"
test station_ownedby_sinclair_SSA = station_ownedby_nexstar_SSA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_SSA = station_ownedby_gray_SSA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_SSA = station_ownedby_gray_SSA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

esttab, nogaps keep(station_ownedby_*)   ///
		rename(	station_ownedby_sinclair_SSA station_ownedby_sinclair_LMA ///
				station_ownedby_gray_SSA station_ownedby_gray_LMA ///
				station_ownedby_nexstar_SSA station_ownedby_nexstar_LMA ///
				station_ownedby_sinclair_OO station_ownedby_sinclair_LMA ///
				station_ownedby_gray_OO station_ownedby_gray_LMA ///
				station_ownedby_nexstar_OO station_ownedby_nexstar_LMA ///
				) ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle nonumbers ///
		posthead("\midrule \ & \multicolumn{8}{c}{Panel B: Within-Market Differences-in-Differences} \\") ///
		compress ///
		stats(stationFE dmamonthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar  pvalue_sinclair_gray pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "DMA-By-Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray")) 
					
esttab using tables/content_robustness.tex, fragment append nogaps keep(station_ownedby_*)  ///
		rename(	station_ownedby_sinclair_SSA station_ownedby_sinclair_LMA ///
				station_ownedby_gray_SSA station_ownedby_gray_LMA ///
				station_ownedby_nexstar_SSA station_ownedby_nexstar_LMA ///
				station_ownedby_sinclair_OO station_ownedby_sinclair_LMA ///
				station_ownedby_gray_OO station_ownedby_gray_LMA ///
				station_ownedby_nexstar_OO station_ownedby_nexstar_LMA ///
				) ///
		noomitted nonotes se(%9.3f) b(%9.3f) label ///
		posthead("\midrule \ & \multicolumn{9}{c}{Panel B: Within-Market Differences-in-Differences} \\\cmidrule(lr){2-10}") ///
		postfoot("\bottomrule \end{tabular}}") ///
		 starlevels(* 0.10 ** 0.05 *** 0.01)  nomtitle nonumbers ///
		compress ///
		stats(stationFE dmamonthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar  pvalue_sinclair_gray pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "DMA-By-Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray")) 

			  

///////////////////////
///////////////////////
// APPENDIX TABLE F2 //
///////////////////////
///////////////////////

use data/adintel/adintel_clean_updated.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

g insample = (_m==3)
drop if _m==2
drop _merge

drop if year==2010
drop if year==2020

// winsorized mentions
cap drop log_duration_perHH_news_w99
cap drop duration_perHH_news_w99
g duration_perHH_news_w99 = duration_perHH_news
su duration_perHH_news_w99, d
replace duration_perHH_news_w99=`r(p99)' if duration_perHH_news_w99>`r(p99)'&duration_perHH_news_w99!=.
g log_duration_perHH_news_w99 = log(duration_perHH_news_w99)

// BALANCED SAMPLE
cap drop N
cap drop balanced_sample
egen N = total(!missing(duration_perHH_news) & !missing(duration_perHH_news)), by(stationID)
tab N
g balanced_sample=(N==108)
drop N

// DIFF-IN-DIFF

eststo clear

// 1. BASELINE

eststo: reghdfe log_duration_perHH_news		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if insample==1, ///
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
		
// 2. WINS

eststo: reghdfe log_duration_perHH_news_w99	station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if insample==1, ///
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

		
// 3. LEVEL

eststo: reghdfe duration_perHH_news			station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if insample==1, ///
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


// 4. BALANCED SAMPLE

eststo: reghdfe log_duration_perHH_news		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		"\checkmark"
qui estadd local dmamonthFE		""
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


// 4. BALANCED SAMPLE

eststo: reghdfe log_duration_perHH_news		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if balanced_sample==1&insample==1, ///
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

// 6. DROPS POST 2018

eststo: reghdfe log_duration_perHH_news		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if year<2018&insample==1, ///
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
				
// 7. TMT OO
		
eststo: reghdfe log_duration_perHH_news 	station_ownedby_sinclair_OO station_ownedby_nexstar_OO  ///
											station_ownedby_gray_OO ///
											if insample==1, ///
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
test station_ownedby_sinclair_OO = station_ownedby_nexstar_OO
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_OO = station_ownedby_gray_OO
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_OO = station_ownedby_gray_OO
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 		

// 8. TMT SSA
		
eststo: reghdfe log_duration_perHH_news		station_ownedby_sinclair_SSA station_ownedby_gray_SSA ///
											station_ownedby_nexstar_SSA ///
											if insample==1, ///
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
test station_ownedby_sinclair_SSA = station_ownedby_nexstar_SSA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_SSA = station_ownedby_gray_SSA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_SSA = station_ownedby_gray_SSA
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
		noomitted nonotes se(%9.3f) b(%9.3f) nonumbers ///
		mlabels(" " "Winsor." "Levels" "Full" "Balanced" "Pre-2018" "O\&O" "SSA/JSA \\ \ & (1) & (2) & (3) & (4) & (5) & (6) & (7) & (8)") ///
		label starlevels(* 0.10 ** 0.05 *** 0.01)  ///
		mgroups("Baseline" "Outcome" "Sample" "Treatment", pattern(1 1 0 1 0 0 1 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		stats(stationFE monthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray    pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray" )) 
					
esttab using tables/adintel_robustness.tex, replace nogaps keep(station_ownedby_*)   ///
		fragment /// 
		prehead("{\def \sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{9}{c}} \toprule") ///
		posthead("\midrule \ & \multicolumn{8}{c}{Panel A: Differences-in-Differences} \\\cmidrule(lr){2-9}") ///
		rename(	station_ownedby_sinclair_SSA station_ownedby_sinclair_LMA ///
				station_ownedby_gray_SSA station_ownedby_gray_LMA ///
				station_ownedby_nexstar_SSA station_ownedby_nexstar_LMA ///
				station_ownedby_sinclair_OO station_ownedby_sinclair_LMA ///
				station_ownedby_gray_OO station_ownedby_gray_LMA ///
				station_ownedby_nexstar_OO station_ownedby_nexstar_LMA ///
				) ///
		noomitted nonotes se(%9.3f) b(%9.3f) nonumbers ///
		mlabels(" " "Winsor." "Levels" "Full" "Balanced" "Pre-2018" "O\&O" "SSA/JSA \\ \ & (1) & (2) & (3) & (4) & (5) & (6) & (7) & (8)") ///
		label starlevels(* 0.10 ** 0.05 *** 0.01)  ///
		mgroups("Baseline" "Outcome" "Sample" "Treatment", pattern(1 1 0 1 0 0 1 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		stats(stationFE monthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray    pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray" )) 


// TRIPLE DIFF

eststo clear

// 1. BASELINE

eststo: reghdfe log_duration_perHH_news 	station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if insample==1, ///
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
		
// 2. WINS

eststo: reghdfe log_duration_perHH_news_w99	station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if insample==1, ///
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

		
// 3. LEVELS

eststo: reghdfe duration_perHH_news			station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if insample==1, ///
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

// 4. FULL SAMPLE
eststo: reghdfe log_duration_perHH_news		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date##dmacode) cluster(dmacode)
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

// 5. BALANCED SAMPLE
eststo: reghdfe log_duration_perHH_news		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if balanced_sample==1&insample==1, ///
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

// 6. DROPS POST 2018
eststo: reghdfe log_duration_perHH_news 	station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if year<2018&insample==1, ///
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
		
// 7. TMT OO	
eststo: reghdfe log_duration_perHH_news 	station_ownedby_sinclair_OO station_ownedby_nexstar_OO  ///
											station_ownedby_gray_OO ///
											if insample==1, ///
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
test station_ownedby_sinclair_OO = station_ownedby_nexstar_OO
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_OO = station_ownedby_gray_OO
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_OO = station_ownedby_gray_OO
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 		

// 8. TMT SSA	
eststo: reghdfe log_duration_perHH_news 	station_ownedby_sinclair_SSA station_ownedby_nexstar_SSA  ///
											station_ownedby_gray_SSA ///
											if insample==1, ///
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
test station_ownedby_sinclair_SSA = station_ownedby_nexstar_SSA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_SSA = station_ownedby_gray_SSA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_SSA = station_ownedby_gray_SSA
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
		noomitted nonotes se(%9.3f) b(%9.3f) nonumbers ///
		mlabels(" " "Winsor." "Levels" "Balanced" "Pre-2018" "O\&O" "SSA/JSA \\ \ & (1) & (2) & (3) & (4) & (5) & (6)  & (7) & (8)") ///
		label starlevels(* 0.10 ** 0.05 *** 0.01)  ///
		mgroups("Baseline" "Outcome" "Sample" "Treatment", pattern(1 1 1 0 1 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		stats(stationFE dmamonthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray    pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "DMA-By-Month FEs" "Controls"  "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray" )) 
					
esttab using tables/adintel_robustness.tex, fragment append nogaps keep(station_ownedby_*)  ///
		rename(	station_ownedby_sinclair_SSA station_ownedby_sinclair_LMA ///
				station_ownedby_gray_SSA station_ownedby_gray_LMA ///
				station_ownedby_nexstar_SSA station_ownedby_nexstar_LMA ///
				station_ownedby_sinclair_OO station_ownedby_sinclair_LMA ///
				station_ownedby_gray_OO station_ownedby_gray_LMA ///
				station_ownedby_nexstar_OO station_ownedby_nexstar_LMA ///
				) ///
		label noomitted nonotes se(%9.3f) b(%9.3f) nomtitle nonumbers starlevels(* 0.10 ** 0.05 *** 0.01) ///
		posthead("\midrule \ & \multicolumn{8}{c}{Panel B: Within-Market Differences-in-Differences} \\\cmidrule(lr){2-9}") ///
		postfoot("\bottomrule \end{tabular}}") ///
		stats(stationFE dmamonthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray    pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "DMA-By-Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray" )) 






	

///////////////////////
///////////////////////
// APPENDIX TABLE F3 //
///////////////////////
///////////////////////

use data/adintel/adintel_clean_updated.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

g insample = (_m==3)
drop if _m==2
drop _merge

drop if year==2010
drop if year==2020

// winsorized mentions
g spend_perHH_news_w99=spend_perHH_news
su spend_perHH_news_w99, d
replace spend_perHH_news_w99=`r(p99)' if spend_perHH_news_w99>`r(p99)'&spend_perHH_news_w99!=.
g log_spend_perHH_news_w99 = log(spend_perHH_news_w99)

// BALANCED SAMPLE
cap drop N
cap drop balanced_sample
egen N = total(!missing(duration_perHH_news) & !missing(duration_perHH_news)), by(stationID)
tab N
g balanced_sample=(N==108)
drop N

		
// DIFF-IN-DIFF 

eststo clear

// 1. BASELINE

eststo: reghdfe log_spend_perHH_news 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if insample==1, ///
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
		
// 2. WINS

eststo: reghdfe log_spend_perHH_news_w99	station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if insample==1, ///
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
		
// 3. WINS
eststo: reghdfe spend_perHH_news			station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if insample==1, ///
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

// 4. FULL SAMPLE
eststo: reghdfe log_spend_perHH_news		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE  		"\checkmark"
qui estadd local dmamonthFE		""
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

// 5. FULL SAMPLE
eststo: reghdfe log_spend_perHH_news		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if balanced_sample==1&insample==1, ///
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

// 6. DROPS POST 2018
eststo: reghdfe log_spend_perHH_news 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if year<2018&insample==1, ///
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
		
		
// 7. TMT OO	
eststo: reghdfe log_spend_perHH_news 		station_ownedby_sinclair_OO station_ownedby_nexstar_OO  ///
											station_ownedby_gray_OO ///
											if insample==1, ///
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
test station_ownedby_sinclair_OO = station_ownedby_nexstar_OO
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_OO = station_ownedby_gray_OO
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_OO = station_ownedby_gray_OO
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 		

// 8. TMT SSA	
eststo: reghdfe log_spend_perHH_news 		station_ownedby_sinclair_SSA station_ownedby_nexstar_SSA  ///
											station_ownedby_gray_SSA ///
											if insample==1, ///
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
test station_ownedby_sinclair_SSA = station_ownedby_nexstar_SSA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_SSA = station_ownedby_gray_SSA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_SSA = station_ownedby_gray_SSA
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
		noomitted nonotes se(%9.3f) b(%9.3f) nonumbers ///
		mlabels(" " "Winsor." "Levels" "Full" "Balanced" "Pre-2018" "O\&O" "SSA/JSA \\ \ & (1) & (2) & (3) & (4) & (5) & (6) & (7) & (8)") ///
		label starlevels(* 0.10 ** 0.05 *** 0.01)  ///
		mgroups("Baseline" "Outcome" "Sample" "Treatment", pattern(1 1 0 1 0 0 1 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		stats(stationFE monthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray    pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray" )) 
					
esttab using tables/adintel_robustness_spending.tex, replace nogaps keep(station_ownedby_*)   ///
		fragment /// 
		prehead("{\def \sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{9}{c}} \toprule") ///
		posthead("\midrule \ & \multicolumn{8}{c}{Panel A: Differences-in-Differences} \\\cmidrule(lr){2-9}") ///
		rename(	station_ownedby_sinclair_SSA station_ownedby_sinclair_LMA ///
				station_ownedby_gray_SSA station_ownedby_gray_LMA ///
				station_ownedby_nexstar_SSA station_ownedby_nexstar_LMA ///
				station_ownedby_sinclair_OO station_ownedby_sinclair_LMA ///
				station_ownedby_gray_OO station_ownedby_gray_LMA ///
				station_ownedby_nexstar_OO station_ownedby_nexstar_LMA ///
				) ///
		noomitted nonotes se(%9.3f) b(%9.3f) nonumbers ///
		mlabels(" " "Winsor." "Levels" "Full" "Balanced" "Pre-2018" "O\&O" "SSA/JSA \\ \ & (1) & (2) & (3) & (4) & (5) & (6) & (7) & (8)") ///
		label starlevels(* 0.10 ** 0.05 *** 0.01)  ///
		mgroups("Baseline" "Outcome" "Sample" "Treatment", pattern(1 1 0 1 0 0 1 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		stats(stationFE monthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray    pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray" )) 

		
// TRIPLE DIFF 

eststo clear

// 1. BASELINE

eststo: reghdfe log_spend_perHH_news 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if insample==1, ///
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
		
// 2. WINS

eststo: reghdfe log_spend_perHH_news_w99	station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if insample==1, ///
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
		
// 3. WINS
eststo: reghdfe spend_perHH_news			station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if insample==1, ///
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

// 4. FULL SAMPLE
eststo: reghdfe log_spend_perHH_news		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date##dmacode) cluster(dmacode)
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

// 5. FULL SAMPLE
eststo: reghdfe log_spend_perHH_news		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if balanced_sample==1&insample==1, ///
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

// 6. DROPS POST 2018
eststo: reghdfe log_spend_perHH_news 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if year<2018&insample==1, ///
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
				
// 7. TMT OO	
eststo: reghdfe log_spend_perHH_news 		station_ownedby_sinclair_OO station_ownedby_nexstar_OO  ///
											station_ownedby_gray_OO ///
											if insample==1, ///
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
test station_ownedby_sinclair_OO = station_ownedby_nexstar_OO
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_OO = station_ownedby_gray_OO
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_OO = station_ownedby_gray_OO
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 		

// 8. TMT SSA	
eststo: reghdfe log_spend_perHH_news 		station_ownedby_sinclair_SSA station_ownedby_nexstar_SSA  ///
											station_ownedby_gray_SSA ///
											if insample==1, ///
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
test station_ownedby_sinclair_SSA = station_ownedby_nexstar_SSA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_SSA = station_ownedby_gray_SSA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_SSA = station_ownedby_gray_SSA
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
		noomitted nonotes se(%9.3f) b(%9.3f) nonumbers ///
		mlabels(" " "Winsor." "Balanced" "Pre-2018" "O\&O" "SSA/JSA \\ \ & (1) & (2) & (3) & (4) & (5) & (6)") ///
		label starlevels(* 0.10 ** 0.05 *** 0.01)  ///
		mgroups("Baseline" "Outcome" "Sample" "Treatment", pattern(1 1 1 0 1 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		stats(stationFE dmamonthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray    pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "DMA-By-Month FEs" "Controls"  "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray" )) 
					
esttab using tables/adintel_robustness_spending.tex, fragment append nogaps keep(station_ownedby_*)  ///
		rename(	station_ownedby_sinclair_SSA station_ownedby_sinclair_LMA ///
				station_ownedby_gray_SSA station_ownedby_gray_LMA ///
				station_ownedby_nexstar_SSA station_ownedby_nexstar_LMA ///
				station_ownedby_sinclair_OO station_ownedby_sinclair_LMA ///
				station_ownedby_gray_OO station_ownedby_gray_LMA ///
				station_ownedby_nexstar_OO station_ownedby_nexstar_LMA ///
				) ///
		label noomitted nonotes se(%9.3f) b(%9.3f) nomtitle nonumbers starlevels(* 0.10 ** 0.05 *** 0.01) ///
		posthead("\midrule \ & \multicolumn{8}{c}{Panel B: Within-Market Differences-in-Differences} \\\cmidrule(lr){2-9}") ///
		postfoot("\bottomrule \end{tabular}}") ///
		stats(stationFE dmamonthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray    pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "DMA-By-Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray" "Nexstar = Gray" )) 
					

					
	

///////////////////////
///////////////////////
// APPENDIX TABLE F4 //
///////////////////////
///////////////////////

use data/adintel/adintel_clean_updated.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

g insample = (_m==3)
drop if _m==2
drop _merge

drop if year==2010
drop if year==2020

// BALANCED SAMPLE
cap drop N
cap drop balanced_sample
egen N = total(!missing(rating_total_news) & !missing(rating_total_news)), by(stationID)
tab N
g balanced_sample=(N==102)
drop N

// DIFF-IN-DIFF 

eststo clear

// 1. BASELINE
eststo: reghdfe rating_total_news 		 	station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if insample==1, ///
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

// 2. BALANCED SAMPLE
eststo: reghdfe rating_total_news 		 	station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
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

// 2. BALANCED SAMPLE
eststo: reghdfe rating_total_news 		 	station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if balanced_sample==1&insample==1, ///
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

// 3. POST 2014
eststo: reghdfe rating_total_news 		 	station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if year>=2014&insample==1, ///
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

// 3. POST 2014
eststo: reghdfe rating_total_news 		 	station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if sweep_month==1&insample==1, ///
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

// 4. O&O
eststo: reghdfe rating_total_news 		 	station_ownedby_sinclair_OO station_ownedby_nexstar_OO  ///
											station_ownedby_gray_OO ///
											if insample==1, ///
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
test station_ownedby_sinclair_OO = station_ownedby_nexstar_OO
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_OO = station_ownedby_gray_OO
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_OO = station_ownedby_gray_OO
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 


// 5. INCLUDES SSA
eststo: reghdfe rating_total_news 		 	station_ownedby_sinclair_SSA station_ownedby_nexstar_SSA  ///
											station_ownedby_gray_SSA ///
											if insample==1, ///
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
test station_ownedby_sinclair_SSA = station_ownedby_nexstar_SSA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_SSA = station_ownedby_gray_SSA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_SSA = station_ownedby_gray_SSA
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
		mlabels(" " "Balanced" "Post" "Sweep" "O\&O" "SSA/JSA" "News \\ \ & \ & \ & 2014 & Months & \ & \ & Ratings  \\ \  & (1) & (2) & (3) & (4) & (5) & (6) & (7)") ///
		mgroups("Baseline" "Sample" "Treatment" "TV Eyes" , pattern(1 1 0 0 1 0 1) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(stationFE monthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray   pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f  %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray"  "Nexstar = Gray" )) 
						
esttab using tables/ratings_robustness.tex, replace nogaps keep(station_ownedby_*)  ///
		fragment ///
		prehead("{\def \sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{8}{c}} \toprule") ///
		posthead("\midrule \ & \multicolumn{7}{c}{Panel A: Differences-in-Differences} \\\cmidrule(lr){2-8}") ///
		rename(	station_ownedby_sinclair_SSA station_ownedby_sinclair_LMA ///
				station_ownedby_gray_SSA station_ownedby_gray_LMA ///
				station_ownedby_nexstar_SSA station_ownedby_nexstar_LMA ///
				station_ownedby_sinclair_OO station_ownedby_sinclair_LMA ///
				station_ownedby_gray_OO station_ownedby_gray_LMA ///
				station_ownedby_nexstar_OO station_ownedby_nexstar_LMA ///
				) ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01)  nonumbers ///
		mlabels(" " "Full" "Balanced" "Post" "Sweep" "O\&O" "SSA/JSA \\ \  & \ & \ & \ & 2014 & Months & \ & \ \\ \  & (1) & (2) & (3) & (4) & (5) & (6) & (7)") ///
		mgroups("Baseline" "Sample" "Treatment", pattern(1 1 0 0 0 1 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(stationFE monthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray   pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f  %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray"  "Nexstar = Gray" )) 



// TRIPLE DIFF 

eststo clear

// 1. BASELINE
eststo: reghdfe rating_total_news	 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if insample==1, ///
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

// 2. ALL STATIONS
eststo: reghdfe rating_total_news	 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date##dmacode) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
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

// 2. ALL STATIONS
eststo: reghdfe rating_total_news	 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if balanced_sample==1&insample==1, ///
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

// 2. ALL STATIONS
eststo: reghdfe rating_total_news	 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if year>=2014&insample==1, ///
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
 
// 2. ALL STATIONS
eststo: reghdfe rating_total_news	 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if sweep_month==1&insample==1, ///
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

// 3. O&O
eststo: reghdfe rating_total_news	 		station_ownedby_sinclair_OO station_ownedby_nexstar_OO  ///
											station_ownedby_gray_OO ///
											if insample==1, ///
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
test station_ownedby_sinclair_OO = station_ownedby_nexstar_OO
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_OO = station_ownedby_gray_OO
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_OO = station_ownedby_gray_OO
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 


// 4. INCLUDES SSA
eststo: reghdfe rating_total_news	 		station_ownedby_sinclair_SSA station_ownedby_nexstar_SSA  ///
											station_ownedby_gray_SSA ///
											if insample==1, ///
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
test station_ownedby_sinclair_SSA = station_ownedby_nexstar_SSA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_SSA = station_ownedby_gray_SSA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_SSA = station_ownedby_gray_SSA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 

esttab, nogaps keep(station_ownedby_*)   ///
		rename(	station_ownedby_sinclair_SSA station_ownedby_sinclair_LMA ///
				station_ownedby_gray_SSA station_ownedby_gray_LMA ///
				station_ownedby_nexstar_SSA station_ownedby_nexstar_LMA ///
				station_ownedby_sinclair_OO station_ownedby_sinclair_LMA ///
				station_ownedby_gray_OO station_ownedby_gray_LMA ///
				station_ownedby_nexstar_OO station_ownedby_nexstar_LMA ///
				) ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01)  nonumbers ///
		mlabels(" " "Balanced" "Post" "Sweep" "O\&O" "SSA/JSA" "News \\ \ & \ & 2014 & Months & \ & \ &  Ratings \\ \  & (1) & (2) & (3) & (4) & (5) & (6) & (7)") ///
		mgroups("Baseline" "Sample" "Treatment" "Harmony Labs" , pattern(1 1 0 0 1 0 1) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(stationFE monthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray   pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f  %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray"  "Nexstar = Gray" )) 

esttab using tables/ratings_robustness.tex, fragment append nogaps keep(station_ownedby_*)  ///
		rename(	station_ownedby_sinclair_SSA station_ownedby_sinclair_LMA ///
				station_ownedby_gray_SSA station_ownedby_gray_LMA ///
				station_ownedby_nexstar_SSA station_ownedby_nexstar_LMA ///
				station_ownedby_sinclair_OO station_ownedby_sinclair_LMA ///
				station_ownedby_gray_OO station_ownedby_gray_LMA ///
				station_ownedby_nexstar_OO station_ownedby_nexstar_LMA ///
				) ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle nonumbers ///
		posthead("\midrule \ & \multicolumn{7}{c}{Panel B: Within-Market Differences-in-Differences} \\\cmidrule(lr){2-8}") ///
		postfoot("\bottomrule \end{tabular}}") ///
		compress ///
		stats(stationFE monthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray   pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f  %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "DMA-By-Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray"  "Nexstar = Gray" )) 


					












///////////////////////
///////////////////////
// APPENDIX TABLE F5 //
///////////////////////
///////////////////////

use data/adintel/adintel_clean_updated.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

g insample = (_m==3)
drop if _m==2
drop _merge

drop if year==2010
drop if year==2020

// BALANCED SAMPLE
cap drop N
cap drop balanced_sample
egen N = total(!missing(rating_total_news) & !missing(rating_total_news)), by(stationID)
tab N
g balanced_sample=(N==102)
drop N

// DIFF-IN-DIFF 

eststo clear

// 1. BASELINE
eststo: reghdfe log_imp_total_news 		 	station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if insample==1, ///
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

// 2. BALANCED SAMPLE
eststo: reghdfe log_imp_total_news 		 	station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
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

// 2. BALANCED SAMPLE
eststo: reghdfe log_imp_total_news 		 	station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if balanced_sample==1&insample==1, ///
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

// 3. POST 2014
eststo: reghdfe log_imp_total_news 		 	station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if year>=2014&insample==1, ///
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

// 3. POST 2014
eststo: reghdfe log_imp_total_news 		 	station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if sweep_month==1&insample==1, ///
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


// 4. O&O
eststo: reghdfe log_imp_total_news 		 	station_ownedby_sinclair_OO station_ownedby_nexstar_OO  ///
											station_ownedby_gray_OO ///
											if insample==1, ///
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
test station_ownedby_sinclair_OO = station_ownedby_nexstar_OO
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_OO = station_ownedby_gray_OO
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_OO = station_ownedby_gray_OO
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 


// 5. INCLUDES SSA
eststo: reghdfe log_imp_total_news 		 	station_ownedby_sinclair_SSA station_ownedby_nexstar_SSA  ///
											station_ownedby_gray_SSA ///
											if insample==1, ///
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
test station_ownedby_sinclair_SSA = station_ownedby_nexstar_SSA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_SSA = station_ownedby_gray_SSA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_SSA = station_ownedby_gray_SSA
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
		mlabels(" " "Balanced" "Post" "Sweep" "O\&O" "SSA/JSA \\ \  & \ & \ & 2014 & Months & \ & \ \\ \  & (1) & (2) & (3) & (4) & (5) & (6)") ///
		mgroups("Baseline" "Sample" "Treatment", pattern(1 1 0 0 1 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(stationFE monthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray   pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f  %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray"  "Nexstar = Gray" )) 
						
esttab using tables/log_impressions_robustness.tex, replace nogaps keep(station_ownedby_*)  ///
		fragment ///
		prehead("{\def \sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{8}{c}} \toprule") ///
		posthead("\midrule \ & \multicolumn{7}{c}{Panel A: Differences-in-Differences} \\\cmidrule(lr){2-8}") ///
		rename(	station_ownedby_sinclair_SSA station_ownedby_sinclair_LMA ///
				station_ownedby_gray_SSA station_ownedby_gray_LMA ///
				station_ownedby_nexstar_SSA station_ownedby_nexstar_LMA ///
				station_ownedby_sinclair_OO station_ownedby_sinclair_LMA ///
				station_ownedby_gray_OO station_ownedby_gray_LMA ///
				station_ownedby_nexstar_OO station_ownedby_nexstar_LMA ///
				) ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01)  nonumbers ///
		mlabels(" " "Full" "Balanced" "Post" "Sweep" "O\&O" "SSA/JSA \\ \  & \ & \ & \ & 2014 & Months & \ & \ \\ \  & (1) & (2) & (3) & (4) & (5) & (6) & (7)") ///
		mgroups("Baseline" "Sample" "Treatment", pattern(1 1 0 0 1 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(stationFE monthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray   pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f  %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray"  "Nexstar = Gray" )) 


// TRIPLE DIFF 

eststo clear

// 1. BASELINE
eststo: reghdfe log_imp_total_news	 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if insample==1, ///
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

// 2. ALL STATIONS
eststo: reghdfe log_imp_total_news	 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											, ///
											absorb(stationID date##dmacode) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
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


// 2. ALL STATIONS
eststo: reghdfe log_imp_total_news	 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if balanced_sample==1&insample==1, ///
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

// 2. ALL STATIONS
eststo: reghdfe log_imp_total_news	 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if year>=2014&insample==1, ///
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

// 2. ALL STATIONS
eststo: reghdfe log_imp_total_news	 		station_ownedby_sinclair_LMA station_ownedby_nexstar_LMA  ///
											station_ownedby_gray_LMA ///
											if sweep_month==1&insample==1, ///
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
// 3. O&O
eststo: reghdfe log_imp_total_news	 		station_ownedby_sinclair_OO station_ownedby_nexstar_OO  ///
											station_ownedby_gray_OO ///
											if insample==1, ///
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
test station_ownedby_sinclair_OO = station_ownedby_nexstar_OO
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_OO = station_ownedby_gray_OO
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_OO = station_ownedby_gray_OO
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 


// 4. INCLUDES SSA
eststo: reghdfe log_imp_total_news	 		station_ownedby_sinclair_SSA station_ownedby_nexstar_SSA  ///
											station_ownedby_gray_SSA ///
											if insample==1, ///
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
test station_ownedby_sinclair_SSA = station_ownedby_nexstar_SSA
qui scalar pvalue_sinclair_nexstar =  `r(p)'
qui estadd scalar pvalue_sinclair_nexstar 
test station_ownedby_sinclair_SSA = station_ownedby_gray_SSA
qui scalar pvalue_sinclair_gray =  `r(p)'
qui estadd scalar pvalue_sinclair_gray 
test station_ownedby_nexstar_SSA = station_ownedby_gray_SSA
qui scalar pvalue_nexstar_gray =  `r(p)'
qui estadd scalar pvalue_nexstar_gray 


esttab, nogaps keep(station_ownedby_*)   ///
		rename(	station_ownedby_sinclair_SSA station_ownedby_sinclair_LMA ///
				station_ownedby_gray_SSA station_ownedby_gray_LMA ///
				station_ownedby_nexstar_SSA station_ownedby_nexstar_LMA ///
				station_ownedby_sinclair_OO station_ownedby_sinclair_LMA ///
				station_ownedby_gray_OO station_ownedby_gray_LMA ///
				station_ownedby_nexstar_OO station_ownedby_nexstar_LMA ///
				) ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01)  nonumbers ///
		mlabels(" " "Balanced" "Post" "Sweep" "O\&O" "SSA/JSA \\ \  & \ & \ & \ & Months & \ & \ \\ \  & (1) & (2) & (3) & (4) & (5) & (6)") ///
		mgroups("Baseline" "Sample" "Treatment", pattern(1 1 0 0 1 0) ///
		prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
		compress ///
		stats(stationFE monthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray   pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f  %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray"  "Nexstar = Gray" )) 

esttab using tables/log_impressions_robustness.tex, fragment append nogaps keep(station_ownedby_*)  ///
		rename(	station_ownedby_sinclair_SSA station_ownedby_sinclair_LMA ///
				station_ownedby_gray_SSA station_ownedby_gray_LMA ///
				station_ownedby_nexstar_SSA station_ownedby_nexstar_LMA ///
				station_ownedby_sinclair_OO station_ownedby_sinclair_LMA ///
				station_ownedby_gray_OO station_ownedby_gray_LMA ///
				station_ownedby_nexstar_OO station_ownedby_nexstar_LMA ///
				) ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle nonumbers ///
		posthead("\midrule \ & \multicolumn{7}{c}{Panel B: Within-Market Differences-in-Differences} \\\cmidrule(lr){2-8}") ///
		postfoot("\bottomrule \end{tabular}}") ///
		compress ///
		stats(stationFE monthFE controls N N_stations N_clust ymean ///
			  pvalue_sinclair_nexstar pvalue_sinclair_gray   pvalue_nexstar_gray, ///
			  fmt(%9.0f %9.0f %9.0f %9.0f  %9.0f %9.0f %9.3f %9.3f %9.3f %9.3f %9.3f ) ///
			  labels("Station FEs" "DMA-By-Month FEs" "Controls" "\midrule Observations" "Stations" "DMAs (Clusters)" ///
					"Mean Dep. Variable" "\midrule Sinclair = Nexstar" "Sinclair = Gray"  "Nexstar = Gray" )) 








	  


///////////////////////
///////////////////////
// APPENDIX TABLE F6 //
///////////////////////
///////////////////////


use data/harmony/content_cleaned.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

cap drop tag
egen tag=tag(stationID)								

// CREATES THE NECESSARY VARIABLES

bysort dmacode: egen ever_sinclair_dma = max(station_ownedby_sinclair_LMA)
bysort dmacode: egen ever_nexstar_dma = max(station_ownedby_nexstar_LMA)
bysort dmacode: egen ever_gray_dma = max(station_ownedby_gray_LMA)

bysort stationID: egen ever_sinclair = max(station_ownedby_sinclair_LMA)
bysort stationID: egen ever_nexstar = max(station_ownedby_nexstar_LMA)
bysort stationID: egen ever_gray = max(station_ownedby_gray_LMA)

// 1. SINCLAIR

eststo clear

eststo: reghdfe mention_place_pershow 		station_ownedby_sinclair_LMA ///
											, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe mention_place_pershow 		station_ownedby_sinclair_LMA ///
											if ever_nexstar==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe mention_place_pershow 		station_ownedby_sinclair_LMA  ///
											if ever_gray==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
											
eststo: reghdfe mention_place_pershow 		station_ownedby_sinclair_LMA ///
											if ever_nexstar==0&ever_gray==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe mention_place_pershow 		station_ownedby_sinclair_LMA  ///
											if ever_nexstar_dma==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe mention_place_pershow 		station_ownedby_sinclair_LMA  ///
											if ever_gray_dma==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
											
eststo: reghdfe mention_place_pershow 		station_ownedby_sinclair_LMA ///
											if ever_nexstar_dma==0&ever_gray_dma==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

esttab using tables/content_spillovers_DID.tex, replace fragment nogaps keep(station_ownedby_*)  ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle nonumbers ///
		prehead("{\def \sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{10}{c}} \toprule \ & \multicolumn{1}{c}{Baseline} & \multicolumn{4}{c}{Drops Stations}   & \multicolumn{4}{c}{Drops DMAs} \\ \cmidrule(lr){2-2}\cmidrule(lr){3-6}\cmidrule(lr){7-10} \ & " " & Sinclair & Nexstar & Gray & Both & Sinclair & Nexstar & Gray & Both \\	\ & (1) & (2) & (3) & (4) & (5) & (6)  & (7)  & (8)  & (9) \\") ///
		posthead("\midrule \ & \multicolumn{9}{c}{Panel A: Sinclair} \\\cmidrule(lr){2-10}") ///
		compress extracols(2 5) ///
		stats(N N_stations N_clust ymean, ///
			  fmt(%9.0f %9.0f %9.0f %9.3f ) ///
			  labels("Observations" "Stations" "DMAs (Clusters)" "Mean Dep. Variable")) 

// 2. NEXSTAR

eststo clear

eststo: reghdfe mention_place_pershow 		station_ownedby_nexstar_LMA ///
											, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe mention_place_pershow 		station_ownedby_nexstar_LMA ///
											if ever_sinclair==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe mention_place_pershow 		station_ownedby_nexstar_LMA  ///
											if ever_gray==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
											
eststo: reghdfe mention_place_pershow 		station_ownedby_nexstar_LMA ///
											if ever_sinclair==0&ever_gray==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe mention_place_pershow 		station_ownedby_nexstar_LMA  ///
											if ever_sinclair_dma==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe mention_place_pershow 		station_ownedby_nexstar_LMA  ///
											if ever_gray_dma==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
											
eststo: reghdfe mention_place_pershow 		station_ownedby_nexstar_LMA ///
											if ever_sinclair_dma==0&ever_gray_dma==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

esttab using tables/content_spillovers_DID.tex, append fragment nogaps keep(station_ownedby_*)  ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle nonumbers ///
		posthead("\midrule \ & \multicolumn{9}{c}{Panel B: Nexstar} \\\cmidrule(lr){2-10}") ///
		compress extracols(3 6) ///
		stats(N N_stations N_clust ymean, ///
			  fmt(%9.0f %9.0f %9.0f %9.3f ) ///
			  labels("Observations" "Stations" "DMAs (Clusters)" "Mean Dep. Variable")) 

// 3. GRAY

eststo clear

eststo: reghdfe mention_place_pershow 		station_ownedby_gray_LMA ///
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

eststo: reghdfe mention_place_pershow 		station_ownedby_gray_LMA ///
											if ever_sinclair==0, ///
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

eststo: reghdfe mention_place_pershow 		station_ownedby_gray_LMA  ///
											if ever_nexstar==0, ///
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
										
eststo: reghdfe mention_place_pershow 		station_ownedby_gray_LMA ///
											if ever_sinclair==0&ever_nexstar==0, ///
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

eststo: reghdfe mention_place_pershow 		station_ownedby_gray_LMA  ///
											if ever_sinclair_dma==0, ///
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

eststo: reghdfe mention_place_pershow 		station_ownedby_gray_LMA  ///
											if ever_nexstar_dma==0, ///
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
											
eststo: reghdfe mention_place_pershow 		station_ownedby_gray_LMA ///
											if ever_sinclair_dma==0&ever_nexstar_dma==0, ///
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

esttab using tables/content_spillovers_DID.tex, append fragment nogaps keep(station_ownedby_*)  ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle nonumbers ///
		posthead("\midrule \ & \multicolumn{9}{c}{Panel C: Gray} \\\cmidrule(lr){2-10}") ///
		postfoot("\bottomrule \end{tabular}}") ///
		compress extracols(4 7) ///
		stats(N N_stations N_clust ymean, ///
			  fmt(%9.0f %9.0f %9.0f %9.3f) ///
			  labels("Observations" "Stations" "DMAs (Clusters)" "Mean Dep. Variable")) 



///////////////////////
///////////////////////
// APPENDIX TABLE F7 //
///////////////////////
///////////////////////


use data/harmony/content_cleaned.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

cap drop tag
egen tag=tag(stationID)								

// CREATES THE NECESSARY VARIABLES

bysort dmacode: egen ever_sinclair_dma = max(station_ownedby_sinclair_LMA)
bysort dmacode: egen ever_nexstar_dma = max(station_ownedby_nexstar_LMA)
bysort dmacode: egen ever_gray_dma = max(station_ownedby_gray_LMA)

bysort stationID: egen ever_sinclair = max(station_ownedby_sinclair_LMA)
bysort stationID: egen ever_nexstar = max(station_ownedby_nexstar_LMA)
bysort stationID: egen ever_gray = max(station_ownedby_gray_LMA)

// 1. SINCLAIR

eststo clear

eststo: reghdfe mention_place_pershow 		station_ownedby_sinclair_LMA ///
											, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe mention_place_pershow 		station_ownedby_sinclair_LMA ///
											if ever_nexstar==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe mention_place_pershow 		station_ownedby_sinclair_LMA  ///
											if ever_gray==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
											
eststo: reghdfe mention_place_pershow 		station_ownedby_sinclair_LMA ///
											if ever_nexstar==0&ever_gray==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe mention_place_pershow 		station_ownedby_sinclair_LMA  ///
											if ever_nexstar_dma==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe mention_place_pershow 		station_ownedby_sinclair_LMA  ///
											if ever_gray_dma==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
											
eststo: reghdfe mention_place_pershow 		station_ownedby_sinclair_LMA ///
											if ever_nexstar_dma==0&ever_gray_dma==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

esttab using tables/content_spillovers_TRIPLEDIFF.tex, replace fragment nogaps keep(station_ownedby_*)  ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle nonumbers ///
		prehead("{\def \sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{10}{c}} \toprule \ & \multicolumn{1}{c}{Baseline} & \multicolumn{4}{c}{Drops Stations}   & \multicolumn{4}{c}{Drops DMAs} \\ \cmidrule(lr){2-2}\cmidrule(lr){3-6}\cmidrule(lr){7-10} \ & " " & Sinclair & Nexstar & Gray & Both & Sinclair & Nexstar & Gray & Both \\	\ & (1) & (2) & (3) & (4) & (5) & (6)  & (7)  & (8)  & (9) \\") ///
		posthead("\midrule \ & \multicolumn{9}{c}{Panel A: Sinclair} \\\cmidrule(lr){2-10}") ///
		compress extracols(2 5) ///
		stats(N N_stations N_clust ymean, ///
			  fmt(%9.0f %9.0f %9.0f %9.3f ) ///
			  labels("Observations" "Stations" "DMAs (Clusters)" "Mean Dep. Variable")) 

// 2. NEXSTAR

eststo clear

eststo: reghdfe mention_place_pershow 		station_ownedby_nexstar_LMA ///
											, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe mention_place_pershow 		station_ownedby_nexstar_LMA ///
											if ever_sinclair==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe mention_place_pershow 		station_ownedby_nexstar_LMA  ///
											if ever_gray==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
											
eststo: reghdfe mention_place_pershow 		station_ownedby_nexstar_LMA ///
											if ever_sinclair==0&ever_gray==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe mention_place_pershow 		station_ownedby_nexstar_LMA  ///
											if ever_sinclair_dma==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe mention_place_pershow 		station_ownedby_nexstar_LMA  ///
											if ever_gray_dma==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
											
eststo: reghdfe mention_place_pershow 		station_ownedby_nexstar_LMA ///
											if ever_sinclair_dma==0&ever_gray_dma==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

esttab using tables/content_spillovers_TRIPLEDIFF.tex, append fragment nogaps keep(station_ownedby_*)  ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle nonumbers ///
		posthead("\midrule \ & \multicolumn{9}{c}{Panel B: Nexstar} \\\cmidrule(lr){2-10}") ///
		compress extracols(3 6) ///
		stats(N N_stations N_clust ymean, ///
			  fmt(%9.0f %9.0f %9.0f %9.3f ) ///
			  labels("Observations" "Stations" "DMAs (Clusters)" "Mean Dep. Variable")) 

// 3. GRAY

eststo clear

eststo: reghdfe mention_place_pershow 		station_ownedby_gray_LMA ///
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

eststo: reghdfe mention_place_pershow 		station_ownedby_gray_LMA ///
											if ever_sinclair==0, ///
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

eststo: reghdfe mention_place_pershow 		station_ownedby_gray_LMA  ///
											if ever_nexstar==0, ///
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
										
eststo: reghdfe mention_place_pershow 		station_ownedby_gray_LMA ///
											if ever_sinclair==0&ever_nexstar==0, ///
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

eststo: reghdfe mention_place_pershow 		station_ownedby_gray_LMA  ///
											if ever_sinclair_dma==0, ///
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

eststo: reghdfe mention_place_pershow 		station_ownedby_gray_LMA  ///
											if ever_nexstar_dma==0, ///
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
											
eststo: reghdfe mention_place_pershow 		station_ownedby_gray_LMA ///
											if ever_sinclair_dma==0&ever_nexstar_dma==0, ///
											absorb(stationID date##dmacode##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
qui estadd local controls		"\checkmark"

esttab using tables/content_spillovers_TRIPLEDIFF.tex, append fragment nogaps keep(station_ownedby_*)  ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle nonumbers ///
		posthead("\midrule \ & \multicolumn{9}{c}{Panel C: Gray} \\\cmidrule(lr){2-10}") ///
		postfoot("\bottomrule \end{tabular}}") ///
		compress extracols(4 7) ///
		stats(N N_stations N_clust ymean, ///
			  fmt(%9.0f %9.0f %9.0f %9.3f) ///
			  labels("Observations" "Stations" "DMAs (Clusters)" "Mean Dep. Variable")) 

			  
////////////////////////
////////////////////////
// APPENDIX TABLE F8 //
////////////////////////
////////////////////////

		  
			
use data/adintel/adintel_clean_updated.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

drop if year==2010
drop if year==2020
			

// CREATES ALL THE NECESSARY VARIABLES 

bysort dmacode: egen ever_sinclair_dma = max(station_ownedby_sinclair_LMA)
bysort dmacode: egen ever_nexstar_dma = max(station_ownedby_nexstar_LMA)
bysort dmacode: egen ever_gray_dma = max(station_ownedby_gray_LMA)

bysort stationID: egen ever_sinclair = max(station_ownedby_sinclair_LMA)
bysort stationID: egen ever_nexstar = max(station_ownedby_nexstar_LMA)
bysort stationID: egen ever_gray = max(station_ownedby_gray_LMA)

// DID 

// 1. SINCLAIR

eststo clear

eststo: reghdfe log_duration_perHH_news		station_ownedby_sinclair_LMA ///
											, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe log_duration_perHH_news		station_ownedby_sinclair_LMA ///
											if ever_nexstar==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe log_duration_perHH_news		station_ownedby_sinclair_LMA  ///
											if ever_gray==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
											
eststo: reghdfe log_duration_perHH_news		station_ownedby_sinclair_LMA ///
											if ever_nexstar==0&ever_gray==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe log_duration_perHH_news		station_ownedby_sinclair_LMA  ///
											if ever_nexstar_dma==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe log_duration_perHH_news		station_ownedby_sinclair_LMA  ///
											if ever_gray_dma==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
											
eststo: reghdfe log_duration_perHH_news		station_ownedby_sinclair_LMA ///
											if ever_nexstar_dma==0&ever_gray_dma==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

esttab using tables/adintel_spillovers_DID.tex, replace fragment nogaps keep(station_ownedby_*)  ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle nonumbers ///
		prehead("{\def \sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{10}{c}} \toprule \ & \multicolumn{1}{c}{Baseline} & \multicolumn{4}{c}{Drops Stations}   & \multicolumn{4}{c}{Drops DMAs} \\ \cmidrule(lr){2-2}\cmidrule(lr){3-6}\cmidrule(lr){7-10} \ & " " & Sinclair & Nexstar & Gray & Both & Sinclair & Nexstar & Gray & Both \\	\ & (1) & (2) & (3) & (4) & (5) & (6)  & (7)  & (8)  & (9) \\") ///
		posthead("\midrule \ & \multicolumn{9}{c}{Panel A: Sinclair} \\\cmidrule(lr){2-10}") ///
		compress extracols(2 5) ///
		stats(N N_stations N_clust ymean, ///
			  fmt(%9.0f %9.0f %9.0f %9.3f ) ///
			  labels("Observations" "Stations" "DMAs (Clusters)" "Mean Dep. Variable")) 

// 2. NEXSTAR

eststo clear

eststo: reghdfe log_duration_perHH_news		station_ownedby_nexstar_LMA ///
											, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe log_duration_perHH_news		station_ownedby_nexstar_LMA ///
											if ever_sinclair==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe log_duration_perHH_news		station_ownedby_nexstar_LMA  ///
											if ever_gray==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
											
eststo: reghdfe log_duration_perHH_news		station_ownedby_nexstar_LMA ///
											if ever_sinclair==0&ever_gray==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe log_duration_perHH_news		station_ownedby_nexstar_LMA  ///
											if ever_sinclair_dma==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe log_duration_perHH_news		station_ownedby_nexstar_LMA  ///
											if ever_gray_dma==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
											
eststo: reghdfe log_duration_perHH_news		station_ownedby_nexstar_LMA ///
											if ever_sinclair_dma==0&ever_gray_dma==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

esttab using tables/adintel_spillovers_DID.tex, append fragment nogaps keep(station_ownedby_*)  ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle nonumbers ///
		posthead("\midrule \ & \multicolumn{9}{c}{Panel B: Nexstar} \\\cmidrule(lr){2-10}") ///
		compress extracols(3 6) ///
		stats(N N_stations N_clust ymean, ///
			  fmt(%9.0f %9.0f %9.0f %9.3f ) ///
			  labels("Observations" "Stations" "DMAs (Clusters)" "Mean Dep. Variable")) 

// 3. GRAY

eststo clear

eststo: reghdfe log_duration_perHH_news		station_ownedby_gray_LMA ///
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

eststo: reghdfe log_duration_perHH_news		station_ownedby_gray_LMA ///
											if ever_sinclair==0, ///
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

eststo: reghdfe log_duration_perHH_news		station_ownedby_gray_LMA  ///
											if ever_nexstar==0, ///
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
										
eststo: reghdfe log_duration_perHH_news		station_ownedby_gray_LMA ///
											if ever_sinclair==0&ever_nexstar==0, ///
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

eststo: reghdfe log_duration_perHH_news		station_ownedby_gray_LMA  ///
											if ever_sinclair_dma==0, ///
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

eststo: reghdfe log_duration_perHH_news		station_ownedby_gray_LMA  ///
											if ever_nexstar_dma==0, ///
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
											
eststo: reghdfe log_duration_perHH_news		station_ownedby_gray_LMA ///
											if ever_sinclair_dma==0&ever_nexstar_dma==0, ///
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

esttab using tables/adintel_spillovers_DID.tex, append fragment nogaps keep(station_ownedby_*)  ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle nonumbers ///
		posthead("\midrule \ & \multicolumn{9}{c}{Panel C: Gray} \\\cmidrule(lr){2-10}") ///
		postfoot("\bottomrule \end{tabular}}") ///
		compress extracols(4 7) ///
		stats(N N_stations N_clust ymean, ///
			  fmt(%9.0f %9.0f %9.0f %9.3f) ///
			  labels("Observations" "Stations" "DMAs (Clusters)" "Mean Dep. Variable")) 

			  
			  

///////////////////////
///////////////////////
// APPENDIX TABLE F9 //
///////////////////////
///////////////////////

		  
use data/adintel/adintel_clean_updated.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

drop if year==2010
drop if year==2020
			
// CREATES ALL THE NECESSARY VARIABLES 

bysort dmacode: egen ever_sinclair_dma = max(station_ownedby_sinclair_LMA)
bysort dmacode: egen ever_nexstar_dma = max(station_ownedby_nexstar_LMA)
bysort dmacode: egen ever_gray_dma = max(station_ownedby_gray_LMA)

bysort stationID: egen ever_sinclair = max(station_ownedby_sinclair_LMA)
bysort stationID: egen ever_nexstar = max(station_ownedby_nexstar_LMA)
bysort stationID: egen ever_gray = max(station_ownedby_gray_LMA)
 

// 1. SINCLAIR

eststo clear

eststo: reghdfe log_duration_perHH_news		station_ownedby_sinclair_LMA ///
											, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe log_duration_perHH_news		station_ownedby_sinclair_LMA ///
											if ever_nexstar==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe log_duration_perHH_news		station_ownedby_sinclair_LMA  ///
											if ever_gray==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
											
eststo: reghdfe log_duration_perHH_news		station_ownedby_sinclair_LMA ///
											if ever_nexstar==0&ever_gray==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe log_duration_perHH_news		station_ownedby_sinclair_LMA  ///
											if ever_nexstar_dma==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe log_duration_perHH_news		station_ownedby_sinclair_LMA  ///
											if ever_gray_dma==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
											
eststo: reghdfe log_duration_perHH_news		station_ownedby_sinclair_LMA ///
											if ever_nexstar_dma==0&ever_gray_dma==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

esttab using tables/adintel_spillovers_TRIPLEDIFF.tex, replace fragment nogaps keep(station_ownedby_*)  ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle nonumbers ///
		prehead("{\def \sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{10}{c}} \toprule \ & \multicolumn{1}{c}{Baseline} & \multicolumn{4}{c}{Drops Stations}   & \multicolumn{4}{c}{Drops DMAs} \\ \cmidrule(lr){2-2}\cmidrule(lr){3-6}\cmidrule(lr){7-10} \ & " " & Sinclair & Nexstar & Gray & Both & Sinclair & Nexstar & Gray & Both \\	\ & (1) & (2) & (3) & (4) & (5) & (6)  & (7)  & (8)  & (9) \\") ///
		posthead("\midrule \ & \multicolumn{9}{c}{Panel A: Sinclair} \\\cmidrule(lr){2-10}") ///
		compress extracols(2 5) ///
		stats(N N_stations N_clust ymean, ///
			  fmt(%9.0f %9.0f %9.0f %9.3f ) ///
			  labels("Observations" "Stations" "DMAs (Clusters)" "Mean Dep. Variable")) 

// 2. NEXSTAR

eststo clear

eststo: reghdfe log_duration_perHH_news		station_ownedby_nexstar_LMA ///
											, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe log_duration_perHH_news		station_ownedby_nexstar_LMA ///
											if ever_sinclair==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe log_duration_perHH_news		station_ownedby_nexstar_LMA  ///
											if ever_gray==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
											
eststo: reghdfe log_duration_perHH_news		station_ownedby_nexstar_LMA ///
											if ever_sinclair==0&ever_gray==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe log_duration_perHH_news		station_ownedby_nexstar_LMA  ///
											if ever_sinclair_dma==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe log_duration_perHH_news		station_ownedby_nexstar_LMA  ///
											if ever_gray_dma==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
											
eststo: reghdfe log_duration_perHH_news		station_ownedby_nexstar_LMA ///
											if ever_sinclair_dma==0&ever_gray_dma==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

esttab using tables/adintel_spillovers_TRIPLEDIFF.tex, append fragment nogaps keep(station_ownedby_*)  ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle nonumbers ///
		posthead("\midrule \ & \multicolumn{9}{c}{Panel B: Nexstar} \\\cmidrule(lr){2-10}") ///
		compress extracols(3 6) ///
		stats(N N_stations N_clust ymean, ///
			  fmt(%9.0f %9.0f %9.0f %9.3f ) ///
			  labels("Observations" "Stations" "DMAs (Clusters)" "Mean Dep. Variable")) 

// 3. GRAY

eststo clear

eststo: reghdfe log_duration_perHH_news		station_ownedby_gray_LMA ///
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

eststo: reghdfe log_duration_perHH_news		station_ownedby_gray_LMA ///
											if ever_sinclair==0, ///
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

eststo: reghdfe log_duration_perHH_news		station_ownedby_gray_LMA  ///
											if ever_nexstar==0, ///
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
										
eststo: reghdfe log_duration_perHH_news		station_ownedby_gray_LMA ///
											if ever_sinclair==0&ever_nexstar==0, ///
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

eststo: reghdfe log_duration_perHH_news		station_ownedby_gray_LMA  ///
										if ever_sinclair_dma==0, ///
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

eststo: reghdfe log_duration_perHH_news		station_ownedby_gray_LMA  ///
											if ever_nexstar_dma==0, ///
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
											
eststo: reghdfe log_duration_perHH_news		station_ownedby_gray_LMA ///
											if ever_sinclair_dma==0&ever_nexstar_dma==0, ///
											absorb(stationID date##dmacode##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
qui estadd local controls		"\checkmark"

esttab using tables/adintel_spillovers_TRIPLEDIFF.tex, append fragment nogaps keep(station_ownedby_*)  ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle nonumbers ///
		posthead("\midrule \ & \multicolumn{9}{c}{Panel C: Gray} \\\cmidrule(lr){2-10}") ///
		postfoot("\bottomrule \end{tabular}}") ///
		compress extracols(4 7) ///
		stats(N N_stations N_clust ymean, ///
			  fmt(%9.0f %9.0f %9.0f %9.3f) ///
			  labels("Observations" "Stations" "DMAs (Clusters)" "Mean Dep. Variable")) 


	  
			  
////////////////////////
////////////////////////
// APPENDIX TABLE F10 //
////////////////////////
////////////////////////


use data/adintel/adintel_clean_updated.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

drop if year==2010
drop if year==2020
		
// CREATES ALL THE NECESSARY VARIABLES

bysort dmacode: egen ever_sinclair_dma = max(station_ownedby_sinclair_LMA)
bysort dmacode: egen ever_nexstar_dma = max(station_ownedby_nexstar_LMA)
bysort dmacode: egen ever_gray_dma = max(station_ownedby_gray_LMA)

bysort stationID: egen ever_sinclair = max(station_ownedby_sinclair_LMA)
bysort stationID: egen ever_nexstar = max(station_ownedby_nexstar_LMA)
bysort stationID: egen ever_gray = max(station_ownedby_gray_LMA)

// 1. SINCLAIR

eststo clear

eststo: reghdfe rating_total_news		station_ownedby_sinclair_LMA ///
											, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe rating_total_news		station_ownedby_sinclair_LMA ///
											if ever_nexstar==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe rating_total_news		station_ownedby_sinclair_LMA  ///
											if ever_gray==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
											
eststo: reghdfe rating_total_news		station_ownedby_sinclair_LMA ///
											if ever_nexstar==0&ever_gray==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe rating_total_news		station_ownedby_sinclair_LMA  ///
											if ever_nexstar_dma==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe rating_total_news		station_ownedby_sinclair_LMA  ///
											if ever_gray_dma==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
											
eststo: reghdfe rating_total_news		station_ownedby_sinclair_LMA ///
											if ever_nexstar_dma==0&ever_gray_dma==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

esttab using tables/ratings_spillovers_DID.tex, replace fragment nogaps keep(station_ownedby_*)  ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle nonumbers ///
		prehead("{\def \sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{10}{c}} \toprule \ & \multicolumn{1}{c}{Baseline} & \multicolumn{4}{c}{Drops Stations}   & \multicolumn{4}{c}{Drops DMAs} \\ \cmidrule(lr){2-2}\cmidrule(lr){3-6}\cmidrule(lr){7-10} \ & " " & Sinclair & Nexstar & Gray & Both & Sinclair & Nexstar & Gray & Both \\	\ & (1) & (2) & (3) & (4) & (5) & (6)  & (7)  & (8)  & (9) \\") ///
		posthead("\midrule \ & \multicolumn{9}{c}{Panel A: Sinclair} \\\cmidrule(lr){2-10}") ///
		compress extracols(2 5) ///
		stats(N N_stations N_clust ymean, ///
			  fmt(%9.0f %9.0f %9.0f %9.3f ) ///
			  labels("Observations" "Stations" "DMAs (Clusters)" "Mean Dep. Variable")) 

// 2. NEXSTAR

eststo clear

eststo: reghdfe rating_total_news		station_ownedby_nexstar_LMA ///
											, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe rating_total_news		station_ownedby_nexstar_LMA ///
											if ever_sinclair==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe rating_total_news		station_ownedby_nexstar_LMA  ///
											if ever_gray==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
											
eststo: reghdfe rating_total_news		station_ownedby_nexstar_LMA ///
											if ever_sinclair==0&ever_gray==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe rating_total_news		station_ownedby_nexstar_LMA  ///
											if ever_sinclair_dma==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe rating_total_news		station_ownedby_nexstar_LMA  ///
											if ever_gray_dma==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
											
eststo: reghdfe rating_total_news		station_ownedby_nexstar_LMA ///
											if ever_sinclair_dma==0&ever_gray_dma==0, ///
											absorb(stationID date c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

esttab using tables/ratings_spillovers_DID.tex, append fragment nogaps keep(station_ownedby_*)  ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle nonumbers ///
		posthead("\midrule \ & \multicolumn{9}{c}{Panel B: Nexstar} \\\cmidrule(lr){2-10}") ///
		compress extracols(3 6) ///
		stats(N N_stations N_clust ymean, ///
			  fmt(%9.0f %9.0f %9.0f %9.3f ) ///
			  labels("Observations" "Stations" "DMAs (Clusters)" "Mean Dep. Variable")) 

// 3. GRAY

eststo clear

eststo: reghdfe rating_total_news		station_ownedby_gray_LMA ///
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

eststo: reghdfe rating_total_news		station_ownedby_gray_LMA ///
											if ever_sinclair==0, ///
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

eststo: reghdfe rating_total_news		station_ownedby_gray_LMA  ///
											if ever_nexstar==0, ///
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
										
eststo: reghdfe rating_total_news		station_ownedby_gray_LMA ///
											if ever_sinclair==0&ever_nexstar==0, ///
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

eststo: reghdfe rating_total_news		station_ownedby_gray_LMA  ///
											if ever_sinclair_dma==0, ///
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

eststo: reghdfe rating_total_news		station_ownedby_gray_LMA  ///
											if ever_nexstar_dma==0, ///
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
											
eststo: reghdfe rating_total_news		station_ownedby_gray_LMA ///
											if ever_sinclair_dma==0&ever_nexstar_dma==0, ///
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

esttab using tables/ratings_spillovers_DID.tex, append fragment nogaps keep(station_ownedby_*)  ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle nonumbers ///
		posthead("\midrule \ & \multicolumn{9}{c}{Panel C: Gray} \\\cmidrule(lr){2-10}") ///
		postfoot("\bottomrule \end{tabular}}") ///
		compress extracols(4 7) ///
		stats(N N_stations N_clust ymean, ///
			  fmt(%9.0f %9.0f %9.0f %9.3f) ///
			  labels("Observations" "Stations" "DMAs (Clusters)" "Mean Dep. Variable")) 

		  

////////////////////////
////////////////////////
// APPENDIX TABLE F11 //
////////////////////////
////////////////////////


use data/adintel/adintel_clean_updated.dta, clear

merge m:1 stationID using data/station_baseline_characteristics_2010_small.dta

keep if _m==3
drop _merge

drop if year==2010
drop if year==2020
		
// CREATES ALL THE NECESSARY VARIABLES

bysort dmacode: egen ever_sinclair_dma = max(station_ownedby_sinclair_LMA)
bysort dmacode: egen ever_nexstar_dma = max(station_ownedby_nexstar_LMA)
bysort dmacode: egen ever_gray_dma = max(station_ownedby_gray_LMA)

bysort stationID: egen ever_sinclair = max(station_ownedby_sinclair_LMA)
bysort stationID: egen ever_nexstar = max(station_ownedby_nexstar_LMA)
bysort stationID: egen ever_gray = max(station_ownedby_gray_LMA)

// 1. SINCLAIR

eststo clear

eststo: reghdfe rating_total_news		station_ownedby_sinclair_LMA ///
											, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe rating_total_news		station_ownedby_sinclair_LMA ///
											if ever_nexstar==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe rating_total_news		station_ownedby_sinclair_LMA  ///
											if ever_gray==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
											
eststo: reghdfe rating_total_news		station_ownedby_sinclair_LMA ///
											if ever_nexstar==0&ever_gray==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe rating_total_news		station_ownedby_sinclair_LMA  ///
											if ever_nexstar_dma==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe rating_total_news		station_ownedby_sinclair_LMA  ///
											if ever_gray_dma==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
											
eststo: reghdfe rating_total_news		station_ownedby_sinclair_LMA ///
											if ever_nexstar_dma==0&ever_gray_dma==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

esttab using tables/ratings_spillovers_TRIPLEDIFF.tex, replace fragment nogaps keep(station_ownedby_*)  ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle nonumbers ///
		prehead("{\def \sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{10}{c}} \toprule \ & \multicolumn{1}{c}{Baseline} & \multicolumn{4}{c}{Drops Stations}   & \multicolumn{4}{c}{Drops DMAs} \\ \cmidrule(lr){2-2}\cmidrule(lr){3-6}\cmidrule(lr){7-10} \ & " " & Sinclair & Nexstar & Gray & Both & Sinclair & Nexstar & Gray & Both \\	\ & (1) & (2) & (3) & (4) & (5) & (6)  & (7)  & (8)  & (9) \\") ///
		posthead("\midrule \ & \multicolumn{9}{c}{Panel A: Sinclair} \\\cmidrule(lr){2-10}") ///
		compress extracols(2 5) ///
		stats(N N_stations N_clust ymean, ///
			  fmt(%9.0f %9.0f %9.0f %9.3f ) ///
			  labels("Observations" "Stations" "DMAs (Clusters)" "Mean Dep. Variable")) 

// 2. NEXSTAR

eststo clear

eststo: reghdfe rating_total_news		station_ownedby_nexstar_LMA ///
											, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe rating_total_news		station_ownedby_nexstar_LMA ///
											if ever_sinclair==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe rating_total_news		station_ownedby_nexstar_LMA  ///
											if ever_gray==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
											
eststo: reghdfe rating_total_news		station_ownedby_nexstar_LMA ///
											if ever_sinclair==0&ever_gray==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe rating_total_news		station_ownedby_nexstar_LMA  ///
											if ever_sinclair_dma==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

eststo: reghdfe rating_total_news		station_ownedby_nexstar_LMA  ///
											if ever_gray_dma==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
											
eststo: reghdfe rating_total_news		station_ownedby_nexstar_LMA ///
											if ever_sinclair_dma==0&ever_gray_dma==0, ///
											absorb(stationID date##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 

esttab using tables/ratings_spillovers_TRIPLEDIFF.tex, append fragment nogaps keep(station_ownedby_*)  ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle nonumbers ///
		posthead("\midrule \ & \multicolumn{9}{c}{Panel B: Nexstar} \\\cmidrule(lr){2-10}") ///
		compress extracols(3 6) ///
		stats(N N_stations N_clust ymean, ///
			  fmt(%9.0f %9.0f %9.0f %9.3f ) ///
			  labels("Observations" "Stations" "DMAs (Clusters)" "Mean Dep. Variable")) 

// 3. GRAY

eststo clear

eststo: reghdfe rating_total_news		station_ownedby_gray_LMA ///
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

eststo: reghdfe rating_total_news		station_ownedby_gray_LMA ///
											if ever_sinclair==0, ///
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

eststo: reghdfe rating_total_news		station_ownedby_gray_LMA  ///
											if ever_nexstar==0, ///
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
										
eststo: reghdfe rating_total_news		station_ownedby_gray_LMA ///
											if ever_sinclair==0&ever_nexstar==0, ///
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

eststo: reghdfe rating_total_news		station_ownedby_gray_LMA  ///
										if ever_sinclair_dma==0, ///
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

eststo: reghdfe rating_total_news		station_ownedby_gray_LMA  ///
											if ever_nexstar_dma==0, ///
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
											
eststo: reghdfe rating_total_news		station_ownedby_gray_LMA ///
											if ever_sinclair_dma==0&ever_nexstar_dma==0, ///
											absorb(stationID date##dmacode##dmacode c.($station_controls)##i.date) cluster(dmacode)											
qui su `e(depvar)' if e(sample)==1
qui scalar ymean =  `r(mean)'
qui estadd scalar ymean 
qui unique stationID if e(sample)==1
qui scalar N_stations =  `r(unique)'
qui estadd scalar N_stations 
qui estadd local stationFE 		"\checkmark"
qui estadd local monthFE		"\checkmark"
qui estadd local controls		"\checkmark"

esttab using tables/ratings_spillovers_TRIPLEDIFF.tex, append fragment nogaps keep(station_ownedby_*)  ///
		noomitted nonotes se(%9.3f) b(%9.3f) ///
		label starlevels(* 0.10 ** 0.05 *** 0.01) nomtitle nonumbers ///
		posthead("\midrule \ & \multicolumn{9}{c}{Panel C: Gray} \\\cmidrule(lr){2-10}") ///
		postfoot("\bottomrule \end{tabular}}") ///
		compress extracols(4 7) ///
		stats(N N_stations N_clust ymean, ///
			  fmt(%9.0f %9.0f %9.0f %9.3f) ///
			  labels("Observations" "Stations" "DMAs (Clusters)" "Mean Dep. Variable")) 
			  




					
					