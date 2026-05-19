---
name: future
description: R future package for parallel computing. Use for unified async and parallel evaluation.
---

# future Package

Unified parallel and distributed processing.

## Setup

```r
library(future)

# Sequential (default)
plan(sequential)

# Multicore (fork, Unix only)
plan(multicore, workers = 4)

# Multisession (separate R sessions)
plan(multisession, workers = 4)

# Cluster
plan(cluster, workers = c("n1", "n2", "n3"))
```

## Basic Usage

```r
# Create future
f <- future({
  slow_computation(data)
})

# Get value (blocks until done)
result <- value(f)

# Check if resolved
resolved(f)
```

## Implicit Futures

```r
# %<-% operator
result %<-% {
  slow_computation(data)
}

# Use result (blocks if not ready)
print(result)
```

## future.apply

```r
library(future.apply)

# Parallel lapply
results <- future_lapply(1:100, function(i) {
  expensive_function(i)
})

# Parallel sapply
results <- future_sapply(1:100, expensive_function)

# Parallel mapply
results <- future_mapply(func, x, y)

# Parallel Map
results <- future_Map(func, x, y)
```

## Multiple Futures

```r
# Create multiple futures
futures <- lapply(data_list, function(d) {
  future({ process(d) })
})

# Collect all results
results <- lapply(futures, value)
```

## Error Handling

```r
f <- future({
  stop("Error!")
})

# Errors propagate on value()
tryCatch(
  value(f),
  error = function(e) message("Caught: ", e$message)
)
```

## Global Variables

```r
# Automatic detection
x <- 10
f <- future({ x + 1 })

# Explicit
f <- future({ x + 1 }, globals = list(x = 10))
```
