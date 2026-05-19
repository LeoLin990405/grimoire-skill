---
name: ggridges
description: R ggridges package for ridgeline plots. Use for creating ridgeline/joy plots showing distributions.
---

# ggridges

Ridgeline plots in ggplot2.

## Basic Ridgeline

```r
library(ggplot2)
library(ggridges)

ggplot(diamonds, aes(x = price, y = cut)) +
  geom_density_ridges()
```

## With Fill

```r
ggplot(diamonds, aes(x = price, y = cut, fill = cut)) +
  geom_density_ridges() +
  theme_ridges() +
  theme(legend.position = "none")
```

## Gradient Fill

```r
ggplot(diamonds, aes(x = price, y = cut, fill = stat(x))) +
  geom_density_ridges_gradient() +
  scale_fill_viridis_c(option = "C")
```

## Quantile Lines

```r
ggplot(diamonds, aes(x = price, y = cut)) +
  geom_density_ridges(
    quantile_lines = TRUE,
    quantiles = c(0.25, 0.5, 0.75)
  )
```

## Jittered Points

```r
ggplot(diamonds, aes(x = price, y = cut)) +
  geom_density_ridges(
    jittered_points = TRUE,
    point_size = 0.5,
    point_alpha = 0.3
  )
```

## Raincloud Plots

```r
ggplot(diamonds, aes(x = price, y = cut)) +
  geom_density_ridges(
    jittered_points = TRUE,
    position = position_points_jitter(width = 0.05, height = 0),
    point_shape = '|',
    point_size = 3,
    alpha = 0.7
  )
```

## Histogram Ridges

```r
ggplot(diamonds, aes(x = price, y = cut, fill = cut)) +
  geom_density_ridges(stat = "binline", bins = 30) +
  theme_ridges()
```

## Scale and Overlap

```r
ggplot(diamonds, aes(x = price, y = cut)) +
  geom_density_ridges(
    scale = 2,      # Overlap amount
    rel_min_height = 0.01  # Cut off tails
  )
```

## Bandwidth

```r
ggplot(diamonds, aes(x = price, y = cut)) +
  geom_density_ridges(bandwidth = 500)
```

## Theme

```r
# Built-in theme
ggplot(diamonds, aes(x = price, y = cut)) +
  geom_density_ridges() +
  theme_ridges(grid = FALSE, center_axis_labels = TRUE)
```
