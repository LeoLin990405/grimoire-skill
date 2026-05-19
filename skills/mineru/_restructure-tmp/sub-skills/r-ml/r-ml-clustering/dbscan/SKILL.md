---
name: dbscan
description: R dbscan package for density-based clustering. Use for DBSCAN, OPTICS, and HDBSCAN clustering.
---

# dbscan

Density-based clustering algorithms.

## DBSCAN

```r
library(dbscan)

# DBSCAN clustering
db <- dbscan(data, eps = 0.5, minPts = 5)

# Results
db$cluster  # 0 = noise
db$eps
db$minPts

# Plot
plot(data, col = db$cluster + 1L)
hullplot(data, db)
```

## Finding eps

```r
# k-nearest neighbor distances
kNNdist(data, k = 5)

# Plot to find elbow
kNNdistplot(data, k = 5)
abline(h = 0.5, col = "red")
```

## OPTICS

```r
# OPTICS ordering
opt <- optics(data, eps = 10, minPts = 5)

# Reachability plot
plot(opt)

# Extract clusters
db <- extractDBSCAN(opt, eps_cl = 0.5)
db <- extractXi(opt, xi = 0.05)

# Plot
hullplot(data, db)
```

## HDBSCAN

```r
# Hierarchical DBSCAN
hdb <- hdbscan(data, minPts = 5)

# Results
hdb$cluster
hdb$membership_prob
hdb$outlier_scores

# Plot
plot(hdb)
plot(hdb, show_flat = TRUE)
```

## LOF (Local Outlier Factor)

```r
# Compute LOF scores
lof_scores <- lof(data, minPts = 5)

# Higher scores = more outlier-like
plot(data, cex = lof_scores)
```

## k-NN

```r
# k-nearest neighbors
nn <- kNN(data, k = 5)

# Results
nn$id    # Neighbor indices
nn$dist  # Distances

# Shared nearest neighbors
snn <- sNN(data, k = 5)
```

## Framing

```r
# Points in eps-neighborhood
frNN(data, eps = 0.5)
```

## Predict

```r
# Predict cluster for new points
predict(db, newdata = new_data, data = data)
```

## With Large Data

```r
# Use index for speed
db <- dbscan(data, eps = 0.5, minPts = 5,
  search = "kdtree")  # or "linear", "dist"
```
