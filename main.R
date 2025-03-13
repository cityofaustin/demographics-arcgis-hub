## Intro

# This is the top level script to update all ACS data needed for the Demographic
# Profiles website. It runs three separate scripts which each contain a function
# to update different parts of the dataset: 1-year ACS data for the city,
# county, and MSA; 5-year ACS tract data aggregated to city  council districts;
# and a smaller subset of 5-year data for census tract maps.

## Instructions

# To get an updated dataset, simply the acs_year variable below and run this 
# script.

# The script will result in an updated final dataset as well as several
# extra exported files. NEED TO COMPLETE COMMENTS LATER

install.packages("readxl")
install.packages("writexl")
library(writexl)
library(readxl)
library(dplyr)

acs_year <- 2023


## Update Functions

#Load the scripts with update functions
source("data_import.R")
source("data_import_CD.R")
source("data_import_tracts.R")


city_county_msa_data <- update_data(year = acs_year)
council_district_data <- update_data_cd(year = acs_year)
map_data <- update_map(year = acs_year)

#Combine city, county, MSA, and CD variables.
combined_dp_data <- bind_rows(city_county_msa_data, council_district_data)

#Import non-ACS data
nonACS <- read_excel("DP_NonACS_Variables.xlsx", sheet = "Data")
merged_dp_data <- merge(combined_dp_data, nonACS, by = "NAME", all.x = TRUE)

#Add rows for data outside of ACS to be added.
#combined_dp_data$DDPopEstimate <- nonACS$DDPopEstimate
#combined_dp_data$DDOccHousingUnits <- nonACS$DDOccHousingUnits
#combined_dp_data$DDHousingUnits <- nonACS$DDHousingUnits
#combined_dp_data$PopDensity <- nonACS$PopDensity
#combined_dp_data$DaytimePopDensity <- nonACS$DaytimePopDensity
#combined_dp_data$LowModIncome <- nonACS$LowModIncome
#combined_dp_data$MedHomeClose <- nonACS$MedHomeClose
#combined_dp_data$AvMonthRent <- nonACS$AvMonthRent
#combined_dp_data$IncRstrctUnit <- nonACS$IncRstrctUnit
#combined_dp_data$Civic <- nonACS$Civic
#combined_dp_data$Commercial <- nonACS$Commercial
#combined_dp_data$Industrial <- nonACS$Industrial
#combined_dp_data$MixedUse <- nonACS$MixedUse
#combined_dp_data$Multifamily <- nonACS$Multifamily
#combined_dp_data$Office <- nonACS$Office
#combined_dp_data$OpenSpace <- nonACS$OpenSpace
#combined_dp_data$SingleFamily <- nonACS$SingleFamily
#combined_dp_data$Undeveloped <- nonACS$Undeveloped
#combined_dp_data$PubTransitStop <- nonACS$PubTransitStop


#Variables for page 1 of profiles.
dp_data_pg1 <- select(merged_dp_data, GEOID,
                      Year,
                      NAME,
                      DDPopEstimate,
                      Total_PopE,
                      MedianAgeE,
                      Perc_Immigrants,
                      BornEur,
                      BornAsia,
                      BornAfr,
                      BornOceania,
                      BornLA,
                      BornNA,
                      pct_veteransE,
                      Perc65plusE,
                      PercUnder18E,
                      NHWhiteE,
                      NHBlackE,
                      NH_AIANE,
                      NHAsianE,
                      NH_NHPIE,
                      NHOtherE,
                      NHMultiracialE,
                      HispanicE,
                      HispanicMexicanE,
                      HispanicPuertoRicanE,
                      HispanicCubanE,
                      HispanicDominicanE,
                      HispanicCostaRicanE,
                      HispanicGuatemalanE,
                      HispanicHonduranE,
                      HispanicNicaraguanE,
                      HispanicPanamanianE,
                      HispanicSalvadoranE,
                      HispanicOtherCentralAmericanE,
                      HispanicArgentineanE,
                      HispanicBolivianE,
                      HispanicChileanE,
                      HispanicColombianE,
                      HispanicEcuadorianE,
                      HispanicParaguayanE,
                      HispanicPeruvianE,
                      HispanicUruguayanE,
                      HispanicVenezuelanE,
                      HispanicOtherSouthAmericanE,
                      HispanicSpaniardE,
                      HispanicSpanishE,
                      HispanicSpanishAmericanE,
                      HispanicAllOtherHispanicE,
                      AsianIndianE,
                      ChineseE,
                      FilipinoE,
                      JapaneseE,
                      KoreanE,
                      VietnameseE,
                      OtherAsianE,
                      MedianHouseholdIncomeE,
                      MedianFamilyIncomeE,
                      MFIBlackE,
                      MFIAsianE,
                      MFIHispanicE,
                      MFINHWhiteE,
                      LowModIncome,
                      PercHHLess10kE,
                      PercHH10kto14999E,
                      PercHH15kto24999E,
                      PercHH25kto34999E,
                      PercHH35kto49999E,
                      PercHH50kto74999E,
                      PercHH75kto99999E,
                      PercHH100kto149999E,
                      PercHH150kto199999E,
                      PercHH200kmoreE,
                      DDOccHousingUnits,
                      Occupied_HUE,
                      HU_1unit_detachedE,
                      HU_1unit_attachedE,
                      HU_2unitsE,
                      HU_3or4unitsE,
                      HU_5to9unitsE,
                      HU_10to19unitsE,
                      HU_20moreunitsE,
                      HU_mobilehomeE,
                      HU_boat_rv_vanE,
                      HH_average_sizeE,
                      PercHH_with_under18E,
                      Families_totalE,
                      avg_family_sizeE,
                      PercHH_livingaloneE,
                      pct_unemployedE,
                      plus16_InLaborForceE,
                      pct_private,
                      pct_government,
                      pct_selfemploy,
                      PercHSorhigherE,
                      PercBAorhigherE,
                      PercNHW_HShigherE,
                      PercNHW_BAhigherE,
                      PercBlack_HShigherE,
                      PercBlack_BAhigherE,
                      PercAsianHShigherE,
                      PercAsianBAhigherE,
                      PercHispHShigherE,
                      PercHispBAhigherE,)

#Variables for page 2 of profiles.
dp_data_pg2 <- select(merged_dp_data, GEOID,
                      Year,
                      NAME,
                      MedHomeClose,
                      AvMonthRent,
                      CostBurdened_lessthan20kE,
                      CostBurdened_20kto34999E,
                      CostBurdened_35kto49999E,
                      CostBurdened_50kto74999E,
                      CostBurdened_75kmoreE,
                      pct_cost_burdened,
                      IncRstrctUnit,
                      PercNoHealthInsuranceE,
                      NoHealthInsuraceUnder19E,
                      NoHealthInsurance65overE,
                      pct_disabilityE,
                      disability_HearingDifficultyE,
                      disability_VisionDifficultyE,
                      disability_CognitiveDisabilityE,
                      disability_AmbulatoryDifficultyE,
                      disability_SelfCareDifficultyE,
                      disability_IndependentLivingDifficultyE,
                      pct_povertyE,
                      PctBlackBelowPovE,
                      PctAsianBelowPovE,
                      PctOtherBelowPovE,
                      PctMultiracialBelowPovE,
                      PctHispanicBelowPovE,
                      PctNHWhiteBelowPovE,
                      PercHHSNAPE,
                      PercBlackSNAPE,
                      PercAIANSNAPE,
                      PercAsianSNAPE,
                      PercAnotherSNAPE,
                      PercMultiSNAPE,
                      PercHispSNAPE,
                      PercNHWSNAPE,
                      PercNoVehicleE,
                      Perc65PlusAlone,
                      PercLimitedEnglishE,
                      pct_no_internetE,
                      PercOwnerE,
                      PercRenterE,
                      PercBlackOwner,
                      PercBlackRenter,
                      PercAsianOwner,
                      PercAsianRenter,
                      PercNHWhiteOwner,
                      PercNHWhiteRenter,
                      PercHispanicOwner,
                      PercHispanicRenter,
                      DDHousingUnits,
                      HousingUnitsE,
                      PopDensity,
                      DaytimePopDensity,
                      SpeakSpanishE,
                      SpeakIndoEuroLangE,
                      SpeakAPILangE,
                      SpeakOtherLangE,
                      DroveAloneE,
                      CarpooledE,
                      PublicTransportE,
                      WalkedE,
                      BicycleE,
                      TaxiMotorcycleE,
                      WorkFromHomeE,
                      PercDrovealoneE,
                      PercCarpooledE,
                      Pct_public_transportE,
                      Perc_WalkedE,
                      PercBicycleE,
                      PercTaxiMotorcycleOtherE,
                      pct_work_from_homeE,
                      WorkersMeanTravelTimeE,
                      MedianCommute,
                      PubTransitStop,
                      Civic,
                      Commercial,
                      Industrial,
                      MixedUse,
                      Multifamily,
                      Office,
                      OpenSpace,
                      SingleFamily,
                      Undeveloped)

#Export tables to Excel
#write_xlsx(dp_data_pg1, "Profile_Data_Page1.xlsx")
#write_xlsx(dp_data_pg2, "Profile_Data_Page2.xlsx")
#write_xlsx(map_data, "MapUpdate.xlsx")
