---
name: igraph
description: R igraph package for network analysis. Use for graph creation, analysis, centrality, community detection, and visualization.
---

# igraph

Network analysis and visualization.

## Create Graphs

```r
library(igraph)

# From edge list
g <- graph_from_edgelist(matrix(c(1,2, 2,3, 3,1), ncol = 2, byrow = TRUE))

# From data frame
g <- graph_from_data_frame(edges, directed = TRUE, vertices = nodes)

# From adjacency matrix
g <- graph_from_adjacency_matrix(adj_matrix)
g <- graph_from_adjacency_matrix(adj_matrix, mode = "undirected", weighted = TRUE)

# Special graphs
g <- make_empty_graph(n = 10)
g <- make_full_graph(n = 10)
g <- make_ring(n = 10)
g <- make_star(n = 10)
g <- make_tree(n = 15, children = 2)
g <- make_lattice(dimvector = c(5, 5))

# Random graphs
g <- sample_gnp(n = 100, p = 0.1)
g <- sample_gnm(n = 100, m = 200)
g <- sample_pa(n = 100, power = 1)  # Preferential attachment
g <- sample_smallworld(dim = 1, size = 100, nei = 2, p = 0.1)
```

## Graph Properties

```r
# Basic
vcount(g)  # Number of vertices
ecount(g)  # Number of edges
is_directed(g)
is_weighted(g)
is_connected(g)

# Vertices and edges
V(g)
E(g)
V(g)$name
E(g)$weight

# Neighbors
neighbors(g, v = 1)
neighbors(g, v = 1, mode = "out")
neighbors(g, v = 1, mode = "in")
neighbors(g, v = 1, mode = "all")

# Adjacency
adjacent_vertices(g, v = 1)
incident_edges(g, v = 1)
are_adjacent(g, v1 = 1, v2 = 2)
```

## Centrality

```r
# Degree
degree(g)
degree(g, mode = "in")
degree(g, mode = "out")

# Betweenness
betweenness(g)
edge_betweenness(g)

# Closeness
closeness(g)

# Eigenvector
eigen_centrality(g)$vector

# PageRank
page_rank(g)$vector

# Hub and authority
hub_score(g)$vector
authority_score(g)$vector
```

## Community Detection

```r
# Louvain
comm <- cluster_louvain(g)
membership(comm)
modularity(comm)

# Other algorithms
cluster_fast_greedy(g)
cluster_walktrap(g)
cluster_edge_betweenness(g)
cluster_label_prop(g)
cluster_infomap(g)
cluster_leiden(g)

# Compare communities
compare(comm1, comm2, method = "nmi")
```

## Paths and Distances

```r
# Shortest paths
shortest_paths(g, from = 1, to = 10)
all_shortest_paths(g, from = 1, to = 10)

# Distances
distances(g)
distances(g, v = 1)
mean_distance(g)

# Diameter
diameter(g)
get_diameter(g)
```

## Graph Metrics

```r
# Density
edge_density(g)

# Transitivity (clustering coefficient)
transitivity(g)
transitivity(g, type = "local")

# Assortativity
assortativity_degree(g)
assortativity(g, V(g)$attribute)

# Components
components(g)
largest_component(g)
```

## Manipulation

```r
# Add/remove vertices
g <- add_vertices(g, 5)
g <- delete_vertices(g, c(1, 2, 3))

# Add/remove edges
g <- add_edges(g, c(1,2, 3,4))
g <- delete_edges(g, E(g)[1:5])

# Subgraph
subgraph <- induced_subgraph(g, vids = 1:10)
subgraph <- subgraph.edges(g, eids = 1:20)

# Simplify
g <- simplify(g)  # Remove loops and multiple edges
```

## Visualization

```r
# Basic plot
plot(g)

# With options
plot(g,
  vertex.size = degree(g) * 2,
  vertex.color = membership(comm),
  vertex.label = V(g)$name,
  vertex.label.cex = 0.8,
  edge.arrow.size = 0.5,
  edge.width = E(g)$weight,
  layout = layout_with_fr(g)
)

# Layouts
layout_with_fr(g)        # Fruchterman-Reingold
layout_with_kk(g)        # Kamada-Kawai
layout_in_circle(g)      # Circle
layout_as_tree(g)        # Tree
layout_with_lgl(g)       # Large graph
layout_nicely(g)         # Auto-select
```
