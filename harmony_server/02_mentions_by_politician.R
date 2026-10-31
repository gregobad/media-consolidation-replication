### stack Harmony mention counts into station x politician x month panel

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
          "pol_id",
          "count_sum")
    ) %>%
    rbindlist %>%
    .[, .(count_sum = sum(count_sum)),
      by = .(year, month, dmacode, callsign, pol_id, search_for)]
}

localpolfiles <- glue("{harmony_dir}/pol_mention_counts_local") %>%
  list.files(pattern = "pol_mentions_\\d{4}-\\d{2}-\\d{2}.csv",
             full.names = TRUE)

months <- localpolfiles %>% str_extract("\\d{4}-\\d{2}")

split(localpolfiles, months) %>%
  map(read_polmentions) %>%
  rbindlist %>%
  .[, date := ym(paste(year, month))] %>%
  .[, .(mentions = sum(count_sum)),
    by = .(year, month, dmacode, callsign, date, pol_id, search_for)] ->
  pols_local

pols_local[, pol_type := "local"]

## state leg pol mentions
## group by month

statelegpolfiles <- glue("{harmony_dir}/pol_mention_counts_stateleg") %>%
  list.files(pattern = "pol_mentions_\\d{4}-\\d{2}-\\d{2}.csv",
             full.names = TRUE)

months <- statelegpolfiles %>% str_extract("\\d{4}-\\d{2}")

split(statelegpolfiles, months) %>%
  map(read_polmentions) %>%
  rbindlist %>%
  .[, date := ym(paste(year, month))] %>%
  .[, .(mentions = sum(count_sum)),
    by = .(year, month, dmacode, callsign, date, pol_id, search_for)] ->
  pols_stateleg

pols_stateleg[, pol_type := "stateleg"]

## congress mentions
## group by month

congresspolfiles <- glue("{harmony_dir}/pol_mention_counts_congress") %>%
  list.files(pattern = "pol_mentions_\\d{4}-\\d{2}-\\d{2}.csv",
             full.names = TRUE)

months <- congresspolfiles %>% str_extract("\\d{4}-\\d{2}")

split(congresspolfiles, months) %>%
  map(read_polmentions) %>%
  rbindlist %>%
  .[, date := ym(paste(year, month))] %>%
  .[, .(mentions = sum(count_sum)),
    by = .(year, month, dmacode, callsign, date, pol_id, search_for)] ->
  pols_congress

pols_congress[, pol_type := "congress"]


## read place mentions files to get n shows and n words
## by station-month

read_placementions <- function(files) {
  cat(files[1], "\n")
  files %>%
    map(fread, select = c(
          "year",
          "month",
          "dmacode",
          "callsign",
          "n_progs",
          "n_words")
    ) %>%
    rbindlist %>%
    unique
}

placefiles <- glue("{harmony_dir}/place_mention_counts/") %>%
  list.files(pattern = "place_mentions_\\d{4}-\\d{2}-\\d{2}.csv",
             full.names = TRUE)

months <- placefiles %>% str_extract("\\d{4}-\\d{2}")

split(placefiles, months) %>%
  map(read_placementions) %>%
  rbindlist %>%
  .[, date := ym(paste(year, month))] %>%
  .[, .(n_progs = sum(n_progs),
        n_words = sum(n_words)),
    by = .(year, month, dmacode, callsign, date)] ->
  progcounts



## stack mentions
mentions <- rbind(
    pols_local,
    pols_stateleg,
    pols_congress) %>%
    .[progcounts, on = .(year, month, dmacode, callsign, date), nomatch = 0]



mentions[, mentions_pershow := mentions / n_progs]
mentions[, mentions_perword := mentions / n_words]
mentions[, mentions_asinh := asinh(mentions)]


mentions %>%
  .[date >= mdy("01-01-2013") & date <= mdy("12-31-2022")] %>%
  fwrite(glue("{proj_dir}/data/content/harmony_mentions_station_politician_month.csv"))

## create dataset of congressman mentions that aggregates to district level, adds congruence info
candidates_congress <-  glue("{proj_dir}/data/elections/dime_recipients_1979_2020.csv") %>%
    fread %>%
    .[cycle >= 2012 &
      cycle <= 2020 &
      seat=="federal:house" &
      total.disbursements >= 5000 &
      fec.cand.status == "C",
      .(year = cycle,
        search_for = paste(fname, lname),
        state = substr(district, 1, 2),
        district = substr(district, 3, 4),
        ico.status)]

## add prior non-election years for incumbents
inc_congress <- candidates_congress[ico.status == "I"] %>%
    complete(year = 2013:2021, nesting(state, district)) %>%
    arrange(state, district, year) %>%
    group_by(state, district) %>%
    fill(search_for, .direction = "up") %>%
    setDT

candidates_congress <- rbind(candidates_congress, inc_congress[is.na(ico.status) & !is.na(search_for)])
candidates_congress[is.na(ico.status), ico.status := "I"]

## match to DMA
cd2dma <- glue("{proj_dir}/data/geo/cd2dma.csv") %>% fread
cd2dma[, district := str_pad(CD, width = 2, pad = "0")]
cd2dma <- cd2dma[, .(share_of_dma = mean(share_of_DMA)), by = .(state, district, dmacode = DMA)]

candidates_congress <- candidates_congress[
    cd2dma,
    on = .(state, district),
    nomatch = 0,
    allow.cartesian = TRUE
]

candidates_congress[, pol_id := 1:.N]

mentions_congress <- mentions[pol_type == "congress"] %>%
    .[candidates_congress, on = .(year, dmacode, search_for, pol_id), nomatch = 0] %>%
    .[, .(mentions = sum(mentions),
          mentions_incumbent = sum(mentions * (ico.status == "I")),
          mentions_challenger = sum(mentions * (ico.status != "I"))),
    by = .(year, month, dmacode, callsign, date, state, district)]


districts_panel <- candidates_congress[, .(year, state, district, dmacode)] %>%
    unique %>%
    .[, month := 1] %>%
    complete(year = 2013:2021, month = 1:12, nesting(state, district, dmacode)) %>%
    setDT %>%
    .[order(year, month, state, district, dmacode)] %>%
    .[year >= 2013 & year <= 2021]

districts_panel <- mentions_congress[districts_panel,
    on = .(year, month, state, district, dmacode)]

districts_panel[is.na(date), date := ym(paste(year, month, sep = "-"))]
districts_panel[is.na(mentions), mentions := 0]
districts_panel[is.na(mentions_incumbent), mentions_incumbent := 0]
districts_panel[is.na(mentions_challenger), mentions_challenger := 0]


districts_panel <- districts_panel[progcounts,
    on = .(year, month, date, dmacode, callsign),
    nomatch = 0]


districts_panel <- districts_panel[cd2dma, on = .(state, district, dmacode), nomatch = 0]

districts_panel[, mention_pol_congress_pershow := mentions / n_progs]
districts_panel[, mention_pol_congress_perword := mentions / n_words]
districts_panel[, mention_pol_congress_asinh := asinh(mentions)]
setnames(districts_panel, old = "mentions", new = "mentions_pol_congress_total")
setnames(districts_panel, old = "mentions_incumbent", new = "mentions_pol_congress_incumbent")
setnames(districts_panel, old = "mentions_challenger", new = "mentions_pol_congress_challenger")

districts_panel %>%
  .[date >= mdy("01-01-2013") & date <= mdy("12-31-2022")] %>%
  fwrite(glue("{proj_dir}/data/content/harmony_mentions_station_cong_district_month.csv"))


## test main effect of congruence
feols(c(mention_pol_congress_pershow, mention_pol_congress_perword, mention_pol_congress_asinh) ~ share_of_dma |
    callsign + date,
    data = districts_panel,
    cluster = ~ callsign)

feols(c(mention_pol_congress_pershow, mention_pol_congress_perword, mention_pol_congress_asinh) ~ share_of_dma |
    callsign + dmacode^date,
    data = districts_panel,
    cluster = ~ callsign)

  feols(c(mention_pol_congress_pershow, mention_pol_congress_perword, mention_pol_congress_asinh) ~ 
    i(bin(share_of_dma, bin = "cut::q1]q2]q3]q4]")) |
    callsign + dmacode^date + state^district,
    data = districts_panel,
    cluster = ~ callsign)

feols(c(mention_pol_congress_pershow, mention_pol_congress_perword, mention_pol_congress_asinh) ~ share_of_dma |
    callsign + state^district + dmacode^date,
    data = districts_panel,
    cluster = ~ callsign)

feols(c(asinh(mentions_pol_congress_incumbent), asinh(mentions_pol_congress_challenger)) ~ share_of_dma |
    callsign + state^district + dmacode^date,
    data = districts_panel,
    cluster = ~ callsign)
