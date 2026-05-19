---
name: stars
description: R stars package for spatiotemporal arrays. Use for raster data cubes and time series of rasters.
---

# stars Package

Spatiotemporal arrays (raster/vector data cubes).

## Read Data

```r
library(stars)

# Single file
r <- read_stars("file.tif")

# Multiple files (time series)
files <- list.files(pattern = "*.tif")
r <- read_stars(files, along = "time")

# NetCDF
nc <- read_stars("file.nc")
```

## Create

```r
# From matrix
m <- matrix(1:20, 4, 5)
s <- st_as_stars(m)

# With dimensions
s <- st_as_stars(list(values = m),
  dimensions = st_dimensions(
    x = 1:4,
    y = 1:5
  )
)
```

## Dimensions

```r
# View dimensions
st_dimensions(r)

# Set dimension values
r <- st_set_dimensions(r, "time", values = dates)

# Rename dimensions
r <- setNames(r, "temperature")
```

## Operations

```r
# Subset
r[, 1:10, 1:10]
r[, , , 1:5]  # First 5 time steps

# Aggregate
r_agg <- st_apply(r, c("x", "y"), mean)

# Warp (reproject)
r_warp <- st_warp(r, crs = 4326)

# Crop
r_crop <- st_crop(r, bbox)
```

## With sf

```r
library(sf)

# Extract by polygons
vals <- aggregate(r, polygons, FUN = mean)

# Rasterize
r <- st_rasterize(sf_obj)
```

## Plot

```r
plot(r)

# With ggplot2
library(ggplot2)
ggplot() +
  geom_stars(data = r) +
  scale_fill_viridis_c()
```

## Write

```r
write_stars(r, "output.tif")
```
