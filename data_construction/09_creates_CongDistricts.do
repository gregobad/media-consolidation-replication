// NOTE: requires the raw CCES common-content files data/CCES/raw/cces2010.dta ... cces2020.dta,
// downloadable from the CCES Dataverse (https://cces.gov.harvard.edu). NOT included because of size; see README.

* SET DIRECTORY


***********************
* 1st STEP - CLEANING *
***********************
* 1.1 SET GLOBALS TO KEEP VARIABLE BY CCES YEAR (unchanged)
global data_2010 V100 V101 V401 V402 V302 V277 V276
global data_2011 V100 V101 V401 V402 V302 V303 V276
global data_2012 V101 V103 starttime endtime inputstate countyfips cdid cdid113
global data_2013 caseid weight starttime endtime inputstate countyfips cdid113
global data_2014 V101 weight starttime endtime inputstate countyfips cdid
global data_2015 V101 weight starttime endtime inputstate countyfips cdid
global data_2016 V101 commonweight starttime_pre endtime_pre inputstate countyfips cdid113 cdid115
global data_2017 V101 weights_common starttime endtime inputstate lookupzip cdid115
global data_2018 caseid commonweight starttime endtime inputstate countyfips cdid115 cdid116
global data_2019 caseid commonweight starttime endtime inputstate countyfips cdid116
global data_2020 caseid commonweight starttime endtime inputstate countyfips cdid116
* 1.2 LOOP OVER YEARS
forval year = 2010(1)2020 {
    di `year'
    use "data/CCES/raw/cces`year'.dta", clear
    keep ${data_`year'}
    * Explicit renames per year (replaces buggy loop)
    if "`year'" == "2010" {
        rename V100 caseID
        rename V101 common_weights  // Adjust mappings based on codebook (e.g., V401→interview_start?)
        rename V401 interview_start
        rename V402 interview_end
        rename V302 statefp
        rename V277 countyfp
        rename V276 cong_district
    }
    else if "`year'" == "2011" {
        rename V100 caseID
        rename V101 common_weights
        rename V401 interview_start
        rename V402 interview_end
        rename V302 statefp
        rename V303 countyfp  // Note: V303 for 2011 county?
        rename V276 cong_district
    }
    else if "`year'" == "2012" {
        rename V101 caseID
        rename V103 common_weights
        rename starttime interview_start
        rename endtime interview_end
        rename inputstate statefp
        rename countyfips countyfp
        rename cdid cong_district
        rename cdid113 cong_district_add
    }
    else if "`year'" == "2013" {
        rename caseid caseID
        rename weight common_weights
        rename starttime interview_start
        rename endtime interview_end
        rename inputstate statefp
        rename countyfips countyfp
        rename cdid113 cong_district  // Only one: upcoming
    }
    else if "`year'" == "2014" {
        rename V101 caseID
        rename weight common_weights
        rename starttime interview_start
        rename endtime interview_end
        rename inputstate statefp
        rename countyfips countyfp
        rename cdid cong_district
    }
    else if "`year'" == "2015" {
        rename V101 caseID
        rename weight common_weights
        rename starttime interview_start
        rename endtime interview_end
        rename inputstate statefp
        rename countyfips countyfp
        rename cdid cong_district
    }
    else if "`year'" == "2016" {
        rename V101 caseID
        rename commonweight common_weights
        rename starttime_pre interview_start
        rename endtime_pre interview_end
        rename inputstate statefp
        rename countyfips countyfp
        rename cdid113 cong_district
        rename cdid115 cong_district_add
    }
    else if "`year'" == "2017" {
        rename V101 caseID
        rename weights_common common_weights
        rename starttime interview_start
        rename endtime interview_end
        rename inputstate statefp
        rename lookupzip zipcode  // No county
        rename cdid115 cong_district
    }
    else if "`year'" == "2018" {
        rename caseid caseID
        rename commonweight common_weights
        rename starttime interview_start
        rename endtime interview_end
        rename inputstate statefp
        rename countyfips countyfp
        rename cdid115 cong_district
        rename cdid116 cong_district_add
    }
    else if "`year'" == "2019" {
        rename caseid caseID
        rename commonweight common_weights
        rename starttime interview_start
        rename endtime interview_end
        rename inputstate statefp
        rename countyfips countyfp
        rename cdid116 cong_district
    }
    else if "`year'" == "2020" {
        rename caseid caseID
        rename commonweight common_weights
        rename starttime interview_start
        rename endtime interview_end
        rename inputstate statefp
        rename countyfips countyfp
        rename cdid116 cong_district
    }
    g year = `year'
    label variable year "Year"
    * Padding (unchanged)
    capture _strip_labels statefp
    tostring statefp, replace
    replace statefp = "0" + statefp if length(statefp) == 1
    replace cong_district = "0" + cong_district if length(cong_district) == 1
    if inlist(`year', 2012, 2016, 2018) {
        replace cong_district_add = "0" + cong_district_add if length(cong_district_add) == 1
    }
    if `year' != 2017 {
        tostring countyfp, replace
        replace countyfp = "00" + countyfp if length(countyfp) == 1
        replace countyfp = "0" + countyfp if length(countyfp) == 2
        if length(countyfp) == 3 {
            gen fips = statefp + countyfp
            drop countyfp
            rename fips countyfp
        }
    }
    * Artifact fixes: two congressional districts that were not correct
    replace cong_district = "1101" if substr(cong_district,1,4)=="1100"
    if `year' == 2012 {
        replace cong_district_add = "01" if cong_district_add == "20" & countyfp == "23031"
    }
    save "data/CCES/raw/individual/cces_individual_`year'_CD.dta", replace
}

* NOTES*

	*1. * District of columbia: DC doesn't have a numbered House district. It's a single at-large district, wikipedia: https://en.wikipedia.org/wiki/District_of_Columbia%27s_at-large_congressional_district
	*replace cong_district = "1101" if substr(cong_district,1,4)=="1100" (ma questo non cambia nulla in fin dei conti, è solo per amor del vero che l'ho cambiato)
	*ONLY CHANGE
	*2. York County in Maine has always been in congressional district 01, there is an error in the 2012 cdid113 that codes it at 20
			*replace cong_district_add = "01" if cong_district_add == "20" & countyfp == "23031"

***************************
* 2nd STEP - MANIPULATION *
***************************
* Append (unchanged)
use "data/CCES/raw/individual/cces_individual_2010_CD", clear
forval y = 2011/2020 {
    append using "data/CCES/raw/individual/cces_individual_`y'_CD"
}
* same_CD (with completion)
g same_CD = 1  // Default: same if no add
replace same_CD = 0 if (cong_district != cong_district_add) & inlist(year, 2012, 2016, 2018)
label variable cong_district_add "Second Congressional District"
label variable same_CD "Same CD dummy (0=diff in transition years)"
fre same_CD  

/*
same_CD -- Same CD dummy (0=diff in transition years)
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |      28866       6.58       6.58       6.58
        1     |     409869      93.42      93.42     100.00
        Total |     438735     100.00     100.00           
-----------------------------------------------------------
*/


* Concat both
replace cong_district = statefp + cong_district
replace cong_district_add = statefp + cong_district_add if !missing(cong_district_add)
save "data/CCES/cd_dma/cces_individual_panel_CDcorrect.dta", replace





