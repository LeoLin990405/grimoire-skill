---
name: ggraph
description: R ggraph package for network visualization. Use for grammar of graphics style network plots.
---

# ggraph Package

Grammar of graphics for networks.

## Basic Plot

```r
library(ggraph)
library(tidygraph)

graph <- as_tbl_graph(igraph_obj)

ggraph(graph, layout = "fr") +
  geom_edge_link() +
  geom_node_point()
```

## Layouts

```r
# Force-directed
ggraph(graph, layout = "fr")  # Fruchterman-Reingold
ggraph(graph, layout = "kk")  # Kamada-Kawai
ggraph(graph, layout = "stress")

# Hierarchical
ggraph(graph, layout = "tree")
ggraph(graph, layout = "dendrogram")

# Circular
ggraph(graph, layout = "circle")
ggraph(graph, layout = "linear", circular = TRUE)

# Manual
ggraph(graph, layout = "manual", x = x_coords, y = y_coords)
```

## Edge Geoms

```r
# Links
geom_edge_link(aes(alpha = weight))
geom_edge_link2(aes(color = node.class))  # Gradient

# Arcs
geom_edge_arc(aes(alpha = weight))
geom_edge_fan()  # Multiple edges

# Curved
geom_edge_bend()
geom_edge_diagonal()

# Arrows
geom_edge_link(arrow = arrow(length = unit(2, "mm")))
```

## Node Geoms

```r
geom_node_point(aes(size = degree, color = community))
geom_node_text(aes(label = name), repel = TRUE)
geom_node_label(aes(label = name))
geom_node_tile()  # For treemaps
```

## Full Example

```r
graph %>%
  mutate(
    degree = centrality_degree(),
    community = as.factor(group_louvain())
  ) %>%
  ggraph(layout = "fr") +
  geom_edge_link(alpha = 0.3) +
  geom_node_point(aes(size = degree, color = community)) +
  geom_node_text(aes(label = name), repel = TRUE, size = 3) +
  scale_size_continuous(range = c(2, 10)) +
  theme_graph() +
  labs(title = "Network Visualization")
```

## Faceting

```r
ggraph(graph, layout = "fr") +
  geom_edge_link() +
  geom_node_point() +
  facet_nodes(~community)

ggraph(graph, layout = "fr") +
  geom_edge_link() +
  geom_node_point() +
  facet_edges(~type)
```
