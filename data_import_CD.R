library(tidycensus)
library(tidyverse)
library(sf)
library(mapview)
library(tigris)
library(readxl)
library(writexl)
library(data.table)

census_api_key(Sys.getenv("CENSUS_API_KEY"))

year = 2024
austin_msa_counties <- c("Bastrop", "Caldwell", "Hays", "Travis", "Williamson")

update_data_cd <- function(year){

#List of ACS variables
profile_varsCD <- c(
  
  #Population
  Total_Pop = "S0101_C01_001",
  TotalFBandNB = "B05002_001",
  TotalFB = "B05002_013",
  VeteranUniverse = "S2101_C01_001",
  Veterans = "S2101_C03_001",
  Plus65 = "S0101_C01_030",
  Under18 = "S0101_C01_022",
  
  #Population by Race/Ethnicity
  NHWhite = "DP05_0082",
  NHBlack = "DP05_0083",
  NH_AIAN = "DP05_0084",
  NHAsian = "DP05_0085",
  NH_NHPI = "DP05_0086",
  NHOther = "DP05_0087",
  NHMultiracial = "DP05_0088",
  Hispanic = "DP05_0076",
  
  #Population by Age
  MaleUnder_5_years = "S0101_C03_002",
  Male5_to_9_years = "S0101_C03_003",
  Male10_to_14_years = "S0101_C03_004",
  Male15_to_19_years = "S0101_C03_005",
  Male20_to_24_years = "S0101_C03_006",
  Male25_to_29_years = "S0101_C03_007",
  Male30_to_34_years = "S0101_C03_008",
  Male35_to_39_years = "S0101_C03_009",
  Male40_to_44_years = "S0101_C03_010",
  Male45_to_49_years = "S0101_C03_011",
  Male50_to_54_years = "S0101_C03_012",
  Male55_to_59_years = "S0101_C03_013",
  Male60_to_64_years = "S0101_C03_014",
  Male65_to_69_years = "S0101_C03_015",
  Male70_to_74_years = "S0101_C03_016",
  Male75_to_79_years = "S0101_C03_017",
  Male80_to_84_years = "S0101_C03_018",
  Male85_years_and_over = "S0101_C03_019",
  FemaleUnder_5_years = "S0101_C05_002",
  Female5_to_9_years = "S0101_C05_003",
  Female10_to_14_years = "S0101_C05_004",
  Female15_to_19_years = "S0101_C05_005",
  Female20_to_24_years = "S0101_C05_006",
  Female25_to_29_years = "S0101_C05_007",
  Female30_to_34_years = "S0101_C05_008",
  Female35_to_39_years = "S0101_C05_009",
  Female40_to_44_years = "S0101_C05_010",
  Female45_to_49_years = "S0101_C05_011",
  Female50_to_54_years = "S0101_C05_012",
  Female55_to_59_years = "S0101_C05_013",
  Female60_to_64_years = "S0101_C05_014",
  Female65_to_69_years = "S0101_C05_015",
  Female70_to_74_years = "S0101_C05_016",
  Female75_to_79_years = "S0101_C05_017",
  Female80_to_84_years = "S0101_C05_018",
  Female85_years_and_over = "S0101_C05_019",
  TotalUnder_5_years = "S0101_C01_002",
  Total5_to_9_years = "S0101_C01_003",
  Total10_to_14_years = "S0101_C01_004",
  Total15_to_19_years = "S0101_C01_005",
  Total20_to_24_years = "S0101_C01_006",
  Total25_to_29_years = "S0101_C01_007",
  Total30_to_34_years = "S0101_C01_008",
  Total35_to_39_years = "S0101_C01_009",
  Total40_to_44_years = "S0101_C01_010",
  Total45_to_49_years = "S0101_C01_011",
  Total50_to_54_years = "S0101_C01_012",
  Total55_to_59_years = "S0101_C01_013",
  Total60_to_64_years = "S0101_C01_014",
  Total65_to_69_years = "S0101_C01_015",
  Total70_to_74_years = "S0101_C01_016",
  Total75_to_79_years = "S0101_C01_017",
  Total80_to_84_years = "S0101_C01_018",
  Total85_years_and_over = "S0101_C01_019",
  
  #Income
  HHTotal = "B19001_001",
  HHLess10k = "B19001_002",
  HH10kto14999 = "B19001_003",
  HH15kto19999 = "B19001_004",
  HH20kto24999 = "B19001_005",
  HH25kto29999 = "B19001_006",
  HH30kto34999 = "B19001_007",
  HH35kto39999 = "B19001_008",
  HH40kto44999 = "B19001_009",
  HH45kto49999 = "B19001_010",
  HH50kto59999 = "B19001_011",
  HH60kto74999 = "B19001_012",
  HH75kto99999 = "B19001_013",
  HH100kto124999 = "B19001_014",
  HH125kto149999 = "B19001_015",
  HH150kto199999 = "B19001_016",
  HH200kmore = "B19001_017",
  FamTotal = "B19101_001",
  FamLess10k = "B19101_002",
  Fam10kto14999 = "B19101_003",
  Fam15kto19999 = "B19101_004",
  Fam20kto24999 = "B19101_005",
  Fam25kto29999 = "B19101_006",
  Fam30kto34999 = "B19101_007",
  Fam35kto39999 = "B19101_008",
  Fam40kto44999 = "B19101_009",
  Fam45kto49999 = "B19101_010",
  Fam50kto59999 = "B19101_011",
  Fam60kto74999 = "B19101_012",
  Fam75kto99999 = "B19101_013",
  Fam100kto124999 = "B19101_014",
  Fam125kto149999 = "B19101_015",
  Fam150kto199999 = "B19101_016",
  Fam200kmore = "B19101_017",
  
  #Households
  Occupied_HU = "DP04_0002",
  HU_1unit_detached = "DP04_0007",
  HU_1unit_attached = "DP04_0008",
  HU_2units = "DP04_0009",
  HU_3or4units = "DP04_0010",
  HU_5to9units = "DP04_0011",
  HU_10to19units = "DP04_0012",
  HU_20moreunits = "DP04_0013",
  HU_mobilehome = "DP04_0014",
  HU_boat_rv_van = "DP04_0015",
  TotalHH = "B11005_001",
  HH_with_under18 = "B11005_002",
  Families_total = "S1101_C01_003",
  HH_livingalone = "B11001_008",
  
  #Employees
  LaborForce = "DP03_0003",
  Unemployed = "DP03_0005",
  plus16_InLaborForce = "DP03_0002",
  
  #Employment Class
  WorkerClassUniverse = "S2408_C01_001",
  emp_PrivateForProfit = "S2408_C01_002",
  emp_PrivatNonProfit = "S2408_C01_005",
  emp_LocalGov = "S2408_C01_006",
  emp_StateGov = "S2408_C01_007",
  emp_FedGov = "S2408_C01_008",
  emp_SelfEmploy = "S2408_C01_009",
  
  #Education
  Pop25andover = "S1501_C01_006",
  Hsorhigher = "S1501_C01_014",
  BAorhigher = "S1501_C01_015",
  
  #Housing Costs
  CostBurdenedUniverse = "S2503_C01_001",
  CostBurdened_0to19999 = "S2503_C01_028",
  CostBurdened_20kto34999 = "S2503_C01_032",
  CostBurdened_35kto49999 = "S2503_C01_036",
  CostBurdened_50kto74999 = "S2503_C01_040",
  CostBurdened_75kmore = "S2503_C01_044",
  
  #Communities of Interest
  HealthInsuranceUniverse = "DP03_0095",
  NoHealthInsurance = "DP03_0099",
  NoHealthInsuraceUnder19 = "B27010_017",
  NoHealthInsurance65over = "B27010_066",
  DisabilityUniverse = "S1810_C01_001",
  Disability = "S1810_C02_001",
  disability_HearingDifficulty = "S1810_C02_019",
  disability_VisionDifficulty = "S1810_C02_029",
  disability_CognitiveDisability = "S1810_C02_039",
  disability_AmbulatoryDifficulty = "S1810_C02_047",
  disability_SelfCareDifficulty = "S1810_C02_055",
  disability_IndependentLivingDifficulty = "S1810_C02_063",
  PovertyUniverse = "S1701_C01_001",
  BelowPoverty = "S1701_C02_001",
  BlackPop = "S1701_C01_014",
  BlackBelowPov = "S1701_C02_014",
  AsianPop = "S1701_C01_016",
  AsianBelowPov = "S1701_C02_016",
  OtherPop = "S1701_C01_018",
  OtherBelowPov = "S1701_C02_018",
  MultiracialPop = "S1701_C01_019",
  MultiracialBelowPov = "S1701_C02_019",
  HispanicPop = "S1701_C01_020",
  HispanicBelowPov = "S1701_C02_020",
  NHWhitePop = "S1701_C01_021",
  NHWhiteBelowPov = "S1701_C02_021",
  SNAPUniverse = "S2201_C01_001",
  HHSNAP = "S2201_C03_001",
  VehicleUniverse = "S2504_C01_001",
  NoVehicle = "S2504_C01_027",
  over65HH = "B09021_022",
  over65Alone = "B09021_023",
  LimitedEnglishUniverse = "S1601_C01_001",
  LimitedEnglish = "S1601_C05_001",
  InternetUniverse = "S2801_C01_001",
  NoInternet = "S2801_C01_019",
  
  #Housing Tenure
  OccupiedHU = "DP04_0045",
  OwnerOccupied = "DP04_0046",
  RenterOccupied = "DP04_0047",
  HHBlack = "B25003B_001",
  HHBlackOwner = "B25003B_002",
  HHBlackRenter = "B25003B_003",
  HHAsian = "B25003D_001",
  HHAsianOwner = "B25003D_002",
  HHAsianRenter = "B25003D_003",
  HH_NHWhite = "B25003H_001",
  HH_NHWhiteOwner = "B25003H_002",
  HH_NHWhiteRenter = "B25003H_003",
  HH_Hispanic = "B25003I_001",
  HH_HispanicOwner = "B25003I_002",
  HH_HispanicRenter = "B25003I_003",
  HousingUnits = "DP04_0001",
  
  #Language
  SpeakSpanish = "S1601_C01_004",
  SpeakIndoEuroLang = "S1601_C01_008",
  SpeakAPILang = "S1601_C01_012",
  SpeakOtherLang = "S1601_C01_016",
  
  #Commute
  CommuteUniverse = "B08006_001",
  DroveAlone = "B08006_003",
  Carpooled = "B08006_004",
  PublicTransport = "B08006_008",
  Walked = "B08006_015",
  Bicycle = "B08006_014",
  TaxiMotorcycle = "B08006_016",
  WorkFromHome = "B08006_017",
  CommuteLess10min = "B08134_002",
  Commute10to14 = "B08134_003",
  Commute15to19 = "B08134_004",
  Commute20to24 = "B08134_005",
  Commute25to29 = "B08134_006",
  Commute30to34 = "B08134_007",
  Commute35to44 = "B08134_008",
  Commute45to59 = "B08134_009",
  Commute60more = "B08134_010")


#Query for ACS 5-year data for the tracts in the five-county Austin MSA
#5-year ACS is needed for tracts because 1-year is only reported for geographies with over 65,000 people
austin_data_tractsCD <- get_acs(
  geography = "tract",
  variables = profile_varsCD,
  year = year,
  state = "TX",
  county = austin_msa_counties,
  output = "wide",
  survey = "acs5",
  geometry = FALSE
)

#Query for the geographic boundaries of the tracts in the five-county Austin MSA
austin_tracts_geo <- tracts(state = "TX", county = austin_msa_counties, year = year, cb = FALSE)

#Rename and combine queried data for export
austin_acs5_2023 <- austin_data_tractsCD

#Step 2: Data cleaning

#remove M columns
margin_clean_CD <- austin_acs5_2023 |>
  select(!ends_with("M"))

#Import Crosswalk from CSV
crosswalk <- read_excel("CD_Crosswalk.xlsx")

#Merge crosswalk and Variables
merged <- full_join(margin_clean_CD, crosswalk, by=c("GEOID" = "GEOID20"))

#Calculate new values from crosswalk
#Calculate Majority District Values
merged$NAME <- NULL

MajorityCD <- merged %>% mutate(across(ends_with("E"), ~Major_CD_Perc * .x))

#Calculate Minority District Values
MinorityCD <- merged %>% mutate(across(ends_with("E"), ~Minor_CD_Perc * .x))

#group Majority Values into districts
GroupedMajority <- group_by(MajorityCD, Major_CD)
SumMajority <- GroupedMajority %>%
  select(ends_with("E")) %>%
  summarise_all(sum, na.rm = TRUE)
names(SumMajority)[names(SumMajority) == 'Major_CD'] <- 'CouncilDistrict'

#Group Minority values into districts 
GroupedMinority <- group_by(MinorityCD, Minor_CD)
SumMinority <- GroupedMinority %>%
  select(ends_with("E")) %>%
  summarise_all(sum, na.rm = TRUE)
names(SumMinority)[names(SumMinority) == 'Minor_CD'] <- 'CouncilDistrict'

#combine variables into districts
BindedDistricts <- bind_rows(SumMajority, SumMinority) %>%
  group_by(CouncilDistrict) %>%
  summarise_all(sum, na.rm = TRUE)

#Remove extra district that resulted from null values.
BindedDistricts <- BindedDistricts[-c(11), ]


#Calculate final percentages for profiles
CD_Data <- BindedDistricts |>
  mutate(Perc_Immigrants = round(((TotalFBE / TotalFBandNBE)*100), digits = 0),
         pct_veteransE = round(((VeteransE/VeteranUniverseE)*100), digits = 0),
         Perc65plusE = round(((Plus65E/Total_PopE)*100), digits = 0),
         PercUnder18E = round(((Under18E/Total_PopE)*100), digits = 0),
         HH_average_sizeE = round((Total_PopE / HHTotalE), digits = 1),
         PercHH_with_under18E = round(((HH_with_under18E/TotalHHE)*100), digits = 0),
         PercHH_livingaloneE = round(((HH_livingaloneE/TotalHHE)*100), digits = 0),
         pct_unemployedE = round(((UnemployedE/LaborForceE)*100), digits = 0),
         emp_Private = (emp_PrivateForProfitE + emp_PrivatNonProfitE),
         emp_Government = (emp_LocalGovE + emp_StateGovE + emp_FedGovE),
         pct_private = round((emp_Private/(WorkerClassUniverseE)*100), digits = 1),
         pct_government = round((emp_Government/(WorkerClassUniverseE)*100), digits = 1),
         pct_selfemploy = round((emp_SelfEmployE/(WorkerClassUniverseE)*100), digits = 1),
         PercHSorhigherE = round(((HsorhigherE/Pop25andoverE)*100), digits = 0),
         PercBAorhigherE = round(((BAorhigherE/Pop25andoverE)*100), digits = 0),
         Total_Cost_Burdened_HH = (CostBurdened_0to19999E + CostBurdened_20kto34999E + CostBurdened_35kto49999E + CostBurdened_50kto74999E + CostBurdened_75kmoreE),
         pct_cost_burdened = round(((Total_Cost_Burdened_HH/CostBurdenedUniverseE)*100), digits = 0),
         PercNoHealthInsuranceE = round(((NoHealthInsuranceE/HealthInsuranceUniverseE)*100), digits = 0),
         pct_disabilityE = round(((DisabilityE/DisabilityUniverseE)*100), digits = 0),
         pct_povertyE = round(((BelowPovertyE/PovertyUniverseE)*100), digits = 0),
         PctBlackBelowPovE = round(((BlackBelowPovE/BlackPopE)*100), digits = 1),
         PctAsianBelowPovE = round(((AsianBelowPovE/AsianPopE)*100), digits = 1),
         PctOtherBelowPovE = round(((OtherBelowPovE/OtherPopE)*100), digits = 1),
         PctMultiracialBelowPovE = round(((MultiracialBelowPovE/MultiracialPopE)*100), digits = 1),
         PctHispanicBelowPovE = round(((HispanicBelowPovE/HispanicPopE)*100), digits = 1),
         PctNHWhiteBelowPovE = round(((NHWhiteBelowPovE/NHWhitePopE)*100), digits = 1),
         PercHHSNAPE = round(((HHSNAPE/SNAPUniverseE)*100), digits = 0),
         PercNoVehicleE = round(((NoVehicleE/VehicleUniverseE)*100), digits = 0),
         Perc65PlusAlone = round(((over65AloneE/over65HHE)*100), digits = 0),
         PercLimitedEnglishE = round(((LimitedEnglishE/LimitedEnglishUniverseE)*100), digits = 0),
         pct_no_internetE = round(((NoInternetE/InternetUniverseE)*100), digits = 0),
         PercOwnerE = round(((OwnerOccupiedE/OccupiedHUE)*100), digits = 1),
         PercRenterE = round(((RenterOccupiedE/OccupiedHUE)*100), digits = 1),
         PercDrovealoneE = round(((DroveAloneE/CommuteUniverseE)*100), digits = 0),
         PercCarpooledE = round(((CarpooledE/CommuteUniverseE)*100), digits = 0),
         Pct_public_transportE = round(((PublicTransportE/CommuteUniverseE)*100), digits = 0),
         Perc_WalkedE = round(((WalkedE/CommuteUniverseE)*100), digits = 0),
         PercBicycleE = round(((BicycleE/CommuteUniverseE)*100), digits = 0),
         PercTaxiMotorcycleOtherE = round(((TaxiMotorcycleE/CommuteUniverseE)*100), digits = 0),
         pct_work_from_homeE = round(((WorkFromHomeE/CommuteUniverseE)*100), digits = 0))


#Add column with year of data and move column to the beginning.Rename "CouncilDistrict" column to "NAME".
CD_Data$Year <- year
colnames(CD_Data)[colnames(CD_Data) == "CouncilDistrict"] <- "NAME"
CD_Data$GEOID <- as.character(CD_Data$NAME)
CD_Data$NAME <- paste("Council District", CD_Data$NAME)
Updated_CD_Data <- CD_Data %>% relocate(Year, .before=NAME)

#Median Family Income
get_median_fam_income <- function(row) {
  lower_bounds <- c(0, 10000, 15000, 20000, 25000, 30000, 35000,
                    40000, 45000, 50000, 60000, 75000, 100000, 125000, 150000, 200000)
  upper_bounds <- c(9999, 14999, 19999, 24999, 29999, 34999, 39999,
                    44999, 49999, 59999, 74999, 99999, 124999, 149999, 199999, Inf)
  
  freq <- as.numeric(c(
    row$FamLess10kE,
    row$Fam10kto14999E,
    row$Fam15kto19999E,
    row$Fam20kto24999E,
    row$Fam25kto29999E,
    row$Fam30kto34999E,
    row$Fam35kto39999E,
    row$Fam40kto44999E,
    row$Fam45kto49999E,
    row$Fam50kto59999E,
    row$Fam60kto74999E,
    row$Fam75kto99999E,
    row$Fam100kto124999E,
    row$Fam125kto149999E,
    row$Fam150kto199999E,
    row$Fam200kmoreE
  ))
  
  n <- sum(freq, na.rm = TRUE)
  if (n == 0) return(NA)
  
  cum_freq <- cumsum(freq)
  median_position <- n / 2
  median_class_index <- which(cum_freq >= median_position)[1]
  
  Lm <- lower_bounds[median_class_index]
  F  <- ifelse(median_class_index == 1, 0, cum_freq[median_class_index - 1])
  fm <- freq[median_class_index]
  i <- ifelse(is.infinite(upper_bounds[median_class_index]),
              NA,
              upper_bounds[median_class_index] - lower_bounds[median_class_index] + 1)
  
  if (is.na(i)) {
    median_income <- Lm
  } else {
    median_income <- Lm + ((median_position - F) / fm) * i
  }
  
  return(median_income)
}

#Median Household Income
get_median_hh_income <- function(row) {
  lower_bounds <- c(0, 10000, 15000, 20000, 25000, 30000, 35000,
                    40000, 45000, 50000, 60000, 75000, 100000, 125000, 150000, 200000)
  upper_bounds <- c(9999, 14999, 19999, 24999, 29999, 34999, 39999,
                    44999, 49999, 59999, 74999, 99999, 124999, 149999, 199999, Inf)
  
  freq <- as.numeric(c(
    row$HHLess10kE,
    row$HH10kto14999E,
    row$HH15kto19999E,
    row$HH20kto24999E,
    row$HH25kto29999E,
    row$HH30kto34999E,
    row$HH35kto39999E,
    row$HH40kto44999E,
    row$HH45kto49999E,
    row$HH50kto59999E,
    row$HH60kto74999E,
    row$HH75kto99999E,
    row$HH100kto124999E,
    row$HH125kto149999E,
    row$HH150kto199999E,
    row$HH200kmoreE
  ))
  
  n <- sum(freq, na.rm = TRUE)
  if (n == 0) return(NA)
  
  cum_freq <- cumsum(freq)
  median_position <- n / 2
  median_class_index <- which(cum_freq >= median_position)[1]
  
  Lm <- lower_bounds[median_class_index]
  F  <- ifelse(median_class_index == 1, 0, cum_freq[median_class_index - 1])
  fm <- freq[median_class_index]
  i <- ifelse(is.infinite(upper_bounds[median_class_index]),
              NA,
              upper_bounds[median_class_index] - lower_bounds[median_class_index] + 1)
  
  if (is.na(i)) {
    median_income <- Lm
  } else {
    median_income <- Lm + ((median_position - F) / fm) * i
  }
  
  return(median_income)
}

#Median Age
get_median_age <- function(row) {
  # Age bins from ACS S0101_C01_002 through S0101_C01_019
  lower_bounds <- c(0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85)
  upper_bounds <- c(4, 9, 14, 19, 24, 29, 34, 39, 44, 49, 54, 59, 64, 69, 74, 79, 84, Inf)
  
  freq <- as.numeric(c(
    row$TotalUnder_5_yearsE,
    row$Total5_to_9_yearsE,
    row$Total10_to_14_yearsE,
    row$Total15_to_19_yearsE,
    row$Total20_to_24_yearsE,
    row$Total25_to_29_yearsE,
    row$Total30_to_34_yearsE,
    row$Total35_to_39_yearsE,
    row$Total40_to_44_yearsE,
    row$Total45_to_49_yearsE,
    row$Total50_to_54_yearsE,
    row$Total55_to_59_yearsE,
    row$Total60_to_64_yearsE,
    row$Total65_to_69_yearsE,
    row$Total70_to_74_yearsE,
    row$Total75_to_79_yearsE,
    row$Total80_to_84_yearsE,
    row$Total85_years_and_overE
  ))
  
  n <- sum(freq, na.rm = TRUE)
  if (n == 0) return(NA)
  
  cum_freq <- cumsum(freq)
  median_position <- n / 2
  median_class_index <- which(cum_freq >= median_position)[1]
  
  Lm <- lower_bounds[median_class_index]
  F  <- ifelse(median_class_index == 1, 0, cum_freq[median_class_index - 1])
  fm <- freq[median_class_index]
  i <- ifelse(is.infinite(upper_bounds[median_class_index]),
              NA,
              upper_bounds[median_class_index] - lower_bounds[median_class_index] + 1)
  
  if (is.na(i)) {
    median_age <- Lm
  } else {
    median_age <- Lm + ((median_position - F) / fm) * i
  }
  
  return(median_age)
}

#Median commute time
get_median_commute <- function(row) {
  lower_bounds <- c(0, 10, 15, 20, 25, 30, 35, 45, 60)
  upper_bounds <- c(9, 14, 19, 24, 29, 34, 44, 59, Inf)
  
  freq <- as.numeric(c(
    row$CommuteLess10minE,
    row$Commute10to14E,
    row$Commute15to19E,
    row$Commute20to24E,
    row$Commute25to29E,
    row$Commute30to34E,
    row$Commute35to44E,
    row$Commute45to59E,
    row$Commute60moreE
  ))
  
  n <- sum(freq, na.rm = TRUE)
  if (n == 0) return(NA)
  
  cum_freq <- cumsum(freq)
  median_position <- n / 2
  median_class_index <- which(cum_freq >= median_position)[1]
  
  Lm <- lower_bounds[median_class_index]
  F  <- ifelse(median_class_index == 1, 0, cum_freq[median_class_index - 1])
  fm <- freq[median_class_index]
  i <- ifelse(is.infinite(upper_bounds[median_class_index]),
              NA,
              upper_bounds[median_class_index] - lower_bounds[median_class_index] + 1)
  
  if (is.na(i)) {
    median_commute <- Lm
  } else {
    median_commute <- Lm + ((median_position - F) / fm) * i
  }
  
  return(median_commute)
}



CD_Data <- CD_Data %>%
  rowwise() %>%
  mutate(
    MedianFamilyIncomeE = get_median_fam_income(cur_data()),
    MedianHouseholdIncomeE = get_median_hh_income(cur_data()),
    MedianAgeE = get_median_age(cur_data()),
    MedianCommute = get_median_commute(cur_data())
  ) %>%
  ungroup()}


#Run it
final_cd_data <- update_data_cd(year = 2024)

#Uncomment to run just this script
#update_data_cd(year = year)
