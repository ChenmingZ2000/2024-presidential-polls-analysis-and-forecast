#### Preamble ####
# Purpose: 
# Author: Chenming Zhao
# Date: 2 November 2024
# Contact: chenming.zhao@mail.utoronto.ca
# License: MIT
# Pre-requisites:
#   - Install the necessary libraries: `tidyverse`, `rstanarm`.
#   - Ensure the Trump time series model is available at "/cloud/project/models/trump_time_model.rds".
#   - Have a folder structure set up with the data directory "/cloud/project/data/02-analysis_data/"
#     to save the prediction output.
# Any other information needed:
#   - This script assumes the structure of `trump_data` is consistent with the input model 
#     used to create `trump_time_series_model`.
#   - The output CSV file ("prediction_data.csv") contains support rate predictions, including
#     point estimates and 95% credible intervals, to be used for further analysis or visualization.


#### Workspace setup ####
library(tidyverse)
library(dplyr)
library(arrow)

#### Load data ####
data <- read_csv("data/01-raw_data/president_polls_raw_data.csv")

ny_data <- data %>% 
  mutate(start_date = as.Date(end_date, format = "%m/%d/%y")) %>%
  filter(display_name == "The New York Times/Siena College") %>%
  distinct()

ny_data <- ny_data %>% select("display_name", "numeric_grade", "methodology", "population")


#### Save data ####
write_parquet(ny_data, "data/02-analysis_data/pollster_data.parquet")
