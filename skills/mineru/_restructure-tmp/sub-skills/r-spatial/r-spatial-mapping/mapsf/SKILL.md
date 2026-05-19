---
name: mapsf
description: R mapsf package for thematic mapping. Use for creating thematic maps with sf objects.
---

# mapsf

Thematic cartography with sf.

## Basic Map

```r
library(mapsf)
library(sf)

# Read data
mtq <- st_read(system.file("gpkg/mtq.gpkg", package = "mapsf"))

# Base map
mf_map(mtq)
```

## Choropleth

```r
# Choropleth map
mf_map(mtq, var = "MED", type = "choro")

# With options
mf_map(mtq,
  var = "MED",
  type = "choro",
  breaks = "quantile",
  nbreaks = 5,
  pal = "Greens",
  border = "white",
  leg_title = "Median Income")
```

## Proportional Symbols

```r
# Proportional symbols
mf_map(mtq, var = "POP", type = "prop")

# With base layer
mf_map(mtq)
mf_map(mtq, var = "POP", type = "prop", add = TRUE)
```

## Combined Maps

```r
# Proportional + choropleth
mf_map(mtq)
mf_map(mtq,
  var = c("POP", "MED"),
  type = "prop_choro",
  add = TRUE)
```

## Typology

```r
# Categorical map
mf_map(mtq, var = "STATUS", type = "typo")
```

## Graduated Symbols

```r
# Graduated symbols
mf_map(mtq, var = "POP", type = "grad")
```

## Labels

```r
# Add labels
mf_label(mtq, var = "LIBGEO", cex = 0.7, halo = TRUE)
```

## Layout

```r
# Initialize map
mf_init(mtq)

# Add layers
mf_map(mtq, var = "MED", type = "choro", add = TRUE)

# Layout elements
mf_layout(
  title = "Map Title",
  credits = "Source: Data",
  arrow = TRUE,
  scale = TRUE
)

# Or separately
mf_title("Map Title")
mf_credits("Source")
mf_arrow()
mf_scale()
```

## Themes

```r
# Set theme
mf_theme("darkula")
mf_theme("candy")
mf_theme("default")

# Custom theme
mf_theme(bg = "lightblue", fg = "darkblue")
```

## Inset Map

```r
# Main map
mf_map(mtq, var = "MED", type = "choro")

# Inset
mf_inset_on(x = "worldmap", pos = "topright")
mf_worldmap(mtq)
mf_inset_off()
```

## Export

```r
# Export to file
mf_export(mtq, filename = "map.png", width = 800)
mf_map(mtq, var = "MED", type = "choro")
dev.off()
```
