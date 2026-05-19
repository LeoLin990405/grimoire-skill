---
name: networkD3
description: R networkD3 package for D3 network graphs. Use for force-directed, Sankey, and tree diagrams.
---

# networkD3 Package

D3 JavaScript network graphs.

## Force Network

```r
library(networkD3)

# Simple
simpleNetwork(links_df, Source = "source", Target = "target")

# Full control
forceNetwork(
  Links = links,
  Nodes = nodes,
  Source = "source",
  Target = "target",
  NodeID = "name",
  Group = "group",
  opacity = 0.8,
  zoom = TRUE
)
```

## Sankey Diagram

```r
sankeyNetwork(
  Links = links,
  Nodes = nodes,
  Source = "source",
  Target = "target",
  Value = "value",
  NodeID = "name",
  units = "TWh"
)
```

## Tree Diagrams

```r
# Radial tree
radialNetwork(hierarchy_list)

# Diagonal tree
diagonalNetwork(hierarchy_list)

# Dendrogram
dendroNetwork(hclust_obj)
```

## Data Format

```r
# Links (0-indexed!)
links <- data.frame(
  source = c(0, 0, 1, 2),
  target = c(1, 2, 3, 3),
  value = c(10, 20, 15, 25)
)

# Nodes
nodes <- data.frame(
  name = c("A", "B", "C", "D"),
  group = c(1, 1, 2, 2)
)
```

## Customization

```r
forceNetwork(
  Links = links,
  Nodes = nodes,
  Source = "source",
  Target = "target",
  NodeID = "name",
  Group = "group",
  fontSize = 14,
  fontFamily = "Arial",
  linkDistance = 100,
  charge = -300,
  bounded = TRUE,
  colourScale = JS("d3.scaleOrdinal(d3.schemeCategory10)")
)
```

## Save

```r
library(htmlwidgets)
saveWidget(network, "network.html")
```
