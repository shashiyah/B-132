cat("\n=== DUPLICATE CHECK ===\n")

duplicate_tracks <- sum(duplicated(df$track_id))
cat("Duplicate track IDs:", duplicate_tracks, "\n")

duplicate_rows <- sum(duplicated(df))
cat("Completely duplicate rows:", duplicate_rows, "\n")

if (duplicate_rows > 0) {
  cat("\nDuplicate rows found - investigating...\n")
  duplicated_data <- df[duplicated(df) | duplicated(df, fromLast = TRUE), ]
  print(head(duplicated_data))
}