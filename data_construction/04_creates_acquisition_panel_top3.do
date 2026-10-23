// NOTE: requires data/acquisitions/UofWarwickTVJuly2018.xlsx (BIA/Kelsey station database, licensed; NOT included in this archive).
// Its outputs, data/acquisitions/acquisition_panel_station_top3_FINAL.dta and acquisition_panel_dma_top3_FINAL.dta, ARE included.

///////////////////////////////
// CREATES ACQUISITION PANEL //
///////////////////////////////

////////////////////////////////////////
// GETS STATIONS FROM BIA/KELSEY DATA //
////////////////////////////////////////

use data/acquisitions/callsign_history_cleaned.dta, replace

bysort fccid (from_ym): g n=_n

reshape wide callsign from_ym to_ym, i(fccid) j(n) 

// creates yearly panel
expand 11
sort fccid
bysort fccid: g year=_n+2009

// creates monthly panel
expand 12
sort fccid year 
egen month = fill(1/12 1/12)
sort fccid year month
g yearmonth = ym(year, month)
format yearmonth %tm

///////////////////////////////
// CREATES CALLSIGN VARIABLE //
///////////////////////////////

g callsign = ""
replace callsign = callsign1 if yearmonth>=from_ym1&yearmonth<=to_ym1
replace callsign = callsign2 if yearmonth>=from_ym2&yearmonth<=to_ym2
replace callsign = callsign3 if yearmonth>=from_ym3&yearmonth<=to_ym3
replace callsign = callsign4 if yearmonth>=from_ym4&yearmonth<=to_ym4
replace callsign = callsign5 if yearmonth>=from_ym5&yearmonth<=to_ym5

mdesc callsign 

// note that there are stations that are founded/on air after 2010!
// we drop these observations before the founding

drop if callsign==""

bysort fccid: egen number_callsigns=nvals(callsign) 
g changes_callsigns = (number_callsigns>1)

egen stationID = group(fccid)

keep stationID fccid yearmonth callsign changes_callsigns

/////////////////////////////////////////////////
// MERGES IN ACQUISITION DATA FOR ALL STATIONS //
/////////////////////////////////////////////////

preserve
import excel data/acquisitions/acquisition_dates_03feb2026.xlsx,  sheet("acquisitions_dates") firstrow clear  

// drops LIN
drop if acquiring_group=="LIN Television Corp"
drop if acquiring_group=="Media General"
drop if acquiring_group=="Raycom Media Inc"

// drops acquisitions from conglomerate to conglomerate
drop if selling_group=="Gray Television Inc"
drop if selling_group=="Sinclair Bcst Group"
drop if selling_group=="Nexstar Bcstg Group"

// if two acquisistions in the dataset, keep only the earliest one (these are group to group)
bysort fccid (acq_date):  g N=_N
list if N!=1

drop if fccid==35991&acq_date==201701

cap drop N
bysort fccid (acq_date):  g N=_N
qui count if N!=1
assert `r(N)'==0

// creates date
tostring acq_date, gen(acq_date_str)
g acq_year_str=substr(acq_date_str,1,4)
g acq_year_month=substr(acq_date_str,5,2)
destring acq_year_str acq_year_month, replace

g acq_ym = ym(acq_year_str, acq_year_month)
format acq_ym %tm

// only keeps acqisisitions after 2010 as the other (always treated are going to be from BIA/Kelsey)
tab acq_ym if year(dofm(acq_ym))<2010
drop if year(dofm(acq_ym))<2010

// renames vars
ren station_clean callsign_new

// selects vars
keep fccid acquiring_group selling_group acq_ym callsign_new

bysort acq_ym acquiring_group selling_group: g stations_in_bundle = _N 

tempfile acquisitions
save `acquisitions'
restore

merge m:1 fccid using `acquisitions'

//     Result                      Number of obs
//     -----------------------------------------
//     Not matched                        73,544
//         from master                    73,511  (_merge==1) // stations never acquired
//         from using                         33  (_merge==2) // acquired stations that are not big4 affiliates or are not in the TVEyes data
//
//     Matched                            28,908  (_merge==3)
//     -----------------------------------------

list if  _m==2

// fccid	callsi~w	acquiring_group	selling_group	acq_ym	
// 20624	WMYT	Nexstar Bcstg Group	Fox Corporation	2020m3	CW
// 65128	WHDF	Nexstar Bcstg Group	Huntsville TV	2018m11	CW
// 166319	KRBK	Nexstar Bcstg Group	KRBK LLC		2018m11	FOX 
// 35909	KBVO	Nexstar Bcstg Group	Media General	2017m1	Independent
// 71905	WNLO	Nexstar Bcstg Group	Media General	2017m1	CW
// 4145		KAII	Nexstar Bcstg Group	Media General	2017m1	Hawaii
// 4108		WTTA	Nexstar Bcstg Group	Media General	2017m1	CW
// 72361	KSNG	Nexstar Bcstg Group	Media General	2017m1	NBC
// 83943	WFNA	Nexstar Bcstg Group	Media General	2017m1	CW
// 4146		KHAW	Nexstar Bcstg Group	Media General	2017m1	CW
// 41975	KDLO	Nexstar Bcstg Group	Media General	2017m1	CBS
// 33081	WCTX	Nexstar Bcstg Group	Media General	2017m1	MyNetworkTV
// 10212	WOTV	Nexstar Bcstg Group	Media General	2017m1	ABC
// 65526	KRON	Nexstar Bcstg Group	Media General	2017m1	CW
// 72359	KSNC	Nexstar Bcstg Group	Media General	2017m1	NBC
// 48556	KBIM	Nexstar Bcstg Group	Media General	2017m1	CBS
// 28462	WNDY	Nexstar Bcstg Group	Media General	2017m1	MyNetworkTV
// 35670	KTLA	Nexstar Bcstg Group	Tribune			2019m9	CW
// 10192	KRCW	Nexstar Bcstg Group	Tribune			2019m9	CW
// 50182	KAUT	Nexstar Bcstg Group	Tribune			2019m9	Independent
// 35883	KWGN	Nexstar Bcstg Group	Tribune			2019m9	CW
// 125		KFCT	Nexstar Bcstg Group	Tribune			2019m9	FOX
// 73879	WPHL	Nexstar Bcstg Group	Tribune			2019m9	MNTV
// 73150	WJW		Nexstar Bcstg Group	Tribune			2019m9	FOX
// 23394	KIAH	Nexstar Bcstg Group	Tribune			2019m9	CW
// 22201	KDAF	Nexstar Bcstg Group	Tribune			2019m9	CW
// 35417	KPLR	Nexstar Bcstg Group	Tribune			2019m9	CW
// 54280	WNOL	Nexstar Bcstg Group	Tribune			2019m9	CW
// 30576	WDCW	Nexstar Bcstg Group	Tribune			2019m9	CW
// 56526	WTTK	Nexstar Bcstg Group	Tribune			2019m9	CBS
// 72115	WGN		Nexstar Bcstg Group	Tribune			2019m9	Independent
// 69571	KZJO	Nexstar Bcstg Group	Tribune			2019m9	MNTV
// 81593	KXNW	Nexstar Bcstg Group	Tribune			2019m9	MNTV

drop if _m==2

// checks for callsign changes
tab _m changes_callsigns

tab fccid if changes_callsigns==1&_m==3

//       fccID |      Freq.     Percent        Cum.
// ------------+-----------------------------------
//       17688 |        132       25.00       25.00
//       34347 |        132       25.00       50.00
//       49760 |        132       25.00       75.00
//       82910 |        132       25.00      100.00
// ------------+-----------------------------------
//       Total |        528      100.00

count if changes_callsigns==1&_m==3&fccid!=34347&fccid!=49760&fccid!=82910&fccid!=17688
assert `r(N)'==0

drop _m


/////////////////////////////////////////////////
// MERGES IN ACQUISITION DATA FOR LP STATIONS  //
/////////////////////////////////////////////////

preserve
import excel data/acquisitions/acquisition_dates_03feb2026.xlsx,  sheet("acquisitions_dates_LP_stations") firstrow clear  

cap drop notes

// creates date
tostring acq_date, gen(acq_date_str) 
g acq_year_str=substr(acq_date_str,1,4)
g acq_year_month=substr(acq_date_str,5,2)
destring acq_year_str acq_year_month, replace

g acq_ym = ym(acq_year_str, acq_year_month)
format acq_ym %tm

// only keeps acqisisitions after 2010 as the other (always treated are going to be from BIA/Kelsey)
tab acq_ym if year(dofm(acq_ym))<2010
drop if year(dofm(acq_ym))<2010

// selects vars
keep fccid acquiring_group selling_group acq_ym

ren acquiring_group acquiring_group_LP
ren selling_group selling_group_LP
ren acq_ym acq_ym_LP

drop if acquiring_group_LP=="LIN Television Corp"
drop if acquiring_group_LP=="Media General"
drop if acquiring_group_LP=="Raycom Media Inc"

destring fccid, replace

tempfile acquisitions
save `acquisitions'
restore

merge m:1 fccid using `acquisitions'

//     Result                      Number of obs
//     -----------------------------------------
//     Not matched                        99,918
//         from master                    99,918  (_merge==1)
//         from using                          0  (_merge==2)
//
//     Matched                             2,501  (_merge==3)
//     -----------------------------------------

drop if _m==2

// checks for callsign changes
tab _m changes_callsigns

tab fccid if changes_callsigns==1&_m==3

//       fccID |      Freq.     Percent        Cum.
// ------------+-----------------------------------
//       40244 |        132       16.69       16.69
//       49285 |        132       16.69       33.38
//      125125 |        132       16.69       50.06
//      128063 |        132       16.69       66.75
//      167735 |        132       16.69       83.44
//      182840 |        131       16.56      100.00
// ------------+-----------------------------------
//       Total |        791      100.00

drop _m


//////////////////////////////////////////////////////////////
// ALWAYS TREATED, STATIONS IN BIA/KELSEY DATA              //
// ALWAYS TREATED LP STATIONS FROM EXCEL FILE JUST IMPORTED //
//////////////////////////////////////////////////////////////

preserve 
import excel data/acquisitions/UofWarwickTVJuly2018.xlsx, sheet("2009") firstrow clear

ren CALLS callsign
ren Owner owner
ren FCCIDNumber fccid
ren Affiliation affiliation

tab owner if regexm(lower(owner),"sinclair")
tab owner if regexm(lower(owner),"nexstar")
tab owner if regexm(lower(owner),"gray")

replace owner="" if 	!(owner=="Sinclair Bcst Group"| ///
						owner=="Nexstar Bcstg Group"| ///
						owner=="Gray Television Inc")
		
replace callsign=subinstr(callsign,"-TV","",.)

drop if fccid==0

ren owner initial_group
ren MarketName marketname

// drops WTTA, which shows up as being O&O by Sinclair in BIA/Kelsey data but is owned by Bay TV from other sources
drop if fccid==4108

keep fccid callsign initial_group marketname 

// 1135. |               Palm Springs, CA       KESQ   25577 |
// 1136. |               Palm Springs, CA       KMIR   16749 |


tempfile always
save `always'
restore

merge m:1 fccid using `always'

//     Result                      Number of obs
//     -----------------------------------------
//     Not matched                         6,583
//         from master                     5,927  (_merge==1) THESE ARE LP STATIONS, INFORMATION FOR THESE FROM EARLIER EXCEL FILE ALREADY
//         from using                        669  (_merge==2) THESE ARE STATIONS NOT IN TVEYES DATA (MOSTLY NOT BIG4, SATELLITES)
//
//     Matched                            96,492  (_merge==3)
//     -----------------------------------------

drop if _m==2 
drop _merge

//////////////////////////////////////////////////
// GETS ADDIITIONAL INFORMATION FOR LP STATIONS //
//////////////////////////////////////////////////

preserve
import excel data/acquisitions/information_LP_stations.xlsx,  sheet("LP_stations") firstrow clear  

drop if fccid==.

keep fccid dma initial_owner
ren dma marketname
ren initial_owner initial_group_LP
replace initial_group_LP="" if initial_group_LP=="not_conglomerate"

drop if marketname=="Anchorage, AK"

tempfile LP_stations
save `LP_stations'
restore

merge m:1 fccid using `LP_stations', update

//     Result                      Number of obs
//     -----------------------------------------
//     Not matched                        96,492
//         from master                    96,492  (_merge==1)
//         from using                          0  (_merge==2)
//
//     Matched                             5,927
//         not updated                         0  (_merge==3)
//         missing updated                 5,927  (_merge==4)
//         nonmissing conflict                 0  (_merge==5)
//     -----------------------------------------


g LP_station = (_m==4)

drop _m

count if marketname==""
assert `r(N)'==0

// checks whether we have acquisition for always owned stations
count if initial_group!=""&initial_group_LP!=""
replace initial_group=initial_group_LP if initial_group==""&initial_group_LP!=""

tab callsign if acquiring_group!=""&initial_group!=""
qui count if acquiring_group!=""&initial_group!=""
assert `r(N)'==0

replace acq_ym=. if acquiring_group!=""&initial_group!=""
replace selling_group="" if acquiring_group!=""&initial_group!=""
replace acquiring_group="" if acquiring_group!=""&initial_group!=""

count if acquiring_group!=""&initial_group!=""
assert `r(N)'==0


/////////////////////////
// MERGES IN DMA CODES //
/////////////////////////

preserve
import excel "data/tv/dma_names_xwalk.xlsx", sheet("Sheet1") firstrow clear
tempfile xwalk
save `xwalk'
restore

merge m:1 marketname using `xwalk'

qui count if _m!=3
assert `r(N)'==0
keep if _m==3
drop _m

preserve
import delimited "data/tv/dmacodes.csv", clear 
ren dma dmacode
ren market dma
replace dma=strtrim(dma)
replace dma=subinstr(dma,",","",.)
tempfile xwalk_2
save `xwalk_2'
restore 

merge m:1 dma using `xwalk_2'

qui count if _m!=3
assert `r(N)'==0
keep if _m==3
drop _m

drop DMA_from_DMA2008

/////////////////////////////////////////
// MERGES IN LMAS AND OTHER AGREEMENTS //
/////////////////////////////////////////

preserve
import excel data/acquisitions/JSA_SSA_LMA_dates_03feb2026.xlsx,  sheet("Full") firstrow clear  

keep fccid callsign agreement_type start_date group_providing_services

replace start_date = "1 JAN 2010" if start_date=="PRE-2010, NO EXACT DATE"
ren start_date agmt_start_date_str

g agm_start_year_str=substr(agmt_start_date_str,length(agmt_start_date_str)-3,4)
g agm_start_month_str=substr(agmt_start_date_str,length(agmt_start_date_str)-7,3)

replace agm_start_month_str="01" if  agm_start_month_str=="JAN"
replace agm_start_month_str="02" if  agm_start_month_str=="FEB"
replace agm_start_month_str="03" if  agm_start_month_str=="MAR"
replace agm_start_month_str="04" if  agm_start_month_str=="APR"
replace agm_start_month_str="05" if  agm_start_month_str=="MAY"
replace agm_start_month_str="06" if  agm_start_month_str=="JUN"
replace agm_start_month_str="07" if  agm_start_month_str=="JUL"
replace agm_start_month_str="08" if  agm_start_month_str=="AUG"
replace agm_start_month_str="09" if  agm_start_month_str=="SEP"
replace agm_start_month_str="10" if  agm_start_month_str=="OCT"
replace agm_start_month_str="11" if  agm_start_month_str=="NOV"
replace agm_start_month_str="12" if  agm_start_month_str=="DEC"

destring agm_start_year_str agm_start_month_str, replace

g LMA_start_date = ym(agm_start_year_str, agm_start_month_str) if agreement_type=="LMA"|agreement_type=="TBA"
format LMA_start_date %tm

g SSA_start_date = ym(agm_start_year_str, agm_start_month_str) if !(agreement_type=="LMA"|agreement_type=="TBA")
format SSA_start_date %tm

	 
drop if group_providing_services=="LIN Television Corp"
drop if group_providing_services=="Media General"
drop if group_providing_services=="Raycom Media Inc"


duplicates tag fccid, g(dup)
sort fccid LMA_start_date  SSA_start_date
list fccid callsign agreement_type agmt_start_date_str group_providing_services if dup!=0

//      +-----------------------------------------------------------------+
//      | fccid   callsign   agreeme~e   agmt_sta~r   group_providing_s~s |
//      |-----------------------------------------------------------------|
//   1. |   144       KNVA         LMA   1 DEC 2014         Media General | OK
//   2. |   144       KNVA         LMA   1 JAN 2017   Nexstar Bcstg Group |
//  15. |  4693       WYTV   SSA & JSA   1 DEC 2014         Media General | OK
//  16. |  4693       WYTV   SSA & JSA   1 JAN 2017   Nexstar Bcstg Group | 
//  36. | 11970       WXXA   SSA & JSA   1 DEC 2012         Media General | OK 
//  37. | 11970       WXXA   SSA & JSA   1 JAN 2017   Nexstar Bcstg Group |
//  72. | 36533       WLAJ         LMA   1 NOV 2011   Sinclair Bcst Group | SEE BELOW
//  73. | 36533       WLAJ   SSA & JSA   1 MAR 2013         Media General |
//  74. | 36533       WLAJ   SSA & JSA   1 JAN 2017   Nexstar Bcstg Group |
//  83. | 49397       KTKA   SSA & JSA   1 DEC 2014         Media General | OK
//  84. | 49397       KTKA   SSA & JSA   1 JAN 2017   Nexstar Bcstg Group |
//  92. | 55049       KASY   SSA & JSA   1 DEC 2014         Media General | OK
//  93. | 55049       KASY         SSA   1 JAN 2017   Nexstar Bcstg Group |
// 110. | 70138       WBDT   SSA & JSA   1 DEC 2014         Media General | OK
// 111. | 70138       WBDT   SSA & JSA   1 JAN 2017   Nexstar Bcstg Group |
// 125. | 73311       WNAC         LMA   1 DEC 2014         Media General | OK
// 126. | 73311       WNAC         LMA   1 JAN 2017   Nexstar Bcstg Group |
// 137. | 76268       KWBQ   SSA & JSA   1 DEC 2014         Media General | OK
// 138. | 76268       KWBQ         SSA   1 JAN 2017   Nexstar Bcstg Group |
// 144. | 84157       KRWB   SSA & JSA   1 DEC 2014         Media General | OK
// 145. | 84157       KRWB         SSA   1 JAN 2017   Nexstar Bcstg Group |
//      +-----------------------------------------------------------------+


drop if fccid==36533&group_providing_services=="Nexstar Bcstg Group"

drop dup
duplicates tag fccid, g(dup)
sort fccid LMA_start_date  SSA_start_date
list fccid callsign agreement_type agmt_start_date_str group_providing_services if dup!=0

// sets intiail date 1 JAN 2010 if earlier
replace LMA_start_date=ym(2010,1) if year(dofm(LMA_start_date))<2010
replace SSA_start_date=ym(2010,1) if year(dofm(SSA_start_date))<2010

tempfile agmts
save `agmts'
restore

merge m:1 fccid using `agmts'

//     Result                      Number of obs
//     -----------------------------------------
//     Not matched                        92,173
//         from master                    92,123  (_merge==1)
//         from using                         52  (_merge==2) STATIONS NOT IN MASTERFILE
//
//     Matched                            10,296  (_merge==3)
//     -----------------------------------------

drop if _m==2
drop _m

/////////////////////////////
/////////////////////////////
// STATION LEVEL TREATMENT //
/////////////////////////////
/////////////////////////////

cap drop tag
egen tag=tag(fccid)

///////////////////////
// ACQUISITION DATES //
///////////////////////

// sinclair
g ownedby_sinclair_date=.
replace ownedby_sinclair_date=ym(2010,1) if initial_group=="Sinclair Bcst Group"
replace ownedby_sinclair_date=acq_ym if acquiring_group=="Sinclair Bcst Group"
replace ownedby_sinclair_date=acq_ym_LP if acquiring_group_LP=="Sinclair Bcst Group"&LP_station==1

// gray
g ownedby_gray_date=.
replace ownedby_gray_date=ym(2010,1) if initial_group=="Gray Television Inc"
replace ownedby_gray_date=acq_ym if acquiring_group=="Gray Television Inc"
replace ownedby_gray_date=acq_ym_LP if acquiring_group_LP=="Gray Television Inc"&LP_station==1

// nexstar
g ownedby_nexstar_date=.
replace ownedby_nexstar_date=ym(2010,1) if initial_group=="Nexstar Bcstg Group"
replace ownedby_nexstar_date=acq_ym if acquiring_group=="Nexstar Bcstg Group"
replace ownedby_nexstar_date=acq_ym_LP if acquiring_group_LP=="Nexstar Bcstg Group"&LP_station==1

format ownedby*date %tm

/////////////////////
// AGREEMENT DATES //
/////////////////////

// sinclair
g LMA_sinclair_date=.
replace LMA_sinclair_date=LMA_start_date if group_providing_services=="Sinclair Bcst Group"
g SSA_sinclair_date=.
replace SSA_sinclair_date=SSA_start_date if group_providing_services=="Sinclair Bcst Group"

// gray
g LMA_gray_date=.
replace LMA_gray_date=LMA_start_date if group_providing_services=="Gray Television Inc"
g SSA_gray_date=.
replace SSA_gray_date=SSA_start_date if group_providing_services=="Gray Television Inc"

// nexstar
g LMA_nexstar_date=.
replace LMA_nexstar_date=LMA_start_date if group_providing_services=="Nexstar Bcstg Group"
g SSA_nexstar_date=.
replace SSA_nexstar_date=SSA_start_date if group_providing_services=="Nexstar Bcstg Group"

format LMA*date %tm
format SSA*date %tm


///////////////////////////
// CHECKS DATE CONFLICTS //
///////////////////////////

cap drop tag
egen tag=tag(fccid)

// sinclair
list fccid LMA_sinclair_date ownedby_gray_date if LMA_sinclair_date!=.&ownedby_gray_date!=.&tag==1
list fccid LMA_sinclair_date ownedby_nexstar_date if LMA_sinclair_date!=.&ownedby_nexstar_date!=.&tag==1

list fccid SSA_sinclair_date ownedby_gray_date if SSA_sinclair_date!=.&ownedby_gray_date!=.&tag==1
list fccid SSA_sinclair_date ownedby_nexstar_date if SSA_sinclair_date!=.&ownedby_nexstar_date!=.&tag==1

//  pay attention to these cases when defining treatment variables
//  under O&O version, keep nexstar ownership
//  under LMA/SSA, also keep nexstar ownership as it comes first
//  so, can fix by setting as missing the sinclair SSA
//         +-----------------------------+
//         | fccid   SSA_si~e   o~nexs~e |
//         |-----------------------------|
//  72997. | 61214    2012m12     2010m1 |
//         +-----------------------------+

replace SSA_sinclair_date=. if fccid==61214

// nexstar
list fccid LMA_nexstar_date ownedby_gray_date if LMA_nexstar_date!=.&ownedby_gray_date!=.&tag==1
list fccid LMA_nexstar_date ownedby_sinclair_date if LMA_nexstar_date!=.&ownedby_sinclair_date!=.&tag==1

list fccid SSA_nexstar_date ownedby_gray_date if SSA_nexstar_date!=.&ownedby_gray_date!=.&tag==1
list fccid SSA_nexstar_date ownedby_sinclair_date if SSA_nexstar_date!=.&ownedby_sinclair_date!=.&tag==1

//  pay attention to these cases when defining treatment variables
//  under O&O version, keep sinclair ownership
//  under LMA/SSA, also keep nexstar ownership as it comes first (1996 vs 2001)
//         +-----------------------------+
//         | fccid   SSA_ne~e   o~sinc~e |
//         |-----------------------------|
//   1321. |   413     2010m1     2010m1 |
//   7657. |  5875     2010m1     2010m1 |
//         +-----------------------------+

replace SSA_nexstar_date=. if fccid==413
replace SSA_nexstar_date=. if fccid==5875

// gray
list fccid LMA_gray_date ownedby_nexstar_date if LMA_gray_date!=.&ownedby_nexstar_date!=.&tag==1
list fccid LMA_gray_date ownedby_sinclair_date if LMA_gray_date!=.&ownedby_sinclair_date!=.&tag==1

list fccid SSA_gray_date ownedby_nexstar_date if SSA_gray_date!=.&ownedby_nexstar_date!=.&tag==1
list fccid SSA_gray_date ownedby_sinclair_date if SSA_gray_date!=.&ownedby_sinclair_date!=.&tag==1

// CLEANS MARKETS

drop if marketname=="Anchorage, AK"
drop if marketname=="Fairbanks, AK"
drop if marketname=="Juneau, AK"
drop if marketname=="Honolulu, HI"

//////////////////////////////////////
// BASELINE TREATMENT		        //
// INCLUDES O&O + LMAs 		        //
//////////////////////////////////////

// these are indicator variables = 1 after a given conglomerate owns a station
// it ignores divestitures/mergers/etc 
// they always sum up to 1 

ren yearmonth date

g ownedby_sinclair_LMA = 0
replace ownedby_sinclair_LMA = 1 if date >= ownedby_sinclair_date
replace ownedby_sinclair_LMA = 1 if date >= LMA_sinclair_date

g ownedby_gray_LMA = 0
replace ownedby_gray_LMA = 1 if date >= ownedby_gray_date
replace ownedby_gray_LMA = 1 if date >= LMA_gray_date

g ownedby_nexstar_LMA = 0
replace ownedby_nexstar_LMA = 1 if date >= ownedby_nexstar_date
replace ownedby_nexstar_LMA = 1 if date >= LMA_nexstar_date

egen check=rsum(ownedby_sinclair_LMA ownedby_gray_LMA ownedby_nexstar_LMA)
count if check!=0&check!=1
assert `r(N)'==0
drop check

egen ownedby_congl_LMA=rmax(ownedby_sinclair_LMA ownedby_gray_LMA ownedby_nexstar_LMA)

bysort fccid: egen ownedby_congl_LMA_date = min(date/(ownedby_congl_LMA==1))
format ownedby_congl_LMA_date %tm

label var ownedby_sinclair_LMA 		"Post-Acquisition, Sinclair"
label var ownedby_gray_LMA		 	"Post-Acquisition, Gray"
label var ownedby_nexstar_LMA 		"Post-Acquisition, Nexstar"
label var ownedby_congl_LMA 		"Post-Acquisition"


//////////////////////////////////////
// ROBUSTNESS # 1   		        //
// INCLUDES O&O + LMAs + SSAs       //
//////////////////////////////////////

g ownedby_sinclair_SSA = 0
replace ownedby_sinclair_SSA = 1 if date >= ownedby_sinclair_date
replace ownedby_sinclair_SSA = 1 if date >= LMA_sinclair_date
replace ownedby_sinclair_SSA = 1 if date >= SSA_sinclair_date

g ownedby_gray_SSA = 0
replace ownedby_gray_SSA = 1 if date >= ownedby_gray_date
replace ownedby_gray_SSA = 1 if date >= LMA_gray_date
replace ownedby_gray_SSA = 1 if date >= SSA_gray_date
replace ownedby_gray_SSA = 0 if fccid==53820 // KYOU, HAS LMA WITH RAYCOM THAT PRECEEDS THE ACQUISITION

g ownedby_nexstar_SSA = 0
replace ownedby_nexstar_SSA = 1 if date >= ownedby_nexstar_date
replace ownedby_nexstar_SSA = 1 if date >= LMA_nexstar_date
replace ownedby_nexstar_SSA = 1 if date >= SSA_nexstar_date

egen check=rsum(ownedby_sinclair_SSA ownedby_gray_SSA ownedby_nexstar_SSA)
count if check!=0&check!=1
assert `r(N)'==0
drop check

egen ownedby_congl_SSA=rmax(ownedby_sinclair_SSA ownedby_gray_SSA ownedby_nexstar_SSA)

bysort fccid: egen ownedby_congl_SSA_date = min(date/(ownedby_congl_SSA==1))
format ownedby_congl_SSA_date %tm

label var ownedby_sinclair_SSA 		"Post-Acquisition, Includes SSAs, Sinclair"
label var ownedby_gray_SSA		 	"Post-Acquisition, Includes SSAs, Gray"
label var ownedby_nexstar_SSA 		"Post-Acquisition, Includes SSAs, Nexstar"
label var ownedby_congl_SSA 		"Post-Acquisition, Includes SSAs"


//////////////////////////////////////
// ROBUSTNESS # 2   		        //
// O&O ONLY					        //
//////////////////////////////////////

g ownedby_sinclair_OO = 0
replace ownedby_sinclair_OO = 1 if date >= ownedby_sinclair_date

g ownedby_gray_OO = 0
replace ownedby_gray_OO = 1 if date >= ownedby_gray_date

g ownedby_nexstar_OO = 0
replace ownedby_nexstar_OO = 1 if date >= ownedby_nexstar_date

egen check=rsum(ownedby_sinclair_OO ownedby_gray_OO ownedby_nexstar_OO)
count if check!=0&check!=1
assert `r(N)'==0
drop check

egen ownedby_congl_OO=rmax(ownedby_sinclair_OO ownedby_gray_OO ownedby_nexstar_OO)

bysort fccid: egen ownedby_congl_OO_date = min(date/(ownedby_congl_OO==1))
format ownedby_congl_OO_date %tm

label var ownedby_sinclair_OO 		"Post-Acquisition, O&O Only, Sinclair "
label var ownedby_gray_OO		 	"Post-Acquisition, O&O Only, Gray"
label var ownedby_nexstar_OO 		"Post-Acquisition, O&O Only, Nexstar"
label var ownedby_congl_OO 			"Post-Acquisition, O&O Only"

ren ownedby_* station_ownedby_*

replace selling_group = selling_group_LP if selling_group==""&selling_group_LP!=""

keep 	fccid date callsign stationID LP_station marketname dma dmacode ///
		station_ownedby_* selling_group

drop station_*_date
	
	
// FIXES CALLSIGNS & DROPS STATIONS THAT WE DO NOT WANT IN THE SAMPLE
// SEE EXCEL FILE FOR DOCUMENTATION

replace callsign="WFXS" if callsign=="DWFXS"

drop if fccid==9766 	// WYCN
drop if fccid==21258 	// WCFT/WSES
drop if fccid==41425 	// KMOT

g year=year(dofm(date))
g month=month(dofm(date))

//////////////////////////////////////////////////////
// IDENTIFIES STATIONS THAT EVENTUALLY ARE DIVESTED //
//////////////////////////////////////////////////////

preserve

import excel data/acquisitions/divestitures_03feb2026.xlsx, sheet("Sheet1") firstrow clear case(lower)

split  station, parse("-")

ren station1 callsign

drop if callsign=="TV3 Winchester"

drop if sold<2010
drop if sold==.

duplicates list callsign

// ignore as it not a big4 affiliated
//   +----------------+
//   | Obs   callsign |
//   |----------------|
//   |  19       WLWC | Nexstar
//   |  57       WLWC |	Sinclair
//   +----------------+

drop if callsign=="WLWC"

keep callsign

tempfile divestitures
save `divestitures'

restore

merge m:1 callsign using `divestitures'

//     Result                      Number of obs
//     -----------------------------------------
//     Not matched                        95,051
//         from master                    95,016  (_merge==1)
//         from using                         35  (_merge==2)
//
//     Matched                             5,027  (_merge==3)
//     -----------------------------------------

drop if _m==2
bysort fccid: egen divested = max((_m==3))

drop _m	
	
save data/acquisitions/acquisition_panel_station_top3_FINAL.dta, replace




/////////////////////////
/////////////////////////
// DMA LEVEL TREATMENT //
/////////////////////////
/////////////////////////

// IGNORE LP STATIONS TO CREATE DMA LEVEL TREATMENT

drop if LP_station==1

//////////////////////////////////
// OWNEDBY: ACQUISTION BY GROUP //
//////////////////////////////////

//////////////////////////////////////
// BASELINE TREATMENT		        //
// INCLUDES O&O + LMAs 		        //
//////////////////////////////////////

foreach owner in sinclair nexstar gray {
	bysort dma date: egen ownedby_`owner'_LMA = max(station_ownedby_`owner'_LMA)
	}

cap drop check
cap drop ownedby_congl_nstations_LMA
cap drop ownedby_congl_LMA
egen ownedby_congl_LMA_nstations=rsum(ownedby_sinclair_LMA ownedby_gray_LMA ownedby_nexstar_LMA)
egen ownedby_congl_LMA=rmax(ownedby_sinclair_LMA ownedby_gray_LMA ownedby_nexstar_LMA)
	

//////////////////////////////////////
// ROBUSTNESS # 1   		        //
// INCLUDES O&O + LMAs + SSAs       //
//////////////////////////////////////

foreach owner in sinclair nexstar gray {
	bysort dma date: egen ownedby_`owner'_SSA = max(station_ownedby_`owner'_SSA)
	}

cap drop check
cap drop ownedby_congl_nstations_SSA
cap drop ownedby_congl_SSA
egen ownedby_congl_SSA_nstations=rsum(ownedby_sinclair_SSA ownedby_gray_SSA ownedby_nexstar_SSA)
egen ownedby_congl_SSA=rmax(ownedby_sinclair_SSA ownedby_gray_SSA ownedby_nexstar_SSA)

//////////////////////////////////////
// ROBUSTNESS # 2   		        //
// O&O ONLY					        //
//////////////////////////////////////

foreach owner in sinclair nexstar gray {
	bysort dma date: egen ownedby_`owner'_OO = max(station_ownedby_`owner'_OO)
	}

cap drop check
cap drop ownedby_congl_OO
egen ownedby_congl_OO_nstations=rsum(ownedby_sinclair_OO ownedby_gray_OO ownedby_nexstar_OO)
egen ownedby_congl_OO=rmax(ownedby_sinclair_OO ownedby_gray_OO ownedby_nexstar_OO)
	
// selects one observations by dma and month
cap drop tag
egen tag=tag(dma date)
keep if tag==1
drop tag

//////////////////////////////////////
// ROBUSTNESS # 3   		        //
// FIRST GROUP TO COME              //
// BASELINE VERSION ONLY  			//
//////////////////////////////////////

// entry date at dma level
foreach group in congl sinclair gray nexstar {
	bysort dmacode: egen ownedby_`group'_date = min(date/(ownedby_`group'_LMA==1))
	format ownedby_`group'_date %tm
	}

// first conglomerate acquisition is by a certain group	
foreach group in sinclair gray nexstar {
	cap drop `group'_first
	cap drop ownedby_`group'_first
	g `group'_first = (ownedby_`group'_date == ownedby_congl_date)
	g ownedby_`group'_LMA_first = 0
	replace ownedby_`group'_LMA_first = ownedby_`group'_LMA if `group'_first==1
	drop `group'_first 
	}

cap drop check

egen check=rsum(ownedby_sinclair_LMA_first ownedby_gray_LMA_first ownedby_nexstar_LMA_first)
tab check ownedby_congl_LMA
tab check ownedby_congl_LMA if ownedby_congl_LMA==1&check>1&year(dofm( ownedby_congl_date ))!=2010&month(dofm(ownedby_congl_date))!=1
// either dmas with two stations owned by different conglomerates from the start
// or Sioux City, with two acquisitions by different groups on the same date

drop check

cap drop station_ownedby_*_date  
drop station_ownedby_*

ren marketname dma_kelseybia

keep dmacode dma dma_kelseybia date date ownedby_*
drop *_date

label var ownedby_sinclair_LMA				"Post-Acquisition, Sinclair"
label var ownedby_gray_LMA		 			"Post-Acquisition, Gray"
label var ownedby_nexstar_LMA 				"Post-Acquisition, Nexstar"
label var ownedby_congl_LMA 				"Post-Acquisition"
label var ownedby_congl_LMA_nstations 		"Number of Stations Owned"

label var ownedby_sinclair_LMA_first 		"Post-Acquisition, Sinclair First"
label var ownedby_gray_LMA_first		 	"Post-Acquisition, Gray First"
label var ownedby_nexstar_LMA_first 		"Post-Acquisition, Nexstar First"

label var ownedby_sinclair_SSA				"Post-Acquisition, Includes SSAs, Sinclair"
label var ownedby_gray_SSA		 			"Post-Acquisition, Includes SSAs, Gray"
label var ownedby_nexstar_SSA 				"Post-Acquisition, Includes SSAs, Nexstar"
label var ownedby_congl_SSA 				"Post-Acquisition, Includes SSAs"
label var ownedby_congl_SSA_nstations 		"Number of Stations Owned, Includes SSAs"

label var ownedby_sinclair_OO			"Post-Acquisition, O&O Only, Sinclair"
label var ownedby_gray_OO		 		"Post-Acquisition, O&O Only, Gray"
label var ownedby_nexstar_OO 			"Post-Acquisition, O&O Only, Nexstar"
label var ownedby_congl_OO 				"Post-Acquisition, O&O Only"
label var ownedby_congl_OO_nstations 	"Number of Stations Owned, O&O Only"

g year=year(dofm(date))
g month=month(dofm(date))

save data/acquisitions/acquisition_panel_dma_top3_FINAL.dta, replace















