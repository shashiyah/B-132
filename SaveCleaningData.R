write.csv(df_clean, "playlist_cleaned.csv", row.names = FALSE)
cat("\nCleaned dataset saved as: playlist_cleaned.csv\n")

sink("data_cleaning_report.txt")
cat("DATA CLEANING REPORT\n")
cat("====================\n")
cat("Prepared by: Ade\n")
cat("Date:", format(Sys.Date(), "%d %B %Y"), "\n\n")
cat("Original records:", nrow(df), "\n")
cat("Final records:", nrow(df_clean), "\n")
cat("Records removed:", nrow(df) - nrow(df_clean), "\n\n")
cat("Key Variables Summary:\n")
cat("- Energy: Mean =", round(mean(df_clean$energy), 4), 
    ", Range =", round(min(df_clean$energy), 4), "-", round(max(df_clean$energy), 4), "\n")
cat("- Loudness: Mean =", round(mean(df_clean$loudness), 4), "dB",
    ", Range =", round(min(df_clean$loudness), 4), "-", round(max(df_clean$loudness), 4), "dB\n")
sink()
cat("Report saved as: data_cleaning_report.txt\n")