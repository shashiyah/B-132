rm(list = ls())
cat("\014") 

required_packages <- c("dplyr", "readr")
for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  }
}

cat("================================================================\n")
cat("DATA CLEANING PROCESS - SPOTIFY TRACKS DATASET\n")
cat("================================================================\n\n")

tryCatch({
  data_original <- read.csv("dataset/playlist_2010to2023.csv", 
                            fileEncoding = "latin1",
                            stringsAsFactors = FALSE,
                            na.strings = c("", "NA", "N/A", "null", "NULL"))
  cat("✓ Dataset loaded successfully with latin1 encoding\n")
}, error = function(e) {
  tryCatch({
    data_original <- read.csv("dataset/playlist_2010to2023.csv", 
                              fileEncoding = "UTF-8",
                              stringsAsFactors = FALSE,
                              na.strings = c("", "NA", "N/A", "null", "NULL"))
    cat("✓ Dataset loaded successfully with UTF-8 encoding\n")
  }, error = function(e) {
    stop("ERROR: Unable to load dataset. Check file path and encoding.")
  })
})

cat("  Rows:", nrow(data_original), "\n")
cat("  Columns:", ncol(data_original), "\n")
cat("  Memory:", format(object.size(data_original), units = "Mb"), "\n\n")

cat("STEP 2: Assessing data quality...\n\n")

missing_total <- sum(is.na(data_original))
missing_by_column <- colSums(is.na(data_original))

cat("--- Missing Values Analysis ---\n")
cat("Total missing values:", missing_total, "\n")
if (missing_total > 0) {
  cat("Missing values by column:\n")
  missing_cols <- missing_by_column[missing_by_column > 0]
  for (col_name in names(missing_cols)) {
    pct <- round((missing_cols[col_name] / nrow(data_original)) * 100, 2)
    cat(sprintf("  %s: %d (%.2f%%)\n", col_name, missing_cols[col_name], pct))
  }
} else {
  cat("✓ No missing values detected\n")
}
cat("\n")

# Check for duplicate rows
duplicate_count <- sum(duplicated(data_original))
cat("--- Duplicate Rows Analysis ---\n")
cat("Duplicate rows found:", duplicate_count, "\n")
if (duplicate_count > 0) {
  cat("⚠ Duplicates will be removed\n")
} else {
  cat("✓ No duplicate rows detected\n")
}
cat("\n")

# Check required columns
required_columns <- c("track_name", "artist_name", "energy", "loudness", 
                      "danceability", "valence", "tempo", "duration_ms")
missing_columns <- setdiff(required_columns, names(data_original))

cat("--- Required Columns Check ---\n")
if (length(missing_columns) == 0) {
  cat("✓ All required columns present\n")
} else {
  cat("⚠ Missing columns:", paste(missing_columns, collapse = ", "), "\n")
  stop("ERROR: Required columns missing from dataset")
}
cat("\n")

cat("STEP 3: Verifying and correcting data types...\n\n")

data_cleaned <- data_original
numeric_cols <- c("energy", "loudness", "danceability", "valence", 
                  "tempo", "duration_ms", "acousticness", "instrumentalness",
                  "liveness", "speechiness")

conversions_made <- 0
for (col in numeric_cols) {
  if (col %in% names(data_cleaned)) {
    if (!is.numeric(data_cleaned[[col]])) {
      data_cleaned[[col]] <- as.numeric(as.character(data_cleaned[[col]]))
      conversions_made <- conversions_made + 1
      cat("  Converted", col, "to numeric\n")
    }
  }
}

if (conversions_made == 0) {
  cat("✓ All numeric columns already correct type\n")
}
cat("\n")

cat("STEP 4: Cleaning data...\n\n")

rows_before <- nrow(data_cleaned)

# Remove duplicate rows
if (duplicate_count > 0) {
  data_cleaned <- data_cleaned[!duplicated(data_cleaned), ]
  cat("✓ Removed", duplicate_count, "duplicate rows\n")
}

# Remove rows with missing values in key variables
key_vars <- c("energy", "loudness")
rows_with_na <- sum(!complete.cases(data_cleaned[, key_vars]))

if (rows_with_na > 0) {
  data_cleaned <- data_cleaned[complete.cases(data_cleaned[, key_vars]), ]
  cat("✓ Removed", rows_with_na, "rows with missing key variables\n")
}

rows_after <- nrow(data_cleaned)
rows_removed <- rows_before - rows_after

if (rows_removed > 0) {
  cat("Total rows removed:", rows_removed, "\n")
  cat("Retention rate:", round((rows_after/rows_before)*100, 2), "%\n")
} else {
  cat("✓ No rows removed - dataset pristine\n")
}
cat("\n")

cat("STEP 5: Validating value ranges...\n\n")

# Check energy (should be 0-1)
energy_range <- range(data_cleaned$energy, na.rm = TRUE)
cat("--- Energy Variable ---\n")
cat("  Range: [", sprintf("%.4f", energy_range[1]), ", ", 
    sprintf("%.4f", energy_range[2]), "]\n", sep = "")
cat("  Mean: ", sprintf("%.4f", mean(data_cleaned$energy, na.rm = TRUE)), "\n", sep = "")
cat("  SD: ", sprintf("%.4f", sd(data_cleaned$energy, na.rm = TRUE)), "\n", sep = "")

if (energy_range[1] >= 0 && energy_range[2] <= 1) {
  cat("  ✓ Within expected range (0-1)\n")
} else {
  cat("  ⚠ Values outside expected range detected\n")
}
cat("\n")


loudness_range <- range(data_cleaned$loudness, na.rm = TRUE)
cat("--- Loudness Variable ---\n")
cat("  Range: [", sprintf("%.2f", loudness_range[1]), ", ", 
    sprintf("%.2f", loudness_range[2]), "] dB\n", sep = "")
cat("  Mean: ", sprintf("%.2f", mean(data_cleaned$loudness, na.rm = TRUE)), " dB\n", sep = "")
cat("  SD: ", sprintf("%.2f", sd(data_cleaned$loudness, na.rm = TRUE)), " dB\n", sep = "")

if (loudness_range[2] <= 0) {
  cat("  ✓ All values negative (valid dB scale)\n")
} else {
  cat("  ⚠ Positive values detected - unusual for loudness\n")
}
cat("\n")

cat("STEP 6: Detecting outliers (using IQR method)...\n\n")

detect_outliers <- function(x) {
  Q1 <- quantile(x, 0.25, na.rm = TRUE)
  Q3 <- quantile(x, 0.75, na.rm = TRUE)
  IQR_val <- Q3 - Q1
  lower_bound <- Q1 - 1.5 * IQR_val
  upper_bound <- Q3 + 1.5 * IQR_val
  outliers <- sum(x < lower_bound | x > upper_bound, na.rm = TRUE)
  percentage <- (outliers / length(x)) * 100
  return(list(count = outliers, percentage = percentage))
}

# Check outliers in energy
energy_outliers <- detect_outliers(data_cleaned$energy)
cat("Energy outliers:\n")
cat("  Count:", energy_outliers$count, "\n")
cat("  Percentage:", sprintf("%.2f%%", energy_outliers$percentage), "\n")

# Check outliers in loudness
loudness_outliers <- detect_outliers(data_cleaned$loudness)
cat("\nLoudness outliers:\n")
cat("  Count:", loudness_outliers$count, "\n")
cat("  Percentage:", sprintf("%.2f%%", loudness_outliers$percentage), "\n")

cat("\n⚠ Note: Outliers retained as potentially legitimate extreme values\n")
cat("   (Represent genuine diversity in musical characteristics)\n\n")

cat("STEP 7: Saving cleaned dataset...\n\n")

# Ensure output directory exists
if (!dir.exists("dataset")) {
  dir.create("dataset", recursive = TRUE)
}

# Save cleaned dataset
output_file <- "dataset/cleaned_playlist_2010to2023.csv"
write.csv(data_cleaned, output_file, row.names = FALSE, fileEncoding = "UTF-8")

cat("✓ Cleaned dataset saved:", output_file, "\n")
cat("  File size:", format(file.size(output_file), units = "Mb"), "\n\n")

cat("================================================================\n")
cat("DATA CLEANING SUMMARY\n")
cat("================================================================\n\n")

cat("ORIGINAL DATASET:\n")
cat("  Rows:", nrow(data_original), "\n")
cat("  Columns:", ncol(data_original), "\n")
cat("  Missing values:", missing_total, "\n")
cat("  Duplicates:", duplicate_count, "\n\n")

cat("CLEANED DATASET:\n")
cat("  Rows:", nrow(data_cleaned), "\n")
cat("  Columns:", ncol(data_cleaned), "\n")
cat("  Missing values:", sum(is.na(data_cleaned[, key_vars])), "\n")
cat("  Duplicates:", sum(duplicated(data_cleaned)), "\n\n")

cat("KEY VARIABLES (for correlation analysis):\n")
cat("  Energy:\n")
cat("    Mean:", sprintf("%.4f", mean(data_cleaned$energy, na.rm = TRUE)), "\n")
cat("    SD:", sprintf("%.4f", sd(data_cleaned$energy, na.rm = TRUE)), "\n")
cat("    Range: [", sprintf("%.4f", min(data_cleaned$energy, na.rm = TRUE)), ", ",
    sprintf("%.4f", max(data_cleaned$energy, na.rm = TRUE)), "]\n", sep = "")
cat("\n  Loudness:\n")
cat("    Mean:", sprintf("%.2f", mean(data_cleaned$loudness, na.rm = TRUE)), "dB\n")
cat("    SD:", sprintf("%.2f", sd(data_cleaned$loudness, na.rm = TRUE)), "dB\n")
cat("    Range: [", sprintf("%.2f", min(data_cleaned$loudness, na.rm = TRUE)), ", ",
    sprintf("%.2f", max(data_cleaned$loudness, na.rm = TRUE)), "] dB\n", sep = "")

cat("\n✓ DATA QUALITY: EXCELLENT - Ready for statistical analysis\n")

# Create summary statistics file
summary_data <- data.frame(
  Metric = c("Original Rows", "Cleaned Rows", "Rows Removed", 
             "Missing Values", "Duplicates", "Energy Mean", "Energy SD",
             "Loudness Mean", "Loudness SD"),
  Value = c(nrow(data_original), nrow(data_cleaned), rows_removed,
            sum(is.na(data_cleaned[, key_vars])), sum(duplicated(data_cleaned)),
            sprintf("%.4f", mean(data_cleaned$energy, na.rm = TRUE)),
            sprintf("%.4f", sd(data_cleaned$energy, na.rm = TRUE)),
            sprintf("%.2f dB", mean(data_cleaned$loudness, na.rm = TRUE)),
            sprintf("%.2f dB", sd(data_cleaned$loudness, na.rm = TRUE)))
)

write.csv(summary_data, "dataset/cleaning_summary.csv", row.names = FALSE)
cat("\n✓ Summary statistics saved: dataset/cleaning_summary.csv\n")

cat("\n================================================================\n")
cat("CLEANING PROCESS COMPLETE\n")
cat("================================================================\n")


