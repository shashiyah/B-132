alpha <- 0.05  # Significance level

cat("\n--- HYPOTHESES ---\n")
cat("H0: There is NO correlation between energy and loudness\n")
cat("H1: There IS a correlation between energy and loudness\n")

cat("\n--- TEST RESULTS ---\n")
cat("Significance level (α):", alpha, "\n")
cat("p-value:", format(spearman_result$p.value, scientific = TRUE), "\n")

cat("\n--- DECISION ---\n")
if (spearman_result$p.value < alpha) {
  cat("Since p-value (", format(spearman_result$p.value, scientific = TRUE), 
      ") < α (", alpha, ")\n", sep = "")
  cat("\n*** REJECT THE NULL HYPOTHESIS ***\n")
  cat("\nConclusion: There is a statistically significant correlation\n")
  cat("between energy and loudness in popular Spotify tracks (2010-2023).\n")
  decision <- "Rejected"
} else {
  cat("Since p-value (", format(spearman_result$p.value, scientific = TRUE), 
      ") >= α (", alpha, ")\n", sep = "")
  cat("\n*** FAIL TO REJECT THE NULL HYPOTHESIS ***\n")
  cat("\nConclusion: There is NO statistically significant correlation\n")
  cat("between energy and loudness in popular Spotify tracks (2010-2023).\n")
  decision <- "NOT REJECTED"
}