
rho <- spearman_result$estimate

if (abs(rho) >= 0.7) {
  strength <- "STRONG"
} else if (abs(rho) >= 0.5) {
  strength <- "MODERATE-TO-STRONG"
} else if (abs(rho) >= 0.3) {
  strength <- "MODERATE"
} else if (abs(rho) >= 0.1) {
  strength <- "WEAK"
} else {
  strength <- "VERY WEAK / NEGLIGIBLE"
}

direction <- ifelse(rho > 0, "POSITIVE", "NEGATIVE")

cat("\nCorrelation coefficient (rho):", round(rho, 4), "\n")
cat("Direction:", direction, "\n")
cat("Strength:", strength, "\n")

cat("\nInterpretation:\n")
cat("There is a", tolower(strength), tolower(direction), "correlation between\n")
cat("energy and loudness in popular Spotify tracks.\n")