// NOTE: requires the raw CCES common-content files data/CCES/raw/cces2010.dta ... cces2020.dta,
// downloadable from the CCES Dataverse (https://cces.gov.harvard.edu). NOT included because of size; see README.

//////////////////////////////////////
// IMPORTS AND CLEANS THE CCES DATA //
//////////////////////////////////////

clear all

***********************
* 1st STEP - CLEANING *
***********************

* 1.1 SET GLOBALS TO KEEP VARIABLE BY CCES YEAR 

* 2010 *
global data_2010 V100 V101 V401 V402 V302 V277 V276 V207 V208 V211 V213 V209 V214 V246 V250 CC317 CC334A CC334D CC334E CC309a CC309b CC309c CC309d CC301_1 CC301_2 CC301_3 CC301_4 CC301_5 CC301b CC301c CC322_4 CC308d CC310a CC310b CC310c CC310d CC354 CC390 CC412 CC315a
* Intention to vote: CC354 "Do you intend to vote in the 2010 general election on November 2?" "1 Yes, definitely", "2 Probably", "3 No", "4 Undecided"

* 2011 *
global data_2011 V100 V101 V401 V402 V302 V303 V276 V207 V208 V211 V213 V209 V214 V246 CC306 CC342A CC342D CC342E CC321a CC321b CC321c CC321d CC331 CC309_1 CC309_2 CC309_3 CC309_4 CC309_5 CC309b CC309c CC351_2 CC320f CC322a CC322b CC322c CC322d CC323a
* Intention to vote: it does not appear to be there 

* 2012 *
global data_2012 V101 V103 starttime endtime inputstate countyfips cdid cdid113 birthyr gender race educ employ marstat faminc ownhome CC317 CC334A CC334E CC334F CC309a CC309b CC309c CC309d CC308d CC310a CC310b CC310c CC310d CC354 CC390 CC390b CC315a
* Intention to vote: CC354 "Does R intend to Vote in 2012" "1 Yes, definitely", "2 Probably", "3 I already voted (early or absentee)", "4 I plan to vote before November", "5 No", "6 Undecided" 

* 2013 *
global data_2013 caseid weight starttime endtime inputstate countyfips cdid113 birthyr gender race educ employ marstat faminc ownhome CC13_315 CC334A CC334E CC334F CC13_310a CC13_310b CC13_310c CC13_310d CC13_301_1 CC13_301_2 CC13_301_3 CC13_301_4 CC13_301_5 CC301_b2 CC301c CC326_2 CC312d CC13_311a CC13_311b CC13_311c CC13_311d CC13_313a
* Intention to vote: it does not appear to be there 

* 2014 *
global data_2014 V101 weight starttime endtime inputstate countyfips cdid birthyr gender race educ employ marstat faminc ownhome CC14_317 CC334A CC334K CC334L CC14_309a CC14_309b CC14_309c CC14_309d CC14_301_1 CC14_301_2 CC14_301_3 CC14_301_4 CC14_301_5 CC301_b2 CC301c CC14_322_2 CC14_308d CC14_310a CC14_310b CC14_310c CC14_310d CC354 CC360 CC360x CC14_315a
* Intention to vote: CC354 - A: "1 Yes, definitely", "2 Probably", "3 I already voted (early or absentee)", "4 I plan to vote before November", "5 No", "6 Undecided" 

* 2015 *
global data_2015 V101 weight starttime endtime inputstate countyfips cdid birthyr gender race educ employ marstat faminc ownhome CC15_315 CC15_340a CC15_340d CC15_340e CC15_310a CC15_310b CC15_310c CC15_310d CC15_321_2 CC15_312f CC15_311a CC15_311b CC15_311c CC15_311d CC15_313a
* Intention to vote: nothing reported

* 2016 *
global data_2016 V101 commonweight starttime_pre endtime_pre inputstate countyfips cdid113 cdid115 birthyr gender race educ employ marstat faminc ownhome CC16_326 CC16_340a CC16_340g CC16_340h CC16_321a CC16_321b CC16_321c CC16_321d CC16_300_1 CC16_300_2 CC16_300_3 CC16_300_4 CC16_300_5 CC16_300_6 CC16_300b CC16_300c CC16_331_2 CC16_320d CC16_322a CC16_322b CC16_322c CC16_322d CC16_367 CC16_364 CC16_320f
* Intention to vote: CC16_364 - A: "1 Yes, definitely", "2 Probably", "3 I already voted (early or absentee)", "4 No", "5 Undecided" 


* 2017 *
global data_2017 V101 weights_common starttime endtime inputstate lookupzip cdid115 birthyr gender race educ employ marstat faminc_new ownhome CC17_327 CC17_350a CC17_350d CC17_350e CC17_320d CC17_320e CC17_320b CC17_320c CC17_331_2 CC17_322e CC17_321a CC17_321b CC17_321c CC17_321d CC17_323a
* Intention to vote: nothing reported

* 2018 *
global data_2018 caseid commonweight starttime endtime inputstate countyfips cdid115 cdid116 birthyr gender race educ employ marstat faminc_new ownhome CC18_317 CC18_334A CC18_334D CC18_334E CC18_309a CC18_309b CC18_309c CC18_309d CC18_300_1 CC18_300_2 CC18_300_3 CC18_300_4 CC18_300_5 CC18_300_6 CC18_300b CC18_300c CC18_322a CC18_308d CC18_310a CC18_310b CC18_310c CC18_310d CC18_350 CC18_353 CC18_353x CC18_311a
* Intention to vote: CC18_350 - A: "1 Yes, definitely", "2 Probably", "3 I already voted (early or absentee)", "4 I plan to vote before November", "5 No", "6 Undecided" 

* 2019 *
global data_2019 caseid commonweight starttime endtime inputstate countyfips cdid116 birthyr gender race educ employ marstat faminc_new ownhome presvote16post CC19_334a CC19_334d CC19_334e CC19_309a CC19_309b CC19_309c CC19_309d CC19_300_1 CC19_300_2 CC19_300_3 CC19_300_4 CC19_300_5 CC19_300_6 CC19_300b CC19_300c CC19_322e CC19_308e CC19_310a CC19_310b CC19_310c CC19_310d CC19_311a
* Intention to vote: nothing reported

* 2020 *
global data_2020 caseid commonweight starttime endtime inputstate countyfips cdid116 birthyr gender race educ employ marstat faminc_new ownhome presvote16post CC20_340a CC20_340e CC20_340f CC20_310a CC20_310b CC20_310c CC20_310d CC20_300_1 CC20_300_2 CC20_300_3 CC20_300_4 CC20_300_5 CC20_300a CC20_300c CC20_331e CC20_320d CC20_311a CC20_311b CC20_311c CC20_311d CC20_367 CC20_412 CC20_320f
* Intention to vote: nothing reported


* 1.2 LOOP OVER YEARS *
forval year = 2010(1)2020{
	
	* PRINT YEAR
	di `year'
	* READ CCES DATA  
	use "data/CCES/raw/cces`year'.dta", clear
	
	* KEEP VARS USING GLOBALS
	keep ${data_`year'}
	
	if "`year'" == "2010"{
		local names "caseID common_weights interview_start interview_end statefp countyfp cong_district birthyr gender race education employment marital_status fam_income own_home vote_last_election ideo_self ideo_dem ideo_rep know_house know_senate know_state_senate know_lower_chamber media_use_blog media_use_TV media_use_NP media_use_radio media_use_none watch_news_type read_np_type imm_increase_border governor_approval recog_governor_party recog_senator1_party recog_senator2_party recog_houserep_party voting_intention house_preference house_voting housemember_approval"
	}
	else if "`year'" == "2011"{
		local names "caseID common_weights interview_start interview_end statefp countyfp cong_district birthyr gender race education employment marital_status fam_income own_home ideo_self ideo_dem ideo_rep know_house know_senate know_state_senate know_lower_chamber vote_last_election media_use_blog media_use_TV media_use_NP media_use_radio media_use_none watch_news_type read_np_type imm_increase_border governor_approval recog_governor_party recog_senator1_party recog_senator2_party recog_houserep_party housemember_approval" 
	}
	* IN 2012 WE DON'T HAVE OPINION ON IMMIGRATION POLICY CONTROL 
	else if "`year'" == "2012"{
		local names "caseID common_weights interview_start interview_end statefp countyfp cong_district cong_district_add birthyr gender race education employment marital_status fam_income own_home vote_last_election ideo_self ideo_dem ideo_rep know_house know_senate know_state_senate know_lower_chamber governor_approval recog_governor_party recog_senator1_party recog_senator2_party recog_houserep_party voting_intention house_voting house_preference housemember_approval" 
	}
	* IN 2013 WE DON'T HAVE OPINION ON IMMIGRATION POLICY CONTROL 
	else if "`year'" == "2013"{
		local names "caseID common_weights interview_start interview_end statefp countyfp cong_district birthyr gender race education employment marital_status fam_income own_home vote_last_election ideo_self ideo_dem ideo_rep know_house know_senate  know_state_senate know_lower_chamber media_use_blog media_use_TV media_use_NP media_use_radio media_use_none watch_news_type read_np_type imm_increase_border governor_approval recog_governor_party recog_senator1_party recog_senator2_party recog_houserep_party housemember_approval" 
	}
	* 2014
	else if "`year'" == "2014"{
		local names "caseID common_weights interview_start interview_end statefp countyfp cong_district birthyr gender race education employment marital_status fam_income own_home vote_last_election ideo_self ideo_dem ideo_rep know_house know_senate  know_state_senate know_lower_chamber media_use_blog media_use_TV media_use_NP media_use_radio media_use_none watch_news_type read_np_type imm_increase_border governor_approval recog_governor_party recog_senator1_party recog_senator2_party recog_houserep_party voting_intention house_preference house_voting housemember_approval" 
	}
	* WE DON'T HAVE MEDIA USAGE
	else if "`year'" == "2015"{
		local names "caseID common_weights interview_start interview_end statefp countyfp cong_district birthyr gender race education employment marital_status fam_income own_home vote_last_election ideo_self ideo_dem ideo_rep know_house know_senate know_state_senate know_lower_chamber imm_increase_border governor_approval recog_governor_party recog_senator1_party recog_senator2_party recog_houserep_party housemember_approval" 
	}
	* WE HAVE SOCIAL MEDIA USAGE
	else if "`year'" == "2016"{
		local names "caseID common_weights interview_start interview_end statefp countyfp cong_district cong_district_add birthyr gender race education employment marital_status fam_income own_home vote_last_election ideo_self ideo_dem ideo_rep know_house know_senate know_state_senate know_lower_chamber media_use_blog media_use_TV media_use_NP media_use_radio media_use_SM media_use_none watch_news_type read_np_type imm_increase_border governor_approval recog_governor_party recog_senator1_party recog_senator2_party recog_houserep_party house_preference voting_intention housemember_approval"
	}
	* IN 2017 WE DON'T HAVE COUNTYFIPS BUT WE DO HAVE ZIPCODES AND WE DON'T HAVE MEDIA USAGE
	else if "`year'" == "2017"{
		local names "caseID common_weights interview_start interview_end statefp zipcode cong_district birthyr gender race education employment marital_status fam_income own_home vote_last_election ideo_self ideo_dem ideo_rep know_state_senate know_lower_chamber know_house know_senate imm_increase_border governor_approval recog_governor_party recog_senator1_party recog_senator2_party recog_houserep_party housemember_approval"			
	}
	else if "`year'" == "2018"{
		local names "caseID common_weights interview_start interview_end statefp countyfp cong_district cong_district_add birthyr gender race education employment marital_status fam_income own_home vote_last_election ideo_self ideo_dem ideo_rep know_house know_senate know_state_senate know_lower_chamber media_use_blog media_use_TV media_use_NP media_use_radio media_use_SM media_use_none watch_news_type read_np_type imm_increase_border governor_approval recog_governor_party recog_senator1_party recog_senator2_party recog_houserep_party voting_intention house_preference house_voting housemember_approval"
	}
	else if "`year'" == "2019"{
		local names "caseID common_weights interview_start interview_end statefp countyfp cong_district birthyr gender race education employment marital_status fam_income own_home vote_last_election ideo_self ideo_dem ideo_rep know_house know_senate know_state_senate know_lower_chamber media_use_blog media_use_TV media_use_NP media_use_radio media_use_SM media_use_none watch_news_type read_np_type imm_increase_border governor_approval recog_governor_party recog_senator1_party recog_senator2_party recog_houserep_party housemember_approval"
	}
	else if "`year'" == "2020"{
		local names "caseID common_weights interview_start interview_end statefp countyfp cong_district birthyr gender race education employment marital_status fam_income own_home vote_last_election ideo_self ideo_dem ideo_rep know_house know_senate know_state_senate know_lower_chamber media_use_SM media_use_TV media_use_NP media_use_radio media_use_none watch_news_type read_np_type imm_increase_border governor_approval recog_governor_party recog_senator1_party recog_senator2_party recog_houserep_party house_preference house_voting housemember_approval"
	}

	
	* LOCAL NUMBER OF VARS
	local nvars : word count ${data_`year'}
	
	* RENAME VARS BY YEAR
	forval j = 1/`nvars'{
		
		* STORE OLD NAME
		local old : word `j' of ${data_`year'}
		* STORE NEW NAME
		local new : word `j' of `names'
		
		*display "`old' `new'"
		
		* RENAME
		rename `old' `new'

	}
	
	* CREATE YEAR VARIABLE
	g year = `year'
	label variable year "Year"

	* CREATE AGE VARIABLE
	g age = year - birthyr
	label variable age "Age"
	
	* RESOLVE POSSIBLE ISSUE IN FIPS
	* STATE
	capture _strip_labels statefp
	tostring statefp, replace
	replace statefp = "0" + statefp if length(statefp) == 1
	
	if `year' != 2017{
		
		* COUNTY
		tostring countyfp, replace
		replace countyfp = "00" + countyfp if length(countyfp) == 1
		replace countyfp = "0" + countyfp if length(countyfp) == 2
		
		if length(countyfp) == 3 {		
			* CORRECT FIPS
			gen fips = statefp + countyfp
			drop countyfp
			rename fips countyfp
		}
				
	}
	
	* MAKE STRING FOR FUTURE MANIPULATATION
	decode fam_income, g(s_fam_income)
	
	* SAVE DATA
	save "data/CCES/working/cces_individual_`year'_additional.dta", replace

}


***************************
* 2nd STEP - MANIPULATION *
***************************


* 2.1 APPEND *

* Append all together
	use "data/CCES/working/cces_individual_2010_additional", clear 
	append using "data/CCES/working/cces_individual_2011_additional"
	append using "data/CCES/working/cces_individual_2012_additional"
	append using "data/CCES/working/cces_individual_2013_additional"
	append using "data/CCES/working/cces_individual_2014_additional"
	append using "data/CCES/working/cces_individual_2015_additional"
	append using "data/CCES/working/cces_individual_2016_additional"
	append using "data/CCES/working/cces_individual_2017_additional"
	append using "data/CCES/working/cces_individual_2018_additional"
	append using "data/CCES/working/cces_individual_2019_additional"
	append using "data/CCES/working/cces_individual_2020_additional"


* 2.2 LABEL THE FINAL APPENDING *
* DEMO AND SOCIO CHARACTERISTICS
	label variable birthyr "In what year were you born?"
	label variable gender "Gender"
	label variable race "Race"
	label variable education "Education"
	label variable employment "Employment Status"
	label variable marital_status "Marital Status"
	label variable fam_income "Family Income"
	label variable own_home "Home ownership"
	label variable countyfp "County FIPS code"
	label variable statefp "State FIPS code"
	label variable interview_start "Interview Start Time"
	label variable interview_end "Interview End Time"
* POLITICAL KNOWLEDGE, IDEOLOGY AND VOTING
	label variable know_house "Party of Government Knowledge - Reps"
	label variable know_senate "Party of Government Knowledge - Senate"
	label variable know_state_senate "Party of Government Knowledge - State Senate"
	label variable know_lower_chamber "Party of Government Knowledge - Lower Chamber"
	label variable vote_last_election "Vote President"
	label variable ideo_self "Ideology - Yourself"
	label variable ideo_dem "Ideology - Dem party"
	label variable ideo_rep "Ideology - Rep party"
* MEDIA 
	label variable watch_news_type "Did you watch local news, national news, or both?"
	label variable read_np_type "Did you read a print newspaper, an online newspaper, or both?"
	label variable media_use_blog "Media Use - Blog"
	label variable media_use_TV "Media Use - TV"
	label variable media_use_NP "Media Use - Newspaper"
	label variable media_use_radio "Media Use - Radio"
	label variable media_use_none "Media Use - None"
* ATTITUDES
	label variable imm_increase_border "Increase border security"
* ADDITIONAL LOCAL KNOWLEDGE 
	label variable governor_approval "Institution Approval - Governor"
	label variable recog_governor_party "Party Recall + Name Recognition - Governor"
	label variable recog_senator1_party "Party Recall + Name Recognition - Senator 1"
	label variable recog_senator2_party "Party Recall + Name Recognition - Senator 2"
	label variable recog_houserep_party "Party Recall + Name Recognition - Rep"
* VOTING INTENTION -- REMEMBER, VARIABLE LABELS ARE NOT RELIABLE. CHECK LABELS IN THE GLOBAL VARS
	label variable voting_intention "Presidential voting intentions in the current year"
	label variable house_preference "U.S. House of Representatives preference" 



												      *************************
												      ** DATES AND GEOGRAPHY **
												      *************************
* EXTRACT DATES *
* Interview start
	gen date = dofc(interview_start) 
	format date %td 
	drop interview_start
	rename date interview_start
* Interview end
	gen date = dofc(interview_end)
	format date %td 
	drop interview_end
	rename date interview_end


	
// Define labels for future DUMMY LABELLING
	label define yesno 1 "Yes" 0 "No", modify

	
	
	
									             				 **************
												                 ** CONTROLS **
													             **************

* --								
								
* EMPLOYMENT, replace 98 values (skipped) and 8 (not sure) *
	replace employment = . if employment == 98
* EMPLOYED (full-time, part-time, student)
	g employed = 0
	replace employed = 1 if employment == 1 | employment == 2 | employment == 8 & employment != .
	replace employed = . if employment == . 
	label values employed yesno
	label variable employed "dummy employment status - employed"
* UNEMPLOYED (temporary laid off, unemployed)
	g unemployed = 0
	replace unemployed = 1 if employment == 3 | employment == 4 & employment != .
	replace unemployed = . if employment == . 
	label values unemployed yesno
	label variable unemployed "dummy employment status - unemployed"
* RETIRED (retired)
	g retired = 0
	replace retired = 1 if employment == 5 & employment != .
	replace retired = . if employment == . 
	label values retired yesno
	label variable retired "dummy employment status - retired"
* OTHER (Permanently disabled, Homemaker, Other)
	g employ_other = 0
	replace employ_other = 1 if employment == 6 | employment == 7 | employment == 9 & employment != .
	replace employ_other = . if employment == . 
	label values employ_other yesno
	label variable employ_other "dummy employment other"

	
* --	
	
* MARITAL STATUS, 8 (skipped) *
	replace marital_status = . if marital_status == 8
* MARRIED DUMMY (1 married and 0 Separated, Divorced, Widowed, Single, Domestic partnership)
	g married = 0 
	replace married = 1 if marital_status == 1
	replace married = . if marital_status == . 
	label values married yesno
	label variable married "dummy marital status - MARRIED"
	
* --	

* OWN HOME *
	replace own_home = . if own_home == 8
	g ownerhome = (own_home==1) if own_home!=.
	label values ownerhome yesno
	label variable ownerhome "dummy own home - you own the home"

* --	

* GENDER *
	replace gender = 0 if gender == 2
	label values gender yesno
	rename gender gender_male

* --	
	
* IMMIGRATION *
	replace imm_increase_border = 0 if imm_increase_border == 2
	label values imm_increase_border yesno

* --

* RACE *
	tab race, g(race_)
	rename race_1 race_white
	rename race_2 race_black
	rename race_3 race_hispanic
	rename race_4 race_asian
* Create other races different from white, black, hisp, asian
	g race_others = (race>4) if race!=.
* label 
	label variable race_others "dummy other races different from the listed above"
* drop useless
	drop race_5 race_6 race_7 race_8	
* Relabel values 	
	label values race_white yesno
	label values race_black yesno
	label values race_hispanic yesno
	label values race_asian yesno
	label values race_others yesno
	
* --


* INCOME *	
		
* Family income
	replace fam_income = . if s_fam_income == "Prefer not to say" 
* But stil there are problems, here an example: 
/*
 tab s_fam_income if fam_income == 10

      Family income |      Freq.     Percent        Cum.
--------------------+-----------------------------------
$100,000 - $119,999 |     17,384       80.36       80.36
  $70,000 - $79,999 |      4,248       19.64      100.00
--------------------+-----------------------------------
              Total |     21,632      100.00
*/

		  	
* Adjust Family Income - from the lowest to the highest category (in this case category 12 - $150000 or more)
	g correct_fam_income = 0		
	replace correct_fam_income = . if fam_income == . 									  
	replace correct_fam_income = 1 if s_fam_income == "less than $10,000" | s_fam_income == "Less than $10,000" & fam_income != .
	replace correct_fam_income = 2 if s_fam_income == "$10,000 - $14,999" | s_fam_income == "$10,000 - $19,999" | s_fam_income == "$15,000 - $19,999" & fam_income != .
	replace correct_fam_income = 3 if s_fam_income == "$20,000 - $24,999" | s_fam_income == "$20,000 - $29,999" | s_fam_income == "$25,000 - $29,999" & fam_income != .
	replace correct_fam_income = 4 if s_fam_income == "$30,000 - $39,999" & fam_income != .
	replace correct_fam_income = 5 if s_fam_income == "$40,000 - $49,999" & fam_income != .
	replace correct_fam_income = 6 if s_fam_income == "$50,000 - $59,999" & fam_income != .
	replace correct_fam_income = 7 if s_fam_income == "$60,000 - $69,999" & fam_income != .
	replace correct_fam_income = 8 if s_fam_income == "$70,000 - $79,999" & fam_income != .
	replace correct_fam_income = 9 if s_fam_income == "$80,000 - $99,999" & fam_income != .
	replace correct_fam_income = 10 if s_fam_income == "$100,000 - $119,999" & fam_income != .
	replace correct_fam_income = 11 if s_fam_income == "$120,000 - $149,999" & fam_income != .
	replace correct_fam_income = 12 if s_fam_income == "$150,000 - $199,999" | s_fam_income == "$150,000 or more" | s_fam_income == "$200,000 - $249,999" | s_fam_income == "$250,000 - $349,999" | s_fam_income == "$250,000 or more" | s_fam_income == "$350,000 - $499,999" | s_fam_income == "$500,000 or more" & fam_income != .
* replace correct_fam_income with missing the question is skipped (value 98)
	replace correct_fam_income = . if fam_income == 98
* Label var
	label variable correct_fam_income "Family income in correct categories"
* LABEL multiple values of the correct family income
	label define income 1 "Less than $10,000" 2 "$10,000 - $19,999" 3 "$20,000 - $29,999" 4 "$30,000 - $39,999" 5 "$40,000 - $49,999" 6 "$50,000 - $59,999" 7 "$60,000 - $69,999" 8 "$70,000 - $79,999" 9 "$80,000 - $99,999" 10 "$100,000 - $119,999" 11 "$120,000 - $149,999" 12 "$150,000 or more", modify
	label values correct_fam_income income

// DICHOTOMIZES FAMILY INCOME
	cap drop income_high
	g income_high = .
	replace income_high = 0 if (correct_fam_income>=1 & correct_fam_income<=6)
	replace income_high = 1 if (correct_fam_income>=7 & correct_fam_income<=12)
	
* --	
	
* EDUCATION	*
	g college_grad = (education == 4 | education == 5 | education == 6) if education!=.
	
* --	


	
	
	
											***********************************
											** MEDIA AND LOCAL NEWS VARIABLE **
											***********************************
											
											
* Recode to Dummies the media usage 
	replace media_use_SM = 0 if media_use_SM == 2
	label values media_use_SM yesno

	replace media_use_none = 0 if media_use_none == 2
	label values media_use_none yesno

	replace media_use_radio = 0 if media_use_radio == 2
	label values media_use_radio yesno

	replace media_use_NP = 0 if media_use_NP == 2
	label values media_use_NP yesno

	replace media_use_TV = 0 if media_use_TV == 2
	label values media_use_TV yesno

	replace media_use_blog = 0 if media_use_blog == 2
	label values media_use_blog yesno




* DUMMIES AND CONTINUOUS
* generate dummies by category			
* news_type
	tab watch_news_type, g(watch_news_type_)
	rename watch_news_type_1 watch_news_type_local
	rename watch_news_type_2 watch_news_type_national
	rename watch_news_type_3 watch_news_type_both

	br year caseID watch_news_type media_use_TV watch_news_type_local watch_news_type_national watch_news_type_both if media_use_TV==0 & (watch_news_type_local!=. | watch_news_type_national !=. | watch_news_type_both!=.)	
** Note : since there are some mistakes in the original CCES variables (causing the anomaly of the br above) we need to do the following corretion:
	
	replace watch_news_type_local = . if media_use_TV == 0 & watch_news_type_local!=.
	replace watch_news_type_national = . if media_use_TV == 0 & watch_news_type_national!=.
	replace watch_news_type_both = . if media_use_TV == 0 & watch_news_type_both!=.
	br year caseID watch_news_type media_use_TV watch_news_type_local watch_news_type_national watch_news_type_both if media_use_TV==0 & (watch_news_type_local!=. | watch_news_type_national !=. | watch_news_type_both!=.)

** See text file "CCES_mistakes_newsvariables" for more info. 

* Relabel 
	label values watch_news_type_local yesno
	label values watch_news_type_national yesno
	label values watch_news_type_both yesno

* --



													  *************************
													  ** POLITICAL KNOWLEDGE **
													  *************************
													
*FOR 2015 and 2017 the VARIABLES PRESENT ADDITIONAL ENTRIES, SUCH THAT: "8 skipped" AND "9 not asked"													
replace governor_approval = . if governor_approval == 8 | governor_approval == 9
replace recog_governor_party = . if recog_governor_party == 8 | recog_governor_party == 9
replace recog_senator1_party = . if recog_senator1_party == 8 | recog_senator1_party == 9
replace recog_senator2_party = . if recog_senator2_party == 8 | recog_senator2_party == 9							
replace recog_houserep_party = . if recog_houserep_party == 8 | recog_houserep_party == 9


*************************************
*Approval member of house of congress
*************************************

	gen dontknow_approval_housemember=0
*2010
	replace dontknow_approval_housemember=1 if housemember_approval==5 & year==2010
	replace dontknow_approval_housemember=. if housemember_approval==. & year==2010
/*
fre housemember_approval
housemember_approval -- Approve of Job - Rep
---------------------------------------------------------------------------
                              |      Freq.    Percent      Valid       Cum.
------------------------------+--------------------------------------------
Valid   1 Strongly Approve    |       9107      16.44      16.66      16.66
        2 Approve             |      17699      31.95      32.37      49.03
        3 Disapprove          |      10698      19.31      19.57      68.59
        4 Strongly Disapprove |      10916      19.70      19.96      88.56
        5 Never Heard         |       6256      11.29      11.44     100.00
        Total                 |      54676      98.69     100.00           
Missing .                     |        724       1.31                      
Total                         |      55400     100.00                      
---------------------------------------------------------------------------

. fre dontknow_approval_housemember

dontknow_approval_housemember
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |      48420      87.40      88.56      88.56
        1     |       6256      11.29      11.44     100.00
        Total |      54676      98.69     100.00           
Missing .     |        724       1.31                      
Total         |      55400     100.00                      
-----------------------------------------------------------

*/



*2011
* never answeered "do not know or never heard"
	replace dontknow_approval_housemember=. if housemember_approval==. & year==2011
/*
housemember_approval -- Approve of Current House Rep
---------------------------------------------------------------------------
                              |      Freq.    Percent      Valid       Cum.
------------------------------+--------------------------------------------
Valid   1 Strongly Approve    |       2814      13.97      14.88      14.88
        2 Approve             |       7828      38.85      41.40      56.29
        3 Disapprove          |       5321      26.41      28.14      84.43
        4 Strongly Disapprove |       2943      14.61      15.57     100.00
        Total                 |      18906      93.83     100.00           
Missing .                     |       1244       6.17                      
Total                         |      20150     100.00                      
---------------------------------------------------------------------------

. fre dontknow_approval_housemember

dontknow_approval_housemember
-------------------------------------------------------
          |      Freq.    Percent      Valid       Cum.
----------+--------------------------------------------
Valid   0 |      18906      93.83     100.00     100.00
Missing . |       1244       6.17                      
Total     |      20150     100.00                      
-------------------------------------------------------

*/


*2012
	replace dontknow_approval_housemember=1 if housemember_approval==5 & year==2012
	replace dontknow_approval_housemember=. if housemember_approval==. & year==2012
/*
housemember_approval -- Approve of Job - Rep
---------------------------------------------------------------------------
                              |      Freq.    Percent      Valid       Cum.
------------------------------+--------------------------------------------
Valid   1 Strongly Approve    |       7549      13.84      14.13      14.13
        2 Approve             |      18726      34.34      35.06      49.19
        3 Disapprove          |      10064      18.45      18.84      68.04
        4 Strongly Disapprove |       7797      14.30      14.60      82.64
        5 Never Heard         |       9274      17.01      17.36     100.00
        Total                 |      53410      97.94     100.00           
Missing .                     |       1125       2.06                      
Total                         |      54535     100.00                      
---------------------------------------------------------------------------

. fre dontknow_approval_housemember

dontknow_approval_housemember
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |      44136      80.93      82.64      82.64
        1     |       9274      17.01      17.36     100.00
        Total |      53410      97.94     100.00           
Missing .     |       1125       2.06                      
Total         |      54535     100.00                      
-----------------------------------------------------------


*/

*2013
	replace dontknow_approval_housemember=1 if housemember_approval==5 & year==2013
	replace dontknow_approval_housemember=. if housemember_approval==. & year==2013
/*
housemember_approval -- Approve of Job - Rep
----------------------------------------------------------------------------------
                                     |      Freq.    Percent      Valid       Cum.
-------------------------------------+--------------------------------------------
Valid   1 Strongly approve           |       1714      10.45      10.70      10.70
        2 Approve                    |       5661      34.52      35.34      46.04
        3 Disapprove                 |       3630      22.13      22.66      68.70
        4 Strongly disapprove        |       2372      14.46      14.81      83.50
        5 Never heard of this person |       2643      16.12      16.50     100.00
        Total                        |      16020      97.68     100.00           
Missing .                            |        380       2.32                      
Total                                |      16400     100.00                      
----------------------------------------------------------------------------------

. fre dontknow_approval_housemember

dontknow_approval_housemember
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |      13377      81.57      83.50      83.50
        1     |       2643      16.12      16.50     100.00
        Total |      16020      97.68     100.00           
Missing .     |        380       2.32                      
Total         |      16400     100.00                      
-----------------------------------------------------------

*/

*2014
	replace dontknow_approval_housemember=1 if housemember_approval==5 & year==2014
	replace dontknow_approval_housemember=. if housemember_approval==. & year==2014
/*
housemember_approval -- Approve of Job - Rep
----------------------------------------------------------------------------------
                                     |      Freq.    Percent      Valid       Cum.
-------------------------------------+--------------------------------------------
Valid   1 Strongly approve           |       6605      11.75      12.00      12.00
        2 Approve                    |      20355      36.22      36.99      49.00
        3 Disapprove                 |      11347      20.19      20.62      69.62
        4 Strongly disapprove        |       7316      13.02      13.30      82.92
        5 Never heard of this person |       9398      16.72      17.08     100.00
        Total                        |      55021      97.90     100.00           
Missing .                            |       1179       2.10                      
Total                                |      56200     100.00                      
----------------------------------------------------------------------------------

. fre dontknow_approval_housemember

dontknow_approval_housemember
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |      45623      81.18      82.92      82.92
        1     |       9398      16.72      17.08     100.00
        Total |      55021      97.90     100.00           
Missing .     |       1179       2.10                      
Total         |      56200     100.00                      
-----------------------------------------------------------

*/

*2015
	replace dontknow_approval_housemember=1 if housemember_approval==5 & year==2015
	replace dontknow_approval_housemember=. if housemember_approval==. & year==2015
	replace dontknow_approval_housemember=. if housemember_approval==8 & year==2015
	replace dontknow_approval_housemember=. if housemember_approval==9 & year==2015
/*
housemember_approval -- Job approval - CurrentHouseName
---------------------------------------------------------------------------
                              |      Freq.    Percent      Valid       Cum.
------------------------------+--------------------------------------------
Valid   1 Strongly Approve    |       1901      13.34      13.34      13.34
        2 Somewhat Approve    |       3748      26.30      26.30      39.64
        3 Somewhat Disapprove |       1884      13.22      13.22      52.86
        4 Strongly Disapprove |       2095      14.70      14.70      67.56
        5 Not Sure            |       4520      31.72      31.72      99.28
        8 Skipped             |         63       0.44       0.44      99.73
        9 Not Asked           |         39       0.27       0.27     100.00
        Total                 |      14250     100.00     100.00           
---------------------------------------------------------------------------

. fre dontknow_approval_housemember

dontknow_approval_housemember
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |       9628      67.56      68.05      68.05
        1     |       4520      31.72      31.95     100.00
        Total |      14148      99.28     100.00           
Missing .     |        102       0.72                      
Total         |      14250     100.00                      
-----------------------------------------------------------

NOTES: We put as missing also categories skipped (63) and not asked (39) - 102 in total that are coded as missing 
*/

*2016
	replace dontknow_approval_housemember=1 if housemember_approval==5 & year==2016
	replace dontknow_approval_housemember=. if housemember_approval==. & year==2016
/*
 fre housemember_approval

housemember_approval -- Approve of Job - Rep
---------------------------------------------------------------------------
                              |      Freq.    Percent      Valid       Cum.
------------------------------+--------------------------------------------
Valid   1 Strongly approve    |       8575      13.27      13.37      13.37
        2 Somewhat approve    |      15573      24.11      24.29      37.66
        3 Somewhat disapprove |       8503      13.16      13.26      50.92
        4 Strongly disapprove |       9359      14.49      14.60      65.52
        5 Not sure            |      22109      34.22      34.48     100.00
        Total                 |      64119      99.26     100.00           
Missing .                     |        481       0.74                      
Total                         |      64600     100.00                      
---------------------------------------------------------------------------

. fre dontknow_approval_housemember

dontknow_approval_housemember
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |      42010      65.03      65.52      65.52
        1     |      22109      34.22      34.48     100.00
        Total |      64119      99.26     100.00           
Missing .     |        481       0.74                      
Total         |      64600     100.00                      
-----------------------------------------------------------

*/

*2017
	replace dontknow_approval_housemember=1 if housemember_approval==5 & year==2017
	replace dontknow_approval_housemember=. if housemember_approval==. & year==2017
	replace dontknow_approval_housemember=. if housemember_approval==8 & year==2017
	replace dontknow_approval_housemember=. if housemember_approval==9 & year==2017
/*
housemember_approval -- Job Approval Representatives -- $CurrentHouseName
---------------------------------------------------------------------------
                              |      Freq.    Percent      Valid       Cum.
------------------------------+--------------------------------------------
Valid   1 Strongly Approve    |       2360      12.97      12.97      12.97
        2 Approve             |       5850      32.14      32.14      45.11
        3 Disapprove          |       3179      17.47      17.47      62.58
        4 Strongly Disapprove |       2689      14.77      14.77      77.35
        5 Never heard         |       4033      22.16      22.16      99.51
        8 skipped             |          5       0.03       0.03      99.54
        9 not asked           |         84       0.46       0.46     100.00
        Total                 |      18200     100.00     100.00           
---------------------------------------------------------------------------

. fre dontknow_approval_housemember

dontknow_approval_housemember
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |      14078      77.35      77.73      77.73
        1     |       4033      22.16      22.27     100.00
        Total |      18111      99.51     100.00           
Missing .     |         89       0.49                      
Total         |      18200     100.00                      
-----------------------------------------------------------

NOTES: We put as missing also categories skipped and not asked - 89 in total that are coded as missing 
*/

*2018
	replace dontknow_approval_housemember=1 if housemember_approval==5 & year==2018
	replace dontknow_approval_housemember=. if housemember_approval==. & year==2018
/*
housemember_approval -- Job approval -- $CurrentHouseName
----------------------------------------------------------------------------------
                                     |      Freq.    Percent      Valid       Cum.
-------------------------------------+--------------------------------------------
Valid   1 Strongly approve           |       7673      12.79      13.01      13.01
        2 Approve                    |      20196      33.66      34.24      47.25
        3 Disapprove                 |      11350      18.92      19.24      66.49
        4 Strongly disapprove        |       9294      15.49      15.76      82.25
        5 Never heard of this person |      10471      17.45      17.75     100.00
        Total                        |      58984      98.31     100.00           
Missing .                            |       1016       1.69                      
Total                                |      60000     100.00                      
----------------------------------------------------------------------------------

. fre dontknow_approval_housemember

dontknow_approval_housemember
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |      48513      80.86      82.25      82.25
        1     |      10471      17.45      17.75     100.00
        Total |      58984      98.31     100.00           
Missing .     |       1016       1.69                      
Total         |      60000     100.00                      
-----------------------------------------------------------

*/

*2019
	replace dontknow_approval_housemember=1 if housemember_approval==5 & year==2019
	replace dontknow_approval_housemember=. if housemember_approval==. & year==2019
/*
housemember_approval -- Job Approval Representatives -- $CurrentHouseName
----------------------------------------------------------------------------------
                                     |      Freq.    Percent      Valid       Cum.
-------------------------------------+--------------------------------------------
Valid   1 Strongly approve           |       2417      13.43      13.56      13.56
        2 Approve                    |       6248      34.71      35.06      48.63
        3 Disapprove                 |       3239      17.99      18.18      66.81
        4 Strongly disapprove        |       2665      14.81      14.96      81.76
        5 Never heard of this person |       3250      18.06      18.24     100.00
        Total                        |      17819      98.99     100.00           
Missing .                            |        181       1.01                      
Total                                |      18000     100.00                      
----------------------------------------------------------------------------------

. fre dontknow_approval_housemember

dontknow_approval_housemember
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |      14569      80.94      81.76      81.76
        1     |       3250      18.06      18.24     100.00
        Total |      17819      98.99     100.00           
Missing .     |        181       1.01                      
Total         |      18000     100.00                      
-----------------------------------------------------------

*/

*2020
	replace dontknow_approval_housemember=1 if housemember_approval==5 & year==2020
	replace dontknow_approval_housemember=. if housemember_approval==. & year==2020
/*
housemember_approval -- Job Approval Institutions -- $CurrentHouseName
---------------------------------------------------------------------------
                              |      Freq.    Percent      Valid       Cum.
------------------------------+--------------------------------------------
Valid   1 Strongly approve    |      10366      16.99      17.17      17.17
        2 Somewhat approve    |      13271      21.76      21.98      39.15
        3 Somewhat disapprove |       6324      10.37      10.47      49.62
        4 Strongly disapprove |      11927      19.55      19.75      69.38
        5 Not sure            |      18488      30.31      30.62     100.00
        Total                 |      60376      98.98     100.00           
Missing .                     |        624       1.02                      
Total                         |      61000     100.00                      
---------------------------------------------------------------------------

. fre dontknow_approval_housemember

dontknow_approval_housemember
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |      41888      68.67      69.38      69.38
        1     |      18488      30.31      30.62     100.00
        Total |      60376      98.98     100.00           
Missing .     |        624       1.02                      
Total         |      61000     100.00                      
-----------------------------------------------------------
*/

* Label variable name
label variable dontknow_approval_housemember "do not know or never heard member of congress"

* GENERAL NOTE:
* The precise question is "Please indicate whether you approve or disapprove of the job that each of the following are doing"
* In most of the year we code as one the answer NEVER HEARD. For few years, see above, NEVER HEARD is substituted by NOT SURE.
* Skipped and Not Asked, when asked, are coded as missing.

*************************************
*PREFERENCE HOUSE OF CONGRESS
*************************************

* Note: Precise wording of the question in CCES: " In the general election of the US House of Rep in your area, who do you prefer?"
*" Assigning value 1 if the answe is I am not sure"

*Voting preferences for the house of congress measured with the question who do you prefer and coding as one the answer .1) I am not sure
	gen no_prefencehouse=0
*2010
*not sure
	replace no_prefencehouse=1 if house_preference==8 & year==2010
*not sure
	replace no_prefencehouse=. if house_preference==. & year==2010
*2012
*not sure
	replace no_prefencehouse=1 if house_preference==8 & year==2012
	replace no_prefencehouse=. if house_preference==. & year==2012
*2014
	replace no_prefencehouse=1 if house_preference==8 & year==2014
	replace no_prefencehouse=. if house_preference==. & year==2014
*2016
	replace no_prefencehouse=1 if house_preference==8 & year==2016
	replace no_prefencehouse=. if house_preference==. & year==2016
*2018
*not sure
	replace no_prefencehouse=1 if house_preference==8 & year==2018
	replace no_prefencehouse=. if house_preference==. & year==2018
*2020
*not sure
*replace no_prefencehouse=1 if house_preference==8 & year==2020
	replace no_prefencehouse=1 if house_preference==98 & year==2020
*not sure
	replace no_prefencehouse=. if house_preference==. & year==2020
*replace no_prefencehouse=. if house_preference==98 & year==2020
*replace no_prefencehouse=. if house_preference==99 & year==2020

	label variable no_prefencehouse "not sure about preference for the house"

*replace no_prefencehouse=. if year==2011 | year==2013 | year==2015 | year==2016 | year==2017 | year==2019
	replace no_prefencehouse=. if year==2011 | year==2013 | year==2015 | year==2017 | year==2019


// NOTES: ONE  WRONGLY CODED, 2020 is the 98 to be categorised as "I'm Not sure" and not the 8. Also, the missing 98 and 99 in 2020 are *wrong, bacause: 98 "I'm not sure"  and  "99 No one". This is evident if we load the 2020 raw data and tab the variable, or if we look at the PDF.
fre no_prefencehouse
/*
BEFORE: 
no_prefencehouse -- not sure about preference for the house
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |     212821      48.51      83.50      83.50
        1     |      42069       9.59      16.50     100.00
        Total |     254890      58.10     100.00           
Missing .     |     183845      41.90                      
Total         |     438735     100.00                      
-----------------------------------------------------------


AFTER CORRECTION:
no_prefencehouse -- not sure about preference for the house
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |     263775      60.12      79.84      79.84
        1     |      66620      15.18      20.16     100.00
        Total |     330395      75.31     100.00           
Missing .     |     108340      24.69                      
Total         |     438735     100.00                      
-----------------------------------------------------------

Total Sum "Not Sure": 9110 (2010) + 10631 (2012) + 12439 (2014) + 15411 (2016) + 9881 (2018) + 9148 (2020) = 66620 
Total Sum Missings considering 2011, 2013, 2015, 2016, 2017, 2019 as Missing given that there is no variable available: 
95 (2010) + 2398 (2012) + 2105 (2014) + 3215 (2018) + 11789 (2020)  = 21340 (Election years missings) + 20150 (2011) + 16400 (2013) + 14250 (2015) + 18200 (2017) + 18000 (2019) = 108340

*/

********************************************************************************
********************************************************************************
********************************************************************************
						  
* Governor approval 
// Gen dummy - I would keep missing in the original variable also missing in the dummy
	gen governor_approval_dummy = .
// To String 
	decode governor_approval, generate(s_governor_approval)
// Switch to 1 if Not Sure -- other papers use "Not Sure" as a measure of political knowledge
	replace governor_approval_dummy = 1 if (s_governor_approval == "Not Sure") & (s_governor_approval != "")
	replace governor_approval_dummy = 0 if (s_governor_approval != "Not Sure") & (s_governor_approval != "")
	label variable governor_approval_dummy "dummy governor approval, Not Sure=1, other=0"


* "Do you recognize this name if so what is their affiliation"
// TO STRING
* GOVERNOR PARTY
	decode recog_governor_party, generate(s_recog_governor_party)
* SENATOR1 PARTY
	decode recog_senator1_party, generate(s_recog_senator1_party)
* SENATOR2 PARTY
	decode recog_senator2_party, generate(s_recog_senator2_party)
* HOUSEREP PARTY
	decode recog_houserep_party, generate(s_recog_houserep_party)

* Dummies for answer - "Never Heard of Person" for each of the following variables
// 1. recog_governor_party
		gen recog_governor_never_heard = .
		replace recog_governor_never_heard = 1 if (s_recog_governor_party == "Never Heard of Person") & (s_recog_governor_party != "")
		replace recog_governor_never_heard = 1 if (s_recog_governor_party != "Never Heard of Person") & (s_recog_governor_party != "")
		label variable recog_governor_never_heard "dummy recognize governor name & which party? ans. Never Heard of Person"

// 2. recog_senator1_party
	gen recog_senator1_never_heard = .
	replace recog_senator1_never_heard = 1 if (s_recog_senator1_party == "Never Heard of Person") & (s_recog_senator1_party != "")
	replace recog_senator1_never_heard = 1 if (s_recog_senator1_party != "Never Heard of Person") & (s_recog_senator1_party != "")
	label variable recog_senator1_never_heard "dummy recognize senator1 name & which party? ans. Never Heard of Person"

// 3. recog_senator2_party
	gen recog_senator2_never_heard = . 
	replace recog_senator2_never_heard = 1 if (s_recog_senator2_party == "Never Heard of Person") & (s_recog_senator2_party != "") 
	replace recog_senator2_never_heard = 0 if (s_recog_senator2_party != "Never Heard of Person") & (s_recog_senator2_party != "") 
	label variable recog_senator2_never_heard "dummy recognize senator2 name & which party? ans. Never Heard of Person"

***************************************************************
******THIS VARIABLE BELOW IS THE ONE WE USE IN THE PAPER********
***************************************************************

// 4a. recog_houserep_party
* Note: The precise wording in CCES is "Please indicate whether you have heard of this person and, if yes, which party he or she is *affiliated with... parties"
	gen recog_houserep_never_heard = .
	replace recog_houserep_never_heard = 1 if (s_recog_houserep_party == "Never Heard of Person") 
*replace recog_houserep_never_heard = 1 if (s_recog_houserep_party == "Not Sure") 
	replace recog_houserep_never_heard = 0 if (s_recog_houserep_party != "Never Heard of Person") & (s_recog_houserep_party != "") 
	label variable recog_houserep_never_heard "dummy recognize houserep name & which party? ans. Never Heard of Person"


// 4b. recog_houserep_party - broad version including as one not only "never heard" but also "not sure".  IMPORTANT: IN THE PAPER WE CHOSE TO USE THIS ONE.
	gen recog_houserep_never_heardbroad = .
	replace recog_houserep_never_heardbroad = 1 if (s_recog_houserep_party == "Never Heard of Person") 
	replace recog_houserep_never_heardbroad = 1 if (s_recog_houserep_party == "Not Sure") 
	replace recog_houserep_never_heardbroad = 0 if (s_recog_houserep_party != "Never Heard of Person") & (s_recog_houserep_party != "Not Sure") & (s_recog_houserep_party != "") 
	label variable recog_houserep_never_heardbroad "dummy recognize houserep name & which party? ans. Never Heard of Person and Not Sure"


	fre s_recog_houserep_party
/*
s_recog_houserep_party -- Party Recall + Name Recognition - Rep
-----------------------------------------------------------------------------
                                |      Freq.    Percent      Valid       Cum.
--------------------------------+--------------------------------------------
Valid   Democrat                |     149186      34.00      34.45      34.45
        Never Heard of Person   |      24843       5.66       5.74      40.19
        Not Sure                |      95345      21.73      22.02      62.20
        Other Party/Independent |       3285       0.75       0.76      62.96
        Republican              |     160389      36.56      37.04     100.00
        Total                   |     433048      98.70     100.00           
Missing                         |       5687       1.30                      
Total                           |     438735     100.00                      
-----------------------------------------------------------------------------
*/

	fre recog_houserep_never_heardbroad

/*
recog_houserep_never_heardbroad
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |     308651      71.18      72.11      72.11
        1     |     119398      27.54      27.89     100.00
        Total |     428049      98.72     100.00           
Missing .     |       5543       1.28                      
Total         |     433592     100.00                      
-----------------------------------------------------------
*/


*********************
*********************
*FOR GOVERNOR PARTY 
* see do file 11_8_240826_cleans_CCES
*********************
*********************


* Save data
	save "data/CCES/cces_individual_panel_revised.dta", replace


*********************************************************
* 3rd STEP - CREATES FINAL VARS AND BRINGS IN TREATMENT *
*********************************************************


	cap drop _merge
	drop cong_district cong_district_add
	ren countyfp countyID
	
***************************************
***1) Bring in congress district information from CCEES
***************************************

* See Do file: 11_0_251014_Creation_CongDistricts.do
	merge 1:1  caseID year using "data/CCES/cd_dma/cces_individual_panel_CDcorrect.dta" 



//     Result                      Number of obs
//     -----------------------------------------
//     Not matched                             0
//     Matched                           438,735  (_merge==3)
//     -----------------------------------------

	drop _m

*******************************************************************************************************************************	
* 2) Note, 2017 CCES file did not have county fips. To recovered them we used the hamornised 06-17 CCEES file merging the CASEid *******************************************************************************************************************************	

	merge 1:1 caseID year using "data/CCES/working/county_fips2017.dta"


//     Result                      Number of obs
//     -----------------------------------------
//     Not matched                       420,535
//         from master                   420,535  (_merge==1)
//         from using                          0  (_merge==2)
//
//     Matched                            18,200  (_merge==3)
//     -----------------------------------------

tab year _merge
//
//            | Matching result from
//            |         merge
//       year | Master on  Matched ( |     Total
// -----------+----------------------+----------
//       2010 |    55,400          0 |    55,400 
//       2011 |    20,150          0 |    20,150 
//       2012 |    54,535          0 |    54,535 
//       2013 |    16,400          0 |    16,400 
//       2014 |    56,200          0 |    56,200 
//       2015 |    14,250          0 |    14,250 
//       2016 |    64,600          0 |    64,600 
//       2017 |         0     18,200 |    18,200 
//       2018 |    60,000          0 |    60,000 
//       2019 |    18,000          0 |    18,000 
//       2020 |    61,000          0 |    61,000 
// -----------+----------------------+----------
//      Total |   420,535     18,200 |   438,735 

* Replace the missing county fips

	replace countyID = countyfp17 if year == 2017 & countyID == ""
*	(18,169 real changes made). Not 19,200 as above. This is because in the original 2017 CCES county, 31 obs where missing. 
*	count if countyfp17==""
*	31

* Drop useless var 
	drop countyfp17 _merge
	count
*	438,735	*
	
	
// *****************************
// **4) Bring in Local Knoweledge additional data
// *****************************
//
// 	merge 1:1 caseID year using "data/CCES/local_knoweledge.dta"
//
// //  Result                      Number of obs
// //     -----------------------------------------
// //     Not matched                             0
// //     Matched                           494,935  (_merge==3)
// //     -----------------------------------------
// 	drop _merge

*** Prepare variables for merge 
	
	*replace cong_district=statefp+cong_district
	rename countyID fips
	rename cong_district cd
	rename statefp statefips
	
*************************************************
**5) Bring in DMA information and Congruence data
*************************************************
	
* Note: before proceeding to the merge we need to fix few congressional districts in CCES which would lose otherwise. In particular, in the US there are few Statess with only one congressional district. These are: 
	// Alaska, 02
	// Delaware, 10
	// North Dakota 38
	// South Dakota 46
	// Vermont 50
	// Wyoming 56
	// Montana, 30 (up to 2020 then gained one more. 
	// Il District of Columbia (DC), 11 not a state but a federal district.  
*These, so called state at large, are normally coded as 01. CCES code them 01 as well but some cd are coded 00 only in 2010 and 2011. Hence, I am harmonising them to not lose these observations. 

	
* 1. Flag for at large states
	gen byte atlarge_fix = inlist(statefips, ///
    "02", "10", "11", "30", "38", "46", "50", "56")

* 2. Fix ONLY for years 2010 and 2011 where districts xx00 -> xx01
	replace cd = statefips + "01" if atlarge_fix == 1 ///
    & inrange(year, 2010, 2011) ///
    & substr(cd, 3, 2) == "00"
	
*(1580 changes made)	

* (optional) quick check
	tab year cd if atlarge_fix == 1	

** Now ready to merge in congruence information ** 
	
	
*see do file "11_8_251017_create_congruence_dataset"
	merge m:1 fips cd statefips using "data/CCES/working/final_with_counties_new.dta"
	
	
//	    Result                      Number of obs
//    -----------------------------------------
//    Not matched                        19,089
//        from master                     2,548  (_merge==1)
//        from using                     16,541  (_merge==2)
//
//    Matched                           436,187  (_merge==3)
//    -----------------------------------------
	
	* Note1: go to do file "inspection_congruence_merge" for a details inspection on which observations do we have in _m==1 above.
	* In short: the overwhelming majority are counties from Alaska and DC which are not present in  final_with_counties_new. We are left with 209 instances for which we fail to build a mapping, cd_county_dma. Small number of residual mismatches likely driven by a combination of CCES geocoding noise and differences between congressional and DMA boundaries over time.	
	
	* Note2. This below would be the output of the merge if we do not run from line 1147 to 119 above (do not fix districts at large)	
	
//     Result                      Number of obs
//     -----------------------------------------
//     Not matched                        20,284
//         from master                     3,738  (_merge==1)
//         from using                     16,546  (_merge==2)
//
//     Matched                           434,997  (_merge==3)
//     -----------------------------------------
//
//	
	
	keep if _m==3
	drop _m
	
	
// ** Gen dummies for percentiles congruence**

	egen cdID=group(cd)
	egen tag=tag(cdID)

	su share_of_dma if tag==1, d
	g above_median = (share_of_dma>=`r(p50)') 
	su share_of_dma if tag==1, d
	g top_75_congruence = (share_of_dma>=`r(p75)') 


*************************
** CREATES THE WEIGHTS ** 
*************************

* Generate weights CCES to make it "representative" by cd dma

	bys dmacode cd: gen repondents=_N

	gen respondents_weight=1/repondents

*****************************************	
********* BRING IN TREATMENT ************
*****************************************

	preserve
	use data/acquisitions/acquisition_panel_dma_top3_FINAL.dta, clear

	
* Leave 6 months buffer. Consider a dma/year treated if the group was present for at least 6 months (May onwards)	
	keep if month(dofm(date))==5

*g year = yofd(dofm(date)) 

	tempfile treatment
	save `treatment'
	restore

	cap drop _merge

	merge m:1 dmacode year using `treatment'
	
	
//	    Result                      Number of obs
//    -----------------------------------------
//    Not matched                         1,423
//        from master                     1,405  (_merge==1) HONOLULU
//        from using                         18  (_merge==2)
//
//    Matched                           434,782  (_merge==3)
//    -----------------------------------------

	
	keep if _m==3
	drop _m


* Create redistricting cycle
	gen redistricting=0
	replace redistricting=1 if year>2011	
	
	
save data/CCES/CCES_final.dta, replace
	
 *--------------------------------------*
// * GENERATE DESCRIPTIVE STATS
// *--------------------------------------*

//  estpost summarize recog_houserep_never_heardbroad dontknow_approval_housemember no_prefencehouse gender_male employed race_black race_hispanic race_asian race_others college_grad married income_high age
// //
// * Export only N, mean, and SD
//  esttab using tables/CCES_summary_stats_f.tex, ///
//      cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3))") ///
//      label title("Summary Statistics (N, Mean, SD)") replace
// //	
//
//
//
//									  


