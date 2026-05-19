---
name: r-parallel-local
description: R local parallel computing with parallel, future, furrr. Use for multi-core processing.
---

# R Local Parallel Computing

Multi-core processing.

## parallel

```r
library(parallel)

# Detect cores
detectCores()
detectCores(logical = FALSE)

# mclapply (Unix)
results <- mclapply(1:100, function(x) x^2, mc.cores = 4)

# parLapply (all platforms)
cl <- makeCluster(4)
clusterExport(cl, c("data", "my_function"))
clusterEvalQ(cl, library(dplyr))
results <- parLapply(cl, 1:100, function(x) x^2)
stopCluster(cl)

# parSapply
cl <- makeCluster(4)
results <- parSapply(cl, 1:100, function(x) x^2)
stopCluster(cl)

# Load balancing
results <- parLapplyLB(cl, tasks, process_task)
```

## future

```r
library(future)

# Plan
plan(sequential)       # Default
plan(multisession)     # Background R sessions
plan(multicore)        # Forked (Unix)
plan(cluster, workers = 4)

# Future
f <- future({ slow_computation() })
result <- value(f)

# Multiple futures
f1 <- future({ task1() })
f2 <- future({ task2() })
results <- values(list(f1, f2))

# Resolved?
resolved(f)

# Nested
plan(list(
  tweak(multisession, workers = 2),
  tweak(multisession, workers = 4)
))
```

## furrr

```r
library(furrr)

plan(multisession, workers = 4)

# Parallel map
results <- future_map(1:100, ~ .x^2)
results <- future_map_dbl(1:100, ~ .x^2)
results <- future_map_dfr(files, read_csv)

# With progress
results <- future_map(1:100, ~ .x^2, .progress = TRUE)

# Options
results <- future_map(
  data_list,
  process_data,
  .options = furrr_options(seed = TRUE)
)
```

## foreach

```r
library(foreach)
library(doParallel)

# Setup
cl <- makeCluster(4)
registerDoParallel(cl)

# Parallel loop
results <- foreach(i = 1:100, .combine = c) %dopar% {
  i^2
}

# With packages
results <- foreach(i = 1:100, .packages = "dplyr") %dopar% {
  # code using dplyr
}

# Nested
results <- foreach(i = 1:10) %:%
  foreach(j = 1:10) %dopar% {
    i * j
  }

stopCluster(cl)
```
