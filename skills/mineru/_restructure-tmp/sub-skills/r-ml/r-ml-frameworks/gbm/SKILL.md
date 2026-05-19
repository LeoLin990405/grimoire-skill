---
name: gbm
description: R gbm package for gradient boosting. Use for gradient boosted regression and classification models.
---

# gbm

Generalized boosted regression models.

## Classification

```r
library(gbm)

# Binary classification
gbm_model <- gbm(
  target ~ .,
  data = train_df,
  distribution = "bernoulli",
  n.trees = 1000,
  interaction.depth = 3,
  shrinkage = 0.01
)

# Multi-class
gbm_model <- gbm(
  target ~ .,
  data = train_df,
  distribution = "multinomial",
  n.trees = 1000
)
```

## Regression

```r
# Gaussian (default)
gbm_model <- gbm(
  y ~ .,
  data = train_df,
  distribution = "gaussian",
  n.trees = 1000
)

# Laplace (robust)
gbm_model <- gbm(y ~ ., data = train_df, distribution = "laplace")

# Quantile regression
gbm_model <- gbm(y ~ ., data = train_df,
  distribution = list(name = "quantile", alpha = 0.5)
)
```

## Parameters

```r
gbm_model <- gbm(
  target ~ .,
  data = train_df,
  distribution = "bernoulli",
  n.trees = 1000,              # Number of trees
  interaction.depth = 3,       # Max tree depth
  shrinkage = 0.01,            # Learning rate
  n.minobsinnode = 10,         # Min obs in terminal node
  bag.fraction = 0.5,          # Subsample fraction
  train.fraction = 1.0,        # Training data fraction
  cv.folds = 5,                # Cross-validation folds
  keep.data = TRUE,
  verbose = TRUE
)
```

## Optimal Trees

```r
# With CV
gbm_model <- gbm(target ~ ., data = df, cv.folds = 5, n.trees = 5000)

# Find optimal number of trees
best_trees <- gbm.perf(gbm_model, method = "cv")

# OOB estimate
best_trees <- gbm.perf(gbm_model, method = "OOB")

# Test set
best_trees <- gbm.perf(gbm_model, method = "test")
```

## Predictions

```r
# Predict (returns on link scale for classification)
pred <- predict(gbm_model, newdata = test_df, n.trees = best_trees)

# Probability for classification
pred_prob <- predict(gbm_model, newdata = test_df,
                     n.trees = best_trees, type = "response")

# Multi-class probabilities
pred_prob <- predict(gbm_model, newdata = test_df,
                     n.trees = best_trees, type = "response")
# Returns array: [obs, class, 1]
```

## Variable Importance

```r
# Summary with importance
summary(gbm_model)

# Relative influence
summary(gbm_model, n.trees = best_trees)

# Plot
summary(gbm_model, plotit = TRUE)

# Get values
rel_inf <- relative.influence(gbm_model, n.trees = best_trees)
```

## Partial Dependence

```r
# Single variable
plot(gbm_model, i.var = 1, n.trees = best_trees)

# By variable name
plot(gbm_model, i.var = "age", n.trees = best_trees)

# Two variables (interaction)
plot(gbm_model, i.var = c(1, 2), n.trees = best_trees)

# Get partial dependence data
pd <- plot(gbm_model, i.var = 1, return.grid = TRUE)
```

## Distributions

```r
# Regression
"gaussian"      # Squared error
"laplace"       # Absolute error
"tdist"         # t-distribution
"huberized"     # Huber loss

# Classification
"bernoulli"     # Binary logistic
"adaboost"      # AdaBoost exponential
"multinomial"   # Multi-class

# Count data
"poisson"       # Poisson regression

# Survival
"coxph"         # Cox proportional hazards

# Quantile
list(name = "quantile", alpha = 0.5)
```

## Interaction Detection

```r
# Interaction strength
interact.gbm(gbm_model, data = train_df, i.var = c(1, 2))

# All pairwise interactions
for (i in 1:(ncol(train_df) - 1)) {
  for (j in (i + 1):ncol(train_df)) {
    print(interact.gbm(gbm_model, train_df, c(i, j)))
  }
}
```

## Calibration

```r
# Calibration plot for classification
calibrate.plot(
  y = test_df$target,
  p = pred_prob,
  shade.col = "lightblue"
)
```

## Stochastic GBM

```r
# Subsample rows
gbm_model <- gbm(target ~ ., data = df,
  bag.fraction = 0.5  # Use 50% of data per tree
)

# Subsample columns (not directly supported, use formula)
```
