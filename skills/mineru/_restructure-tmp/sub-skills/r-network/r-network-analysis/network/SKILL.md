---
name: network
description: R network package for network data. Use for creating and manipulating network objects.
---

# network

Classes for relational data.

## Creating Networks

```r
library(network)

# From edge list
edges <- matrix(c(1, 2, 1, 3, 2, 3, 3, 4), ncol = 2, byrow = TRUE)
net <- network(edges, directed = TRUE)

# From adjacency matrix
adj <- matrix(c(0, 1, 1, 0,
                0, 0, 1, 0,
                0, 0, 0, 1,
                0, 0, 0, 0), nrow = 4, byrow = TRUE)
net <- network(adj, directed = TRUE)

# Empty network
net <- network.initialize(10, directed = FALSE)
```

## Network Properties

```r
# Number of vertices
network.size(net)

# Number of edges
network.edgecount(net)

# Is directed?
is.directed(net)

# Is bipartite?
is.bipartite(net)

# Density
network.density(net)
```

## Vertex Attributes

```r
# Set vertex attribute
set.vertex.attribute(net, "name", c("A", "B", "C", "D"))
net %v% "name" <- c("A", "B", "C", "D")

# Get vertex attribute
get.vertex.attribute(net, "name")
net %v% "name"

# List all vertex attributes
list.vertex.attributes(net)
```

## Edge Attributes

```r
# Set edge attribute
set.edge.attribute(net, "weight", c(1, 2, 3, 4))
net %e% "weight" <- c(1, 2, 3, 4)

# Get edge attribute
get.edge.attribute(net, "weight")
net %e% "weight"

# List all edge attributes
list.edge.attributes(net)
```

## Network Attributes

```r
# Set network attribute
set.network.attribute(net, "title", "My Network")
net %n% "title" <- "My Network"

# Get network attribute
get.network.attribute(net, "title")
net %n% "title"
```

## Adding/Removing Edges

```r
# Add edges
add.edges(net, tail = c(1, 2), head = c(4, 4))

# Add edge with attributes
add.edges(net, tail = 1, head = 5, names.eval = "weight", vals.eval = 3)

# Delete edges
delete.edges(net, eid = 1)

# Add vertices
add.vertices(net, nv = 2)

# Delete vertices
delete.vertices(net, vid = c(1, 2))
```

## Subsetting

```r
# Get neighbors
get.neighborhood(net, v = 1, type = "out")
get.neighborhood(net, v = 1, type = "in")
get.neighborhood(net, v = 1, type = "combined")

# Get edge IDs
get.edgeIDs(net, v = 1, alter = 2)

# Subnetwork
subnet <- get.inducedSubgraph(net, v = c(1, 2, 3))
```

## Adjacency

```r
# As adjacency matrix
as.matrix(net)
as.matrix(net, matrix.type = "adjacency")

# As edge list
as.matrix(net, matrix.type = "edgelist")

# As sociomatrix
as.sociomatrix(net)
```

## Plotting

```r
# Basic plot
plot(net)

# With labels
plot(net, displaylabels = TRUE)

# With vertex attributes
plot(net,
     vertex.col = net %v% "color",
     vertex.cex = net %v% "size",
     displaylabels = TRUE,
     label = net %v% "name"
)

# With edge attributes
plot(net,
     edge.col = net %e% "type",
     edge.lwd = net %e% "weight"
)

# Layout
plot(net, mode = "circle")
plot(net, mode = "fruchtermanreingold")
plot(net, mode = "kamadakawai")
```

## Bipartite Networks

```r
# Create bipartite network
net <- network(edges, bipartite = 3)  # First 3 vertices are mode 1

# Check bipartite
is.bipartite(net)

# Get bipartite attribute
net %n% "bipartite"
```

## Conversion

```r
# To igraph
library(intergraph)
ig <- asIgraph(net)

# From igraph
net <- asNetwork(ig)
```

## Summary

```r
# Network summary
summary(net)

# Print
print(net)
```
