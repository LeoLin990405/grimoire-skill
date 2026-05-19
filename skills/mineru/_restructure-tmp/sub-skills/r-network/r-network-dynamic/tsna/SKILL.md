---
name: tsna
description: R tsna package for temporal network analysis. Use for analyzing temporal paths and metrics in dynamic networks.
---

# tsna

Tools for temporal social network analysis.

## Temporal Paths

```r
library(tsna)

# Forward reachable set
tPath(dnet, v = 1, direction = "fwd",
  start = 0, end = 10)

# Backward reachable set
tPath(dnet, v = 1, direction = "bkwd",
  start = 0, end = 10)

# Geodesic distance
tPath(dnet, v = 1, type = "geodesic")
```

## Reachability

```r
# Forward reachability
reach_fwd <- tReach(dnet, direction = "fwd")

# Backward reachability
reach_bkwd <- tReach(dnet, direction = "bkwd")

# Reachability matrix
tReach(dnet, graph = TRUE)
```

## Temporal Metrics

```r
# Temporal degree
tDegree(dnet)

# At specific time
tDegree(dnet, at = 5)

# Over interval
tDegree(dnet, start = 0, end = 10)
```

## SNA Statistics Over Time

```r
# Apply SNA function over time
tSnaStats(dnet, snafun = "betweenness")
tSnaStats(dnet, snafun = "closeness")
tSnaStats(dnet, snafun = "degree")

# Custom function
tSnaStats(dnet, snafun = function(x) {
  mean(degree(x))
})
```

## Edge Duration

```r
# Edge durations
edgeDuration(dnet)

# Mean duration
mean(edgeDuration(dnet))
```

## Vertex Activity

```r
# Vertex activity duration
vertexDuration(dnet)
```

## Transmission Trees

```r
# Infection/transmission tree
tree <- tPath(dnet, v = 1, direction = "fwd",
  type = "earliest.arrive")

# Plot tree
plot(tree)
```

## Temporal Correlation

```r
# Correlation between time slices
tCorrelate(dnet, lag = 1)
```

## Aggregation

```r
# Aggregate over time windows
tErgmStats(dnet,
  formula = ~ edges + mutual,
  start = 0, end = 10,
  time.interval = 1)
```
