---
name: visNetwork
description: R visNetwork package for network visualization. Use for interactive network graphs with vis.js.
---

# visNetwork Package

Interactive network visualization with vis.js.

## Basic Network

```r
library(visNetwork)

nodes <- data.frame(
  id = 1:5,
  label = c("A", "B", "C", "D", "E")
)

edges <- data.frame(
  from = c(1, 1, 2, 3),
  to = c(2, 3, 4, 5)
)

visNetwork(nodes, edges)
```

## Node Styling

```r
nodes <- data.frame(
  id = 1:5,
  label = LETTERS[1:5],
  color = c("red", "blue", "green", "yellow", "purple"),
  size = c(20, 30, 25, 35, 15),
  shape = c("dot", "square", "triangle", "star", "diamond"),
  group = c("A", "A", "B", "B", "C")
)

visNetwork(nodes, edges) %>%
  visGroups(groupname = "A", color = "red") %>%
  visGroups(groupname = "B", color = "blue")
```

## Edge Styling

```r
edges <- data.frame(
  from = c(1, 1, 2),
  to = c(2, 3, 4),
  arrows = "to",
  dashes = c(TRUE, FALSE, FALSE),
  width = c(1, 2, 3),
  color = c("red", "blue", "green")
)
```

## Interactivity

```r
visNetwork(nodes, edges) %>%
  visOptions(
    highlightNearest = TRUE,
    nodesIdSelection = TRUE,
    selectedBy = "group"
  ) %>%
  visInteraction(
    navigationButtons = TRUE,
    keyboard = TRUE
  )
```

## Layout

```r
visNetwork(nodes, edges) %>%
  visLayout(randomSeed = 123) %>%
  visPhysics(stabilization = FALSE)

# Hierarchical
visNetwork(nodes, edges) %>%
  visHierarchicalLayout(direction = "UD")
```

## From igraph

```r
library(igraph)
g <- make_ring(10)
visIgraph(g)
```

## Events

```r
visNetwork(nodes, edges) %>%
  visEvents(
    select = "function(nodes) {
      Shiny.onInputChange('selected', nodes.nodes);
    }"
  )
```
