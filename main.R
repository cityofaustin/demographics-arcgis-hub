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

acs_year <- 2023


## Update Functions

#Load the scripts with update functions
source("data_import.R")
source("data_import_CD.R")
source("data_import_tracts.R")


city_county_msa_data <- update_data(year = acs_year)
council_district_data <- update_data_cd(year = acs_year)
map_data <- update_map(year = acs_year)