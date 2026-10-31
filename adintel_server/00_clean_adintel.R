#### read and combine Nielsen Ad Intel ####
library(dplyr)
library(lubridate)
library(arrow)
library(glue)
library(tidyr)
library(data.table)
library(purrr)

# set path to AdIntel data on commandline
basedir <- commandArgs(trailingOnly = TRUE)[1]
if(is.na(basedir)) basedir <- "AdIntel"

years <- 2010:2020

## file stems (without extension) for each dataset
imp_stem <- "Impressions/ImpSpotTV"
tvhh_stem <- "Universe_Estimates/UESpotTV"
occ_stem <- "Occurrences/SpotTV"
brand_stem <- "References/Brand"
station_stem <- "References/Distributor"
prog_stem <- "References/TV Program"

## convert a single TSV to parquet, removing the original TSV
toparquet <- function(tsv_file){
    parquet_name <- sub("[.]tsv$", ".parquet", tsv_file)
    tsv_file %>% fread(fill = TRUE) %>% write_parquet(parquet_name)
    file.remove(tsv_file)
    parquet_name
}

## ensure the parquet version of a file stem exists for every year,
## converting from TSV only when the parquet is missing
ensure_parquet <- function(stem){
    parquet_files <- glue("{basedir}/{years}/{stem}.parquet")
    tsv_files <- glue("{basedir}/{years}/{stem}.tsv")
    missing <- !file.exists(parquet_files)
    if(any(missing)){
        walk(tsv_files[missing], toparquet)
    }
    invisible(parquet_files)
}

walk(c(imp_stem, tvhh_stem, occ_stem, brand_stem, station_stem, prog_stem),
     ensure_parquet)

## parquet paths used downstream
imp_ext <- glue("{imp_stem}.parquet")
tvhh_ext <- glue("{tvhh_stem}.parquet")
occ_ext <- glue("{occ_stem}.parquet")
brand_ext <- glue("{brand_stem}.parquet")
station_ext <- glue("{station_stem}.parquet")
prog_ext <- glue("{prog_stem}.parquet")

## Programs
progs <- open_dataset(
    glue("{basedir}/{years}/{prog_ext}"),
    format = "parquet") %>%
    distinct

## Stations
stations <- open_dataset(
    glue("{basedir}/{years}/{station_ext}"),
    format = "parquet") %>%
    filter(MediaTypeId == 5) %>%
    select(DistributorCode, MarketCode, callsign = Abbreviation, Affiliation) %>%
    distinct %>%
    filter(substr(callsign, 1, 1) %in% c("W", "K"), Affiliation %in% c("ABC", "CBS", "FOX", "NBC"))

## Occurrence Data
occur <- open_dataset(
    glue("{basedir}/{years}/{occ_ext}"),
    format = "parquet",
    unify_schemas = TRUE) %>%
    inner_join(stations) %>%
    filter(MediaTypeID == 5,
           !is.na(Spend),
           Spend > 0,
           !is.na(Duration),
           Duration > 0) %>%
    select(AdDate,
           AdTime,
           MonitorPlusProgramCode = `Monitor Plus Program Code`,
           MarketCode,
           PrimBrandCode,
           callsign,
           Affiliation,
           Duration,
           PeriodYearMonth,
           DistributorID,
           DayOfWeek,
           TimeIntervalNumber,
           Spend) %>%
    mutate(year = PeriodYearMonth %/% 100)

all_days <- occur %>%
    distinct(DistributorID, DayOfWeek, TimeIntervalNumber, PeriodYearMonth)

## get denominators for ratings
hhs <- open_dataset(
    glue("{basedir}/{years}/{tvhh_ext}"),
    format = "parquet",
    unify_schemas = TRUE) %>%
    mutate(hh_50_plus =female_50_54 +female_55_64 +female_65_plus +Male_50_54 +Male_55_64 +Male_65_plus,
         hh_lt_50 = female_18_20 +female_21_24 +female_25_34 +female_35_49 +Male_18_20 +Male_21_24 +Male_25_34 +Male_35_49,
         hh_50_plus_f =female_50_54 +female_55_64 +female_65_plus,
         hh_50_plus_m =Male_50_54 +Male_55_64 +Male_65_plus,
         hh_lt_50_f =female_18_20 +female_21_24 +female_25_34 +female_35_49,
         hh_lt_50_m =Male_18_20 +Male_21_24 +Male_25_34 +Male_35_49,
         hh_f =female_18_20 +female_21_24 +female_25_34 +female_35_49 +female_50_54 +female_55_64 +female_65_plus,
         hh_m =Male_18_20 +Male_21_24 +Male_25_34 +Male_35_49 +Male_50_54 +Male_55_64 +Male_65_plus) %>%
  filter(year(StartDate)>=2009, year(EndDate) >= 2009) %>%
  group_by(MarketCode, StartDate, EndDate, HispanicFlag) %>%
  summarise(across(everything(), max)) %>%
  select(MarketCode,
         StartDate,
         EndDate,
         HispanicFlag,
         hh_total = TV_HH,
         hh_f, hh_m, hh_50_plus, hh_lt_50, hh_50_plus_f, hh_50_plus_m, hh_lt_50_f, hh_lt_50_m) %>%
    group_by(MarketCode, StartDate, EndDate) %>%
    summarise(across(starts_with("hh"), sum)) %>%
    ungroup() %>%
    collect() %>%
    mutate(EndDate = if_else(year(EndDate) == 2020, ymd("2020-12-31"), EndDate))

## Impressions
impressions <- open_dataset(
  glue("{basedir}/{years}/{imp_ext}"),
  format = "parquet",
  unify_schemas = TRUE) %>%
  filter(MediaTypeID == 5) %>%
  filter(TV_HH > 0) %>%
  mutate(imp_50_plus =female_50_54 +female_55_64 +female_65_plus +Male_50_54 +Male_55_64 +Male_65_plus,
         imp_lt_50 = female_18_20 +female_21_24 +female_25_34 +female_35_49 +Male_18_20 +Male_21_24 +Male_25_34 +Male_35_49,
         imp_50_plus_f =female_50_54 +female_55_64 +female_65_plus,
         imp_50_plus_m =Male_50_54 +Male_55_64 +Male_65_plus,
         imp_lt_50_f =female_18_20 +female_21_24 +female_25_34 +female_35_49,
         imp_lt_50_m =Male_18_20 +Male_21_24 +Male_25_34 +Male_35_49,
         imp_f =female_18_20 +female_21_24 +female_25_34 +female_35_49 +female_50_54 +female_55_64 +female_65_plus,
         imp_m =Male_18_20 +Male_21_24 +Male_25_34 +Male_35_49 +Male_50_54 +Male_55_64 +Male_65_plus) %>%
    select(DistributorID,
         DayOfWeek,
         PeriodYearMonth,
         TimeIntervalNumber,
         HispanicFlag,
         imp_total = TV_HH,
         imp_f, imp_m, imp_50_plus, imp_lt_50, imp_50_plus_f, imp_50_plus_m, imp_lt_50_f, imp_lt_50_m) %>%
    group_by(DistributorID, DayOfWeek, TimeIntervalNumber, PeriodYearMonth) %>%
    summarise(across(starts_with("imp"), ~ sum(., na.rm = TRUE))) %>%
    ungroup %>%
    right_join(all_days) %>%
    collect %>%
    group_by(DistributorID, DayOfWeek, TimeIntervalNumber) %>%
    arrange(DistributorID, DayOfWeek, TimeIntervalNumber, PeriodYearMonth) %>%
    fill(starts_with("imp"), .direction = "downup") %>%
    ungroup

## get multimarket advertisers
multi <- occur %>%
    distinct(year, PrimBrandCode, MarketCode) %>%
    count(year, PrimBrandCode) %>%
    mutate(multimarket = n > 1) %>%
    select(year, PrimBrandCode, multimarket)

## get number of halfhours
n_half <- occur %>%
    mutate(local_news = MonitorPlusProgramCode == 6281) %>%
    group_by(callsign,
             Affiliation,
             MarketCode,
             DistributorID,
             PeriodYearMonth,
             DayOfWeek,
             TimeIntervalNumber,
             local_news) %>%
    summarize(n_half_hour = n_distinct(floor_date(mdy_hms(paste(AdDate, AdTime, sep = " ")), unit = "30 minutes")))


## join
clean <- occur %>%
    filter((TimeIntervalNumber >= 445) & (TimeIntervalNumber <= 705)) %>% # 5pm-11:30pm
    # filter(TimeIntervalNumber <= 705) %>% # 6am-11:30pm
    mutate(local_news = MonitorPlusProgramCode == 6281) %>%
    left_join(multi) %>%
    left_join(n_half) %>%
    group_by(callsign,
             Affiliation,
             MarketCode,
             DistributorID,
             PeriodYearMonth,
             DayOfWeek,
             TimeIntervalNumber,
             local_news,
             n_half_hour,
             multimarket) %>%
    summarise(
        n_ads = sum(Duration / 30),
        total_duration = sum(Duration),
        total_spend = sum(Spend)
    ) %>%
    ungroup() %>%
    mutate(PeriodYearMonthStart = ym(PeriodYearMonth)) %>%
    left_join(impressions) %>%
    collect() %>%
    mutate(cpm = total_spend / n_ads / imp_total * 1000) %>%
    left_join(hhs, by = join_by(MarketCode, within(PeriodYearMonthStart, PeriodYearMonthStart, StartDate, EndDate))) %>%
    mutate(rating_total = imp_total / hh_total,
              rating_f = imp_f / hh_f,
              rating_m = imp_m / hh_m,
              rating_50_plus = imp_50_plus / hh_50_plus,
              rating_lt_50 = imp_lt_50 / hh_lt_50,
              rating_50_plus_f = imp_50_plus_f / hh_50_plus_f,
              rating_50_plus_m = imp_50_plus_m / hh_50_plus_m,
              rating_lt_50_f = imp_lt_50_f / hh_lt_50_f,
              rating_lt_50_m = imp_lt_50_m / hh_lt_50_m)

clean %>% write_parquet(glue("{basedir}/clean.parquet"))
clean %>% write_csv_arrow(glue("{basedir}/adintel_clean_timeinterval_yearmonth.csv"))

c1 <- clean %>%
    group_by(callsign, MarketCode, PeriodYearMonth, multimarket, local_news) %>%
    summarise(across(matches("^(hh|imp|cpm|rating)"), function(x) weighted.mean(x, n_ads, na.rm=TRUE)),
              total_half_hour = sum(n_half_hour),
              total_spend = sum(total_spend),
              total_duration = sum(total_duration),
              n_ads = sum(n_ads)) %>%
    ungroup %>%
    mutate(PeriodYearMonth = ym(PeriodYearMonth),
           multimarket = if_else(multimarket, "multimarket", "local"),
           local_news = if_else(local_news, "news", "nonnews")) %>%
    pivot_wider(id_cols = c(callsign, MarketCode, PeriodYearMonth, starts_with("hh_")),
                names_from = c(multimarket, local_news),
                values_from = !c(callsign, MarketCode, PeriodYearMonth, multimarket, local_news, starts_with("hh_"))
                ) %>%
    mutate(across(contains("spend"), ~ replace_na(., replace = 0))) %>%
    mutate(across(contains("duration"), ~ replace_na(., replace = 0)))


c1 %>% write_parquet(glue("{basedir}/clean_yearmonth.parquet"))
c1 %>% write_csv_arrow(glue("{basedir}/adintel_clean_yearmonth.csv"))
