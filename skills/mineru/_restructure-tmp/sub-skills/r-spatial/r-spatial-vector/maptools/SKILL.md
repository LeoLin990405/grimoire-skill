---
name: maptools
description: R maptools package for spatial data tools. Use for reading/writing spatial data (deprecated, use sf).
---

# maptools

Tools for handling spatial objects (deprecated - use sf).

## Note

maptools was retired in October 2023. Use sf instead.

## Migration to sf

```r
# Old maptools way
library(maptools)
shp <- readShapePoly("data.shp")
writePolyShape(shp, "output.shp")

# New sf way
library(sf)
shp <- st_read("data.shp")
st_write(shp, "output.shp")
```

## Reading Shapefiles

```r
# Old way
readShapePoly("polygons.shp")
readShapeLines("lines.shp")
readShapePoints("points.shp")

# New sf way (all types)
st_read("data.shp")
```

## Coordinate Operations

```r
# Old way
coordinates(sp_obj)
bbox(sp_obj)

# New sf way
st_coordinates(sf_obj)
st_bbox(sf_obj)
```

## Conversion

```r
# Old way (sp to data.frame)
as.data.frame(sp_obj)

# New sf way
as.data.frame(sf_obj)
st_drop_geometry(sf_obj)
```

## Point in Polygon

```r
# Old way
over(points, polygons)

# New sf way
st_join(points, polygons)
st_intersection(points, polygons)
```
