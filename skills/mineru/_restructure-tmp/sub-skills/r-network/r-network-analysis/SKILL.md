---
name: r-network-analysis
description: R network analysis with igraph, sna. Use for centrality, community detection, and network metrics.
---

# R Network Analysis

Graph analysis and metrics.

## igraph

```r
library(igraph)

# Create graph
g <- graph_from_data_frame(edges, directed = TRUE, vertices = nodes)
g <- graph_from_adjacency_matrix(adj_matrix)
g <- make_ring(10)

# Basic info
vcount(g); ecount(g)
V(g); E(g)
is_directed(g)

# Centrality
degree(g)
betweenness(g)
closeness(g)
eigen_centrality(g)$vector
page_rank(g)$vector

# Community detection
cluster_louvain(g)
cluster_walktrap(g)
cluster_edge_betweenness(g)
membership(communities)
modularity(communities)

# Paths
shortest_paths(g, from = 1, to = 10)
distances(g)
diameter(g)

# Network metrics
transitivity(g)  # Clustering coefficient
graph.density(g)
assortativity_degree(g)
```

## sna

```r
library(sna)

# Centrality
degree(net, cmode = "indegree")
betweenness(net)
closeness(net)

# Structural equivalence
equiv.clust(net)

# QAP correlation
qaptest(list(net1, net2), gcor, g1 = 1, g2 = 2)
```

## Network Statistics

```r
# Degree distribution
degree_distribution(g)
fit_power_law(degree(g))

# Clustering
transitivity(g, type = "local")
transitivity(g, type = "global")

# Components
components(g)
largest_component <- decompose(g)[[1]]

# Motifs
motifs(g, size = 3)
count_motifs(g, size = 3)
```
