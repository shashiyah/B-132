png("Figure3_Combined_Analysis.png", 
    width = 1200, height = 900, res = 100)

layout(matrix(c(1, 1, 2, 3), nrow = 2, byrow = TRUE))

par(mar = c(4, 4, 3, 2))
plot(energy, loudness,
     main = "Figure 1: Correlation Between Energy and Loudness\nin Popular Spotify Tracks (2010-2023)",
     xlab = "Energy Level (0-1 scale)",
     ylab = "Loudness (dB)",
     col = rgb(0.27, 0.51, 0.71, 0.5),
     pch = 19, cex = 0.7)
abline(lm(loudness ~ energy), col = "red", lwd = 2)
legend("bottomright", 
       legend = c(paste("Spearman ρ =", rho), "p < 0.001", paste("n =", length(energy))),
       bty = "n", cex = 0.9)
grid(col = "gray80")

par(mar = c(4, 4, 3, 1))
hist(energy, main = "Figure 2a: Distribution of Energy",
     xlab = "Energy (0-1)", ylab = "Frequency",
     col = "steelblue", breaks = 25)
abline(v = mean(energy), col = "red", lwd = 2, lty = 2)

par(mar = c(4, 4, 3, 1))
hist(loudness, main = "Figure 2b: Distribution of Loudness",
     xlab = "Loudness (dB)", ylab = "Frequency",
     col = "coral", breaks = 25)
abline(v = mean(loudness), col = "red", lwd = 2, lty = 2)

dev.off()

cat("Saved: Figure3_Combined_Analysis.png\n")