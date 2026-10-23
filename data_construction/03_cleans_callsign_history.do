////////////////////////////////////
// CREATES CALLSIGN TO FCC XWALK //
///////////////////////////////////

////////////////////////////////////////
// GETS STATIONS FROM BIA/KELSEY DATA //
////////////////////////////////////////

import delimited data/acquisitions/callsigns_history.csv, clear 

// cleans callsign
replace callsign=regexs(1) if regexm(callsign,"([A-Z0-9]+)([-])")

// fixes missing start date + mistakes
drop if callsign=="WLHT"&fccid==48668 
drop if callsign=="800717KF"&fccid==48668 
drop if callsign=="801022KE"&fccid==35655
drop if callsign=="791107LD"&fccid==58560
drop if callsign=="DWBBJ"&fccid==65204
drop if callsign=="KCPX"&fccid==68889
drop if callsign=="WHP"&fccid==73120

tab callsign if regexm(callsign,"([0-9])")==1

//    callsign |      Freq.     Percent        Cum.
// ------------+-----------------------------------
//       K11TW |          1       11.11       11.11
//       K17KH |          1       11.11       22.22
//       K24KH |          1       11.11       33.33
//       K26LV |          1       11.11       44.44
//       W16DB |          1       11.11       55.56
//       W16DE |          1       11.11       66.67
//       W18DR |          1       11.11       77.78
//       W35CY |          1       11.11       88.89
//       W45EI |          1       11.11      100.00
// ------------+-----------------------------------
//       Total |          9      100.00

// if repeated callsign, keep the one with earliest date
cap drop to_drop
bysort fccid (v1): g to_drop = (callsign==callsign[_n+1])
drop if to_drop == 1

// replaces last entry with earlier start date if empty
cap drop to_replace
bysort fccid (v1): g to_replace = ((_N>1)&(_n==_N)&(from_date==""))
replace from_date = "11/20/1970" if to_replace==1 

// creates time variables
ren from_date from_date_str
g from_date = date(from_date_str, "MDY")
format from_date %td

g from_ym = ym(year(from_date), month(from_date))
format from_ym %tm

bysort fccid (v1): g to_ym = from_ym[_n-1]-1
format to_ym %tm

drop if year(dofm(to_ym))<2010

keep fccid callsign from_ym to_ym

// reassigns from_ym and to_ym as relevant for the sample
replace from_ym=ym(2010,1) if from_ym<ym(2010,1)|from_ym==.
replace to_ym=ym(2022,7) if to_ym==.

save data/acquisitions/callsign_history_cleaned.dta, replace