---
name: ggforce
description: R ggforce package for ggplot2 extensions. Use for advanced geometries, annotations, and transformations.
---

# ggforce

Accelerating ggplot2 with advanced features.

## Shapes and Geometries

```r
library(ggforce)
library(ggplot2)

# Circles
ggplot(df) +
  geom_circle(aes(x0 = x, y0 = y, r = radius, fill = group))

# Ellipses
ggplot(df) +
  geom_ellipse(aes(x0 = x, y0 = y, a = width, b = height, angle = angle))

# Arcs
ggplot(df) +
  geom_arc(aes(x0 = x, y0 = y, r = r, start = start, end = end))

# Bezier curves
ggplot(df) +
  geom_bezier(aes(x = x, y = y, group = id))
```

## Hulls and Enclosures

```r
# Convex hull
ggplot(df, aes(x, y, color = group)) +
  geom_point() +
  geom_mark_hull(aes(fill = group), concavity = 2)

# Ellipse enclosure
ggplot(df, aes(x, y, color = group)) +
  geom_point() +
  geom_mark_ellipse(aes(fill = group, label = group))

# Rectangle enclosure
ggplot(df, aes(x, y, color = group)) +
  geom_point() +
  geom_mark_rect(aes(fill = group))

# Circle enclosure
ggplot(df, aes(x, y, color = group)) +
  geom_point() +
  geom_mark_circle(aes(fill = group))
```

## Annotations

```r
# Mark with description
ggplot(df, aes(x, y)) +
  geom_point() +
  geom_mark_ellipse(
    aes(filter = group == "A", label = "Group A", description = "Notable cluster"),
    label.fontsize = 10
  )
```

## Faceting

```r
# Paginated facets
ggplot(df, aes(x, y)) +
  geom_point() +
  facet_wrap_paginate(~category, nrow = 2, ncol = 2, page = 1)

# Zoom facets
ggplot(df, aes(x, y)) +
  geom_point() +
  facet_zoom(xlim = c(0, 10), ylim = c(0, 5))

# Grid paginate
ggplot(df, aes(x, y)) +
  geom_point() +
  facet_grid_paginate(row ~ col, nrow = 2, ncol = 3, page = 1)
```

## Transformations

```r
# Linear transformation
ggplot(df, aes(x, y)) +
  geom_point() +
  coord_trans_xy(trans = "log10")

# Focus on region
ggplot(df, aes(x, y)) +
  geom_point() +
  facet_zoom(x = group == "A")
```

## Sina Plot (Violin + Jitter)

```r
# Sina plot - better than jitter for distributions
ggplot(df, aes(group, value)) +
  geom_sina()

# With violin
ggplot(df, aes(group, value)) +
  geom_violin() +
  geom_sina(alpha = 0.5)
```

## Parallel Coordinates

```r
# Parallel coordinates plot
ggplot(df) +
  geom_parallel_sets(aes(fill = category), alpha = 0.5) +
  geom_parallel_sets_axes() +
  geom_parallel_sets_labels()
```

## Links and Connections

```r
# Diagonal links
ggplot(df) +
  geom_link(aes(x = x1, y = y1, xend = x2, yend = y2, color = stat(index)))

# With varying properties along link
ggplot(df) +
  geom_link2(aes(x = x, y = y, group = id, color = value))
```

## Splines

```r
# B-spline
ggplot(df, aes(x, y)) +
  geom_bspline(aes(group = id))

# Closed B-spline
ggplot(df, aes(x, y)) +
  geom_bspline_closed(aes(fill = group))
```

## Voronoi

```r
# Voronoi tessellation
ggplot(df, aes(x, y)) +
  geom_voronoi_tile(aes(fill = group)) +
  geom_point()

# Delaunay triangulation
ggplot(df, aes(x, y)) +
  geom_delaunay_tile(aes(fill = stat(group))) +
  geom_point()
```
