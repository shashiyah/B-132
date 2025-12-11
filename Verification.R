cat("\n=== VERIFICATION ===\n")
files_created <- c(
  "Figure1_Scatterplot_Energy_Loudness.png",
  "Figure2_Histograms_Energy_Loudness.png",
  "Figure3_Combined_Analysis.png"
)

for (f in files_created) {
  if (file.exists(f)) {
    cat("✓", f, "- Created successfully\n")
  } else {
    cat("✗", f, "- NOT FOUND\n")
  }
}
