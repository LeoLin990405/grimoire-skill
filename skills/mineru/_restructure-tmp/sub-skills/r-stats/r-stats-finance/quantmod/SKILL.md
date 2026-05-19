---
name: quantmod
description: R quantmod package for quantitative financial modeling. Use for downloading stock data and technical analysis.
---

# quantmod

Quantitative financial modeling framework.

## Get Stock Data

```r
library(quantmod)

# Download from Yahoo Finance
getSymbols("AAPL")
getSymbols(c("AAPL", "GOOGL", "MSFT"))

# Specify source
getSymbols("AAPL", src = "yahoo")

# Date range
getSymbols("AAPL", from = "2020-01-01", to = "2024-01-01")

# Auto-assign to environment
getSymbols("AAPL", auto.assign = TRUE)

# Return data directly
data <- getSymbols("AAPL", auto.assign = FALSE)
```

## OHLCV Access

```r
# Open, High, Low, Close, Volume, Adjusted
Op(AAPL)
Hi(AAPL)
Lo(AAPL)
Cl(AAPL)
Vo(AAPL)
Ad(AAPL)

# Combined
OHLC(AAPL)
HLC(AAPL)
OHLCV(AAPL)
```

## Charting

```r
# Basic chart
chartSeries(AAPL)

# Candlestick
chartSeries(AAPL, type = "candlesticks")

# Bar chart
chartSeries(AAPL, type = "bars")

# Line chart
chartSeries(AAPL, type = "line")

# Subset
chartSeries(AAPL, subset = "2024")
chartSeries(AAPL, subset = "2024-01::2024-06")

# Theme
chartSeries(AAPL, theme = chartTheme("white"))
```

## Add Indicators

```r
chartSeries(AAPL)

# Moving averages
addSMA(n = 20)
addEMA(n = 50)

# Bollinger Bands
addBBands()

# MACD
addMACD()

# RSI
addRSI()

# Volume
addVo()

# Multiple indicators
chartSeries(AAPL)
addSMA(n = 20, col = "blue")
addSMA(n = 50, col = "red")
addBBands()
addMACD()
```

## Technical Indicators

```r
# Moving averages
SMA(Cl(AAPL), n = 20)
EMA(Cl(AAPL), n = 20)
WMA(Cl(AAPL), n = 20)
DEMA(Cl(AAPL), n = 20)

# Momentum
RSI(Cl(AAPL), n = 14)
MACD(Cl(AAPL))
ROC(Cl(AAPL), n = 10)
momentum(Cl(AAPL), n = 10)

# Volatility
BBands(HLC(AAPL))
ATR(HLC(AAPL))
volatility(OHLC(AAPL))

# Volume
OBV(Cl(AAPL), Vo(AAPL))
```

## Returns

```r
# Daily returns
dailyReturn(AAPL)
dailyReturn(AAPL, type = "log")

# Weekly/Monthly/Yearly
weeklyReturn(AAPL)
monthlyReturn(AAPL)
yearlyReturn(AAPL)
annualReturn(AAPL)

# All returns
allReturns(AAPL)
```

## Period Conversion

```r
# Convert to different periods
to.weekly(AAPL)
to.monthly(AAPL)
to.quarterly(AAPL)
to.yearly(AAPL)

# Period apply
periodReturn(AAPL, period = "monthly")
```

## Data Sources

```r
# Yahoo Finance (default)
getSymbols("AAPL", src = "yahoo")

# FRED (Federal Reserve)
getSymbols("GDP", src = "FRED")
getSymbols("UNRATE", src = "FRED")

# Oanda (forex)
getSymbols("EUR/USD", src = "oanda")
```
