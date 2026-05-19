---
name: forecast
description: R forecast package for time series forecasting. Use for ARIMA, ETS, and automatic forecasting.
---

# forecast Package

Time series forecasting methods.

## Basic Forecasting

```r
library(forecast)

# Create time series
ts_data <- ts(data, frequency = 12, start = c(2020, 1))

# Auto ARIMA
fit <- auto.arima(ts_data)
fc <- forecast(fit, h = 12)
plot(fc)

# ETS (Exponential Smoothing)
fit <- ets(ts_data)
fc <- forecast(fit, h = 12)
```

## ARIMA

```r
# Automatic
fit <- auto.arima(ts_data,
  seasonal = TRUE,
  stepwise = FALSE,
  approximation = FALSE
)

# Manual
fit <- Arima(ts_data, order = c(1, 1, 1), seasonal = c(1, 1, 1))

# Diagnostics
checkresiduals(fit)
```

## ETS Models

```r
# Automatic
fit <- ets(ts_data)

# Specific model (A=Additive, M=Multiplicative, N=None)
fit <- ets(ts_data, model = "MAM")  # Multiplicative error, Additive trend, Multiplicative season
```

## Other Methods

```r
# Theta
fit <- thetaf(ts_data, h = 12)

# TBATS (complex seasonality)
fit <- tbats(ts_data)
fc <- forecast(fit, h = 12)

# Neural network
fit <- nnetar(ts_data)
fc <- forecast(fit, h = 12)

# STL decomposition + ETS
fit <- stlf(ts_data, h = 12)
```

## Accuracy

```r
# Train/test split
train <- window(ts_data, end = c(2022, 12))
test <- window(ts_data, start = c(2023, 1))

fit <- auto.arima(train)
fc <- forecast(fit, h = length(test))
accuracy(fc, test)
```

## Cross-Validation

```r
# Time series CV
errors <- tsCV(ts_data, forecastfunction = function(x, h) {
  forecast(auto.arima(x), h = h)
}, h = 12)

sqrt(mean(errors^2, na.rm = TRUE))  # RMSE
```
