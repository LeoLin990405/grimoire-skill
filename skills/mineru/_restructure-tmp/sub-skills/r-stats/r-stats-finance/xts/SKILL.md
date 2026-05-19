---
name: xts
description: R xts package for extensible time series. Use for creating and manipulating time series objects.
---

# xts

Extensible time series.

## Creating xts

```r
library(xts)

# From vector
dates <- as.Date("2024-01-01") + 0:99
values <- rnorm(100)
ts <- xts(values, order.by = dates)

# From matrix
data <- matrix(rnorm(200), ncol = 2)
ts <- xts(data, order.by = dates)
colnames(ts) <- c("A", "B")

# From data frame
ts <- xts(df[, -1], order.by = df$date)
```

## Subsetting

```r
# By date
ts["2024"]
ts["2024-01"]
ts["2024-01-15"]

# Date range
ts["2024-01/2024-06"]
ts["2024-01-01/2024-03-31"]
ts["/2024-06"]  # Up to June
ts["2024-07/"]  # From July

# First/last
first(ts, "3 months")
last(ts, "1 week")
first(ts, 10)
last(ts, 10)
```

## Time-based Operations

```r
# Endpoints
endpoints(ts, on = "months")
endpoints(ts, on = "weeks")
endpoints(ts, on = "years")

# Period apply
apply.monthly(ts, mean)
apply.weekly(ts, sum)
apply.yearly(ts, max)

# Period conversion
to.monthly(ts)
to.weekly(ts)
to.quarterly(ts)
to.yearly(ts)
```

## Merging

```r
# Merge (outer join)
merged <- merge(ts1, ts2)

# Inner join
merged <- merge(ts1, ts2, join = "inner")

# Left/right join
merged <- merge(ts1, ts2, join = "left")

# Fill missing
merged <- merge(ts1, ts2, fill = 0)
merged <- merge(ts1, ts2, fill = na.locf)
```

## Lag and Diff

```r
# Lag
lag(ts, k = 1)
lag(ts, k = -1)  # Lead

# Difference
diff(ts)
diff(ts, lag = 1)
diff(ts, differences = 2)
```

## Rolling Functions

```r
# Rolling mean
rollapply(ts, width = 20, FUN = mean)

# Rolling with alignment
rollapply(ts, width = 20, FUN = mean, align = "right")

# Rolling custom function
rollapply(ts, width = 20, FUN = function(x) max(x) - min(x))

# Rolling with partial windows
rollapply(ts, width = 20, FUN = mean, partial = TRUE)
```

## NA Handling

```r
# Last observation carried forward
na.locf(ts)

# Next observation carried backward
na.locf(ts, fromLast = TRUE)

# Interpolation
na.approx(ts)

# Remove NA
na.omit(ts)
```

## Attributes

```r
# Index
index(ts)
time(ts)

# Core data
coredata(ts)

# Periodicity
periodicity(ts)

# Number of periods
ndays(ts)
nweeks(ts)
nmonths(ts)
nyears(ts)
```

## Conversion

```r
# To data frame
as.data.frame(ts)
data.frame(date = index(ts), coredata(ts))

# To zoo
as.zoo(ts)

# To ts
as.ts(ts)
```

## Alignment

```r
# Align to another series
align.time(ts, n = 60)  # Align to minutes

# Make index unique
make.index.unique(ts)
```
