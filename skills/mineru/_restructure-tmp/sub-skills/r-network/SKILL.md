---
name: r-network
description: R network analysis packages. Use for graph analysis, social network analysis, network visualization, and community detection.
---

# R Network Analysis Skill

## Sub-skills

| Sub-skill | Description |
|-----------|-------------|
| [r-network-analysis](r-network-analysis/SKILL.md) | igraph, tidygraph, centrality, communities |
| [r-network-viz](r-network-viz/SKILL.md) | ggraph, visNetwork, networkD3 |
| [r-network-dynamic](r-network-dynamic/SKILL.md) | networkDynamic, ndtv, temporal networks |

Network and graph analysis in R.

## Core Packages

| Package | Description |
|---------|-------------|
| **igraph** ★ | Comprehensive network analysis |
| **tidygraph** ★ | Tidy API for graphs |
| **network** | Basic relational data tools |
| **sna** | Social network analysis |

## Network Modeling

| Package | Description |
|---------|-------------|
| **ergm** | Exponential random graph models |
| **latentnet** | Latent position/cluster models |
| **manynet** | Many network types |

## Dynamic Networks

| Package | Description |
|---------|-------------|
| **networkDynamic** | Dynamic/temporal networks |
| **ndtv** | Animated network visualization |
| **netdiffuseR** | Network diffusion analysis |

## Visualization

| Package | Description |
|---------|-------------|
| **ggraph** ★ | Grammar of graphics for graphs |
| **visNetwork** ★ | Interactive visualization (vis.js) |
| **networkD3** | D3 network graphs |
| **autograph** | Automagic network plotting |

## Metrics & Analysis

| Package | Description |
|---------|-------------|
| **tnet** | Weighted/two-mode networks |
| **rgexf** | Export to GEXF (Gephi) |

## Quick Examples

```r
# igraph basics
library(igraph)

# Create graph
g <- graph_from_data_frame(edges, directed = TRUE, vertices = nodes)
# Or from adjacency matrix
g <- graph_from_adjacency_matrix(adj_matrix)

# Basic metrics
vcount(g)  # Number of vertices
ecount(g)  # Number of edges
degree(g)  # Degree centrality
betweenness(g)  # Betweenness centrality
closeness(g)  # Closeness centrality
page_rank(g)$vector  # PageRank

# Community detection
communities <- cluster_louvain(g)
membership(communities)
modularity(communities)

# Shortest paths
shortest_paths(g, from = "A", to = "B")
distances(g)

# Plot
plot(g,
     vertex.size = degree(g) * 2,
     vertex.color = membership(communities),
     edge.arrow.size = 0.5)

# tidygraph + ggraph
library(tidygraph)
library(ggraph)

tg <- as_tbl_graph(g) %>%
  activate(nodes) %>%
  mutate(
    centrality = centrality_degree(),
    community = group_louvain()
  )

ggraph(tg, layout = "fr") +
  geom_edge_link(alpha = 0.5) +
  geom_node_point(aes(size = centrality, color = factor(community))) +
  geom_node_text(aes(label = name), repel = TRUE) +
  theme_graph()

# Interactive visualization
library(visNetwork)
visNetwork(nodes, edges) %>%
  visOptions(highlightNearest = TRUE) %>%
  visLayout(randomSeed = 123)

# Network statistics
transitivity(g)  # Clustering coefficient
diameter(g)  # Network diameter
graph.density(g)  # Density
assortativity_degree(g)  # Degree assortativity
```

## Common Workflows

### Social Network Analysis
```r
library(igraph)

# Load data
edges <- read.csv("edges.csv")
nodes <- read.csv("nodes.csv")
g <- graph_from_data_frame(edges, vertices = nodes)

# Centrality analysis
nodes$degree <- degree(g)
nodes$betweenness <- betweenness(g)
nodes$eigenvector <- eigen_centrality(g)$vector

# Community detection
comm <- cluster_louvain(g)
nodes$community <- membership(comm)

# Key players
head(nodes[order(-nodes$betweenness), ])
```

### Network Visualization
```r
library(ggraph)
library(tidygraph)

tg <- as_tbl_graph(g) %>%
  activate(nodes) %>%
  mutate(importance = centrality_pagerank())

# Force-directed layout
ggraph(tg, layout = "fr") +
  geom_edge_link(aes(alpha = weight)) +
  geom_node_point(aes(size = importance)) +
  theme_void()

# Circular layout by community
ggraph(tg, layout = "linear", circular = TRUE) +
  geom_edge_arc(aes(alpha = weight)) +
  geom_node_point(aes(color = factor(community))) +
  coord_fixed()
```

## Resources

- igraph: https://igraph.org/r/
- tidygraph: https://tidygraph.data-imaginist.com/
- ggraph: https://ggraph.data-imaginist.com/
- visNetwork: https://datastorm-open.github.io/visNetwork/
