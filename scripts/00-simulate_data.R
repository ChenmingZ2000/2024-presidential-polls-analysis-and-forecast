#### Preamble ####
# Purpose: Simulates a dataset of America 2024 presidential polls, including the 
#          state, pollster, methodology, support rate, and other relevant fields.
# Author: Chenming Zhao
# Date: 26 October 2024
# Contact: chenming.zhao@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` and `lubridate` packages must be installed.
# Any other information needed? Make sure you are in the `starter_folder` rproj


#### Workspace setup ####
library(tidyverse)
library(lubridate)


#### Simulate data ####
set.seed(853)

# function that give random date from 2024-07-21 to 2024-11-05
random_dates <- function(n) {
  start_date <- as.Date("2024-07-21")
  end_date <- as.Date("2024-11-04")
  date_seq <- seq(start_date, end_date, by = "day")
  sampled_dates <- sample(date_seq, size = n, replace = TRUE)}

# simulate data
political_support <-
  tibble(
    start_date = random_dates(1000),
    state = sample(c("Alabama", "Alaska", "Arkansas", "California", "Colorado", 
                     "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", 
                     "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", 
                     "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", 
                     "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", 
                     "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", 
                     "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", 
                     "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", 
                     "Tennessee", "Texas", "Utah", "Vermont", "Virginia", 
                     "Washington", "West Virginia", "Wisconsin", "Wyoming", "national"), size = 1000, replace = TRUE),
    pollster = sample(c("A", "B", "C", "D", "E", "F"), size = 1000, replace = TRUE),
    methodology = sample(c("online panel", "by phone", "in-person", "probability panel"), size = 1000, replace = TRUE),
    noise = rnorm(n = 1000, mean = 0, sd = 10) |> round(),
    supports_rate = round(runif(1000, min = 19, max = 60), 1),
    is_national = if_else(state == "national", 1, 0),
    days_since_biden_withdrawal = as.numeric(start_date - as.Date("2024-07-21"))
  )

political_support


#### Save data ####
write_csv(political_support, "/cloud/project/data/00-simulated_data/simulated_data.csv")
