---
name: foreach
description: R foreach package for parallel loops. Use for parallel iteration with various backends.
---

# foreach Package

Parallel loops with pluggable backends.

## Setup

```r
library(foreach)
library(doParallel)

# Register parallel backend
cl <- makeCluster(4)
registerDoParallel(cl)

# Check registration
getDoParWorkers()
```

## Basic Loop

```r
# Sequential
result <- foreach(i = 1:100) %do% {
  expensive_function(i)
}

# Parallel
result <- foreach(i = 1:100) %dopar% {
  expensive_function(i)
}
```

## Combine Results

```r
# As vector (c)
result <- foreach(i = 1:100, .combine = c) %dopar% {
  i^2
}

# As data frame (rbind)
result <- foreach(i = 1:100, .combine = rbind) %dopar% {
  data.frame(x = i, y = i^2)
}

# Sum
result <- foreach(i = 1:100, .combine = `+`) %dopar% {
  i
}

# Custom combine
result <- foreach(i = 1:100, .combine = function(a, b) c(a, b)) %dopar% {
  i
}
```

## Multiple Iterators

```r
result <- foreach(a = 1:10, b = 11:20) %dopar% {
  a + b
}

# Nested (all combinations)
result <- foreach(a = 1:3) %:%
  foreach(b = 1:3) %dopar% {
    a * b
  }
```

## Options

```r
result <- foreach(
  i = 1:100,
  .combine = rbind,
  .packages = c("dplyr", "ggplot2"),
  .export = c("my_function", "my_data"),
  .errorhandling = "pass"  # or "remove", "stop"
) %dopar% {
  # code
}
```

## Cleanup

```r
stopCluster(cl)
```
