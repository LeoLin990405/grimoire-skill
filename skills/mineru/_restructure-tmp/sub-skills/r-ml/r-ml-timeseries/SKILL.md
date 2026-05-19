---
name: r-ml-timeseries
description: R time series forecasting. Use for prophet, forecast, fable, ARIMA, and exponential smoothing.
---

# R Time Series Forecasting

Time series analysis and forecasting.

## prophet (Facebook)

```r
library(prophet)

# Prepare data (must have 'ds' and 'y' columns)
df <- data.frame(
  ds = dates,
  y = values
)

# Fit model
model <- prophet(df)

# Future dates
future <- make_future_dataframe(model, periods = 365)

# Forecast
forecast <- predict(model, future)

# Plot
plot(model, forecast)
prophet_plot_components(model, forecast)

# With seasonality
model <- prophet(
  df,
  yearly.seasonality = TRUE,
  weekly.seasonality = TRUE,
  daily.seasonality = FALSE
)

# Add holidays
holidays <- data.frame(
  holiday = "event",
  ds = as.Date(c("2024-01-01", "2024-12-25")),
  lower_window = 0,
  upper_window = 1
)
model <- prophet(df, holidays = holidays)

# Add regressors
model <- prophet() %>%
  add_regressor("temperature") %>%
  fit.prophet(df)
```

## forecast

```r
library(forecast)

# Create time series
ts_data <- ts(values, frequency = 12, start = c(2020, 1))

# Auto ARIMA
model <- auto.arima(ts_data)
forecast_result <- forecast(model, h = 12)
plot(forecast_result)

# ETS (Exponential Smoothing)
model <- ets(ts_data)
forecast_result <- forecast(model, h = 12)

# TBATS (complex seasonality)
model <- tbats(ts_data)
forecast_result <- forecast(model, h = 12)

# STL decomposition
decomp <- stl(ts_data, s.window = "periodic")
plot(decomp)

# Accuracy
accuracy(forecast_result)
```

## fable (Tidy Forecasting)

```r
library(fable)
library(tsibble)

# Create tsibble
ts_data <- df %>%
  as_tsibble(index = date, key = id)

# Fit multiple models
models <- ts_data %>%
  model(
    arima = ARIMA(value),
    ets = ETS(value),
    snaive = SNAIVE(value)
  )

# Forecast
fc <- models %>% forecast(h = 12)

# Plot
fc %>% autoplot(ts_data)

# Accuracy
fc %>% accuracy(ts_data)

# Cross-validation
cv <- ts_data %>%
  stretch_tsibble(.init = 36, .step = 1) %>%
  model(ARIMA(value)) %>%
  forecast(h = 1) %>%
  accuracy(ts_data)
```

## ARIMA Manual

```r
library(forecast)

# Check stationarity
adf.test(ts_data)

# ACF/PACF
acf(ts_data)
pacf(ts_data)

# Differencing
diff_data <- diff(ts_data)

# Fit ARIMA(p, d, q)
model <- Arima(ts_data, order = c(1, 1, 1))

# Seasonal ARIMA
model <- Arima(ts_data, order = c(1, 1, 1), seasonal = c(1, 1, 1))

# Diagnostics
checkresiduals(model)
```

## VAR (Multivariate)

```r
library(vars)

# Fit VAR
model <- VAR(multivariate_ts, p = 2)

# Forecast
forecast_result <- predict(model, n.ahead = 12)
plot(forecast_result)

# Impulse response
irf <- irf(model, impulse = "var1", response = "var2", n.ahead = 10)
plot(irf)

# Granger causality
causality(model, cause = "var1")
```

## Comparison

| Package | Strengths | Use Case |
|---------|-----------|----------|
| prophet | Holidays, trends | Business |
| forecast | Classic methods | General |
| fable | Tidy, multiple models | Modern workflow |
| vars | Multivariate | Econometrics |
