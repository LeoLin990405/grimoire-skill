---
name: Rtsne
description: R Rtsne package for t-SNE. Use for t-distributed stochastic neighbor embedding visualization.
---

# Rtsne

t-Distributed Stochastic Neighbor Embedding.

## Basic Usage

```r
library(Rtsne)

# Run t-SNE
tsne <- Rtsne(data, dims = 2, perplexity = 30)

# Results
tsne$Y  # 2D coordinates

# Plot
plot(tsne$Y, col = labels, pch = 19)
```

## Parameters

```r
tsne <- Rtsne(data,
  dims = 2,           # Output dimensions
  perplexity = 30,    # Perplexity (5-50)
  theta = 0.5,        # Speed/accuracy trade-off (0 = exact)
  max_iter = 1000,    # Iterations
  eta = 200,          # Learning rate
  pca = TRUE,         # Initial PCA
  pca_center = TRUE,
  pca_scale = FALSE,
  verbose = TRUE
)
```

## Remove Duplicates

```r
# t-SNE requires unique rows
tsne <- Rtsne(unique(data), check_duplicates = FALSE)

# Or
tsne <- Rtsne(data, check_duplicates = TRUE)  # Default
```

## From Distance Matrix

```r
# Compute distances
d <- dist(data)

# t-SNE from distances
tsne <- Rtsne(as.matrix(d), is_distance = TRUE)
```

## Reproducibility

```r
# Set seed for reproducibility
set.seed(42)
tsne <- Rtsne(data)

# Or use seed parameter
tsne <- Rtsne(data, seed = 42)
```

## Perplexity Selection

```r
# Try different perplexities
perplexities <- c(5, 10, 30, 50)

par(mfrow = c(2, 2))
for (p in perplexities) {
  tsne <- Rtsne(data, perplexity = p)
  plot(tsne$Y, main = paste("Perplexity:", p))
}
```

## With ggplot2

```r
library(ggplot2)

tsne_df <- data.frame(
  x = tsne$Y[, 1],
  y = tsne$Y[, 2],
  label = labels
)

ggplot(tsne_df, aes(x, y, color = label)) +
  geom_point() +
  theme_minimal()
```

## Large Data

```r
# Use Barnes-Hut approximation
tsne <- Rtsne(data, theta = 0.5)  # Faster

# Exact t-SNE (slow)
tsne <- Rtsne(data, theta = 0)
```
