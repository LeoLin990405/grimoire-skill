---
name: irlba
description: R irlba package for fast SVD/PCA. Use for truncated SVD and PCA on large matrices.
---

# irlba

Fast truncated SVD and PCA.

## Truncated SVD

```r
library(irlba)

# Compute top 5 singular vectors
svd_result <- irlba(A, nv = 5)

# Results
svd_result$u  # Left singular vectors
svd_result$v  # Right singular vectors
svd_result$d  # Singular values
```

## Fast PCA

```r
# PCA via SVD
pca <- prcomp_irlba(data, n = 5)

# Results
pca$x         # Scores (rotated data)
pca$rotation  # Loadings
pca$sdev      # Standard deviations
pca$center    # Means
pca$scale     # Scales

# Predict
predict(pca, newdata = new_data)
```

## Options

```r
# With centering and scaling
pca <- prcomp_irlba(data, n = 5,
  center = TRUE,
  scale. = TRUE)

# More iterations for accuracy
svd_result <- irlba(A, nv = 5, maxit = 1000)
```

## Sparse Matrices

```r
library(Matrix)

# Create sparse matrix
sparse_A <- Matrix(A, sparse = TRUE)

# SVD on sparse matrix
svd_result <- irlba(sparse_A, nv = 5)
```

## Partial SVD

```r
# Only left vectors
svd_result <- irlba(A, nv = 5, nu = 0)

# Only right vectors
svd_result <- irlba(A, nv = 5, nv = 0)
```

## Augmented Implicitly Restarted

```r
# For better convergence
svd_result <- irlba(A, nv = 5,
  work = 20,      # Working subspace size
  reorth = TRUE)  # Reorthogonalization
```

## Comparison with Base R

```r
# Base R (computes all)
svd_full <- svd(A)

# irlba (computes only top k)
svd_partial <- irlba(A, nv = 5)

# Much faster for large matrices
```

## Low-Rank Approximation

```r
# Reconstruct matrix
svd_result <- irlba(A, nv = 5)
A_approx <- svd_result$u %*% diag(svd_result$d) %*% t(svd_result$v)
```
