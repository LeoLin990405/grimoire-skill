---
name: lightgbm
description: R lightgbm package for gradient boosting. Use for fast, distributed, high-performance gradient boosting.
---

# lightgbm

Light Gradient Boosting Machine.

## Basic Usage

```r
library(lightgbm)

# Prepare data
dtrain <- lgb.Dataset(data = as.matrix(train_x), label = train_y)
dtest <- lgb.Dataset(data = as.matrix(test_x), label = test_y, reference = dtrain)

# Train
params <- list(
  objective = "binary",
  metric = "auc",
  num_leaves = 31,
  learning_rate = 0.1
)

model <- lgb.train(
  params = params,
  data = dtrain,
  nrounds = 100,
  valids = list(test = dtest),
  early_stopping_rounds = 10
)

# Predict
pred <- predict(model, as.matrix(test_x))
```

## Parameters

```r
params <- list(
  # Objective
  objective = "binary",              # Binary classification
  objective = "multiclass",          # Multiclass
  objective = "regression",          # Regression
  objective = "lambdarank",          # Ranking
  
  # Tree
  num_leaves = 31,                   # Max leaves per tree
  max_depth = -1,                    # Max depth (-1 = no limit)
  min_data_in_leaf = 20,             # Min samples per leaf
  min_sum_hessian_in_leaf = 1e-3,    # Min sum hessian
  
  # Sampling
  bagging_fraction = 0.8,            # Row sampling
  bagging_freq = 5,                  # Bagging frequency
  feature_fraction = 0.8,            # Column sampling
  
  # Learning
  learning_rate = 0.1,               # Learning rate
  lambda_l1 = 0,                     # L1 regularization
  lambda_l2 = 0,                     # L2 regularization
  min_gain_to_split = 0,             # Min gain for split
  
  # Metric
  metric = "auc",                    # AUC
  metric = "binary_logloss",         # Log loss
  metric = "rmse",                   # RMSE
  metric = "mae",                    # MAE
  metric = "multi_logloss",          # Multiclass log loss
  
  # Other
  num_threads = 4,                   # Threads
  seed = 42,                         # Random seed
  verbose = 1                        # Verbosity
)
```

## Cross-Validation

```r
cv_results <- lgb.cv(
  params = params,
  data = dtrain,
  nrounds = 1000,
  nfold = 5,
  stratified = TRUE,
  early_stopping_rounds = 50
)

# Best iteration
best_nrounds <- cv_results$best_iter
```

## Feature Importance

```r
# Importance
importance <- lgb.importance(model)
print(importance)

# Plot
lgb.plot.importance(importance, top_n = 20)

# Interpretation
lgb.interprete(model, as.matrix(test_x[1:10, ]))
```

## Categorical Features

```r
# Specify categorical columns
dtrain <- lgb.Dataset(
  data = as.matrix(train_x),
  label = train_y,
  categorical_feature = c("cat1", "cat2")
)

# Or by index
dtrain <- lgb.Dataset(
  data = as.matrix(train_x),
  label = train_y,
  categorical_feature = c(1, 3, 5)
)
```

## Save/Load

```r
# Save
lgb.save(model, "model.lgb")
saveRDS.lgb.Booster(model, "model.rds")

# Load
model <- lgb.load("model.lgb")
model <- readRDS.lgb.Booster("model.rds")
```

## Multiclass

```r
params <- list(
  objective = "multiclass",
  num_class = 3,
  metric = "multi_logloss"
)

model <- lgb.train(params, dtrain, nrounds = 100)

# Predict probabilities
pred_prob <- predict(model, as.matrix(test_x))
pred_matrix <- matrix(pred_prob, ncol = 3, byrow = TRUE)

# Predict class
pred_class <- max.col(pred_matrix)
```
