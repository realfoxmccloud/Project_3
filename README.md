# Hylaeus Observation Data Cleaning Project

**Course:** ZOOL710 - Data Science in R for Biologists (2025)

**Project Purpose:**  
This project provides a clear and guided method for cleaning field-collected Hylaeus observation data for future analysis and research. It is designed to teach beginners how to handle multi-sheet Excel files, clean qualitative field observations for mixed-method use, and prepare data for reproducible scientific research.

# Cleaning Hylaeus Data

This repository contains scripts and data cleaning processes related to the field study of *Hylaeus anthracinus*, one of Hawaiʻi’s endemic yellow-faced bees. This work is part of a larger research project focused on understanding the ecological and cultural significance of *Hylaeus* through both scientific and biocultural methods.

## Project Context

The data in this repository were collected from Kaʻena Point, located within the ahupuaʻa of Kaʻena, on the westernmost tip of Oʻahu. Kaʻena Point is a critical conservation area and one of the last remaining coastal ecosystems in the Hawaiian Islands where native vegetation and species—including *Hylaeus anthracinus*—can still thrive. 

This project examines how observational data from this site, combined with mapping, kilo (traditional observation), and inoa ʻāina (place-based knowledge), can inform conservation strategies rooted in both ecological science and Native Hawaiian frameworks of stewardship and relationship (pilina).

## Why Hylaeus?

*Hylaeus* bees are vital pollinators in Hawaiʻi, yet they are often overlooked in both public and scientific discourse. Many species within the genus are now endangered or threatened due to habitat loss, invasive species, and climate change. This project aims to restore visibility to these key pollinators by highlighting their role in native plant mutualisms and their deeper ties to place and culture.

## File Overview

- `Cleaning_Hylaeus_Data.qmd`: Quarto file used for cleaning raw field data and formatting timestamp information.
- `data/`: Folder for raw and processed data files.
- `outputs/`: Folder for cleaned datasets and summary outputs.


**Folder Structure:**
- `Data/Raw_data/` — contains the original Excel observation file.
- `Data/Processed_data/` — where cleaned `.csv` and `.rds` files will be saved.
- `Code/` — contains the `.qmd` file that performs the cleaning.

**Key Steps in Cleaning:**
- Load all sheets from the Excel file
- Combine and create a new Datetime column
- Extract logical indicators for Photos, Sightings, and Observations
- Handle missing data
- Reorder columns for clarity
- Save cleaned outputs
- Provide a Data Dictionary for future reference

**Important Note:**  
Be sure your working directory is set to the project root so that relative paths work correctly!

---
Mahalo nui for participating in good science practices!

## Extra Notes

The time formatting in this project adjusts Excel-based numeric timestamps (based on the 1899-12-30 origin) into human-readable 12-hour time (AM/PM) format using the following logic:

```r
if ("Timestamp" %in% names(df)) {
    if (is.numeric(df$Timestamp)) {
      df$Timestamp <- format(as.POSIXct(df$Timestamp * 86400, origin = "1899-12-30", tz = "UTC"), "%I:%M %p")
    } else {
      df$Timestamp <- as.character(df$Timestamp)
    }
} else {
    df$Timestamp <- NA_character_
}