// NOTE: requires data/harmony/harmony_mentions_station_month.csv, a station-by-month aggregate of the proprietary
// TVEyes closed-caption transcripts (archived by Harmony Labs). NOT included in this archive; see README.

/////////////////////////
// CLEANS CONTENT DATA //
/////////////////////////
			  
import delimited "data/harmony/harmony_mentions_station_month.csv", clear

ren date date_str
g year = substr(date_str,1,4)
destring year, replace

g month = substr(date_str,6,2)
destring month, replace

gen date=ym(year,month)
format date %tm

duplicates tag callsign date, g(dup)
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


merge 1:1 callsign date using data/acquisitions/acquisition_panel_station_top3_FINAL.dta

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
//         Master only (1) |     10,926       13.03       13.03
//          Using only (2) |      3,573        4.26       17.30
//             Matched (3) |     69,330       82.70      100.00
// ------------------------+-----------------------------------
//                   Total |     83,829      100.00

drop if _m==1

// drops stations not in the content data
bysort stationID: egen missing=total((mention_place_total==.))
drop if missing==96

unique stationID // 733 stations
unique fccid // 733 stations

bysort stationID: g N=_N
mdesc mention_place_total if N!=96 // these are stations that are not going to be relevant to the content analysis in any case
drop if missing==N // stations not in existance for the full period, but always missing in any case

drop _m

// /////////////////////
// // CHECKS THE DATA //
// /////////////////////
//
// cap drop tag_date
// egen tag_date=tag(date)
//
// cap drop n_programs_tot
// bysort date: egen n_programs_tot=total(n_progs)
//
// tw line n_programs_tot date if tag_date==1, ///
// 		graphr(c(white)) ///
// 		bgcolor(white) ///
// 		title("Overall # of Programs per Month", c(black)) ///
// 		xlabel(636(12)731, grid valuel glc(gs12) glp(dot) format(%tmCY)) ///
// 		ytick(, notick nolabel) ///
// 		ylabel(, glc(gs12) glp(dot)) ///
// 		ytitle("Number of Programs", c(black)) ///
// 		xtitle("", c(black)) ///
// 		legend(off)
//
// cap drop zero_programs
// cap drop zeros
// g zero_programs = n_progs == 0
// bysort date: egen zeros=total(zero_programs)
//
// tw line zeros date if tag_date==1, ///
// 		graphr(c(white)) ///
// 		bgcolor(white) ///
// 		title("Number of Stations with Zero Programs", c(black)) ///
// 		xlabel(636(12)731, grid valuel glc(gs12) glp(dot)  format(%tmCY)) ///
// 		ytick(, notick nolabel) ///
// 		ylabel(, glc(gs12) glp(dot)) ///
// 		ytitle("Number of Stations with Zero Programs", c(black)) ///
// 		xtitle("", c(black)) ///
// 		legend(off)
//
// cap drop mean
// bysort date: egen mean=mean(mention_place_pershow)
//
// tw line mean date if tag_date==1, ///
// 		graphr(c(white)) ///
// 		bgcolor(white) ///
// 		title("Mean Number of Place Mentions per Show", c(black)) ///
// 		xlabel(636(12)731, grid valuel glc(gs12) glp(dot) format(%tmCY)) ///
// 		ytick(, notick nolabel) ///
// 		ylabel(11(1)18, glc(gs12) glp(dot)) ///
// 		ytitle("Mean Number of Place Mentions per Show", c(black)) ///
// 		xtitle("", c(black)) ///
// 		legend(off)
		
// sets mentions equal to zero if there are no programs or no words

replace mention_place_total = .  if n_progs==0
replace mention_pol_local_total = .  if n_progs==0
replace mention_pol_stateleg_total = . if n_progs==0
replace mention_pol_congress_total = . if n_progs==0

replace mention_place_total = .  if n_words==0
replace mention_pol_local_total = .  if n_words==0
replace mention_pol_stateleg_total = . if n_words==0
replace mention_pol_congress_total = . if n_words==0

// checks the zero mentions
su n_progs if mention_place_total==0, d
su n_progs if mention_place_total!=0&mention_place_total!=., d

////////////////
// DROPS 2020 //
////////////////

// drops 2020
drop if year(dofm(date))==2020

////////////////////////////
// LOOKS AT ZERO MENTIONS //
////////////////////////////

cap drop zero_mentions
cap drop zeros
g zero_mentions = mention_place_total == 0
bysort stationID: egen has_zeros = max(zero_mentions)

unique stationID if has_zeros == 1 // 102
	
drop *pershow *perword *asinh

ren *_total* **

foreach var of varlist 	mention_place mention_pol_local mention_pol_stateleg ///
						mention_pol_national mention_pol_congress {
	g `var'_pershow=`var'/n_progs
	g `var'_perword=`var'/n_words
	}
	

// /////////////////////
// // CHECKS THE DATA //
// /////////////////////
//
// cap drop n_programs_tot
// bysort date: egen n_programs_tot=total(n_progs)
//
// tw line n_programs_tot date if tag_date==1, ///
// 		graphr(c(white)) ///
// 		bgcolor(white) ///
// 		title("Overall # of Programs per Month", c(black)) ///
// 		xlabel(636(12)719, grid valuel glc(gs12) glp(dot) format(%tmCY)) ///
// 		ytick(, notick nolabel) ///
// 		ylabel(, glc(gs12) glp(dot)) ///
// 		ytitle("Number of Programs", c(black)) ///
// 		xtitle("", c(black)) ///
// 		legend(off)
//
// cap drop mean
// bysort date: egen mean=mean(mention_place_pershow)
//
// tw line mean date if tag_date==1, ///
// 		graphr(c(white)) ///
// 		bgcolor(white) ///
// 		title("Mean Number of Place Mentions per Show", c(black)) ///
// 		xlabel(636(12)719, grid valuel glc(gs12) glp(dot) format(%tmCY)) ///
// 		ytick(, notick nolabel) ///
// 		ylabel(11(1)18, glc(gs12) glp(dot)) ///
// 		ytitle("Mean Number of Place Mentions per Show", c(black)) ///
// 		xtitle("", c(black)) ///
// 		legend(off)
//
// cap drop mean
// bysort date: egen mean=mean(mention_place_perword)
//
// tw line mean date if tag_date==1, ///
// 		graphr(c(white)) ///
// 		bgcolor(white) ///
// 		title("Mean Number of Place Mentions per Word", c(black)) ///
// 		xlabel(636(12)719, grid valuel glc(gs12) glp(dot) format(%tmCY)) ///
// 		ytick(, notick nolabel) ///
// 		ylabel(0.0028(0.0002)0.0038, glc(gs12) glp(dot)) ///
// 		ytitle("Mean Number of Place Mentions per Word", c(black)) ///
// 		xtitle("", c(black)) ///
// 		legend(off)	
		
// creates outcome variable

cap drop log_mention_place_pershow
g log_mention_place_pershow = log(mention_place_pershow)

replace mention_place_perword=mention_place_perword*100

cap drop log_mention_place_perword
g log_mention_place_perword = log(mention_place_perword)

label var log_mention_place_pershow		"Log Place Mentions by Program"
label var log_mention_place_perword		"Log Place Mentions by Word"

label var mention_place_pershow			"Place Mentions by Program"
label var mention_place_perword			"Place Mentions by Word"

g mention_place_pershow_w99 = mention_place_pershow
su mention_place_pershow_w99, d
replace mention_place_pershow_w99=`r(p99)' if mention_place_pershow_w99>`r(p99)'&mention_place_pershow_w99!=.

g mention_place_perword_w99 = mention_place_perword
su mention_place_perword_w99, d
replace mention_place_perword_w99=`r(p99)' if mention_place_perword_w99>`r(p99)'&mention_place_perword_w99!=.

g mention_pol_congress_pershow_w99 = mention_pol_congress_pershow
su mention_pol_congress_pershow_w99, d
replace mention_pol_congress_pershow_w99=`r(p99)' if mention_pol_congress_pershow_w99>`r(p99)'&mention_pol_congress_pershow_w99!=.


///////////////////////////////////////////////
// BALANCED SAMPLE							 //
///////////////////////////////////////////////

// identifies balanced sample for the main content data
cap drop N
egen N = total(!missing(mention_place) & !missing(mention_place)), by(stationID)
tab N

g balanced_sample=(N==84)

// drops staitons that are always missing
drop if N==0

unique stationID // 723
unique stationID if balanced_sample==1 // 618

drop N

save data/harmony/content_cleaned.dta, replace









