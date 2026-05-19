---
name: leaflet
description: R leaflet package for interactive maps. Use for creating web maps with markers, polygons, tiles, and layers.
---

# leaflet

Interactive web maps.

## Basic Map

```r
library(leaflet)

leaflet() %>%
  addTiles() %>%
  setView(lng = -73.9, lat = 40.7, zoom = 10)
```

## Markers

```r
# Single marker
leaflet() %>%
  addTiles() %>%
  addMarkers(lng = -73.9, lat = 40.7, popup = "NYC")

# From data
leaflet(df) %>%
  addTiles() %>%
  addMarkers(~lng, ~lat, popup = ~name)

# Circle markers
leaflet(df) %>%
  addTiles() %>%
  addCircleMarkers(
    ~lng, ~lat,
    radius = 5,
    color = "red",
    fillOpacity = 0.8,
    popup = ~name
  )

# Clustered markers
leaflet(df) %>%
  addTiles() %>%
  addMarkers(~lng, ~lat, clusterOptions = markerClusterOptions())

# Custom icons
icons <- makeIcon(iconUrl = "marker.png", iconWidth = 25, iconHeight = 41)
leaflet(df) %>%
  addTiles() %>%
  addMarkers(~lng, ~lat, icon = icons)
```

## Shapes

```r
# Circles
leaflet() %>%
  addTiles() %>%
  addCircles(lng = -73.9, lat = 40.7, radius = 500)

# Polygons (from sf)
leaflet(sf_data) %>%
  addTiles() %>%
  addPolygons(
    fillColor = ~colorQuantile("YlOrRd", value)(value),
    weight = 1,
    opacity = 1,
    color = "white",
    fillOpacity = 0.7,
    popup = ~name
  )

# Polylines
leaflet() %>%
  addTiles() %>%
  addPolylines(lng = c(-73.9, -74.0), lat = c(40.7, 40.8))

# Rectangles
leaflet() %>%
  addTiles() %>%
  addRectangles(lng1 = -74, lat1 = 40.6, lng2 = -73.8, lat2 = 40.8)
```

## Tile Providers

```r
# Default OpenStreetMap
addTiles()

# Provider tiles
addProviderTiles(providers$CartoDB.Positron)
addProviderTiles(providers$Stamen.Toner)
addProviderTiles(providers$Esri.WorldImagery)
addProviderTiles(providers$OpenTopoMap)

# Multiple layers
leaflet() %>%
  addTiles(group = "OSM") %>%
  addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>%
  addLayersControl(baseGroups = c("OSM", "Satellite"))
```

## Legends and Controls

```r
# Legend
pal <- colorQuantile("YlOrRd", df$value)
leaflet(df) %>%
  addTiles() %>%
  addPolygons(fillColor = ~pal(value)) %>%
  addLegend(pal = pal, values = ~value, title = "Value")

# Layer control
leaflet() %>%
  addTiles() %>%
  addMarkers(data = df1, group = "Group 1") %>%
  addMarkers(data = df2, group = "Group 2") %>%
  addLayersControl(overlayGroups = c("Group 1", "Group 2"))

# Scale bar
addScaleBar(position = "bottomleft")

# Mini map
addMiniMap()
```

## Popups and Labels

```r
# Popup
addMarkers(popup = ~paste("<b>", name, "</b><br>", value))

# Label (on hover)
addMarkers(label = ~name)
addMarkers(label = ~name, labelOptions = labelOptions(noHide = TRUE))
```

## Save

```r
m <- leaflet() %>% addTiles()
htmlwidgets::saveWidget(m, "map.html")
```
