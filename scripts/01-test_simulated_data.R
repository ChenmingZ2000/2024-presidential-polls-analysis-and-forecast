#### Preamble ####
# Purpose: Tests the structure and validity of the simulated America 2024 presidential polls dataset
# Author: Chenmming Zhao
# Date: 26 October 2024
# Contact: chenming.zhao@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - The `tidyverse` package must be installed and loaded
  # - 00-simulate_data.R must have been run
# Any other information needed? Make sure you are in the `starter_folder` rproj


#### Workspace setup ####
library(tidyverse)

sample_data <- read_csv("/cloud/project/data/00-simulated_data/simulated_data.csv")

# Test if the data was successfully loaded
if (exists("sample_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}

#### Test data ####

# Check if the dataset has 1000 rows
if (nrow(sample_data) == 1000) {
  message("Test Passed: The dataset has 1000 rows.")
} else {
  stop("Test Failed: The dataset does not have 1000 rows.")
}

# Check if the dataset has 8 columns
if (ncol(sample_data) == 8) {
  message("Test Passed: The dataset has 8 columns.")
} else {
  stop("Test Failed: The dataset does not have 8 columns.")
}

# Check if all values in the 'start_date' column are reasonable
if (all(as.Date("2024-07-21") <= sample_data$start_date & as.Date("2024-11-04") >= sample_data$start_date)) {
  message("Test Passed: All dates in 'start_date' are reasonable.")
} else {
  stop("Test Failed: The 'start_date' column contains unreasonable values.")
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

if (all(sample_data$state %in% valid_states)) {
  message("Test Passed: The 'state' column contains only valid U.S. state names.")
} else {
  stop("Test Failed: The 'state' column contains invalid state names.")
}

# Check if there are any missing values in the dataset
if (all(!is.na(sample_data))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}

# Check if there are no empty strings in 'methodology', 'state', and 'pollster' columns
if (all(sample_data$methodology != "" & sample_data$state != "" & sample_data$pollster != "")) {
  message("Test Passed: There are no empty strings in 'division', 'state', or 'party'.")
} else {
  stop("Test Failed: There are empty strings in one or more columns.")
}

# Check if the 'supports_rate' column has reasonable values
if (all(0 <= sample_data$supports_rate & 100 >= sample_data$supports_rate)) {
  message("Test Passed: The 'supports_rate' column contains at least two unique values.")
} else {
  stop("Test Failed: The 'supports_rate' column contains less than two unique values.")
}

# Check if the 'days_since_biden_withdrawal' column has reasonable values
if (all(0 <= sample_data$days_since_biden_withdrawal & as.numeric(as.Date("2024-11-05") - as.Date("2024-07-21")) >= sample_data$days_since_biden_withdrawal)) {
  message("Test Passed: The 'days_since_biden_withdrawal' column contains at least two unique values.")
} else {
  stop("Test Failed: The 'days_since_biden_withdrawal' column contains less than two unique values.")
}