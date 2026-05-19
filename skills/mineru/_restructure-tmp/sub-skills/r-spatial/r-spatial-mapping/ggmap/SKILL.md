---
name: ggmap
description: R ggmap package for maps with ggplot2. Use for Google Maps and Stamen tiles with ggplot2.
---

# ggmap Package

ggplot2-style maps with tile backgrounds.

## Get Map Tiles

```r
library(ggmap)

# Stamen maps (no API key needed)
map <- get_stadiamap(
  bbox = c(left = -122.5, bottom = 37.5, right = -122, top = 38),
  zoom = 12,
  maptype = "stamen_toner_lite"
)

# Google Maps (requires API key)
register_google(key = "YOUR_API_KEY")
map <- get_googlemap(
  center = c(lon = -122.4, lat = 37.8),
  zoom = 12,
  maptype = "roadmap"
)
```

## Plot Map

```r
ggmap(map)

# With points
ggmap(map) +
  geom_point(data = df, aes(x = lon, y = lat), color = "red", size = 3)
```

## Add Layers

```r
ggmap(map) +
  geom_point(data = df, aes(x = lon, y = lat, color = category)) +
  geom_path(data = route, aes(x = lon, y = lat)) +
  scale_color_viridis_d()
```

## Density Maps

```r
ggmap(map) +
  stat_density_2d(
    data = df,
    aes(x = lon, y = lat, fill = after_stat(level)),
    geom = "polygon",
    alpha = 0.3
  ) +
  scale_fill_viridis_c()
```

## Geocoding

```r
# Google geocoding (requires API)
geocode("1600 Pennsylvania Ave, Washington DC")

# Reverse geocoding
revgeocode(c(-77.0365, 38.8977))
```

## Routes

```r
# Google directions (requires API)
route <- route(
  from = "San Francisco, CA",
  to = "Los Angeles, CA",
  mode = "driving"
)

ggmap(map) +
  geom_path(data = route, aes(x = lon, y = lat), color = "blue", size = 2)
```

## Map Types

```r
# Stadia/Stamen types
"stamen_toner"
"stamen_toner_lite"
"stamen_watercolor"
"stamen_terrain"

# Google types
"roadmap"
"satellite"
"terrain"
"hybrid"
```
