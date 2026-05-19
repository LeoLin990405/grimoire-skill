---
name: doParallel
description: R doParallel package for parallel foreach backend. Use for registering parallel backends for foreach loops.
---

# doParallel

Parallel backend for foreach using parallel package.

## Setup

```r
library(doParallel)
library(foreach)

# Register parallel backend
cl <- makeCluster(4)
registerDoParallel(cl)

# Or simpler (auto-creates cluster)
registerDoParallel(cores = 4)
```

## Basic Usage

```r
library(doParallel)
library(foreach)

# Register backend
registerDoParallel(cores = 4)

# Parallel foreach
result <- foreach(i = 1:100) %dopar% {
  sqrt(i)
}

# Stop parallel backend
stopImplicitCluster()
```

## Combining Results

```r
# As list (default)
result <- foreach(i = 1:10) %dopar% { i^2 }

# As vector
result <- foreach(i = 1:10, .combine = c) %dopar% { i^2 }

# As matrix (rbind)
result <- foreach(i = 1:10, .combine = rbind) %dopar% { c(i, i^2) }

# As matrix (cbind)
result <- foreach(i = 1:10, .combine = cbind) %dopar% { c(i, i^2) }

# Sum
result <- foreach(i = 1:10, .combine = `+`) %dopar% { i }

# Custom combine
result <- foreach(i = 1:10, .combine = function(a, b) a + b) %dopar% { i }
```

## Multiple Iterators

```r
# Nested loops
result <- foreach(i = 1:3, .combine = rbind) %:%
  foreach(j = 1:3, .combine = c) %dopar% {
    i * j
  }

# Parallel over multiple variables
result <- foreach(a = 1:10, b = 11:20, .combine = c) %dopar% {
  a + b
}
```

## Export Variables

```r
my_data <- 1:100
my_func <- function(x) x^2

result <- foreach(
  i = 1:10,
  .export = c("my_data", "my_func")
) %dopar% {
  my_func(my_data[i])
}
```

## Load Packages

```r
result <- foreach(
  i = 1:10,
  .packages = c("dplyr", "ggplot2")
) %dopar% {
  # dplyr and ggplot2 available here
  process(i)
}
```

## Error Handling

```r
# Return error info instead of stopping
result <- foreach(
  i = 1:10,
  .errorhandling = "pass"  # "stop", "remove", "pass"
) %dopar% {
  if (i == 5) stop("Error!")
  i^2
}

# Remove failed iterations
result <- foreach(
  i = 1:10,
  .errorhandling = "remove"
) %dopar% {
  if (i == 5) stop("Error!")
  i^2
}
```

## Sequential Fallback

```r
# Use %do% for sequential execution
result <- foreach(i = 1:10) %do% { i^2 }

# Useful for debugging
result <- foreach(i = 1:10) %do% {
  print(i)  # Can see output
  i^2
}
```

## Check Registration

```r
# Check current backend
getDoParWorkers()
getDoParName()

# Check if parallel
getDoParRegistered()
```

## Cleanup

```r
# With explicit cluster
cl <- makeCluster(4)
registerDoParallel(cl)

# ... do work ...

stopCluster(cl)

# With implicit cluster
registerDoParallel(cores = 4)

# ... do work ...

stopImplicitCluster()
```

## Random Numbers

```r
library(doRNG)

# Reproducible parallel random numbers
registerDoParallel(cores = 4)

result <- foreach(i = 1:10, .options.RNG = 123) %dorng% {
  rnorm(1)
}
```

## Progress Bar

```r
library(doSNOW)

cl <- makeCluster(4)
registerDoSNOW(cl)

# Progress bar
pb <- txtProgressBar(max = 100, style = 3)
progress <- function(n) setTxtProgressBar(pb, n)
opts <- list(progress = progress)

result <- foreach(i = 1:100, .options.snow = opts) %dopar% {
  Sys.sleep(0.1)
  i^2
}

close(pb)
stopCluster(cl)
```

## Best Practices

```r
# 1. Use fewer cores than available
registerDoParallel(cores = detectCores() - 1)

# 2. Chunk work appropriately
# Bad: many tiny tasks
foreach(i = 1:1000000) %dopar% { i }

# Good: fewer larger tasks
chunks <- split(1:1000000, ceiling(seq_along(1:1000000) / 10000))
foreach(chunk = chunks) %dopar% { sum(chunk) }

# 3. Always clean up
on.exit(stopImplicitCluster())
```
