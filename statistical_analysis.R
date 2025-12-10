df <- read.csv("playlist_cleaned.csv")

cat("=== DATA VERIFICATION ===\n")
cat("Number of tracks:", nrow(df), "\n")
cat("Variables:", ncol(df), "\n\n")

energy <- df$energy
loudness <- df$loudness

cat("\n--- ENERGY (0-1 scale) ---\n")
cat("Mean:     ", round(mean(energy), 4), "\n")
cat("Median:   ", round(median(energy), 4), "\n")
cat("Std Dev:  ", round(sd(energy), 4), "\n")
cat("Min:      ", round(min(energy), 4), "\n")
cat("Max:      ", round(max(energy), 4), "\n")
cat("Range:    ", round(max(energy) - min(energy), 4), "\n")

cat("\n--- LOUDNESS (dB) ---\n")
cat("Mean:     ", round(mean(loudness), 4), "dB\n")
cat("Median:   ", round(median(loudness), 4), "dB\n")
cat("Std Dev:  ", round(sd(loudness), 4), "dB\n")
cat("Min:      ", round(min(loudness), 4), "dB\n")
cat("Max:      ", round(max(loudness), 4), "dB\n")
cat("Range:    ", round(max(loudness) - min(loudness), 4), "dB\n")