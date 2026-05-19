---
name: PerformanceAnalytics
description: R PerformanceAnalytics package for portfolio analysis. Use for risk metrics, performance attribution, and portfolio analytics.
---

# PerformanceAnalytics

Econometric tools for performance and risk analysis.

## Returns Calculation

```r
library(PerformanceAnalytics)

# Calculate returns
Return.calculate(prices, method = "discrete")
Return.calculate(prices, method = "log")

# Cumulative returns
Return.cumulative(returns)

# Annualized returns
Return.annualized(returns, scale = 252)

# Excess returns
Return.excess(returns, Rf = 0.02/252)
```

## Risk Metrics

```r
# Standard deviation
StdDev(returns)
StdDev.annualized(returns, scale = 252)

# Value at Risk
VaR(returns, p = 0.95, method = "historical")
VaR(returns, p = 0.95, method = "gaussian")
VaR(returns, p = 0.95, method = "modified")

# Expected Shortfall (CVaR)
ES(returns, p = 0.95, method = "historical")
CVaR(returns, p = 0.95)

# Maximum Drawdown
maxDrawdown(returns)
Drawdowns(returns)
```

## Performance Ratios

```r
# Sharpe Ratio
SharpeRatio(returns, Rf = 0.02/252)
SharpeRatio.annualized(returns, Rf = 0.02)

# Sortino Ratio
SortinoRatio(returns, MAR = 0)

# Calmar Ratio
CalmarRatio(returns)

# Information Ratio
InformationRatio(returns, benchmark)

# Treynor Ratio
TreynorRatio(returns, benchmark, Rf = 0.02/252)

# Omega Ratio
Omega(returns, L = 0)
```

## Drawdown Analysis

```r
# Drawdown series
Drawdowns(returns)

# Maximum drawdown
maxDrawdown(returns)

# Drawdown table
table.Drawdowns(returns, top = 10)

# Time to recovery
DrawdownPeak(returns)
```

## Risk-Adjusted Returns

```r
# CAPM metrics
CAPM.alpha(returns, benchmark)
CAPM.beta(returns, benchmark)
CAPM.jensenAlpha(returns, benchmark, Rf = 0.02/252)

# Tracking error
TrackingError(returns, benchmark)

# Active premium
ActivePremium(returns, benchmark)
```

## Higher Moments

```r
# Skewness
skewness(returns)

# Kurtosis
kurtosis(returns)

# Co-skewness
CoSkewness(returns, benchmark)

# Co-kurtosis
CoKurtosis(returns, benchmark)
```

## Portfolio Analysis

```r
# Portfolio returns
Return.portfolio(returns, weights)
Return.portfolio(returns, weights, rebalance_on = "months")

# Portfolio risk
StdDev(returns, portfolio_method = "component", weights = weights)

# Contribution to risk
ES(returns, portfolio_method = "component", weights = weights)
```

## Tables and Charts

```r
# Summary statistics
table.Stats(returns)
table.AnnualizedReturns(returns)
table.CalendarReturns(returns)
table.DownsideRisk(returns)

# Charts
charts.PerformanceSummary(returns)
chart.CumReturns(returns)
chart.Drawdown(returns)
chart.RollingPerformance(returns)
chart.Histogram(returns)
chart.QQPlot(returns)
chart.Boxplot(returns)
```

## Rolling Analysis

```r
# Rolling returns
chart.RollingPerformance(returns, width = 252)

# Rolling Sharpe
chart.RollingPerformance(returns, FUN = "SharpeRatio.annualized")

# Rolling correlation
chart.RollingCorrelation(returns, benchmark)

# Rolling regression
chart.RollingRegression(returns, benchmark)
```

## Correlation Analysis

```r
# Correlation matrix
cor(returns)

# Correlation chart
chart.Correlation(returns)

# Rolling correlation
chart.RollingCorrelation(returns[, 1], returns[, 2])
```

## Benchmark Comparison

```r
# Relative performance
Return.relative(returns, benchmark)

# Capture ratios
UpDownRatios(returns, benchmark)
UpDownRatios(returns, benchmark, method = "Capture")

# Up/down capture
UpDownRatios(returns, benchmark, method = "Number")
```
