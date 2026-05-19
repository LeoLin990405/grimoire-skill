---
name: sf
description: R sf package for simple features. Use for vector spatial data - points, lines, polygons, and geometric operations.
---

# sf

Simple Features for R.

## Read/Write

```r
library(sf)

# Read
shp <- st_read("file.shp")
geojson <- st_read("file.geojson")
gpkg <- st_read("file.gpkg")
gpkg <- st_read("file.gpkg", layer = "layer_name")

# Write
st_write(shp, "output.shp")
st_write(shp, "output.geojson")
st_write(shp, "output.gpkg")
st_write(shp, "output.gpkg", layer = "layer_name", append = TRUE)
```

## Create Geometries

```r
# Point
pt <- st_point(c(0, 0))
pt <- st_point(c(0, 0, 100))  # With Z

# Multipoint
mpt <- st_multipoint(matrix(c(0,0, 1,1, 2,2), ncol = 2, byrow = TRUE))

# Linestring
line <- st_linestring(matrix(c(0,0, 1,1, 2,0), ncol = 2, byrow = TRUE))

# Polygon
poly <- st_polygon(list(
  matrix(c(0,0, 1,0, 1,1, 0,1, 0,0), ncol = 2, byrow = TRUE)
))

# Polygon with hole
poly <- st_polygon(list(
  matrix(c(0,0, 10,0, 10,10, 0,10, 0,0), ncol = 2, byrow = TRUE),
  matrix(c(2,2, 8,2, 8,8, 2,8, 2,2), ncol = 2, byrow = TRUE)
))

# Create sf object
geom <- st_sfc(pt1, pt2, pt3, crs = 4326)
sf_obj <- st_sf(data.frame(id = 1:3, name = c("A", "B", "C")), geometry = geom)

# From data frame
sf_obj <- st_as_sf(df, coords = c("lon", "lat"), crs = 4326)
```

## CRS Operations

```r
# Get CRS
st_crs(shp)

# Set CRS
st_set_crs(shp, 4326)

# Transform CRS
shp_transformed <- st_transform(shp, 3857)
shp_transformed <- st_transform(shp, "EPSG:3857")
```

## Geometric Operations

```r
# Measurements
st_area(polygons)
st_length(lines)
st_distance(a, b)
st_distance(a, b, by_element = TRUE)

# Predicates
st_intersects(a, b)
st_contains(a, b)
st_within(a, b)
st_touches(a, b)
st_crosses(a, b)
st_overlaps(a, b)
st_disjoint(a, b)
st_equals(a, b)

# Binary operations
st_intersection(a, b)
st_union(a, b)
st_difference(a, b)
st_sym_difference(a, b)

# Unary operations
st_buffer(shp, dist = 100)
st_centroid(shp)
st_convex_hull(shp)
st_simplify(shp, dTolerance = 100)
st_boundary(shp)
st_make_valid(shp)

# Combine
st_union(shp)  # Dissolve all
st_combine(shp)  # Combine without dissolving
```

## Spatial Joins

```r
# Join
st_join(points, polygons)
st_join(points, polygons, join = st_within)

# Filter
st_filter(points, polygon)
st_filter(points, polygon, .predicate = st_within)

# Crop
st_crop(shp, bbox)
st_crop(shp, c(xmin = 0, ymin = 0, xmax = 10, ymax = 10))
```

## Attributes

```r
# Get geometry
st_geometry(shp)

# Drop geometry
st_drop_geometry(shp)

# Set geometry
st_set_geometry(df, geom)

# Bounding box
st_bbox(shp)

# Coordinates
st_coordinates(shp)
```

## Plotting

```r
# Base plot
plot(shp)
plot(shp["column"])
plot(st_geometry(shp))

# ggplot2
library(ggplot2)
ggplot(shp) +
  geom_sf(aes(fill = value)) +
  coord_sf()
```
