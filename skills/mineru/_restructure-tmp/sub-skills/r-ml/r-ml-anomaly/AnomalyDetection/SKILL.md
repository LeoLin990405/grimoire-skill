---
name: AnomalyDetection
description: R AnomalyDetection package from Twitter. Use for detecting anomalies in time series data.
---

# AnomalyDetection

Twitter's anomaly detection for time series.

## Installation

```r
# From GitHub (not on CRAN)
devtools::install_github("twitter/AnomalyDetection")
library(AnomalyDetection)
```

## Basic Usage

```r
# Detect anomalies in time series
result <- AnomalyDetectionTs(df, max_anoms = 0.02, direction = "both")

# View anomalies
result$anoms

# Plot
result$plot
```

## Parameters

```r
result <- AnomalyDetectionTs(
  df,                    # Data frame with timestamp and value columns
  max_anoms = 0.02,      # Max proportion of anomalies (0-0.49)
  direction = "both",    # "pos", "neg", or "both"
  alpha = 0.05,          # Significance level
  only_last = NULL,      # "day" or "hr" for recent anomalies only
  threshold = "None",    # "med_max", "p95", "p99" for filtering
  e_value = FALSE,       # Return expected value
  longterm = FALSE,      # Use piecewise median for long series
  piecewise_median_period_weeks = 2,
  plot = TRUE,           # Generate plot
  y_log = FALSE,         # Log scale
  xlabel = "",
  ylabel = "count"
)
```

## Vector Input

```r
# For raw vectors (no timestamps)
result <- AnomalyDetectionVec(
  x,                     # Numeric vector
  max_anoms = 0.02,
  direction = "both",
  alpha = 0.05,
  period = NULL,         # Seasonality period
  only_last = FALSE,
  threshold = "None",
  e_value = FALSE,
  longterm_period = NULL,
  plot = TRUE
)
```

## Direction Options

```r
# Positive anomalies only (spikes)
result <- AnomalyDetectionTs(df, direction = "pos")

# Negative anomalies only (dips)
result <- AnomalyDetectionTs(df, direction = "neg")

# Both directions
result <- AnomalyDetectionTs(df, direction = "both")
```

## Threshold Filtering

```r
# Only report anomalies above median max
result <- AnomalyDetectionTs(df, threshold = "med_max")

# Only report anomalies above 95th percentile
result <- AnomalyDetectionTs(df, threshold = "p95")

# Only report anomalies above 99th percentile
result <- AnomalyDetectionTs(df, threshold = "p99")
```

## Long Time Series

```r
# For series spanning months/years
result <- AnomalyDetectionTs(
  df,
  longterm = TRUE,
  piecewise_median_period_weeks = 4
)
```

## Recent Anomalies

```r
# Only last day
result <- AnomalyDetectionTs(df, only_last = "day")

# Only last hour
result <- AnomalyDetectionTs(df, only_last = "hr")
```

## Data Format

```r
# Required format: data frame with 2 columns
# Column 1: timestamp (POSIXct or character)
# Column 2: numeric value

df <- data.frame(
  timestamp = seq(as.POSIXct("2024-01-01"), by = "hour", length.out = 1000),
  count = rnorm(1000, mean = 100, sd = 10)
)

# Add some anomalies
df$count[c(100, 500, 800)] <- c(200, 20, 180)

result <- AnomalyDetectionTs(df, max_anoms = 0.02)
```

## Extract Results

```r
# Anomaly data frame
anomalies <- result$anoms
# Contains: timestamp, anoms (value)

# Plot object (ggplot)
plot <- result$plot

# Save plot
ggsave("anomalies.png", result$plot)
```
