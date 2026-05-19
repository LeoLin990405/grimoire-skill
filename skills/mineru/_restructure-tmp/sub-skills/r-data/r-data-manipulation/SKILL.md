---
name: r-data-manipulation
description: R data manipulation with dplyr, data.table, tidyr. Use for filtering, selecting, mutating, grouping, summarizing, reshaping data frames.
---

# R Data Manipulation

Data frame manipulation with dplyr, data.table, and tidyr.

## dplyr (Tidyverse)

```r
library(dplyr)

# Core verbs
df %>%
  filter(x > 10, y == "A") %>%      # Filter rows
  select(a, b, c) %>%               # Select columns
  mutate(d = a + b) %>%             # Create/modify columns
  arrange(desc(a)) %>%              # Sort rows
  group_by(category) %>%            # Group

  summarise(                        # Aggregate
    mean = mean(value),
    sd = sd(value),
    n = n()
  ) %>%
  ungroup()

# Joins
left_join(df1, df2, by = "id")
inner_join(df1, df2, by = c("a" = "b"))
anti_join(df1, df2, by = "id")

# Window functions
df %>%
  group_by(category) %>%
  mutate(
    rank = row_number(),
    cumsum = cumsum(value),
    lag_val = lag(value, 1),
    lead_val = lead(value, 1)
  )

# Conditional
df %>% mutate(
  category = case_when(
    x < 10 ~ "low",
    x < 50 ~ "medium",
    TRUE ~ "high"
  ),
  y = if_else(x > 0, log(x), NA_real_)
)

# across() for multiple columns
df %>%
  mutate(across(where(is.numeric), scale)) %>%
  summarise(across(c(a, b), list(mean = mean, sd = sd)))
```

## data.table (High Performance)

```r
library(data.table)
dt <- as.data.table(df)

# Basic syntax: dt[i, j, by]
dt[x > 10]                          # Filter (i)
dt[, .(a, b)]                       # Select (j)
dt[, sum(value)]                    # Aggregate
dt[, .(total = sum(value)), by = category]  # Group by

# Modify in place
dt[, new_col := a + b]              # Add column
dt[, c("a", "b") := NULL]           # Remove columns
dt[x < 0, x := 0]                   # Conditional update

# Chaining
dt[x > 10][order(-value)][, head(.SD, 5), by = category]

# Keys and joins
setkey(dt1, id)
setkey(dt2, id)
dt1[dt2]                            # Join

# .SD (Subset of Data)
dt[, lapply(.SD, mean), by = category, .SDcols = c("a", "b")]

# fread/fwrite (fast I/O)
dt <- fread("data.csv")
fwrite(dt, "output.csv")
```

## tidyr (Reshaping)

```r
library(tidyr)

# Pivot longer (wide to long)
df %>% pivot_longer(
  cols = c(col1, col2, col3),
  names_to = "variable",
  values_to = "value"
)

# Pivot wider (long to wide)
df %>% pivot_wider(
  names_from = variable,
  values_from = value
)

# Separate and unite
df %>% separate(col, into = c("a", "b"), sep = "-")
df %>% unite("combined", a, b, sep = "_")

# Nested data
df %>% nest(data = -group)
df %>% unnest(data)

# Missing values
df %>% drop_na()
df %>% fill(column, .direction = "down")
df %>% replace_na(list(x = 0, y = "unknown"))
```

## Comparison

| Operation | dplyr | data.table |
|-----------|-------|------------|
| Filter | `filter(x > 10)` | `dt[x > 10]` |
| Select | `select(a, b)` | `dt[, .(a, b)]` |
| Mutate | `mutate(c = a+b)` | `dt[, c := a+b]` |
| Group + Summarise | `group_by() %>% summarise()` | `dt[, .(), by=]` |
| Speed | Good | Fastest |
| Memory | Copies | In-place |
