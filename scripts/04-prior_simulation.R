#### Preamble ####
# Purpose: Model Trump's support rate in the 2024 U.S. Presidential Election
# Author: Chenming Zhao
# Date: 30 October 2024
# Contact: chenming.zhao@mail.utoronto.ca
# License: MIT
# Pre-requisites: This script requires access to simulated prior distributions 
#                 for Trump's support rate, based on factors such as days since 
#                 Biden's withdrawal, pollster effects, methodology, and state/national indicators.
#                 Make sure to have 'tibble', 'ggplot2', and 'dplyr' libraries installed.
# Overview:This script is designed to set up prior distributions for Bayesian modeling 
#          of Trump's support rate in the 2024 election. The factors influencing support rate 
#          (as captured in this simulation) include:
#          - Methodology (method of polling),
#          - Days since Biden's withdrawal,
#          - National or state-level effect,
#          - Pollster (random effect including time influence),
#          - State-level effects.
#          The purpose of these priors is to assess the model's predictions before fitting actual data, 
#          ensuring reasonable assumptions about the ranges and distributions for each variable. 
#          These checks provide insight into whether the priors are likely to yield interpretable 
#          and realistic results once data is introduced.


#### Workspace setup ####
library(tibble)
library(ggplot2)
library(dplyr)

# Set the prior parameters of the simulation
draws <- 1000
num_effects <- 16

# Time range: Shorten the range of days and repeat to ensure consistent column length
time_range <- rep(seq(0, 100, by = 5), length.out = draws * num_effects)

priors <- tibble(
  sigma = rep(rexp(n = draws, rate = 1), times = num_effects),
  # Intercept prior
  beta_0 = rep(rnorm(n = draws, mean = 40, sd = 2.5), times = num_effects),
  
  # days_since_Biden_Withdrawal prior
  beta_time = rep(rnorm(n = draws, mean = 0, sd = 0.2), times = num_effects),
  
  # pollster effect prior
  beta_pollster = rep(rnorm(n = draws, mean = 0, sd = 1), times = num_effects),
  
  # methodology effect prior
  beta_methodology = rep(rnorm(n = draws, mean = 0, sd = 1.5), times = num_effects),
  
  # state effect prior
  beta_state = rep(rnorm(n = draws, mean = 0, sd = 1), times = num_effects),
  
  beta_is_national = rep(rbinom(n = draws * num_effects, size = 1, prob = 0.5), times = 1),
  is_national = rep(c(0, 1), length.out = draws * num_effects),
  
  days_since_Biden_Withdrawal = time_range
  
) |>
  rowwise() |>
  mutate(
    mu = beta_0 + 
      beta_methodology + 
      beta_time * days_since_Biden_Withdrawal + 
      beta_pollster + 
      beta_state,
    
    # The support rate pct was simulated using a random normal distribution
    pct = pmin(pmax(rnorm(n = 1, mean = mu, sd = sigma), 0), 100) # limit from 0 to 100
  )

# plots

# Distribution histogram of support rate pct
priors |>
  ggplot(aes(x = pct)) +
  geom_histogram(binwidth = 5, fill = "#1f78b4", color = "black") +
  labs(title = "Prior Predictive Distribution of Trump Support Rate",
       x = "Trump Support Rate (%)", y = "Frequency") +
  theme_classic()

# Point plot of pct over time
priors |>
  ggplot(aes(x = days_since_Biden_Withdrawal, y = pct)) +
  geom_point(alpha = 0.1, color = "#33a02c") +
  labs(title = "Prior Predictive Check: Trump Support Rate Over Time",
       x = "Days Since Biden's Withdrawal", y = "Trump Support Rate (%)") +
  theme_classic()

# The distribution of pct classified by different pollsters
priors |>
  ggplot(aes(x = as.factor(beta_pollster), y = pct)) +
  geom_boxplot(fill = "#b2df8a") +
  labs(title = "Prior Predictive Check: Trump Support Rate by Pollster",
       x = "Pollster Effect (Simulated)", y = "Trump Support Rate (%)") +
  theme_classic()

# The distribution of pct in different methodologies
priors |>
  ggplot(aes(x = as.factor(beta_methodology), y = pct)) +
  geom_boxplot(fill = "#fb9a99") +
  labs(title = "Prior Predictive Check: Trump Support Rate by Methodology",
       x = "Methodology Effect (Simulated)", y = "Trump Support Rate (%)") +
  theme_classic()



