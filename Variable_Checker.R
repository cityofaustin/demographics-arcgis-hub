library(tidycensus)
library(dplyr)
library(tibble)
library(writexl)


# years to compare
year_2023 <- 2023
year_2024 <- 2024

# Your ACS variable list (name = code)
acs_vars_2023 <- c(
  #Population
  Total_Pop = "S0101_C01_001",
  TotalFBandNB = "B05002_001",
  TotalFB = "B05002_013",
  VeteranUniverse = "S2101_C01_001",
  Veterans = "S2101_C03_001",
  Plus65 = "S0101_C01_030",
  Under18 = "S0101_C01_022",
  
  #Population by Race/Ethnicity
  NHWhite = "DP05_0096",
  NHBlack = "DP05_0097",
  NH_AIAN = "DP05_0098",
  NHAsian = "DP05_0099",
  NH_NHPI = "DP05_0100",
  NHOther = "DP05_0101",
  NHMultiracial = "DP05_0102",
  Hispanic = "DP05_0090",
  
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

vars_2023 <- bind_rows(
  load_variables(2023, "acs5", cache = TRUE),
  load_variables(2023, "acs5/subject", cache = TRUE),
  load_variables(2023, "acs5/profile", cache = TRUE)
)

vars_2024 <- bind_rows(
  load_variables(2024, "acs5", cache = TRUE),
  load_variables(2024, "acs5/subject", cache = TRUE),
  load_variables(2024, "acs5/profile", cache = TRUE)
)


comparison <- tibble(
  custom_name = names(acs_vars_2023),
  variable = unname(acs_vars_2023)
) %>%
  left_join(
    vars_2023 %>% select(name, label_2023 = label),
    by = c("variable" = "name")
  ) %>%
  left_join(
    vars_2024 %>% select(name, label_2024 = label),
    by = c("variable" = "name")
  ) %>%
  mutate(
    exists_2023 = !is.na(label_2023),
    exists_2024 = !is.na(label_2024),
    label_changed = case_when(
      !exists_2024 ~ NA,
      label_2023 != label_2024 ~ TRUE,
      TRUE ~ FALSE
    )
  )
comparison %>%
  filter(!exists_2024)
comparison %>%
  filter(label_changed)
comparison %>%
  filter(exists_2024 & !label_changed)
write_xlsx(
  comparison,
  "acs_2023_vs_2024_variable_check.xlsx")
