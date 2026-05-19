---
name: plotly
description: R plotly package for interactive visualizations. Use for creating interactive charts, 3D plots, and converting ggplot2 to interactive.
---

# plotly

Interactive visualizations.

## From ggplot2

```r
library(plotly)

p <- ggplot(df, aes(x, y)) + geom_point()
ggplotly(p)

# Customize tooltip
ggplotly(p, tooltip = c("x", "y", "color"))
```

## Native plotly

```r
# Scatter
plot_ly(df, x = ~x, y = ~y, type = "scatter", mode = "markers")
plot_ly(df, x = ~x, y = ~y, color = ~group, type = "scatter", mode = "markers")

# Line
plot_ly(df, x = ~x, y = ~y, type = "scatter", mode = "lines")
plot_ly(df, x = ~x, y = ~y, type = "scatter", mode = "lines+markers")

# Bar
plot_ly(df, x = ~category, y = ~value, type = "bar")
plot_ly(df, x = ~category, y = ~value, color = ~group, type = "bar")

# Histogram
plot_ly(df, x = ~value, type = "histogram")

# Box
plot_ly(df, y = ~value, type = "box")
plot_ly(df, x = ~group, y = ~value, type = "box")

# Heatmap
plot_ly(z = ~matrix, type = "heatmap")

# Pie
plot_ly(df, labels = ~category, values = ~value, type = "pie")
```

## 3D Plots

```r
# 3D scatter
plot_ly(df, x = ~x, y = ~y, z = ~z, type = "scatter3d", mode = "markers")

# 3D surface
plot_ly(z = ~volcano, type = "surface")

# 3D line
plot_ly(df, x = ~x, y = ~y, z = ~z, type = "scatter3d", mode = "lines")
```

## Layout

```r
plot_ly(df, x = ~x, y = ~y) %>%
  layout(
    title = "Title",
    xaxis = list(title = "X Axis"),
    yaxis = list(title = "Y Axis"),
    legend = list(x = 0.8, y = 0.9),
    margin = list(l = 50, r = 50, t = 50, b = 50)
  )

# Axis options
layout(
  xaxis = list(
    title = "X",
    range = c(0, 100),
    tickvals = c(0, 25, 50, 75, 100),
    ticktext = c("0%", "25%", "50%", "75%", "100%"),
    showgrid = TRUE,
    zeroline = FALSE
  )
)
```

## Subplots

```r
# Multiple plots
subplot(p1, p2, nrows = 1, shareX = TRUE)
subplot(p1, p2, p3, p4, nrows = 2)

# Share axes
subplot(p1, p2, shareY = TRUE)
```

## Animations

```r
plot_ly(df, x = ~x, y = ~y, frame = ~year, type = "scatter", mode = "markers") %>%
  animation_opts(frame = 1000, transition = 500) %>%
  animation_slider(currentvalue = list(prefix = "Year: "))
```

## Events

```r
# Click events
plot_ly(df, x = ~x, y = ~y) %>%
  event_register("plotly_click")

# In Shiny
observeEvent(event_data("plotly_click"), {
  click <- event_data("plotly_click")
  # Handle click
})
```

## Save

```r
# Save as HTML
htmlwidgets::saveWidget(p, "plot.html")

# Save as image (requires orca)
orca(p, "plot.png")
```
