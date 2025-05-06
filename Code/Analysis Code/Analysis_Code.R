# Hylaeus_Observation_Analysis.R
# Run from: Project_3/Code/Analysis Code/
# Requires: Project_3/Data/Processed_data/Hylaeus_Observations_Cleaned.csv

# --- Setup ---
rm(list = ls())  # Clear environment

# Need to install this most likely

# Load required packages
library(dplyr)
library(ggplot2)
library(readr)
library(lubridate)

# --- Load Data ---
# Use relative path from "Analysis Code/" folder
hylaeus_data <- install.packages("here")
read_csv("../../Data/Processed_data/Hylaeus_Observations_Cleaned.csv")

# --- Process Datetime ---
# Timestamp has full datetime, but date is separate — extract time only and join
hylaeus_data <- hylaeus_data %>%
  mutate(
    Datetime = ymd_hms(paste(Date, format(as.POSIXct(Timestamp), "%H:%M:%S")))
  )

# --- Daily Summary ---
daily_counts <- hylaeus_data %>%
  count(Date, name = "Observations")

plot_daily <- ggplot(daily_counts, aes(x = Date, y = Observations)) +
  geom_line() +
  geom_point() +
  labs(title = "Daily Observation Counts", x = "Date", y = "Number of Observations") +
  theme_minimal()

# --- Category Summary ---
category_counts <- hylaeus_data %>%
  count(Category, sort = TRUE)

plot_category <- ggplot(category_counts, aes(x = reorder(Category, n), y = n)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(title = "Observations by Category", x = "Category", y = "Count") +
  theme_minimal()

# --- Keyword Flag Summary ---
keyword_summary <- hylaeus_data %>

