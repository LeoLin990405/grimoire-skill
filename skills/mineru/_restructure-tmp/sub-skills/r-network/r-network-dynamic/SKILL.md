---
name: r-network-dynamic
description: R dynamic/temporal networks with ndtv, networkDynamic, tsna. Use for time-varying networks and network evolution.
---

# R Dynamic Networks

Temporal and evolving networks.

## networkDynamic

```r
library(networkDynamic)

# Create dynamic network
dnet <- networkDynamic(
  network.list = list(net_t1, net_t2, net_t3),
  onsets = c(0, 1, 2),
  termini = c(1, 2, 3)
)

# Add/remove edges over time
activate.edges(dnet, onset = 1, terminus = 3, e = 1:5)
deactivate.edges(dnet, onset = 2, terminus = 3, e = 3)

# Query at time point
network.extract(dnet, at = 1.5)
network.extract(dnet, onset = 0, terminus = 2)

# Edge/vertex activity
is.active(dnet, at = 1, e = 1:10)
get.edge.activity(dnet, e = 1)
```

## ndtv (Animation)

```r
library(ndtv)

# Compute animation
compute.animation(dnet, animation.mode = "kamadakawai")

# Render animation
render.d3movie(dnet, filename = "network.html")
render.animation(dnet, filename = "network.gif")

# Customize
render.d3movie(dnet,
  vertex.col = "blue",
  edge.col = "gray",
  displaylabels = TRUE
)
```

## tsna (Temporal Analysis)

```r
library(tsna)

# Temporal paths
tPath(dnet, v = 1, start = 0, end = 10)

# Reachability
tReach(dnet, direction = "fwd")

# Temporal metrics
tDegree(dnet)
tSnaStats(dnet, snafun = "betweenness")
```
