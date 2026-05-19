---
name: TTR
description: R TTR package for technical trading rules. Use for technical analysis indicators and trading signals.
---

# TTR

Technical Trading Rules - functions for technical analysis.

## Moving Averages

```r
library(TTR)

# Simple moving average
SMA(price, n = 20)

# Exponential moving average
EMA(price, n = 20)

# Weighted moving average
WMA(price, n = 20)

# Double EMA
DEMA(price, n = 20)

# Triple EMA
TEMA(price, n = 20)

# Volume-weighted moving average
VWMA(price, volume, n = 20)

# Zero-lag EMA
ZLEMA(price, n = 20)
```

## Momentum Indicators

```r
# Relative Strength Index
RSI(price, n = 14)

# MACD
MACD(price, nFast = 12, nSlow = 26, nSig = 9)

# Rate of Change
ROC(price, n = 10)

# Momentum
momentum(price, n = 10)

# Commodity Channel Index
CCI(HLC, n = 20)

# Williams %R
WPR(HLC, n = 14)

# Stochastic Oscillator
stoch(HLC, nFastK = 14, nFastD = 3, nSlowD = 3)

# Ultimate Oscillator
ultimateOscillator(HLC)
```

## Volatility Indicators

```r
# Bollinger Bands
BBands(HLC, n = 20, sd = 2)

# Average True Range
ATR(HLC, n = 14)

# True Range
TR(HLC)

# Chaikin Volatility
chaikinVolatility(HLC, n = 10)

# Garman-Klass volatility
volatility(OHLC, calc = "garman.klass")

# Parkinson volatility
volatility(OHLC, calc = "parkinson")
```

## Trend Indicators

```r
# Average Directional Index
ADX(HLC, n = 14)

# Aroon
aroon(HL, n = 20)

# Parabolic SAR
SAR(HL, accel = c(0.02, 0.2))

# Trend Detection Index
TDI(price, n = 20)

# Vertical Horizontal Filter
VHF(price, n = 28)
```

## Volume Indicators

```r
# On Balance Volume
OBV(price, volume)

# Chaikin Money Flow
CMF(HLC, volume, n = 20)

# Money Flow Index
MFI(HLC, volume, n = 14)

# Accumulation/Distribution
chaikinAD(HLC, volume)

# Klinger Volume Oscillator
KVO(HLC, volume)
```

## Price Channels

```r
# Donchian Channel
DonchianChannel(HL, n = 20)

# Price Channel
# High/low over n periods
runMax(Hi, n = 20)
runMin(Lo, n = 20)
```

## Running Functions

```r
# Running sum
runSum(x, n = 10)

# Running mean
runMean(x, n = 10)

# Running min/max
runMin(x, n = 10)
runMax(x, n = 10)

# Running standard deviation
runSD(x, n = 10)

# Running median
runMedian(x, n = 10)

# Running correlation
runCor(x, y, n = 20)

# Running covariance
runCov(x, y, n = 20)
```

## Signal Generation

```r
# Cross signals
# Price crosses above MA
cross_above <- price > SMA(price, 20) & lag(price) <= lag(SMA(price, 20))

# RSI overbought/oversold
rsi <- RSI(price, 14)
oversold <- rsi < 30
overbought <- rsi > 70

# MACD crossover
macd <- MACD(price)
signal <- macd[, "macd"] > macd[, "signal"]
```

## Combining Indicators

```r
# Multiple timeframe analysis
sma_short <- SMA(price, 10)
sma_medium <- SMA(price, 50)
sma_long <- SMA(price, 200)

# Trend confirmation
trend_up <- sma_short > sma_medium & sma_medium > sma_long

# Bollinger + RSI
bb <- BBands(HLC, n = 20)
rsi <- RSI(Cl(data), n = 14)
buy_signal <- Cl(data) < bb[, "dn"] & rsi < 30
```

## With quantmod

```r
library(quantmod)

# Get data and apply indicators
getSymbols("AAPL")
chartSeries(AAPL)
addSMA(n = 20)
addBBands()
addRSI()
addMACD()
```
