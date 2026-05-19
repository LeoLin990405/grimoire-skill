---
name: prophet
description: R prophet package for time series forecasting. Use for forecasting with seasonality, holidays, and trend changes.
---

# prophet

Facebook's forecasting tool.

## Basic Usage

```r
library(prophet)

# Prepare data (must have 'ds' and 'y' columns)
df <- data.frame(
  ds = dates,
  y = values
)

# Fit model
model <- prophet(df)

# Create future dataframe
future <- make_future_dataframe(model, periods = 365)

# Predict
forecast <- predict(model, future)

# Plot
plot(model, forecast)
dyplot.prophet(model, forecast)  # Interactive
```

## Seasonality

```r
# Default: yearly, weekly, daily (if sub-daily data)
model <- prophet(df)

# Disable seasonality
model <- prophet(df, yearly.seasonality = FALSE)
model <- prophet(df, weekly.seasonality = FALSE)
model <- prophet(df, daily.seasonality = FALSE)

# Custom seasonality
model <- prophet(df, yearly.seasonality = FALSE)
model <- add_seasonality(
  model,
  name = "monthly",
  period = 30.5,
  fourier.order = 5
)
model <- fit.prophet(model, df)

# Multiplicative seasonality
model <- prophet(df, seasonality.mode = "multiplicative")
```

## Holidays

```r
# Define holidays
holidays <- data.frame(
  holiday = c("christmas", "christmas", "newyear", "newyear"),
  ds = as.Date(c("2023-12-25", "2024-12-25", "2024-01-01", "2025-01-01")),
  lower_window = 0,
  upper_window = 1
)

model <- prophet(df, holidays = holidays)

# Country holidays
model <- prophet(df)
model <- add_country_holidays(model, country_name = "US")
model <- fit.prophet(model, df)
```

## Trend

```r
# Linear trend (default)
model <- prophet(df, growth = "linear")

# Logistic growth (with cap)
df$cap <- 100
df$floor <- 0
model <- prophet(df, growth = "logistic")

# Flat trend
model <- prophet(df, growth = "flat")

# Changepoints
model <- prophet(df, changepoints = c("2023-01-01", "2023-06-01"))
model <- prophet(df, n.changepoints = 25)
model <- prophet(df, changepoint.range = 0.8)
model <- prophet(df, changepoint.prior.scale = 0.05)
```

## Regressors

```r
# Add regressor
df$regressor <- regressor_values

model <- prophet(df)
model <- add_regressor(model, "regressor")
model <- fit.prophet(model, df)

# Future must include regressor
future <- make_future_dataframe(model, periods = 365)
future$regressor <- future_regressor_values
forecast <- predict(model, future)
```

## Uncertainty

```r
# Uncertainty intervals
model <- prophet(df, interval.width = 0.95)

# MCMC sampling
model <- prophet(df, mcmc.samples = 300)
```

## Cross-Validation

```r
# Cross-validation
cv <- cross_validation(
  model,
  initial = 730,      # Initial training period (days)
  period = 180,       # Spacing between cutoffs
  horizon = 365       # Forecast horizon
)

# Performance metrics
metrics <- performance_metrics(cv)
head(metrics)

# Plot
plot_cross_validation_metric(cv, metric = "mape")
```

## Components

```r
# Plot components
prophet_plot_components(model, forecast)

# Extract components
forecast$trend
forecast$yearly
forecast$weekly
forecast$holidays
```
