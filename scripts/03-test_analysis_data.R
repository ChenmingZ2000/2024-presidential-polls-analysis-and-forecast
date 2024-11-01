#### Preamble ####
# Purpose: Tests the structure and validity of the America 2024 presidential polls dataset
# Author: Chenmming Zhao
# Date: 26 October 2024
# Contact: chenming.zhao@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - The `tidyverse` package must be installed and loaded
# - 02-clean_data.R must have been run
# Any other information needed? Make sure you are in the `starter_folder` rproj


#### Workspace setup ####
library(tidyverse)
library(testthat)

data <- read_csv("/cloud/project/data/02-analysis_data/analysis_trump_data.csv")


#### Test data ####
# Test if the data was successfully loaded
if (exists("data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}

#### Test data ####
# Check if the dataset has 8 columns
if (ncol(data) == 7) {
  message("Test Passed: The dataset has 7 columns.")
} else {
  stop("Test Failed: The dataset does not have 7 columns.")
}

# Check if the 'state' column contains only valid US state names
valid_states <- c("Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", 
                  "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", 
                  "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", 
                  "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", 
                  "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", 
                  "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", 
                  "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", 
                  "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", 
                  "Tennessee", "Texas", "Utah", "Vermont", "Virginia", 
                  "Washington", "West Virginia", "Wisconsin", "Wyoming", "national")

if (all(data$state %in% valid_states)) {
  message("Test Passed: The 'state' column contains only valid U.S. state names.")
} else {
  stop("Test Failed: The 'state' column contains invalid state names.")
}

# Check if there are any missing values in the dataset
if (all(!is.na(data))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}

# Check if there are no empty strings in 'methodology', 'state', and 'pollster' columns
if (all(data$methodology != "" & data$state != "" & data$pollster != "")) {
  message("Test Passed: There are no empty strings in 'division', 'state', or 'party'.")
} else {
  stop("Test Failed: There are empty strings in one or more columns.")
}

# Check if the 'pct' column has reasonable values
if (all(0 <= data$pct & 100 >= data$pct)) {
  message("Test Passed: The 'pct' column contains at least two unique values.")
} else {
  stop("Test Failed: The 'pct' column contains less than two unique values.")
}

# Check if the 'days_since_biden_withdrawal' column has reasonable values
if (all(0 <= data$days_since_Biden_Withdrawal & as.numeric(as.Date("2024-11-05") - as.Date("2024-07-21")) >= data$days_since_Biden_Withdrawal)) {
  message("Test Passed: The 'days_since_biden_withdrawal' column contains at least two unique values.")
} else {
  stop("Test Failed: The 'days_since_biden_withdrawal' column contains less than two unique values.")
}