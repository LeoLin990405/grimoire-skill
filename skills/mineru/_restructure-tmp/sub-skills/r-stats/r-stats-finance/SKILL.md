---
name: r-stats-finance
description: R quantitative finance with quantmod, PerformanceAnalytics, tidyquant. Use for stock data, portfolio analysis, and technical indicators.
---

# R Quantitative Finance

Financial analysis and trading.

## quantmod

```r
library(quantmod)

# Get stock data
getSymbols("AAPL", from = "2020-01-01")
getSymbols(c("AAPL", "GOOGL", "MSFT"), src = "yahoo")

# Access OHLCV
Op(AAPL)  # Open
Hi(AAPL)  # High
Lo(AAPL)  # Low
Cl(AAPL)  # Close
Vo(AAPL)  # Volume
Ad(AAPL)  # Adjusted

# Charts
chartSeries(AAPL)
addBBands()
addMACD()
addRSI()
addSMA(n = 50)
addEMA(n = 20)

# Returns
dailyReturn(AAPL)
weeklyReturn(AAPL)
monthlyReturn(AAPL)
annualReturn(AAPL)

# Technical indicators
SMA(Cl(AAPL), n = 20)
EMA(Cl(AAPL), n = 20)
RSI(Cl(AAPL), n = 14)
MACD(Cl(AAPL))
BBands(HLC(AAPL))
```

## PerformanceAnalytics

```r
library(PerformanceAnalytics)

# Calculate returns
returns <- Return.calculate(prices)

# Performance metrics
Return.annualized(returns)
StdDev.annualized(returns)
SharpeRatio(returns, Rf = 0.02/252)
SortinoRatio(returns)
maxDrawdown(returns)

# Tables
table.AnnualizedReturns(returns)
table.CalendarReturns(returns)
table.Drawdowns(returns)
table.DownsideRisk(returns)

# Charts
charts.PerformanceSummary(returns)
chart.RollingPerformance(returns)
chart.Drawdown(returns)
chart.CumReturns(returns)
chart.Histogram(returns)

# Risk metrics
VaR(returns, p = 0.95, method = "historical")
ES(returns, p = 0.95)  # Expected Shortfall
```

## tidyquant

```r
library(tidyquant)

# Get data (tidy)
prices <- tq_get(c("AAPL", "GOOGL"), from = "2020-01-01")

# Returns
returns <- prices %>%
  group_by(symbol) %>%
  tq_transmute(select = adjusted, mutate_fun = periodReturn, period = "daily")

# Technical indicators
prices %>%
  group_by(symbol) %>%
  tq_mutate(select = close, mutate_fun = SMA, n = 20) %>%
  tq_mutate(select = close, mutate_fun = RSI, n = 14)

# Portfolio
weights <- c(0.5, 0.3, 0.2)
portfolio_returns <- returns %>%
  tq_portfolio(
    assets_col = symbol,
    returns_col = daily.returns,
    weights = weights
  )

# Performance
portfolio_returns %>%
  tq_performance(Ra = portfolio.returns, performance_fun = table.AnnualizedReturns)
```

## Portfolio Optimization

```r
library(PortfolioAnalytics)

# Create portfolio
port <- portfolio.spec(assets = colnames(returns))
port <- add.constraint(port, type = "full_investment")
port <- add.constraint(port, type = "box", min = 0.05, max = 0.4)
port <- add.objective(port, type = "return", name = "mean")
port <- add.objective(port, type = "risk", name = "StdDev")

# Optimize
opt <- optimize.portfolio(returns, port, optimize_method = "ROI")
extractWeights(opt)

# Efficient frontier
ef <- create.EfficientFrontier(returns, port, type = "mean-StdDev")
chart.EfficientFrontier(ef)
```

## Time Series

```r
library(xts)
library(zoo)

# Create xts
prices_xts <- xts(prices$close, order.by = prices$date)

# Subsetting
prices_xts["2024"]
prices_xts["2024-01/2024-06"]
first(prices_xts, "3 months")
last(prices_xts, "1 week")

# Rolling functions
rollmean(prices_xts, k = 20)
rollapply(prices_xts, width = 20, FUN = sd)
```
