library(tidycensus)
library(tidyverse)
library(sf)
library(mapview)
library(tigris)

census_api_key(Sys.getenv("CENSUS_API_KEY"))

year = 2023
austin_msa_counties <- c("Bastrop", "Caldwell", "Hays", "Travis", "Williamson")

update_map <- function(year){

#List of ACS variables
map_vars <- c(
  Total_Pop = "S0101_C01_001",
  MedianAge = "S0101_C01_032",
  PercPlus65 = "S0101_C02_030",
  MedianHouseholdIncome = "S1901_C01_012",
  NHWhite = "DP05_0082",
  NHBlack = "DP05_0083",
  NH_AIAN = "DP05_0084",
  NHAsian = "DP05_0085",
  NH_NHPI = "DP05_0086",
  NHOther = "DP05_0087",
  NHMultiracial = "DP05_0088",
  Hispanic = "DP05_0076",
  PctFamBelowPov = "S1702_C02_001")

#Query for ACS 5-year data for the tracts in the five-county Austin MSA
#5-year ACS is needed for tracts because 1-year is only reported for geographies with over 65,000 people
austin_data_tracts <- get_acs(
  geography = "tract",
  variables = map_vars,
  year = year,
  state = "TX",
  county = austin_msa_counties,
  output = "wide",
  survey = "acs5"
)

#Query for the geographic boundaries of the tracts in the five-county Austin MSA
austin_tracts_geo <- tracts(state = "TX", county = austin_msa_counties, year = year, cb = FALSE)

#Calcualte CV and Percentages
data_clean_tracts <- austin_data_tracts |>
  mutate(PercWhite = round(((NHWhiteE/Total_PopE)*100), digits = 1),
         PercBlack = round(((NHBlackE/Total_PopE)*100), digits = 1),
         PercAsian = round(((NHAsianE/Total_PopE)*100), digits = 1),
         PercHisp = round(((HispanicE/Total_PopE)*100), digits = 1),
         NHWhiteCV = round((NHWhiteM/(1.645*NHWhiteE)*100), digits = 1),
         NHBlackCV = round((NHBlackM/(1.645*NHBlackE)*100), digits = 1),
         NHAIANCV = round((NH_AIANM/(1.645*NH_AIANE)*100), digits = 1),
         NHAsianCV = round((NHAsianM/(1.645*NHAsianE)*100), digits = 1),
         NHNHPICV = round((NH_NHPIM/(1.645*NH_NHPIE)*100), digits = 1),
         NHOtherCV = round((NHOtherM/(1.645*NHOtherE)*100), digits = 1),
         NHMultiracialCV = round((NHMultiracialM/(1.645*NHMultiracialE)*100), digits = 1),
         HispanicCV = round((HispanicM/(1.645*HispanicE)*100), digits = 1)
  )

return(data_clean_tracts)

}

#Uncomment to run just this script
#update_map(year = year)
