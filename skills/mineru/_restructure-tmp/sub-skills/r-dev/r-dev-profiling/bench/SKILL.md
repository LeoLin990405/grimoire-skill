---
name: bench
description: R bench package for benchmarking. Use for high precision timing of R expressions.
---

# bench

High precision timing of R expressions.

## Basic Benchmark

```r
library(bench)

# Time single expression
bench::mark(
  sqrt(1:1000)
)

# Compare expressions
bench::mark(
  sqrt = sqrt(1:1000),
  exp = exp(1:1000),
  log = log(1:1000)
)
```

## Options

```r
bench::mark(
  sqrt(x),
  exp(x),
  iterations = 100,      # Number of iterations
  check = TRUE,          # Check results are equal
  memory = TRUE,         # Track memory
  time_unit = "ms"       # Time unit
)
```

## Press (Parameter Grid)

```r
# Benchmark across parameters
results <- bench::press(
  n = c(100, 1000, 10000),
  {
    x <- runif(n)
    bench::mark(
      sort(x),
      order(x)
    )
  }
)

# Plot
autoplot(results)
```

## Results

```r
results <- bench::mark(
  sqrt(x),
  exp(x)
)

# Access columns
results$expression
results$min
results$median
results$mem_alloc
results$n_itr
results$n_gc
```

## Memory Tracking

```r
results <- bench::mark(
  method1 = { ... },
  method2 = { ... },
  memory = TRUE
)

# Memory allocated
results$mem_alloc
```

## Plotting

```r
library(ggplot2)

# Autoplot
autoplot(results)

# Custom plot
ggplot(results, aes(x = expression, y = median)) +
  geom_col()
```

## System Time

```r
# Measure system time
bench::system_time({
  # Code to time
  Sys.sleep(1)
})
```

## Garbage Collection

```r
# Force GC between iterations
bench::mark(
  expr,
  gc = TRUE
)

# Track GC
results$n_gc  # Number of GC runs
```

## Relative Performance

```r
# Compare relative to baseline
results <- bench::mark(
  baseline = method1(),
  improved = method2()
)

# Relative times
results$median / min(results$median)
```
