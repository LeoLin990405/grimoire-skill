---
name: ggplot2
description: R ggplot2 package for data visualization. Use for creating plots with grammar of graphics - geoms, aesthetics, facets, scales, themes.
---

# ggplot2

Grammar of graphics visualization.

## Basic Structure

```r
library(ggplot2)

ggplot(data, aes(x = x, y = y)) +
  geom_point() +
  labs(title = "Title") +
  theme_minimal()
```

## Aesthetics

```r
aes(x = x, y = y)
aes(color = group)
aes(fill = category)
aes(size = value)
aes(shape = type)
aes(alpha = intensity)
aes(linetype = series)
aes(group = id)
```

## Geoms

```r
# Points and lines
geom_point()
geom_line()
geom_path()
geom_step()
geom_segment(aes(xend = x2, yend = y2))

# Bars
geom_bar(stat = "count")
geom_col()  # stat = "identity"
geom_histogram(bins = 30)

# Area
geom_area()
geom_ribbon(aes(ymin = lower, ymax = upper))
geom_density()

# Box/violin
geom_boxplot()
geom_violin()
geom_jitter()

# Text
geom_text(aes(label = name))
geom_label(aes(label = name))

# Smooth
geom_smooth(method = "lm")
geom_smooth(method = "loess")

# Reference
geom_hline(yintercept = 0)
geom_vline(xintercept = 0)
geom_abline(slope = 1, intercept = 0)

# Tile/raster
geom_tile()
geom_raster()
geom_contour()

# Error bars
geom_errorbar(aes(ymin = y - se, ymax = y + se))
geom_pointrange(aes(ymin = lower, ymax = upper))
```

## Facets

```r
facet_wrap(~ variable)
facet_wrap(~ variable, ncol = 2)
facet_wrap(~ variable, scales = "free")
facet_grid(row ~ col)
facet_grid(. ~ col)
facet_grid(row ~ .)
```

## Scales

```r
# Axes
scale_x_continuous(limits = c(0, 100), breaks = seq(0, 100, 20))
scale_y_log10()
scale_x_date(date_labels = "%Y-%m")
scale_x_discrete(labels = c("A" = "Label A"))

# Colors
scale_color_manual(values = c("red", "blue"))
scale_color_brewer(palette = "Set1")
scale_color_viridis_c()
scale_color_viridis_d()
scale_color_gradient(low = "white", high = "red")
scale_color_gradient2(low = "blue", mid = "white", high = "red")

scale_fill_manual(values = c("red", "blue"))
scale_fill_brewer(palette = "Blues")

# Size/shape
scale_size_continuous(range = c(1, 10))
scale_shape_manual(values = c(16, 17, 18))
```

## Coordinates

```r
coord_cartesian(xlim = c(0, 10), ylim = c(0, 100))
coord_flip()
coord_polar()
coord_fixed(ratio = 1)
coord_trans(x = "log10", y = "sqrt")
```

## Themes

```r
theme_minimal()
theme_bw()
theme_classic()
theme_void()
theme_dark()

# Custom
theme(
  plot.title = element_text(size = 16, face = "bold"),
  axis.title = element_text(size = 12),
  axis.text = element_text(size = 10),
  legend.position = "bottom",
  legend.title = element_blank(),
  panel.grid.minor = element_blank(),
  panel.background = element_rect(fill = "white"),
  strip.background = element_rect(fill = "gray90")
)
```

## Labels

```r
labs(
  title = "Main Title",
  subtitle = "Subtitle",
  caption = "Source: Data",
  x = "X Axis",
  y = "Y Axis",
  color = "Legend Title",
  fill = "Fill Legend"
)

ggtitle("Title")
xlab("X Label")
ylab("Y Label")
```

## Annotations

```r
annotate("text", x = 5, y = 10, label = "Note")
annotate("rect", xmin = 1, xmax = 3, ymin = 0, ymax = 10, alpha = 0.2)
annotate("segment", x = 1, xend = 3, y = 5, yend = 10, arrow = arrow())
```

## Save

```r
ggsave("plot.png", width = 10, height = 6, dpi = 300)
ggsave("plot.pdf", width = 10, height = 6)
ggsave("plot.svg", width = 10, height = 6)
```
