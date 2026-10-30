## keyword searches of transcript data
## search for candidates for local office then place names
## must be run on HARMONY secure server
library(tidyverse)
library(data.table)
library(lubridate)
library(quanteda)
library(glue)
library(haven)
library(ggthemes)
library(stringdist)
library(humaniformat)

## setup
proj_dir <- "~/media-consolidation"

national_shows <- fread(glue("{proj_dir}/data/tv/national_shows.csv"))

pols_national <- rbindlist(
    list(
        data.table(search_for = "nancy pelosi", year = 2013:2022),
        data.table(search_for = "harry reid", year = 2013:2016),
        data.table(search_for = "chuck schumer", year = 2017:2022),
        data.table(search_for = "mitch mcconnell", year = 2013:2022),
        data.table(search_for = "kevin mccarthy", year = 2019:2022),
        data.table(search_for = "john boehner", year = 2013:2014),
        data.table(search_for = "paul ryan", year = 2015:2018),
        data.table(search_for = "barack obama", year = 2013:2016),
        data.table(search_for = "joe biden", year = c(2013:2016, 2020:2021)),
        data.table(search_for = "donald trump", year = 2016:2020),
        data.table(search_for = "mike pence", year = 2016:2020)
    )
)

dir_local_counts <- "/data/greg/pol_mention_counts_local/"
dir_national_counts <- "/data/greg/pol_mention_counts_national/"
dir_congress_counts <- "/data/greg/pol_mention_counts_congress/"
dir_stateleg_counts <- "/data/greg/pol_mention_counts_stateleg/"
dir_places <- "/data/greg/place_mention_counts/"

## read station to DMA map
calls <- glue("{proj_dir}/data/tv/callsigns-fcc.csv") %>% fread
calls[grep("-TV$", callsign), callsign := sub("-TV$", "", callsign)]
calls[grep("-DT$", callsign), callsign := sub("-DT$", "", callsign)]
calls[, call2 := sub("-CD$", "", callsign)]
calls[, n := .N, by = .(call2)]

calls[n == 1 & grepl("-CD$", callsign), callsign := sub("-CD$", "", callsign)]

calls <- calls[, .(callsign, dmacode)]

# add some addl low power stations
call_adds <- data.table(callsign = c("KLAF","KSPR","KXLH","WBMA","WFVX","KSAW","KTFT","KHBB","WBND","KEVN","KJCT","KFXV","KSVT"),
    dmacode = c(642,619,766,630,537,760,757,755,588,764,773,636,760))

calls <- rbind(calls, call_adds)


###
### Read mayor names
###

mayors <- glue("{proj_dir}/data/elections/mayor_candidates_export_220627.rds") %>%
    readRDS %>%
    setDT %>%
    .[year %in% c(2008:2020)] %>%
    setnames(old = "abb", new = "state") %>%
    .[, city := sub("St[. ]+", "Saint ", city)] %>%
    .[, city := sub("([A-Za-z]+)-.*County$", "\\1", city)] %>%
    .[city == "Carson" & state == "NV", city := "Carson City"] %>%
    .[city == "Boise City" & state == "ID", city := "Boise"]

## NOTE: uscities.csv is the proprietary simplemaps US Cities Pro database
## (see README, "Sources for Proprietary Data Sets"). Only a truncated sample
## is included in this archive; the full file is required to run this script.
citygeo <- glue("{proj_dir}/data/geo/uscities.csv") %>%
    fread %>%
    .[, .(city, state = state_id, zips)] %>%
    .[, city := sub("St[. ]+", "Saint ", city)] %>%
    .[, city := sub("Mt[. ]+", "Mount ", city)] %>%
    .[, city := sub("^No?[. ]+", "North ", city)] %>%
    .[, city := sub("^E?[. ]+", "East ", city)] %>%
    .[, city := sub("^W?[. ]+", "West ", city)] %>%
    .[, city := sub("^So?[. ]+", "South ", city)]

# handle occasional duplicate entries by selecting first row (the most populous)
citygeo <- citygeo[citygeo[, .I[1], by = .(city, state)]$V1]

# flatten zips
citygeo <- citygeo[, .(zipcode = str_split(zips, " ") %>% unlist %>% as.integer), by = .(city, state)]

# get DMA
dmazip <- glue("{proj_dir}/data/CCES/cd_dma/DMA-zip.csv") %>%
    fread %>%
    setnames(new = tolower) %>%
    setnames(old = c("st", "dma code", "dma name"), new = c("state", "dmacode", "dmaname"))

citygeo <- citygeo[dmazip, on = .(state, zipcode), nomatch = 0]

city2dma <- citygeo[, .(n = .N), by = .(state, city, dmacode, dmaname)] %>%
    .[order(state, city, desc(n))]

# this selects the most common DMA
city2dma <- city2dma[city2dma[, .I[1], by = .(city, state)]$V1]
city2dma[, n := NULL]

mayors <- mayors[city2dma, on = .(city, state), nomatch = 0]

mayors[, search_for := case_when(
    grepl("['](\\w+)[']", full_name) ~ paste(str_extract(full_name, "(?<=['])(\\w+)(?=['])"), lastname),
    nchar(firstname) == 1 ~ str_extract(full_name, "[a-z'-]+ [a-z'-]+$"),
    TRUE ~ paste(firstname, lastname))]

## add records for incumbents in non election years
inc_mayors <- mayors[, .SD[which.max(votes)], by = .(state, city, year)] %>%
    complete(year = 2013:2021, nesting(city, state, dmacode, dmaname)) %>%
    arrange(city, state, year) %>%
    group_by(city, state) %>%
    fill(search_for, firstname, lastname, .direction = "down") %>%
    setDT %>%
    .[!is.na(search_for)]

inc_mayors2 <- copy(inc_mayors) %>%
    .[!is.na(lastname)] %>%
    .[,search_for := paste("mayor", lastname)]

mayors <- rbind(mayors, inc_mayors, inc_mayors2)


mayors <- mayors[, .(search_for, dmacode, year)] %>%
    unique %>%
    .[order(dmacode, year, search_for)]
mayors[, pol_id := 1:.N]


###
### Read state leg candidate names
###

candidates_stleg <- c("ftm_bycandidate_stateleg.csv", "ftm_bycandidate_stateleg_2020-2022.csv") %>%
    map(~ glue("{proj_dir}/data/elections/{.}") %>% fread) %>% rbindlist(fill = TRUE)

## add prior non-election years for incumbents
inc_stleg <- candidates_stleg[Incumbency_Status == "Incumbent"] %>%
    complete(Election_Year = 2013:2021, nesting(Election_Jurisdiction, Office_Sought)) %>%
    arrange(Election_Jurisdiction, Office_Sought, Election_Year) %>%
    group_by(Election_Jurisdiction, Office_Sought) %>%
    fill(Candidate, .direction = "up") %>%
    setDT

candidates_stleg <- rbind(candidates_stleg, inc_stleg[is.na(request)])

## format names
candidates_stleg <- candidates_stleg[, parse_names(format_reverse(Candidate)),
                          by = .(Election_Year, Election_Jurisdiction, Office_Sought)]

## standardize districts
candidates_stleg[, lu := if_else(grepl("SENATE", Office_Sought), "U", "L")]
candidates_stleg[, district := sub(".* DISTRICT ", "", Office_Sought)]
candidates_stleg <- candidates_stleg[, .(year = Election_Year, state = Election_Jurisdiction, lu, district, first_name, middle_name, last_name)]


candidates_stleg[, search_for := case_when(
    grepl("[(](\\w+)[)]", middle_name) ~ paste(str_extract(middle_name, "(?<=[(])(\\w+)(?=[)])"), last_name),
    nchar(first_name) == 1 ~ paste(middle_name, last_name),
    TRUE ~ paste(first_name, last_name)) %>% tolower]


## match to DMAs
# correct some districts
candidates_stleg[state == "AK" & grepl("^[A-Z]$", district), district := paste0("000", district)]
candidates_stleg[state %in% c("ID", "WA") & grepl("POSITION", district), district := sub("-POSITION.*", "", district)]
candidates_stleg[state == "MA", district := sub(" AND ", " & ", district)]

# MA and VT are annoying, require translation using census gazetteer files
glue("{proj_dir}/data/geo/2012_Gaz_sldl_national.txt") %>%
    fread %>%
    .[,.(statefips = substr(GEOID, 1,2), sld = substr(GEOID, 3, 5), district = NAME, lu = "L")] %>%
    .[statefips %in% c("25", "50")] %>%
    .[, state := if_else(statefips == "25", "MA", "VT")] -> gaz_l

gaz_l[, district := sub("( State House)? District", "", district)]
gaz_l[, district := toupper(district)]

glue("{proj_dir}/data/geo/2013_Gaz_sldu_national.txt") %>%
    fread %>%
    .[,.(statefips = substr(GEOID, 1,2), sld = substr(GEOID, 3, 5), district = NAME, lu = "U")] %>%
    .[statefips %in% c("25", "50")] %>%
    .[, state := if_else(statefips == "25", "MA", "VT")] -> gaz_u

gaz_u[, district := sub("( State Senate)? District", "", district)]
gaz_u[, district := toupper(district)]
gaz_u[district == "GRAND-ISLE-CHITTENDEN", district := "GRAND ISLE"]

gaz <- rbind(gaz_l, gaz_u)


sld2dma <- glue("{proj_dir}/data/geo/sld2dma.rds") %>%
    readRDS %>%
    .[, .(state, lu, district = sld, year = regime, dmacode)]

c1 <- candidates_stleg[sld2dma, on = .(state, year, lu, district), nomatch = 0]
c0 <- candidates_stleg[!sld2dma, on = .(state, year, lu, district)]



c0 <- c0[gaz, on = .(state, lu, district), nomatch = 0] %>%
    .[, district := sld] %>%
    .[sld2dma, on = .(state, year, lu, district), nomatch = 0]

c0[, c("sld", "statefips") := NULL]

candidates_stleg <- rbind(c0, c1) %>%
    .[, .(search_for, dmacode, year)] %>% unique
candidates_stleg[, pol_id := 1:.N]

###
### Read congressional candidate names
###

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

candidates_congress <- rbind(
    candidates_congress,
    inc_congress[is.na(ico.status) & !is.na(search_for)]
)
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


###
### Read place names
###

places <- read_dta(glue("{proj_dir}/data/places/places_by_DMA.dta")) %>%
    setDT

place_dmas <- places[, .(dma)] %>% unique

dmacodes <- fread(glue("{proj_dir}/data/tv/dmacodes.csv")) %>%
    setnames(old = c("DMA"), new = c("dmacode")) %>%
    .[, Market := str_trim(Market)] %>%
    .[, Market := sub(" ?\\(.+\\)$", "", Market)]


nielsen_dmas <- dmacodes[, .(Market, dmacode)] %>% unique

place_dmas[, Market := map_chr(dma, ~ nielsen_dmas$Market[which.min(stringdist(., nielsen_dmas$Market, method = "lcs"))])]
place_dmas <- place_dmas[nielsen_dmas, on = .(Market), nomatch = 0]
place_dmas[, Market := NULL]

places <- places[place_dmas, on = .(dma)]
places[, place_id := 1:.N]


## function to read in raw data, extract transcript, search for relevant politicians and places
## (relevance defined by running for office in same year / DMA)
parse_tveyes <- function(
    f,
    cands_national = NULL,
    cands_local = NULL,
    cands_stateleg = NULL,
    cands_congress = NULL,
    place_names = NULL) {

    cat(f, "\n")
    raw <- fread(f)
    setnames(raw, new = tolower)

    dt <- str_extract(f, "[0-9-]+(?=\\.csv)")

    if (nrow(raw) == 0) {
    cat("\tNo data.\n")
    return()
    } else {
    cat("\t", nrow(raw), "records found.\n")
    }

    cat("\tDropping national shows...")
    raw <- raw[!national_shows, on = .(programlongtitle)]

    raw <- raw[!(programlongtitle == "" &
                 !grepl("\\b(local|state)\\b", programinfodescription, ignore.case = TRUE))]
    cat(nrow(raw), "records retained.\n")

    cat("\tExtracting metadata...\n")
    raw[, programutcdatetime := as.POSIXct(programutctime, origin = "1970-01-01")]
    raw[, affil := str_extract(station_name, "(?<=\\()[A-Z]+(?=\\))")]
    raw[, callsign := stationguid]
    raw <- unique(raw, by = c("programid", "callsign", "affil", "programutcdatetime", "programlongtitle"))

    raw <- raw[calls, on = .(callsign), nomatch = 0]

    # convert to local
    raw[, program_date := date(programutcdatetime)]
    raw[dmacode >= 800 & hour(programutcdatetime) <= 7, program_date := program_date - days(1)]
    raw[dmacode >= 700 & dmacode < 800 & hour(programutcdatetime) <= 6, program_date := program_date - days(1)]
    raw[dmacode >= 600 & dmacode < 700 & hour(programutcdatetime) <= 5, program_date := program_date - days(1)]
    raw[dmacode < 600 & hour(programutcdatetime) <= 4, program_date := program_date - days(1)]

    raw[, year := year(program_date)]
    raw[, month := month(program_date)]
    
    ## count national politician mentions
    if (!is.null(cands_national)){
        cat("\tCounting mentions of national politicians...\n")
        raw_expanded <- raw[cands_national, on = .(year), allow.cartesian = T]

        raw_expanded[!is.na(transcript), count := str_count(tolower(transcript), fixed(search_for))]

        counts <- raw_expanded[!is.na(transcript),
                                .(count_sum = sum(count),
                                count_mean = mean(count),
                                count_med = median(count)),
                            by = .(year, month, program_date, dmacode, callsign, search_for)]

        fwrite(counts, paste0(dir_national_counts, "natlpol_mentions_", dt, ".csv"))
    }
    
    ## count local politician mentions
    if (!is.null(cands_local)) {
        cat("\tCounting mentions of local politicians...\n")
        raw_expanded <- raw[cands_local, on = .(dmacode, year), allow.cartesian = T]

        raw_expanded[!is.na(transcript), count := str_count(tolower(transcript), fixed(search_for))]

        counts <- raw_expanded[!is.na(transcript),
                                .(count_sum = sum(count),
                                count_mean = mean(count),
                                count_med = median(count)),
                            by = .(year, month, program_date, dmacode, callsign, pol_id, search_for)]

        fwrite(counts, paste0(dir_local_counts, "pol_mentions_", dt, ".csv"))
    }
    

    ## count state leg mentions
    if (!is.null(cands_stateleg)) {
        cat("\tCounting mentions of state legislators...\n")
        raw_expanded <- raw[cands_stateleg, on = .(dmacode, year), allow.cartesian = T]

        raw_expanded[!is.na(transcript), count := str_count(tolower(transcript), fixed(search_for))]

        counts <- raw_expanded[!is.na(transcript),
                                .(count_sum = sum(count),
                                count_mean = mean(count),
                                count_med = median(count)),
                            by = .(year, month, program_date, dmacode, callsign, pol_id, search_for)]

        fwrite(counts, paste0(dir_stateleg_counts, "pol_mentions_", dt, ".csv"))
    }

    ## count congress mentions
    if (!is.null(cands_congress)) {
        cat("\tCounting mentions of congressional candidates...\n")
        raw_expanded <- raw[cands_congress, on = .(dmacode, year), allow.cartesian = T]

        raw_expanded[!is.na(transcript), count := str_count(tolower(transcript), fixed(search_for))]

        counts <- raw_expanded[!is.na(transcript),
                                .(count_sum = sum(count),
                                count_mean = mean(count),
                                count_med = median(count)),
                            by = .(year, month, program_date, dmacode, callsign, pol_id, search_for)]

        fwrite(counts, paste0(dir_congress_counts, "pol_mentions_", dt, ".csv"))
    }
    

    ## count mentions of places, and total words
    if (!is.null(place_names)) {
        cat("\tCounting total words...\n")
        raw[, n_progs := .N, by = .(year, month, program_date, dmacode, callsign)]
        raw[, n_words := sum(str_count(transcript, "\\w+")),
            by = .(year, month, program_date, dmacode, callsign)]

        cat("\tCounting mentions of local place names...\n")
        raw_expanded <- raw[place_names, on = .(dmacode), allow.cartesian = T]

        raw_expanded[!is.na(transcript), count := str_count(tolower(transcript), fixed(tolower(name_cleaned)))]

        counts <- raw_expanded[!is.na(transcript),
                                .(count_sum = sum(count),
                                count_mean = mean(count),
                                count_med = median(count)),
                                by = .(year, month, program_date, dmacode, callsign, n_progs, n_words, place_id, name_cleaned)]

        fwrite(counts, paste0(dir_places, "place_mentions_", dt, ".csv"))
    }
    
}


raw_dir <- "/data/tveyes3"

raw_files <- list.files(path = raw_dir, pattern = "-\\d\\d.csv", full.names = T)

raw_files %>%
    walk(parse_tveyes,
        cands_national = pols_national,
        cands_local = mayors,
        cands_stateleg = candidates_stleg,
        cands_congress = candidates_congress,
        place_names = places)
