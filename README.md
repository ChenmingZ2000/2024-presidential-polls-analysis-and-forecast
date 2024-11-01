# Prediction of the 2024 U.S. presidential election results

## Overview

This repo contains the project which focuses on predicting the winner of the 2024 U.S. presidential election. The model used in this project is a generalized linear model and focuses only on Donald Trump's polling data.

## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data for each candidate in 2024 presidential polls as obtained from FiveThirtyEight.
-   `data/analysis_data` contains the cleaned datasets that were constructed which is used for analysing and prediction.
-   `model` contains fitted models. 
-   `other` contains relevant literature, details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, test, clean data, model data and prediction data.


## Statement on LLM usage
Aspects of the code and some bibliography were written with the help of ChatGPT, and the entire chat history is available in inputs/other/llm_usage/usage.txt.