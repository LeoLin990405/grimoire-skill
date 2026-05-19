---
name: lattice
description: R lattice package for trellis graphics. Use for multi-panel conditioning plots and high-level statistical graphics.
---

# lattice

Trellis graphics for R.

## Basic Plots

```r
library(lattice)

# Scatter plot
xyplot(y ~ x, data = df)

# Histogram
histogram(~ x, data = df)

# Density plot
densityplot(~ x, data = df)

# Box plot
bwplot(~ x | group, data = df)

# Bar chart
barchart(y ~ x, data = df)

# Dot plot
dotplot(y ~ x, data = df)
```

## Conditioning (Panels)

```r
# Condition on one variable
xyplot(y ~ x | group, data = df)

# Condition on two variables
xyplot(y ~ x | group1 * group2, data = df)

# Layout control
xyplot(y ~ x | group, data = df, layout = c(3, 2))
```

## Grouping

```r
# Group by variable
xyplot(y ~ x, groups = group, data = df, auto.key = TRUE)

# Custom legend
xyplot(y ~ x, groups = group, data = df,
  auto.key = list(space = "right", title = "Group")
)
```

## Panel Functions

```r
# Add regression line
xyplot(y ~ x | group, data = df,
  panel = function(x, y, ...) {
    panel.xyplot(x, y, ...)
    panel.lmline(x, y, col = "red")
  }
)

# Add smooth line
xyplot(y ~ x, data = df,
  panel = function(x, y, ...) {
    panel.xyplot(x, y, ...)
    panel.loess(x, y, col = "blue")
  }
)

# Add grid
xyplot(y ~ x, data = df,
  panel = function(...) {
    panel.grid(h = -1, v = -1)
    panel.xyplot(...)
  }
)
```

## 3D Plots

```r
# 3D scatter
cloud(z ~ x * y, data = df)

# 3D surface
wireframe(z ~ x * y, data = df)

# Level plot (heatmap)
levelplot(z ~ x * y, data = df)

# Contour plot
contourplot(z ~ x * y, data = df)
```

## Customization

```r
# Colors and symbols
xyplot(y ~ x, data = df,
  col = "blue",
  pch = 16,
  cex = 1.5
)

# Axis labels
xyplot(y ~ x, data = df,
  xlab = "X Variable",
  ylab = "Y Variable",
  main = "Title"
)

# Scales
xyplot(y ~ x, data = df,
  scales = list(
    x = list(log = 10),
    y = list(rot = 45)
  )
)
```

## Themes

```r
# Set theme
trellis.par.set(theme = standard.theme(color = FALSE))

# Custom theme
my_theme <- list(
  plot.polygon = list(col = "lightblue"),
  plot.line = list(col = "darkblue", lwd = 2)
)
trellis.par.set(my_theme)

# Reset
trellis.par.set(theme = standard.theme())
```

## Strip Labels

```r
# Custom strip
xyplot(y ~ x | group, data = df,
  strip = strip.custom(
    bg = "lightgray",
    par.strip.text = list(cex = 0.8)
  )
)

# Strip function
xyplot(y ~ x | group, data = df,
  strip = function(which.panel, ...) {
    strip.default(which.panel, ...)
  }
)
```

## Combining Plots

```r
# Multiple plots
p1 <- xyplot(y ~ x, data = df)
p2 <- histogram(~ x, data = df)

# Print together
print(p1, split = c(1, 1, 2, 1), more = TRUE)
print(p2, split = c(2, 1, 2, 1))

# Using gridExtra
library(gridExtra)
grid.arrange(p1, p2, ncol = 2)
```

## Saving Plots

```r
# PDF
pdf("plot.pdf")
print(xyplot(y ~ x, data = df))
dev.off()

# PNG
png("plot.png", width = 800, height = 600)
print(xyplot(y ~ x, data = df))
dev.off()

# trellis.device
trellis.device(pdf, file = "plot.pdf")
print(xyplot(y ~ x, data = df))
dev.off()
```
