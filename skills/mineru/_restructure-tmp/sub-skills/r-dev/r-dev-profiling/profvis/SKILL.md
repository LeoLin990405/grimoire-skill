---
name: profvis
description: R profvis package for interactive profiling. Use for visualizing R code profiling data.
---

# profvis

Interactive visualizations for profiling R code.

## Basic Profiling

```r
library(profvis)

# Profile code block
profvis({
  # Code to profile
  data <- read.csv("large_file.csv")
  result <- lm(y ~ x, data = data)
  summary(result)
})
```

## Save Profile

```r
# Save to file
p <- profvis({
  # Code
})

# Save HTML
htmlwidgets::saveWidget(p, "profile.html")
```

## Profile Function

```r
# Profile a function
my_function <- function(n) {
  x <- rnorm(n)
  y <- x^2
  mean(y)
}

profvis({
  my_function(1e6)
})
```

## Interval

```r
# Adjust sampling interval (ms)
profvis({
  # Code
}, interval = 0.01)  # 10ms intervals
```

## Memory Profiling

```r
# Profile memory
profvis({
  x <- 1:1e7
  y <- x^2
  rm(x)
  gc()
})
```

## Flame Graph

```r
# View as flame graph
p <- profvis({
  # Code
})

# Interactive viewer shows:
# - Flame graph (call stack over time)
# - Data tab (detailed timing)
# - Source code highlighting
```

## With Shiny

```r
# Profile Shiny app
profvis({
  runApp("myapp", display.mode = "normal")
}, interval = 0.01)
```

## Pause Profiling

```r
profvis({
  # Profiled code
  pause(FALSE)  # Stop profiling
  # Not profiled
  pause(TRUE)   # Resume profiling
  # Profiled again
})
```

## Print Summary

```r
p <- profvis({
  # Code
})

# Print summary
print(p)
```

## Tips

```r
# 1. Use small interval for short code
profvis({ fast_code() }, interval = 0.005)

# 2. Run multiple times for stable results
profvis({
  for (i in 1:10) {
    my_function()
  }
})

# 3. Profile realistic workloads
```
