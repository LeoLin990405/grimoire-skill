---
name: rbokeh
description: R rbokeh package for Bokeh visualizations. Use for interactive web-based plots using Bokeh.js.
---

# rbokeh

R interface to Bokeh for interactive visualizations.

## Basic Plots

```r
library(rbokeh)

# Scatter plot
figure() %>%
  ly_points(x, y, data = df)

# Line plot
figure() %>%
  ly_lines(x, y, data = df)

# Bar chart
figure() %>%
  ly_bar(category, value, data = df)
```

## Figure Options

```r
figure(
  title = "My Plot",
  width = 800,
  height = 600,
  xlab = "X Axis",
  ylab = "Y Axis",
  xlim = c(0, 100),
  ylim = c(0, 50),
  xgrid = TRUE,
  ygrid = TRUE
) %>%
  ly_points(x, y, data = df)
```

## Glyphs

```r
# Points
figure() %>%
  ly_points(x, y, data = df, color = "blue", size = 10)

# Lines
figure() %>%
  ly_lines(x, y, data = df, color = "red", width = 2)

# Segments
figure() %>%
  ly_segments(x0, y0, x1, y1, data = df)

# Rectangles
figure() %>%
  ly_rect(xleft, ybottom, xright, ytop, data = df)

# Circles
figure() %>%
  ly_circle(x, y, data = df, radius = 0.5)

# Text
figure() %>%
  ly_text(x, y, text = label, data = df)
```

## Grouping and Colors

```r
# Color by group
figure() %>%
  ly_points(x, y, data = df, color = group)

# Custom palette
figure() %>%
  ly_points(x, y, data = df,
    color = group,
    palette = c("red", "blue", "green")
  )

# Size by variable
figure() %>%
  ly_points(x, y, data = df, size = value)
```

## Statistical Layers

```r
# Histogram
figure() %>%
  ly_hist(x, data = df, breaks = 30)

# Density
figure() %>%
  ly_density(x, data = df)

# Box plot
figure() %>%
  ly_boxplot(group, value, data = df)

# Quantile
figure() %>%
  ly_quantile(x, data = df)
```

## Hover Tool

```r
# Add hover info
figure() %>%
  ly_points(x, y, data = df,
    hover = c(x, y, label)
  )

# Custom hover
figure() %>%
  ly_points(x, y, data = df,
    hover = list(
      "X Value" = x,
      "Y Value" = y,
      "Category" = category
    )
  )
```

## Multiple Layers

```r
figure() %>%
  ly_points(x, y, data = df1, color = "blue") %>%
  ly_lines(x, y, data = df2, color = "red") %>%
  ly_abline(h = 0, color = "gray")
```

## Axes

```r
# Log scale
figure() %>%
  ly_points(x, y, data = df) %>%
  x_axis(log = TRUE) %>%
  y_axis(log = TRUE)

# Date axis
figure() %>%
  ly_lines(date, value, data = df) %>%
  x_axis(type = "datetime")

# Categorical axis
figure() %>%
  ly_bar(category, value, data = df) %>%
  x_axis(type = "categorical")
```

## Annotations

```r
# Horizontal/vertical lines
figure() %>%
  ly_points(x, y, data = df) %>%
  ly_abline(h = mean(df$y), color = "red") %>%
  ly_abline(v = mean(df$x), color = "blue")

# Shaded region
figure() %>%
  ly_points(x, y, data = df) %>%
  ly_rect(xleft = 0, xright = 10, ybottom = 0, ytop = 5,
          fill_alpha = 0.2, color = "gray")
```

## Grid Plots

```r
# Multiple figures
p1 <- figure() %>% ly_points(x, y, data = df1)
p2 <- figure() %>% ly_lines(x, y, data = df2)
p3 <- figure() %>% ly_hist(x, data = df3)

grid_plot(list(p1, p2, p3), ncol = 2)
```

## Saving

```r
# Save as HTML
p <- figure() %>% ly_points(x, y, data = df)
rbokeh2html(p, file = "plot.html")

# Save as PNG (requires phantomjs)
widget2png(p, file = "plot.png")
```

## Tools

```r
# Customize tools
figure(tools = c("pan", "wheel_zoom", "box_zoom", "reset", "save")) %>%
  ly_points(x, y, data = df)
```
