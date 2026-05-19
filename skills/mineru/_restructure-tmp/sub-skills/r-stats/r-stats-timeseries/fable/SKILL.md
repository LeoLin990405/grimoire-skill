---
name: fable
description: R fable package for tidy forecasting. Use for forecasting with tidyverse-compatible syntax.
---

# fable

Tidy forecasting with tsibble.

## Setup

```r
library(fable)
library(tsibble)
library(dplyr)

# Convert to tsibble
ts_data <- as_tsibble(data, index = date)
```

## Model Fitting

```r
# Single model
fit <- ts_data %>%
  model(arima = ARIMA(value))

# Multiple models
fit <- ts_data %>%
  model(
    arima = ARIMA(value),
    ets = ETS(value),
    naive = NAIVE(value)
  )
```

## Forecasting

```r
# Generate forecasts
fc <- fit %>%
  forecast(h = 12)

# Plot
fc %>% autoplot(ts_data)

# With intervals
fc %>%
  hilo(level = c(80, 95))
```

## Model Types

```r
# ARIMA
ARIMA(value)
ARIMA(value ~ pdq(1,1,1) + PDQ(1,1,1))

# ETS
ETS(value)
ETS(value ~ error("A") + trend("A") + season("M"))

# TSLM (regression)
TSLM(value ~ trend() + season())

# NNETAR
NNETAR(value)

# Prophet (via fable.prophet)
prophet(value)
```

## Grouped Forecasting

```r
# Forecast by group
fit <- ts_data %>%
  group_by(region) %>%
  model(arima = ARIMA(value))

fc <- fit %>%
  forecast(h = 12)
```

## Accuracy

```r
# Training accuracy
accuracy(fit)

# Test accuracy
fc %>%
  accuracy(test_data)

# Cross-validation
ts_data %>%
  stretch_tsibble(.init = 36, .step = 1) %>%
  model(arima = ARIMA(value)) %>%
  forecast(h = 1) %>%
  accuracy(ts_data)
```

## Components

```r
# Extract components
fit %>%
  components()

# Residuals
fit %>%
  augment()
```

## Combination

```r
# Combine forecasts
fit <- ts_data %>%
  model(
    arima = ARIMA(value),
    ets = ETS(value)
  ) %>%
  mutate(combination = (arima + ets) / 2)
```

## Reconciliation

```r
# Hierarchical forecasting
fit <- ts_data %>%
  aggregate_key(region / store, value = sum(value)) %>%
  model(arima = ARIMA(value)) %>%
  reconcile(arima = min_trace(arima))
```
