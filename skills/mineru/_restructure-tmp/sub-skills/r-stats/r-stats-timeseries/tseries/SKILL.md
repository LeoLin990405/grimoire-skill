---
name: tseries
description: R tseries package for time series analysis. Use for time series tests and GARCH models.
---

# tseries

Time series analysis and computational finance.

## Stationarity Tests

```r
library(tseries)

# Augmented Dickey-Fuller test
adf.test(ts_data)
# H0: non-stationary (unit root)
# p < 0.05 -> reject H0 -> stationary

# KPSS test
kpss.test(ts_data)
# H0: stationary
# p < 0.05 -> reject H0 -> non-stationary

# Phillips-Perron test
pp.test(ts_data)
```

## GARCH Models

```r
# Fit GARCH(1,1)
fit <- garch(returns, order = c(1, 1))
summary(fit)

# Residuals
residuals(fit)

# Fitted values
fitted(fit)
```

## ARMA

```r
# Fit ARMA
fit <- arma(ts_data, order = c(2, 1))
summary(fit)
```

## Jarque-Bera Test

```r
# Test for normality
jarque.bera.test(returns)
# H0: data is normally distributed
```

## Runs Test

```r
# Test for randomness
runs.test(as.factor(sign(returns)))
```

## BDS Test

```r
# Test for independence
bds.test(returns)
```

## Portfolio Optimization

```r
# Efficient frontier
portfolio.optim(returns_matrix)

# With constraints
portfolio.optim(returns_matrix,
  pm = target_return,
  shorts = FALSE)
```

## Cointegration

```r
# Engle-Granger test
po.test(cbind(x, y))

# Phillips-Ouliaris test
po.test(cbind(x, y), type = "Pu")
```

## Autocorrelation

```r
# Ljung-Box test
Box.test(ts_data, type = "Ljung-Box", lag = 10)

# Box-Pierce test
Box.test(ts_data, type = "Box-Pierce")
```

## Data

```r
# Get financial data
get.hist.quote(instrument = "AAPL",
  start = "2020-01-01",
  end = "2023-12-31",
  quote = "Close")
```
