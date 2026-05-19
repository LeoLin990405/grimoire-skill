---
name: sna
description: R sna package for social network analysis. Use for network statistics and visualization with statnet.
---

# sna Package

Social network analysis tools.

## Create Network

```r
library(sna)
library(network)

# From adjacency matrix
net <- network(adj_matrix, directed = TRUE)

# From edge list
net <- network(edge_list, matrix.type = "edgelist")
```

## Centrality Measures

```r
# Degree
degree(net, cmode = "indegree")
degree(net, cmode = "outdegree")
degree(net, cmode = "freeman")

# Betweenness
betweenness(net)

# Closeness
closeness(net)

# Eigenvector
evcent(net)
```

## Network Statistics

```r
# Density
gden(net)

# Transitivity (clustering)
gtrans(net)

# Reciprocity
grecip(net)

# Centralization
centralization(net, degree)
```

## Structural Equivalence

```r
# Euclidean distance
sedist(net, method = "euclidean")

# Correlation
sedist(net, method = "correlation")

# Block modeling
equiv.clust(net)
```

## Visualization

```r
# Basic plot
gplot(net)

# With attributes
gplot(net,
  vertex.col = "blue",
  vertex.cex = degree(net) / 5,
  edge.col = "gray",
  mode = "fruchtermanreingold"
)

# Layout modes
gplot(net, mode = "circle")
gplot(net, mode = "kamadakawai")
gplot(net, mode = "mds")
```

## QAP Correlation

```r
# Quadratic Assignment Procedure
qaptest(list(net1, net2), gcor, g1 = 1, g2 = 2, reps = 1000)
```

## Dyad/Triad Census

```r
dyad.census(net)
triad.census(net)
```
