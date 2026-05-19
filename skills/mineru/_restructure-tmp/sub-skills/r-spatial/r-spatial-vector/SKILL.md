---
name: r-spatial-vector
description: R vector spatial data with sf, sp, terra. Use for points, lines, polygons, and geometric operations.
---

# R Vector Spatial Data

Points, lines, and polygons.

## sf (Simple Features)

```r
library(sf)

# Read/write
shp <- st_read("file.shp")
geojson <- st_read("file.geojson")
st_write(shp, "output.gpkg")

# Create geometries
pt <- st_point(c(0, 0))
line <- st_linestring(matrix(c(0,0, 1,1, 2,0), ncol = 2, byrow = TRUE))
poly <- st_polygon(list(matrix(c(0,0, 1,0, 1,1, 0,1, 0,0), ncol = 2, byrow = TRUE)))

# Create sf object
df <- data.frame(id = 1:3, name = c("A", "B", "C"))
geom <- st_sfc(pt1, pt2, pt3, crs = 4326)
sf_obj <- st_sf(df, geometry = geom)

# CRS operations
st_crs(shp)
st_transform(shp, 4326)
st_set_crs(shp, 4326)

# Geometric operations
st_buffer(shp, dist = 100)
st_intersection(shp1, shp2)
st_union(shp)
st_difference(shp1, shp2)
st_centroid(shp)
st_area(shp)
st_length(lines)
st_distance(shp1, shp2)

# Spatial predicates
st_intersects(shp1, shp2)
st_contains(shp1, shp2)
st_within(shp1, shp2)
st_touches(shp1, shp2)

# Spatial joins
st_join(points, polygons)
st_filter(points, polygon)
```

## terra (Vectors)

```r
library(terra)

# Read/write
v <- vect("file.shp")
writeVector(v, "output.gpkg")

# Create
pts <- vect(cbind(x, y), crs = "EPSG:4326")

# Operations
buffer(v, width = 100)
intersect(v1, v2)
union(v1, v2)
aggregate(v, by = "field")
```
