---
name: cartography
description: R cartography package for thematic mapping. Use for creating publication-quality thematic maps.
---

# cartography

Thematic cartography.

## Basic Map

```r
library(cartography)
library(sf)

# Read data
mtq <- st_read(system.file("gpkg/mtq.gpkg", package = "cartography"))

# Plot base map
plot(st_geometry(mtq), col = "lightblue", border = "white")
```

## Choropleth Map

```r
# Choropleth
choroLayer(
  x = mtq,
  var = "MED",
  method = "quantile",
  nclass = 5,
  col = carto.pal("green.pal", 5),
  border = "white",
  legend.title.txt = "Median Income"
)
```

## Proportional Symbols

```r
# Proportional circles
propSymbolsLayer(
  x = mtq,
  var = "POP",
  col = "red",
  border = "white",
  legend.title.txt = "Population"
)

# Proportional + choropleth
propSymbolsChoroLayer(
  x = mtq,
  var = "POP",
  var2 = "MED",
  col = carto.pal("blue.pal", 4)
)
```

## Typology Map

```r
# Categorical map
typoLayer(
  x = mtq,
  var = "STATUS",
  col = carto.pal("pastel.pal", 4),
  legend.title.txt = "Status"
)
```

## Labels

```r
# Add labels
labelLayer(
  x = mtq,
  txt = "LIBGEO",
  col = "black",
  cex = 0.7,
  halo = TRUE
)
```

## Layout Elements

```r
# Title
layoutLayer(
  title = "Map Title",
  author = "Author",
  sources = "Data source",
  scale = 5,
  north = TRUE
)

# North arrow
north(pos = "topleft")

# Scale bar
barscale(size = 5)
```

## Color Palettes

```r
# Available palettes
display.carto.all()

# Get palette
carto.pal("green.pal", 5)
carto.pal("red.pal", 7)
carto.pal("blue.pal", 4)
carto.pal("orange.pal", 6)
```

## Smoothed Map

```r
# Kernel density
smoothLayer(
  x = mtq,
  var = "POP",
  typefct = "exponential",
  span = 3000,
  beta = 2
)
```

## Links/Flows

```r
# Flow map
gradLinkLayer(
  x = links,
  df = flow_data,
  xid = "origin",
  yid = "destination",
  var = "flow"
)
```
