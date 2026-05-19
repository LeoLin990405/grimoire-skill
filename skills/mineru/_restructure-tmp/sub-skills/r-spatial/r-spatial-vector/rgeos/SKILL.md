---
name: rgeos
description: R rgeos package for geometry operations. Use for geometric operations on spatial data (deprecated, use sf).
---

# rgeos

Interface to GEOS (deprecated - use sf).

## Note

rgeos was retired in October 2023. Use sf instead.

## Migration to sf

```r
# Old rgeos way
library(rgeos)
gBuffer(sp_obj, width = 100)
gIntersection(sp1, sp2)
gUnion(sp1, sp2)
gDifference(sp1, sp2)
gArea(sp_obj)
gLength(sp_obj)
gCentroid(sp_obj)
gContains(sp1, sp2)
gIntersects(sp1, sp2)

# New sf way
library(sf)
st_buffer(sf_obj, dist = 100)
st_intersection(sf1, sf2)
st_union(sf1, sf2)
st_difference(sf1, sf2)
st_area(sf_obj)
st_length(sf_obj)
st_centroid(sf_obj)
st_contains(sf1, sf2)
st_intersects(sf1, sf2)
```

## Common Operations

```r
# Buffer
st_buffer(sf_obj, dist = 1000)

# Simplify
st_simplify(sf_obj, dTolerance = 100)

# Convex hull
st_convex_hull(sf_obj)

# Voronoi
st_voronoi(sf_obj)

# Nearest points
st_nearest_points(sf1, sf2)
```

## Predicates

```r
# Spatial predicates in sf
st_intersects(sf1, sf2)
st_disjoint(sf1, sf2)
st_touches(sf1, sf2)
st_crosses(sf1, sf2)
st_within(sf1, sf2)
st_contains(sf1, sf2)
st_overlaps(sf1, sf2)
st_equals(sf1, sf2)
st_covers(sf1, sf2)
st_covered_by(sf1, sf2)
```
