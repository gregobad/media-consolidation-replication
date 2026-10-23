# Replication Files for Media Consolidation

This repository contains replication code and data for Martin, Mastrorocco, McCrain, and Ornaghi, "Media Consolidation," *Review of Economics and Statistics* (forthcoming).

Contact for questions about the replication files: Gregory J. Martin, Stanford Graduate School of Business, gjmartin@stanford.edu.

# How to Use This Archive

1. Stata scripts in `data_construction` construct the analysis datasets from the raw data. Several of these depend on proprietary data that is not included in the archive (see "Sources for Proprietary Data Sets" below). The scripts must be run in the order given by their numeric prefix; `MASTER.do` at the root of the archive calls them in the right order. Scripts whose inputs are not included are commented out in `MASTER.do`, but their *outputs* are included wherever the data license allows, so that downstream scripts can be run.

2. Stata and R scripts in `analysis` produce every table and figure in the manuscript and appendices from the processed data. The Stata scripts are also called by `MASTER.do`; the R scripts are run separately. See below for indices describing which script produces each table or figure. Most tables and figures depend on proprietary data (Nielsen Ad Intel and/or TVEyes transcripts); this is noted in the indices.

3. Before running anything, set the path to the root of this archive:
   - Stata: edit `global PATH` in `00_setup.do`. `MASTER.do` runs `00_setup.do` first; if you run individual scripts, run `00_setup.do` first in the same session. All Stata scripts use paths relative to the archive root (or the global `${PATH}`).
   - R and Python: edit `path_to_archive` at the top of each script.

4. Outputs are written to `tables/` (LaTeX fragments, `\input` by the manuscript) and `figures/` (PDF/PNG). The archive ships with the versions of these files that appear in the published manuscript, so a replicator can compare re-generated output to the originals. Four tables received small manual edits after being produced by Stata; these are documented in "Manual edits to script output" below.

## Software

The scripts were run by the authors on the following software. Replicators should use the same or later versions.

| Software | Version | Notes |
|---|---|---|
| Stata | Stata/MP or SE, version 17 or later | User-written packages: `reghdfe`, `ftools`, `estout` (`eststo`, `estadd`, `esttab`), `unique`, `fre`, `mdesc`, `egenmore` (for `egen, nvals()`), `spmap`, `palettes` and `colrspace` (for `colorpalette`), `did_multiplegt_dyn`, `ppmlhdfe`. All are installable with `ssc install`. |
| R | 4.6.1 (macOS 26.7) | Packages: `tidyverse` 2.0.0, `haven` 2.5.5, `data.table` 1.18.6, `lubridate` 1.9.5, `fixest` 0.14.2, `glmnet` 5.1, `glue` 1.8.1, `magrittr`, `broom`, `ggthemes`, `humaniformat` 0.6.0. |
| Python | 3.9 | `pandas`, `beautifulsoup4`, `lxml` (only for `data_construction/02_scrapes_callsigns_history.py`, whose output is included). |

Run times: `analysis/figures_robustness_appendix.do` (the de Chaisemartin and d'Haultfoeuille event studies) is the slowest script and takes several hours on a laptop. All other scripts run in minutes.

# Manuscript Figures / Tables to Source Code Index

Table / Figure | File(s) in `figures/` or `tables/` | Code to Produce | Requires Proprietary Data?
------ | ------ | ------ | ------
Figure 1(a) | `ownership_over_time_bygroup_top3.pdf` | `analysis/figures_main.do` |
Figure 1(b) | `populationreached_over_time_bygroup_top3.pdf` | `analysis/figures_main.do` | Yes (Nielsen)
Figure 2(a) | `mention_place_pershow_DID_bygroup.pdf` | `analysis/figures_main.do` | Yes (TVEyes, Nielsen)
Figure 2(b) | `mention_place_pershow_TRIPLEDIFF_bygroup.pdf` | `analysis/figures_main.do` | Yes (TVEyes, Nielsen)
Figure 3(a) | `log_duration_DID_bygroup.pdf` | `analysis/figures_main.do` | Yes (Nielsen)
Figure 3(b) | `log_duration_TRIPLEDID_bygroup.pdf` | `analysis/figures_main.do` | Yes (Nielsen)
Figure 4(a) | `news_rating_DID_bygroup.pdf` | `analysis/figures_main.do` | Yes (Nielsen)
Figure 4(b) | `news_rating_TRIPLEDIFF_bygroup.pdf` | `analysis/figures_main.do` | Yes (Nielsen)
Table 1 | `content_main.tex` | `analysis/tables_main.do` | Yes (TVEyes, Nielsen)
Table 2 | `content_additional_outcomes.tex` | `analysis/tables_main.do` | Yes (TVEyes, Nielsen)
Table 3 | `adintel_main.tex` | `analysis/tables_main.do` | Yes (Nielsen)
Table 4 | `ratings_main.tex` | `analysis/tables_main.do` | Yes (Nielsen)
Table 5 | `CCES_unweightednew.tex` | `analysis/tables_main.do` | No (public CCES, see "Public data not included")
Table 6 | `congruence_unweightedF.tex` | `analysis/tables_main.do` | Yes (Panel A: TVEyes, Nielsen; Panel B: public CCES)

Nielsen data enter every regression on the station-month panel through the baseline (2010) station controls, even when the outcome comes from the TVEyes transcripts.

# Appendix Figures / Tables to Source Code Index

Appendix figures and tables are numbered by appendix section (A: Appendix Figures, B: Appendix Tables, C: Model, D: Analysis of Differences across Conglomerates, E: Data, F: Robustness Checks).

Table / Figure | File(s) in `figures/` or `tables/` | Code to Produce | Requires Proprietary Data?
------ | ------ | ------ | ------
Figure A1(a) | `map.png` | `analysis/figures_main.do` |
Figure A1(b)-(d) | `map_sinclair.png`, `map_nexstar.png`, `map_gray.png` | `analysis/figures_appendix.do` |
Figure A2 | `descriptives_mentions_overtime.pdf`, `descriptives_mentions_density.pdf` | `analysis/figures_appendix.do` | Yes (TVEyes, Nielsen)
Figure A3 | `descriptives_adsduration_overtime.pdf`, `descriptives_adsduration_density.pdf` | `analysis/figures_appendix.do` | Yes (Nielsen)
Figure A4 | `descriptives_adsrevenue_overtime.pdf`, `descriptives_adsrevenue_density.pdf` | `analysis/figures_appendix.do` | Yes (Nielsen)
Figure A5 | `descriptives_ratings_overtime.pdf`, `descriptives_ratings_density.pdf` | `analysis/figures_appendix.do` | Yes (Nielsen)
Figure A6 | `descriptives_impressions_overtime.pdf`, `descriptives_impressions_density.pdf` | `analysis/figures_appendix.do` | Yes (Nielsen)
Figure A7 | `log_spending_DID_bygroup.pdf`, `log_spending_TRIPLEDID_bygroup.pdf` | `analysis/figures_appendix.do` | Yes (Nielsen)
Figure A8 | `log_imp_total_news_DID_bygroup.pdf`, `log_imp_total_news_TRIPLEDIFF_bygroup.pdf` | `analysis/figures_appendix.do` | Yes (Nielsen)
Table B1 | `sample_stats.tex` | `analysis/tables_appendix.do` | Yes (Nielsen, for the analytical-sample column)
Table B2 | `descriptives_EDITED.tex` (manual edit of `descriptives.tex`) | `analysis/tables_appendix.do` | Yes (TVEyes, Nielsen)
Table B3 | `CCES_descriptives.tex` | `analysis/tables_appendix.do` | No (public CCES)
Table B4 | `adintel_by_multi_and_single_market.tex` | `analysis/tables_appendix.do` | Yes (Nielsen)
Table B5 | `adintel_share_local.tex` | `analysis/tables_appendix.do` | Yes (Nielsen)
Table B6 | `cpm.tex` | `analysis/tables_appendix.do` | Yes (Nielsen)
Table B7 | `adintel_main_nonnews.tex` | `analysis/tables_appendix.do` | Yes (Nielsen)
Table B8 | `ratings_byagegroup.tex` | `analysis/tables_appendix.do` | Yes (Nielsen)
Table B9 | `ratings_nonnews.tex` | `analysis/tables_appendix.do` | Yes (Nielsen)
Table B10 | `content_additional_outcomes_dummy.tex` | `analysis/tables_appendix.do` | Yes (TVEyes, Nielsen)
Table B11 | `market_concentration_final.tex` | `analysis/tables_appendix.do` (last section) | Yes (Nielsen, for baseline ratings); public CCES
Figures C1, C2 | drawn in TikZ inside `appendix.tex` | N/A |
Figure D1 | `lasso_acquisitions.png` | `analysis/predict_acquisitions.R` | Yes (Nielsen)
Table D1 | `within_market_acquisitions.tex` | `analysis/predict_acquisitions.R` | Yes (Nielsen)
Figure D2 | `rr_cand_giving.pdf` | `analysis/donations.R` |
Figure D3 | `rr_pac_giving.pdf` | `analysis/donations.R` |
Table D2 | typed directly in `appendix.tex` (source: S&P Capital IQ) | N/A |
Figures D4-D9 | `earning_calls_{sinclair,nexstar,gray}_part{1,2}_cropped.pdf` | N/A, see note (2) below |
Figure F1 | `mention_place_pershow_{TWFEsemesters,dCdH}_{DID,TRIPLEDIFF}[_controls].pdf` | `analysis/figures_robustness_appendix.do` | Yes (TVEyes, Nielsen)
Figure F2 | `log_duration_{TWFEsemesters,dCdH}_{DID,TRIPLEDIFF}[_controls].pdf` | `analysis/figures_robustness_appendix.do` | Yes (Nielsen)
Figure F3 | `log_spending_{TWFEsemesters,dCdH}_{DID,TRIPLEDIFF}[_controls].pdf` | `analysis/figures_robustness_appendix.do` | Yes (Nielsen)
Figure F4 | `news_ratings_{TWFEsemesters,dCdH}_{DID,TRIPLEDIFF}[_controls].pdf` | `analysis/figures_robustness_appendix.do` | Yes (Nielsen)
Figure F5 | `log_imp_total_news_{TWFEsemesters,dCdH}_{DID,TRIPLEDIFF}[_controls].pdf` | `analysis/figures_robustness_appendix.do` | Yes (Nielsen)
Table F1 | `content_robustness.tex` | `analysis/tables_robustness_appendix.do` | Yes (TVEyes, Nielsen)
Table F2 | `adintel_robustness.tex` | `analysis/tables_robustness_appendix.do` | Yes (Nielsen)
Table F3 | `adintel_robustness_spending.tex` | `analysis/tables_robustness_appendix.do` | Yes (Nielsen)
Table F4 | `ratings_robustness.tex` | `analysis/tables_robustness_appendix.do` | Yes (Nielsen)
Table F5 | `log_impressions_robustness.tex` | `analysis/tables_robustness_appendix.do` | Yes (Nielsen)
Table F6 | `content_spillovers_DID.tex` | `analysis/tables_appendix.do` | Yes (TVEyes, Nielsen)
Table F7 | `content_spillovers_TRIPLEDIFF.tex` | `analysis/tables_appendix.do` | Yes (TVEyes, Nielsen)
Table F8 | `adintel_spillovers_DID.tex` | `analysis/tables_appendix.do` | Yes (Nielsen)
Table F9 | `adintel_spillovers_TRIPLEDIFF.tex` | `analysis/tables_appendix.do` | Yes (Nielsen)
Table F10 | `ratings_spillovers_DID.tex` | `analysis/tables_appendix.do` | Yes (Nielsen)
Table F11 | `ratings_spillovers_TRIPLEDIFF.tex` | `analysis/tables_appendix.do` | Yes (Nielsen)

Numbers quoted in the text on the number of stations ever owned and acquired by each group are produced by `analysis/scalars.do`.

Notes:

1. **Acquisition-propensity analysis (Figure D1, Table D1).** `analysis/predict_acquisitions.R` estimates a cross-sectional binomial LASSO (`glmnet`, 10-fold cross-validation with folds stratified on the outcome) followed by unpenalized logit on the selected predictors, and station-by-semester linear probability models with DMA and semester fixed effects (`fixest`). Predictors are the DMA-level characteristics in `data/geo/dma_demos.csv` (built by `data_construction/11_market_demos.R`) and station-level 2010 means of ratings, impressions, advertising duration and revenue taken from two Nielsen-derived station-month files that are not included (see the data-file table). The script also writes `tables/within_market_acquisitions_drop_alwaystreated.tex`, a variant not reported in the paper. The LASSO uses fixed random seeds, so results are reproducible given the same inputs.

2. **Earnings-call figures (D4-D9).** These are typeset summaries of a qualitative reading of the groups' quarterly earnings-call transcripts (2013-2019), produced with the assistance of a large language model as described in Appendix D. They are not generated by code in this archive.

## Manual edits to script output

The LaTeX fragments in `tables/` are the versions used in the manuscript. For 25 of the 29 tables these are identical to the Stata output up to line endings. Four were edited by hand after being produced:

| Table | Script output | Manual edit |
|---|---|---|
| B2 `descriptives_EDITED.tex` | `descriptives.tex` | The "Stations" and "DMAs" columns (number of stations and DMAs contributing to each panel) were filled in by hand from the counts printed in the Stata log; panel titles were edited. |
| 5 `CCES_unweightednew.tex` | same name | `\hline` replaced by `\toprule`/`\midrule`/`\bottomrule`; "DMA FE" relabeled "DMA FEs". Numbers unchanged. |
| 6 `congruence_unweightedF.tex` | same name | `\hline` replaced by `\midrule`; the "CDs" row of Panel B commented out. Numbers unchanged. |
| B11 `market_concentration_final.tex` | same name | Coefficient and column labels rewritten (e.g. "Post-Acquisition, Sinclair=1 × high_ratings_sinclair_v2=1" to "Post-Acquisition, Sinclair × High Ratings Sinclair"), the esttab `\caption` removed, and the table wrapped as a fragment. Numbers unchanged. |

Re-running the scripts overwrites the hand-edited files with the raw output; the archive copies can be recovered from the git history.

# Description of Data Files

The `data` directory mirrors the directory structure that the scripts expect. Files marked **not included** are either proprietary or too large to redistribute; see "Sources for Proprietary Data Sets" and "Public data not included" for how to obtain them.

## Ownership and station data

File / Directory | Description | Source
------ | ------ | ------
`acquisitions/acquisition_dates_03feb2026.xlsx` | Dates on which Sinclair, Nexstar, Gray (and the groups they absorbed: Media General, Raycom, LIN) took control of each station, with the selling group. Sheet `acquisitions_dates` covers full-power stations (keyed by FCC facility ID), sheet `acquisitions_dates_LP_stations` low-power stations. | Hand-collected from the groups' annual 10-K reports and press releases
`acquisitions/JSA_SSA_LMA_dates_03feb2026.xlsx` | Start and end dates of Local Marketing Agreements (LMA), Shared Services Agreements (SSA) and Joint Sales Agreements (JSA) between each group and stations it does not own. One sheet per group plus a consolidated sheet `Full`, which is the one read by the code. | Hand-collected from 10-K reports
`acquisitions/divestitures_03feb2026.xlsx` | Stations divested by each group after acquisition (purchase and sale dates). | Hand-collected from 10-K reports and press releases
`acquisitions/information_LP_stations.xlsx` | Low-power stations appearing in the TVEyes data: type, DMA, initial owner, and whether they are kept in the sample (sheet `LP_stations`). | Desk research (FCC, station websites)
`acquisitions/UofWarwickTVJuly2018.xlsx` | **Not included.** BIA/Kelsey Media Access Pro station database: yearly network affiliation, market, and owner of every full-power US station, 2009-2017. Licensed. | BIA Advisory Services
`acquisitions/fccidnumbers_for_scraping.dta` | FCC facility IDs of the 780 stations ever affiliated with a Big Four network in the TVEyes station list (output of `01_gets_fccids_for_scraping.do`). | Derived
`acquisitions/callsigns_history.csv` | Raw scrape of the FCC CDBS call-sign history page for each facility ID (output of `02_scrapes_callsigns_history.py`, July 2022). | FCC CDBS
`acquisitions/callsign_history_cleaned.dta` | Cleaned call-sign spells by facility ID (output of `03_cleans_callsign_history.do`). | Derived
`acquisitions/acquisition_panel_station_top3_FINAL.dta` | **Main treatment file.** Station-by-month panel, 2010m1-2020m12, for the 760 stations in the acquisition sample, with indicators for control by Sinclair, Nexstar, and Gray under the three treatment definitions used in the paper (LMA = owned or operated under an LMA, the baseline; SSA = additionally counts SSAs/JSAs; OO = owned-and-operated only), the selling group, DMA, and a divestiture flag (output of `04_creates_acquisition_panel_top3.do`). | Derived
`acquisitions/acquisition_panel_dma_top3_FINAL.dta` | DMA-by-month panel with indicators for the presence of at least one station controlled by each group, the number of such stations, and which group entered the market first (output of `04_creates_acquisition_panel_top3.do`). | Derived
`tv/dma_names_xwalk.xlsx` | Crosswalk between BIA/Kelsey market names, Nielsen DMA names, and the names in the 2008 DMA boundary file. | Authors
`tv/dmacodes.csv` | Nielsen DMA code to DMA name crosswalk. | Nielsen
`harmony/harmony_callsigns.csv` | List of the 914 station call signs present in the TVEyes transcript data. | Harmony Labs
`dma_dmaID_xwalk.dta` | DMA name to BIA market ID crosswalk, used to draw maps. | Authors
`DMA_2008_database.dta`, `DMA_2008_coords.dta` | Polygon attribute and coordinate files for the 2008 DMA boundaries, in the format required by `spmap`. | 2008 DMA boundary shapefile converted with `shp2dta`

## Content, advertising and viewership data

File / Directory | Description | Source
------ | ------ | ------
`harmony/harmony_mentions_station_month.csv` | **Not included.** Station-by-month counts, January 2013-December 2019, of the number of local newscasts (`n_progs`) and words (`n_words`) in the TVEyes transcripts, and of mentions of same-DMA municipalities and counties (`mention_place_*`), mayors and mayoral candidates (`mention_pol_local_*`), state legislators and candidates (`mention_pol_stateleg_*`), US House members and candidates (`mention_pol_congress_*`), and national politicians (`mention_pol_national_*`); each in levels, per show, per word, and inverse-hyperbolic-sine. Columns: `date, callsign, dmacode, n_progs, n_words, mention_{place,pol_local,pol_stateleg,pol_national,pol_congress}_{total,pershow,perword,asinh}`. | Derived from TVEyes transcripts (proprietary)
`harmony/harmony_mentions_station_cong_district_month.csv` | **Not included.** Same as above but for mentions of US House members and candidates by station, congressional district and month, with the district's population share of the DMA (`share_of_dma`); used for the congruence analysis in Table 6, Panel A. | Derived from TVEyes transcripts (proprietary)
`harmony/content_cleaned.dta` | **Not included.** Analysis file for the content outcomes: the station-month mention counts merged with the acquisition panel, with the sample restrictions described in Appendix E (output of `05_cleans_content_data.do`). | Derived (proprietary)
`adintel/adintel_clean_yearmonth.csv` | **Not included.** Station-by-month aggregates, 2010-2019, of the Nielsen Ad Intel occurrence and impressions files for ads aired on local newscasts (5pm-11:30pm) and on other programs: number of ads, total duration (seconds), total estimated spending (dollars), number of half hours, impressions and ratings by demographic group (total, female/male, under/over 50), cost per mille, and TV households in the market, each split by single-market ("local") versus multi-market advertisers. Column names follow the pattern `{n_ads,total_duration,total_spend,total_half_hour,imp_<demo>,rating_<demo>,cpm}_{multimarket,local}_{news,nonnews}` plus `hh_<demo>`. | Derived from Nielsen Ad Intel (proprietary)
`adintel/adintel_clean_updated.dta` | **Not included.** Analysis file for the advertising and viewership outcomes: the station-month aggregates merged with the acquisition panel, with the sweep-month smoothing, interpolation, and sample restrictions described in Appendix E (output of `06_cleans_adintel_data.do`). | Derived (proprietary)
`station_baseline_characteristics_2010.dta`, `station_baseline_characteristics_2010_small.dta` | **Not included.** 2010 averages by station of news and non-news ratings, advertising duration and revenue per TV household, for the 644 stations continuously observed February-December 2010 (the "analytical sample"). The `_small` file keeps only the three baseline controls used in the regressions (output of `07_gets_stations_baseline_characteristics_2010.do`). | Derived (proprietary)

## CCES (political knowledge) data

File / Directory | Description | Source
------ | ------ | ------
`CCES/raw/cces2010.dta` ... `cces2020.dta` | **Not included (size).** Cooperative Congressional Election Study common-content files, one per year 2010-2020. | CCES Dataverse, https://cces.gov.harvard.edu
`CCES/cd_dma/cd2dma.dta` | Congressional district to DMA crosswalk by year, with the share of the DMA's votes cast in each district. | Built from county-level returns and county-to-DMA assignment
`CCES/cd_dma/xwalk_state.dta` | State abbreviation to state FIPS crosswalk. | Census
`CCES/cd_dma/DMA-zip.csv` | County and ZIP code to DMA crosswalk. | Nielsen DMA definitions
`CCES/working/county_fips2017.dta` | County of residence for respondents to the 2017 CCES, which reports ZIP code but not county. | Derived from CCES 2017 ZIP codes
`CCES/working/final_with_counties_new.dta` | Congressional district by county by DMA file (output of `08_create_congruence_dataset.do`). | Derived
`CCES/cd_dma/cces_individual_panel_CDcorrect.dta` | Respondent-level file with corrected congressional district of residence (output of `09_creates_CongDistricts.do`). | Derived
`CCES/CCES_final.dta` | **Not included (size, 320 MB).** Respondent-level analysis file: political knowledge outcomes, controls, county, congressional district, DMA, and the DMA-year treatment indicators (output of `10_cleans_CCES.do`; fully reproducible from the public CCES files). | Derived

## Appendix D (differences across conglomerates) data

File / Directory | Description | Source
------ | ------ | ------
`geo/dma_demos.csv` | DMA-level characteristics used as predictors of acquisition: 2010 Census and 2006-2010 ACS population, housing, income, education, commuting, race, age and family-structure variables (columns named by NHGIS code; `geo/census/census_vars.csv` maps codes to definitions), labor-force participation, Gini, 2012 presidential vote shares, number of stations, newspaper circulation per capita, and 2010 price per impression (output of `11_market_demos.R`). | Derived
`geo/census/census_vars.csv` | NHGIS variable code to definition. | NHGIS
`geo/census/nhgis0018_ds172_2010_county.csv`, `nhgis0018_ds176_20105_county.csv`, `nhgis0018_ds177_20105_county.csv` and `*_codebook.txt` | County-level extracts from the 2010 Census (SF1) and the 2006-2010 ACS 5-year estimates, with codebooks. | IPUMS NHGIS, https://www.nhgis.org
`geo/cty2DMA.RData` | County to DMA crosswalk with vote-share allocation weights for counties split across DMAs. | Authors, from Nielsen DMA definitions
`elections/countypres_2000-2020.csv` | County-level presidential election returns. | MIT Election Data and Science Lab
`newspapers/circulation_per_capita_2010.csv` | Daily newspaper circulation per capita by county, 2010. | Alliance for Audited Media circulation reports
`tv/ads2010_market_agg.rds` | **Not included.** 2010 average price per impression by DMA. | Derived from Nielsen Ad Intel (proprietary)
`adintel/ads_halfhour_full_cleaned.dta` | **Not included.** Station-by-month advertising duration, spending and revenue per minute on local (`_L`) and non-local (`_NL`) programs, 2010-2019, from an earlier aggregation of the Ad Intel occurrence files; `predict_acquisitions.R` uses only the 2010 station means. | Derived from Nielsen Ad Intel (proprietary)
`adintel/ads_impression_cleaned.dta` | **Not included.** Station-by-month news and non-news ratings and log impressions, 2010-2019, from an earlier aggregation of the Ad Intel impressions files; `predict_acquisitions.R` uses only the 2010 station means. | Derived from Nielsen Ad Intel (proprietary)
`donations/*_messy.csv` | Raw FEC individual-contribution downloads for contributors listing Gray, Nexstar or Sinclair (or a media/broadcasting employer) as employer. | FEC, https://www.fec.gov/data/receipts/individual-contributions/
`donations/*_check.csv` | Subsets of the above matched by last name to the officers and directors in `boards/`, hand-checked; `drop` = 1 flags false matches. | Derived
`donations/sinclair_employers.csv` | Employer strings in the Sinclair download with a hand-coded `keep` flag. | Derived
`donations/ind_donations.csv` | Cleaned individual donations by officers and directors (output of `donations.R`, intermediate). | Derived
`donations/sinclair_pac.csv`, `nexstar_pac.csv` | FEC disbursement downloads for the Sinclair and Nexstar corporate PACs (Gray had no PAC in the sample period). | FEC
`donations/boards/*.csv` | Officers and directors of each group by year (name, title, year). | Hand-collected from SEC filings (DEF 14A proxy statements and 10-K reports)
`dime/dime_recipients_1979_2024.csv` | **Not included (size).** DIME recipients file, used to identify the party of recipient committees. | Bonica, Database on Ideology, Money in Politics, and Elections, https://data.stanford.edu/dime

## Public data not included

Three public datasets are omitted because of their size. Download them and place them at the indicated paths:

1. **CCES common content 2010-2020** (`data/CCES/raw/cces2010.dta` ... `cces2020.dta`): from the CCES Dataverse (https://cces.gov.harvard.edu). Keep the original variable names; `data_construction/09_creates_CongDistricts.do` and `10_cleans_CCES.do` list the variables used from each year.
2. **DIME recipients file** (`data/dime/dime_recipients_1979_2024.csv`): from https://data.stanford.edu/dime. The columns used are `cycle`, `lname`, `ffname`, `fname`, `party`, `state`, `seat`, `district`, `Cand.ID`, `FEC.ID`, `NID`, `ICPSR2`.
3. The processed CCES analysis file `data/CCES/CCES_final.dta` is also omitted (320 MB); it is reproduced by the scripts above from item 1 and the included acquisition panel.

# Sources for Proprietary Data Sets

Three proprietary data sets are used in the paper. The scripts that read them are listed; their derived station-by-month aggregates and analysis files are not redistributed, in keeping with the data providers' terms.

1. **Nielsen Ad Intel.** Advertising occurrences (duration, estimated spending) and impressions for local TV, 2010-2019. Used to construct all advertising and viewership outcomes, the baseline station controls, and the analytical sample. Required by `data_construction/06_cleans_adintel_data.do`, `07_gets_stations_baseline_characteristics_2010.do` and `analysis/predict_acquisitions.R` and, through their outputs, by every other analysis script except `donations.R`. We accessed the data through the Nielsen Datasets at the Kilts Center for Marketing, University of Chicago Booth School of Business: https://www.chicagobooth.edu/research/kilts/research-data/nielsen. Researchers at subscribing institutions can request access through their institution's Kilts contact; others should contact the Kilts Center at the address on that page. The station-by-month aggregation of the raw Ad Intel files (producing `data/adintel/adintel_clean_yearmonth.csv`) was run on the Kilts-licensed copy of the data and follows the definitions in Appendix E of the manuscript.

2. **TVEyes local TV news transcripts.** Closed-caption transcripts of all local newscasts, January 2013-December 2019, archived by Harmony Labs. Used to construct the local-coverage outcomes (mentions of local places and politicians). Required by `data_construction/05_cleans_content_data.do` and, through its output, by the content tables and figures. Transcripts can be licensed directly from TVEyes (https://www.tveyes.com) or accessed through Harmony Labs (https://harmonylabs.org), which makes the archive available to academic researchers. The mention counts (producing `data/harmony/harmony_mentions_station_month.csv` and `harmony_mentions_station_cong_district_month.csv`) were computed on Harmony Labs' infrastructure as described in Appendix E; the lists of place and politician names used are drawn from the sources cited there (Census place and county names; Warshaw's mayoral candidate list; Follow the Money state legislative candidate filings; DIME US House candidates).

3. **BIA/Kelsey Media Access Pro.** Yearly station affiliation, market, and owner, 2009-2017, used to define the sample of Big Four affiliates and the set of stations owned by each group at baseline. Required by `data_construction/01_gets_fccids_for_scraping.do` and `04_creates_acquisition_panel_top3.do`; their outputs (the acquisition panels) are included, so no downstream script needs this file. Contact BIA Advisory Services (https://www.bia.com) for licensing.

# Data dictionary

Variable-level documentation for every dataset in the archive follows, generated from the files' variable names and labels. Datasets that are not included are documented as well, so that a replicator with access to the proprietary sources can check that the reconstructed files match. Monthly dates are Stata `%tm` integers (months since January 1960; 600 = January 2010). `stationID` is a sequential ID generated from the FCC facility ID `fccid`; `dmacode` is the Nielsen DMA code.


### `data/acquisitions/callsign_history_cleaned.dta` (841 obs, 4 vars)
- `callsign` [character] 
- `fccid` [numeric] fccID
- `from_ym` [numeric] 
- `to_ym` [numeric] 

### `data/acquisitions/fccidnumbers_for_scraping.dta` (780 obs, 1 vars)
- `fccidnumber` [numeric] FCC ID Number

### `data/acquisitions/acquisition_panel_station_top3_FINAL.dta` (100043 obs, 24 vars)
- `fccid` [numeric] fccID
- `date` [numeric] 
- `callsign` [character] 
- `stationID` [numeric] group(fccid)
- `selling_group` [character] selling_group
- `marketname` [character] Market Name
- `LP_station` [numeric] 
- `dma` [character] dma
- `dmacode` [numeric] DMA
- `station_ownedby_sinclair_LMA` [numeric] Post-Acquisition, Sinclair
- `station_ownedby_gray_LMA` [numeric] Post-Acquisition, Gray
- `station_ownedby_nexstar_LMA` [numeric] Post-Acquisition, Nexstar
- `station_ownedby_congl_LMA` [numeric] Post-Acquisition
- `station_ownedby_sinclair_SSA` [numeric] Post-Acquisition, Includes SSAs, Sinclair
- `station_ownedby_gray_SSA` [numeric] Post-Acquisition, Includes SSAs, Gray
- `station_ownedby_nexstar_SSA` [numeric] Post-Acquisition, Includes SSAs, Nexstar
- `station_ownedby_congl_SSA` [numeric] Post-Acquisition, Includes SSAs
- `station_ownedby_sinclair_OO` [numeric] Post-Acquisition, O&O Only, Sinclair
- `station_ownedby_gray_OO` [numeric] Post-Acquisition, O&O Only, Gray
- `station_ownedby_nexstar_OO` [numeric] Post-Acquisition, O&O Only, Nexstar
- `station_ownedby_congl_OO` [numeric] Post-Acquisition, O&O Only
- `year` [numeric] 
- `month` [numeric] 
- `divested` [numeric] 

### `data/acquisitions/acquisition_panel_dma_top3_FINAL.dta` (27192 obs, 24 vars)
- `date` [numeric] 
- `dma_kelseybia` [character] Market Name
- `dma` [character] dma
- `dmacode` [numeric] DMA
- `ownedby_sinclair_LMA` [numeric] Post-Acquisition, Sinclair
- `ownedby_nexstar_LMA` [numeric] Post-Acquisition, Nexstar
- `ownedby_gray_LMA` [numeric] Post-Acquisition, Gray
- `ownedby_congl_LMA_nstations` [numeric] Number of Stations Owned
- `ownedby_congl_LMA` [numeric] Post-Acquisition
- `ownedby_sinclair_SSA` [numeric] Post-Acquisition, Includes SSAs, Sinclair
- `ownedby_nexstar_SSA` [numeric] Post-Acquisition, Includes SSAs, Nexstar
- `ownedby_gray_SSA` [numeric] Post-Acquisition, Includes SSAs, Gray
- `ownedby_congl_SSA_nstations` [numeric] Number of Stations Owned, Includes SSAs
- `ownedby_congl_SSA` [numeric] Post-Acquisition, Includes SSAs
- `ownedby_sinclair_OO` [numeric] Post-Acquisition, O&O Only, Sinclair
- `ownedby_nexstar_OO` [numeric] Post-Acquisition, O&O Only, Nexstar
- `ownedby_gray_OO` [numeric] Post-Acquisition, O&O Only, Gray
- `ownedby_congl_OO_nstations` [numeric] Number of Stations Owned, O&O Only
- `ownedby_congl_OO` [numeric] Post-Acquisition, O&O Only
- `ownedby_sinclair_LMA_first` [numeric] Post-Acquisition, Sinclair First
- `ownedby_gray_LMA_first` [numeric] Post-Acquisition, Gray First
- `ownedby_nexstar_LMA_first` [numeric] Post-Acquisition, Nexstar First
- `year` [numeric] 
- `month` [numeric] 

### `data/dma_dmaID_xwalk.dta` (210 obs, 2 vars)
- `dma` [character] Market Name
- `dmaID` [numeric] BIA TV Market ID Number

### `data/DMA_2008_database.dta` (206 obs, 3 vars)
- `_ID` [numeric] 
- `dma` [character] DMA_from_kelseybia
- `dmaID` [numeric] BIA TV Market ID Number

### `data/DMA_2008_coords.dta` (323770 obs, 3 vars)
- `_ID` [numeric] 
- `_X` [numeric] 
- `_Y` [numeric] 

### `data/CCES/cd_dma/cd2dma.dta` (11681 obs, 8 vars)
- `year` [numeric] 
- `state` [character] 
- `cong_district` [character] CD
- `dma` [numeric] DMA
- `votes_cast` [numeric] 
- `votes_cast_dma` [numeric] votes_cast_DMA
- `share_of_dma` [numeric] share_of_DMA
- `candidate_district` [character] 

### `data/CCES/cd_dma/xwalk_state.dta` (53 obs, 2 vars)
- `state` [character] 
- `statefp` [numeric] 

### `data/CCES/working/county_fips2017.dta` (18200 obs, 3 vars)
- `year` [numeric] CCES year
- `caseID` [numeric] Case identifier
- `countyfp17` [character] County of residence

### `data/station_baseline_characteristics_2010_small.dta` (644 obs, 4 vars) -- NOT INCLUDED (derived from proprietary data or too large; see above)
- `stationID` [numeric] group(fccid)
- `log_duration_news_2010` [numeric] 
- `log_spend_news_2010` [numeric] 
- `rating_news_2010` [numeric] 

### `data/harmony/content_cleaned.dta` (60732 obs, 52 vars) -- NOT INCLUDED (derived from proprietary data or too large; see above)
- `date_str` [character] 
- `callsign` [character] 
- `dmacode` [numeric] 
- `n_progs` [numeric] 
- `n_words` [numeric] 
- `mention_place` [numeric] 
- `mention_pol_local` [numeric] 
- `mention_pol_stateleg` [numeric] 
- `mention_pol_national` [numeric] 
- `mention_pol_congress` [numeric] 
- `date` [numeric] 
- `dup` [numeric] 
- `fccid` [numeric] fccID
- `stationID` [numeric] group(fccid)
- `selling_group` [character] selling_group
- `marketname` [character] Market Name
- `LP_station` [numeric] 
- `dma` [character] dma
- `station_ownedby_sinclair_LMA` [numeric] Post-Acquisition, Sinclair
- `station_ownedby_gray_LMA` [numeric] Post-Acquisition, Gray
- `station_ownedby_nexstar_LMA` [numeric] Post-Acquisition, Nexstar
- `station_ownedby_congl_LMA` [numeric] Post-Acquisition
- `station_ownedby_sinclair_SSA` [numeric] Post-Acquisition, Includes SSAs, Sinclair
- `station_ownedby_gray_SSA` [numeric] Post-Acquisition, Includes SSAs, Gray
- `station_ownedby_nexstar_SSA` [numeric] Post-Acquisition, Includes SSAs, Nexstar
- `station_ownedby_congl_SSA` [numeric] Post-Acquisition, Includes SSAs
- `station_ownedby_sinclair_OO` [numeric] Post-Acquisition, O&O Only, Sinclair
- `station_ownedby_gray_OO` [numeric] Post-Acquisition, O&O Only, Gray
- `station_ownedby_nexstar_OO` [numeric] Post-Acquisition, O&O Only, Nexstar
- `station_ownedby_congl_OO` [numeric] Post-Acquisition, O&O Only
- `year` [numeric] 
- `month` [numeric] 
- `divested` [numeric] 
- `missing` [numeric] 
- `zero_mentions` [numeric] 
- `has_zeros` [numeric] 
- `mention_place_pershow` [numeric] Place Mentions by Program
- `mention_place_perword` [numeric] Place Mentions by Word
- `mention_pol_local_pershow` [numeric] 
- `mention_pol_local_perword` [numeric] 
- `mention_pol_stateleg_pershow` [numeric] 
- `mention_pol_stateleg_perword` [numeric] 
- `mention_pol_national_pershow` [numeric] 
- `mention_pol_national_perword` [numeric] 
- `mention_pol_congress_pershow` [numeric] 
- `mention_pol_congress_perword` [numeric] 
- `log_mention_place_pershow` [numeric] Log Place Mentions by Program
- `log_mention_place_perword` [numeric] Log Place Mentions by Word
- `mention_place_pershow_w99` [numeric] 
- `mention_place_perword_w99` [numeric] 
- `mention_pol_congress_pershow_w99` [numeric] 
- `balanced_sample` [numeric] 

### `data/adintel/adintel_clean_updated.dta` (91740 obs, 325 vars) -- NOT INCLUDED (derived from proprietary data or too large; see above)
- `callsign` [character] 
- `marketcode` [numeric] MarketCode
- `periodyearmonth` [character] PeriodYearMonth
- `year` [numeric] 
- `month` [numeric] 
- `date` [numeric] 
- `dup` [numeric] 
- `n_ads_MM_nonnews_ORIG` [numeric] 
- `n_ads_MM_news_ORIG` [numeric] 
- `n_ads_SM_nonnews_ORIG` [numeric] 
- `n_ads_SM_news_ORIG` [numeric] 
- `hh_total_ORIG` [numeric] 
- `hh_f_ORIG` [numeric] 
- `hh_m_ORIG` [numeric] 
- `hh_50_plus_ORIG` [numeric] 
- `hh_lt_50_ORIG` [numeric] 
- `hh_50_plus_f_ORIG` [numeric] 
- `hh_50_plus_m_ORIG` [numeric] 
- `hh_lt_50_f_ORIG` [numeric] 
- `hh_lt_50_m_ORIG` [numeric] 
- `imp_total_MM_nonnews_ORIG` [numeric] 
- `imp_total_MM_news_ORIG` [numeric] 
- `imp_total_SM_nonnews_ORIG` [numeric] 
- `imp_total_SM_news_ORIG` [numeric] 
- `imp_f_MM_nonnews_ORIG` [numeric] 
- `imp_f_MM_news_ORIG` [numeric] 
- `imp_f_SM_nonnews_ORIG` [numeric] 
- `imp_f_SM_news_ORIG` [numeric] 
- `imp_m_MM_nonnews_ORIG` [numeric] 
- `imp_m_MM_news_ORIG` [numeric] 
- `imp_m_SM_nonnews_ORIG` [numeric] 
- `imp_m_SM_news_ORIG` [numeric] 
- `imp_50_plus_MM_nonnews_ORIG` [numeric] 
- `imp_50_plus_MM_news_ORIG` [numeric] 
- `imp_50_plus_SM_nonnews_ORIG` [numeric] 
- `imp_50_plus_SM_news_ORIG` [numeric] 
- `imp_lt_50_MM_nonnews_ORIG` [numeric] 
- `imp_lt_50_MM_news_ORIG` [numeric] 
- `imp_lt_50_SM_nonnews_ORIG` [numeric] 
- `imp_lt_50_SM_news_ORIG` [numeric] 
- `imp_50_plus_f_MM_nonnew_ORIG` [numeric] 
- `imp_50_plus_f_MM_news_ORIG` [numeric] 
- `imp_50_plus_f_SM_nonnews_ORIG` [numeric] 
- `imp_50_plus_f_SM_news_ORIG` [numeric] 
- `imp_50_plus_m_MM_nonnew_ORIG` [numeric] 
- `imp_50_plus_m_MM_news_ORIG` [numeric] 
- `imp_50_plus_m_SM_nonnews_ORIG` [numeric] 
- `imp_50_plus_m_SM_news_ORIG` [numeric] 
- `imp_lt_50_f_MM_nonnews_ORIG` [numeric] 
- `imp_lt_50_f_MM_news_ORIG` [numeric] 
- `imp_lt_50_f_SM_nonnews_ORIG` [numeric] 
- `imp_lt_50_f_SM_news_ORIG` [numeric] 
- `imp_lt_50_m_MM_nonnews_ORIG` [numeric] 
- `imp_lt_50_m_MM_news_ORIG` [numeric] 
- `imp_lt_50_m_SM_nonnews_ORIG` [numeric] 
- `imp_lt_50_m_SM_news_ORIG` [numeric] 
- `cpm_MM_nonnews_ORIG` [numeric] 
- `cpm_MM_news_ORIG` [numeric] 
- `cpm_SM_nonnews_ORIG` [numeric] 
- `cpm_SM_news_ORIG` [numeric] 
- `total_half_hour_MM_nonn_ORIG` [numeric] 
- `total_half_hour_MM_news_ORIG` [numeric] 
- `total_half_hour_SM_nonnews_ORIG` [numeric] 
- `total_half_hour_SM_news_ORIG` [numeric] 
- `total_spend_MM_nonnews_ORIG` [numeric] 
- `total_spend_MM_news_ORIG` [numeric] 
- `total_spend_SM_nonnews_ORIG` [numeric] 
- `total_spend_SM_news_ORIG` [numeric] 
- `total_duration_MM_nonnews_ORIG` [numeric] 
- `total_duration_MM_news_ORIG` [numeric] 
- `total_duration_SM_nonnews_ORIG` [numeric] 
- `total_duration_SM_news_ORIG` [numeric] 
- `tag` [numeric] tag(callsign date)
- `fccid` [numeric] fccID
- `stationID` [numeric] group(fccid)
- `selling_group` [character] selling_group
- `marketname` [character] Market Name
- `LP_station` [numeric] 
- `dma` [character] dma
- `dmacode` [numeric] DMA
- `station_ownedby_sinclair_LMA` [numeric] Post-Acquisition, Sinclair
- `station_ownedby_gray_LMA` [numeric] Post-Acquisition, Gray
- `station_ownedby_nexstar_LMA` [numeric] Post-Acquisition, Nexstar
- `station_ownedby_congl_LMA` [numeric] Post-Acquisition
- `station_ownedby_sinclair_SSA` [numeric] Post-Acquisition, Includes SSAs, Sinclair
- `station_ownedby_gray_SSA` [numeric] Post-Acquisition, Includes SSAs, Gray
- `station_ownedby_nexstar_SSA` [numeric] Post-Acquisition, Includes SSAs, Nexstar
- `station_ownedby_congl_SSA` [numeric] Post-Acquisition, Includes SSAs
- `station_ownedby_sinclair_OO` [numeric] Post-Acquisition, O&O Only, Sinclair
- `station_ownedby_gray_OO` [numeric] Post-Acquisition, O&O Only, Gray
- `station_ownedby_nexstar_OO` [numeric] Post-Acquisition, O&O Only, Nexstar
- `station_ownedby_congl_OO` [numeric] Post-Acquisition, O&O Only
- `divested` [numeric] 
- `n_ads_news_ORIG` [numeric] 
- `n_ads_nonnews_ORIG` [numeric] 
- `total_duration_news_ORIG` [numeric] 
- `total_spend_news_ORIG` [numeric] 
- `total_duration_nonnews_ORIG` [numeric] 
- `total_spend_nonnews_ORIG` [numeric] 
- `share_duration_MM_news` [numeric] 
- `share_duration_MM_nonnews` [numeric] 
- `imp_total_news_ORIG` [numeric] 
- `imp_total_nonnews_ORIG` [numeric] 
- `imp_f_news_ORIG` [numeric] 
- `imp_m_news_ORIG` [numeric] 
- `imp_50_plus_news_ORIG` [numeric] 
- `imp_lt_50_news_ORIG` [numeric] 
- `total_half_hour_news_ORIG` [numeric] 
- `total_half_hour_nonnews_ORIG` [numeric] 
- `spend_perHH_nonnews_ORIG` [numeric] 
- `spend_perHH_MM_nonnews_ORIG` [numeric] 
- `spend_perHH_SM_nonnews_ORIG` [numeric] 
- `duration_perHH_nonnews_ORIG` [numeric] 
- `duration_perHH_MM_nonnews_ORIG` [numeric] 
- `duration_perHH_SM_nonnews_ORIG` [numeric] 
- `spend_perHH_news_ORIG` [numeric] 
- `spend_perHH_MM_news_ORIG` [numeric] 
- `spend_perHH_SM_news_ORIG` [numeric] 
- `duration_perHH_news_ORIG` [numeric] 
- `duration_perHH_MM_news_ORIG` [numeric] 
- `duration_perHH_SM_news_ORIG` [numeric] 
- `sweep_month` [numeric] 
- `nonmissing_nonsweep_month` [numeric] 
- `missing_nonsweep_month` [numeric] 
- `missing` [numeric] 
- `preperiod` [numeric] 
- `N` [numeric] 
- `spell` [numeric] 
- `N_missing_months_in_spell` [numeric] 
- `total_duration_MM_nonnews` [numeric] 
- `total_duration_MM_news` [numeric] 
- `total_duration_SM_nonnews` [numeric] 
- `total_duration_SM_news` [numeric] 
- `total_duration_news` [numeric] 
- `total_duration_nonnews` [numeric] 
- `total_spend_MM_nonnews` [numeric] 
- `total_spend_MM_news` [numeric] 
- `total_spend_SM_nonnews` [numeric] 
- `total_spend_SM_news` [numeric] 
- `total_spend_news` [numeric] 
- `total_spend_nonnews` [numeric] 
- `n_ads_MM_nonnews` [numeric] 
- `n_ads_MM_news` [numeric] 
- `n_ads_SM_nonnews` [numeric] 
- `n_ads_SM_news` [numeric] 
- `n_ads_news` [numeric] 
- `n_ads_nonnews` [numeric] 
- `total_half_hour_MM_nonn` [numeric] 
- `total_half_hour_MM_news` [numeric] 
- `total_half_hour_SM_nonnews` [numeric] 
- `total_half_hour_SM_news` [numeric] 
- `total_half_hour_news` [numeric] 
- `total_half_hour_nonnews` [numeric] 
- `spend_perHH_nonnews` [numeric] 
- `spend_perHH_MM_nonnews` [numeric] 
- `spend_perHH_SM_nonnews` [numeric] 
- `spend_perHH_news` [numeric] 
- `spend_perHH_MM_news` [numeric] 
- `spend_perHH_SM_news` [numeric] 
- `duration_perHH_nonnews` [numeric] 
- `duration_perHH_MM_nonnews` [numeric] 
- `duration_perHH_SM_nonnews` [numeric] 
- `duration_perHH_news` [numeric] 
- `duration_perHH_MM_news` [numeric] 
- `duration_perHH_SM_news` [numeric] 
- `imp_total_MM_nonnews` [numeric] 
- `imp_total_MM_news` [numeric] 
- `imp_total_SM_nonnews` [numeric] 
- `imp_total_SM_news` [numeric] 
- `imp_f_MM_nonnews` [numeric] 
- `imp_f_MM_news` [numeric] 
- `imp_f_SM_nonnews` [numeric] 
- `imp_f_SM_news` [numeric] 
- `imp_m_MM_nonnews` [numeric] 
- `imp_m_MM_news` [numeric] 
- `imp_m_SM_nonnews` [numeric] 
- `imp_m_SM_news` [numeric] 
- `imp_50_plus_MM_nonnews` [numeric] 
- `imp_50_plus_MM_news` [numeric] 
- `imp_50_plus_SM_nonnews` [numeric] 
- `imp_50_plus_SM_news` [numeric] 
- `imp_lt_50_MM_nonnews` [numeric] 
- `imp_lt_50_MM_news` [numeric] 
- `imp_lt_50_SM_nonnews` [numeric] 
- `imp_lt_50_SM_news` [numeric] 
- `imp_50_plus_f_MM_nonnew` [numeric] 
- `imp_50_plus_f_MM_news` [numeric] 
- `imp_50_plus_f_SM_nonnews` [numeric] 
- `imp_50_plus_f_SM_news` [numeric] 
- `imp_50_plus_m_MM_nonnew` [numeric] 
- `imp_50_plus_m_MM_news` [numeric] 
- `imp_50_plus_m_SM_nonnews` [numeric] 
- `imp_50_plus_m_SM_news` [numeric] 
- `imp_lt_50_f_MM_nonnews` [numeric] 
- `imp_lt_50_f_MM_news` [numeric] 
- `imp_lt_50_f_SM_nonnews` [numeric] 
- `imp_lt_50_f_SM_news` [numeric] 
- `imp_lt_50_m_MM_nonnews` [numeric] 
- `imp_lt_50_m_MM_news` [numeric] 
- `imp_lt_50_m_SM_nonnews` [numeric] 
- `imp_lt_50_m_SM_news` [numeric] 
- `imp_total_news` [numeric] 
- `imp_total_nonnews` [numeric] 
- `imp_f_news` [numeric] 
- `imp_m_news` [numeric] 
- `imp_50_plus_news` [numeric] 
- `imp_lt_50_news` [numeric] 
- `hh_total` [numeric] 
- `hh_f` [numeric] 
- `hh_m` [numeric] 
- `hh_50_plus` [numeric] 
- `hh_lt_50` [numeric] 
- `hh_50_plus_f` [numeric] 
- `hh_50_plus_m` [numeric] 
- `hh_lt_50_f` [numeric] 
- `temp` [numeric] Interpolation of hh_lt_50_m_ORIG on date
- `hh_lt_50_m` [numeric] 
- `rating_total_nonnews` [numeric] 
- `rating_total_MM_nonnews` [numeric] 
- `rating_total_SM_nonnews` [numeric] 
- `rating_total_news` [numeric] 
- `rating_total_MM_news` [numeric] 
- `rating_total_SM_news` [numeric] 
- `rating_f_news` [numeric] 
- `rating_m_news` [numeric] 
- `rating_50_plus_news` [numeric] 
- `rating_lt_50_news` [numeric] 
- `cpm_nonnews` [numeric] 
- `cpm_MM_nonnews` [numeric] 
- `cpm_SM_nonnews` [numeric] 
- `cpm_news` [numeric] 
- `cpm_MM_news` [numeric] 
- `cpm_SM_news` [numeric] 
- `log_n_ads_MM_news` [numeric] 
- `asinh_n_ads_MM_news` [numeric] 
- `log_n_ads_SM_news` [numeric] 
- `asinh_n_ads_SM_news` [numeric] 
- `log_n_ads_news` [numeric] 
- `asinh_n_ads_news` [numeric] 
- `log_n_ads_MM_nonnews` [numeric] 
- `asinh_n_ads_MM_nonnews` [numeric] 
- `log_n_ads_SM_nonnews` [numeric] 
- `asinh_n_ads_SM_nonnews` [numeric] 
- `log_n_ads_nonnews` [numeric] 
- `asinh_n_ads_nonnews` [numeric] 
- `log_total_duration_MM_nonnews` [numeric] 
- `asinh_total_duration_MM_nonnews` [numeric] 
- `log_total_duration_SM_nonnews` [numeric] 
- `asinh_total_duration_SM_nonnews` [numeric] 
- `log_total_duration_nonnews` [numeric] 
- `asinh_total_duration_nonnews` [numeric] 
- `log_total_duration_MM_news` [numeric] 
- `asinh_total_duration_MM_news` [numeric] 
- `log_total_duration_SM_news` [numeric] 
- `asinh_total_duration_SM_news` [numeric] 
- `log_total_duration_news` [numeric] 
- `asinh_total_duration_news` [numeric] 
- `log_total_spend_MM_news` [numeric] 
- `asinh_total_spend_MM_news` [numeric] 
- `log_total_spend_SM_news` [numeric] 
- `asinh_total_spend_SM_news` [numeric] 
- `log_total_spend_news` [numeric] 
- `asinh_total_spend_news` [numeric] 
- `log_total_spend_MM_nonnews` [numeric] 
- `asinh_total_spend_MM_nonnews` [numeric] 
- `log_total_spend_SM_nonnews` [numeric] 
- `asinh_total_spend_SM_nonnews` [numeric] 
- `log_total_spend_nonnews` [numeric] 
- `asinh_total_spend_nonnews` [numeric] 
- `log_imp_total_MM_news` [numeric] 
- `asinh_imp_total_MM_news` [numeric] 
- `log_imp_total_SM_news` [numeric] 
- `asinh_imp_total_SM_news` [numeric] 
- `log_imp_total_news` [numeric] 
- `asinh_imp_total_news` [numeric] 
- `log_imp_f_news` [numeric] 
- `asinh_imp_f_news` [numeric] 
- `log_imp_m_news` [numeric] 
- `asinh_imp_m_news` [numeric] 
- `log_imp_50_plus_news` [numeric] 
- `asinh_imp_50_plus_news` [numeric] 
- `log_imp_lt_50_news` [numeric] 
- `asinh_imp_lt_50_news` [numeric] 
- `log_imp_total_MM_nonnews` [numeric] 
- `asinh_imp_total_MM_nonnews` [numeric] 
- `log_imp_total_SM_nonnews` [numeric] 
- `asinh_imp_total_SM_nonnews` [numeric] 
- `log_imp_total_nonnews` [numeric] 
- `asinh_imp_total_nonnews` [numeric] 
- `log_cpm_nonnews` [numeric] 
- `asinh_cpm_nonnews` [numeric] 
- `log_cpm_MM_nonnews` [numeric] 
- `asinh_cpm_MM_nonnews` [numeric] 
- `log_cpm_SM_nonnews` [numeric] 
- `asinh_cpm_SM_nonnews` [numeric] 
- `log_cpm_news` [numeric] 
- `asinh_cpm_news` [numeric] 
- `log_cpm_MM_news` [numeric] 
- `asinh_cpm_MM_news` [numeric] 
- `log_cpm_SM_news` [numeric] 
- `asinh_cpm_SM_news` [numeric] 
- `log_duration_perHH_nonnews` [numeric] 
- `asinh_duration_perHH_nonnews` [numeric] 
- `log_duration_perHH_MM_nonnews` [numeric] 
- `asinh_duration_perHH_MM_nonnews` [numeric] 
- `log_duration_perHH_SM_nonnews` [numeric] 
- `asinh_duration_perHH_SM_nonnews` [numeric] 
- `log_duration_perHH_news` [numeric] 
- `asinh_duration_perHH_news` [numeric] 
- `log_duration_perHH_MM_news` [numeric] 
- `asinh_duration_perHH_MM_news` [numeric] 
- `log_duration_perHH_SM_news` [numeric] 
- `asinh_duration_perHH_SM_news` [numeric] 
- `log_spend_perHH_nonnews` [numeric] 
- `asinh_spend_perHH_nonnews` [numeric] 
- `log_spend_perHH_MM_nonnews` [numeric] 
- `asinh_spend_perHH_MM_nonnews` [numeric] 
- `log_spend_perHH_SM_nonnews` [numeric] 
- `asinh_spend_perHH_SM_nonnews` [numeric] 
- `log_spend_perHH_news` [numeric] 
- `asinh_spend_perHH_news` [numeric] 
- `log_spend_perHH_MM_news` [numeric] 
- `asinh_spend_perHH_MM_news` [numeric] 
- `log_spend_perHH_SM_news` [numeric] 
- `asinh_spend_perHH_SM_news` [numeric] 

### `data/CCES/CCES_final.dta` (434782 obs, 112 vars) -- NOT INCLUDED (derived from proprietary data or too large; see above)
- `caseID` [numeric] Case ID
- `common_weights` [numeric] Common Content Weights
- `watch_news_type` [haven_labelled] Did you watch local news, national news, or both?
- `read_np_type` [haven_labelled] Did you read a print newspaper, an online newspaper, or both?
- `media_use_blog` [haven_labelled] Media Use - Blog
- `media_use_TV` [haven_labelled] Media Use - TV
- `media_use_NP` [haven_labelled] Media Use - Newspaper
- `media_use_radio` [haven_labelled] Media Use - Radio
- `media_use_none` [haven_labelled] Media Use - None
- `governor_approval` [haven_labelled] Institution Approval - Governor
- `know_house` [haven_labelled] Party of Government Knowledge - Reps
- `know_senate` [haven_labelled] Party of Government Knowledge - Senate
- `know_state_senate` [haven_labelled] Party of Government Knowledge - State Senate
- `know_lower_chamber` [haven_labelled] Party of Government Knowledge - Lower Chamber
- `recog_governor_party` [haven_labelled] Party Recall + Name Recognition - Governor
- `recog_senator1_party` [haven_labelled] Party Recall + Name Recognition - Senator 1
- `recog_senator2_party` [haven_labelled] Party Recall + Name Recognition - Senator 2
- `recog_houserep_party` [haven_labelled] Party Recall + Name Recognition - Rep
- `housemember_approval` [haven_labelled] Approve of Job - Rep
- `vote_last_election` [haven_labelled] Vote President
- `imm_increase_border` [haven_labelled] Increase border security
- `ideo_self` [haven_labelled] Ideology - Yourself
- `ideo_dem` [haven_labelled] Ideology - Dem party
- `ideo_rep` [haven_labelled] Ideology - Rep party
- `voting_intention` [haven_labelled] Presidential voting intentions in the current year
- `house_preference` [haven_labelled] U.S. House of Representatives preference
- `birthyr` [haven_labelled] In what year were you born?
- `gender_male` [haven_labelled] Gender
- `employment` [haven_labelled] Employment Status
- `race` [haven_labelled] Race
- `education` [haven_labelled] Education
- `marital_status` [haven_labelled] Marital Status
- `fam_income` [haven_labelled] Family Income
- `own_home` [haven_labelled] Home ownership
- `fips` [character] County FIPS code
- `statefips` [character] State FIPS code
- `house_voting` [haven_labelled] House vote
- `year` [numeric] Year
- `age` [numeric] Age
- `s_fam_income` [character] Family income
- `media_use_SM` [haven_labelled] Media Use - Social Media
- `zipcode` [character] lookupzip
- `interview_start` [Date] 
- `interview_end` [Date] 
- `employed` [haven_labelled] dummy employment status - employed
- `unemployed` [haven_labelled] dummy employment status - unemployed
- `retired` [haven_labelled] dummy employment status - retired
- `employ_other` [haven_labelled] dummy employment other
- `married` [haven_labelled] dummy marital status - MARRIED
- `ownerhome` [haven_labelled] dummy own home - you own the home
- `race_white` [haven_labelled] race==White
- `race_black` [haven_labelled] race==Black
- `race_hispanic` [haven_labelled] race==Hispanic
- `race_asian` [haven_labelled] race==Asian
- `race_others` [haven_labelled] dummy other races different from the listed above
- `correct_fam_income` [haven_labelled] Family income in correct categories
- `income_high` [numeric] 
- `college_grad` [numeric] 
- `watch_news_type_local` [haven_labelled] watch_news_type==Local Newscast
- `watch_news_type_national` [haven_labelled] watch_news_type==National Newscast
- `watch_news_type_both` [haven_labelled] watch_news_type==Both
- `dontknow_approval_housemember` [numeric] do not know or never heard member of congress
- `no_prefencehouse` [numeric] not sure about preference for the house
- `governor_approval_dummy` [numeric] dummy governor approval, Not Sure=1, other=0
- `s_governor_approval` [character] Institution Approval - Governor
- `s_recog_governor_party` [character] Party Recall + Name Recognition - Governor
- `s_recog_senator1_party` [character] Party Recall + Name Recognition - Senator 1
- `s_recog_senator2_party` [character] Party Recall + Name Recognition - Senator 2
- `s_recog_houserep_party` [character] Party Recall + Name Recognition - Rep
- `recog_governor_never_heard` [numeric] dummy recognize governor name & which party? ans. Never Heard of Person
- `recog_senator1_never_heard` [numeric] dummy recognize senator1 name & which party? ans. Never Heard of Person
- `recog_senator2_never_heard` [numeric] dummy recognize senator2 name & which party? ans. Never Heard of Person
- `recog_houserep_never_heard` [numeric] dummy recognize houserep name & which party? ans. Never Heard of Person
- `recog_houserep_never_heardbroad` [numeric] dummy recognize houserep name & which party? ans. Never Heard of Person and Not
- `cd` [character] Congressional district
- `countyfp` [character] County FIPS code
- `cong_district_add` [character] Second Congressional District
- `same_CD` [numeric] Same CD dummy (0=diff in transition years)
- `atlarge_fix` [numeric] 
- `dma` [character] DMA
- `share_of_dma` [numeric] (mean) share_of_dma
- `merge_indicator` [haven_labelled] 1239999
- `dma_name` [character] DMA NAME
- `dmacode` [numeric] 
- `cdID` [numeric] group(cd)
- `tag` [numeric] tag(cdID)
- `above_median` [numeric] 
- `top_75_congruence` [numeric] 
- `repondents` [numeric] 
- `respondents_weight` [numeric] 
- `date` [numeric] 
- `dma_kelseybia` [character] Market Name
- `ownedby_sinclair_LMA` [numeric] Post-Acquisition, Sinclair
- `ownedby_nexstar_LMA` [numeric] Post-Acquisition, Nexstar
- `ownedby_gray_LMA` [numeric] Post-Acquisition, Gray
- `ownedby_congl_LMA_nstations` [numeric] Number of Stations Owned
- `ownedby_congl_LMA` [numeric] Post-Acquisition
- `ownedby_sinclair_SSA` [numeric] Post-Acquisition, Includes SSAs, Sinclair
- `ownedby_nexstar_SSA` [numeric] Post-Acquisition, Includes SSAs, Nexstar
- `ownedby_gray_SSA` [numeric] Post-Acquisition, Includes SSAs, Gray
- `ownedby_congl_SSA_nstations` [numeric] Number of Stations Owned, Includes SSAs
- `ownedby_congl_SSA` [numeric] Post-Acquisition, Includes SSAs
- `ownedby_sinclair_OO` [numeric] Post-Acquisition, O&O Only, Sinclair
- `ownedby_nexstar_OO` [numeric] Post-Acquisition, O&O Only, Nexstar
- `ownedby_gray_OO` [numeric] Post-Acquisition, O&O Only, Gray
- `ownedby_congl_OO_nstations` [numeric] Number of Stations Owned, O&O Only
- `ownedby_congl_OO` [numeric] Post-Acquisition, O&O Only
- `ownedby_sinclair_LMA_first` [numeric] Post-Acquisition, Sinclair First
- `ownedby_gray_LMA_first` [numeric] Post-Acquisition, Gray First
- `ownedby_nexstar_LMA_first` [numeric] Post-Acquisition, Nexstar First
- `month` [numeric] 
- `redistricting` [numeric] 

### `data/acquisitions/callsigns_history.csv` (1946 rows)
`V1`, `callsign`, `from_date`, `fccID`

### `data/tv/dmacodes.csv` (210 rows)
`Market`, `DMA`

### `data/harmony/harmony_callsigns.csv` (914 rows)
`callsign`

### `data/CCES/cd_dma/DMA-zip.csv` (41535 rows)
`FIPS`, `COUNTY`, `ST`, `DMA CODE`, `DMA NAME`, `ZIPCODE`

### `data/geo/dma_demos.csv` (210 rows)
`DMA`, `H7V001`, `H7W002`, `H7W005`, `H7X002`, `H7X003`, `H7X004`, `H7X005`, `H7X006`, `IFE001`, `IFE002`, `IFE003`, `JLZE001`, `JLZE002`, `JLZE026`, `JM2E001`, `JM2E002`, `JM2E003`, `JM2E004`, `JM2E005`, `JM2E006`, `JM2E007`, `JM2E008`, `JM2E009`, `JM2E010`, `JM2E011`, `JM2E012`, `JM2E013`, `JM5E001`, `JM5E002`, `JM5E003`, `JM5E004`, `JM5E005`, `JM5E006`, `JM5E007`, `JM5E008`, `JM5E009`, `JN9E001`, `JN9E002`, `JN9E003`, `JN9E004`, `JN9E005`, `JN9E006`, `JN9E007`, `JN9E008`, `JN9E009`, `JN9E010`, `JN9E011`, `JN9E012`, `JN9E013`, `JN9E014`, `JN9E015`, `JN9E016`, `JN9E017`, `JN9E018`, `JN9E019`, `JN9E020`, `JN9E021`, `JN9E022`, `JN9E023`, `JN9E024`, `JN9E025`, `JN9E026`, `JN9E027`, `JN9E028`, `JN9E029`, `JN9E030`, `JN9E031`, `JN9E032`, `JN9E033`, `JN9E034`, `JN9E035`, `JOCE001`, `JOCE002`, `JOCE003`, `JOCE004`, `JOCE005`, `JOCE006`, `JOCE007`, `JOCE008`, `JRKE001`, `JRKE002`, `JRKE003`, `JOIE001`, `JQBE001`, `JS5E001`, `JTIE001`, `male_16_over`, `female_16_over`, `male_not_labor`, `female_not_labor`, `gini`, `totalvotes`, `democrat`, `republican`, `other`, `d_vote`, `r_vote`, `o_vote`, `price_per_imp`, `num_stations`, `total_circ_pc_2010`

### `data/geo/census/census_vars.csv` (259 rows)
`var`, `definition`

### `data/donations/ind_donations.csv` (414 rows)
`contributor_first_name`, `contributor_middle_name`, `contributor_last_name`, `committee_id`, `committee_name`, `year`, `contribution_receipt_amount`, `network`

### `data/donations/sinclair_pac.csv` (128 rows)
`committee_id`, `committee_name`, `report_year`, `report_type`, `image_number`, `filing_form`, `link_id`, `line_number`, `transaction_id`, `file_number`, `entity_type`, `entity_type_desc`, `unused_recipient_committee_id`, `recipient_committee_id`, `recipient_name`, `recipient_city`, `recipient_state`, `recipient_zip`, `beneficiary_committee_name`, `national_committee_nonfederal_account`, `disbursement_type`, `disbursement_type_description`, `disbursement_description`, `disbursement_purpose_category`, `memo_code`, `memo_code_full`, `memo_text`, `disbursement_date`, `disbursement_amount`, `candidate_office`, `candidate_office_description`, `candidate_office_district`, `candidate_id`, `candidate_name`, `candidate_first_name`, `candidate_last_name`, `candidate_middle_name`, `candidate_prefix`, `candidate_suffix`, `candidate_office_state`, `candidate_office_state_full`, `election_type`, `election_type_full`, `fec_election_type_desc`, `fec_election_year`, `two_year_transaction_period`, `amendment_indicator`, `amendment_indicator_desc`, `schedule_type`, `schedule_type_full`, `load_date`, `sub_id`, `original_sub_id`, `back_reference_transaction_id`, `back_reference_schedule_id`, `semi_annual_bundled_refund`, `pdf_url`, `line_number_label`, `payee_last_name`, `payee_first_name`, `payee_middle_name`, `payee_prefix`, `payee_suffix`, `payee_employer`, `payee_occupation`, `category_code`, `category_code_full`, `conduit_committee_name`, `conduit_committee_street1`, `conduit_committee_street2`, `conduit_committee_city`, `conduit_committee_state`, `conduit_committee_zip`, `ref_disp_excess_flg`, `comm_dt`, `spender_committee_type`, `spender_committee_org_type`, `spender_committee_designation`

### `data/donations/nexstar_pac.csv` (378 rows)
`committee_id`, `committee_name`, `report_year`, `report_type`, `image_number`, `filing_form`, `link_id`, `line_number`, `transaction_id`, `file_number`, `entity_type`, `entity_type_desc`, `unused_recipient_committee_id`, `recipient_committee_id`, `recipient_name`, `recipient_city`, `recipient_state`, `recipient_zip`, `beneficiary_committee_name`, `national_committee_nonfederal_account`, `disbursement_type`, `disbursement_type_description`, `disbursement_description`, `disbursement_purpose_category`, `memo_code`, `memo_code_full`, `memo_text`, `disbursement_date`, `disbursement_amount`, `candidate_office`, `candidate_office_description`, `candidate_office_district`, `candidate_id`, `candidate_name`, `candidate_first_name`, `candidate_last_name`, `candidate_middle_name`, `candidate_prefix`, `candidate_suffix`, `candidate_office_state`, `candidate_office_state_full`, `election_type`, `election_type_full`, `fec_election_type_desc`, `fec_election_year`, `two_year_transaction_period`, `amendment_indicator`, `amendment_indicator_desc`, `schedule_type`, `schedule_type_full`, `load_date`, `sub_id`, `original_sub_id`, `back_reference_transaction_id`, `back_reference_schedule_id`, `semi_annual_bundled_refund`, `pdf_url`, `line_number_label`, `payee_last_name`, `payee_first_name`, `payee_middle_name`, `payee_prefix`, `payee_suffix`, `payee_employer`, `payee_occupation`, `category_code`, `category_code_full`, `conduit_committee_name`, `conduit_committee_street1`, `conduit_committee_street2`, `conduit_committee_city`, `conduit_committee_state`, `conduit_committee_zip`, `ref_disp_excess_flg`, `comm_dt`, `spender_committee_type`, `spender_committee_org_type`, `spender_committee_designation`

### `data/donations/sinclair_check.csv` (305 rows)
`committee_name...1`, `committee_name...2`, `entity_type`, `entity_type_desc`, `unused_contbr_id`, `drop`, `contributor_prefix`, `contributor_name`, `recipient_committee_type`, `recipient_committee_org_type`, `recipient_committee_designation`, `contributor_first_name`, `contributor_middle_name`, `contributor_last_name`, `contributor_suffix`, `contributor_street_1`, `contributor_street_2`, `contributor_city`, `contributor_state`, `contributor_zip`, `contributor_employer`, `contributor_occupation`, `contributor_id`, `is_individual`, `receipt_type`, `receipt_type_desc`, `receipt_type_full`, `memo_code`, `memo_code_full`, `memo_text`, `contribution_receipt_date`, `contribution_receipt_amount`, `contributor_aggregate_ytd`, `candidate_id`, `candidate_name`, `candidate_first_name`, `candidate_last_name`, `candidate_middle_name`, `candidate_prefix`, `candidate_suffix`, `candidate_office`, `candidate_office_full`, `candidate_office_state`, `candidate_office_state_full`, `candidate_office_district`, `conduit_committee_id`, `conduit_committee_name`, `conduit_committee_street1`, `conduit_committee_street2`, `conduit_committee_city`, `conduit_committee_state`, `conduit_committee_zip`, `donor_committee_name`, `national_committee_nonfederal_account`, `election_type`, `election_type_full`, `fec_election_type_desc`, `fec_election_year`, `two_year_transaction_period`, `amendment_indicator`, `amendment_indicator_desc`, `schedule_type`, `schedule_type_full`, `increased_limit`, `load_date`, `sub_id`, `original_sub_id`, `back_reference_transaction_id`, `back_reference_schedule_name`, `pdf_url`, `line_number_label`, `committee_id`, `report_year`, `report_type`, `image_number`, `filing_form`, `link_id`, `line_number`, `transaction_id`, `file_number`

### `data/donations/sinclair_employers.csv` (453 rows)
`contributor_employer`, `n`, `keep`

### `data/donations/sinclair_messy.csv` (14270 rows)
`committee_name`, `committee_name`, `entity_type`, `entity_type_desc`, `unused_contbr_id`, `contributor_prefix`, `contributor_name`, `recipient_committee_type`, `recipient_committee_org_type`, `recipient_committee_designation`, `contributor_first_name`, `contributor_middle_name`, `contributor_last_name`, `contributor_suffix`, `contributor_street_1`, `contributor_street_2`, `contributor_city`, `contributor_state`, `contributor_zip`, `contributor_employer`, `contributor_occupation`, `contributor_id`, `is_individual`, `receipt_type`, `receipt_type_desc`, `receipt_type_full`, `memo_code`, `memo_code_full`, `memo_text`, `contribution_receipt_date`, `contribution_receipt_amount`, `contributor_aggregate_ytd`, `candidate_id`, `candidate_name`, `candidate_first_name`, `candidate_last_name`, `candidate_middle_name`, `candidate_prefix`, `candidate_suffix`, `candidate_office`, `candidate_office_full`, `candidate_office_state`, `candidate_office_state_full`, `candidate_office_district`, `conduit_committee_id`, `conduit_committee_name`, `conduit_committee_street1`, `conduit_committee_street2`, `conduit_committee_city`, `conduit_committee_state`, `conduit_committee_zip`, `donor_committee_name`, `national_committee_nonfederal_account`, `election_type`, `election_type_full`, `fec_election_type_desc`, `fec_election_year`, `two_year_transaction_period`, `amendment_indicator`, `amendment_indicator_desc`, `schedule_type`, `schedule_type_full`, `increased_limit`, `load_date`, `sub_id`, `original_sub_id`, `back_reference_transaction_id`, `back_reference_schedule_name`, `pdf_url`, `line_number_label`, `committee_id`, `report_year`, `report_type`, `image_number`, `filing_form`, `link_id`, `line_number`, `transaction_id`, `file_number`

### `data/donations/boards/Cleaned_Nexstar_Officers_and_Directors.csv` (233 rows)
`year`, `name`, `title`, `company`

### `data/donations/boards/Updated_Gray_Officers_and_Directors_with_2018.csv` (146 rows)
`name`, `title`, `role`, `year`

### `data/donations/boards/Sinclair_Officers_and_Board__2010_.csv` (18 rows)
`Name`, `Role`, `Year`

### `data/newspapers/circulation_per_capita_2010.csv` (1170 rows)
`state`, `fips`, `total_circ_pc_2010`

### `data/acquisitions/acquisition_dates_03feb2026.xlsx`
- sheet `acquisitions_dates` (325 rows): `fccid`, `station_clean`, `acquiring_group`, `selling_group`, `acq_date`
- sheet `acquisitions_dates_LP_stations` (25 rows): `fccid`, `callsign`, `acquiring_group`, `selling_group`, `acq_date`

### `data/acquisitions/JSA_SSA_LMA_dates_03feb2026.xlsx`
- sheet `Nexstar` (52 rows): `fccid`, `callsign`, `agreement_type`, `start_date`, `end_date`, `owner`, `notes_from_report`, `notes_arianna`
- sheet `Gray` (11 rows): `fccid`, `callsign`, `LP`, `agreement_type`, `start_date`, `end_date`, `owner`, `notes_from_report`, `notes_arianna`
- sheet `Raycom` (8 rows): `fccid`, `callsign`, `LP`, `agreement_type`, `start_date`, `end_date`, `owner`, `notes_from_report`, `notes_arianna`, `source`
- sheet `Sinclair` (72 rows): `fccid`, `callsign`, `agreement_type`, `start_date`, `end_date`, `owner`, `notes_from_report`, `notes_arianna`, `note_main_file`
- sheet `MediaGen` (11 rows): `fccid`, `callsign`, `LP`, `agreement_type`, `start_date`, `end_date`, `owner`, `notes_from_report`, `notes_arianna`
- sheet `LIN` (9 rows): `fccid`, `callsign`, `LP`, `agreement_type`, `start_date`, `end_date`, `owner`, `notes_from_report`, `notes_arianna`, `...10`
- sheet `Full` (160 rows): `fccid`, `callsign`, `agreement_type`, `start_date`, `end_date`, `owner`, `group_providing_services`

### `data/acquisitions/divestitures_03feb2026.xlsx`
- sheet `Sheet1` (96 rows): `Group`, `Station`, `Purchased`, `Sold`, `Notes`

### `data/acquisitions/information_LP_stations.xlsx`
- sheet `types` (119 rows): `callsign`, `type`, `keep/drop`
- sheet `LP_stations` (48 rows): `callsign`, `fccid`, `type`, `dma`, `initial_owner`

### `data/tv/dma_names_xwalk.xlsx`
- sheet `Sheet1` (210 rows): `dma`, `marketname`, `DMA_from_DMA2008`

### `data/acquisitions/UofWarwickTVJuly2018.xlsx` -- NOT INCLUDED (licensed BIA/Kelsey data)
One sheet per year 2009-2017; each row is a full-power station with call sign, FCC facility ID, market, network affiliation, and owner.

### `data/adintel/adintel_clean_yearmonth.csv` -- NOT INCLUDED (derived from proprietary Nielsen Ad Intel data)
`callsign`, `MarketCode`, `PeriodYearMonth`, `hh_{total,f,m,50_plus,lt_50,50_plus_f,50_plus_m,lt_50_f,lt_50_m}`, and for each `<adv>` in {`multimarket`, `local`} and `<prog>` in {`news`, `nonnews`}: `imp_<demo>_<adv>_<prog>`, `rating_<demo>_<adv>_<prog>`, `cpm_<adv>_<prog>`, `total_half_hour_<adv>_<prog>`, `total_spend_<adv>_<prog>`, `total_duration_<adv>_<prog>`, `n_ads_<adv>_<prog>`.

### `data/harmony/harmony_mentions_station_month.csv` -- NOT INCLUDED (derived from proprietary TVEyes transcripts)
`date` (YYYY-MM), `callsign`, `dmacode`, `n_progs`, `n_words`, and for each `<m>` in {`place`, `pol_local`, `pol_stateleg`, `pol_national`, `pol_congress`}: `mention_<m>_total`, `mention_<m>_pershow`, `mention_<m>_perword`, `mention_<m>_asinh`.

### `data/harmony/harmony_mentions_station_cong_district_month.csv` -- NOT INCLUDED (derived from proprietary TVEyes transcripts)
`year`, `month`, `dmacode`, `callsign`, `date`, `state`, `district`, `mentions_pol_congress_total`, `mentions_pol_congress_incumbent`, `mentions_pol_congress_challenger`, `n_progs`, `n_words`, `share_of_dma`, `mention_pol_congress_pershow`, `mention_pol_congress_perword`, `mention_pol_congress_asinh`.


### `data/adintel/ads_halfhour_full_cleaned.dta` (90552 obs, 70 vars) -- NOT INCLUDED (derived from proprietary Nielsen Ad Intel data); input to `analysis/predict_acquisitions.R`
- `distributorcode` [numeric] DistributorCode
- `callsign` [character] Abbreviation
- `year` [numeric] 
- `month` [numeric] 
- `other_spending_L` [numeric] 
- `campaign_spending_L` [numeric] 
- `other_duration_L` [numeric] 
- `campaign_duration_L` [numeric] 
- `other_spending_NL` [numeric] 
- `campaign_spending_NL` [numeric] campaign_spending_halfhour_notlocal
- `other_duration_NL` [numeric] 
- `campaign_duration_NL` [numeric] campaign_duration_halfhour_notlocal
- `date` [numeric] 
- `fccid` [numeric] fccID
- `stationID` [numeric] group(fccid)
- `marketname` [character] Market Name
- `LP_station` [numeric] 
- `dma` [character] dma
- `dmacode` [numeric] DMA
- `station_ownedby_sinclair_LMA` [numeric] Post-Acquisition, Sinclair
- `station_ownedby_gray_LMA` [numeric] Post-Acquisition, Gray
- `station_ownedby_nexstar_LMA` [numeric] Post-Acquisition, Nexstar
- `station_ownedby_congl_LMA` [numeric] Post-Acquisition
- `station_ownedby_sinclair_SSA` [numeric] Post-Acquisition, Includes SSAs, Sinclair
- `station_ownedby_gray_SSA` [numeric] Post-Acquisition, Includes SSAs, Gray
- `station_ownedby_nexstar_SSA` [numeric] Post-Acquisition, Includes SSAs, Nexstar
- `station_ownedby_congl_SSA` [numeric] Post-Acquisition, Includes SSAs
- `station_ownedby_sinclair_OO` [numeric] Post-Acquisition, O&O Only, Sinclair
- `station_ownedby_gray_OO` [numeric] Post-Acquisition, O&O Only, Gray
- `station_ownedby_nexstar_OO` [numeric] Post-Acquisition, O&O Only, Nexstar
- `station_ownedby_congl_OO` [numeric] Post-Acquisition, O&O Only
- `missing` [numeric] 
- `total_spending_L` [numeric] 
- `total_spending_NL` [numeric] 
- `log_total_spending_L` [numeric] 
- `log_total_spending_NL` [numeric] 
- `total_duration_L` [numeric] 
- `total_duration_NL` [numeric] 
- `log_total_duration_L` [numeric] 
- `log_total_duration_NL` [numeric] 
- `revenues_per_minute_NL` [numeric] 
- `revenues_per_minute_L` [numeric] 
- `log_revenues_per_minute_NL` [numeric] 
- `log_revenues_per_minute_L` [numeric] 
- `log_1_total_spending_L` [numeric] 
- `asinh_total_spending_L` [numeric] 
- `log_1_other_spending_L` [numeric] 
- `asinh_other_spending_L` [numeric] 
- `log_1_campaign_spending_L` [numeric] 
- `asinh_campaign_spending_L` [numeric] 
- `log_1_total_duration_L` [numeric] 
- `asinh_total_duration_L` [numeric] 
- `log_1_other_duration_L` [numeric] 
- `asinh_other_duration_L` [numeric] 
- `log_1_campaign_duration_L` [numeric] 
- `asinh_campaign_duration_L` [numeric] 
- `log_1_total_spending_NL` [numeric] 
- `asinh_total_spending_NL` [numeric] 
- `log_1_other_spending_NL` [numeric] 
- `asinh_other_spending_NL` [numeric] 
- `log_1_campaign_spending_NL` [numeric] 
- `asinh_campaign_spending_NL` [numeric] 
- `log_1_total_duration_NL` [numeric] 
- `asinh_total_duration_NL` [numeric] 
- `log_1_other_duration_NL` [numeric] 
- `asinh_other_duration_NL` [numeric] 
- `log_1_campaign_duration_NL` [numeric] 
- `asinh_campaign_duration_NL` [numeric] 
- `N` [numeric] 
- `balanced_sample` [numeric] 

### `data/adintel/ads_impression_cleaned.dta` (90552 obs, 71 vars) -- NOT INCLUDED (derived from proprietary Nielsen Ad Intel data); input to `analysis/predict_acquisitions.R`
- `distributorcode` [numeric] DistributorCode
- `callsign` [character] Abbreviation
- `year` [numeric] 
- `month` [numeric] 
- `avg_imp` [numeric] 
- `marketcode` [character] MarketCode
- `tv_temporary` [numeric] 
- `mediatypeid` [character] MediaTypeId
- `distribdesc` [character] DistribDesc
- `publisherid` [character] PublisherID
- `language` [character] Language
- `affiliation` [character] Affiliation
- `genreid` [character] GenreID
- `greater_50` [numeric] 
- `less_50` [numeric] 
- `male_less_50` [numeric] Male_less_50
- `male_greater_50` [numeric] Male_greater_50
- `female_less_50` [numeric] 
- `female_greater_50` [numeric] 
- `date` [numeric] 
- `fccid` [numeric] fccID
- `stationID` [numeric] group(fccid)
- `marketname` [character] Market Name
- `LP_station` [numeric] 
- `dma` [character] dma
- `dmacode` [numeric] DMA
- `station_ownedby_sinclair_LMA` [numeric] Post-Acquisition, Sinclair
- `station_ownedby_gray_LMA` [numeric] Post-Acquisition, Gray
- `station_ownedby_nexstar_LMA` [numeric] Post-Acquisition, Nexstar
- `station_ownedby_congl_LMA` [numeric] Post-Acquisition
- `station_ownedby_sinclair_SSA` [numeric] Post-Acquisition, Includes SSAs, Sinclair
- `station_ownedby_gray_SSA` [numeric] Post-Acquisition, Includes SSAs, Gray
- `station_ownedby_nexstar_SSA` [numeric] Post-Acquisition, Includes SSAs, Nexstar
- `station_ownedby_congl_SSA` [numeric] Post-Acquisition, Includes SSAs
- `station_ownedby_sinclair_OO` [numeric] Post-Acquisition, O&O Only, Sinclair
- `station_ownedby_gray_OO` [numeric] Post-Acquisition, O&O Only, Gray
- `station_ownedby_nexstar_OO` [numeric] Post-Acquisition, O&O Only, Nexstar
- `station_ownedby_congl_OO` [numeric] Post-Acquisition, O&O Only
- `missing` [numeric] 
- `female` [numeric] 
- `male` [numeric] 
- `log_impressions` [numeric] 
- `log_impressions_greater50` [numeric] 
- `log_impressions_less50` [numeric] 
- `log_impressions_greater50F` [numeric] 
- `log_impressions_greater50M` [numeric] 
- `log_impressions_F` [numeric] 
- `log_impressions_M` [numeric] 
- `tv_hh` [numeric] 
- `news_rating` [numeric] 
- `news_ratings_greater50` [numeric] 
- `news_ratings_less50` [numeric] 
- `news_ratings_greater50F` [numeric] 
- `news_ratings_greater50M` [numeric] 
- `news_ratings_F` [numeric] 
- `news_ratings_M` [numeric] 
- `tv_hh_smoothed` [numeric] 
- `news_rating_smoothed` [numeric] 
- `news_ratings_smooth_greater50` [numeric] 
- `news_ratings_smooth_less50` [numeric] 
- `news_ratings_smooth_greater50F` [numeric] 
- `news_ratings_smooth_greater50M` [numeric] 
- `news_ratings_smooth_F` [numeric] 
- `news_ratings_smooth_M` [numeric] 
- `avg_imp_NL` [numeric] 
- `log_impressions_nonnews` [numeric] 
- `nonnews_rating` [numeric] 
- `nonnews_rating_smoothed` [numeric] 
- `balanced_sample` [numeric] 
- `tag_date` [numeric] tag(date)
- `mean` [numeric] 
