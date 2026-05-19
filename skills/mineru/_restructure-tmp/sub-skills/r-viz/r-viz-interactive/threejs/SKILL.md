---
name: threejs
description: R threejs package for 3D JavaScript visualizations. Use for interactive 3D scatter plots and globe visualizations.
---

# threejs

Interactive 3D visualizations using three.js.

## 3D Scatter Plot

```r
library(threejs)

# Basic scatter
scatterplot3js(x, y, z)

# With data frame
scatterplot3js(df$x, df$y, df$z)

# From matrix
scatterplot3js(matrix_data)
```

## Customization

```r
scatterplot3js(
  x, y, z,
  color = "blue",           # Point color
  size = 0.5,               # Point size
  labels = labels,          # Point labels
  renderer = "canvas",      # "canvas" or "webgl"
  bg = "white",             # Background color
  stroke = "black",         # Point outline
  flip.y = TRUE             # Flip y-axis
)
```

## Color by Variable

```r
# Color by group
colors <- c("red", "blue", "green")[as.factor(group)]
scatterplot3js(x, y, z, color = colors)

# Color gradient
colors <- colorRampPalette(c("blue", "red"))(100)
scatterplot3js(x, y, z, color = colors[cut(z, 100)])

# Rainbow colors
scatterplot3js(x, y, z, color = rainbow(length(x)))
```

## Size by Variable

```r
# Size by value
sizes <- scales::rescale(value, to = c(0.1, 1))
scatterplot3js(x, y, z, size = sizes)
```

## Axes and Grid

```r
scatterplot3js(
  x, y, z,
  axisLabels = c("X", "Y", "Z"),
  grid = TRUE,
  num.ticks = c(5, 5, 5)
)
```

## Globe Visualization

```r
# Basic globe
globejs()

# With points
globejs(
  lat = latitudes,
  long = longitudes
)

# With arcs
globejs(
  lat = latitudes,
  long = longitudes,
  arcs = arcs_data  # Data frame with origin/destination
)
```

## Globe Customization

```r
globejs(
  lat = latitudes,
  long = longitudes,
  value = values,           # Point heights
  color = colors,           # Point colors
  atmosphere = TRUE,        # Show atmosphere
  bg = "black",             # Background
  pointsize = 1,            # Point size
  rotationlat = 0,          # Initial rotation
  rotationlong = 0,
  fov = 35                  # Field of view
)
```

## Globe with Arcs

```r
# Create arcs data
arcs <- data.frame(
  origin_lat = c(40.7, 51.5),
  origin_long = c(-74.0, -0.1),
  dest_lat = c(35.7, 48.9),
  dest_long = c(139.7, 2.3)
)

globejs(
  arcs = arcs,
  arcsColor = "yellow",
  arcsHeight = 0.3,
  arcsLwd = 2,
  arcsOpacity = 0.5
)
```

## Graph Visualization

```r
# Network graph
graphjs(
  edges,                    # Edge list
  layout = layout,          # Node positions (3 columns)
  vertex.color = colors,
  vertex.size = sizes,
  edge.color = "gray",
  edge.width = 1
)
```

## Animation

```r
# Animated scatter
scatterplot3js(x, y, z, animation = TRUE)

# Custom animation speed
scatterplot3js(x, y, z,
  animation = TRUE,
  animationSpeed = 0.01
)
```

## Saving

```r
# Save as HTML widget
library(htmlwidgets)
p <- scatterplot3js(x, y, z)
saveWidget(p, "plot.html")

# In Shiny
output$plot <- renderScatterplotThree({
  scatterplot3js(x, y, z)
})
```

## With Shiny

```r
library(shiny)

ui <- fluidPage(
  scatterplotThreeOutput("scatter")
)

server <- function(input, output) {
  output$scatter <- renderScatterplotThree({
    scatterplot3js(x, y, z)
  })
}

shinyApp(ui, server)
```

## Performance

```r
# For large datasets, use WebGL
scatterplot3js(x, y, z, renderer = "webgl")

# Reduce point count for interactivity
sample_idx <- sample(length(x), 10000)
scatterplot3js(x[sample_idx], y[sample_idx], z[sample_idx])
```
