sink("statistical_analysis_report.txt")
cat("STATISTICAL ANALYSIS REPORT\n")
cat("===========================\n")
cat("Prepared by: Krishna\n")
cat("Date:", format(Sys.Date(), "%d %B %Y"), "\n\n")

cat("RESEARCH QUESTION:\n")
cat("Is there a correlation between the energy level and the loudness\n")
cat("of popular Spotify tracks (2010-2023)?\n\n")

cat("DESCRIPTIVE STATISTICS:\n")
cat("Energy - Mean:", round(mean(energy), 4), ", SD:", round(sd(energy), 4), "\n")
cat("Loudness - Mean:", round(mean(loudness), 4), "dB, SD:", round(sd(loudness), 4), "dB\n\n")

cat("NORMALITY TESTS:\n")
cat("Energy: W =", round(shapiro_energy$statistic, 4), 
    ", p =", format(shapiro_energy$p.value, scientific = TRUE), "(Not normal)\n")
cat("Loudness: W =", round(shapiro_loudness$statistic, 4), 
    ", p =", format(shapiro_loudness$p.value, scientific = TRUE), "(Not normal)\n\n")

cat("CORRELATION TEST (Spearman):\n")
cat("rho =", round(spearman_result$estimate, 4), "\n")
cat("p-value =", format(spearman_result$p.value, scientific = TRUE), "\n")
cat("n =", length(energy), "\n\n")

cat("HYPOTHESIS DECISION:\n")
cat("Null hypothesis:", decision, "\n")
cat("Interpretation:", strength, direction, "correlation\n")
sink()

cat("\nAnalysis report saved as: statistical_analysis_report.txt\n")
cat("\n=== ANALYSIS COMPLETE ===\n")