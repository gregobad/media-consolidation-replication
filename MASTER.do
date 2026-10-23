/////////////////////////////////////////////////////////////////
// MASTER FILE                                                 //
// Calls every Stata script needed to build the analysis data  //
// and reproduce the tables and figures of the paper.          //
// Edit the global PATH in 00_setup.do before running.         //
/////////////////////////////////////////////////////////////////

do 00_setup.do

//////////////////////////////////////
// CREATES DATASET FOR THE ANALYSIS //
//////////////////////////////////////

// 01 Gets FCC facility IDs for scraping         [requires BIA/Kelsey station file, not included]
// do ${PATH}/data_construction/01_gets_fccids_for_scraping.do

// 02 Scrapes FCC call sign history (Python)      [output data/acquisitions/callsigns_history.csv is included]
// shell python3 ${PATH}/data_construction/02_scrapes_callsigns_history.py

// 03 Cleans the scraped call sign history
do ${PATH}/data_construction/03_cleans_callsign_history.do

// 04 Creates the station- and DMA-level acquisition panels  [requires BIA/Kelsey station file, not included]
// do ${PATH}/data_construction/04_creates_acquisition_panel_top3.do

// 05 Cleans the content (TVEyes / Harmony Labs) data          [requires proprietary TVEyes-derived input]
do ${PATH}/data_construction/05_cleans_content_data.do

// 06 Cleans the advertising and viewership (Nielsen Ad Intel) data  [requires proprietary Nielsen-derived input]
do ${PATH}/data_construction/06_cleans_adintel_data.do

// 07 Baseline (2010) station characteristics                  [requires output of 06]
do ${PATH}/data_construction/07_gets_stations_baseline_characteristics_2010.do

// 08-10 CCES: congressional-district / DMA congruence, CD assignment, cleaning  [requires raw CCES files, see README]
do ${PATH}/data_construction/08_create_congruence_dataset.do
do ${PATH}/data_construction/09_creates_CongDistricts.do
do ${PATH}/data_construction/10_cleans_CCES.do

///////////////////////
// RUNS THE ANALYSIS //
///////////////////////

// main text figures
do ${PATH}/analysis/figures_main.do

// main text tables
do ${PATH}/analysis/tables_main.do

// appendix figures
do ${PATH}/analysis/figures_appendix.do

// appendix tables
do ${PATH}/analysis/tables_appendix.do

// robustness appendix figures (TWFE and de Chaisemartin-d'Haultfoeuille event studies)
do ${PATH}/analysis/figures_robustness_appendix.do

// robustness appendix tables
do ${PATH}/analysis/tables_robustness_appendix.do

// numbers quoted in the text (number of stations ever owned / acquired by group)
do ${PATH}/analysis/scalars.do

// R scripts (run separately, see README):
//   analysis/donations.R                -> Appendix Figures on political donations
//   analysis/predict_acquisitions.R     -> Appendix Figure D1 and Table D1 (acquisition propensity)
//   data_construction/11_market_demos.R -> DMA-level predictors used in the acquisition-propensity appendix
