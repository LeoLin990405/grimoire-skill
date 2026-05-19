---
name: reshape2
description: R reshape2 package for data reshaping. Use for melting and casting data between wide and long formats.
---

# reshape2

Flexibly reshape data.

## Melt (Wide to Long)

```r
library(reshape2)

# Basic melt
long_df <- melt(wide_df)

# Specify id variables
long_df <- melt(wide_df, id.vars = c("id", "name"))

# Specify measure variables
long_df <- melt(wide_df,
  id.vars = "id",
  measure.vars = c("var1", "var2", "var3")
)

# Custom column names
long_df <- melt(wide_df,
  id.vars = "id",
  variable.name = "metric",
  value.name = "score"
)
```

## Cast (Long to Wide)

```r
# dcast for data frames
wide_df <- dcast(long_df, id ~ variable)

# With aggregation
wide_df <- dcast(long_df, id ~ variable, fun.aggregate = mean)
wide_df <- dcast(long_df, id ~ variable, fun.aggregate = sum)

# Multiple id variables
wide_df <- dcast(long_df, id + name ~ variable)

# acast for arrays/matrices
arr <- acast(long_df, id ~ variable)
```

## Formula Syntax

```r
# row_var ~ col_var
dcast(df, id ~ variable)

# Multiple row variables
dcast(df, id + group ~ variable)

# Multiple column variables
dcast(df, id ~ var1 + var2)

# All variables on one side
dcast(df, ... ~ variable)  # All others as rows
dcast(df, id ~ ...)        # All others as columns
```

## Handling Missing Values

```r
# Fill missing with value
wide_df <- dcast(long_df, id ~ variable, fill = 0)
wide_df <- dcast(long_df, id ~ variable, fill = NA)

# Drop missing
wide_df <- dcast(long_df, id ~ variable, drop = TRUE)
```

## Multiple Value Columns

```r
# Melt multiple measure columns
long_df <- melt(wide_df,
  id.vars = "id",
  measure.vars = list(
    c("a1", "a2", "a3"),
    c("b1", "b2", "b3")
  ),
  variable.name = "time",
  value.name = c("metric_a", "metric_b")
)
```

## Comparison with tidyr

```r
# reshape2::melt = tidyr::pivot_longer
# reshape2::dcast = tidyr::pivot_wider

# reshape2 is faster for large datasets
# tidyr has cleaner syntax
# Both achieve same results
```
