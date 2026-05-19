---
name: r-spatial
description: R spatial analysis packages. Use for geographic data, maps, GIS operations, and spatial statistics.
---

# R Spatial Analysis Skill

## Sub-skills

| Sub-skill | Description |
|-----------|-------------|
| [r-spatial-vector](r-spatial-vector/SKILL.md) | sf, sp, terra vectors, geometric operations |
| [r-spatial-raster](r-spatial-raster/SKILL.md) | terra, raster, stars, gridded data |
| [r-spatial-mapping](r-spatial-mapping/SKILL.md) | tmap, leaflet, mapview, ggplot2+sf |

Geographic and spatial data analysis in R.

## Core Spatial Packages

| Package | Description |
|---------|-------------|
| **sf** ★ | Simple Features for R (modern) |
| **terra** ★ | Spatial data analysis (raster/vector) |
| **sp** | Classes for spatial data (legacy) |
| **rgdal** | Geospatial Data Abstraction Library |
| **rgeos** | Geometry Engine - Open Source |

## Mapping & Visualization

| Package | Description |
|---------|-------------|
| **leaflet** ★ | Interactive maps |
| **tmap** ★ | Thematic maps |
| **ggmap** | Maps with ggplot2 |
| **maptools** | Spatial object tools |
| **RColorBrewer** | Color schemes for maps |
| **REmap** | ECharts maps |

## Spatial Statistics

| Package | Description |
|---------|-------------|
| **spatstat** | Spatial point pattern analysis |
| **gstat** | Geostatistical modeling |
| **spdep** | Spatial dependence |
| **GWmodel** | Geographically-weighted models |

## Spatio-temporal

| Package | Description |
|---------|-------------|
| **spacetime** | Spatio-temporal data |

## Data Sources

| Package | Description |
|---------|-------------|
| **tigris** | US Census TIGER shapefiles |
| **rnaturalearth** | Natural Earth map data |
| **osmdata** | OpenStreetMap data |

## Quick Examples

```r
# sf basics
library(sf)

# Read shapefile
shp <- st_read("data.shp")

# Read GeoJSON
geo <- st_read("data.geojson")

# Create from coordinates
points <- st_as_sf(df, coords = c("lon", "lat"), crs = 4326)

# Coordinate reference systems
st_crs(shp)
shp_transformed <- st_transform(shp, crs = 3857)

# Spatial operations
st_intersection(a, b)
st_union(a, b)
st_buffer(points, dist = 1000)
st_area(polygons)
st_distance(a, b)

# Spatial joins
st_join(points, polygons)

# Interactive map with leaflet
library(leaflet)
leaflet(shp) %>%
  addTiles() %>%
  addPolygons(
    fillColor = ~colorQuantile("YlOrRd", value)(value),
    weight = 1,
    popup = ~name
  )

# Static map with tmap
library(tmap)
tm_shape(shp) +
  tm_polygons("value",
    style = "quantile",
    palette = "Blues",
    title = "Value"
  ) +
  tm_layout(title = "Map Title")

# ggplot2 + sf
library(ggplot2)
ggplot(shp) +
  geom_sf(aes(fill = value)) +
  scale_fill_viridis_c() +
  theme_minimal()

# Spatial statistics
library(spdep)
# Create neighbors
nb <- poly2nb(shp)
# Spatial weights
lw <- nb2listw(nb)
# Moran's I
moran.test(shp$value, lw)

# Geostatistics
library(gstat)
# Variogram
v <- variogram(value ~ 1, data = points)
plot(v)
# Kriging
v.fit <- fit.variogram(v, vgm("Sph"))
kriged <- krige(value ~ 1, points, grid, v.fit)
```

## Common Workflows

### Choropleth Map
```r
library(sf)
library(tmap)

# Load data
shp <- st_read("boundaries.shp")
data <- read.csv("data.csv")

# Join
shp <- merge(shp, data, by = "id")

# Map
tmap_mode("view")  # Interactive
tm_shape(shp) +
  tm_polygons("value",
    style = "jenks",
    palette = "RdYlBu",
    title = "Value"
  ) +
  tm_borders() +
  tm_layout(legend.outside = TRUE)
```

### Point Pattern Analysis
```r
library(sf)
library(spatstat)

# Convert to ppp
window <- as.owin(boundary)
ppp_obj <- as.ppp(st_coordinates(points), W = window)

# Density
density_map <- density(ppp_obj)
plot(density_map)

# K-function
K <- Kest(ppp_obj)
plot(K)
```

## Resources

- sf: https://r-spatial.github.io/sf/
- terra: https://rspatial.org/
- tmap: https://r-tmap.github.io/tmap/
- leaflet: https://rstudio.github.io/leaflet/
- Geocomputation with R: https://geocompr.robinlovelace.net/
