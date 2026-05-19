---
name: r-viz-static
description: R static visualization with ggplot2 and lattice. Use for scatter plots, bar charts, line graphs, histograms, box plots, and publication-quality graphics.
---

# R Static Visualization

Publication-quality static graphics with ggplot2.

## ggplot2 Basics

```r
library(ggplot2)

# Basic structure
ggplot(data, aes(x = x_var, y = y_var)) +
  geom_point() +
  labs(title = "Title", x = "X", y = "Y") +
  theme_minimal()
```

## Geoms (Geometric Objects)

```r
# Points
geom_point(aes(color = group, size = value, shape = category))

# Lines
geom_line(aes(color = group, linetype = type))
geom_path()
geom_step()

# Bars
geom_bar(stat = "count")           # Count
geom_col()                         # Values
geom_bar(position = "dodge")       # Grouped
geom_bar(position = "fill")        # 100% stacked

# Area
geom_area(alpha = 0.5)
geom_ribbon(aes(ymin = lower, ymax = upper))

# Distributions
geom_histogram(bins = 30)
geom_density(fill = "blue", alpha = 0.3)
geom_boxplot()
geom_violin()
geom_jitter(width = 0.2)

# Statistical
geom_smooth(method = "lm", se = TRUE)
geom_smooth(method = "loess")
geom_quantile()

# Text
geom_text(aes(label = name))
geom_label(aes(label = name))
ggrepel::geom_text_repel(aes(label = name))
```

## Aesthetics

```r
# Inside aes() - mapped to data
aes(x = var1, y = var2, color = group, size = value)

# Outside aes() - fixed values
geom_point(color = "red", size = 3, alpha = 0.5)

# Common aesthetics
# x, y, color, fill, size, shape, alpha, linetype, group
```

## Facets

```r
# Wrap (one variable)
facet_wrap(~ category, ncol = 3)
facet_wrap(~ category, scales = "free_y")

# Grid (two variables)
facet_grid(rows ~ cols)
facet_grid(. ~ category)
facet_grid(category ~ ., scales = "free")
```

## Scales

```r
# Axes
scale_x_continuous(limits = c(0, 100), breaks = seq(0, 100, 20))
scale_y_log10()
scale_x_date(date_labels = "%Y-%m")

# Colors
scale_color_manual(values = c("A" = "red", "B" = "blue"))
scale_color_brewer(palette = "Set1")
scale_color_viridis_d()
scale_fill_gradient(low = "white", high = "red")
scale_fill_gradient2(low = "blue", mid = "white", high = "red")
```

## Themes

```r
# Built-in themes
theme_minimal()
theme_bw()
theme_classic()
theme_void()

# Customize
theme(
  plot.title = element_text(size = 16, face = "bold"),
  axis.text = element_text(size = 12),
  legend.position = "bottom",
  panel.grid.minor = element_blank()
)

# hrbrthemes
library(hrbrthemes)
theme_ipsum()
```

## Annotations

```r
# Reference lines
geom_hline(yintercept = 50, linetype = "dashed")
geom_vline(xintercept = 10, color = "red")
geom_abline(intercept = 0, slope = 1)

# Text annotations
annotate("text", x = 5, y = 10, label = "Note")
annotate("rect", xmin = 1, xmax = 3, ymin = 0, ymax = 10, alpha = 0.2)
annotate("segment", x = 1, xend = 3, y = 5, yend = 10, arrow = arrow())
```

## Combining Plots

```r
library(patchwork)

# Arrange
p1 + p2                    # Side by side
p1 / p2                    # Stacked
(p1 | p2) / p3             # Complex layout
p1 + p2 + plot_layout(ncol = 1, heights = c(2, 1))

# Annotations
p1 + p2 + plot_annotation(
  title = "Combined Plot",
  tag_levels = "A"
)
```

## Save

```r
ggsave("plot.png", width = 10, height = 6, dpi = 300)
ggsave("plot.pdf", width = 10, height = 6)
ggsave("plot.svg", width = 10, height = 6)
```

## lattice

```r
library(lattice)

xyplot(y ~ x | group, data = df)
bwplot(~ value | category, data = df)
histogram(~ value | group, data = df)
densityplot(~ value, groups = category, data = df)
```
