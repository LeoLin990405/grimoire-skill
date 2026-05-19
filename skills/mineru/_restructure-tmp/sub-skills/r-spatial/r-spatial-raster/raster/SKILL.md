---
name: raster
description: R raster package for raster data. Use for reading, writing, and analyzing raster/gridded data.
---

# raster

Geographic data analysis and modeling.

## Note

Consider using terra for new projects (faster, modern replacement).

## Reading/Writing

```r
library(raster)

# Read raster
r <- raster("file.tif")

# Read multi-band
s <- stack("multiband.tif")
b <- brick("multiband.tif")

# Write
writeRaster(r, "output.tif")
writeRaster(r, "output.tif", format = "GTiff")
```

## Create Raster

```r
# Empty raster
r <- raster(nrows = 100, ncols = 100,
  xmn = 0, xmx = 100, ymn = 0, ymx = 100)

# From matrix
r <- raster(matrix(1:100, 10, 10))

# Set values
values(r) <- runif(ncell(r))
```

## Properties

```r
# Dimensions
nrow(r)
ncol(r)
ncell(r)
res(r)

# Extent
extent(r)
xmin(r); xmax(r); ymin(r); ymax(r)

# CRS
crs(r)
projection(r)
```

## Operations

```r
# Arithmetic
r2 <- r * 2
r3 <- r + r2
r4 <- sqrt(r)
r5 <- log(r)

# Cell statistics
cellStats(r, stat = "mean")
cellStats(r, stat = "sum")

# Focal operations
focal(r, w = matrix(1, 3, 3), fun = mean)
```

## Extract Values

```r
# By coordinates
extract(r, cbind(x, y))

# By spatial object
extract(r, points)
extract(r, polygons, fun = mean)

# Get all values
values(r)
getValues(r)
```

## Crop and Mask

```r
# Crop to extent
r_crop <- crop(r, extent_obj)

# Mask by polygon
r_mask <- mask(r, polygon)

# Both
r_clip <- crop(r, polygon)
r_clip <- mask(r_clip, polygon)
```

## Reproject

```r
# Project raster
r_proj <- projectRaster(r, crs = "+proj=utm +zone=10")

# Resample
r_resamp <- resample(r, template_raster)
```

## Stack Operations

```r
# Create stack
s <- stack(r1, r2, r3)

# Stack statistics
mean(s)
sum(s)
calc(s, fun = mean)

# Apply function
overlay(r1, r2, fun = function(x, y) x + y)
```

## Migration to terra

```r
# raster -> terra equivalents
# raster() -> rast()
# stack() -> rast()
# brick() -> rast()
# extent() -> ext()
# crs() -> crs()
# projectRaster() -> project()
```
