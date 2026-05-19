---
name: mapview
description: R mapview package for quick interactive maps. Use for rapid spatial data exploration.
---

# mapview Package

Quick interactive maps for spatial data exploration.

## Basic Usage

```r
library(mapview)
library(sf)

# Quick view
mapview(shp)

# With column
mapview(shp, zcol = "value")
```

## Customization

```r
mapview(shp,
  zcol = "value",
  col.regions = viridisLite::viridis,
  alpha.regions = 0.8,
  layer.name = "My Layer",
  legend = TRUE
)
```

## Multiple Layers

```r
# Add layers with +
mapview(polygons) + mapview(points)

# Or combine
m1 <- mapview(polygons, col.regions = "blue")
m2 <- mapview(points, col.regions = "red")
m1 + m2
```

## Different Data Types

```r
# sf objects
mapview(sf_object)

# Raster
library(terra)
mapview(raster_object)

# sp objects
mapview(sp_object)
```

## Options

```r
# Global options
mapviewOptions(
  basemaps = c("OpenStreetMap", "Esri.WorldImagery"),
  layers.control.pos = "topright"
)

# Reset
mapviewOptions(default = TRUE)
```

## Basemaps

```r
mapview(shp, map.types = c(
  "OpenStreetMap",
  "Esri.WorldImagery",
  "CartoDB.Positron"
))
```

## Popups

```r
mapview(shp,
  popup = popupTable(shp, zcol = c("name", "value"))
)
```

## Save

```r
m <- mapview(shp)
mapshot(m, file = "map.html")
mapshot(m, file = "map.png")
```

## Sync Maps

```r
# Side by side
sync(m1, m2)

# Lattice view
latticeView(m1, m2)
```
