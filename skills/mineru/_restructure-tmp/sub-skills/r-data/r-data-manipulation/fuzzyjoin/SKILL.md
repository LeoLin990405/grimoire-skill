---
name: fuzzyjoin
description: R fuzzyjoin package for fuzzy matching joins. Use for joining tables by inexact matching on strings, numbers, or distances.
---

# fuzzyjoin

Join tables by inexact matching.

## String Matching

```r
library(fuzzyjoin)

# Regex join
regex_left_join(df1, df2, by = c("name" = "pattern"))
regex_inner_join(df1, df2, by = "name")

# Fuzzy string matching (stringdist)
stringdist_left_join(df1, df2, by = "name", max_dist = 2)
stringdist_inner_join(df1, df2, by = "name", method = "jw", max_dist = 0.1)

# Methods: "osa", "lv", "dl", "hamming", "lcs", "qgram", "cosine", "jaccard", "jw"
```

## Numeric Matching

```r
# Difference join (within tolerance)
difference_left_join(df1, df2, by = "value", max_dist = 5)

# Distance join
distance_left_join(df1, df2, by = c("x", "y"), max_dist = 10)
```

## Interval Matching

```r
# Interval join (overlapping ranges)
interval_left_join(df1, df2, by = c("start", "end"))

# Genome-style intervals
genome_left_join(df1, df2, by = c("chr", "start", "end"))
```

## Geographic Matching

```r
# Geo join (within distance)
geo_left_join(df1, df2,
  by = c("lat", "lon"),
  max_dist = 10,
  unit = "km"
)
```

## Custom Matching

```r
# Fuzzy join with custom function
fuzzy_left_join(df1, df2,
  by = c("x" = "y"),
  match_fun = function(x, y) abs(x - y) < 5
)

# Multiple conditions
fuzzy_left_join(df1, df2,
  by = c("a" = "b", "c" = "d"),
  match_fun = list(`<`, `>`)
)
```

## Semi and Anti Joins

```r
# Fuzzy semi join (filter matches)
stringdist_semi_join(df1, df2, by = "name", max_dist = 2)

# Fuzzy anti join (filter non-matches)
stringdist_anti_join(df1, df2, by = "name", max_dist = 2)
```

## All Join Types

```r
# Available for all fuzzy methods:
# _inner_join, _left_join, _right_join, _full_join
# _semi_join, _anti_join

stringdist_inner_join(df1, df2, by = "name")
stringdist_full_join(df1, df2, by = "name")
regex_semi_join(df1, df2, by = "name")
difference_anti_join(df1, df2, by = "value")
```

## Examples

```r
# Match company names with typos
companies <- data.frame(name = c("Microsoft", "Apple Inc", "Google"))
records <- data.frame(company = c("Microsft", "Apple", "Gogle"))

stringdist_left_join(records, companies,
  by = c("company" = "name"),
  max_dist = 2
)

# Match dates within range
events <- data.frame(date = as.Date(c("2024-01-15", "2024-02-20")))
periods <- data.frame(
  start = as.Date(c("2024-01-01", "2024-02-01")),
  end = as.Date(c("2024-01-31", "2024-02-28"))
)

fuzzy_left_join(events, periods,
  by = c("date" = "start", "date" = "end"),
  match_fun = list(`>=`, `<=`)
)
```
