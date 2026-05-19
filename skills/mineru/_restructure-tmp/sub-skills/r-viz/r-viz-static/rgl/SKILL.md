---
name: rgl
description: R rgl package for 3D visualization. Use for interactive 3D graphics using OpenGL.
---

# rgl

Interactive 3D visualization with OpenGL.

## Basic 3D Plots

```r
library(rgl)

# 3D scatter plot
plot3d(x, y, z)
plot3d(x, y, z, col = "red", size = 5)

# Points
points3d(x, y, z)

# Lines
lines3d(x, y, z)

# Spheres
spheres3d(x, y, z, radius = 0.1)
```

## Surfaces

```r
# Surface from matrix
z <- outer(x, y, function(x, y) sin(x) * cos(y))
persp3d(x, y, z)

# Surface with colors
persp3d(x, y, z, col = "lightblue", alpha = 0.8)

# Wireframe
persp3d(x, y, z, front = "lines", back = "lines")

# Surface from function
surface3d(x, y, z)
```

## Shapes

```r
# Cube
cube3d()
shade3d(cube3d(), col = "red")

# Sphere
spheres3d(0, 0, 0, radius = 1)

# Cylinder
cylinder3d(center = rbind(c(0, 0, 0), c(0, 0, 1)), radius = 0.5)

# Cone
cone3d(base = c(0, 0, 0), tip = c(0, 0, 1), radius = 0.5)
```

## Customization

```r
# Axes
axes3d()
axis3d("x", at = seq(0, 10, 2))
box3d()

# Labels
title3d(main = "3D Plot", xlab = "X", ylab = "Y", zlab = "Z")

# Background
bg3d(color = "white")

# Bounding box
bbox3d()
```

## Colors and Materials

```r
# Color by value
plot3d(x, y, z, col = rainbow(length(x)))

# Color gradient
cols <- colorRampPalette(c("blue", "red"))(100)
plot3d(x, y, z, col = cols[cut(z, 100)])

# Material properties
material3d(col = "red", alpha = 0.5, shininess = 50)
```

## Animation

```r
# Spin animation
play3d(spin3d(axis = c(0, 0, 1), rpm = 10), duration = 10)

# Custom animation
for (i in 1:360) {
  view3d(theta = i, phi = 30)
  Sys.sleep(0.01)
}

# Save animation
movie3d(spin3d(), duration = 5, dir = ".", movie = "animation")
```

## Interactivity

```r
# Rotate with mouse (default)
# Zoom with scroll wheel

# Identify points
identify3d(x, y, z)

# Select region
select3d()
```

## Multiple Objects

```r
# Open new scene
open3d()

# Add objects
plot3d(x1, y1, z1, col = "red")
points3d(x2, y2, z2, col = "blue", add = TRUE)

# Clear scene
clear3d()

# Close
close3d()
```

## Saving

```r
# Snapshot
snapshot3d("plot.png")

# WebGL (interactive HTML)
writeWebGL(dir = "webgl", filename = "plot.html")

# Save scene
scene <- scene3d()
save(scene, file = "scene.rda")

# Restore
load("scene.rda")
plot3d(scene)
```

## View Control

```r
# Set view angle
view3d(theta = 45, phi = 30, zoom = 0.8)

# Get current view
par3d("userMatrix")

# Reset view
view3d(0, 0)
```

## With ggplot2

```r
# Using plotly for 3D ggplot-style
library(plotly)
plot_ly(df, x = ~x, y = ~y, z = ~z, type = "scatter3d", mode = "markers")
```

## Mesh Objects

```r
# Create mesh
mesh <- mesh3d(
  vertices = rbind(x, y, z, 1),
  triangles = matrix(indices, nrow = 3)
)

# Plot mesh
shade3d(mesh, col = "blue")
wire3d(mesh)
```
