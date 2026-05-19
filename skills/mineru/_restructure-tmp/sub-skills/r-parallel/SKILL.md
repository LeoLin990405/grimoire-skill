---
name: r-parallel
description: R parallel computing and high performance packages. Use for multi-core processing, distributed computing, Spark integration, and C++ acceleration with Rcpp.
---

# R Parallel & High Performance Skill

## Sub-skills

| Sub-skill | Description |
|-----------|-------------|
| [r-parallel-local](r-parallel-local/SKILL.md) | parallel, future, furrr, foreach |
| [r-parallel-distributed](r-parallel-distributed/SKILL.md) | sparklyr, batchtools, clustermq |
| [r-parallel-cpp](r-parallel-cpp/SKILL.md) | Rcpp, RcppParallel, RcppArmadillo |

Parallel computing and performance optimization in R.

## Parallel Computing

| Package | Description |
|---------|-------------|
| **future** ★ | Unified parallel/distributed API |
| **furrr** | future + purrr |
| **foreach** | Parallel loops |
| **parallel** | Built-in multicore/snow |
| **doParallel** | Parallel backend for foreach |
| **Rmpi** | MPI interface |
| **batchtools** | HPC cluster support |

## Distributed Computing

| Package | Description |
|---------|-------------|
| **sparklyr** ★ | Spark interface (RStudio) |
| **SparkR** | Spark R frontend |
| **DistributedR** | HP Vertica platform |
| **ddR** | Distributed data structures |

## High Performance

| Package | Description |
|---------|-------------|
| **Rcpp** ★ | C++ integration |
| **cpp11** | Header-only C++ interface |
| **Rcpp11** | C++11 Rcpp redesign |
| **compiler** | JIT compilation |
| **data.table** | Fast data manipulation |

## Quick Examples

```r
# future - unified parallel API
library(future)
plan(multisession, workers = 4)  # Use 4 cores

# Async evaluation
f <- future({
  slow_computation(data)
})
result <- value(f)

# future.apply
library(future.apply)
results <- future_lapply(1:100, function(i) {
  expensive_function(i)
})

# furrr (future + purrr)
library(furrr)
plan(multisession, workers = 4)
results <- future_map(data_list, process_function)
results <- future_map_dfr(files, read_and_process)

# foreach
library(foreach)
library(doParallel)
registerDoParallel(cores = 4)

results <- foreach(i = 1:100, .combine = rbind) %dopar% {
  expensive_function(i)
}

# parallel (base R)
library(parallel)
cl <- makeCluster(4)
results <- parLapply(cl, 1:100, function(i) {
  expensive_function(i)
})
stopCluster(cl)

# Rcpp - C++ acceleration
library(Rcpp)
cppFunction('
  double sumC(NumericVector x) {
    int n = x.size();
    double total = 0;
    for(int i = 0; i < n; ++i) {
      total += x[i];
    }
    return total;
  }
')
sumC(1:1000000)  # Much faster than sum()

# Rcpp with sourceCpp
# save as mycode.cpp
# [[Rcpp::export]]
# double meanC(NumericVector x) {
#   return std::accumulate(x.begin(), x.end(), 0.0) / x.size();
# }
sourceCpp("mycode.cpp")

# Spark with sparklyr
library(sparklyr)
sc <- spark_connect(master = "local")
spark_df <- copy_to(sc, mtcars, "mtcars")

spark_df %>%
  group_by(cyl) %>%
  summarise(mean_mpg = mean(mpg)) %>%
  collect()

spark_disconnect(sc)
```

## Performance Tips

```r
# 1. Vectorize operations
# Bad
for (i in 1:n) result[i] <- x[i] + y[i]
# Good
result <- x + y

# 2. Pre-allocate vectors
# Bad
result <- c()
for (i in 1:n) result <- c(result, compute(i))
# Good
result <- vector("numeric", n)
for (i in 1:n) result[i] <- compute(i)

# 3. Use data.table for large data
library(data.table)
dt <- as.data.table(df)
dt[, mean(value), by = group]

# 4. Profile before optimizing
profvis::profvis({
  your_code()
})

# 5. Use Rcpp for bottlenecks
library(Rcpp)
cppFunction('
  // C++ code for hot loops
')

# 6. Byte compilation
library(compiler)
fast_fn <- cmpfun(slow_fn)
```

## Parallel Patterns

```r
# Map pattern
library(furrr)
plan(multisession, workers = 4)
results <- future_map(items, process_item)

# Reduce pattern
library(foreach)
result <- foreach(i = 1:100, .combine = `+`) %dopar% {
  compute(i)
}

# Chunked processing
library(future.apply)
chunks <- split(data, ceiling(seq_along(data) / chunk_size))
results <- future_lapply(chunks, process_chunk)
final <- do.call(rbind, results)
```

## Resources

- future: https://future.futureverse.org/
- Rcpp: https://www.rcpp.org/
- sparklyr: https://spark.rstudio.com/
- High Performance R: https://adv-r.hadley.nz/perf-improve.html
