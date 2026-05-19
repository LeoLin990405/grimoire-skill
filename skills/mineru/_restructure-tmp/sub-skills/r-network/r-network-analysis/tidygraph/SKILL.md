---
name: tidygraph
description: R tidygraph package for tidy graph manipulation. Use for dplyr-style operations on network data.
---

# tidygraph Package

Tidy API for graph/network manipulation.

## Create Graph

```r
library(tidygraph)

# From data frames
graph <- tbl_graph(nodes = nodes_df, edges = edges_df)

# From igraph
graph <- as_tbl_graph(igraph_obj)

# Built-in graphs
graph <- play_erdos_renyi(100, 0.1)
graph <- create_ring(10)
graph <- create_tree(15, 2)
```

## Activate Context

```r
# Switch between nodes and edges
graph %>%
  activate(nodes) %>%
  mutate(degree = centrality_degree())

graph %>%
  activate(edges) %>%
  filter(weight > 0.5)
```

## Node Operations

```r
graph %>%
  activate(nodes) %>%
  mutate(
    degree = centrality_degree(),
    betweenness = centrality_betweenness(),
    pagerank = centrality_pagerank(),
    community = group_louvain()
  ) %>%
  filter(degree > 5) %>%
  arrange(desc(betweenness))
```

## Edge Operations

```r
graph %>%
  activate(edges) %>%
  mutate(
    centrality = centrality_edge_betweenness()
  ) %>%
  filter(!edge_is_multiple()) %>%
  arrange(desc(weight))
```

## Graph Operations

```r
# Convert
graph %>% to_undirected()
graph %>% to_simple()

# Subgraph
graph %>%
  activate(nodes) %>%
  filter(group == 1) %>%
  activate(edges) %>%
  filter(!edge_is_incident(node_is_isolated()))
```

## Morphing

```r
# Temporarily change structure
graph %>%
  morph(to_components) %>%
  mutate(comp_size = graph_order()) %>%
  unmorph()

# Other morphs
to_subgraph()
to_contracted()
to_linegraph()
```

## With ggraph

```r
library(ggraph)

graph %>%
  ggraph(layout = "fr") +
  geom_edge_link() +
  geom_node_point(aes(size = degree))
```
