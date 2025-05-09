# Cleaned R script from Cleaning_Hylaeus_Data.qmd (Final Fixed Version with Type Handling)
# Use this for live demo or reproducible processing of Hylaeus observations

# Load necessary libraries
# NOTE: parse_datetime() doesn't exist — using parse_date_time() from lubridate
library(readxl)    # For reading Excel files
library(dplyr)     # For data manipulation
library(lubridate) # For working with dates and times
library(stringr)   # For keyword searches

# Although readxl works fine for Excel, converting to .csv is recommended for archival and reproducibility.

# Define the path to the Excel file (relative path from /Code/ folder)
excel_file <- "../Data/Raw_data/Kaʻena_Hylaeus Data Observations (Grouped).xlsx"

# Step 1: Get sheet names
sheet_names <- excel_sheets(excel_file)

# Step 2: Convert sheet names (assumed to be in MMDDYY format) to proper Date
parsed_dates <- suppressWarnings(mdy(sheet_names))
bad_sheets <- is.na(parsed_dates)
print(sheet_names[bad_sheets])  # Optional: inspect bad sheet names
sheet_names <- sheet_names[!bad_sheets]
sheet_dates <- parsed_dates[!bad_sheets]

# Step 3: Read in all sheets, tagging each observation with its respective date
data_list <- lapply(seq_along(sheet_names), function(i) {
  read_excel(excel_file, sheet = sheet_names[i]) %>%
    mutate(
      Date = sheet_dates[i],
      Timestamp = format(
        as.POSIXct(as.numeric(Timestamp) * 86400, origin = "1899-12-30", tz = "UTC"),
        "%I:%M %p"
      ),
      `Temperature (°F)` = as.numeric(`Temperature (°F)`),
      `Wind Direction` = as.character(`Wind Direction`),
      `Wind Notes` = as.character(`Wind Notes`)
    )
})

# Step 4: Combine into a single dataframe
observations_raw <- bind_rows(data_list)

# Step 5: Ensure fallback columns exist for safe text search
if (!"Additional_Notes" %in% names(observations_raw)) {
  observations_raw$Additional_Notes <- NA_character_
}
if (!"Detail" %in% names(observations_raw)) {
  observations_raw$Detail <- NA_character_
}

# Step 6: Clean up NA or malformed Timestamps before combining
observations_raw <- observations_raw %>%
  mutate(
    Timestamp = ifelse(is.na(Timestamp) | Timestamp == "NA", NA, Timestamp),
    Combined = paste(Date, Timestamp),
    Datetime = parse_date_time(Combined, orders = "ymd IMp", quiet = TRUE)
  )

# Step 7: Create logical columns for keyword searches
observations_clean <- observations_raw %>%
  mutate(
    Photo_Taken = if_else(str_detect(tolower(paste(Detail, Additional_Notes)), "photo|filmed|picture|video"), TRUE, FALSE),
    Species_Sighted = if_else(str_detect(tolower(paste(Detail, Additional_Notes)), "sighting|seen|observed|found"), TRUE, FALSE),
    Observation_Noted = if_else(str_detect(tolower(paste(Detail, Additional_Notes)), "observation|observed|noted|detected"), TRUE, FALSE)
  )

# Step 8: Reorder columns for clarity
observations_clean <- observations_clean %>%
  select(Datetime, Date, Timestamp, Category, Detail, Additional_Notes,
         Photo_Taken, Species_Sighted, Observation_Noted,
         `Temperature (°F)`, `Wind Direction`, `Wind Notes`)

# Step 9: Create directory for output if it doesn’t exist
dir.create("../Data/Processed_data", recursive = TRUE, showWarnings = FALSE)

# Step 10: Save outputs
write.csv(observations_clean, "../Data/Processed_data/Hylaeus_Observations_Cleaned.csv", row.names = FALSE)
saveRDS(observations_clean, "../Data/Processed_data/Hylaeus_Observations_Cleaned.rds")
