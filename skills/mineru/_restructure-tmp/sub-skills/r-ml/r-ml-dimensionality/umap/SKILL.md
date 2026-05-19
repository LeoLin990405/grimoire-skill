---
name: umap
description: R umap package for UMAP. Use for Uniform Manifold Approximation and Projection visualization.
---

# umap

Uniform Manifold Approximation and Projection.

## Basic Usage

```r
library(umap)

# Run UMAP
um <- umap(data)

# Results
um$layout  # 2D coordinates

# Plot
plot(um$layout, col = labels, pch = 19)
```

## Configuration

```r
# Custom configuration
config <- umap.defaults
config$n_neighbors <- 15
config$min_dist <- 0.1
config$metric <- "euclidean"
config$n_epochs <- 200

um <- umap(data, config = config)
```

## Parameters

```r
um <- umap(data,
  n_neighbors = 15,    # Local neighborhood size

  n_components = 2,    # Output dimensions
  metric = "euclidean",
  n_epochs = 200,
  min_dist = 0.1,      # Minimum distance in embedding
  spread = 1,
  random_state = 42
)
```

## Methods

```r
# R implementation (default)
um <- umap(data, method = "naive")

# Python implementation (requires reticulate)
um <- umap(data, method = "umap-learn")
```

## Predict New Data

```r
# Fit UMAP
um <- umap(train_data)

# Transform new data
new_coords <- predict(um, new_data)
```

## From Distance Matrix

```r
# Compute distances
d <- as.matrix(dist(data))

# UMAP from distances
um <- umap(d, input = "dist")
```

## Supervised UMAP

```r
# With labels
um <- umap(data, labels = labels)
```

## With ggplot2

```r
library(ggplot2)

umap_df <- data.frame(
  x = um$layout[, 1],
  y = um$layout[, 2],
  label = labels
)

ggplot(umap_df, aes(x, y, color = label)) +
  geom_point(alpha = 0.7) +
  theme_minimal() +
  labs(title = "UMAP Projection")
```

## Parameter Tuning

```r
# n_neighbors: larger = more global structure
# min_dist: smaller = tighter clusters

# Try different parameters
params <- expand.grid(
  n_neighbors = c(5, 15, 50),
  min_dist = c(0.01, 0.1, 0.5)
)
```
