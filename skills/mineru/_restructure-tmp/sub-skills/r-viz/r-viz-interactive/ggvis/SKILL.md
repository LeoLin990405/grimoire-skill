---
name: ggvis
description: R ggvis package for interactive graphics. Use for creating interactive web graphics with a grammar of graphics.
---

# ggvis

Interactive web graphics with grammar of graphics.

## Basic Plots

```r
library(ggvis)

# Scatter plot
mtcars %>%
  ggvis(~wt, ~mpg) %>%
  layer_points()

# Line plot
df %>%
  ggvis(~x, ~y) %>%
  layer_lines()

# Bar plot
df %>%
  ggvis(~category) %>%
  layer_bars()
```

## Aesthetics

```r
mtcars %>%
  ggvis(~wt, ~mpg) %>%
  layer_points(
    fill = ~factor(cyl),
    size = ~hp,
    opacity := 0.5
  )

# := for fixed values, ~ for mapped values
mtcars %>%
  ggvis(~wt, ~mpg) %>%
  layer_points(
    fill := "red",      # Fixed color
    size := 100,        # Fixed size
    stroke := "black"   # Fixed stroke
  )
```

## Multiple Layers

```r
mtcars %>%
  ggvis(~wt, ~mpg) %>%
  layer_points() %>%
  layer_smooths(stroke := "red")

# Points with lines
df %>%
  ggvis(~x, ~y) %>%
  layer_points() %>%
  layer_lines()
```

## Interactivity

```r
# Tooltips
mtcars %>%
  ggvis(~wt, ~mpg) %>%
  layer_points() %>%
  add_tooltip(function(df) df$mpg)

# Custom tooltip
mtcars %>%
  ggvis(~wt, ~mpg) %>%
  layer_points() %>%
  add_tooltip(function(df) {
    paste0("MPG: ", df$mpg, "<br>", "Weight: ", df$wt)
  }, "hover")
```

## Input Controls

```r
# Slider
mtcars %>%
  ggvis(~wt, ~mpg) %>%
  layer_points(
    size := input_slider(10, 300, value = 50, label = "Size")
  )

# Select
mtcars %>%
  ggvis(~wt, ~mpg) %>%
  layer_points(
    fill := input_select(c("red", "blue", "green"), label = "Color")
  )

# Checkbox
mtcars %>%
  ggvis(~wt, ~mpg) %>%
  layer_points(
    opacity := input_checkbox(label = "Transparent", map = function(x) if(x) 0.3 else 1)
  )
```

## Scales

```r
mtcars %>%
  ggvis(~wt, ~mpg) %>%
  layer_points(fill = ~factor(cyl)) %>%
  scale_nominal("fill", range = c("red", "blue", "green"))

# Axis customization
mtcars %>%
  ggvis(~wt, ~mpg) %>%
  layer_points() %>%
  add_axis("x", title = "Weight") %>%
  add_axis("y", title = "Miles per Gallon")
```

## Legends

```r
mtcars %>%
  ggvis(~wt, ~mpg, fill = ~factor(cyl)) %>%
  layer_points() %>%
  add_legend("fill", title = "Cylinders")
```

## Histograms and Density

```r
# Histogram
mtcars %>%
  ggvis(~mpg) %>%
  layer_histograms(width = 2)

# Density
mtcars %>%
  ggvis(~mpg) %>%
  layer_densities()
```

## Grouping

```r
mtcars %>%
  ggvis(~wt, ~mpg) %>%
  layer_points() %>%
  layer_smooths() %>%
  group_by(cyl)
```

## Shiny Integration

```r
# In Shiny UI
ggvisOutput("plot")

# In Shiny server
bind_shiny(
  mtcars %>%
    ggvis(~wt, ~mpg) %>%
    layer_points(),
  "plot"
)
```
