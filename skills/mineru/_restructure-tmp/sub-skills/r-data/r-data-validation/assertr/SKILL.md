---
name: assertr
description: R assertr package for assertion pipelines. Use for assertive programming with data frames.
---

# assertr

Assertive programming for R analysis pipelines.

## Basic Assertions

```r
library(assertr)
library(dplyr)

df %>%
  assert(within_bounds(0, 120), age) %>%
  assert(not_na, name) %>%
  assert(is_uniq, id)
```

## Predicates

```r
# Built-in predicates
within_bounds(0, 100)    # Value in range
in_set(c("A", "B", "C")) # Value in set
not_na                   # Not NA
is_uniq                  # Unique values

# Custom predicate
is_positive <- function(x) x > 0

df %>%
  assert(is_positive, income)
```

## Verify

```r
# Row-level assertions
df %>%
  verify(age >= 0) %>%
  verify(income > 0) %>%
  verify(nrow(.) > 0)
```

## Insist

```r
# Statistical assertions
df %>%
  insist(within_n_sds(3), age) %>%
  insist(within_n_mads(3), income)
```

## Chain Assertions

```r
df %>%
  verify(nrow(.) > 0) %>%
  assert(not_na, id, name) %>%
  assert(within_bounds(0, 120), age) %>%
  insist(within_n_sds(3), income) %>%
  # Continue with analysis
  group_by(category) %>%
  summarize(mean_age = mean(age))
```

## Error Handling

```r
# Custom error function
df %>%
  chain_start %>%
  assert(not_na, name) %>%
  assert(is_uniq, id) %>%
  chain_end(error_fun = error_append)

# Just warn
df %>%
  assert(not_na, name, error_fun = just_warn)

# Return logical
df %>%
  assert(not_na, name, error_fun = error_logical)
```

## Assert Rows

```r
# Row-wise assertions
df %>%
  assert_rows(
    rowSums,
    within_bounds(0, 100),
    col1, col2, col3
  )

# Custom row function
df %>%
  assert_rows(
    function(x) x$end - x$start,
    function(x) x >= 0,
    end, start
  )
```

## Column Assertions

```r
# Check column existence
df %>%
  has_all_names("id", "name", "age")

# Check column types
df %>%
  assert(is.numeric, age, income) %>%
  assert(is.character, name)
```

## Success/Failure Functions

```r
# Custom success function
df %>%
  assert(not_na, name,
    success_fun = success_append,
    error_fun = error_append)
```
