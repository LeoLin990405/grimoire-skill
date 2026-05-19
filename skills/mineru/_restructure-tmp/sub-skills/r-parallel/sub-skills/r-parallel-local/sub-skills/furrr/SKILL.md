---
name: furrr
description: R furrr package for parallel purrr. Use for future-powered map functions.
---

# furrr Package

Parallel purrr with future backend.

## Setup

```r
library(furrr)
library(future)

plan(multisession, workers = 4)
```

## Parallel Map

```r
# Basic map
results <- future_map(1:100, slow_function)

# With type
results <- future_map_dbl(1:100, function(x) x^2)
results <- future_map_chr(items, process_text)
results <- future_map_lgl(items, is_valid)

# Return data frame
results <- future_map_dfr(files, read_and_process)
results <- future_map_dfc(items, extract_columns)
```

## Two Arguments

```r
results <- future_map2(x, y, function(a, b) a + b)
results <- future_map2_dbl(x, y, `+`)
```

## Multiple Arguments

```r
results <- future_pmap(list(a = x, b = y, c = z), function(a, b, c) {
  a + b + c
})
```

## Progress Bar

```r
# Enable progress
results <- future_map(1:100, slow_function, .progress = TRUE)

# With progressr
library(progressr)
handlers(global = TRUE)

with_progress({
  results <- future_map(1:100, slow_function, .progress = TRUE)
})
```

## Options

```r
# Seed for reproducibility
results <- future_map(1:100, function(x) runif(1),
  .options = furrr_options(seed = 123)
)

# Chunk size
results <- future_map(1:1000, func,
  .options = furrr_options(chunk_size = 100)
)
```

## Walk (Side Effects)

```r
future_walk(files, process_file)
future_walk2(data, paths, write_csv)
```
