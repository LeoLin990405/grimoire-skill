---
name: tmap
description: R tmap package for thematic maps. Use for publication-quality static and interactive maps.
---

# tmap Package

Thematic maps with grammar of graphics style.

## Basic Map

```r
library(tmap)
library(sf)

tm_shape(shp) +
  tm_polygons("value")
```

## Map Layers

```r
# Polygons
tm_shape(polygons) +
  tm_polygons("variable",
    style = "quantile",
    palette = "Blues",
    title = "Legend Title"
  )

# Points
tm_shape(points) +
  tm_dots(size = "population", col = "red")

tm_shape(points) +
  tm_bubbles(size = "value", col = "category")

# Lines
tm_shape(roads) +
  tm_lines(col = "type", lwd = 2)

# Raster
tm_shape(raster) +
  tm_raster(palette = "viridis")
```

## Multiple Layers

```r
tm_shape(polygons) +
  tm_polygons("value") +
tm_shape(points) +
  tm_dots(col = "red") +
tm_shape(roads) +
  tm_lines()
```

## Layout

```r
tm_shape(shp) +
  tm_polygons("value") +
  tm_layout(
    title = "Map Title",
    legend.outside = TRUE,
    frame = FALSE
  ) +
  tm_compass(position = c("right", "top")) +
  tm_scale_bar(position = c("left", "bottom")) +
  tm_credits("Source: Data Provider")
```

## Facets

```r
tm_shape(shp) +
  tm_polygons("value") +
  tm_facets(by = "year", ncol = 3)
```

## Interactive Mode

```r
tmap_mode("view")  # Interactive
tmap_mode("plot")  # Static

# Current map interactive
tmap_last() %>% tmap_leaflet()
```

## Save

```r
map <- tm_shape(shp) + tm_polygons()
tmap_save(map, "map.png", width = 1920, height = 1080)
tmap_save(map, "map.html")
```
