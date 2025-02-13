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
  FB_cit_Europe = "B05002_015",
  FB_cit_Asia = "B05002_016",
  FB_cit_Africa = "B05002_017",
  FB_cit_Oceania = "B05002_018",
  FB_cit_LatinAmer = "B05002_019",
  FB_cit_NorthAmer = "B05002_020",
  FB_noncit_Europe = "B05002_022",
  FB_noncit_Asia = "B05002_023",
  FB_noncit_Africa = "B05002_024",
  FB_noncit_Oceania = "B05002_025",
  FB_noncit_LatinAmer = "B05002_026",
  FB_noncit_NorthAmer = "B05002_027",
  pct_veterans = "S2101_C04_001",
  Perc65plus = "S0101_C02_030",
  PercUnder18 = "S0101_C02_022",
  
  #Population by Race/Ethnicity
  NHWhite = "DP05_0082",
  NHBlack = "DP05_0083",
  NH_AIAN = "DP05_0084",
  NHAsian = "DP05_0085",
  NH_NHPI = "DP05_0086",
  NHOther = "DP05_0087",
  NHMultiracial = "DP05_0088",
  Hispanic = "DP05_0076",
  
  #Hispanic Origin for top 5 ranking
  HispanicMexican = "B03001_004",
  HispanicPuertoRican = "B03001_005",
  HispanicCuban = "B03001_006",
  HispanicDominican = "B03001_007",
  HispanicCostaRican = "B03001_009",
  HispanicGuatemalan = "B03001_010",
  HispanicHonduran = "B03001_011",
  HispanicNicaraguan = "B03001_012",
  HispanicPanamanian = "B03001_013",
  HispanicSalvadoran = "B03001_014",
  HispanicOtherCentralAmerican = "B03001_015",
  HispanicArgentinean = "B03001_017",
  HispanicBolivian = "B03001_018",
  HispanicChilean = "B03001_019",
  HispanicColombian = "B03001_020",
  HispanicEcuadorian = "B03001_021",
  HispanicParaguayan = "B03001_022",
  HispanicPeruvian = "B03001_023",
  HispanicUruguayan = "B03001_024",
  HispanicVenezuelan = "B03001_025",
  HispanicOtherSouthAmerican = "B03001_026",
  HispanicSpaniard = "B03001_028",
  HispanicSpanish = "B03001_029",
  HispanicSpanishAmerican = "B03001_030",
  HispanicAllOtherHispanic = "B03001_031",
  
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
  PercHHLess10k = "S1901_C01_002",
  PercHH10kto14999 = "S1901_C01_003",
  PercHH15kto24999 = "S1901_C01_004",
  PercHH25kto34999 = "S1901_C01_005",
  PercHH35kto49999 = "S1901_C01_006",
  PercHH50kto74999 = "S1901_C01_007",
  PercHH75kto99999 = "S1901_C01_008",
  PercHH100kto149999 = "S1901_C01_009",
  PercHH150kto199999 = "S1901_C01_010",
  PercHH200kmore = "S1901_C01_011",
  
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
  HH_average_size = "S1101_C01_002",
  PercHH_with_under18 = "S1101_C01_010",
  Families_total = "S1101_C01_003",
  avg_family_size = "S1101_C01_004",
  PercHH_livingalone = "S1101_C01_013",
  
  #Employees
  pct_unemployed = "DP03_0005P",
  plus16_InLaborForce = "DP03_0002",
  
  #Employment Class
  emp_PrivateForProfit = "S2408_C01_002",
  emp_PrivatNonProfit = "S2408_C01_005",
  emp_LocalGov = "S2408_C01_006",
  emp_StateGov = "S2408_C01_007",
  emp_FedGov = "S2408_C01_008",
  emp_SelfEmploy = "S2408_C01_009",
  
  #Education
  PercHSorhigher = "S1501_C02_014",
  PercBAorhigher = "S1501_C02_015",
  PercNHW_HShigher = "S1501_C02_032",
  PercNHW_BAhigher = "S1501_C02_033",
  PercBlack_HShigher = "S1501_C02_035",
  PercBlack_BAhigher = "S1501_C02_036",
  PercAsianHShigher = "S1501_C02_041",
  PercAsianBAhigher = "S1501_C02_042",
  PercHispHShigher = "S1501_C02_053",
  PercHispBAhigher = "S1501_C02_054",
  
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
  PercNoHealthInsurance = "DP03_0099P",
  NoHealthInsuraceUnder19 = "B27010_017",
  NoHealthInsurance65over = "B27010_066",
  pct_disability = "S1810_C03_001",
  disability_HearingDifficulty = "S1810_C03_019",
  disability_VisionDifficulty = "S1810_C03_029",
  disability_CognitiveDisability = "S1810_C03_039",
  disability_AmbulatoryDifficulty = "S1810_C03_047",
  disability_SelfCareDifficulty = "S1810_C03_055",
  disability_IndependentLivingDifficulty = "S1810_C03_063",
  pct_poverty = "S1701_C03_001",
  BlackBelowPoverty = "S1701_C03_014",
  AsianBelowPoverty = "S1701_C03_016",
  OtherBelowPoverty = "S1701_C03_018",
  MultiracialBelowPoverty = "S1701_C03_019",
  HispanicBelowPoverty = "S1701_C03_020",
  NHWhiteBelowPoverty = "S1701_C03_021",
  PercHHSNAP = "S2201_C04_001",
  PercBlackSNAP = "S2201_C04_026",
  PercAIANSNAP = "S2201_C04_027",
  PercAsianSNAP = "S2201_C04_028",
  PercAnotherSNAP = "S2201_C04_030",
  PercMultiSNAP = "S2201_C04_031",
  PercHispSNAP = "S2201_C04_032",
  PercNHWSNAP = "S2201_C04_033",
  PercNoVehicle = "S2504_C02_027",
  over65HH = "B09021_022",
  over65Alone = "B09021_023",
  PercLimitedEnglish = "S1601_C06_001",
  pct_no_internet = "S2801_C02_019",
  
  #Housing Tenure
  PercOwner = "S1101_C01_018",
  PercRenter = "S1101_C01_019",
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
  
  #Language
  SpeakSpanish = "S1601_C01_004",
  SpeakIndoEuroLang = "S1601_C01_008",
  SpeakAPILang = "S1601_C01_012",
  SpeakOtherLang = "S1601_C01_016",
  
  #Commute
  PercDrovealone = "S0801_C01_003",
  PercCarpooled = "S0801_C01_004",
  Pct_public_transport = "S0801_C01_009",
  Perc_Walked = "S0801_C01_010",
  PercBicycle = "S0801_C01_011",
  PercTaxiMotorcycleOther = "S0801_C01_012",
  pct_work_from_home = "S0801_C01_013",
  WorkersMeanTravelTime = "S0801_C01_046")

#Query for ACS 1-year data for Travis County
austin_data_county <- get_acs(
  geography = "county",
  variables = profile_vars,
  year = year,
  state = "TX",
  county = "Travis",
  output = "wide",
  survey = "acs1"
)

#Query for ACS 1-year data for the city of Austin
austin_data_place <- get_acs(
  geography = "place",
  variables = profile_vars,
  year = year,
  state = "TX",
  output = "wide",
  survey = "acs1"
)%>%
  filter(str_detect(NAME, "Austin"))

#Query for ACS 1-year data for the five-county Austin MSA (Metropolitan Statistical Area)
austin_data_msa <- get_acs(
  geography = "cbsa",
  variables = profile_vars,
  year = year,
  #state = "TX",
  output = "wide",
  survey = "acs1"
)%>%
  filter(str_detect(NAME, "Austin"))

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
