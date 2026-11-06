## Predictors of acquisition (Appendix D, "Predictors of Acquisition").
## Part 1: cross-sectional binomial LASSO (glmnet, 10-fold CV with folds stratified on the outcome) of an
##         indicator for acquisition by each group in 2011-2020, among stations not owned by any of the three
##         groups in 2010, followed by unpenalized logit on the selected predictors (plus the three
##         group-presence-at-baseline indicators). Produces figures/lasso_acquisitions.png (Appendix Figure D1).
## Part 2: station-by-semester linear probability models of acquisition among not-yet-acquired stations with
##         DMA and semester fixed effects (fixest). Produces tables/within_market_acquisitions.tex (Appendix
##         Table D1).
##
## Inputs:
##   data/acquisitions/acquisition_panel_station_top3_FINAL.dta   (included)
##   data/geo/dma_demos.csv, data/geo/census/census_vars.csv        (included)
##   data/station_baseline_characteristics_2010.dta                output of data_construction/07_..., 2010 station
##                                                                  means for the 644-station analytical sample
##   data/adintel/adintel_clean_updated.dta                        output of data_construction/06_..., used for 2010
##                                                                  means of cost per mille and impressions
##   (both derived from proprietary Nielsen Ad Intel data and NOT included in the archive)

# PREDICTORS OF ACQUISITION (Table D1 and Figure D1 in Appendix D)
library(lubridate)
library(tidyverse)
library(magrittr)
library(data.table)
library(fixest)
library(haven)
library(glue)
library(glmnet)
library(ggthemes)
library(broom)      # tidy() methods for fixest objects, used for the coefficient plot

###
### PRELIMINARIES AND SETUP
###


### SET WORKING DIRECTORY HERE
path_to_archive <- "/path/to/replication"
setwd(path_to_archive)

datadir <- "data"
figuredir <- "figures"
tabledir <- "tables"

theme_set(theme_few())

Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

read_in_dta <- function(fullpath) {
    fullpath %>%
            read_dta %>%
            setDT ->
    dt

    datecols <- grep("date|yearmonth", colnames(dt))

    dt[, (datecols) := map(.SD, ~ ymd("2010-01-01") + months(. - 600)),
        .SDcols = datecols]
    dt
} 

read_in <- function(f, path = datadir) {
    fullpath <- glue("{path}/{f}")

    if (grepl("\\.dta$", f)) read_function <- read_in_dta
    if (grepl("\\.csv$", f)) read_function <- fread
    if (grepl("\\.rds$", f)) read_function <- readRDS

    read_function(fullpath)
}

make_f <- function(lhs = "", rhs = "1", drop_const = FALSE) {

    collapsed_rhs <- paste(rhs, collapse = " + ")
    if (drop_const) collapsed_rhs <- paste0(collapsed_rhs, " - 1")
    if (collapsed_rhs == "" | collapsed_rhs == " - 1") collapsed_rhs <= "1"

    paste(lhs, collapsed_rhs, sep = " ~ ") %>%
        as.formula
}

stratify_by_D <- function(D, folds){
    treated <- which(D == 1)
    untreated <- which(D == 0)

    f_t <- sample.int(folds, length(treated), replace = TRUE)
    f_u <- sample.int(folds, length(untreated), replace = TRUE)

    folds <- vector(mode = "integer", length = length(D))
    folds[treated] <- f_t
    folds[untreated] <- f_u

    folds
}

expit <- \(x) exp(x)/(1+exp(x))

fitGet <- \(m){
    #' Get cross-fit predictions from LASSO without fitting the model again
    m$fit.preval[,
      !is.na(colSums(m$fit.preval))][,
      m$lambda[!is.na(colSums(m$fit.preval))] == m$lambda.min]
}

### DATASETS

## read station acquisition / ownership data
stations <- read_in("acquisitions/acquisition_panel_station_top3_FINAL.dta")

## read station-level baseline data. Advertising duration, revenue and ratings are the 2010 station means
## produced by data_construction/07_gets_stations_baseline_characteristics_2010.do for the 644-station
## analytical sample (February-December means of per-half-hour ad duration and revenue, logged here, and
## of news / non-news ratings). Cost per mille and impressions are 2010 (February-December) means computed
## from the Ad Intel analysis file for the same stations.
base_station <- read_dta(glue("{datadir}/station_baseline_characteristics_2010.dta")) %>%
    setDT %>%
    .[, .(stationID, callsign,
          log_duration_news = log(duration_perHH_news), log_duration_nonnews = log(duration_perHH_nonnews),
          log_spend_news = log(spend_perHH_news), log_spend_nonnews = log(spend_perHH_nonnews),
          rating_news = rating_total_news, rating_nonnews = rating_total_nonnews)]

base_extra <- read_dta(glue("{datadir}/adintel/adintel_clean_updated.dta"),
        col_select = c("stationID", "dmacode", "year", "month",
                       "cpm_news", "cpm_nonnews", "imp_total_news", "imp_total_nonnews")) %>%
    setDT %>%
    .[year == 2010 & month > 1,
      .(dmacode = first(dmacode),
        cpm_news = mean(cpm_news, na.rm = TRUE), cpm_nonnews = mean(cpm_nonnews, na.rm = TRUE),
        log_imp_news = log(mean(imp_total_news, na.rm = TRUE)), log_imp_nonnews = log(mean(imp_total_nonnews, na.rm = TRUE))),
      by = .(stationID)]

base_station <- base_extra[base_station, on = .(stationID), nomatch = 0]

# rank of news rating in DMA
base_station[, news_rating_rank := rank(rating_news, ties.method = "max"), by = .(dmacode)]
base_station[, paste0("news_rating_rank_", 1:3) := map(1:3, ~ as.numeric(news_rating_rank == .))]
base_station[, news_rating_rank := NULL]

setnames(base_station,
        old = grep("duration|rating|cpm|imp|spend", colnames(base_station)),
        new = function(x) paste0("baseline_", x))

## read DMA level characteristics
dmavars <- read_in("geo/dma_demos.csv")
census_vars <- read_in("geo/census/census_vars.csv")

setnames(dmavars, old = "DMA", new = "dmacode")
setnames(dmavars,
    old = grep("^[A-Z0-9]+$", colnames(dmavars)),
    new = function(n) map_chr(n, ~ census_vars[var == ., definition]) %>%
                      make.names(unique = TRUE) %>%
                      tolower)

## convert some variables to per-capita or per-housing-unit
pc_scale <- c(
    "total.population.for.whom.poverty.status.is.determined",
    "male_16_over",
    "female_16_over",
    "total.population.25.years.and.over",
    "total.workers.16.years.and.over"
)
dmavars[, (pc_scale) := map(.SD, ~ . / total.population), .SDcols = pc_scale]

dmavars[, hu_occupied := total.occupied.housing.units / total.housing.units]
dmavars[, hu_per_capita := total.housing.units / total.population]
dmavars[, hu_per_hh := total.housing.units / total.households]
dmavars[, hh_size := total.households / total.population]
dmavars[, turnout := totalvotes / total.population]

# bin population
dmavars[, pop_bin := bin(total.population, bin = "cut::p10]p20]p30]p40]p50]p60]p70]p80]p90]p100]")]
popbins <- sort(unique(dmavars$pop_bin))
dmavars[, paste0("pop_bin_", 2:10) := map(popbins[2:10], ~ as.numeric(pop_bin == .))]

# bin number of stations
dmavars[, num_stations_eq4 := as.numeric(num_stations == 4)]
dmavars[, num_stations_gt4 := as.numeric(num_stations > 4)]
dmavars[is.na(num_stations_gt4), num_stations_gt4 := 0]
dmavars[is.na(num_stations_eq4), num_stations_eq4 := 0]

# remove collinear variables and non-pop-scaled ones
dmavars[, c("total.households",
            "total.population",
            "pop_bin",
            "pop_bin_1",
            "total.population.1",
            "male.1",
            "female.1",
            "totalvotes",
            "republican",
            "democrat",
            "other",
            "rural",
            "total.housing.units",
            "total.occupied.housing.units",
            "vacant.housing.units",
            "female",
            "x90.or.more.minutes",
            "family.households..other.family",
            "family.households..other.family..female.householder..no.husband.present",
            "nonfamily.households..householder.living.alone",
            "nonfamily.households..householder.not.living.alone",
            "female..doctorate.degree",
            "x2.00.and.over",
            "renter.occupied",
            "o_vote",
            "num_stations") := NULL]
setnames(dmavars, old = grep("minutes", colnames(dmavars)), new = function(x) sub("^x?", "commute.", x))
setnames(dmavars, old = grep("(under\\.\\.50)|(x[0-9.]+to)", colnames(dmavars)), new = function(x) sub("^x?", "povertyline.ratio.", x))

# simplify for interpretability
dmavars[, educ_bachelors := female..bachelor.s.degree +
                                 male..bachelor.s.degree +
                                 female..master.s.degree +
                                 male..master.s.degree +
                                 female..professional.school.degree +
                                 male..professional.school.degree]
dmavars[, educ_somecollege := female..some.college..less.than.1.year +
                              female..some.college..1.or.more.years..no.degree +
                              female..associate.s.degree +
                              male..some.college..less.than.1.year +
                              male..some.college..1.or.more.years..no.degree +
                              male..associate.s.degree]

dmavars[, race_nonwhite := 1 - white.alone]


term_labels <- c(
    baseline_log_imp_news = "2010 Avg. Log Impressions (news)",
    baseline_log_imp_nonnews = "2010 Avg. Log Impressions (non-news)",
    baseline_log_duration_news = "2010 Avg. Log Ad Duration (news)",
    baseline_log_duration_nonnews = "2010 Avg. Log Ad Duration (non-news)",
    baseline_log_spend_news = "2010 Avg. Log Ad Revenue (news)",
    baseline_log_spend_nonnews = "2010 Avg. Log Ad Revenue (non-news)",
    baseline_rating_news = "2010 Avg. Rating (news)",
    baseline_rating_nonnews = "2010 Avg. Rating (non-news)",
    baseline_cpm_news = "2010 Avg. CPM (news)",
    baseline_cpm_nonnews = "2010 Avg. CPM (non-news)",
    baseline_news_rating_rank_1 = "2010 News Ratings Rank in DMA: 1",
    baseline_news_rating_rank_2 = "2010 News Ratings Rank in DMA: 2",
    baseline_news_rating_rank_3 = "2010 News Ratings Rank in DMA: 3",
    black.or.african.american.alone = "Race: Share Black",
    commute.20.to.24.minutes = "Commute Times: Share 20 to 24 minutes",
    commute.25.to.29.minutes = "Commute Times: Share 25 to 29 minutes",
    commute.40.to.44.minutes = "Commute Times: Share 40 to 44 minutes",
    commute.45.to.59.minutes = "Commute Times: Share 45 to 59 minutes",
    commute.less.than.5.minutes = "Commute Times: Share less than 5 minutes",     
    d_vote = "Democratic Pres. Vote Share (2008)",
    turnout = "Voter Turnout (2008)",
    always_treated_gray = "Existing Gray Presence",
    always_treated_nexstar = "Existing Nexstar Presence",
    always_treated_sinclair = "Existing Sinclair Presence",
    previous_gray_acq = "Previous Gray Acquisition in Market",
    previous_nexstar_acq = "Previous Nexstar Acquisition in Market",
    previous_sinclair_acq = "Previous Sinclair Acquisition in Market",
    family.households..married = "Family Structure: Share of Married HH",
    family.households = "Family Structure: Share of Family HH",
    female..associate.s.degree = "Educ: Share Females with Associate Degree",
    female..some.college..1.or.more.years..no.degree = "Educ: Share Females with 1-3yrs College",
    female..some.college..less.than.1.year = "Educ: Share Females with <1yr College",                    
    hu_occupied = "Share of Housing Units Occupied",
    hu_per_capita = "Housing Units per Capita",
    hu_per_hh = "Housing Units per Household",
    male = "Gender: Share Male",
    male..7th.and.8th.grade = "Educ: Share Males with no HS",
    male..no.schooling.completed = "Educ: Share Males with no Schooling Completed",
    male..professional.school.degree = "Educ: Share Males with Prof. Degree",                   
    male..some.college..1.or.more.years..no.degree = "Educ: Share Males with Some College",
    median.value..dollars..owner = "Median Value of Housing Units",    
    num_stations_eq4 = "Exactly 4 Stations in DMA",
    num_stations_gt4 = "More than 4 Stations in DMA",
    per.capita.income.in.the.past.12.months..in.2010.inflation = "Income: Per Capita Income",
    median.household.income.in.the.past.12.months..in.2010.inflation = "Income: Median HH Income",
    pop_bin_2 = "Population Decile: 2",
    pop_bin_3 = "Population Decile: 3",
    pop_bin_4 = "Population Decile: 4",
    pop_bin_5 = "Population Decile: 5",
    pop_bin_6 = "Population Decile: 6",
    pop_bin_7 = "Population Decile: 7",
    pop_bin_8 = "Population Decile: 8",
    pop_bin_9 = "Population Decile: 9",
    pop_bin_10 = "Population Decile: 10",
    povertyline.ratio..50.to..99 = "Poverty: Share Earning 0.5x to 1x Pov. Line",  
    povertyline.ratio.1.25.to.1.49 = "Poverty: Share Earning 1.25x to 1.49x Pov. Line",
    price_per_imp = "Average Price per Ad Impression",
    total.population.25.years.and.over = "Age: Share 25 Years and Over", 
    total.population.for.whom.poverty.status.is.determined = "Poverty: Share with Poverty Status",
    urban = "Urbanity: Share Urban",
    white.alone = "Race: Share White",
    race_nonwhite = "Race: Share Nonwhite",
    owner.occupied = "Share Housing Owner-Occupied",
    hh_size = "Avg. Household Size",
    male_16_over = "Age/Sex: Share Male 16+",
    female_16_over = "Age/Sex: Share Female 16+",
    male_not_labor = "Age/Sex: Share Male Not in Labor Force",
    female_not_labor = "Age/Sex: Share Female Not in Labor Force",
    educ_somecollege = "Education: Share with Some College",
    educ_bachelors = "Education: Share with at least Bachelors Degree",
    gini = "Income: Gini Coefficient",
    semester = "Semester"
)


###
### PART 1: cross-sectional estimate of propensity of being acquired by group G ever in 2010-2020
### conditional on not yet being owned by any group as of 2010
###

## collapse acquisition data to cross-section
stations <- stations[order(stationID, date)]

# indicator for owned by a conglomerate at baseline
stations[,
    always_treated := max(pmax(station_ownedby_gray_LMA[year == 2010],
                          station_ownedby_sinclair_LMA[year == 2010],
                          station_ownedby_nexstar_LMA[year == 2010])),
    by = .(stationID)]
stations[is.infinite(always_treated), always_treated := 0]

# indicator for another conglomerate-owned station at baseline
stations[, dma_always_treated_gray := max(station_ownedby_gray_LMA * always_treated), by = .(dmacode)]
stations[, dma_always_treated_nexstar := max(station_ownedby_nexstar_LMA * always_treated), by = .(dmacode)]
stations[, dma_always_treated_sinclair := max(station_ownedby_sinclair_LMA * always_treated), by = .(dmacode)]

stations_cross <- stations[
    always_treated == 0 & year >= 2011,
    .(
        acquiredby_gray = max(station_ownedby_gray_LMA),
        acquiredby_nexstar = max(station_ownedby_nexstar_LMA),
        acquiredby_sinclair = max(station_ownedby_sinclair_LMA),
        callsign = head(keep(callsign, \(x) str_detect(x, "[A-Z]{3}")), 1)
    ),
    by = .(stationID, dmacode, dma_always_treated_gray, dma_always_treated_nexstar, dma_always_treated_sinclair)
]

stations_cross <- stations_cross %>%
    .[dmavars, on = .(dmacode), nomatch = 0] %>%
    .[base_station, on = .(callsign, stationID, dmacode), nomatch = 0]

## fill a couple of NA's with sample mean
## (glmnet demeans variables prior to estimation)
anymissing <- imap_lgl(stations_cross, ~ any(is.na(.)))
anymissing <- names(anymissing)[which(anymissing)]
stations_cross[, (anymissing) := map(.SD, ~ replace_na(., mean(., na.rm = TRUE))), .SDcols = anymissing]

## variables to include in propensity model
rhs_everything <- c(
    grep("baseline_", colnames(stations_cross), value = TRUE),
    setdiff(colnames(dmavars), "dmacode"),
    grep("existing_", colnames(stations_cross), value = TRUE)
)

rhs_selected <- c(
    paste0("pop_bin_", 2:10),
    "urban", "owner.occupied", "hu_per_capita", "hu_per_hh",
    "median.household.income.in.the.past.12.months..in.2010.inflation", "per.capita.income.in.the.past.12.months..in.2010.inflation", "gini",
    "turnout", "d_vote",
    "educ_somecollege",
    "educ_bachelors",
    "race_nonwhite",
    "family.households", "hh_size",
    "male_16_over", "female_16_over", "male_not_labor", "female_not_labor",
    "price_per_imp",
    "dma_always_treated_gray", "dma_always_treated_nexstar", "dma_always_treated_sinclair",
    "baseline_log_spend_news",
    "baseline_log_spend_nonnews",
    "baseline_log_duration_news",
    "baseline_log_duration_nonnews",
    "baseline_cpm_news",
    "baseline_cpm_nonnews",
    "baseline_rating_news", "baseline_news_rating_rank_1", "baseline_news_rating_rank_2", "baseline_news_rating_rank_3",
    "baseline_rating_nonnews",
    "baseline_log_imp_news",
    "baseline_log_imp_nonnews"
)

# stratify by treatment status for CV
nfolds <- 10

D_gray <- stations_cross$acquiredby_gray
D_sinclair <- stations_cross$acquiredby_sinclair
D_nexstar <- stations_cross$acquiredby_nexstar

## create folds for CV and cross-fitting
set.seed(354684955)
folds_gray <- stratify_by_D(D_gray, nfolds)
folds_sinclair <- stratify_by_D(D_sinclair, nfolds)
folds_nexstar <- stratify_by_D(D_nexstar, nfolds)

## estimate propensity scores
X <- model.matrix(make_f(rhs = rhs_selected), stations_cross)
psfit_gray <- glmnet::cv.glmnet(X, D_gray, family="binomial", alpha=1, keep = TRUE, nfolds = nfolds, foldid = folds_gray)
psfit_sinclair <- glmnet::cv.glmnet(X, D_sinclair, family="binomial", alpha=1, keep = TRUE, nfolds = nfolds, foldid = folds_sinclair)
psfit_nexstar <- glmnet::cv.glmnet(X, D_nexstar, family="binomial", alpha=1, keep = TRUE, nfolds = nfolds, foldid = folds_nexstar)

predict_data = copy(stations_cross)
predict_data[, (rhs_selected) := map(.SD, function(x) (x - mean(x)) / sd(x)), .SDcols = rhs_selected]

post_lasso_cross <- function(lasso, outcome, data, ...) {
    b <- coef(lasso, ...)
    
    rhs <- c(setdiff(rownames(b)[which(b!=0)], "(Intercept)"), "dma_always_treated_gray", "dma_always_treated_nexstar", "dma_always_treated_sinclair") %>% unique

    feglm(make_f(outcome, rhs), data, family = binomial(link = "logit"))
}

acq_lassos_cross <- map2(
    list(psfit_gray, psfit_nexstar, psfit_sinclair),
    c("acquiredby_gray", "acquiredby_nexstar", "acquiredby_sinclair"),
    post_lasso_cross,
    data = predict_data,
    s = "lambda.min"
    )

coefplot_data <- acq_lassos_cross %>%
    map(compose(setDT, tidy)) %>%
    set_names(c("Gray", "Nexstar", "Sinclair")) %>%
    rbindlist(idcol = "Acquirer") %>%
    .[, c("lb", "ub") := .(estimate - 1.96 * std.error, estimate + 1.96 * std.error)] %>%
    .[term != "(Intercept)"] %>%
    .[grep("baseline", term), type := "Station"] %>%
    .[is.na(type), type := "DMA"] %>%
    .[, term := term_labels[term]] %>%
    .[!is.na(term)]

coefplot_data[, term :=
    fct_reorder(term, type, .fun = function(x) head(x,1))]

coefplot_data[, term :=
    fct_relevel(term, "Population Decile: 10", after = which(levels(term) == "Population Decile: 9")-1)]

coefplot_data %>%
    ggplot(aes(x = term, y = estimate, ymin = lb, ymax = ub)) +
    geom_pointrange(aes(group = Acquirer, shape = type, colour = type), size = 1.1) +
    facet_wrap(~ Acquirer) +
    geom_hline(yintercept = 0, linetype = "dashed") +
    labs(x = "Variable", y = "Standardized Coefficient", shape = "Data From", colour = "Data From") +
    coord_flip()
ggsave(filename = glue("{figuredir}/lasso_acquisitions.png"), height = 10, width = 8)



###
### PART 2: time-varying propensity of being acquired by group G
### conditional on not yet being owned by any group
### within-market
###

## collapse acquisition data to 6 months
stations[, semester := floor_date(date, unit = "6 months")]


owncols <- grep("station_ownedby", colnames(stations), value = TRUE)
stations_6mo <- stations[, map(.SD, ~ as.numeric(all(. == 1))),
                           by = .(semester, stationID, dmacode),
                           .SDcols = owncols]
id2call <- stations[, .(callsign = Mode(callsign)), .(stationID, semester)]
stations_6mo <- stations_6mo[id2call, on = .(stationID, semester)]

## indicators for station acquisition
stations_6mo <- stations_6mo[order(stationID, semester)]
stations_6mo[, station_ownedby_gray_LMA_lag := shift(station_ownedby_gray_LMA), by = .(stationID)]
stations_6mo[, station_ownedby_sinclair_LMA_lag := shift(station_ownedby_sinclair_LMA), by = .(stationID)]
stations_6mo[, station_ownedby_nexstar_LMA_lag := shift(station_ownedby_nexstar_LMA), by = .(stationID)]

stations_6mo[, acquiredby_gray := as.numeric(station_ownedby_gray_LMA > station_ownedby_gray_LMA_lag), by = .(stationID)]
stations_6mo[, acquiredby_sinclair := as.numeric(station_ownedby_sinclair_LMA > station_ownedby_sinclair_LMA_lag), by = .(stationID)]
stations_6mo[, acquiredby_nexstar := as.numeric(station_ownedby_nexstar_LMA > station_ownedby_nexstar_LMA_lag), by = .(stationID)]

## construct indicators for other conglomerate-owned station in the DMA
stations_6mo[, previous_gray_acq := as.numeric(any(station_ownedby_gray_LMA_lag == 1)),
             by = .(dmacode, semester)]
stations_6mo[, previous_sinclair_acq := as.numeric(any(station_ownedby_sinclair_LMA_lag == 1)),
             by = .(dmacode, semester)]
stations_6mo[, previous_nexstar_acq := as.numeric(any(station_ownedby_nexstar_LMA_lag == 1)),
             by = .(dmacode, semester)]

stations_6mo[, dma_always_treated_gray := max(station_ownedby_gray_LMA[year(semester) == 2010]), by = .(dmacode)]
stations_6mo[, dma_always_treated_sinclair := max(station_ownedby_sinclair_LMA[year(semester) == 2010]), by = .(dmacode)]
stations_6mo[, dma_always_treated_nexstar := max(station_ownedby_nexstar_LMA[year(semester) == 2010]), by = .(dmacode)]

## merge ownership data w/ baseline and DMA characteristics
stations_6mo <- stations_6mo[base_station, on = .(stationID), nomatch = 0] %>%
    .[dmavars, on = .(dmacode), nomatch = 0]

## data for estimating the propensity score
stations_6mo <- stations_6mo[!is.na(acquiredby_gray)]
notyet_treated <- stations_6mo[
    (acquiredby_gray == 1) |
    (acquiredby_sinclair == 1) |
    (acquiredby_nexstar == 1) |
    (station_ownedby_congl_LMA == 0)]

## fill a couple of NA's with sample mean
## (glmnet demeans variables prior to estimation)
anymissing <- imap_lgl(notyet_treated, ~ any(is.na(.)))
anymissing <- names(anymissing)[which(anymissing)]
notyet_treated[, (anymissing) := map(.SD, ~ replace_na(., mean(., na.rm = TRUE))), .SDcols = anymissing]


## variables to include in propensity model
rhs_everything <- c(
    grep("baseline_", colnames(notyet_treated), value = TRUE),
    setdiff(colnames(dmavars), "dmacode"),
    grep("existing_", colnames(notyet_treated), value = TRUE)
)


# stratify by treatment status for CV
nfolds <- 10

D_gray <- notyet_treated$acquiredby_gray
D_sinclair <- notyet_treated$acquiredby_sinclair
D_nexstar <- notyet_treated$acquiredby_nexstar

## create folds for CV and cross-fitting
set.seed(14891491)
folds_gray <- stratify_by_D(D_gray, nfolds)
folds_sinclair <- stratify_by_D(D_sinclair, nfolds)
folds_nexstar <- stratify_by_D(D_nexstar, nfolds)

## estimate propensity scores
X <- model.matrix(make_f(rhs = rhs_selected, drop_const = TRUE), notyet_treated)
psfit_gray <- glmnet::cv.glmnet(X, D_gray, family="binomial", alpha=1, keep = TRUE, nfolds = nfolds, foldid = folds_gray)
psfit_sinclair <- glmnet::cv.glmnet(X, D_sinclair, family="binomial", alpha=1, keep = TRUE, nfolds = nfolds, foldid = folds_sinclair)
psfit_nexstar <- glmnet::cv.glmnet(X, D_nexstar, family="binomial", alpha=1, keep = TRUE, nfolds = nfolds, foldid = folds_nexstar)

predict_data = copy(notyet_treated)
predict_data[, (rhs_selected) := map(.SD, function(x) (x - mean(x)) / sd(x)), .SDcols = rhs_selected]

post_lasso <- function(lasso, outcome, data, ...) {
    b <- coef(lasso, ...)
    
    rhs <- c(setdiff(rownames(b)[which(b!=0)], "(Intercept)"), "previous_gray_acq", "previous_nexstar_acq", "previous_sinclair_acq") %>% unique

    feglm(make_f(outcome, rhs), data, family = binomial(link = "logit"))
}

acq_lassos <- map2(
    list(psfit_gray, psfit_sinclair, psfit_nexstar),
    c("acquiredby_gray", "acquiredby_sinclair", "acquiredby_nexstar"),
    post_lasso,
    data = predict_data,
    s = "lambda.min"
    )



# within-market version
withincols <- c("baseline_log_duration_news", "baseline_log_duration_nonnews",
                "baseline_log_spend_news", "baseline_log_spend_nonnews",
                "baseline_rating_news", "baseline_rating_nonnews")
setFixest_etable(fitstat = ~ n + r2)

tablestyle  = style.tex(main="aer",
                depvar.title = "Acquirer",
                 fixef.suffix = " FEs",
                 fixef.where ="var",
                 fixef.title = "",
                 stats.title = "\\midrule",
                 tablefoot=F,
                 yesNo="\\checkmark")


## standard errors clustered by DMA (set explicitly: fixest >= 0.13 no longer clusters on the first
## fixed effect by default)
within_acq_all <- feols(c(acquiredby_gray, acquiredby_nexstar, acquiredby_sinclair) ~
        .[withincols]
        + previous_gray_acq + previous_nexstar_acq + previous_sinclair_acq
      | dmacode + semester, data = notyet_treated, vcov = ~ dmacode)

etable(within_acq_all,
    style.tex = tablestyle,
    dict = c(term_labels,
             dmacode = "DMA",
             acquiredby_gray = "Gray",
             acquiredby_nexstar = "Nexstar",
             acquiredby_sinclair = "Sinclair"),
    file = glue("{tabledir}/within_market_acquisitions.tex"),
    replace = TRUE
)
