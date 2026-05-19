---
name: sp
description: R sp package for spatial data. Use for spatial data classes and methods (legacy, see sf for modern approach).
---

# sp

Classes and methods for spatial data.

## Spatial Points

```r
library(sp)

# Create SpatialPoints
coords <- cbind(x = c(1, 2, 3), y = c(4, 5, 6))
sp_points <- SpatialPoints(coords)

# With CRS
sp_points <- SpatialPoints(coords, proj4string = CRS("+proj=longlat +datum=WGS84"))

# With data
df <- data.frame(id = 1:3, value = c(10, 20, 30))
spdf <- SpatialPointsDataFrame(coords, df)
```

## Spatial Lines

```r
# Create Line
line1 <- Line(cbind(c(1, 2, 3), c(1, 2, 1)))
line2 <- Line(cbind(c(4, 5, 6), c(4, 5, 4)))

# Create Lines (collection)
lines1 <- Lines(list(line1), ID = "a")
lines2 <- Lines(list(line2), ID = "b")

# Create SpatialLines
sp_lines <- SpatialLines(list(lines1, lines2))

# With data
df <- data.frame(id = c("a", "b"), length = c(10, 15))
sldf <- SpatialLinesDataFrame(sp_lines, df, match.ID = "id")
```

## Spatial Polygons

```r
# Create Polygon
poly1 <- Polygon(cbind(c(0, 1, 1, 0, 0), c(0, 0, 1, 1, 0)))
poly2 <- Polygon(cbind(c(2, 3, 3, 2, 2), c(0, 0, 1, 1, 0)))

# Create Polygons
polys1 <- Polygons(list(poly1), ID = "a")
polys2 <- Polygons(list(poly2), ID = "b")

# Create SpatialPolygons
sp_polys <- SpatialPolygons(list(polys1, polys2))

# With data
df <- data.frame(id = c("a", "b"), area = c(1, 1))
spdf <- SpatialPolygonsDataFrame(sp_polys, df, match.ID = "id")
```

## Coordinate Reference Systems

```r
# Set CRS
proj4string(sp_obj) <- CRS("+proj=longlat +datum=WGS84")

# Get CRS
proj4string(sp_obj)

# Transform CRS
sp_transformed <- spTransform(sp_obj, CRS("+proj=utm +zone=10 +datum=WGS84"))

# Common CRS strings
# WGS84: "+proj=longlat +datum=WGS84"
# UTM: "+proj=utm +zone=10 +datum=WGS84"
# Web Mercator: "+proj=merc +a=6378137 +b=6378137"
```

## Subsetting

```r
# By index
sp_obj[1:5, ]

# By attribute
sp_obj[sp_obj$value > 10, ]

# Access data
sp_obj@data
sp_obj$column_name
```

## Spatial Operations

```r
# Bounding box
bbox(sp_obj)

# Coordinates
coordinates(sp_obj)

# Area (polygons)
library(rgeos)
gArea(sp_polys)

# Length (lines)
gLength(sp_lines)

# Centroid
gCentroid(sp_polys)
```

## Overlay Operations

```r
library(rgeos)

# Intersection
gIntersection(sp1, sp2)

# Union
gUnion(sp1, sp2)

# Difference
gDifference(sp1, sp2)

# Buffer
gBuffer(sp_obj, width = 100)

# Contains
gContains(sp1, sp2)

# Intersects
gIntersects(sp1, sp2)
```

## Reading/Writing

```r
library(rgdal)

# Read shapefile
sp_obj <- readOGR(dsn = "path/to/folder", layer = "filename")

# Write shapefile
writeOGR(sp_obj, dsn = "output", layer = "name", driver = "ESRI Shapefile")

# Read from GeoJSON
sp_obj <- readOGR("file.geojson")
```

## Plotting

```r
# Basic plot
plot(sp_obj)

# With colors
plot(sp_obj, col = sp_obj$value)

# Add points to existing plot
plot(sp_polys)
points(sp_points, col = "red", pch = 16)

# spplot (lattice-based)
spplot(spdf, "value")
```

## Convert to sf

```r
library(sf)

# sp to sf
sf_obj <- st_as_sf(sp_obj)

# sf to sp
sp_obj <- as(sf_obj, "Spatial")
```

## Grid Data

```r
# Create grid
grd <- GridTopology(c(0, 0), c(1, 1), c(10, 10))
sp_grid <- SpatialGrid(grd)

# Pixels
sp_pixels <- SpatialPixels(SpatialPoints(coordinates(sp_grid)))

# With data
spgdf <- SpatialGridDataFrame(grd, data.frame(value = 1:100))
```
