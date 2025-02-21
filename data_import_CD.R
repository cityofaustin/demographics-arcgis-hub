library(tidycensus)
library(tidyverse)
library(sf)
library(mapview)
library(tigris)

census_api_key(Sys.getenv("CENSUS_API_KEY"))

year = 2023
austin_msa_counties <- c("Bastrop", "Caldwell", "Hays", "Travis", "Williamson")

#List of ACS variables
profile_vars <- c(
  
  #Population
  Total_Pop = "S0101_C01_001",
  MedianAge = "S0101_C01_032",
  TotalFBandNB = "B05002_001",
  TotalFB = "B05002_013",
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
  
  #Income
  MedianHouseholdIncome = "S1901_C01_012",
  MedianFamilyIncome = "S1901_C02_012",
  
  #Households
  Occupied_HU = "DP04_0002",
  HH_average_size = "S1101_C01_002",
  TotalHH = "B11005_001",
  HH_with_under18 = "B11005_002",
  Families_total = "S1101_C01_003",
  HH_livingalone = "B11001_008",
  
  #Employees
  LaborForce = "DP03_0003",
  Unemployed = "DP03_0005",
  plus16_InLaborForce = "DP03_0002",
  
  #Employment Class
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
  HU_lessthan20k = "S2503_C01_025",
  CostBurdened_lessthan20k = "S2503_C01_028",
  HU_20kto34999 = "S2503_C01_029",
  CostBurdened_20kto34999 = "S2503_C01_032",
  HU_35kto49999 = "S2503_C01_033",
  CostBurdened_35kto49999 = "S2503_C01_036",
  HU_50kto74999 = "S2503_C01_037",
  CostBurdened_50kto74999 = "S2503_C01_040",
  HU_75kmore = "S2503_C01_041",
  CostBurdened_75kmore = "S2503_C01_044",
  
  #Communities of Interest
  HealthInsuranceUniverse = "DP03_0095",
  NoHealthInsurance = "DP03_0099",
  NoHealthInsuraceUnder19 = "B27010_017",
  NoHealthInsurance65over = "B27010_066",
  DisabilityUniverse = "S1810_C01_001",
  Disability = "S1810_C02_001",
  disability_HearingDifficulty = "S1810_C03_019",
  disability_VisionDifficulty = "S1810_C03_029",
  disability_CognitiveDisability = "S1810_C03_039",
  disability_AmbulatoryDifficulty = "S1810_C03_047",
  disability_SelfCareDifficulty = "S1810_C03_055",
  disability_IndependentLivingDifficulty = "S1810_C03_063",
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
  
  #Language
  SpeakSpanish = "S1601_C01_004",
  SpeakIndoEuroLang = "S1601_C01_008",
  SpeakAPILang = "S1601_C01_012",
  SpeakOtherLang = "S1601_C01_016",
  
  #Commute
  CommuteUniverse = "DP03_0018",
  DroveAlone = "DP03_0019",
  Carpooled = "DP03_0020",
  PublicTransport = "DP03_0021",
  Walked = "DP03_0022",
  OtherMeans = "DP03_0023",
  WorkFromHome = "DP03_0024",
  WorkersMeanTravelTime = "DP03_0025")


#Query for ACS 5-year data for the tracts in the five-county Austin MSA
#5-year ACS is needed for tracts because 1-year is only reported for geographies with over 65,000 people
austin_data_tracts <- get_acs(
  geography = "tract",
  variables = profile_vars,
  year = year,
  state = "TX",
  county = austin_msa_counties,
  output = "wide",
  survey = "acs5"
)

#Query for the geographic boundaries of the tracts in the five-county Austin MSA
austin_tracts_geo <- tracts(state = "TX", county = austin_msa_counties, year = year, cb = FALSE)

#Rename and combine queried data for export
austin_acs1_2023 <- bind_rows(austin_data_county, austin_data_place, austin_data_msa)
austin_acs5_2023 <- austin_data_tracts

write_csv(austin_acs1_2023, "raw-data/austin_acs1_2023.csv")
write_csv(austin_acs5_2023, "raw-data/austin_acs5_2023.csv")
write_sf(austin_tracts_geo, "raw-data/austin_tracts_geo.geojson")