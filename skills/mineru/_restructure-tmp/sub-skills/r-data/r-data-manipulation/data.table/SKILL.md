---
name: data.table
description: R data.table package for fast data manipulation. Use for high-performance data operations with concise syntax.
---

# data.table

High-performance data manipulation.

## Basics

```r
library(data.table)

# Create
dt <- data.table(x = 1:5, y = letters[1:5])
dt <- as.data.table(df)

# Syntax: dt[i, j, by]
# i = row filter
# j = column select/compute
# by = group by
```

## Row Operations (i)

```r
# Filter rows
dt[x > 3]
dt[x > 3 & y == "a"]
dt[x %in% c(1, 2, 3)]
dt[x %between% c(2, 4)]
dt[y %like% "^a"]

# Order
dt[order(x)]
dt[order(-x)]
dt[order(x, -y)]

# First/last rows
dt[1:5]
dt[.N]  # Last row
dt[(.N-4):.N]  # Last 5 rows
```

## Column Operations (j)

```r
# Select columns
dt[, .(x, y)]
dt[, x]  # Returns vector
dt[, .(x)]  # Returns data.table
dt[, c("x", "y"), with = FALSE]

# Compute
dt[, .(mean_x = mean(x), sum_y = sum(y))]
dt[, .(total = x + y)]

# Modify in place (:=)
dt[, z := x * 2]
dt[, c("a", "b") := .(x + 1, y)]
dt[, `:=`(a = x + 1, b = y)]

# Remove columns
dt[, z := NULL]
dt[, c("a", "b") := NULL]

# Special symbols
dt[, .N]  # Number of rows
dt[, .I]  # Row indices
dt[, .SD]  # Subset of data
dt[, .SDcols]  # Columns in .SD
```

## Grouping (by)

```r
# Group by
dt[, .(mean = mean(x)), by = category]
dt[, .(mean = mean(x)), by = .(cat1, cat2)]

# keyby (sorted)
dt[, .(mean = mean(x)), keyby = category]

# .SD operations
dt[, lapply(.SD, mean), by = category]
dt[, lapply(.SD, mean), by = category, .SDcols = c("x", "y")]
dt[, lapply(.SD, mean), by = category, .SDcols = is.numeric]

# .N by group
dt[, .N, by = category]
```

## Keys and Joins

```r
# Set key
setkey(dt, id)
setkeyv(dt, c("id1", "id2"))

# Join
dt1[dt2, on = "id"]  # Right join
dt2[dt1, on = "id"]  # Left join
dt1[dt2, on = "id", nomatch = 0]  # Inner join

# Multiple keys
dt1[dt2, on = .(a, b)]
dt1[dt2, on = .(a = x, b = y)]

# Non-equi joins
dt1[dt2, on = .(x >= a, x <= b)]

# Rolling joins
dt1[dt2, on = "date", roll = TRUE]
dt1[dt2, on = "date", roll = "nearest"]
```

## Reshaping

```r
# Wide to long
melt(dt, id.vars = "id", measure.vars = c("a", "b"))

# Long to wide
dcast(dt, id ~ variable, value.var = "value")
dcast(dt, id ~ variable, fun.aggregate = mean)
```

## Chaining

```r
dt[x > 0][order(-y)][, .(mean = mean(x)), by = cat]

# Or with line breaks
dt[x > 0
  ][order(-y)
  ][, .(mean = mean(x)), by = cat]
```

## Performance

```r
# Set index (secondary key)
setindex(dt, col)

# fread/fwrite (fast I/O)
dt <- fread("file.csv")
fwrite(dt, "output.csv")

# Modify by reference
set(dt, i = 1L, j = "x", value = 100)
setnames(dt, "old", "new")
setcolorder(dt, c("b", "a", "c"))
```
