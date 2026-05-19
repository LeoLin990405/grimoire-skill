# R4DS - Part I: Visualize (ggplot2)

Based on "R for Data Science" (2e) by Hadley Wickham et al.
Book URL: https://r4ds.hadley.nz/

## Core Structure

```r
ggplot(data, aes(x = var1, y = var2)) +
  geom_*() +
  labs() +
  theme_*()
```

## Aesthetic Mappings

**Inside `aes()`**: Map data to visual properties (varies by data)
**Outside `aes()`**: Set fixed visual properties

```r
# Mapping (color varies by species)
ggplot(df, aes(x = x, y = y, color = species)) + geom_point()

# Setting (all points blue)
ggplot(df, aes(x = x, y = y)) + geom_point(color = "blue")
```

## Common Aesthetics

| Aesthetic | Description |
|-----------|-------------|
| `x`, `y` | Position |
| `color` | Outline color |
| `fill` | Fill color |
| `size` | Point/line size |
| `shape` | Point shape |
| `alpha` | Transparency |
| `linetype` | Line pattern |

## Geoms

### One Variable

| Data Type | Geom | Example |
|-----------|------|---------|
| Categorical | `geom_bar()` | Bar chart |
| Numeric | `geom_histogram()` | Distribution |
| Numeric | `geom_density()` | Smooth distribution |
| Numeric | `geom_boxplot()` | Box plot |

### Two Variables

| X | Y | Geom |
|---|---|------|
| Numeric | Numeric | `geom_point()` |
| Numeric | Numeric | `geom_smooth()` |
| Numeric | Numeric | `geom_line()` |
| Categorical | Numeric | `geom_boxplot()` |
| Categorical | Numeric | `geom_violin()` |
| Categorical | Categorical | `geom_count()` |

### Common Geoms Reference

```r
geom_point()      # Scatter plot
geom_line()       # Line chart
geom_bar()        # Bar chart (stat = "count")
geom_col()        # Bar chart (stat = "identity")
geom_histogram()  # Histogram (set binwidth)
geom_density()    # Density curve
geom_boxplot()    # Box plot
geom_violin()     # Violin plot
geom_smooth()     # Trend line (method = "lm" for linear)
geom_text()       # Text labels
geom_label()      # Text with background
geom_tile()       # Heatmap tiles
geom_area()       # Area chart
geom_ribbon()     # Range ribbon
```

## Faceting

```r
# Single variable - wrap into rows
facet_wrap(~variable)
facet_wrap(~variable, ncol = 2)

# Two variables - grid
facet_grid(row_var ~ col_var)
facet_grid(. ~ col_var)  # Only columns
facet_grid(row_var ~ .)  # Only rows
```

## Scales

```r
# Axis scales
scale_x_continuous(limits = c(0, 100), breaks = seq(0, 100, 20))
scale_y_log10()
scale_x_date(date_labels = "%Y-%m")

# Color scales
scale_color_manual(values = c("red", "blue"))
scale_color_brewer(palette = "Set1")
scale_color_viridis_d()  # Discrete
scale_color_viridis_c()  # Continuous
scale_fill_gradient(low = "white", high = "red")
```

## Labels & Themes

```r
# Labels
labs(
  title = "Main Title",
  subtitle = "Subtitle",
  caption = "Data source",
  x = "X axis label",
  y = "Y axis label",
  color = "Legend title"
)

# Themes
theme_minimal()
theme_bw()
theme_classic()
theme_void()

# Custom theme elements
theme(
  legend.position = "bottom",
  axis.text.x = element_text(angle = 45, hjust = 1),
  panel.grid.minor = element_blank()
)
```

## Coordinate Systems

```r
coord_flip()           # Flip x and y
coord_polar()          # Polar coordinates
coord_fixed(ratio = 1) # Fixed aspect ratio
coord_cartesian(xlim = c(0, 10))  # Zoom without removing data
```

## Save Plots

```r
ggsave("plot.png", width = 10, height = 6, dpi = 300)
ggsave("plot.pdf", width = 10, height = 6)
ggsave("plot.svg", width = 10, height = 6)
```

## Combining Plots (patchwork)

```r
library(patchwork)

p1 + p2           # Side by side
p1 / p2           # Stacked
p1 + p2 + p3 + plot_layout(ncol = 2)
(p1 | p2) / p3    # Complex layouts
```
