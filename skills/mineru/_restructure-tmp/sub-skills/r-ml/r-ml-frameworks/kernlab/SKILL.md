---
name: kernlab
description: R kernlab package for kernel methods. Use for support vector machines and kernel-based learning.
---

# kernlab

Kernel-based machine learning.

## Support Vector Machines

```r
library(kernlab)

# Classification
model <- ksvm(Species ~ ., data = iris, kernel = "rbfdot")

# Regression
model <- ksvm(mpg ~ ., data = mtcars, type = "eps-svr")

# Predict
pred <- predict(model, newdata = test_df)
```

## SVM Types

```r
# Classification
"C-svc"      # C-classification (default)
"nu-svc"     # Nu-classification
"C-bsvc"     # Bound-constraint classification
"spoc-svc"   # Crammer-Singer multi-class
"kbb-svc"    # Weston-Watkins multi-class

# Regression
"eps-svr"    # Epsilon-SVR
"nu-svr"     # Nu-SVR
"eps-bsvr"   # Bound-constraint epsilon-SVR

# One-class
"one-svc"    # One-class SVM (novelty detection)
```

## Kernels

```r
# RBF (Gaussian) - default
model <- ksvm(y ~ ., data = df, kernel = "rbfdot")

# Linear
model <- ksvm(y ~ ., data = df, kernel = "vanilladot")

# Polynomial
model <- ksvm(y ~ ., data = df, kernel = "polydot")

# Sigmoid
model <- ksvm(y ~ ., data = df, kernel = "tanhdot")

# Laplacian
model <- ksvm(y ~ ., data = df, kernel = "laplacedot")

# Custom kernel parameters
rbf_kernel <- rbfdot(sigma = 0.1)
model <- ksvm(y ~ ., data = df, kernel = rbf_kernel)
```

## Parameters

```r
model <- ksvm(
  y ~ .,
  data = df,
  type = "C-svc",
  kernel = "rbfdot",
  kpar = list(sigma = 0.1),  # Kernel parameters
  C = 1,                      # Cost parameter
  epsilon = 0.1,              # Epsilon for SVR
  nu = 0.2,                   # Nu parameter
  cross = 5,                  # Cross-validation folds
  prob.model = TRUE,          # Enable probability estimates
  scaled = TRUE               # Scale features
)
```

## Model Information

```r
# Summary
model

# Support vectors
SVindex(model)
alpha(model)

# Cross-validation error
cross(model)

# Fitted values
fitted(model)
```

## Probability Predictions

```r
# Enable probabilities
model <- ksvm(y ~ ., data = df, prob.model = TRUE)

# Predict probabilities
pred_prob <- predict(model, newdata = test_df, type = "probabilities")
```

## Kernel PCA

```r
# Kernel PCA
kpca_model <- kpca(~ ., data = df, kernel = "rbfdot", kpar = list(sigma = 0.1),
                   features = 2)

# Get principal components
pcv(kpca_model)

# Project new data
predict(kpca_model, newdata = new_df)

# Plot
plot(rotated(kpca_model))
```

## Spectral Clustering

```r
# Spectral clustering
sc <- specc(as.matrix(df), centers = 3)

# Get cluster assignments
sc@.Data

# With kernel
sc <- specc(as.matrix(df), centers = 3, kernel = "rbfdot")
```

## Gaussian Processes

```r
# Gaussian process regression
gp <- gausspr(y ~ ., data = df, kernel = "rbfdot")

# Predict with variance
pred <- predict(gp, newdata = test_df, type = "response")
var <- predict(gp, newdata = test_df, type = "variance")
```

## Relevance Vector Machine

```r
# RVM for regression
rvm_model <- rvm(y ~ ., data = df)

# Predict
pred <- predict(rvm_model, newdata = test_df)
```

## Kernel Matrix

```r
# Compute kernel matrix
K <- kernelMatrix(rbfdot(sigma = 0.1), as.matrix(df))

# Use pre-computed kernel
model <- ksvm(K, y, type = "C-svc", kernel = "matrix")
```

## Tuning

```r
# Manual grid search
results <- sapply(c(0.01, 0.1, 1, 10), function(C) {
  model <- ksvm(y ~ ., data = df, C = C, cross = 5)
  cross(model)
})

# Best C
best_C <- c(0.01, 0.1, 1, 10)[which.min(results)]
```
