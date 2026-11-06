/////////////////////////////////////////////////////////////////
// SETS UP PATHS AND GLOBALS                                   //
// Run this file once at the start of every Stata session,     //
// before any script in data_construction/ or analysis/.       //
/////////////////////////////////////////////////////////////////

clear all
set more off
pause off

/////////////////////////////////////////////////////////////////
// SET THE PATH TO THE ROOT OF THIS ARCHIVE HERE               //
/////////////////////////////////////////////////////////////////

global PATH ""

cd "${PATH}"

// output folders (created if missing)
cap mkdir "${PATH}/tables"
cap mkdir "${PATH}/figures"
cap mkdir "${PATH}/data/CCES/raw/individual"

//////////////////
// SETS GLOBALS //
//////////////////

// baseline (2010) station characteristics interacted with time FEs
global station_controls 	"log_duration_news_2010 log_spend_news_2010 rating_news_2010"

// individual-level controls, CCES regressions
global controls_CCES 		"gender_male employed race_black race_hispanic race_asian race_others college_grad married income_high age"
