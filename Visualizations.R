df <- read.csv("playlist_cleaned.csv")

energy <- df$energy
loudness <- df$loudness

cor_result <- cor.test(energy, loudness, method = "spearman")
rho <- round(cor_result$estimate, 4)

png("Figure1_Scatterplot_Energy_Loudness.png", 
    width = 800, height = 600, res = 100)

# Create the plot
plot(energy, loudness,
     main = "Scatterplot: Correlation Between Energy and Loudness\nin Popular Spotify Tracks (2010-2023)",
     xlab = "Energy Level (0-1 scale)",
     ylab = "Loudness (dB)",
     col = rgb(0.27, 0.51, 0.71, 0.5),  
     pch = 19,                           
     cex = 0.8)                          

abline(lm(loudness ~ energy), col = "red", lwd = 2)

legend("bottomright", 
       legend = c(paste("Spearman ρ =", rho),
                  "p-value < 0.001",
                  paste("n =", length(energy))),
       bty = "n",    
       cex = 0.9)

grid(col = "gray80")

dev.off()

cat("Saved: Figure1_Scatterplot_Energy_Loudness.png\n")