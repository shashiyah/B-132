set.seed(42)  # For reproducibility
sample_size <- min(2000, length(energy))
sample_indices <- sample(length(energy), sample_size)

shapiro_energy <- shapiro.test(energy[sample_indices])
cat("\n--- ENERGY ---\n")
cat("Shapiro-Wilk W statistic:", round(shapiro_energy$statistic, 4), "\n")
cat("p-value:", format(shapiro_energy$p.value, scientific = TRUE), "\n")
cat("Interpretation: ")
if (shapiro_energy$p.value > 0.05) {
  cat("Data IS normally distributed (p > 0.05)\n")
} else {
  cat("Data is NOT normally distributed (p < 0.05)\n")
}

shapiro_loudness <- shapiro.test(loudness[sample_indices])
cat("\n--- LOUDNESS ---\n")
cat("Shapiro-Wilk W statistic:", round(shapiro_loudness$statistic, 4), "\n")
cat("p-value:", format(shapiro_loudness$p.value, scientific = TRUE), "\n")
cat("Interpretation: ")
if (shapiro_loudness$p.value > 0.05) {
  cat("Data IS normally distributed (p > 0.05)\n")
} else {
  cat("Data is NOT normally distributed (p < 0.05)\n")
}

cat("\n--- TEST SELECTION DECISION ---\n")
if (shapiro_energy$p.value < 0.05 | shapiro_loudness$p.value < 0.05) {
  cat("Desicion: Use SPEARMAN correlation (data is not normal)\n")
  test_method <- "spearman"
} else {
  cat("Desicion: Use PEARSON correlation (data is normal)\n")
  test_method <- "pearson"
}