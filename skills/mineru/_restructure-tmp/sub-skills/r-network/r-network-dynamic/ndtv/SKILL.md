---
name: ndtv
description: R ndtv package for network animation. Use for visualizing and animating dynamic networks.
---

# ndtv

Network dynamic temporal visualization.

## Compute Animation

```r
library(ndtv)

# Compute layout for animation
compute.animation(dnet,
  animation.mode = "kamadakawai",
  slice.par = list(
    start = 0,
    end = 10,
    interval = 1,
    aggregate.dur = 1
  ))
```

## Render Animation

```r
# HTML/D3 animation
render.d3movie(dnet, filename = "network.html")

# GIF animation
render.animation(dnet, filename = "network.gif")

# Video
render.animation(dnet, filename = "network.mp4",
  ani.options = list(interval = 0.1))
```

## Customization

```r
render.d3movie(dnet,
  # Vertex appearance
  vertex.col = "blue",
  vertex.cex = 1.5,
  vertex.sides = 50,  # Circle

  # Edge appearance
  edge.col = "gray",
  edge.lwd = 1,

  # Labels
  displaylabels = TRUE,
  label.cex = 0.8,
  label.col = "black",

  # Output
  filename = "network.html",
  output.mode = "htmlWidget"
)
```

## Dynamic Attributes

```r
# Color by attribute
render.d3movie(dnet,
  vertex.col = function(slice) {
    get.vertex.attribute(slice, "group")
  })

# Size by degree
render.d3movie(dnet,
  vertex.cex = function(slice) {
    degree(slice) / 5
  })
```

## Timeline

```r
# Add timeline
timeline(dnet,
  slice.par = list(start = 0, end = 10, interval = 1))

# Filmstrip view
filmstrip(dnet, displaylabels = TRUE)
```

## Layout Modes

```r
# Available modes
compute.animation(dnet, animation.mode = "kamadakawai")
compute.animation(dnet, animation.mode = "MDSJ")
compute.animation(dnet, animation.mode = "Graphviz")
compute.animation(dnet, animation.mode = "useAttribute")
```

## Proximity Timeline

```r
# Proximity timeline plot
proximity.timeline(dnet,
  default.dist = 10,
  mode = "sammon")
```

## Export Frames

```r
# Export individual frames
for (t in 0:10) {
  net_t <- network.extract(dnet, at = t)
  png(paste0("frame_", t, ".png"))
  plot(net_t)
  dev.off()
}
```
