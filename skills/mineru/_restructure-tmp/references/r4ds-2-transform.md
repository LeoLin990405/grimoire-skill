# R4DS - Part II: Transform (dplyr)

Based on "R for Data Science" (2e) by Hadley Wickham et al.
Book URL: https://r4ds.hadley.nz/

## The Pipe `|>`

```r
df |> filter(...) |> select(...) |> mutate(...)
```

Passes left side as first argument to right side function.

## Row Operations

### filter() - Keep rows by condition
```r
df |> filter(x > 10)
df |> filter(x > 10 & y < 5)
df |> filter(x > 10 | y < 5)
df |> filter(x %in% c("a", "b", "c"))
df |> filter(is.na(x))
df |> filter(!is.na(x))
```

### arrange() - Sort rows
```r
df |> arrange(x)           # Ascending
df |> arrange(desc(x))     # Descending
df |> arrange(x, desc(y))  # Multiple columns
```

### distinct() - Unique rows
```r
df |> distinct()                    # All columns
df |> distinct(x)                   # By specific column
df |> distinct(x, .keep_all = TRUE) # Keep other columns
```

### slice() - Select rows by position
```r
df |> slice(1:5)           # First 5 rows
df |> slice_head(n = 5)    # First 5
df |> slice_tail(n = 5)    # Last 5
df |> slice_sample(n = 10) # Random 10
df |> slice_max(x, n = 5)  # Top 5 by x
df |> slice_min(x, n = 5)  # Bottom 5 by x
```

## Column Operations

### select() - Choose columns
```r
df |> select(x, y, z)
df |> select(x:z)              # Range
df |> select(-x)               # Exclude
df |> select(starts_with("a")) # Helpers
df |> select(ends_with("_id"))
df |> select(contains("name"))
df |> select(matches("^x\\d"))
df |> select(where(is.numeric))
```

### mutate() - Create/modify columns
```r
df |> mutate(z = x + y)
df |> mutate(z = x + y, .before = x)
df |> mutate(z = x + y, .after = y)
df |> mutate(z = x + y, .keep = "used")  # Keep only used columns
```

### rename() - Rename columns
```r
df |> rename(new_name = old_name)
df |> rename_with(toupper)
df |> rename_with(~ str_replace(.x, "_", "."))
```

### relocate() - Move columns
```r
df |> relocate(z)              # Move to front
df |> relocate(z, .before = x)
df |> relocate(z, .after = y)
```

## Grouping & Summarizing

### group_by() + summarize()
```r
df |>
  group_by(category) |>
  summarize(
    mean_x = mean(x),
    sum_y = sum(y),
    count = n(),
    distinct_z = n_distinct(z)
  )
```

### Per-operation grouping (.by)
```r
df |> summarize(mean_x = mean(x), .by = category)
df |> summarize(mean_x = mean(x), .by = c(cat1, cat2))
```

### Common Summary Functions
| Function | Description |
|----------|-------------|
| `n()` | Count rows |
| `n_distinct(x)` | Count unique values |
| `sum(x)` | Sum |
| `mean(x)` | Mean |
| `median(x)` | Median |
| `sd(x)` | Standard deviation |
| `min(x)`, `max(x)` | Min/max |
| `first(x)`, `last(x)` | First/last value |
| `quantile(x, 0.25)` | Quantile |

### ungroup()
```r
df |> group_by(x) |> mutate(...) |> ungroup()
```

## Logical Vectors

```r
# Comparisons
x == y, x != y
x < y, x <= y, x > y, x >= y
x %in% c(1, 2, 3)
between(x, 1, 10)
near(x, y, tol = 0.001)  # Floating point comparison

# Boolean operations
!x           # NOT
x & y        # AND
x | y        # OR
xor(x, y)    # XOR

# Aggregations
any(x)       # Any TRUE?
all(x)       # All TRUE?
sum(x)       # Count TRUE
mean(x)      # Proportion TRUE
```

## Numbers

```r
# Rounding
round(x, digits = 2)
floor(x)
ceiling(x)
trunc(x)

# Cumulative
cumsum(x)
cumprod(x)
cummin(x)
cummax(x)
cummean(x)  # dplyr

# Ranking
row_number(x)    # 1, 2, 3, 4 (ties get different ranks)
min_rank(x)      # 1, 2, 2, 4 (ties get same rank)
dense_rank(x)    # 1, 2, 2, 3 (no gaps)
percent_rank(x)  # 0 to 1
ntile(x, n)      # Divide into n groups

# Offsets
lead(x, n = 1)   # Next value
lag(x, n = 1)    # Previous value
```

## Missing Values

```r
is.na(x)
!is.na(x)

# Replace NA
coalesce(x, 0)           # Replace NA with 0
replace_na(x, 0)         # tidyr
na_if(x, "")             # Convert "" to NA

# Remove NA
df |> filter(!is.na(x))
df |> drop_na(x)         # tidyr

# In calculations
mean(x, na.rm = TRUE)
sum(x, na.rm = TRUE)
```
