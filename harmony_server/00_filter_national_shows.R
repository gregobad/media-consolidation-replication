#### filter out national shows from TVEYES data ####
### must be run on harmony labs secure server ###
library(tidyverse)
library(data.table)
library(here)

## code to find national shows: look for anything with count_length > 10
## (count_length is the number of occurrences in tveyes of the same unique airing id)
## then manually filter this list

setwd("~/media-consolidation")
here::i_am("code/harmony_server/00_filter_national_shows.R")


get_national_shows <- function(f) {
  cat(f, "\n")
  fread(f, select = c("count_length", "programlongtitle")) %>%
    .[count_length >= 10, .(programlongtitle)] %>%
    unique
}

raw_dir <- "/data/tveyes3"
tveyes_files <- list.files(path = raw_dir, pattern = "-\\d\\d.csv", full.names = T)

badshows <- tveyes_files %>%
  map(get_national_shows) %>%
  rbindlist %>%
  .[, .(appeared_on_days = .N), by = .(programlongtitle)] %>%
  .[order(appeared_on_days, decreasing = T)]

fwrite(badshows, here("data/tv", "national_shows.csv"))  ## note: this is manually checked after running
