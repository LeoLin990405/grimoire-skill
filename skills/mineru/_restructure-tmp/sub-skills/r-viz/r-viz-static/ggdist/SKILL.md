---
name: ggdist
description: R ggdist package for distribution visualizations. Use for visualizing distributions and uncertainty.
---

# ggdist

Visualizations of distributions and uncertainty.

## Stat Halfeye

```r
library(ggplot2)
library(ggdist)

ggplot(data, aes(x = group, y = value)) +
  stat_halfeye()

# With options
ggplot(data, aes(x = group, y = value)) +
  stat_halfeye(
    .width = c(0.66, 0.95),
    point_interval = median_qi
  )
```

## Stat Eye

```r
# Full eye (violin + interval)
ggplot(data, aes(x = group, y = value)) +
  stat_eye()
```

## Stat Slab

```r
# Just the density
ggplot(data, aes(x = group, y = value)) +
  stat_slab()

# Horizontal
ggplot(data, aes(y = group, x = value)) +
  stat_slab()
```

## Stat Interval

```r
# Just intervals
ggplot(data, aes(x = group, y = value)) +
  stat_interval()

# Multiple intervals
ggplot(data, aes(x = group, y = value)) +
  stat_interval(.width = c(0.5, 0.8, 0.95))
```

## Stat Pointinterval

```r
# Point + interval
ggplot(data, aes(x = group, y = value)) +
  stat_pointinterval()

# Different point types
ggplot(data, aes(x = group, y = value)) +
  stat_pointinterval(point_interval = mean_qi)
```

## Stat Dots

```r
# Dot plot
ggplot(data, aes(x = group, y = value)) +
  stat_dots()

# Quantile dots
ggplot(data, aes(x = group, y = value)) +
  stat_dotsinterval()
```

## Gradient Intervals

```r
ggplot(data, aes(x = group, y = value)) +
  stat_gradientinterval()
```

## CCDF Bars

```r
# Complementary CDF
ggplot(data, aes(x = group, y = value)) +
  stat_ccdfinterval()
```

## Combining

```r
ggplot(data, aes(x = group, y = value)) +
  stat_halfeye(
    adjust = 0.5,
    width = 0.6,
    .width = 0,
    justification = -0.2,
    point_colour = NA
  ) +
  geom_boxplot(
    width = 0.15,
    outlier.shape = NA
  ) +
  stat_dots(
    side = "left",
    justification = 1.1,
    binwidth = 0.25
  )
```

## With Posterior Samples

```r
# From Bayesian models
library(brms)
posterior <- as_draws_df(fit)

ggplot(posterior, aes(x = b_Intercept)) +
  stat_halfeye()
```
