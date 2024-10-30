#### Preamble ####
# Purpose: This script models Trump's support rate in the 2024 U.S. Presidential Election 
#          using Bayesian time-series analysis.
# Author: Chenming Zhao
# Date: 30 October 2024
# Contact: chenming.zhao@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
#   - This script requires the `tidyverse` and `rstanarm` libraries for data manipulation 
#     and Bayesian modeling.
#   - Ensure that `analysis_trump_data.csv` is available in the specified path 
#     "/cloud/project/data/02-analysis_data/".
#   - The output model will be saved as `trump_time_model.rds` in the `models` folder.
# Any other information needed? None

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


