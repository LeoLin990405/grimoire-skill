---
name: terra
description: R terra package for spatial data. Use for raster and vector data analysis, successor to raster package.
---

# terra Package

Spatial data analysis (raster and vector).

## Raster Data

```r
library(terra)

# Read raster
r <- rast("file.tif")

# Create raster
r <- rast(nrows = 100, ncols = 100, xmin = 0, xmax = 10, ymin = 0, ymax = 10)
values(r) <- runif(ncell(r))

# Multi-layer
r <- rast(c("band1.tif", "band2.tif", "band3.tif"))
```

## Raster Operations

```r
# Basic info
dim(r)
res(r)
ext(r)
crs(r)

# Algebra
r2 <- r * 2
r3 <- r + r2
r4 <- sqrt(r)

# Aggregate/Disaggregate
r_agg <- aggregate(r, fact = 2, fun = mean)
r_dis <- disagg(r, fact = 2)

# Resample
r_resamp <- resample(r, template_raster)

# Crop/Mask
r_crop <- crop(r, extent)
r_mask <- mask(r, polygon)
```

## Vector Data

```r
# Read vector
v <- vect("file.shp")
v <- vect("file.gpkg")

# Create from coordinates
pts <- vect(cbind(x, y), crs = "EPSG:4326")

# From sf
v <- vect(sf_object)
sf_obj <- st_as_sf(v)
```

## Vector Operations

```r
# Buffer
v_buf <- buffer(v, width = 1000)

# Intersect
v_int <- intersect(v1, v2)

# Union
v_union <- union(v1, v2)

# Extract raster values
vals <- extract(r, v)
```

## Write

```r
writeRaster(r, "output.tif")
writeVector(v, "output.shp")
```

## Plot

```r
plot(r)
plot(v, add = TRUE)
```
