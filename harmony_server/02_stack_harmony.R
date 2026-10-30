### stack Harmony mention counts into monthly panel

library(lubridate)
library(tidyverse)
library(magrittr)
library(data.table)
library(fixest)
library(haven)
library(glue)

proj_dir <- "~/media-consolidation"
harmony_dir <- "/data/greg"

setDTthreads(8)

###
### MENTION COUNTS
###


## place mentions
## group by month

read_placementions <- function(files) {
  cat(files[1], "\n")
  files %>%
    map(fread, select = c(
          "year",
          "month",
          "dmacode",
          "callsign",
          "name_cleaned",
          "place_id",
          "n_progs",
          "n_words",
          "count_sum",
          "count_mean",
          "count_med")
    ) %>%
    rbindlist %>%
    .[,
     .(count_sum = sum(count_sum),
       count_mean = sum(count_mean),
       count_med = sum(count_med)),
     by = .(year, month, dmacode, callsign, n_progs, n_words, place_id, name_cleaned)]
}

placefiles <- glue("{harmony_dir}/place_mention_counts/") %>%
  list.files(pattern = "place_mentions_\\d{4}-\\d{2}-\\d{2}.csv",
             full.names = TRUE)

months <- placefiles %>% str_extract("\\d{4}-\\d{2}")

split(placefiles, months) %>%
  map(read_placementions) %>%
  rbindlist %>%
  .[, date := ym(paste(year, month))] %>%
  .[, .(mention_place_total = sum(count_sum),
        n_progs = sum(n_progs),
        n_words = sum(n_words)),
    by = .(year, month, dmacode, callsign, date, name_cleaned)] %>%
  .[, .(mention_place_total = sum(mention_place_total)),
     by = .(year, month, dmacode, callsign, date, n_progs, n_words)] ->
  places

## city pol mentions
## group by month

read_polmentions <- function(files) {
  cat(files[1], "\n")
  files %>%
    map(fread, select = c(
          "year",
          "month",
          "dmacode",
          "callsign",
          "search_for",
          "count_sum")
    ) %>%
    rbindlist %>%
    .[, .(count_sum = sum(count_sum)),
      by = .(year, month, dmacode, callsign)]
}

localpolfiles <- glue("{harmony_dir}/pol_mention_counts_local/") %>%
  list.files(pattern = "pol_mentions_\\d{4}-\\d{2}-\\d{2}.csv",
             full.names = TRUE)

months <- localpolfiles %>% str_extract("\\d{4}-\\d{2}")

split(localpolfiles, months) %>%
  map(read_polmentions) %>%
  rbindlist %>%
  .[, date := ym(paste(year, month))] %>%
  .[, .(mention_pol_local_total = sum(count_sum)),
    by = .(year, month, dmacode, callsign, date)] ->
  pols_local

## state leg pol mentions
## group by month

statelegpolfiles <- glue("{harmony_dir}/pol_mention_counts_stateleg/") %>%
  list.files(pattern = "pol_mentions_\\d{4}-\\d{2}-\\d{2}.csv",
             full.names = TRUE)

months <- statelegpolfiles %>% str_extract("\\d{4}-\\d{2}")

split(statelegpolfiles, months) %>%
  map(read_polmentions) %>%
  rbindlist %>%
  .[, date := ym(paste(year, month))] %>%
  .[, .(mention_pol_stateleg_total = sum(count_sum)),
    by = .(year, month, dmacode, callsign, date)] ->
  pols_stateleg

## national pol mentions
## group by month

nationalpolfiles <- glue("{harmony_dir}/pol_mention_counts_national/") %>%
  list.files(pattern = "natlpol_mentions_\\d{4}-\\d{2}-\\d{2}.csv",
             full.names = TRUE)

months <- nationalpolfiles %>% str_extract("\\d{4}-\\d{2}")

split(nationalpolfiles, months) %>%
  map(read_polmentions) %>%
  rbindlist %>%
  .[, date := ym(paste(year, month))] %>%
  .[, .(mention_pol_national_total = sum(count_sum)),
    by = .(year, month, dmacode, callsign, date)] ->
  pols_national

## congress mentions
## group by month

congresspolfiles <- glue("{harmony_dir}/pol_mention_counts_congress/") %>%
  list.files(pattern = "pol_mentions_\\d{4}-\\d{2}-\\d{2}.csv",
             full.names = TRUE)

months <- congresspolfiles %>% str_extract("\\d{4}-\\d{2}")

split(congresspolfiles, months) %>%
  map(read_polmentions) %>%
  rbindlist %>%
  .[, date := ym(paste(year, month))] %>%
  .[, .(mention_pol_congress_total = sum(count_sum)),
    by = .(year, month, dmacode, callsign, date)] ->
  pols_congress

## join all mentions together

# first create complete set of year / month / station obs
panel <- rbind(pols_congress, pols_stateleg, pols_local, places, pols_national, fill = T) %>%
  .[, .(year, month, date, dmacode, callsign)] %>%
  unique

call2dma <- panel[, .(callsign, dmacode)] %>% unique

panel[, CJ(date, callsign, unique = T)] %>%
  .[call2dma, on = .(callsign)] ->
  panel

pols_local %>%
  .[panel,
    .(date,
      callsign,
      dmacode,
      mention_pol_local_total),
    on = .(date, callsign, dmacode)] ->
  panel

pols_stateleg %>%
  .[panel, .(date,
             callsign,
             dmacode,
             mention_pol_local_total,
             mention_pol_stateleg_total),
          on = .(date, callsign, dmacode)] ->
  panel

pols_national %>%
  .[panel, .(date,
             callsign,
             dmacode,
             mention_pol_local_total,
             mention_pol_stateleg_total,
             mention_pol_national_total),
          on = .(date, callsign, dmacode)] ->
  panel

places %>%
  .[panel, .(date,
             callsign,
             dmacode,
             n_progs,
             n_words,
             mention_place_total,
             mention_pol_local_total,
             mention_pol_stateleg_total,
             mention_pol_national_total),
    on = .(date, callsign, dmacode)] ->
  panel

pols_congress %>%
  .[panel, .(date,
             callsign,
             dmacode,
             n_progs,
             n_words,
             mention_place_total,
             mention_pol_local_total,
             mention_pol_stateleg_total,
             mention_pol_national_total,
             mention_pol_congress_total),
    on = .(date, callsign, dmacode)] ->
  panel

panel[is.na(panel)] <- 0

mentioncols <- c("mention_place_total",
  "mention_pol_local_total",
  "mention_pol_stateleg_total",
  "mention_pol_national_total",
  "mention_pol_congress_total")
panel[, sub("_total", "_pershow", mentioncols) := map(.SD, ~ . / n_progs), .SDcols = mentioncols]
panel[, sub("_total", "_perword", mentioncols) := map(.SD, ~ . / n_words), .SDcols = mentioncols]
panel[, sub("_total", "_asinh", mentioncols) := map(.SD, asinh), .SDcols = mentioncols]


panel %>%
  .[date >= mdy("01-01-2013") & date <= mdy("12-31-2022")] %>%
  fwrite(glue("{proj_dir}/data/content/harmony_mentions_station_month.csv"))
