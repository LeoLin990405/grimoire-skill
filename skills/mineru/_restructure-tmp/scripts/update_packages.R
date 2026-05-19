#!/usr/bin/env Rscript
# Update all installed R packages
# Usage: Rscript update_packages.R

options(repos = c(CRAN = "https://cloud.r-project.org"))

cat("Checking for package updates...\n")
update.packages(ask = FALSE, checkBuilt = TRUE)
cat("Done.\n")
