---
name: microbenchmark
description: R microbenchmark package for precise timing. Use for sub-millisecond accurate timing of R expressions.
---

# microbenchmark

Accurate timing functions.

## Basic Usage

```r
library(microbenchmark)

# Benchmark expressions
microbenchmark(
  sqrt(x),
  x^0.5,
  exp(log(x)/2)
)
```

## Options

```r
microbenchmark(
  sqrt(x),
  x^0.5,
  times = 100,           # Number of evaluations
  unit = "ms",           # Time unit
  check = "equal",       # Check results equal
  control = list(
    order = "random",    # Randomize order
    warmup = 10          # Warmup iterations
  )
)
```

## Named Expressions

```r
microbenchmark(
  "sqrt" = sqrt(x),
  "power" = x^0.5,
  "exp_log" = exp(log(x)/2)
)
```

## Setup Code

```r
microbenchmark(
  sort(x),
  order(x),
  setup = {
    x <- runif(1000)
  }
)
```

## Results

```r
results <- microbenchmark(
  sqrt(x),
  x^0.5
)

# Summary
summary(results)

# As data frame
as.data.frame(results)

# Print with unit
print(results, unit = "ms")
```

## Plotting

```r
# Autoplot (requires ggplot2)
library(ggplot2)
autoplot(results)

# Boxplot
boxplot(results)

# Violin plot
autoplot(results) +
  geom_violin()
```

## Compare Functions

```r
# Compare implementations
f1 <- function(x) sum(x)
f2 <- function(x) Reduce(`+`, x)

x <- 1:1000
microbenchmark(
  f1(x),
  f2(x)
)
```

## Time Units

```r
# Available units
# "ns" - nanoseconds
# "us" - microseconds
# "ms" - milliseconds
# "s"  - seconds

print(results, unit = "relative")  # Relative to fastest
```

## Statistical Summary

```r
results <- microbenchmark(expr1, expr2)

# Access statistics
summary(results)$min
summary(results)$mean
summary(results)$median
summary(results)$max
summary(results)$neval
```
