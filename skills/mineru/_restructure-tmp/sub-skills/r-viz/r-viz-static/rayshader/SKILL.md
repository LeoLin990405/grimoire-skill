---
name: rayshader
description: R rayshader package for 2D and 3D data visualization. Use for creating 3D maps, elevation plots, and ray-traced visualizations.
---

# rayshader

2D and 3D data visualizations via rgl.

## Elevation Maps

```r
library(rayshader)

# Create elevation matrix
elev_matrix <- matrix(runif(100*100), nrow = 100)

# Basic 3D plot
elev_matrix %>%
  sphere_shade() %>%
  plot_3d(elev_matrix)

# With water
elev_matrix %>%
  sphere_shade() %>%
  add_water(detect_water(elev_matrix)) %>%
  plot_3d(elev_matrix)
```

## Shading

```r
# Sphere shading (default)
elev_matrix %>%
  sphere_shade(texture = "desert")

# Available textures
# "desert", "imhof1", "imhof2", "imhof3", "imhof4", "bw", "unicorn"

# Custom texture
elev_matrix %>%
  sphere_shade(texture = create_texture(
    "#1B4F72", "#2874A6", "#85C1E9", "#F7DC6F", "#F39C12"
  ))

# Ambient shading
elev_matrix %>%
  sphere_shade() %>%
  add_shadow(ambient_shade(elev_matrix), 0.5)

# Ray shading
elev_matrix %>%
  sphere_shade() %>%
  add_shadow(ray_shade(elev_matrix, sunangle = 315), 0.5)

# Lamb shading
elev_matrix %>%
  sphere_shade() %>%
  add_shadow(lamb_shade(elev_matrix), 0.5)
```

## 3D Plotting

```r
# Basic 3D
elev_matrix %>%
  sphere_shade() %>%
  plot_3d(elev_matrix,
    zscale = 10,           # Vertical exaggeration
    windowsize = c(800, 600),
    zoom = 0.7,
    phi = 45,              # Azimuth angle
    theta = 45             # Rotation angle
  )

# Add labels
render_label(elev_matrix,
  x = 50, y = 50, z = 1000,
  text = "Peak",
  textsize = 2
)

# Render snapshot
render_snapshot("map_3d.png")

# High quality render
render_highquality("map_hq.png",
  samples = 256,
  lightdirection = 315
)
```

## ggplot2 to 3D

```r
library(ggplot2)

# Create ggplot
p <- ggplot(df, aes(x, y, fill = value)) +
  geom_tile() +
  scale_fill_viridis_c()

# Convert to 3D
plot_gg(p,
  width = 5,
  height = 5,
  scale = 250,
  multicore = TRUE,
  windowsize = c(800, 800)
)

render_snapshot("ggplot_3d.png")
```

## Overlays

```r
# Add overlay image
elev_matrix %>%
  sphere_shade() %>%
  add_overlay(overlay_img, alphalayer = 0.7) %>%
  plot_3d(elev_matrix)

# Add water
elev_matrix %>%
  sphere_shade() %>%
  add_water(detect_water(elev_matrix, min_area = 1000),
    color = "lightblue") %>%
  plot_3d(elev_matrix)
```

## Camera Control

```r
# Set camera position
render_camera(
  theta = 45,
  phi = 30,
  zoom = 0.8,
  fov = 70
)

# Orbit animation
render_movie("orbit.mp4",
  frames = 360,
  fps = 30,
  phi = 30,
  theta = seq(0, 360, length.out = 360)
)
```

## Depth of Field

```r
render_depth(
  focus = 0.5,
  focallength = 200,
  filename = "depth.png"
)
```

## Real Elevation Data

```r
library(elevatr)

# Get elevation data
elev <- get_elev_raster(locations, z = 10)
elev_matrix <- raster_to_matrix(elev)

# Plot
elev_matrix %>%
  sphere_shade(texture = "imhof1") %>%
  add_shadow(ray_shade(elev_matrix), 0.5) %>%
  plot_3d(elev_matrix, zscale = 10)
```

## 2D Hillshade

```r
# 2D hillshade map
elev_matrix %>%
  sphere_shade() %>%
  add_shadow(ray_shade(elev_matrix), 0.5) %>%
  plot_map()

# Save 2D
elev_matrix %>%
  sphere_shade() %>%
  save_png("hillshade.png")
```
