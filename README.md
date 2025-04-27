# Hylaeus Observation Data Cleaning Project

**Course:** ZOOL710 - Data Science in R for Biologists (2025)

**Project Purpose:**  
This project provides a clear and guided method for cleaning field-collected Hylaeus observation data for future analysis and research. It is designed to teach beginners how to handle multi-sheet Excel files, clean qualitative field observations for mixed-method use, and prepare data for reproducible scientific research.

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
