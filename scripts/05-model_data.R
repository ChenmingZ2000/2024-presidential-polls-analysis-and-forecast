#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

#### Workspace setup ####
library(tidyverse)
library(rstanarm)

#### Read data ####
trump_data <- read_csv("/cloud/project/data/02-analysis_data/analysis_trump_data.csv")

### Model data ####
trump_time_series_model <- stan_glmer(
  pct ~ methodology + days_since_Biden_Withdrawal + is_national + (1 | state) + (1 + days_since_Biden_Withdrawal | pollster), 
  data = trump_data, 
  family = gaussian(),
  prior = normal(0, 5, autoscale = TRUE),
  prior_intercept = normal(45, 5, autoscale = TRUE),
  prior_covariance = decov(regularization = 1)
)


#### Save model ####
saveRDS(
  trump_time_series_model,
  file = "/cloud/project/models/trump_time_model.rds"
)


