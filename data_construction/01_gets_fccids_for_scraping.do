// NOTE: requires data/acquisitions/UofWarwickTVJuly2018.xlsx (BIA/Kelsey station database, licensed; NOT included in this archive).
// Its output, data/acquisitions/fccidnumbers_for_scraping.dta, IS included.

///////////////////////////////
// GETS FCCIDs TO SCRAPE     //
///////////////////////////////

////////////////////////////////////////
// GETS STATIONS FROM BIA/KELSEY DATA //
////////////////////////////////////////

// gets all stations
forvalues year=2010(1)2017 {

	import excel data/acquisitions/UofWarwickTVJuly2018.xlsx, sheet("`year'") firstrow case(lower) clear
	keep calls affiliation biastationcode fccidnumber
	ren calls callsign
	ren biastationcode stationID
	g year = `year'
	tempfile BIAKELSEY_`year'
	save `BIAKELSEY_`year''
	
	}

clear	
forvalues year=2010(1)2017 {

	append using `BIAKELSEY_`year''
	
	}

// cleans callsign 
replace callsign=regexs(1) if regexm(callsign,"([A-Z]+)([-])")==1
	
// cleans affiliation	
replace affiliation="FOX" if affiliation=="F&M"

// gets number of years in which station is active
bysort stationID: g N=_N	

// gets number of stations that change callsign
bysort stationID: egen number_callsigns = nvals(callsign)

// gets number of stations that change callsign
bysort stationID: egen number_fccidnumber = nvals(fccidnumber)

// gets affiliation 
g big4 = (affiliation == "ABC" | affiliation == "CBS" | affiliation == "NBC" | affiliation == "FOX")
bysort stationID: egen ever_big4 = max(big4)

// sets as ever_big4 = 1 stations that are ever big 4 according to Nielsen data
replace ever_big4 = 1 if callsign == "WBKP"
replace ever_big4 = 1 if callsign == "WPGA"

/////////////////////////////////////////
// GETS CALLSIGNS FROM TVEYES DATA     //
/////////////////////////////////////////

preserve

import delimited data/harmony/harmony_callsigns.csv, clear varn(1)

egen tag=tag(callsign)
keep if tag==1

tempfile tveyes
save `tveyes'
restore

merge m:1 callsign using `tveyes'

//     Result                      Number of obs
//     -----------------------------------------
//     Not matched                         5,029
//         from master                     4,941  (_merge==1)
//         from using                         88  (_merge==2) 
//
//     Matched                             6,273  (_merge==3)
//     -----------------------------------------

keep if ever_big4==1
tab _m

keep if _m==3

drop _merge

cap drop tag
egen tag=tag(fccidnumber)

keep if tag==1

keep fccidnumber 

/////////////////////////////////////
// APPENDS FACILITYIDs FROM TVEYES //
/////////////////////////////////////

preserve
import excel data/acquisitions/information_LP_stations.xlsx, sheet("LP_stations") firstrow clear
keep fccid
ren fccid fccidnumber
tempfile toappend
save `toappend'
restore

append using `toappend'

save data/acquisitions/fccidnumbers_for_scraping.dta, replace


