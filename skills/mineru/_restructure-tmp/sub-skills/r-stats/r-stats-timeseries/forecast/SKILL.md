---
name: forecast
description: R forecast package for time series forecasting. Use for ARIMA, ETS, and other forecasting methods.
---

# forecast

Forecasting functions for time series.

## Time Series Objects

```r
library(forecast)

# Create ts object
ts_data <- ts(data, start = c(2020, 1), frequency = 12)

# From vector
ts_data <- ts(values, frequency = 4)  # Quarterly
```

## Auto ARIMA

```r
# Automatic ARIMA
fit <- auto.arima(ts_data)

# Forecast
fc <- forecast(fit, h = 12)
plot(fc)

# With options
fit <- auto.arima(ts_data,
  seasonal = TRUE,
  stepwise = FALSE,
  approximation = FALSE)
```

## ETS (Exponential Smoothing)

```r
# Automatic ETS
fit <- ets(ts_data)
fc <- forecast(fit, h = 12)

# Specific model
fit <- ets(ts_data, model = "MAM")  # Multiplicative error, additive trend, multiplicative season
```

## TBATS

```r
# For complex seasonality
fit <- tbats(ts_data)
fc <- forecast(fit, h = 24)
```

## Simple Methods

```r
# Naive
naive(ts_data, h = 12)

# Seasonal naive
snaive(ts_data, h = 12)

# Mean
meanf(ts_data, h = 12)

# Random walk with drift
rwf(ts_data, h = 12, drift = TRUE)
```

## Decomposition

```r
# STL decomposition
stl_fit <- stl(ts_data, s.window = "periodic")
plot(stl_fit)

# Forecast from STL
stlf(ts_data, h = 12)

# MSTL for multiple seasonality
mstl(ts_data)
```

## Accuracy

```r
# Fit accuracy
accuracy(fit)

# Forecast accuracy
accuracy(fc, test_data)

# Cross-validation
tsCV(ts_data, forecastfunction = naive, h = 1)
```

## Diagnostics

```r
# Residual diagnostics
checkresiduals(fit)

# ACF/PACF
Acf(ts_data)
Pacf(ts_data)

# Ljung-Box test
Box.test(residuals(fit), type = "Ljung-Box")
```

## Neural Network

```r
# Neural network autoregression
fit <- nnetar(ts_data)
fc <- forecast(fit, h = 12)
```

## Plotting

```r
# Forecast plot
autoplot(fc)

# With ggplot2
autoplot(fc) +
  autolayer(fitted(fit), series = "Fitted")
```
