#### Preamble ####
# Purpose: This script replicates and generates predictions for Trump support rates
#          in the upcoming U.S. presidential election on November 5, 2024. 
#          It uses historical polling data and Bayesian time series modeling to forecast support
#          across various states and methodologies.
# Author: Chenming Zhao
# Date: 30 October 2024
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

trump_time_series_model <- readRDS("/cloud/project/models/trump_time_model.rds")

trump_data$methodology <- as.factor(trump_data$methodology)


#### Load data ####
# Define each variable separately first
methodology <- c("Live phone", "Online Panel", "Online Panel/Text-to-Web", 
                 "IVR/Online Panel/Text-to-Web", "Probability Panel", 
                 "Live Phone/Text-to-Web", "Live Phone/Online Panel/Text-to-Web",
                 "Online Ad", "Live Phone/Text-to-Web/Email/Mail-to-Web", 
                 "IVR/Online Panel", "unknown", "Live Phone/Email")           

days_since_Biden_Withdrawal <- as.numeric(as.Date("2024-11-05") - as.Date("2024-07-21"))

state <- c("Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", 
           "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", 
           "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", 
           "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", 
           "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", 
           "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", 
           "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", 
           "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", 
           "Tennessee", "Texas", "Utah", "Vermont", "Virginia", 
           "Washington", "West Virginia", "Wisconsin", "Wyoming", "national")

is_national <- ifelse(state == "national", 1, 0)

pollster <- c("AtlasIntel", "Beacon/Shaw", "CES / YouGov", "Christopher Newport U.", 
              "CNN/SSRS", "Data Orbital", "Echelon Insights", "Emerson", 
              "Ipsos", "Marist", "Marquette Law School", "MassINC Polling Group", 
              "Monmouth", "Quinnipiac", "Selzer", "Siena", "Siena/NYT", "Suffolk", 
              "SurveyUSA", "SurveyUSA/High Point University", "The Washington Post", 
              "U. North Florida", "University of Massachusetts Lowell/YouGov", 
              "Washington Post/George Mason University", 
              "YouGov", "YouGov/Center for Working Class Politics")

# Expand each state to achieve a total of 1000 samples
set.seed(853)  # For reproducibility
prediction_data <- data.frame(
  methodology = sample(methodology, size = 1000, replace = TRUE),  # Randomly sample methodologies
  days_since_Biden_Withdrawal = days_since_Biden_Withdrawal,  # Use the same days since Biden withdrawal
  state = sample(state, size = 1000, replace = TRUE),  # Randomly sample states
  is_national = ifelse(sample(state, size = 1000, replace = TRUE) == "national", 1, 0),
  pollster = sample(pollster, size = 1000, replace = TRUE)  # Randomly sample pollsters
)


# 生成预测值
prediction_data$methodology <- factor(prediction_data$methodology, levels = levels(trump_data$methodology))
# Fill missing values in the 'methodology' column with a random sample from valid levels
prediction_data$methodology[is.na(prediction_data$methodology)] <- sample(
  levels(trump_data$methodology),
  sum(is.na(prediction_data$methodology)),
  replace = TRUE
)

prediction_samples <- posterior_predict(trump_time_series_model, newdata = prediction_data)

# 计算预测均值和置信区间
prediction_means <- apply(prediction_samples, 2, mean)
prediction_ci_lower <- apply(prediction_samples, 2, quantile, probs = 0.025)
prediction_ci_upper <- apply(prediction_samples, 2, quantile, probs = 0.975)

# 将结果添加到数据框
prediction_data$predicted_support <- prediction_means
prediction_data$lower_ci <- prediction_ci_lower
prediction_data$upper_ci <- prediction_ci_upper

#### Save data ####
write_csv(prediction_data, "/cloud/project/data/02-analysis_data/prediction_data.csv")
