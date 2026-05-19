---
name: cluster
description: R cluster package for clustering algorithms. Use for PAM, CLARA, AGNES, DIANA, and other clustering methods.
---

# cluster

Finding groups in data.

## K-Medoids (PAM)

```r
library(cluster)

# PAM clustering
pam_result <- pam(data, k = 3)

# Results
pam_result$clustering  # Cluster assignments
pam_result$medoids     # Medoid points
pam_result$silinfo     # Silhouette info

# Plot
plot(pam_result)
```

## CLARA (Large Data)

```r
# CLARA for large datasets
clara_result <- clara(data, k = 3, samples = 50)

# Results
clara_result$clustering
clara_result$medoids
```

## Hierarchical Clustering

```r
# Agglomerative (AGNES)
agnes_result <- agnes(data, method = "ward")
plot(agnes_result)
cutree(agnes_result, k = 3)

# Divisive (DIANA)
diana_result <- diana(data)
plot(diana_result)
cutree(diana_result, k = 3)
```

## Fuzzy Clustering

```r
# Fuzzy c-means
fanny_result <- fanny(data, k = 3)

# Membership matrix
fanny_result$membership

# Hard clustering
fanny_result$clustering
```

## Silhouette Analysis

```r
# Compute silhouette
sil <- silhouette(clustering, dist(data))

# Summary
summary(sil)

# Plot
plot(sil)

# Average silhouette width
mean(sil[, 3])
```

## Distance Matrix

```r
# Compute distances
d <- daisy(data)

# Mixed data types
d <- daisy(data, metric = "gower")

# With weights
d <- daisy(data, weights = c(1, 2, 1))
```

## Optimal Clusters

```r
# Gap statistic
gap_stat <- clusGap(data, FUN = pam, K.max = 10, B = 50)
plot(gap_stat)

# Optimal k
maxSE(gap_stat$Tab[, "gap"], gap_stat$Tab[, "SE.sim"])
```

## Plotting

```r
# Cluster plot
clusplot(data, clustering,
  color = TRUE,
  shade = TRUE,
  labels = 2,
  lines = 0)
```
