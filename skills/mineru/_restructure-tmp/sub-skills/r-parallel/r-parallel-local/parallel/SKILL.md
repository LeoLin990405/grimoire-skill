---
name: parallel
description: R parallel package for parallel computing. Use for multicore and cluster-based parallel processing.
---

# parallel

Base R parallel computing support.

## Detect Cores

```r
library(parallel)

# Number of cores
detectCores()
detectCores(logical = FALSE)  # Physical cores only
```

## mclapply (Unix/Mac only)

```r
# Parallel lapply
result <- mclapply(1:100, function(x) x^2, mc.cores = 4)

# With more options
result <- mclapply(
  X = data_list,
  FUN = process_function,
  mc.cores = detectCores() - 1,
  mc.preschedule = TRUE,
  mc.set.seed = TRUE
)
```

## parLapply (Cross-platform)

```r
# Create cluster
cl <- makeCluster(4)

# Parallel lapply
result <- parLapply(cl, 1:100, function(x) x^2)

# Stop cluster
stopCluster(cl)
```

## Cluster Types

```r
# PSOCK (default, cross-platform)
cl <- makeCluster(4, type = "PSOCK")

# FORK (Unix/Mac only, shares memory)
cl <- makeCluster(4, type = "FORK")

# MPI cluster
cl <- makeCluster(4, type = "MPI")
```

## Export Variables

```r
cl <- makeCluster(4)

# Export variables to workers
clusterExport(cl, c("my_data", "my_function"))

# Export from specific environment
clusterExport(cl, "var", envir = my_env)

# Evaluate expression on workers
clusterEvalQ(cl, library(dplyr))

result <- parLapply(cl, data_list, my_function)
stopCluster(cl)
```

## Parallel Apply Functions

```r
cl <- makeCluster(4)

# parLapply - parallel lapply
parLapply(cl, X, FUN)

# parSapply - parallel sapply
parSapply(cl, X, FUN)

# parApply - parallel apply for matrices
parApply(cl, matrix, MARGIN, FUN)

# parRapply - parallel row apply
parRapply(cl, matrix, FUN)

# parCapply - parallel column apply
parCapply(cl, matrix, FUN)

stopCluster(cl)
```

## Load Balancing

```r
cl <- makeCluster(4)

# Static scheduling (default)
parLapply(cl, X, FUN)

# Dynamic load balancing
parLapplyLB(cl, X, FUN)
parSapplyLB(cl, X, FUN)

stopCluster(cl)
```

## Random Number Generation

```r
cl <- makeCluster(4)

# Set up parallel RNG
clusterSetRNGStream(cl, iseed = 123)

# Now random numbers are reproducible
result <- parLapply(cl, 1:10, function(x) rnorm(1))

stopCluster(cl)
```

## mcmapply

```r
# Parallel mapply (Unix/Mac)
result <- mcmapply(
  FUN = function(x, y) x + y,
  x = 1:10,
  y = 11:20,
  mc.cores = 4
)
```

## pvec

```r
# Parallel vector operations (Unix/Mac)
result <- pvec(1:1000000, function(x) x^2, mc.cores = 4)
```

## Error Handling

```r
cl <- makeCluster(4)

# Wrap in tryCatch
safe_fun <- function(x) {
  tryCatch(
    risky_function(x),
    error = function(e) NA
  )
}

result <- parLapply(cl, data_list, safe_fun)
stopCluster(cl)
```

## Progress Tracking

```r
# Using pbapply for progress bars
library(pbapply)

cl <- makeCluster(4)
result <- pblapply(X, FUN, cl = cl)
stopCluster(cl)
```

## Memory Management

```r
# FORK clusters share memory (Unix/Mac)
cl <- makeCluster(4, type = "FORK")

# For PSOCK, minimize data transfer
cl <- makeCluster(4)
clusterExport(cl, "large_data")  # Export once
result <- parLapply(cl, indices, function(i) process(large_data[i]))
stopCluster(cl)
```

## Cleanup

```r
# Always stop clusters
cl <- makeCluster(4)
on.exit(stopCluster(cl))

# Or use tryCatch
tryCatch({
  result <- parLapply(cl, X, FUN)
}, finally = {
  stopCluster(cl)
})
```
