---
name: lobstr
description: R lobstr package for memory inspection. Use for understanding R object memory usage and structure.
---

# lobstr

Visualize R data structures.

## Object Size

```r
library(lobstr)

# Object size
obj_size(x)

# Multiple objects
obj_size(x, y)

# Shared memory
obj_size(x, y)  # May be less than obj_size(x) + obj_size(y)
```

## Object Address

```r
# Memory address
obj_addr(x)

# Check if same object
obj_addr(x) == obj_addr(y)
```

## Reference Counting

```r
# Reference count
ref(x)

# Track references
x <- 1:10
y <- x
ref(x)  # Shows 2 references
```

## AST (Abstract Syntax Tree)

```r
# View expression tree
ast(f(x, y))

# Complex expression
ast(
  if (x > 0) {
    sqrt(x)
  } else {
    -sqrt(-x)
  }
)
```

## Object Tree

```r
# View object structure
sxp(x)

# List structure
sxp(list(a = 1, b = 2))
```

## Memory Tracking

```r
# Track memory changes
x <- 1:1e6
obj_size(x)

y <- x
obj_size(x, y)  # Same memory (copy-on-modify)

y[1] <- 0L
obj_size(x, y)  # Now separate
```

## Compare Sizes

```r
# Compare object sizes
sizes <- c(
  "vector" = obj_size(1:1000),
  "list" = obj_size(as.list(1:1000)),
  "df" = obj_size(data.frame(x = 1:1000))
)
sizes
```

## Memory Efficiency

```r
# Integer vs double
obj_size(1:1000)        # Integer
obj_size(as.double(1:1000))  # Double (2x size)

# Character interning
x <- rep("hello", 1000)
obj_size(x)  # Efficient due to interning
```

## Tree Visualization

```r
# View call tree
tree(quote(f(g(x), h(y, z))))
```
