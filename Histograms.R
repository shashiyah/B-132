png("Figure2_Histograms_Energy_Loudness.png", 
    width = 1000, height = 450, res = 100)

par(mfrow = c(1, 2))

hist(energy, 
     main = "Distribution of Energy\nin Spotify Tracks (2010-2023)",
     xlab = "Energy Level (0-1 scale)",
     ylab = "Frequency",
     col = "steelblue",
     border = "black",
     breaks = 25)

abline(v = mean(energy), col = "red", lwd = 2, lty = 2)

abline(v = median(energy), col = "green", lwd = 2, lty = 2)

legend("topleft", 
       legend = c(paste("Mean =", round(mean(energy), 3)),
                  paste("Median =", round(median(energy), 3))),
       col = c("red", "green"), 
       lty = 2, lwd = 2, 
       bty = "n", cex = 0.8)

hist(loudness, 
     main = "Distribution of Loudness\nin Spotify Tracks (2010-2023)",
     xlab = "Loudness (dB)",
     ylab = "Frequency",
     col = "coral",
     border = "black",
     breaks = 25)

abline(v = mean(loudness), col = "red", lwd = 2, lty = 2)

abline(v = median(loudness), col = "green", lwd = 2, lty = 2)

legend("topleft", 
       legend = c(paste("Mean =", round(mean(loudness), 2), "dB"),
                  paste("Median =", round(median(loudness), 2), "dB")),
       col = c("red", "green"), 
       lty = 2, lwd = 2, 
       bty = "n", cex = 0.8)

par(mfrow = c(1, 1))

dev.off()

cat("Saved: Figure2_Histograms_Energy_Loudness.png\n")