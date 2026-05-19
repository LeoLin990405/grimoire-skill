---
name: r-network-viz
description: R network visualization with ggraph, visNetwork. Use for graph layouts and interactive networks.
---

# R Network Visualization

Graph visualization.

## ggraph

```r
library(ggraph)
library(tidygraph)

# Convert to tbl_graph
tg <- as_tbl_graph(g)

# Basic plot
ggraph(tg, layout = "fr") +
  geom_edge_link() +
  geom_node_point()

# Layouts
ggraph(tg, layout = "kk")      # Kamada-Kawai
ggraph(tg, layout = "fr")      # Fruchterman-Reingold
ggraph(tg, layout = "circle")
ggraph(tg, layout = "tree")
ggraph(tg, layout = "stress")

# Styled
ggraph(tg, layout = "fr") +
  geom_edge_link(aes(alpha = weight), show.legend = FALSE) +
  geom_node_point(aes(size = centrality, color = community)) +
  geom_node_text(aes(label = name), repel = TRUE) +
  theme_graph()

# Edge types
geom_edge_link()
geom_edge_arc()
geom_edge_fan()
geom_edge_diagonal()
```

## visNetwork

```r
library(visNetwork)

# Basic
visNetwork(nodes, edges)

# Options
visNetwork(nodes, edges) %>%
  visOptions(
    highlightNearest = TRUE,
    nodesIdSelection = TRUE,
    selectedBy = "group"
  ) %>%
  visLayout(randomSeed = 123) %>%
  visPhysics(stabilization = FALSE)

# From igraph
visIgraph(g)

# Hierarchical
visNetwork(nodes, edges) %>%
  visHierarchicalLayout(direction = "UD")
```

## networkD3

```r
library(networkD3)

# Force network
forceNetwork(Links = edges, Nodes = nodes, Source = "from", Target = "to",
             NodeID = "name", Group = "group")

# Sankey
sankeyNetwork(Links = links, Nodes = nodes, Source = "source", Target = "target",
              Value = "value", NodeID = "name")

# Simple network
simpleNetwork(edges)
```
