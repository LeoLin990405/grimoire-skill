---
name: patchwork
description: R patchwork package for combining ggplot2 plots. Use for arranging multiple plots into composite figures.
---

# patchwork

Combine ggplot2 plots.

## Basic Composition

```r
library(patchwork)

# Side by side
p1 + p2

# Stacked
p1 / p2

# Complex layouts
(p1 | p2) / p3
(p1 + p2) / (p3 + p4)
p1 | (p2 / p3)
```

## Layout Control

```r
# Specify layout
p1 + p2 + p3 + plot_layout(ncol = 2)
p1 + p2 + p3 + plot_layout(nrow = 1)

# Widths and heights
p1 + p2 + plot_layout(widths = c(2, 1))
p1 / p2 + plot_layout(heights = c(1, 2))

# Design layout
design <- "
  AAB
  AAC
  DEC
"
p1 + p2 + p3 + p4 + p5 + plot_layout(design = design)

# Area function
design <- c(
  area(1, 1, 2, 2),
  area(1, 3),
  area(2, 3),
  area(3, 1, 3, 3)
)
p1 + p2 + p3 + p4 + plot_layout(design = design)
```

## Annotations

```r
# Add title to composition
p1 + p2 + plot_annotation(
  title = "Combined Plot",
  subtitle = "Subtitle",
  caption = "Source: Data",
  tag_levels = "A"
)

# Tag levels
p1 + p2 + plot_annotation(tag_levels = "A")  # A, B, C
p1 + p2 + plot_annotation(tag_levels = "1")  # 1, 2, 3
p1 + p2 + plot_annotation(tag_levels = "i")  # i, ii, iii
p1 + p2 + plot_annotation(tag_levels = c("A", "1"))  # Nested

# Tag styling
p1 + p2 + plot_annotation(
  tag_levels = "A",
  tag_prefix = "Fig. ",
  tag_suffix = ")"
)
```

## Spacers and Guides

```r
# Add empty space
p1 + plot_spacer() + p2

# Collect guides
p1 + p2 + plot_layout(guides = "collect")

# Collect and position
p1 + p2 + plot_layout(guides = "collect") &
  theme(legend.position = "bottom")
```

## Modifying All Plots

```r
# Apply theme to all
(p1 + p2 + p3) & theme_minimal()

# Apply scale to all
(p1 + p2 + p3) & scale_color_viridis_d()

# Modify specific plots
p1 + p2 + p3 & theme(legend.position = "none")
```

## Insets

```r
# Add inset plot
p1 + inset_element(
  p2,
  left = 0.6, right = 0.95,
  bottom = 0.6, top = 0.95
)

# Align inset
p1 + inset_element(p2, 0.6, 0.6, 1, 1, align_to = "panel")
```

## Wrap Plots

```r
# Wrap non-ggplot objects
wrap_elements(grid::textGrob("Text"))
wrap_elements(~plot(1:10))

# Wrap ggplot
wrap_plots(list(p1, p2, p3), ncol = 2)
```
