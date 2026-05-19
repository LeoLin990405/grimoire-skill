---
name: zoo
description: R zoo package for ordered observations. Use for irregular time series and ordered indexed observations.
---

# zoo

Z's ordered observations for irregular time series.

## Creating zoo Objects

```r
library(zoo)

# From vector
dates <- as.Date("2024-01-01") + 0:99
values <- rnorm(100)
z <- zoo(values, order.by = dates)

# From matrix
data <- matrix(rnorm(200), ncol = 2)
z <- zoo(data, order.by = dates)
colnames(z) <- c("A", "B")

# Irregular time series
irregular_dates <- sort(sample(dates, 50))
z <- zoo(rnorm(50), order.by = irregular_dates)
```

## Subsetting

```r
# By index
z[1:10]
z["2024-01-15"]

# Date range
window(z, start = as.Date("2024-01-01"), end = as.Date("2024-03-31"))

# Head/tail
head(z, 10)
tail(z, 10)
```

## Index Operations

```r
# Get index
index(z)
time(z)

# Get core data
coredata(z)

# Set index
index(z) <- new_dates
```

## Merging

```r
# Merge (outer join)
merged <- merge(z1, z2)

# Inner join
merged <- merge(z1, z2, all = FALSE)

# Fill missing
merged <- merge(z1, z2, fill = 0)
merged <- merge(z1, z2, fill = na.locf)
```

## NA Handling

```r
# Last observation carried forward
na.locf(z)

# Next observation carried backward
na.locf(z, fromLast = TRUE)

# Linear interpolation
na.approx(z)

# Spline interpolation
na.spline(z)

# Remove NA
na.omit(z)
na.trim(z)  # Trim leading/trailing NA
```

## Rolling Functions

```r
# Rolling mean
rollmean(z, k = 5)
rollmean(z, k = 5, align = "right")

# Rolling sum
rollsum(z, k = 5)

# Rolling max/min
rollmax(z, k = 5)

# Rolling apply
rollapply(z, width = 5, FUN = sd)
rollapply(z, width = 5, FUN = function(x) max(x) - min(x))
```

## Aggregation

```r
# Aggregate by month
aggregate(z, as.yearmon, mean)

# Aggregate by quarter
aggregate(z, as.yearqtr, sum)

# Aggregate by year
aggregate(z, format, "%Y", FUN = mean)

# Custom aggregation
aggregate(z, function(x) as.Date(cut(x, "week")), mean)
```

## Lag and Diff

```r
# Lag
lag(z, k = 1)
lag(z, k = -1)  # Lead

# Difference
diff(z)
diff(z, lag = 1)
diff(z, differences = 2)
```

## Date Classes

```r
# Year-month
as.yearmon("2024-01")
as.yearmon(z)

# Year-quarter
as.yearqtr("2024 Q1")
as.yearqtr(z)

# Convert
as.Date(as.yearmon("2024-01"))
```

## Conversion

```r
# To data frame
as.data.frame(z)
fortify.zoo(z)  # For ggplot2

# To xts
as.xts(z)

# To ts (regular only)
as.ts(z)

# From ts
as.zoo(ts_object)
```

## Reading/Writing

```r
# Read zoo
read.zoo("data.csv", header = TRUE, sep = ",", format = "%Y-%m-%d")

# Write zoo
write.zoo(z, "output.csv", sep = ",")
```

## Plotting

```r
# Base plot
plot(z)
plot(z, screens = 1)  # Multiple series on one plot

# With ggplot2
library(ggplot2)
autoplot(z)
```
