---
name: mclust
description: R mclust package for model-based clustering. Use for Gaussian mixture models and model-based clustering.
---

# mclust

Gaussian mixture modeling for model-based clustering.

## Basic Clustering

```r
library(mclust)

# Model-based clustering
mc <- Mclust(data)

# Summary
summary(mc)

# Results
mc$classification  # Cluster assignments
mc$G               # Number of clusters
mc$modelName       # Best model
mc$BIC             # BIC values
```

## Specify Clusters

```r
# Fixed number of clusters
mc <- Mclust(data, G = 3)

# Range of clusters
mc <- Mclust(data, G = 1:9)
```

## Model Selection

```r
# BIC plot
plot(mc, what = "BIC")

# Available models
# E = equal, V = variable
# I = spherical, E = diagonal, V = ellipsoidal
# EII, VII, EEI, VEI, EVI, VVI, EEE, EVE, VEE, VVE, EEV, VEV, EVV, VVV
```

## Visualization

```r
# Classification plot
plot(mc, what = "classification")

# Uncertainty plot
plot(mc, what = "uncertainty")

# Density plot
plot(mc, what = "density")

# All plots
plot(mc)
```

## Density Estimation

```r
# Density estimation
dens <- densityMclust(data)

# Plot
plot(dens, what = "density")
plot(dens, what = "persp")  # 3D
```

## Discriminant Analysis

```r
# Model-based discriminant analysis
mda <- MclustDA(train_data, train_labels)

# Predict
pred <- predict(mda, newdata = test_data)
pred$classification
```

## Dimension Reduction

```r
# Cluster with dimension reduction
mc <- MclustDR(data)

# Plot
plot(mc, what = "pairs")
plot(mc, what = "boundaries")
```

## Bootstrap

```r
# Bootstrap LRT
boot <- mclustBootstrapLRT(data, modelName = "VVV")
boot
```

## ICL Criterion

```r
# ICL (Integrated Complete-data Likelihood)
mc <- Mclust(data)
icl <- mclustICL(data)
plot(icl)
```
