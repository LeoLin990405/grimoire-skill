---
name: feasts
description: R feasts package for time series features. Use for extracting features and visualizing time series.
---

# feasts

Feature extraction and statistics for time series.

## Setup

```r
library(feasts)
library(tsibble)
library(dplyr)

# Convert to tsibble
ts_data <- as_tsibble(data, index = date)
```

## Decomposition

```r
# STL decomposition
ts_data %>%
  model(stl = STL(value)) %>%
  components() %>%
  autoplot()

# Classical decomposition
ts_data %>%
  model(classical = classical_decomposition(value)) %>%
  components()

# X11 decomposition
ts_data %>%
  model(x11 = X_13ARIMA_SEATS(value ~ x11())) %>%
  components()
```

## ACF/PACF

```r
# ACF plot
ts_data %>%
  ACF(value) %>%
  autoplot()

# PACF plot
ts_data %>%
  PACF(value) %>%
  autoplot()

# Combined
ts_data %>%
  gg_tsdisplay(value, plot_type = "partial")
```

## Seasonal Plots

```r
# Seasonal plot
ts_data %>%
  gg_season(value)

# Subseries plot
ts_data %>%
  gg_subseries(value)

# Lag plot
ts_data %>%
  gg_lag(value, lags = 1:12)
```

## Features

```r
# Extract features
ts_data %>%
  features(value, feature_set(pkgs = "feasts"))

# Specific features
ts_data %>%
  features(value, list(
    mean = mean,
    sd = sd,
    acf1 = ~ ACF(.x, lag_max = 1)$acf
  ))

# STL features
ts_data %>%
  features(value, feat_stl)

# ACF features
ts_data %>%
  features(value, feat_acf)

# Spectral features
ts_data %>%
  features(value, feat_spectral)
```

## Unit Root Tests

```r
# KPSS test
ts_data %>%
  features(value, unitroot_kpss)

# ADF test
ts_data %>%
  features(value, unitroot_ndiffs)

# Seasonal differences needed
ts_data %>%
  features(value, unitroot_nsdiffs)
```

## Guerrero Lambda

```r
# Find optimal Box-Cox lambda
ts_data %>%
  features(value, guerrero)
```

## Feature Comparison

```r
# Compare multiple series
ts_data %>%
  group_by(series) %>%
  features(value, feature_set(pkgs = "feasts")) %>%
  select(series, trend_strength, seasonal_strength_year)
```
