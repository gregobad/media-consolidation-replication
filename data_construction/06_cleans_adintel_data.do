// NOTE: requires data/adintel/adintel_clean_yearmonth.csv, a station-by-month aggregate of the proprietary
// Nielsen Ad Intel database (Kilts Center). NOT included in this archive; see README.

/////////////////////////
// CLEANS ADINTEL DATA //
/////////////////////////
	
import delimited "data/adintel/adintel_clean_yearmonth.csv", clear

g year=substr(periodyearmonth,1,4)
destring year, replace

g month=substr(periodyearmonth,6,2)
destring month, replace

cap drop date
gen date=ym(year,month)
format date %tm

tab year
drop if year==2009

// drops KYMA as it has lots of duplicates
drop if callsign=="KYMA"
drop if callsign=="KSPR" 

// renames variables
ren *_multimarket_* *_MM_*
ren *_local_* *_SM_*

// ren v19  	timeintervalnumber_SM_n
// ren v115	sum_total_duration_SM_n
ren total_duration_MM_nonne total_duration_MM_nonnews

duplicates tag callsign date, g(dup)

// this is needed to setup the data correctly 
foreach var of varlist n_ads* hh_* imp_* cpm_* rating_* total_half_hour* total_spend* total_duration* {
	cap drop temp
	cap drop max
	ren `var' temp
	bysort callsign date: egen `var'=max(temp)
	}

egen tag=tag(callsign date)	
keep if tag==1
	
merge 1:1 callsign date using data/acquisitions/acquisition_panel_station_top3_FINAL.dta

//     Result                      Number of obs
//     -----------------------------------------
//     Not matched                        52,422
//         from master                     3,397  (_merge==1)
//         from using                     49,025  (_merge==2)
//
//     Matched                            51,018  (_merge==3)
//     -----------------------------------------

drop if _m==1

// drops stations not in the content data
bysort stationID: egen missing=total((total_duration_MM_nonnews==.))
tab missing
drop if missing==132

unique stationID // 705 stations
unique fccid // 705 stations

bysort stationID: g N=_N
mdesc total_duration_MM_nonnews if N!=132 // these are stations that are not going to be relevant to the content analysis in any case
drop if missing==N // stations not in existance for the full period, but always missing in any case

drop _m

unique stationID // 695

// drop dayofweek_*
// drop timeintervalnumber_*
// drop sum_total_*
// drop total_30s_obs_*

//////////////////////////////////
// FIXES ZEROS AND MISSING DATA //
//////////////////////////////////

// creates total ads by news and nonnews programs
su n_ads_MM_news n_ads_SM_news, d

count if n_ads_MM_news!=. & n_ads_SM_news!=.
count if n_ads_MM_news!=. & n_ads_SM_news==.
count if n_ads_MM_news==. & n_ads_SM_news!=.
count if n_ads_MM_news==. & n_ads_SM_news==.

cap drop n_ads_news
g n_ads_news = .
replace n_ads_news = n_ads_MM_news + n_ads_SM_news 	if n_ads_MM_news!=. & n_ads_SM_news!=.
replace n_ads_news = n_ads_MM_news 				 	if n_ads_MM_news!=. & n_ads_SM_news==.

su n_ads_MM_nonnews n_ads_SM_nonnews, d

count if n_ads_MM_nonnews!=. & n_ads_SM_nonnews!=.
count if n_ads_MM_nonnews!=. & n_ads_SM_nonnews==.
count if n_ads_MM_nonnews==. & n_ads_SM_nonnews!=.
count if n_ads_MM_nonnews==. & n_ads_SM_nonnews==.

cap drop n_ads_nonnews
g n_ads_nonnews = .
replace n_ads_nonnews = n_ads_MM_nonnews + n_ads_SM_nonnews 	if n_ads_MM_nonnews!=. & n_ads_SM_nonnews!=.
replace n_ads_nonnews = n_ads_MM_nonnews 				 		if n_ads_MM_nonnews!=. & n_ads_SM_nonnews==.

su n_ads_news, d
su n_ads_nonnews, d

// sets duration and spending to missing (rather than zero) if no ads
su total_duration_MM_news total_spend_MM_news if n_ads_news==.
replace total_duration_MM_news=. if n_ads_news==.
replace total_spend_MM_news=. if n_ads_news==.

su total_duration_SM_news total_spend_SM_news if n_ads_news==.
replace total_duration_SM_news=. if n_ads_news==.
replace total_spend_SM_news=. if n_ads_news==.

su total_duration_MM_nonnews total_spend_MM_nonnews if n_ads_nonnews==.
replace total_duration_MM_nonnews=. if n_ads_nonnews==.
replace total_spend_MM_nonnews=. if n_ads_nonnews==.

su total_duration_SM_nonnews total_spend_SM_nonnews if n_ads_nonnews==.
replace total_duration_SM_nonnews=. if n_ads_nonnews==.
replace total_spend_SM_nonnews=. if n_ads_nonnews==.

cap drop total_duration_news
g total_duration_news = .
replace total_duration_news = total_duration_MM_news + total_duration_SM_news 	if n_ads_MM_news!=. & n_ads_SM_news!=.
replace total_duration_news = total_duration_MM_news 				 			if n_ads_MM_news!=. & n_ads_SM_news==.

cap drop total_spend_news
g total_spend_news = .
replace total_spend_news = total_spend_MM_news + total_spend_SM_news 	if n_ads_MM_news!=. & n_ads_SM_news!=.
replace total_spend_news = total_spend_MM_news 				 			if n_ads_MM_news!=. & n_ads_SM_news==.

cap drop total_duration_nonnews
g total_duration_nonnews = .
replace total_duration_nonnews = total_duration_MM_nonnews + total_duration_SM_nonnews 	if n_ads_MM_nonnews!=. & n_ads_SM_nonnews!=.
replace total_duration_nonnews = total_duration_MM_nonnews 				 			if n_ads_MM_nonnews!=. & n_ads_SM_nonnews==.

cap drop total_spend_nonnews
g total_spend_nonnews = .
replace total_spend_nonnews = total_spend_MM_nonnews + total_spend_SM_nonnews 	if n_ads_MM_nonnews!=. & n_ads_SM_nonnews!=.
replace total_spend_nonnews = total_spend_MM_nonnews 				 			if n_ads_MM_nonnews!=. & n_ads_SM_nonnews==.


// checks impressions
su imp_total_MM_news imp_total_SM_news if n_ads_news==.
su imp_total_MM_nonnews imp_total_SM_nonnews if n_ads_nonnews==.

g share_duration_MM_news = total_duration_MM_news/total_duration_news 
g share_duration_MM_nonnews = total_duration_MM_nonnews/total_duration_nonnews 

cap drop imp_total_news
g imp_total_news = .
replace imp_total_news = share_duration_MM_news*imp_total_MM_news + (1-share_duration_MM_news)*imp_total_SM_news 	if n_ads_MM_news!=. & n_ads_SM_news!=.
replace imp_total_news = imp_total_MM_news 				 		if n_ads_MM_news!=. & n_ads_SM_news==.

cap drop imp_total_nonnews
g imp_total_nonnews = .
replace imp_total_nonnews = share_duration_MM_nonnews*imp_total_MM_nonnews + (1-share_duration_MM_nonnews)*imp_total_SM_nonnews 	if n_ads_MM_nonnews!=. & n_ads_SM_nonnews!=.
replace imp_total_nonnews = imp_total_MM_nonnews 				 		if n_ads_MM_nonnews!=. & n_ads_SM_nonnews==.

cap drop imp_f_news
g imp_f_news = .
replace imp_f_news = share_duration_MM_news*imp_f_MM_news + (1-share_duration_MM_news)*imp_f_SM_news 	if n_ads_MM_news!=. & n_ads_SM_news!=.
replace imp_f_news = imp_f_MM_news			 		if n_ads_MM_news!=. & n_ads_SM_news==.

cap drop imp_m_news
g imp_m_news = .
replace imp_m_news = share_duration_MM_news*imp_m_MM_news + (1-share_duration_MM_news)*imp_m_SM_news 	if n_ads_MM_news!=. & n_ads_SM_news!=.
replace imp_m_news = imp_m_MM_news			 		if n_ads_MM_news!=. & n_ads_SM_news==.


cap drop imp_50_plus_news
g imp_50_plus_news = .
replace imp_50_plus_news = share_duration_MM_news*imp_50_plus_MM_news + (1-share_duration_MM_news)*imp_50_plus_SM_news 	if n_ads_MM_news!=. & n_ads_SM_news!=.
replace imp_50_plus_news = imp_50_plus_MM_news			 				if n_ads_MM_news!=. & n_ads_SM_news==.

cap drop imp_lt_50_news
g imp_lt_50_news = .
replace imp_lt_50_news = share_duration_MM_news*imp_lt_50_MM_news + (1-share_duration_MM_news)* imp_lt_50_SM_news 	if n_ads_MM_news!=. & n_ads_SM_news!=.
replace imp_lt_50_news = imp_lt_50_MM_news			 			if n_ads_MM_news!=. & n_ads_SM_news==.

// creates number of half hours (take max between the two, which is always the MM one for nonnews)
su total_half_hour_MM_news total_half_hour_SM_news if n_ads_news==.
count if total_half_hour_MM_news<total_half_hour_SM_news & total_half_hour_SM_news!=.
su total_half_hour_MM_news total_half_hour_SM_news if total_half_hour_MM_news<total_half_hour_SM_news & total_half_hour_SM_news!=.

su total_half_hour_MM_nonn total_half_hour_SM_nonnews if n_ads_nonnews==.
count if total_half_hour_MM_nonn<total_half_hour_SM_nonnews & total_half_hour_SM_nonnews!=.

cap drop total_half_hour_news 
egen total_half_hour_news = rowmax(total_half_hour_MM_news total_half_hour_SM_news)

cap drop total_half_hour_nonnews 
egen total_half_hour_nonnews = rowmax(total_half_hour_MM_nonn total_half_hour_SM_nonnews)

// spending & duration per half hour
g spend_perHH_nonnews = total_spend_nonnews / total_half_hour_nonnews
g spend_perHH_MM_nonnews = total_spend_MM_nonnews / total_half_hour_MM_nonn
g spend_perHH_SM_nonnews = total_spend_SM_nonnews / total_half_hour_SM_nonnews

g duration_perHH_nonnews = total_duration_nonnews / total_half_hour_nonnews
g duration_perHH_MM_nonnews = total_duration_MM_nonnews / total_half_hour_MM_nonn
g duration_perHH_SM_nonnews = total_duration_SM_nonnews / total_half_hour_SM_nonnews

g spend_perHH_news = total_spend_news / total_half_hour_news
g spend_perHH_MM_news = total_spend_MM_news / total_half_hour_MM_news
g spend_perHH_SM_news = total_spend_SM_news / total_half_hour_SM_news

g duration_perHH_news = total_duration_news / total_half_hour_news
g duration_perHH_MM_news = total_duration_MM_news / total_half_hour_MM_news
g duration_perHH_SM_news = total_duration_SM_news / total_half_hour_SM_news


/////////////////////////////////////////////
// FIXES AGGREAGATED DATA IN SWEEP MARKETS //
/////////////////////////////////////////////

// identifies stations with observations outside of sweep months
cap drop sweep_month
g sweep_month = (month==11|month==2|month==5|month==7)	

cap drop nonmissing_nonsweepmonth
cap drop missing_nonsweepmonth
cap drop missing

g nonmissing_nonsweep_month = 	(!missing(total_duration_MM_nonnews)&sweep_month==0) ///
								if year(dofm(date))<2018|(year(dofm(date))==2018&month(dofm(date))<7)
g missing_nonsweep_month    = 	(missing(total_duration_MM_nonnews)&sweep_month==0) ///
								if year(dofm(date))<2018|(year(dofm(date))==2018&month(dofm(date))<7)
g missing = missing(total_duration_MM_nonnews)
g preperiod = year(dofm(date))<2018|(year(dofm(date))==2018&month(dofm(date))<7)
						
cap drop N							 
bysort stationID: egen N = total(nonmissing_nonsweep_month)						 

tab N


//           N |      Freq.     Percent        Cum.
// ------------+-----------------------------------
//           0 |     69,828       76.12       76.12	 "standard" DMAs
//           8 |      1,056        1.15       77.27	 DMAs that also measure in October
//          17 |      1,584        1.73       78.99	 DMAs that also measure in October & January
//          19 |        264        0.29       79.28  DMAs that start being monthly in 2016 (+ one random missing month)
//          20 |      6,468        7.05       86.33  DMAs that start being monthly in 2016
//          67 |        132        0.14       86.47  LMP DMAs (+one random missing month)
//          68 |     12,408       13.53      100.00  LMP DMAs
// ------------+-----------------------------------
//       Total |     91,740      100.00


// sort fccid date
// br fccid date sweep_month N total_duration_MM_nonnews if N==20

tab month  if N==0&preperiod==1, su(missing)

tab month  if N==8&preperiod==1, su(missing)
replace sweep_month = 1 if N==8&month==10&preperiod==1

tab month  if N==17&preperiod==1, su(missing)
replace sweep_month = 1 if N==17&month==10&preperiod==1
replace sweep_month = 1 if N==17&month==1&preperiod==1

tab month  if N==19&preperiod==1, su(missing)
tab month  if N==19&preperiod==1&year<2016, su(missing)
replace preperiod=0 if N==19&year>=2016

tab month  if N==20&preperiod==1, su(missing)
tab month  if N==20&preperiod==1&year<2016, su(missing)
replace preperiod=0 if N==20&year>=2016

tab month  if N==67, su(missing)
replace preperiod=0 if N==67

tab month  if N==68, su(missing)
replace preperiod=0 if N==68

// creates the spells
cap drop spell
cap drop N_missing_months_in_spell
bysort stationID (date): g spell = sum(sweep_month)
bysort stationID spell: egen N_missing_months_in_spell = total(missing(total_duration_MM_nonnews))
replace N_missing_months_in_spell = N_missing_months_in_spell + 1

// note: 	plotting the number of total_half_hour* shows that those appear to refer to one month only
// 			they are similar 

foreach var of varlist total_duration* total_spend* n_ads* spend_perHH* duration_perHH* {
	
	ren `var' `var'_ORIG
	
	cap drop temp1
	cap drop temp2
	g temp1 = `var'_ORIG/N_missing_months
	bysort stationID spell: egen temp2 = max(cond(sweep_month==1 & preperiod==1, temp1, .))

	g `var' =  `var'_ORIG
	replace `var' = temp2 if preperiod==1
	
	}

drop temp1 temp2	

// IMPRESSIONS & HHs --> LINEARLY INTERPOLATE

foreach var of varlist imp_* hh_* {
	
	ren `var' `var'_ORIG

	cap drop temp
	bysort stationID (date): ipolate `var'_ORIG date, generate(temp)
	g `var' = `var'_ORIG
	replace `var' = temp if `var'==. & preperiod==1

	}

// SETS IMPRESSIONS TO MISSING FROM AUGUST 2013 TO JAN 2014
foreach var of varlist imp_*  {
	
	if regexm("`var'","_ORIG") {	
		}
	else {
		replace `var'=. if year==2013&month>=8
		replace `var'=. if year==2014&month==1
		}
	}
	

	
// RATINGS
cap drop rating_*

g rating_total_nonnews = imp_total_nonnews/hh_total*100	
g rating_total_MM_nonnews = imp_total_MM_nonnews/hh_total*100	
g rating_total_SM_nonnews = imp_total_SM_nonnews/hh_total*100		
g rating_total_news = imp_total_news/hh_total*100	
g rating_total_MM_news = imp_total_MM_news/hh_total*100	
g rating_total_SM_news = imp_total_SM_news/hh_total*100		

g rating_f_news = imp_f_news/hh_f*100	
g rating_m_news = imp_m_news/hh_m*100	
g rating_50_plus_news = imp_50_plus_news/hh_50_plus*100	
g rating_lt_50_news = imp_lt_50_news/hh_lt_50*100	


// CPM	
ren cpm_* cpm_*_ORIG
g cpm_nonnews = total_spend_nonnews/n_ads_nonnews/imp_total_nonnews*1000
g cpm_MM_nonnews = total_spend_MM_nonnews/n_ads_MM_nonnews/imp_total_MM_nonnews*1000
g cpm_SM_nonnews = total_spend_SM_nonnews/n_ads_SM_nonnews/imp_total_SM_nonnews*1000	
g cpm_news = total_spend_news/n_ads_news/imp_total_news*1000	
g cpm_MM_news = total_spend_MM_news/n_ads_MM_news/imp_total_MM_news*1000	
g cpm_SM_news = total_spend_SM_news/n_ads_SM_news/imp_total_SM_news*1000		

// LOGS
foreach var of varlist 	n_ads*_news ///
						n_ads*_nonnews ///
						total_duration*_nonnews ///
						total_duration*_news ///
						total_spend*_news ///
						total_spend*_nonnews ///
						imp_total*_news imp_f_news imp_m_news imp_50_plus_news imp_lt_50_news ///
						imp_total*_nonnews /// 
						cpm*_nonnews ///
						cpm*_news ///
						duration_perHH_*news ///
						spend_perHH_*news  {
							
	g log_`var' = log(`var')
	g asinh_`var' = asinh(`var')
	
	}

save data/adintel/adintel_clean_updated.dta, replace


