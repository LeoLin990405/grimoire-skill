---
name: tsibble
description: R tsibble package for tidy time series. Use for temporal data structures with tidyverse integration.
---

# tsibble Package

Tidy temporal data frames.

## Create tsibble

```r
library(tsibble)

# From data frame
ts_data <- df %>%
  as_tsibble(index = date)

# With key (multiple series)
ts_data <- df %>%
  as_tsibble(index = date, key = c(region, product))

# Regular interval
ts_data <- df %>%
  as_tsibble(index = date, regular = TRUE)
```

## Index Types

```r
# Yearly
yearquarter("2020 Q1")
yearmonth("2020 Jan")
yearweek("2020 W01")

# Convert
df %>%
  mutate(month = yearmonth(date)) %>%
  as_tsibble(index = month)
```

## Temporal Operations

```r
# Fill gaps
ts_data %>% fill_gaps()
ts_data %>% fill_gaps(value = 0)

# Filter by time
ts_data %>% filter_index("2020" ~ "2022")
ts_data %>% filter_index(~ "2022-06")

# Lag/Lead
ts_data %>% mutate(
  lag1 = lag(value),
  lead1 = lead(value),
  diff1 = difference(value)
)
```

## Aggregation

```r
# Temporal aggregation
ts_data %>%
  index_by(year = year(date)) %>%
  summarise(total = sum(value))

# Group aggregation
ts_data %>%
  group_by_key() %>%
  index_by(month = yearmonth(date)) %>%
  summarise(avg = mean(value))
```

## Rolling Windows

```r
library(slider)

ts_data %>%
  mutate(
    ma7 = slide_dbl(value, mean, .before = 6),
    ma30 = slide_dbl(value, mean, .before = 29)
  )
```

## Scan for Duplicates

```r
# Check for duplicates
duplicates(ts_data)

# Check regularity
is_regular(ts_data)
interval(ts_data)
```
