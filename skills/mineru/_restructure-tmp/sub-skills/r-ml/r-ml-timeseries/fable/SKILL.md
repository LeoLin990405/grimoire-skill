---
name: fable
description: R fable package for tidy time series forecasting. Use for modern forecasting with tsibble integration.
---

# fable Package

Tidy time series forecasting.

## Setup

```r
library(fable)
library(tsibble)
library(feasts)

# Create tsibble
ts_data <- df %>%
  as_tsibble(index = date, key = id)
```

## Basic Forecasting

```r
# Fit models
fit <- ts_data %>%
  model(
    arima = ARIMA(value),
    ets = ETS(value),
    naive = NAIVE(value)
  )

# Forecast
fc <- fit %>% forecast(h = 12)

# Plot
fc %>% autoplot(ts_data)
```

## Model Specifications

```r
# ARIMA
ARIMA(value)
ARIMA(value ~ pdq(1,1,1) + PDQ(1,1,1))

# ETS
ETS(value)
ETS(value ~ error("A") + trend("A") + season("M"))

# TSLM (regression)
TSLM(value ~ trend() + season())

# Prophet
prophet(value ~ season(period = "year", order = 10))
```

## Multiple Series

```r
# Fit by group
fit <- ts_data %>%
  model(arima = ARIMA(value))

# Forecast all
fc <- fit %>% forecast(h = 12)

# Accuracy by group
accuracy(fit)
```

## Decomposition

```r
ts_data %>%
  model(STL(value ~ season(window = "periodic"))) %>%
  components() %>%
  autoplot()
```

## Cross-Validation

```r
# Stretch tsibble
cv_data <- ts_data %>%
  stretch_tsibble(.init = 100, .step = 1)

# Fit and forecast
cv_fc <- cv_data %>%
  model(ARIMA(value)) %>%
  forecast(h = 1)

# Accuracy
cv_fc %>% accuracy(ts_data)
```

## Reconciliation

```r
# Hierarchical forecasting
fit <- ts_data %>%
  aggregate_key(region / store, value = sum(value)) %>%
  model(ets = ETS(value))

fc <- fit %>%
  reconcile(ets = min_trace(ets)) %>%
  forecast(h = 12)
```
