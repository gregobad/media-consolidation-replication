// NOTE: requires data/adintel/adintel_clean_updated.dta (output of 06_cleans_adintel_data.do, derived from
// proprietary Nielsen Ad Intel data). NOT included in this archive; see README.

/////////////////////////////////////////
// GETS STATIONS CHARACTERISTICS, 2010 //
/////////////////////////////////////////

use data/adintel/adintel_clean_updated.dta, clear

keep if year==2010
drop if month==1

// BALANCED SAMPLE
cap drop N
egen N = total(!missing(total_duration_news) & !missing(total_duration_nonnews)), by(stationID)
tab N
g balanced_sample_2010=(N==11)
drop N

collapse (mean) rating_total_nonnews rating_total_news duration_perHH_nonnews duration_perHH_news spend_perHH_nonnews spend_perHH_news balanced_sample_2010 (firstnm) callsign, by(stationID) 

ren balanced_sample balanced_sample_ads

// sample fixes
keep if balanced_sample_ads==1

save data/station_baseline_characteristics_2010.dta, replace

g log_duration_news_2010 = log(duration_perHH_news)
g log_spend_news_2010 = log(spend_perHH_news)
g rating_news_2010 = rating_total_news

keep stationID *_2010  

save data/station_baseline_characteristics_2010_small.dta, replace

