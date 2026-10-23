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

unique cong_district  // 456, WHY?


* Check unique districts per year (including non-voting as DC)
preserve
collapse (count) obs=caseID, by(year cong_district)  // Assumes caseID is unique ID; adjust if needed
bysort year: gen n_unique = _N
bysort year: keep if _n == 1
list year n_unique, clean noobs
* (435 voting + 6 non-voting, in our case 1 only DC); 
gen flag_year = (n_unique > 435)
list year n_unique flag_year if flag_year == 1, clean noobs

/*
 list year n_unique, clean noobs
    year   n_unique  
    2010        436  
    2011        436  
    2012        436  
    2013        436  
    2014        436  
    2015        436  
    2016        436  
    2017        436  
    2018        436  
    2019        436  
    2020        436 
*/

restore


// AND STILL, when:
unique cong_district  // 456, WHY?


// BELOW THE EXPLANATION: //


* Simple demonstration of how 436 per year becomes 456 pooled
use "data/CCES/raw/individual/cces_individual_panel_CD.dta", clear

display "=========================================="
display " DEMONSTRATION on WHY: 436 to 456"
display "=========================================="

* Step 1: Show each year has exactly 436
display _newline "STEP 1: Each year has exactly 436 districts"
display "-------------------------------------------"
forvalues y = 2010/2020 {
    qui unique cong_district if year == `y'
    display "Year `y': " r(unique) " unique districts"
}

* Step 2: Show pre-2012 pooled has 444
display _newline "STEP 2: Pool years 2010-2012 has 444 codes"
display "-------------------------------------------"
preserve
keep if year <= 2012
unique cong_district
local pre_codes = r(unique)
display "Pre-2012 pooled (2010-2012): " `pre_codes' " unique codes"
display "Extra codes from within-period changes: " `pre_codes' - 436 " = " `pre_codes' " - 436"
restore

* Step 3: Show post-2012 pooled has 436
display _newline "STEP 3: Pool years 2013-2020 has 436 codes"
display "-------------------------------------------"
preserve
keep if year >= 2013
unique cong_district
local post_codes = r(unique)
display "Post-2012 pooled (2013-2020): " `post_codes' " unique codes"
display "Extra codes from within-period changes: " `post_codes' - 436 " = " `post_codes' " - 436"
display "(No changes - perfectly stable!)"
restore

* Step 4: Show all years pooled has 456
display _newline "STEP 4: Pool ALL years 2010-2020 has 456 codes"
display "-------------------------------------------"
unique cong_district
local all_codes = r(unique)
display "All years pooled (2010-2020): " `all_codes' " unique codes"

* Step 5: Calculate shared codes
display _newline "STEP 5: Calculate the breakdown"
display "-------------------------------------------"
local shared = `pre_codes' + `post_codes' - `all_codes'
local pre_only = `pre_codes' - `shared'
local post_only = `post_codes' - `shared'

display "Formula: Pooled = Pre + Post - Shared"
display "`all_codes' = `pre_codes' + `post_codes' - Shared"
display "Therefore: Shared = `pre_codes' + `post_codes' - `all_codes' = " `shared'
display ""
display "Breakdown of the `all_codes' unique codes:"
display "  • " `shared' " codes used in BOTH periods (shared)"
display "  • " `pre_only' " codes used ONLY pre-2012 (legacy)"
display "  • " `post_only' " codes used ONLY post-2012 (new)"
display "  • Total: " `shared' " + " `pre_only' " + " `post_only' " = " `shared' + `pre_only' + `post_only'

* Step 6: Show some actual examples
display _newline "STEP 6: Examples of code changes"
display "-------------------------------------------"

* Find some pre-only codes
preserve
gen pre = (year <= 2012)
gen post = (year >= 2013)

* For each district, check if it appears in each period
collapse (max) in_pre=pre (max) in_post=post, by(cong_district)

gen pre_only = (in_pre == 1 & in_post == 0)
gen post_only = (in_pre == 0 & in_post == 1)
gen shared = (in_pre == 1 & in_post == 1)

* Count each type
qui count if pre_only == 1
local n_pre = r(N)
qui count if post_only == 1
local n_post = r(N)
qui count if shared == 1
local n_shared = r(N)

display "Found " `n_pre' " pre-only, " `n_post' " post-only, " `n_shared' " shared codes"
display ""

display "Sample PRE-ONLY codes (disappeared after 2012):"
gsort -pre_only cong_district
list cong_district if pre_only == 1 in 1/5, clean noobs

display _newline "Sample POST-ONLY codes (appeared after 2012):"
gsort -post_only cong_district
list cong_district if post_only == 1 in 1/5, clean noobs

display _newline "Sample SHARED codes (used in both periods):"
gsort -shared cong_district
list cong_district if shared == 1 in 1/5, clean noobs

restore
display _newline "=========================================="
display "SUMMARY: Why 436 becomes 456"
display "=========================================="
display "• Each year: 436 active districts (constant)"
display "• Pre-2012: 436 + 8 transitional = 444 codes"
display "• Post-2012: 436 + 0 changes = 436 codes"  
display "• Pooled: 444 + 436 - 424 shared = 456 codes"
display "• The extra 20 codes (456-436) come from redistricting"
display "=========================================="




// HERE IF YOU WANNA BREAK DOWN EXACTLY THE MATH //

* Comprehensive verification of ALL codes
use "data/CCES/raw/individual/cces_individual_panel_CD.dta", clear

* Create indicator for pre-redistricting period (2010-2012)
* pre=1 for observations in years 2010-2012, pre=0 otherwise
gen pre = (year <= 2012)

* Create indicator for post-redistricting period (2013-2020)
* post=1 for observations in years 2013-2020, post=0 otherwise
gen post = (year >= 2013)

* Collapse to district level: for each unique district code, determine
* whether it appears in the pre period (in_pre) and/or post period (in_post)
* (max) takes the maximum value: if district appears in ANY pre year, in_pre=1
* n_obs counts total observations per district (for reference)
collapse (max) in_pre=pre (max) in_post=post (count) n_obs=pre, by(cong_district)

* Identify districts that existed ONLY before redistricting (2010-2012)
* These are "legacy" codes that disappeared after 2012
gen pre_only = (in_pre == 1 & in_post == 0)

* Identify districts that existed ONLY after redistricting (2013-2020)
* These are "new" codes that appeared after 2012
gen post_only = (in_pre == 0 & in_post == 1)

* Identify districts whose codes appear in BOTH periods
* Note: same code doesn't mean same boundaries - likely redrawn
gen shared = (in_pre == 1 & in_post == 1)

* Verify the logic is correct
count if shared == 1 // Shared CD
count if pre_only == 1 // ONLY PRE CD
count if post_only == 1 // ONLY POST CD






