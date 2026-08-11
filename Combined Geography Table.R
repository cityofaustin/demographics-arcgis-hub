# Install packages if needed
# install.packages(c("tidycensus", "tidyverse", "writexl"))

library(tidycensus)
library(tidyverse)
library(writexl)

# --- SETTINGS ---
year <- 2024
table_id <- "B03001"   
survey_type <- "acs1"

# --- LOAD VARIABLE LABELS ---
vars_acs1 <- load_variables(year, survey_type, cache = TRUE)
table_vars <- vars_acs1 %>%
  filter(str_detect(name, paste0("^", table_id)))

# --- AUSTIN CITY ---
austin_data <- get_acs(
  geography = "place",
  table = table_id,
  year = year,
  state = "TX",
  output = "tidy",
  survey = survey_type
) %>%
  filter(NAME == "Austin city, Texas") %>%
  left_join(table_vars, by = c("variable" = "name")) %>%
  select(GEOID, NAME, variable, label, concept, estimate, moe)

# --- TEXAS ---
tx_data <- get_acs(
  geography = "state",
  table = table_id,
  year = year,
  state = "TX",
  output = "tidy",
  survey = survey_type
) %>%
  left_join(table_vars, by = c("variable" = "name")) %>%
  select(GEOID, NAME, variable, label, concept, estimate, moe)

# --- UNITED STATES ---
us_data <- get_acs(
  geography = "us",
  table = table_id,
  year = year,
  output = "tidy",
  survey = survey_type
) %>%
  left_join(table_vars, by = c("variable" = "name")) %>%
  select(GEOID, NAME, variable, label, concept, estimate, moe)

# --- EXPORT TO ONE EXCEL FILE ---
write_xlsx(
  list(
    "Austin" = austin_data,
    "Texas" = tx_data,
    "United States" = us_data
  ),
  "C15002I_2024_1yr_combined.xlsx"
)


