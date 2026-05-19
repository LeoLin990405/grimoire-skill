---
name: ggalt
description: R ggalt package for extra ggplot2 geoms. Use for lollipop charts, dumbbell plots, and encircling.
---

# ggalt

Extra coordinate systems, geoms, and stats for ggplot2.

## Lollipop Charts

```r
library(ggalt)
library(ggplot2)

# Basic lollipop
ggplot(df, aes(x = reorder(category, value), y = value)) +
  geom_lollipop() +
  coord_flip()

# Horizontal lollipop
ggplot(df, aes(x = value, y = reorder(category, value))) +
  geom_lollipop(horizontal = TRUE)

# Customized
ggplot(df, aes(x = reorder(category, value), y = value)) +
  geom_lollipop(
    point.colour = "steelblue",
    point.size = 3,
    stem.colour = "gray"
  ) +
  coord_flip()
```

## Dumbbell Plots

```r
# Compare two values per category
ggplot(df, aes(x = value1, xend = value2, y = category)) +
  geom_dumbbell()

# Customized dumbbell
ggplot(df, aes(x = value1, xend = value2, y = reorder(category, value1))) +
  geom_dumbbell(
    colour = "gray",
    size = 2,
    colour_x = "blue",
    colour_xend = "red",
    size_x = 3,
    size_xend = 3
  )

# With labels
ggplot(df, aes(x = value1, xend = value2, y = category)) +
  geom_dumbbell() +
  geom_text(aes(x = value1, label = value1), hjust = 1.5) +
  geom_text(aes(x = value2, label = value2), hjust = -0.5)
```

## Encircling Points

```r
# Encircle a group
ggplot(iris, aes(Sepal.Length, Sepal.Width)) +
  geom_point(aes(color = Species)) +
  geom_encircle(aes(group = Species, fill = Species), alpha = 0.2)

# Encircle specific points
highlight <- iris[iris$Sepal.Length > 7, ]
ggplot(iris, aes(Sepal.Length, Sepal.Width)) +
  geom_point() +
  geom_encircle(data = highlight, color = "red", size = 2)

# Customized encircle
ggplot(df, aes(x, y)) +
  geom_point() +
  geom_encircle(
    s_shape = 0.5,      # Shape (0 = circle, 1 = follow points)
    expand = 0.02,      # Expansion
    spread = 0.01       # Spread
  )
```

## Splines

```r
# X-spline
ggplot(df, aes(x, y)) +
  geom_xspline()

# B-spline
ggplot(df, aes(x, y)) +
  geom_bspline()

# Closed spline
ggplot(df, aes(x, y)) +
  geom_bspline_closed(fill = "lightblue", alpha = 0.5)
```

## Step Ribbon

```r
# Step ribbon for uncertainty
ggplot(df, aes(x = date, y = value, ymin = lower, ymax = upper)) +
  geom_stepribbon(fill = "lightblue", alpha = 0.5) +
  geom_step()
```

## Coordinate Systems

```r
# Cartesian with aspect ratio
ggplot(df, aes(x, y)) +
  geom_point() +
  coord_cartesian_equal()

# Projected coordinates
ggplot(map_data, aes(long, lat, group = group)) +
  geom_polygon() +
  coord_proj("+proj=robin")  # Robinson projection
```

## Annotations

```r
# Annotate with encircle
ggplot(df, aes(x, y)) +
  geom_point() +
  annotate("encircle",
    x = c(1, 2, 3),
    y = c(4, 5, 6),
    color = "red",
    size = 2
  )
```

## Stat Functions

```r
# ECDF with steps
ggplot(df, aes(x)) +
  stat_ecdf(geom = "step")

# Ash (average shifted histogram)
ggplot(df, aes(x)) +
  geom_ash()
```

## Formatting

```r
# Byte formatting for axes
ggplot(df, aes(x, bytes)) +
  geom_col() +
  scale_y_continuous(labels = byte_format())

# SI prefix formatting
ggplot(df, aes(x, value)) +
  geom_col() +
  scale_y_continuous(labels = si_format())
```

## Combining with ggplot2

```r
# Full example
ggplot(df, aes(x = start, xend = end, y = reorder(name, start))) +
  geom_dumbbell(
    colour = "#e3e2e1",
    colour_x = "#5b8124",
    colour_xend = "#bad744",
    size = 3,
    size_x = 4,
    size_xend = 4
  ) +
  labs(
    title = "Change Over Time",
    x = "Value",
    y = NULL
  ) +
  theme_minimal()
```
