---
name: rgdal
description: R rgdal package for geospatial data. Use for reading/writing spatial data formats (deprecated, use sf/terra).
---

# rgdal

Bindings for GDAL/OGR (deprecated - use sf or terra).

## Note

rgdal was retired in October 2023. Use sf or terra instead.

## Migration to sf

```r
# Old rgdal way
library(rgdal)
shp <- readOGR("data.shp")
writeOGR(shp, "output.shp", layer = "data", driver = "ESRI Shapefile")

# New sf way
library(sf)
shp <- st_read("data.shp")
st_write(shp, "output.shp")
```

## Migration to terra

```r
# Old rgdal way
library(rgdal)
raster <- readGDAL("raster.tif")

# New terra way
library(terra)
raster <- rast("raster.tif")
```

## CRS Handling

```r
# Old way
proj4string(sp_obj) <- CRS("+proj=longlat +datum=WGS84")
spTransform(sp_obj, CRS("+proj=utm +zone=10"))

# New sf way
st_crs(sf_obj) <- 4326
st_transform(sf_obj, 32610)
```

## Available Drivers

```r
# In sf
st_drivers()

# In terra
gdal(drivers = TRUE)
```
