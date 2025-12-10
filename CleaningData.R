df_clean <- df

df_clean <- subset(df_clean, year >= 2010 & year <= 2023)
cat("After year filter (2010-2023):", nrow(df_clean), "tracks\n")

df_clean <- df_clean[complete.cases(df_clean$energy, df_clean$loudness), ]
cat("After removing missing values:", nrow(df_clean), "tracks\n")

df_clean <- df_clean[!duplicated(df_clean$track_id), ]
cat("After removing duplicates:", nrow(df_clean), "tracks\n")

cat("\n=== FINAL CLEANED DATASET ===\n")
cat("Original dataset:", nrow(df), "tracks\n")
cat("Cleaned dataset:", nrow(df_clean), "tracks\n")
cat("Records removed:", nrow(df) - nrow(df_clean), "\n")