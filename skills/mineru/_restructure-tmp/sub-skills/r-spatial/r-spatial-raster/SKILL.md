---
name: r-spatial-raster
description: R raster spatial data with terra, raster, stars. Use for gridded data, satellite imagery, and raster analysis.
---

# R Raster Spatial Data

Gridded and imagery data.

## terra

```r
library(terra)

# Read/write
r <- rast("file.tif")
writeRaster(r, "output.tif")

# Create raster
r <- rast(nrows = 100, ncols = 100, xmin = 0, xmax = 10, ymin = 0, ymax = 10)
values(r) <- runif(ncell(r))

# Multi-layer
stack <- c(r1, r2, r3)
r[[1]]  # First layer
names(stack) <- c("band1", "band2", "band3")

# Properties
res(r)
ext(r)
crs(r)
ncell(r)
dim(r)

# Operations
crop(r, extent)
mask(r, polygon)
resample(r, template)
project(r, "EPSG:4326")
aggregate(r, fact = 2)
disagg(r, fact = 2)

# Algebra
r1 + r2
r * 2
log(r)
app(stack, fun = mean)
lapp(stack, fun = function(x, y) x / y)

# Extract
extract(r, points)
extract(r, polygons, fun = mean)

# Focal operations
focal(r, w = 3, fun = mean)
focal(r, w = matrix(1, 3, 3), fun = sum)

# Terrain
terrain(dem, v = c("slope", "aspect"))
shade(slope, aspect)
```

## stars

```r
library(stars)

# Read
s <- read_stars("file.tif")
s <- read_ncdf("file.nc")

# Dimensions
st_dimensions(s)

# Operations
s[, 1:100, 1:100]  # Subset
st_apply(s, c("x", "y"), mean)
st_warp(s, crs = 4326)
```
