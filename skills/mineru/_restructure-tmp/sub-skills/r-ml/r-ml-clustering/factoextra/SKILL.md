---
name: factoextra
description: R factoextra package for cluster visualization. Use for visualizing clustering results and PCA.
---

# factoextra

Extract and visualize multivariate analyses.

## Optimal Clusters

```r
library(factoextra)

# Elbow method
fviz_nbclust(data, kmeans, method = "wss")

# Silhouette method
fviz_nbclust(data, kmeans, method = "silhouette")

# Gap statistic
fviz_nbclust(data, kmeans, method = "gap_stat")
```

## K-Means Visualization

```r
# Perform k-means
km <- kmeans(data, centers = 3)

# Visualize clusters
fviz_cluster(km, data = data)

# With options
fviz_cluster(km, data = data,
  palette = "jco",
  ellipse.type = "convex",
  repel = TRUE,
  ggtheme = theme_minimal())
```

## Hierarchical Clustering

```r
# Compute distances
d <- dist(data)

# Hierarchical clustering
hc <- hclust(d, method = "ward.D2")

# Dendrogram
fviz_dend(hc, k = 3,
  cex = 0.5,
  color_labels_by_k = TRUE,
  rect = TRUE)

# Circular dendrogram
fviz_dend(hc, k = 3, type = "circular")

# Phylogenic
fviz_dend(hc, k = 3, type = "phylogenic")
```

## Silhouette Plot

```r
# Silhouette
sil <- silhouette(km$cluster, dist(data))

# Visualize
fviz_silhouette(sil)
```

## PCA Visualization

```r
# PCA
pca <- prcomp(data, scale = TRUE)

# Scree plot
fviz_eig(pca)

# Individuals
fviz_pca_ind(pca,
  col.ind = "cos2",
  gradient.cols = c("blue", "yellow", "red"))

# Variables
fviz_pca_var(pca,
  col.var = "contrib",
  gradient.cols = c("blue", "yellow", "red"))

# Biplot
fviz_pca_biplot(pca)
```

## Contribution

```r
# Variable contributions
fviz_contrib(pca, choice = "var", axes = 1)

# Individual contributions
fviz_contrib(pca, choice = "ind", axes = 1:2)
```

## Other Methods

```r
# PAM
pam_result <- pam(data, k = 3)
fviz_cluster(pam_result)

# CLARA
clara_result <- clara(data, k = 3)
fviz_cluster(clara_result)

# FANNY
fanny_result <- fanny(data, k = 3)
fviz_cluster(fanny_result)
```
