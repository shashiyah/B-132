df <- read.csv("playlist_2010to2023.csv", fileEncoding = "latin1")

cat("=== FIRST 6 ROWS ===\n")
head(df)

cat("\n=== DATASET SIZE ===\n")
cat("Number of rows (tracks):", nrow(df), "\n")
cat("Number of columns (variables):", ncol(df), "\n")

cat("\n=== COLUMN NAMES ===\n")
print(names(df))

cat("\n=== DATA STRUCTURE ===\n")
str(df)

cat("\n=== SUMMARY STATISTICS ===\n")
summary(df)