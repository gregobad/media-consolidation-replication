## Political donation behavior of ownership groups (Appendix: "Political Donation Behavior of Ownership Groups").
## Produces figures/rr_cand_giving.pdf (donations by executive-board signatories) and
## figures/rr_pac_giving.pdf (donations by conglomerate PACs).
##
## Inputs (all in data/donations/, downloaded from the FEC, https://www.fec.gov/data/):
##   *_messy.csv            raw FEC individual-contribution downloads for contributors whose employer matches each group
##   *_check.csv            hand-checked subsets matched to officer/director names (column `drop` flags false matches)
##   sinclair_employers.csv hand-coded list of employer strings that correspond to Sinclair
##   *_pac.csv              FEC disbursement downloads for the Nexstar and Sinclair corporate PACs
##   boards/*.csv           officers and directors by year, hand-collected from SEC filings
## plus the DIME recipients file (see below), used to identify the party of recipient committees.

library(tidyverse)
library(humaniformat)   # name parsing; install.packages("humaniformat")

### SET WORKING DIRECTORY HERE
path_to_archive <- "/path/to/replication"
setwd(path_to_archive)

# individual donations by boards ------------------------------------------


#sinclair <- read_csv("data/donations/boards/Sinclair_officers_and_board__2010_.csv")

sinclair <- map_df(list.files(path = "data/donations/boards", pattern = "Sinclair", full.names = T), read_csv)

nexstar <- read_csv("data/donations/boards/Cleaned_Nexstar_Officers_and_Directors.csv")

gray <- read_csv("data/donations/boards/Updated_Gray_Officers_and_Directors_with_2018.csv")


ind.sinclair <- read_csv("data/donations/sinclair_messy.csv")

#ind.sinclair %>% group_by(contributor_employer) %>% count %>% write_csv("data/donations/sinclair_employers.csv")

sinclair.employers <- read_csv("data/donations/sinclair_employers.csv") %>% filter(keep == 1)

ind.sinclair <- filter(ind.sinclair, contributor_employer %in% sinclair.employers$contributor_employer)


sinclair.names <- sinclair %>% 
  distinct(Name) %>% 
  pull %>% 
  map_df(parse_names) %>% 
  mutate(across(c(first_name, middle_name, last_name), ~str_replace_all(.x, "[:punct:]", "") %>% str_trim %>% str_squish %>% str_to_upper)) %>% 
  mutate(first_name = ifelse(str_length(first_name) == 1, middle_name, first_name))

ind.sinclair <- ind.sinclair %>% 
  mutate(contributor_last_name = str_replace_all(contributor_last_name, "[:punct:]", "") %>% str_trim %>% str_squish %>% str_to_upper) %>% 
  filter(contributor_last_name %in% unique(sinclair.names$last_name))

#write_csv(ind.sinclair, "data/donations/sinclair_check.csv")

ind.sinclair.orig <- read_csv("data/donations/sinclair_messy.csv")

ind.sinclair <- read_csv("data/donations/sinclair_check.csv") %>% filter(is.na(drop))

# sinclair <- left_join(sinclair, sinclair.names, by = c("Name" = "full_name"))
# sinclair <- sinclair %>% 
#   group_by(Name) %>% 
#   distinct(Year, .keep_all=T)
# 
ind.sinclair <- ind.sinclair %>%
  ungroup %>%
  mutate(year = year(ymd(contribution_receipt_date)))
# 
# ind.sinclair <- ind.sinclair %>% 
#   inner_join(sinclair %>% ungroup %>%  select(Year, last_name), by = c("contributor_last_name" = "last_name","year" = "Year"))



###### nexstar
nexstar.names <- nexstar %>% 
  distinct(name) %>% 
  pull %>% 
  map_df(parse_names) %>% 
  mutate(across(c(first_name, middle_name, last_name), ~str_replace_all(.x, "[:punct:]", "") %>% str_trim %>% str_squish %>% str_to_upper)) %>% 
  mutate(first_name = ifelse(str_length(first_name) == 1, middle_name, first_name))


ind.nexstar <- read_csv("data/donations/nexstar_messy.csv")

ind.nexstar <- ind.nexstar %>% 
  mutate(contributor_last_name = str_replace_all(contributor_last_name, "[:punct:]", "") %>% str_trim %>% str_squish %>% str_to_upper) %>% 
  filter(contributor_last_name %in% unique(nexstar.names$last_name))

#write_csv(ind.nexstar, "data/donations/nexstar_check.csv")
ind.nexstar <- read_csv("data/donations/nexstar_check.csv") %>% filter(is.na(drop))

ind.nexstar <- ind.nexstar %>% 
  ungroup %>% 
  mutate(year = year(ymd(contribution_receipt_date)))

nexstar <- left_join(nexstar, nexstar.names, by = c("name" = "full_name"))
nexstar <- nexstar %>% 
  group_by(name) %>% 
  distinct(year, .keep_all=T)

ind.nexstar <- ind.nexstar %>% 
  inner_join(nexstar %>% ungroup %>%  select(year, last_name), by = c("contributor_last_name" = "last_name", "year"))



###### gray
gray.names <- gray %>% 
  distinct(name) %>% 
  pull %>% 
  map_df(parse_names) %>% 
  mutate(across(c(first_name, middle_name, last_name), ~str_replace_all(.x, "[:punct:]", "") %>% str_trim %>% str_squish %>% str_to_upper)) %>% 
  mutate(first_name = ifelse(str_length(first_name) == 1, middle_name, first_name)) %>% 
  filter(!is.na(full_name))


ind.gray <- read_csv("data/donations/gray_messy.csv")
#ind.gray %>% group_by(contributor_employer) %>% count %>% View

ind.gray <- ind.gray %>% 
  filter(contributor_employer %in% c("GRAY", "GRAY TV") | str_detect(contributor_employer, "MEDIA|BROADCAST|TELEVISION"))


ind.gray <- ind.gray %>% 
  mutate(contributor_last_name = str_replace_all(contributor_last_name, "[:punct:]", "") %>% str_trim %>% str_squish %>% str_to_upper) %>% 
  filter(contributor_last_name %in% unique(gray.names$last_name))

#write_csv(ind.gray, "data/donations/gray_check.csv")
ind.gray <- read_csv("data/donations/gray_check.csv") %>% filter(is.na(drop))

ind.gray <- ind.gray %>% 
  ungroup %>% 
  mutate(year = year(ymd(contribution_receipt_date)))

gray <- left_join(gray, gray.names, by = c("name" = "full_name"))
gray <- gray %>% 
  group_by(name) %>% 
  distinct(year, .keep_all=T)

ind.gray <- ind.gray %>% 
  inner_join(gray %>% ungroup %>% filter(first_name != "ROBIN" & !is.na(last_name)) %>% select(year, last_name), by = c("contributor_last_name" = "last_name", "year"))




# combine -----------------------------------------------------------------

ind.gray <- ind.gray %>% mutate(network = "gray") %>% select(contributor_first_name:contributor_last_name, committee_id, committee_name = `committee_name...2`, year, contribution_receipt_amount, network)
ind.nexstar <- ind.nexstar %>% mutate(network = "nexstar") %>% select(contributor_first_name:contributor_last_name, committee_id, committee_name = `committee_name...2`, year, contribution_receipt_amount, network)
ind.sinclair <- ind.sinclair %>% mutate(network = "sinclair") %>% select(contributor_first_name:contributor_last_name, committee_id, committee_name = `committee_name...2`, year, contribution_receipt_amount, network)

ind <- bind_rows(ind.gray, ind.nexstar, ind.sinclair)

write_csv(ind, "data/donations/ind_donations.csv")

ind <- read_csv("data/donations/ind_donations.csv")


## DIME recipients file (Bonica, Database on Ideology, Money in Politics, and Elections), NOT included in this
## archive because of size. Download the recipients file covering the 1979-2024 cycles from
## https://data.stanford.edu/dime and save it as data/dime/dime_recipients_1979_2024.csv
cands <- read_csv("data/dime/dime_recipients_1979_2024.csv", guess_max = 1e6)

cands <- select(cands, cycle, lname:fname, party, state, seat, district, Cand.ID, FEC.ID, NID, icpsr = ICPSR2) %>% filter(Cand.ID != "")
cands <- cands %>% 
  ungroup %>% 
  group_by(cycle, Cand.ID) %>% 
  filter(row_number()==1)
cands <- filter(cands, cycle >= 2010 & cycle <= 2022)
cands.dist <- cands %>% 
  ungroup %>% 
  distinct(FEC.ID, .keep_all = T)

#200 = R

ind <- left_join(ind, cands.dist, by = c("committee_id" = "FEC.ID"))
ind.cands <- ind %>% filter(seat %in% c("federal:house", "federal:senate", "federal:president"))
ind.cmtes <- ind %>% filter(is.na(seat) | !(seat %in% c("federal:house", "federal:senate", "federal:president")))

## hand label R or D cmtes:
cmtes <- tibble(
  pac_name = unique(ind.cmtes$committee_name)
) %>%
  mutate(
    party_align = case_when(
      # Democratic identifiers
      grepl("DEMOCRAT|DSCC|DCCC|DEM", pac_name, ignore.case = TRUE) ~ "Democrat",
      
      # Republican identifiers
      grepl("TRUMP|REPUBLICAN|NRCC|NRSC|RNC|TEAM RYAN|TED CRUZ|WINRED|MCCARTHY|BOEHNER|ROMNEY|CONSERVATIVE|TEA PARTY|GOP|DAINES|BARVE|RIFLE|GUN", pac_name, ignore.case = TRUE) ~ "Republican",
      grepl("GREAT AMERICA|STOP HILLARY|RYAN-NRCC|SENATE CONSERVATIVES|JOBS GROWTH AND FREEDOM FUND|RESPONSIBILITY AND FREEDOM|BOLTON PAC|MOONEY VICTORY", pac_name, ignore.case = TRUE) ~ "Republican",
      
      # Everyone else
      TRUE ~ "Other"
    )
  )

ind.cmtes <- left_join(ind.cmtes, cmtes, by = c("committee_name" = "pac_name"))
ind.cands <- ind.cands %>% 
  ungroup %>% 
  mutate(party_align = case_when(
    party == "200" ~ "Republican",
    party == "100" ~ "Democrat",
    TRUE ~ "Other"
  ))

ind.cmte.giving <- ind.cmtes %>% 
  ungroup %>% 
  group_by(network, year, party_align) %>% 
  summarize(total_ind_cmte_giving = sum(contribution_receipt_amount))

ind.cand.giving <- ind.cands %>% 
  ungroup %>% 
  group_by(network, year, party_align) %>% 
  summarize(total_ind_cand_giving = sum(contribution_receipt_amount))



# PAC contributions -------------------------------------------------------

sinclair.pac <- read_csv("data/donations/sinclair_pac.csv") %>% 
  select(recipient_name, recipient_committee_id, disbursement_amount, disbursement_date)

sinclair.pac.cands <- inner_join(sinclair.pac, cands.dist, by = c("recipient_committee_id" = "FEC.ID"))
sinclair.pac.pacs <- sinclair.pac %>% filter(!(recipient_committee_id %in% sinclair.pac.cands$recipient_committee_id))

nexstar.pac <- read_csv("data/donations/nexstar_pac.csv") %>% 
  select(recipient_name, recipient_committee_id, disbursement_amount, disbursement_date)

nexstar.pac.cands <- inner_join(nexstar.pac, cands.dist, by = c("recipient_committee_id" = "FEC.ID"))
nexstar.pac.pacs <- nexstar.pac %>% filter(!(recipient_committee_id %in% nexstar.pac.cands$recipient_committee_id))

## nexstar:
pacs <- c(
  "BIG EASY COMMITTEE",
  "LUJAN/LOBO VICTORY FUND",
  "GOODLATTE VICTORY COMMITTEE",
  "DONALD J. TRUMP FOR PRESIDENT, INC.",
  "TEAM RYAN",
  "WALDEN VICTORY FUND",
  "SCALISE LEADERSHIP FUND",
  "MCCARTHY VICTORY FUND",
  "MCCONNELL FOR MAJORITY LEADER COMMITTEE",
  "DURBIN VICTORY FUND",
  "TEAM JOYCE FOR PENNSYLVANIA",
  "GREG PENCE VICTORY",
  "LONG TEAM",
  "BRADY VICTORY FUND",
  "GREG PIERCE FOR CONGRESS COMMITTEE",
  "HOYER'S MAJORITY FUND"
)

party <- c(
  "Democrat",   # BIG EASY COMMITTEE (Landrieu/Jazz PAC/LA Dems JFC)
  "Democrat",   # LUJAN/LOBO VICTORY FUND (Sen. Ben Ray Luján)
  "Republican", # GOODLATTE VICTORY COMMITTEE (Rep. Bob Goodlatte)
  "Republican", # DONALD J. TRUMP FOR PRESIDENT, INC.
  "Republican", # TEAM RYAN (Speaker Paul Ryan JFC)
  "Republican", # WALDEN VICTORY FUND (Rep. Greg Walden)
  "Republican", # SCALISE LEADERSHIP FUND (Rep. Steve Scalise)
  "Republican", # MCCARTHY VICTORY FUND (Rep. Kevin McCarthy)
  "Republican", # MCCONNELL FOR MAJORITY LEADER COMMITTEE (Sen. Mitch McConnell)
  "Democrat",   # DURBIN VICTORY FUND (Sen. Dick Durbin)
  "Republican", # TEAM JOYCE FOR PENNSYLVANIA (Rep. John Joyce)
  "Republican", # GREG PENCE VICTORY (Rep. Greg Pence)
  "Republican", # LONG TEAM (Rep. Billy Long)
  "Republican", # BRADY VICTORY FUND (Rep. Kevin Brady)
  "Democrat",   # GREG PIERCE FOR CONGRESS COMMITTEE (AL-03 Dem, 2006)
  "Democrat"    # HOYER'S MAJORITY FUND (Rep. Steny Hoyer)
)

pac_parties <- tibble(
  pac = pacs,
  party = factor(party, levels = c("Republican", "Democrat", "Other"))
) %>% 
  rename(party_align = party)

nexstar.pac.pacs <- left_join(nexstar.pac.pacs, pac_parties, by = c("recipient_name" = "pac"))


##sinclair:

pacs <- c(
  "MCCONNELL VICTORY KENTUCKY",
  "HAGAN VICTORY FUND",
  "RIPLEY, CHRISTOPHER",
  "DSCC",
  "TEAM RYAN",
  "MCMORRIS RODGERS AMERICAN DREAM PROJECT; THE",
  "MIDWEST NORTH STARS",
  "HANSON, REBECCA JEAN",
  "ADAM KINZINGER - FUTURE 1ST COMMITTEE"
)

party <- c(
  "Republican", # MCCONNELL VICTORY KENTUCKY (Sen. Mitch McConnell, R-KY)
  "Democrat",   # HAGAN VICTORY FUND (Sen. Kay Hagan, D-NC)
  "Other",      # RIPLEY, CHRISTOPHER (CEO of Sinclair Broadcast Group, not a partisan PAC)
  "Democrat",   # DSCC (Democratic Senatorial Campaign Committee)
  "Republican", # TEAM RYAN (Speaker Paul Ryan, R-WI)
  "Republican", # MCMORRIS RODGERS AMERICAN DREAM PROJECT (Rep. Cathy McMorris Rodgers, R-WA)
  "Other",      # MIDWEST NORTH STARS (corporate/interest JFC, not clear partisan alignment)
  "Other",      # HANSON, REBECCA JEAN (individual filer, no partisan committee info)
  "Republican"  # ADAM KINZINGER - FUTURE 1ST COMMITTEE (Rep. Adam Kinzinger, R-IL; GOP but anti-Trump)
)

pac_parties <- tibble(
  pac = pacs,
  party = factor(party, levels = c("Republican", "Democrat", "Other"))
) %>% 
  rename(party_align = party)

sinclair.pac.pacs <- left_join(sinclair.pac.pacs, pac_parties, by = c("recipient_name" = "pac"))
sinclair.pac.pacs$network <- "sinclair"
sinclair.pac.cands$network <- "sinclair"

nexstar.pac.pacs$network <- "nexstar"
nexstar.pac.cands$network <- "nexstar"

sinclair.pac.cands <- sinclair.pac.cands %>% 
  mutate(party_align = case_when(
    party == "200" ~ "Republican",
    party == "100" ~ "Democrat",
    TRUE ~ "Other"
  ))

nexstar.pac.cands <- nexstar.pac.cands %>% 
  mutate(party_align = case_when(
    party == "200" ~ "Republican",
    party == "100" ~ "Democrat",
    TRUE ~ "Other"
  ))

pac.contribs <- bind_rows(nexstar.pac.cands, nexstar.pac.pacs, sinclair.pac.cands, sinclair.pac.pacs)

pac.contribs <- pac.contribs %>% 
  ungroup %>% 
  mutate(year = year(ymd(disbursement_date))) %>% 
  group_by(network, year, party_align) %>% 
  summarize(total_pac_giving = sum(disbursement_amount))



# summarize ---------------------------------------------------------------


giving <- full_join(ind.cand.giving, pac.contribs) %>% full_join(ind.cmte.giving)

giving <- giving %>% 
  mutate(across(c(total_ind_cand_giving, total_pac_giving, total_ind_cmte_giving), ~replace_na(.x, 0))) %>% 
  mutate(all_giving = total_ind_cand_giving + total_pac_giving + total_ind_cmte_giving)

giving <- giving %>% 
  ungroup %>% 
  mutate(network = str_to_sentence(network))

giving %>% 
  mutate(all_giving = all_giving/1000) %>% 
  ggplot(aes(x = year, y = all_giving, fill = party_align)) +
  geom_col() +
  facet_wrap(~network)  +
  scale_x_continuous(breaks = c(2010, 2012, 2014, 2016, 2018, 2020, 2022)) +
  scale_fill_manual(values = c("dodgerblue", "green4", "red4")) +
  theme_bw()

giving %>% 
  mutate(all_ind_giving = total_ind_cand_giving + total_ind_cmte_giving,
         all_ind_giving = all_ind_giving/1000) %>% 
  filter(year < 2022) %>% 
  ggplot(aes(x = year, y = all_ind_giving, fill = party_align)) +
  geom_col() +
  facet_wrap(~network, ncol=1)  +
  scale_x_continuous(breaks = c(2010, 2012, 2014, 2016, 2018, 2020)) +
  scale_fill_manual(values = c("dodgerblue", "green4", "red4")) +
  theme_bw() +
  theme(legend.title = element_blank()) +
  xlab("") +
  ylab("Amount Donated ($1000s)")

ggsave(file = "figures/rr_cand_giving.pdf", units = "in", width = 6, height = 6)


## just giving to individual candidates

giving %>% 
  mutate(all_ind_giving = total_ind_cand_giving ,
         all_ind_giving = all_ind_giving/1000) %>% 
  ggplot(aes(x = year, y = all_ind_giving, fill = party_align)) +
  geom_col() +
  facet_wrap(~network, ncol=1)  +
  scale_x_continuous(breaks = c(2010, 2012, 2014, 2016, 2018, 2020, 2022)) +
  scale_fill_manual(values = c("dodgerblue", "green4", "red4")) +
  theme_bw() +
  theme(legend.title = element_blank())



giving %>% 
  filter(network != "Gray") %>% 
  mutate(total_pac_giving = total_pac_giving/1000) %>% 
  ggplot(aes(x = year, y = total_pac_giving, fill = party_align)) +
  geom_col() +
  facet_wrap(~network, ncol=1)  +
  scale_x_continuous(breaks = c(2010, 2012, 2014, 2016, 2018, 2020, 2022)) +
  scale_fill_manual(values = c("dodgerblue", "green4", "red4")) +
  theme_bw() +
  theme(legend.title = element_blank()) +
  xlab("") +
  ylab("Amount Donated ($1000s)")

ggsave(file = "figures/rr_pac_giving.pdf", units = "in", width = 6, height = 4)
