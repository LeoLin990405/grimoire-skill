---
name: anomalize
description: R anomalize package for tidy anomaly detection. Use for detecting anomalies in time series with tidyverse workflow.
---

# anomalize

Tidy anomaly detection for time series.

## Basic Usage

```r
library(anomalize)
library(tidyverse)
library(tibbletime)

# Detect anomalies
df %>%
  time_decompose(value) %>%
  anomalize(remainder) %>%
  time_recompose()
```

## Full Workflow

```r
# Complete anomaly detection pipeline
result <- df %>%
  # Decompose time series
  time_decompose(value, method = "stl") %>%
  # Detect anomalies in remainder
  anomalize(remainder, method = "iqr") %>%
  # Recompose with anomaly bounds
  time_recompose()

# View anomalies
result %>% filter(anomaly == "Yes")
```

## Decomposition Methods

```r
# STL decomposition (default)
df %>% time_decompose(value, method = "stl")

# Twitter decomposition
df %>% time_decompose(value, method = "twitter")

# With frequency and trend
df %>% time_decompose(value,
  method = "stl",
  frequency = "auto",
  trend = "auto"
)
```

## Anomaly Detection Methods

```r
# IQR method (default)
df %>%
  time_decompose(value) %>%
  anomalize(remainder, method = "iqr", alpha = 0.05)

# GESD method (Generalized ESD)
df %>%
  time_decompose(value) %>%
  anomalize(remainder, method = "gesd", alpha = 0.05, max_anoms = 0.2)
```

## Visualization

```r
# Plot decomposition
df %>%
  time_decompose(value) %>%
  anomalize(remainder) %>%
  plot_anomaly_decomposition()

# Plot anomalies
df %>%
  time_decompose(value) %>%
  anomalize(remainder) %>%
  time_recompose() %>%
  plot_anomalies(time_recomposed = TRUE)
```

## Parameters

```r
# Alpha: significance level (lower = fewer anomalies)
df %>%
  time_decompose(value) %>%
  anomalize(remainder, alpha = 0.01)  # More strict

# Max anomalies (for GESD)
df %>%
  time_decompose(value) %>%
  anomalize(remainder, method = "gesd", max_anoms = 0.1)
```

## Grouped Analysis

```r
# Detect anomalies by group
df %>%
  group_by(category) %>%
  time_decompose(value) %>%
  anomalize(remainder) %>%
  time_recompose()

# Plot by group
df %>%
  group_by(category) %>%
  time_decompose(value) %>%
  anomalize(remainder) %>%
  time_recompose() %>%
  plot_anomalies(ncol = 2)
```

## Frequency and Trend

```r
# Auto-detect frequency
time_frequency(df, period = "auto")

# Auto-detect trend
time_trend(df, period = "auto")

# Manual specification
df %>% time_decompose(value,
  frequency = "1 week",
  trend = "3 months"
)
```

## Clean Anomalies

```r
# Replace anomalies with interpolated values
df_clean <- df %>%
  time_decompose(value) %>%
  anomalize(remainder) %>%
  clean_anomalies()
```

## Extract Components

```r
result <- df %>%
  time_decompose(value) %>%
  anomalize(remainder) %>%
  time_recompose()

# Components available:
# - observed: original values
# - season: seasonal component
# - trend: trend component
# - remainder: residual
# - anomaly: "Yes" or "No"
# - recomposed_l1: lower bound
# - recomposed_l2: upper bound
```

## With tibbletime

```r
library(tibbletime)

# Create tbl_time object
df_time <- df %>%
  as_tbl_time(index = date)

# Anomaly detection
df_time %>%
  time_decompose(value) %>%
  anomalize(remainder) %>%
  time_recompose()
```
