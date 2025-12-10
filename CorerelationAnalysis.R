spearman_result <- cor.test(energy, loudness, method = "spearman")

cat("\n--- SPEARMAN'S RANK CORRELATION ---\n")
cat("(Used because data is NOT normally distributed)\n\n")
cat("Correlation coefficient (rho): ", round(spearman_result$estimate, 4), "\n")
cat("p-value:                       ", format(spearman_result$p.value, scientific = TRUE), "\n")
cat("Sample size (n):               ", length(energy), "\n")
cat("Test statistic (S):            ", format(spearman_result$statistic, scientific = TRUE), "\n")

pearson_result <- cor.test(energy, loudness, method = "pearson")

cat("\n--- PEARSON CORRELATION (for comparison only) ---\n")
cat("Correlation coefficient (r):   ", round(pearson_result$estimate, 4), "\n")
cat("p-value:                       ", format(pearson_result$p.value, scientific = TRUE), "\n")
