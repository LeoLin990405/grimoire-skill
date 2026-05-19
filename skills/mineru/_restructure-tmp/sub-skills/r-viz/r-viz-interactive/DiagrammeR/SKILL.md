---
name: DiagrammeR
description: R DiagrammeR package for graph and diagram creation. Use for creating flowcharts, network diagrams, and Graphviz/Mermaid diagrams.
---

# DiagrammeR

Create graph diagrams and flowcharts.

## Graphviz Diagrams

```r
library(DiagrammeR)

# DOT language
grViz("
  digraph {
    A -> B
    B -> C
    C -> A
  }
")

# With styling
grViz("
  digraph {
    graph [rankdir = LR]
    node [shape = box, style = filled, fillcolor = lightblue]

    A [label = 'Start']
    B [label = 'Process']
    C [label = 'End', fillcolor = lightgreen]

    A -> B -> C
  }
")
```

## Flowcharts

```r
grViz("
  digraph flowchart {
    graph [rankdir = TB]
    node [shape = rectangle, style = filled]

    start [label = 'Start', shape = oval, fillcolor = '#90EE90']
    input [label = 'Input Data', fillcolor = '#ADD8E6']
    process [label = 'Process Data', fillcolor = '#FFE4B5']
    decision [label = 'Valid?', shape = diamond, fillcolor = '#FFB6C1']
    output [label = 'Output Results', fillcolor = '#ADD8E6']
    end [label = 'End', shape = oval, fillcolor = '#90EE90']

    start -> input -> process -> decision
    decision -> output [label = 'Yes']
    decision -> input [label = 'No']
    output -> end
  }
")
```

## Mermaid Diagrams

```r
# Mermaid flowchart
mermaid("
  graph LR
    A[Start] --> B{Decision}
    B -->|Yes| C[Action 1]
    B -->|No| D[Action 2]
    C --> E[End]
    D --> E
")

# Sequence diagram
mermaid("
  sequenceDiagram
    participant User
    participant Server
    participant Database

    User->>Server: Request
    Server->>Database: Query
    Database-->>Server: Results
    Server-->>User: Response
")
```

## Graph Objects

```r
# Create graph programmatically
graph <- create_graph() %>%
  add_node(label = "A") %>%
  add_node(label = "B") %>%
  add_node(label = "C") %>%
  add_edge(from = 1, to = 2) %>%
  add_edge(from = 2, to = 3) %>%
  add_edge(from = 3, to = 1)

render_graph(graph)

# From data frames
nodes <- data.frame(
  id = 1:4,
  label = c("A", "B", "C", "D"),
  type = c("input", "process", "process", "output")
)

edges <- data.frame(
  from = c(1, 2, 2, 3),
  to = c(2, 3, 4, 4)
)

graph <- create_graph(nodes_df = nodes, edges_df = edges)
render_graph(graph)
```

## Styling Nodes and Edges

```r
graph <- create_graph() %>%
  add_node(label = "Start",
    node_aes = node_aes(
      shape = "circle",
      fillcolor = "green",
      fontcolor = "white"
    )) %>%
  add_node(label = "End",
    node_aes = node_aes(
      shape = "circle",
      fillcolor = "red"
    )) %>%
  add_edge(from = 1, to = 2,
    edge_aes = edge_aes(
      color = "blue",
      penwidth = 2
    ))

render_graph(graph)
```

## Graph Analysis

```r
# Create graph
graph <- create_graph() %>%
  add_n_nodes(10) %>%
  add_edges_w_string("1->2 2->3 3->4 4->5 5->1 2->6 6->7 7->8 8->9 9->10")

# Metrics
get_degree_distribution(graph)
get_betweenness(graph)
get_closeness(graph)
get_pagerank(graph)

# Traversal
graph %>%
  select_nodes_by_id(1) %>%
  trav_out() %>%
  get_selection()
```

## Export

```r
# Export to SVG
export_graph(graph, file_name = "graph.svg")

# Export to PNG
export_graph(graph, file_name = "graph.png")

# Export to PDF
export_graph(graph, file_name = "graph.pdf")

# Get DOT code
generate_dot(graph)
```

## Subgraphs and Clusters

```r
grViz("
  digraph {
    subgraph cluster_0 {
      label = 'Process A'
      style = filled
      color = lightgrey
      a1 -> a2 -> a3
    }

    subgraph cluster_1 {
      label = 'Process B'
      color = blue
      b1 -> b2 -> b3
    }

    a3 -> b1
  }
")
```
