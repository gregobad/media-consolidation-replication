## Builds the DMA-level file of market characteristics (data/geo/dma_demos.csv) used as predictors
## in the acquisition-propensity analysis of the appendix (Appendix Figure on post-LASSO estimates and
## Appendix Table on within-market acquisition propensity).
##
## Inputs: NHGIS 2010 Census / 2006-2010 ACS county extracts (data/geo/census/), county-to-DMA crosswalk
## (data/geo/cty2DMA.RData), MIT Election Lab county presidential returns (data/elections/),
## newspaper circulation per capita (data/newspapers/), and two files NOT included in this archive:
##   - data/tv/ads2010_market_agg.rds   (2010 advertising price per impression by market; derived from
##                                       proprietary Nielsen Ad Intel data)
##   - data/acquisitions/acquisition_panel_station_FINAL.dta (an earlier, five-group version of the
##                                       acquisition panel; used only to count stations per DMA)
## The output file data/geo/dma_demos.csv IS included, so this script is provided for documentation.

### SET WORKING DIRECTORY HERE
path_to_archive <- "/path/to/replication"
setwd(path_to_archive)

library(tidyverse)

keep <- c("GISJOIN", "STATEA", "COUNTYA", "STATE", "COUNTY")

census1 <- read_csv("data/geo/census/nhgis0018_ds172_2010_county.csv") 

## census1 variables:

census1.vars <- c(
"H7V001",      #Total
"H7W002",      #Urban
"H7W005",      #Rural
"H7X002",      #White alone
"H7X003",      #Black or African American alone
"H7X004",      #American Indian and Alaska Native alone
"H7X005",      #Asian alone
"H7X006",      #Native Hawaiian and Other Pacific Islander alone

#Table 2:
"IFE001",      #Total Housing Units
"IFE002",      #Occupied Housing Units
"IFE003"      #Vacant Housing Units
)

census1 <- census1 %>% select(all_of(c(keep, census1.vars)))



census1.varsdf <- data.frame(var = c(
  "H7V001-Total Population",
  "H7W002-Urban",
  "H7W005-Rural",
  "H7X002-White alone",
  "H7X003-Black or African American alone",
  "H7X004-American Indian and Alaska Nativ",
  "H7X005-Asian alone",
  "H7X006-Native Hawaiian and Other Pacifi",
  "IFE001-Total Housing Units",
  "IFE002-Occupied Housing Units",
  "IFE003-Vacant Housing Units"
)) %>% 
  separate(var, sep = "-", into = c("var", "definition"))


# join in DMA info:
load("data/geo/cty2DMA.RData")
dmacty <- ungroup(dmacty) %>% filter(year == 2010) %>% 
  select(statefips, countyfips, DMA, vote_allocation)

census1 <- left_join(census1, dmacty, by = c("STATEA" = "statefips", "COUNTYA" = "countyfips"))
## a few counties are split (use vote_allocation to adjust)


# aggregate at DMA level:
census1 <- census1 %>% 
  mutate_at(vars(H7V001:IFE003), ~.*vote_allocation) %>% 
  group_by(DMA) %>% 
  summarize_at(vars(H7V001:IFE003), sum)

# create percentages
census1 <- census1 %>% 
  ungroup %>% 
  mutate_at(vars(H7W002:H7X006), ~./H7V001) %>% 
  mutate_at(vars(IFE002:IFE003), ~./IFE001)


# second census file ------------------------------------------------------



census2 <- read_csv("data/geo/census/nhgis0018_ds176_20105_county.csv")

## census 2 variables


census2.vars <- c(
"JLZE001",     #Total Population
"JLZE002",     #Male
"JLZE026",     #Female

#Table 2:     Travel Time to Work
#Universe:    Workers 16 years and over who did not work at home
"JM2E001",     #Total Workers 16 years and over
"JM2E002",     #Less than 5 minutes
"JM2E003",     #5 to 9 minutes
"JM2E004",     #10 to 14 minutes
"JM2E005",     #15 to 19 minutes
"JM2E006",     #20 to 24 minutes
"JM2E007",     #25 to 29 minutes
"JM2E008",     #30 to 34 minutes
"JM2E009",     #35 to 39 minutes
"JM2E010",     #40 to 44 minutes
"JM2E011",     #45 to 59 minutes
"JM2E012",     #60 to 89 minutes
"JM2E013",     #90 or more minutes

#Table 3:     Household Type (Including Living Alone)
#Universe:    Households
"JM5E001",     #Total Households
"JM5E002",     #Family households
"JM5E003",     #Family households: Married-couple family
"JM5E004",     #Family households: Other family
"JM5E005",     #Family households: Other family: Male householder, no wife present
"JM5E006",     #Family households: Other family: Female householder, no husband present
"JM5E007",     #Nonfamily households
"JM5E008",     #Nonfamily households: Householder living alone
"JM5E009",     #Nonfamily households: Householder not living alone

#Table 4:     Sex by Educational Attainment for the Population 25 Years and Over
#Universe:    Population 25 years and over
"JN9E001",     #Total Population 25 years and over
"JN9E002",     #Male
"JN9E003",     #Male: No schooling completed
"JN9E004",     #Male: Nursery to 4th grade
"JN9E005",     #Male: 5th and 6th grade
"JN9E006",     #Male: 7th and 8th grade
"JN9E007",     #Male: 9th grade
"JN9E008",     #Male: 10th grade
"JN9E009",     #Male: 11th grade
"JN9E010",     #Male: 12th grade, no diploma
"JN9E011",     #Male: High school graduate, GED, or alternative
"JN9E012",     #Male: Some college, less than 1 year
"JN9E013",     #Male: Some college, 1 or more years, no degree
"JN9E014",     #Male: Associate's degree
"JN9E015",     #Male: Bachelor's degree
"JN9E016",     #Male: Master's degree
"JN9E017",     #Male: Professional school degree
"JN9E018",     #Male: Doctorate degree
"JN9E019",     #Female
"JN9E020",     #Female: No schooling completed
"JN9E021",     #Female: Nursery to 4th grade
"JN9E022",     #Female: 5th and 6th grade
"JN9E023",     #Female: 7th and 8th grade
"JN9E024",     #Female: 9th grade
"JN9E025",     #Female: 10th grade
"JN9E026",     #Female: 11th grade
"JN9E027",     #Female: 12th grade, no diploma
"JN9E028",     #Female: High school graduate, GED, or alternative
"JN9E029",     #Female: Some college, less than 1 year
"JN9E030",     #Female: Some college, 1 or more years, no degree
"JN9E031",     #Female: Associate's degree
"JN9E032",     #Female: Bachelor's degree
"JN9E033",     #Female: Master's degree
"JN9E034",     #Female: Professional school degree
"JN9E035",     #Female: Doctorate degree

#Table 5:     Ratio of Income to Poverty Level in the Past 12 Months
#Universe:    Population for whom poverty status is determined
"JOCE001",     #Total Population for whom poverty status is determined
"JOCE002",     #Under .50
"JOCE003",     #.50 to .99
"JOCE004",     #1.00 to 1.24
"JOCE005",     #1.25 to 1.49
"JOCE006",     #1.50 to 1.84
"JOCE007",     #1.85 to 1.99
"JOCE008",     #2.00 and over

#Table 5.1 Household stuff
"JOIE001",     #Median household income in the past 12 months (in 2010 inflation-adjusted dollars)
"JQBE001",     #Per capita income in the past 12 months (in 2010 inflation-adjusted dollars)

#Table 8:     Tenure
#Universe:    Occupied housing units
"JRKE001",     #Total Occupied housing units
"JRKE002",     #Owner occupied
"JRKE003",     #Renter occupied

#Table 9:     Rent / value
"JS5E001",     #Median gross rent
"JTIE001"     #Median value (dollars) Owner-occupied housing units
)

census2 <- census2 %>% select(all_of(c(keep, census2.vars)))



census2.varsdf <- data.frame(
  var = c(
    "JLZE001-Total Population",
    "JLZE002-Male",
    "JLZE026-Female",
    "JM2E001-Total Workers 16 years and over",
    "JM2E002-Less than 5 minutes",
    "JM2E003-5 to 9 minutes",
    "JM2E004-10 to 14 minutes",
    "JM2E005-15 to 19 minutes",
    "JM2E006-20 to 24 minutes",
    "JM2E007-25 to 29 minutes",
    "JM2E008-30 to 34 minutes",
    "JM2E009-35 to 39 minutes",
    "JM2E010-40 to 44 minutes",
    "JM2E011-45 to 59 minutes",
    "JM2E012-60 to 89 minutes",
    "JM2E013-90 or more minutes",
    "JM5E001-Total Households",
    "JM5E002-Family households",
    "JM5E003-Family households: Married-couple family",
    "JM5E004-Family households: Other family",
    "JM5E005-Family households: Other family: Male householder, no wife present",
    "JM5E006-Family households: Other family: Female householder, no husband present",
    "JM5E007-Nonfamily households",
    "JM5E008-Nonfamily households: Householder living alone",
    "JM5E009-Nonfamily households: Householder not living alone",
    "JN9E001-Total Population 25 years and over",
    "JN9E002-Male",
    "JN9E003-Male: No schooling completed",
    "JN9E004-Male: Nursery to 4th grade",
    "JN9E005-Male: 5th and 6th grade",
    "JN9E006-Male: 7th and 8th grade",
    "JN9E007-Male: 9th grade",
    "JN9E008-Male: 10th grade",
    "JN9E009-Male: 11th grade",
    "JN9E010-Male: 12th grade, no diploma",
    "JN9E011-Male: High school graduate, GED, or alternative",
    "JN9E012-Male: Some college, less than 1 year",
    "JN9E013-Male: Some college, 1 or more years, no degree",
    "JN9E014-Male: Associate's degree",
    "JN9E015-Male: Bachelor's degree",
    "JN9E016-Male: Master's degree",
    "JN9E017-Male: Professional school degree",
    "JN9E018-Male: Doctorate degree",
    "JN9E019-Female",
    "JN9E020-Female: No schooling completed",
    "JN9E021-Female: Nursery to 4th grade",
    "JN9E022-Female: 5th and 6th grade",
    "JN9E023-Female: 7th and 8th grade",
    "JN9E024-Female: 9th grade",
    "JN9E025-Female: 10th grade",
    "JN9E026-Female: 11th grade",
    "JN9E027-Female: 12th grade, no diploma",
    "JN9E028-Female: High school graduate, GED, or alternative",
    "JN9E029-Female: Some college, less than 1 year",
    "JN9E030-Female: Some college, 1 or more years, no degree",
    "JN9E031-Female: Associate's degree",
    "JN9E032-Female: Bachelor's degree",
    "JN9E033-Female: Master's degree",
    "JN9E034-Female: Professional school degree",
    "JN9E035-Female: Doctorate degree",
    "JOCE001-Total Population for whom poverty status is determined",
    "JOCE002-Under .50",
    "JOCE003-.50 to .99",
    "JOCE004-1.00 to 1.24",
    "JOCE005-1.25 to 1.49",
    "JOCE006-1.50 to 1.84",
    "JOCE007-1.85 to 1.99",
    "JOCE008-2.00 and over",
    "JOIE001-Median household income in the past 12 months (in 2010 inflation-adjusted dollars)",
    "JQBE001-Per capita income in the past 12 months (in 2010 inflation-adjusted dollars)",
    "JRKE001-Total Occupied housing units",
    "JRKE002-Owner occupied",
    "JRKE003-Renter occupied",
    "JS5E001-Median gross rent",
    "JTIE001-Median value (dollars) Owner-occupied housing units"
  )
) %>% 
  separate(var, sep = "-", into = c("var", "definition"))


census2 <- left_join(census2, dmacty, by = c("STATEA" = "statefips", "COUNTYA" = "countyfips"))
## a few counties are split (use vote_allocation to adjust)


# aggregate at DMA level:
census2.1 <- census2 %>% 
  mutate_at(vars(JLZE001:JOCE008, JRKE001:JRKE003), ~.*vote_allocation) %>% 
  group_by(DMA) %>% 
  summarize_at(vars(JLZE001:JOCE008, JRKE001:JRKE003), sum)

census2.2 <- census2 %>% 
  group_by(DMA) %>% 
  summarize_at(vars(JOIE001, JQBE001, JS5E001, JTIE001), mean)

census2 <- left_join(census2.1, census2.2)

census2 <- census2 %>% 
  mutate_at(vars(JLZE002, JLZE026), ~./JLZE001) %>% 
  mutate_at(vars(JM2E002:JM2E013), ~./JM2E001) %>% 
  mutate_at(vars(JM5E002:JM5E009), ~./JM5E001) %>% 
  mutate_at(vars(JN9E002:JN9E035), ~./JN9E001) %>% 
  mutate_at(vars(JOCE002:JOCE008), ~./JOCE001) %>% 
  mutate_at(vars(JRKE002, JRKE003), ~./JRKE001)

# third census file -------------------------------------------------------


census3 <- read_csv("data/geo/census/nhgis0018_ds177_20105_county.csv")

# create male and female above 16 and 19 labor force participation aggregates


census3.vars <- data.frame(
  var = c(
  "J6QE001-Total",
  "J6QE002-Male",
  "J6QE003-Male: 16 to 19 years",
  "J6QE004-Male: 16 to 19 years: In labor force",
  "J6QE005-Male: 16 to 19 years: In labor force: In Armed Forces",
  "J6QE006-Male: 16 to 19 years: In labor force: Civilian",
  "J6QE007-Male: 16 to 19 years: In labor force: Civilian: Emplo",
  "J6QE008-Male: 16 to 19 years: In labor force: Civilian: Unemp",
  "J6QE009-Male: 16 to 19 years: Not in labor force",
  "J6QE010-Male: 20 and 21 years",
  "J6QE011-Male: 20 and 21 years: In labor force",
  "J6QE012-Male: 20 and 21 years: In labor force: In Armed Force",
  "J6QE013-Male: 20 and 21 years: In labor force: Civilian",
  "J6QE014-Male: 20 and 21 years: In labor force: Civilian: Empl",
  "J6QE015-Male: 20 and 21 years: In labor force: Civilian: Unem",
  "J6QE016-Male: 20 and 21 years: Not in labor force",
  "J6QE017-Male: 22 to 24 years",
  "J6QE018-Male: 22 to 24 years: In labor force",
  "J6QE019-Male: 22 to 24 years: In labor force: In Armed Forces",
  "J6QE020-Male: 22 to 24 years: In labor force: Civilian",
  "J6QE021-Male: 22 to 24 years: In labor force: Civilian: Emplo",
  "J6QE022-Male: 22 to 24 years: In labor force: Civilian: Unemp",
  "J6QE023-Male: 22 to 24 years: Not in labor force",
  "J6QE024-Male: 25 to 29 years",
  "J6QE025-Male: 25 to 29 years: In labor force",
  "J6QE026-Male: 25 to 29 years: In labor force: In Armed Forces",
  "J6QE027-Male: 25 to 29 years: In labor force: Civilian",
  "J6QE028-Male: 25 to 29 years: In labor force: Civilian: Emplo",
  "J6QE029-Male: 25 to 29 years: In labor force: Civilian: Unemp",
  "J6QE030-Male: 25 to 29 years: Not in labor force",
  "J6QE031-Male: 30 to 34 years",
  "J6QE032-Male: 30 to 34 years: In labor force",
  "J6QE033-Male: 30 to 34 years: In labor force: In Armed Forces",
  "J6QE034-Male: 30 to 34 years: In labor force: Civilian",
  "J6QE035-Male: 30 to 34 years: In labor force: Civilian: Emplo",
  "J6QE036-Male: 30 to 34 years: In labor force: Civilian: Unemp",
  "J6QE037-Male: 30 to 34 years: Not in labor force",
  "J6QE038-Male: 35 to 44 years",
  "J6QE039-Male: 35 to 44 years: In labor force",
  "J6QE040-Male: 35 to 44 years: In labor force: In Armed Forces",
  "J6QE041-Male: 35 to 44 years: In labor force: Civilian",
  "J6QE042-Male: 35 to 44 years: In labor force: Civilian: Emplo",
  "J6QE043-Male: 35 to 44 years: In labor force: Civilian: Unemp",
  "J6QE044-Male: 35 to 44 years: Not in labor force",
  "J6QE045-Male: 45 to 54 years",
  "J6QE046-Male: 45 to 54 years: In labor force",
  "J6QE047-Male: 45 to 54 years: In labor force: In Armed Forces",
  "J6QE048-Male: 45 to 54 years: In labor force: Civilian",
  "J6QE049-Male: 45 to 54 years: In labor force: Civilian: Emplo",
  "J6QE050-Male: 45 to 54 years: In labor force: Civilian: Unemp",
  "J6QE051-Male: 45 to 54 years: Not in labor force",
  "J6QE052-Male: 55 to 59 years",
  "J6QE053-Male: 55 to 59 years: In labor force",
  "J6QE054-Male: 55 to 59 years: In labor force: In Armed Forces",
  "J6QE055-Male: 55 to 59 years: In labor force: Civilian",
  "J6QE056-Male: 55 to 59 years: In labor force: Civilian: Emplo",
  "J6QE057-Male: 55 to 59 years: In labor force: Civilian: Unemp",
  "J6QE058-Male: 55 to 59 years: Not in labor force",
  "J6QE059-Male: 60 and 61 years",
  "J6QE060-Male: 60 and 61 years: In labor force",
  "J6QE061-Male: 60 and 61 years: In labor force: In Armed Force",
  "J6QE062-Male: 60 and 61 years: In labor force: Civilian",
  "J6QE063-Male: 60 and 61 years: In labor force: Civilian: Empl",
  "J6QE064-Male: 60 and 61 years: In labor force: Civilian: Unem",
  "J6QE065-Male: 60 and 61 years: Not in labor force",
  "J6QE066-Male: 62 to 64 years",
  "J6QE067-Male: 62 to 64 years: In labor force",
  "J6QE068-Male: 62 to 64 years: In labor force: In Armed Forces",
  "J6QE069-Male: 62 to 64 years: In labor force: Civilian",
  "J6QE070-Male: 62 to 64 years: In labor force: Civilian: Emplo",
  "J6QE071-Male: 62 to 64 years: In labor force: Civilian: Unemp",
  "J6QE072-Male: 62 to 64 years: Not in labor force",
  "J6QE073-Male: 65 to 69 years",
  "J6QE074-Male: 65 to 69 years: In labor force",
  "J6QE075-Male: 65 to 69 years: In labor force: Employed",
  "J6QE076-Male: 65 to 69 years: In labor force: Unemployed",
  "J6QE077-Male: 65 to 69 years: Not in labor force",
  "J6QE078-Male: 70 to 74 years",
  "J6QE079-Male: 70 to 74 years: In labor force",
  "J6QE080-Male: 70 to 74 years: In labor force: Employed",
  "J6QE081-Male: 70 to 74 years: In labor force: Unemployed",
  "J6QE082-Male: 70 to 74 years: Not in labor force",
  "J6QE083-Male: 75 years and over",
  "J6QE084-Male: 75 years and over: In labor force",
  "J6QE085-Male: 75 years and over: In labor force: Employed",
  "J6QE086-Male: 75 years and over: In labor force: Unemployed",
  "J6QE087-Male: 75 years and over: Not in labor force",
  "J6QE088-Female",
  "J6QE089-Female: 16 to 19 years",
  "J6QE090-Female: 16 to 19 years: In labor force",
  "J6QE091-Female: 16 to 19 years: In labor force: In Armed Forc",
  "J6QE092-Female: 16 to 19 years: In labor force: Civilian",
  "J6QE093-Female: 16 to 19 years: In labor force: Civilian: Emp",
  "J6QE094-Female: 16 to 19 years: In labor force: Civilian: Une",
  "J6QE095-Female: 16 to 19 years: Not in labor force",
  "J6QE096-Female: 20 and 21 years",
  "J6QE097-Female: 20 and 21 years: In labor force",
  "J6QE098-Female: 20 and 21 years: In labor force: In Armed For",
  "J6QE099-Female: 20 and 21 years: In labor force: Civilian",
  "J6QE100-Female: 20 and 21 years: In labor force: Civilian: Em",
  "J6QE101-Female: 20 and 21 years: In labor force: Civilian: Un",
  "J6QE102-Female: 20 and 21 years: Not in labor force",
  "J6QE103-Female: 22 to 24 years",
  "J6QE104-Female: 22 to 24 years: In labor force",
  "J6QE105-Female: 22 to 24 years: In labor force: In Armed Forc",
  "J6QE106-Female: 22 to 24 years: In labor force: Civilian",
  "J6QE107-Female: 22 to 24 years: In labor force: Civilian: Emp",
  "J6QE108-Female: 22 to 24 years: In labor force: Civilian: Une",
  "J6QE109-Female: 22 to 24 years: Not in labor force",
  "J6QE110-Female: 25 to 29 years",
  "J6QE111-Female: 25 to 29 years: In labor force",
  "J6QE112-Female: 25 to 29 years: In labor force: In Armed Forc",
  "J6QE113-Female: 25 to 29 years: In labor force: Civilian",
  "J6QE114-Female: 25 to 29 years: In labor force: Civilian: Emp",
  "J6QE115-Female: 25 to 29 years: In labor force: Civilian: Une",
  "J6QE116-Female: 25 to 29 years: Not in labor force",
  "J6QE117-Female: 30 to 34 years",
  "J6QE118-Female: 30 to 34 years: In labor force",
  "J6QE119-Female: 30 to 34 years: In labor force: In Armed Forc",
  "J6QE120-Female: 30 to 34 years: In labor force: Civilian",
  "J6QE121-Female: 30 to 34 years: In labor force: Civilian: Emp",
  "J6QE122-Female: 30 to 34 years: In labor force: Civilian: Une",
  "J6QE123-Female: 30 to 34 years: Not in labor force",
  "J6QE124-Female: 35 to 44 years",
  "J6QE125-Female: 35 to 44 years: In labor force",
  "J6QE126-Female: 35 to 44 years: In labor force: In Armed Forc",
  "J6QE127-Female: 35 to 44 years: In labor force: Civilian",
  "J6QE128-Female: 35 to 44 years: In labor force: Civilian: Emp",
  "J6QE129-Female: 35 to 44 years: In labor force: Civilian: Une",
  "J6QE130-Female: 35 to 44 years: Not in labor force",
  "J6QE131-Female: 45 to 54 years",
  "J6QE132-Female: 45 to 54 years: In labor force",
  "J6QE133-Female: 45 to 54 years: In labor force: In Armed Forc",
  "J6QE134-Female: 45 to 54 years: In labor force: Civilian",
  "J6QE135-Female: 45 to 54 years: In labor force: Civilian: Emp",
  "J6QE136-Female: 45 to 54 years: In labor force: Civilian: Une",
  "J6QE137-Female: 45 to 54 years: Not in labor force",
  "J6QE138-Female: 55 to 59 years",
  "J6QE139-Female: 55 to 59 years: In labor force",
  "J6QE140-Female: 55 to 59 years: In labor force: In Armed Forc",
  "J6QE141-Female: 55 to 59 years: In labor force: Civilian",
  "J6QE142-Female: 55 to 59 years: In labor force: Civilian: Emp",
  "J6QE143-Female: 55 to 59 years: In labor force: Civilian: Une",
  "J6QE144-Female: 55 to 59 years: Not in labor force",
  "J6QE145-Female: 60 and 61 years",
  "J6QE146-Female: 60 and 61 years: In labor force",
  "J6QE147-Female: 60 and 61 years: In labor force: In Armed For",
  "J6QE148-Female: 60 and 61 years: In labor force: Civilian",
  "J6QE149-Female: 60 and 61 years: In labor force: Civilian: Em",
  "J6QE150-Female: 60 and 61 years: In labor force: Civilian: Un",
  "J6QE151-Female: 60 and 61 years: Not in labor force",
  "J6QE152-Female: 62 to 64 years",
  "J6QE153-Female: 62 to 64 years: In labor force",
  "J6QE154-Female: 62 to 64 years: In labor force: In Armed Forc",
  "J6QE155-Female: 62 to 64 years: In labor force: Civilian",
  "J6QE156-Female: 62 to 64 years: In labor force: Civilian: Emp",
  "J6QE157-Female: 62 to 64 years: In labor force: Civilian: Une",
  "J6QE158-Female: 62 to 64 years: Not in labor force",  "J6QE159-Female: 65 to 69 years",
  "J6QE160-Female: 65 to 69 years: In labor force",
  "J6QE161-Female: 65 to 69 years: In labor force: Employed",
  "J6QE162-Female: 65 to 69 years: In labor force: Unemployed",
  "J6QE163-Female: 65 to 69 years: Not in labor force",
  "J6QE164-Female: 70 to 74 years",
  "J6QE165-Female: 70 to 74 years: In labor force",
  "J6QE166-Female: 70 to 74 years: In labor force: Employed",
  "J6QE167-Female: 70 to 74 years: In labor force: Unemployed",
  "J6QE168-Female: 70 to 74 years: Not in labor force",
  "J6QE169-Female: 75 years and over",
  "J6QE170-Female: 75 years and over: In labor force",
  "J6QE171-Female: 75 years and over: In labor force: Employed",
  "J6QE172-Female: 75 years and over: In labor force: Unemployed",
  "J6QE173-Female: 75 years and over: Not in labor force"
  )
  
) %>% 
  separate(var, sep = "-", into = c("var", "definition"))

male.vars <- census3.vars %>% 
  filter(word(definition, 1) == "Male:" & str_detect(definition, "Not"))

female.vars <- census3.vars %>% 
  filter(word(definition, 1) == "Female:" & str_detect(definition, "Not"))

census3 <- left_join(census3, dmacty, by = c("STATEA" = "statefips", "COUNTYA" = "countyfips"))
## a few counties are split (use vote_allocation to adjust)


# aggregate at DMA level:
census3.1 <- census3 %>% 
  mutate_at(vars(J6QE001:J6QE173), ~.*vote_allocation) %>% 
  group_by(DMA) %>% 
  summarize_at(vars(J6QE001:J6QE173), sum)

census3.1 <- census3.1 %>% 
  ungroup %>% 
  mutate(male_labor_total = rowSums(across(all_of(male.vars$var))),
         female_labor_total = rowSums(across(all_of(female.vars$var))))

census3.1 <- census3.1 %>% 
  mutate(male_not_labor = male_labor_total/J6QE002,
         female_not_labor = female_labor_total/J6QE088) %>% 
  select(DMA, male_16_over = J6QE002, female_16_over = J6QE088, male_not_labor, female_not_labor)

census3.2 <- census3 %>% 
  select(DMA, gini = J4TE001) %>% 
  group_by(DMA) %>% 
  summarize(gini = mean(gini))

census3 <- left_join(census3.1, census3.2)

#  mutate(sumrow = rowSums(pick(x1:x5), na.rm = T))
census.varsdf <- bind_rows(census1.varsdf, census2.varsdf, census3.vars)

census.final <- left_join(census1, census2) %>% left_join(census3) %>% filter(!is.na(DMA))

write_rds(census.final, file = "data/geo/census/census_final.rds")
write_csv(census.varsdf, file = "data/geo/census/census_vars.csv")


## add in political stuff

elec <- read_csv("data/elections/countypres_2000-2020.csv") %>% 
  filter(year == 2012) %>% 
  select(county_fips, office, party, candidatevotes, totalvotes) %>% 
  ungroup %>% 
  mutate(party = str_to_lower(party))# %>% 
  #mutate(vote = candidatevotes/totalvotes)f

elec <- elec %>% 
  filter(!is.na(county_fips)) %>% 
  select(county_fips, party, totalvotes, candidatevotes) %>% 
  pivot_wider(names_from = party, values_from = candidatevotes)

elec <- left_join(
  elec,
  dmacty %>% mutate(county_fips = paste(statefips, countyfips, sep="")) %>% 
    select(county_fips, DMA, vote_allocation)
)

elec <- elec %>% 
  mutate_at(vars(totalvotes:other), ~.*vote_allocation) %>% 
  group_by(DMA) %>% 
  summarize_at(vars(totalvotes:other), ~sum(., na.rm=T)) %>% 
  mutate(d_vote = democrat/totalvotes,
         r_vote = republican/totalvotes,
         o_vote = other/totalvotes) %>% 
  filter(!is.na(DMA))

## final:

dma_demos <- census.final %>% left_join(elec)

## add in ad prices:
ads <- read_rds("data/tv/ads2010_market_agg.rds")


demos <- left_join(demos, ads %>% mutate(dmacode = as.character(dmacode)), by = c("DMA" = "dmacode"))

# write_rds(dma_demos, file = "data/geo/dema_demos.rds")


# newspapers --------------------------------------------------------------

demos <- read_rds("data/geo/dema_demos.rds")

circ <- read_csv("data/newspapers/circulation_per_capita_2010.csv")

load("data/geo/cty2DMA.RData")
dmacty <- ungroup(dmacty) %>% filter(year == 2010) 

dmacty <- dmacty %>% 
  ungroup %>% 
  mutate(merge_fips = paste(as.numeric(statefips), countyfips, sep="")) %>% 
  group_by(merge_fips) %>% 
  arrange(desc(vote_allocation)) %>% 
  filter(row_number()==1) %>% 
  select(merge_fips, DMA)

circ <- inner_join(circ, dmacty %>% mutate(merge_fips = as.numeric(merge_fips)), by = c("fips" = "merge_fips"))
circ <- circ %>% 
  ungroup %>% 
  group_by(DMA) %>% 
  summarize(total_circ_pc_2010 = mean(total_circ_pc_2010, na.rm=T))


acqs <- haven::read_dta("data/acquisitions/acquisition_panel_station_FINAL.dta")

acqs <- acqs %>% 
  ungroup %>% 
  group_by(callsign) %>% 
  arrange(date) %>% 
  filter(row_number()==1) %>% 
  ungroup %>% 
  group_by(dmacode) %>% 
  summarize(num_stations = n())

demos <- left_join(demos %>% mutate(DMA = as.numeric(DMA)), acqs, by = c("DMA" = "dmacode"))
demos <- left_join(demos, circ %>% mutate(DMA = as.numeric(DMA)))

write_csv(demos, file = "data/geo/dma_demos.csv")
