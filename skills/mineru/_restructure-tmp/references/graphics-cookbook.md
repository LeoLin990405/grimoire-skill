# R Graphics Cookbook Reference

Based on "R Graphics Cookbook" (2nd ed) by Winston Chang.
Book URL: https://r-graphics.org/

## Bar Graphs

### Basic Bar Graph
```r
# Counts (stat = "count")
ggplot(df, aes(x = category)) +
  geom_bar()

# Values (stat = "identity")
ggplot(df, aes(x = category, y = value)) +
  geom_col()
```

### Grouped Bars
```r
ggplot(df, aes(x = category, y = value, fill = group)) +
  geom_col(position = "dodge")
```

### Stacked Bars
```r
# Stacked
ggplot(df, aes(x = category, y = value, fill = group)) +
  geom_col(position = "stack")

# 100% Stacked
ggplot(df, aes(x = category, y = value, fill = group)) +
  geom_col(position = "fill")
```

### Bar Styling
```r
geom_col(width = 0.5)              # Bar width
geom_col(color = "black")         # Border color
coord_flip()                       # Horizontal bars
```

### Reorder Bars
```r
ggplot(df, aes(x = reorder(category, value), y = value)) +
  geom_col()

ggplot(df, aes(x = fct_reorder(category, value), y = value)) +
  geom_col()
```

## Line Graphs

### Basic Line
```r
ggplot(df, aes(x = date, y = value)) +
  geom_line()
```

### Multiple Lines
```r
ggplot(df, aes(x = date, y = value, color = group)) +
  geom_line()

ggplot(df, aes(x = date, y = value, linetype = group)) +
  geom_line()
```

### Line + Points
```r
ggplot(df, aes(x = date, y = value)) +
  geom_line() +
  geom_point()
```

### Area Charts
```r
ggplot(df, aes(x = date, y = value)) +
  geom_area(fill = "lightblue", alpha = 0.5)

# Stacked area
ggplot(df, aes(x = date, y = value, fill = group)) +
  geom_area()
```

## Scatter Plots

### Basic Scatter
```r
ggplot(df, aes(x = x, y = y)) +
  geom_point()
```

### Grouping Points
```r
ggplot(df, aes(x = x, y = y, color = group)) +
  geom_point()

ggplot(df, aes(x = x, y = y, shape = group)) +
  geom_point()

ggplot(df, aes(x = x, y = y, size = z)) +
  geom_point()
```

### Overplotting Solutions
```r
geom_point(alpha = 0.3)           # Transparency
geom_point(position = "jitter")   # Jitter
geom_bin2d()                      # 2D bins
geom_hex()                        # Hexagonal bins
geom_density_2d()                 # Contours
```

### Fitted Lines
```r
geom_smooth()                     # LOESS (default)
geom_smooth(method = "lm")        # Linear
geom_smooth(method = "lm", se = FALSE)  # No confidence band
```

## Distributions

### Histogram
```r
ggplot(df, aes(x = value)) +
  geom_histogram(binwidth = 5)

ggplot(df, aes(x = value)) +
  geom_histogram(bins = 30)
```

### Density
```r
ggplot(df, aes(x = value)) +
  geom_density()

# Multiple groups
ggplot(df, aes(x = value, fill = group)) +
  geom_density(alpha = 0.5)
```

### Box Plot
```r
ggplot(df, aes(x = group, y = value)) +
  geom_boxplot()

# With points
ggplot(df, aes(x = group, y = value)) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(width = 0.2, alpha = 0.5)
```

### Violin Plot
```r
ggplot(df, aes(x = group, y = value)) +
  geom_violin()

# With box plot inside
ggplot(df, aes(x = group, y = value)) +
  geom_violin() +
  geom_boxplot(width = 0.1)
```

## Annotations

### Text Labels
```r
geom_text(aes(label = name))
geom_text(aes(label = name), hjust = 0, vjust = 0)
geom_label(aes(label = name))     # With background

# Repel overlapping labels
ggrepel::geom_text_repel(aes(label = name))
ggrepel::geom_label_repel(aes(label = name))
```

### Reference Lines
```r
geom_hline(yintercept = 50)
geom_vline(xintercept = 10)
geom_abline(intercept = 0, slope = 1)
```

### Rectangles & Segments
```r
annotate("rect", xmin = 1, xmax = 3, ymin = 0, ymax = 10,
         alpha = 0.2, fill = "blue")

annotate("segment", x = 1, xend = 3, y = 5, yend = 10,
         arrow = arrow())

annotate("text", x = 2, y = 5, label = "Note")
```

### Error Bars
```r
geom_errorbar(aes(ymin = mean - se, ymax = mean + se), width = 0.2)
geom_pointrange(aes(ymin = mean - se, ymax = mean + se))
geom_linerange(aes(ymin = mean - se, ymax = mean + se))
```

## Colors

### Discrete Colors
```r
scale_color_manual(values = c("red", "blue", "green"))
scale_fill_brewer(palette = "Set1")
scale_color_viridis_d()
```
### Continuous Colors
```r
scale_color_gradient(low = "white", high = "red")
scale_color_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0)
scale_color_viridis_c()
scale_fill_distiller(palette = "Spectral")
```

### Colorblind-Friendly
```r
scale_color_viridis_d()           # Best for colorblind
scale_fill_brewer(palette = "Set2")
# Or use: RColorBrewer::display.brewer.all(colorblindFriendly = TRUE)
```

## Output

### Save Plots
```r
ggsave("plot.png", width = 10, height = 6, dpi = 300)
ggsave("plot.pdf", width = 10, height = 6)
ggsave("plot.svg", width = 10, height = 6)

# Specific plot object
ggsave("plot.png", plot = p, width = 10, height = 6)
```

### Combine Plots (patchwork)
```r
library(patchwork)

p1 + p2                 # Side by side
p1 / p2                 # Stacked
(p1 | p2) / p3          # Complex layout
p1 + p2 + plot_layout(ncol = 1)
p1 + p2 + plot_annotation(title = "Combined")
```

## Special Plots

### Heatmap
```r
ggplot(df, aes(x = x, y = y, fill = value)) +
  geom_tile() +
  scale_fill_viridis_c()
```

### Correlation Matrix
```r
library(corrplot)
corrplot(cor(df), method = "circle")

# With ggplot2
library(ggcorrplot)
ggcorrplot(cor(df), type = "lower", lab = TRUE)
```

### Maps
```r
library(sf)
ggplot(map_data) +
  geom_sf(aes(fill = value))
```
