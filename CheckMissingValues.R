cat("\n=== MISSING VALUES CHECK ===\n")

missing_counts <- colSums(is.na(df))
print(missing_counts)

cat("\n--- Key Variables for Analysis ---\n")
cat("Energy - Missing values:", sum(is.na(df$energy)), "\n")
cat("Loudness - Missing values:", sum(is.na(df$loudness)), "\n")
cat("Year - Missing values:", sum(is.na(df$year)), "\n")

cat("\n--- Percentage Missing ---\n")
missing_percent <- round((colSums(is.na(df)) / nrow(df)) * 100, 2)
print(missing_percent[missing_percent > 0])