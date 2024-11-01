#### Preamble ####
# Purpose: Cleans and preprocesses raw polling data for the 2024 US presidential election
#          and combined with 2023 economic situation (GDP and personal income) national in
#          U.S. and per state.
#          The data includes national polling results from various pollsters, as well as
#          details on methodology, sample size, and polling dates. This script aims to
#          clean and structure the data for analysis and model building.
# Author: Chenming Zhao
# Date: 28 October 2024
# Contact: chenming.zhao@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
#    - Download the raw polling data from https://projects.fivethirtyeight.com/polls/president-general/2024/national/
#    - Install necessary libraries, such as dplyr and tidyverse.
#    - Basic understanding of data wrangling and modeling in R.
# Any other information needed?
#    - Ensure that the downloaded data is saved in a directory accessible by this script, 
#      or adjust the file path accordingly.
#    - The analysis will focus on specific candidates; please adjust filters for desired candidates as needed.

#### Workspace setup ####
library(tidyverse)
library(readxl)
library(dplyr)
library(arrow)

#### Clean data ####
raw_data <- read_csv("/cloud/project/data/01-raw_data/president_polls_raw_data.csv")


# Filters were used to filter good quality Trump related polls in the dataset
trump_data <- raw_data %>%
  mutate(candidate_name = str_replace(candidate_name, " Jr.", "")) %>%
  mutate(start_date = as.Date(start_date, format = "%m/%d/%y")) %>%
  mutate(end_date = as.Date(end_date, format = "%m/%d/%y")) %>%
  # We only consider polls results after Biden's Withdrawal
  filter(candidate_name == "Donald Trump" &  numeric_grade >= 2.7 & start_date >= as.Date("2024-07-21")) %>%
  distinct()

# Delete NAs in pollster column
trump_data <- trump_data %>%
  filter(!is.na(pollster))

# calculate the mean of pct and sample_size (NA values excluded)
mean_pct <- mean(trump_data$pct, na.rm = TRUE)
mean_sample_size <- mean(trump_data$sample_size, na.rm = TRUE)
# Fill in the missing pct values
trump_data$pct[is.na(trump_data$pct)] <- mean_pct
trump_data$sample_size[is.na(trump_data$sample_size)] <- mean_sample_size

# Handle outliers
# Set the pct values less than 0 to 0
trump_data$pct[trump_data$pct < 0] <- 0
# Set the pct values greater than 100 to 100
trump_data$pct[trump_data$pct > 100] <- 100

# Fill the missing state and methodology with "unknown" so that they can participate in the layering of the model.
trump_data <- trump_data %>%
  mutate(
    state = ifelse(is.na(state), "national", state),
    methodology = ifelse(is.na(methodology), "unknown", methodology)
  ) %>%
  mutate(is_national = ifelse(state == "national", 1, 0))

# Unify the format of 'state'
trump_data <- trump_data %>%
  mutate(state = str_replace(state, " CD-\\d+", ""))

trump_data <- trump_data %>%
  select(start_date, state, pollster, methodology, pct, is_national)

# number of days since Joe Biden's Withdrawal
trump_data$days_since_Biden_Withdrawal <- as.numeric(trump_data$start_date - as.Date("2024-07-21"))

#### Save data ####
write_parquet(trump_data, "/cloud/project/data/02-analysis_data/analysis_trump_data.parquet")
