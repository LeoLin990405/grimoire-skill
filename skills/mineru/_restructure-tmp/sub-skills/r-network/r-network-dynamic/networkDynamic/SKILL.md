---
name: networkDynamic
description: R networkDynamic package for temporal networks. Use for creating and manipulating dynamic/temporal networks.
---

# networkDynamic

Dynamic extensions of the network class.

## Create Dynamic Network

```r
library(networkDynamic)

# From static network
dnet <- networkDynamic(base.net = static_net)

# From network list
dnet <- networkDynamic(
  network.list = list(net_t1, net_t2, net_t3),
  onsets = c(0, 1, 2),
  termini = c(1, 2, 3)
)

# Empty dynamic network
dnet <- networkDynamic(network.initialize(10))
```

## Edge Activity

```r
# Activate edges
activate.edges(dnet, onset = 0, terminus = 5, e = 1:10)

# Deactivate edges
deactivate.edges(dnet, onset = 3, terminus = 5, e = 5:10)

# Add edge with timing
add.edges.active(dnet,
  tail = 1, head = 2,
  onset = 0, terminus = 10)

# Query edge activity
is.active(dnet, at = 2, e = 1:10)
get.edge.activity(dnet, e = 1)
```

## Vertex Activity

```r
# Activate vertices
activate.vertices(dnet, onset = 0, terminus = 10, v = 1:5)

# Deactivate vertices
deactivate.vertices(dnet, onset = 5, terminus = 10, v = 3:5)

# Query vertex activity
is.active(dnet, at = 2, v = 1:10)
get.vertex.activity(dnet, v = 1)
```

## Extract Networks

```r
# At specific time
net_t2 <- network.extract(dnet, at = 2)

# Time interval
net_interval <- network.extract(dnet, onset = 1, terminus = 3)

# Collapse to static
static <- network.collapse(dnet, onset = 0, terminus = 10)
```

## Dynamic Attributes

```r
# Set dynamic attribute
activate.vertex.attribute(dnet, "status",
  value = "active",
  onset = 0, terminus = 5,
  v = 1:5)

# Get attribute at time
get.vertex.attribute.active(dnet, "status", at = 2)
```

## Spells

```r
# Get activity spells
get.edge.activity(dnet, e = 1, as.spellList = TRUE)
get.vertex.activity(dnet, v = 1, as.spellList = TRUE)

# Activity duration
get.edge.activity(dnet, e = 1)
```

## Conversion

```r
# To/from data frame
df <- as.data.frame(dnet)
dnet <- as.networkDynamic(df)
```
