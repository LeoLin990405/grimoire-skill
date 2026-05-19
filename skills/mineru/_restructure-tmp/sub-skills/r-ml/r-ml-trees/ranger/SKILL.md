---
name: ranger
description: R ranger package for random forests. Use for fast implementation of random forests for classification and regression.
---

# ranger

Fast random forests.

## Basic Usage

```r
library(ranger)

# Classification
model <- ranger(
  formula = target ~ .,
  data = train,
  num.trees = 500,
  importance = "impurity"
)

# Regression
model <- ranger(
  formula = value ~ .,
  data = train,
  num.trees = 500
)

# Predict
pred <- predict(model, test)
pred$predictions
```

## Parameters

```r
model <- ranger(
  formula = target ~ .,
  data = train,
  
  # Trees
  num.trees = 500,                   # Number of trees
  mtry = NULL,                       # Variables per split (default: sqrt(p))
  min.node.size = 1,                 # Min node size (1 class, 5 reg)
  max.depth = NULL,                  # Max depth (NULL = unlimited)
  
  # Sampling
  sample.fraction = 1,               # Sample fraction
  replace = TRUE,                    # Sample with replacement
  case.weights = NULL,               # Case weights
  
  # Importance
  importance = "none",               # none, impurity, impurity_corrected, permutation
  
  # Probability
  probability = FALSE,               # Probability forest
  
  # Other
  num.threads = NULL,                # Threads (NULL = all)
  seed = NULL,                       # Random seed
  verbose = TRUE,                    # Verbose output
  write.forest = TRUE                # Save forest
)
```

## Probability Prediction

```r
# Train probability forest
model <- ranger(
  formula = target ~ .,
  data = train,
  probability = TRUE
)

# Predict probabilities
pred <- predict(model, test)
pred$predictions  # Matrix of probabilities
```

## Feature Importance

```r
# Impurity importance
model <- ranger(target ~ ., data = train, importance = "impurity")
importance(model)

# Permutation importance
model <- ranger(target ~ ., data = train, importance = "permutation")
importance(model)

# Plot
barplot(sort(importance(model), decreasing = TRUE)[1:20])
```

## Survival Analysis

```r
library(survival)

# Survival forest
model <- ranger(
  formula = Surv(time, status) ~ .,
  data = train,
  num.trees = 500
)

# Predict survival
pred <- predict(model, test)
pred$survival  # Survival probabilities
pred$unique.death.times  # Time points
```

## Quantile Regression

```r
# Quantile regression forest
model <- ranger(
  formula = value ~ .,
  data = train,
  quantreg = TRUE
)

# Predict quantiles
pred <- predict(model, test, type = "quantiles", quantiles = c(0.1, 0.5, 0.9))
pred$predictions
```

## Out-of-Bag Error

```r
# OOB error
model$prediction.error

# OOB predictions
model <- ranger(target ~ ., data = train, keep.inbag = TRUE)
model$predictions  # OOB predictions
```

## Tuning

```r
# Grid search
results <- expand.grid(
  mtry = c(2, 4, 6, 8),
  min.node.size = c(1, 5, 10),
  error = NA
)

for (i in 1:nrow(results)) {
  model <- ranger(
    target ~ ., data = train,
    mtry = results$mtry[i],
    min.node.size = results$min.node.size[i]
  )
  results$error[i] <- model$prediction.error
}

results[which.min(results$error), ]
```
