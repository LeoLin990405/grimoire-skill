---
name: r-spatial-mapping
description: R mapping with tmap, leaflet, mapview. Use for static and interactive maps.
---

# R Mapping

Static and interactive maps.

## tmap

```r
library(tmap)

# Mode
tmap_mode("plot")  # Static
tmap_mode("view")  # Interactive

# Basic map
tm_shape(shp) +
  tm_polygons("variable", palette = "Blues") +
  tm_borders()

# Points
tm_shape(points) +
  tm_dots(col = "value", size = 0.5)

# Lines
tm_shape(roads) +
  tm_lines(col = "type", lwd = 2)

# Complete map
tm_shape(polygons) +
  tm_fill("pop", style = "quantile", palette = "YlOrRd") +
  tm_borders(alpha = 0.5) +
tm_shape(points) +
  tm_symbols(col = "red", size = 0.3) +
tm_layout(
  title = "Map Title",
  legend.position = c("left", "bottom")
) +
tm_compass(position = c("right", "top")) +
tm_scale_bar()

# Save
tmap_save(map, "map.png", width = 10, height = 8)
```

## leaflet

```r
library(leaflet)

# Basic
leaflet() %>%
  addTiles() %>%
  addMarkers(lng = -73.9, lat = 40.7, popup = "NYC")

# With sf
leaflet(shp) %>%
  addTiles() %>%
  addPolygons(
    fillColor = ~colorQuantile("YlOrRd", pop)(pop),
    weight = 1,
    popup = ~name
  )

# Layers
leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addCircleMarkers(data = points, radius = 5) %>%
  addPolylines(data = lines, color = "blue") %>%
  addLegend(pal = pal, values = ~value)
```

## mapview

```r
library(mapview)

# Quick view
mapview(shp)
mapview(shp, zcol = "variable")

# Multiple layers
mapview(polygons) + mapview(points, col.regions = "red")

# Options
mapview(shp,
  zcol = "pop",
  layer.name = "Population",
  alpha.regions = 0.7
)
```

## ggplot2 + sf

```r
library(ggplot2)

ggplot(shp) +
  geom_sf(aes(fill = variable)) +
  scale_fill_viridis_c() +
  coord_sf(crs = 4326) +
  theme_minimal()
```
