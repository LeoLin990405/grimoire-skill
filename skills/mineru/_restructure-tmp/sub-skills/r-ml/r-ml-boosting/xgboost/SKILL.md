---
name: xgboost
description: R xgboost package for gradient boosting. Use for high-performance classification, regression, and ranking.
---

# xgboost

eXtreme Gradient Boosting.

## Basic Usage

```r
library(xgboost)

# Prepare data
dtrain <- xgb.DMatrix(data = as.matrix(train_x), label = train_y)
dtest <- xgb.DMatrix(data = as.matrix(test_x), label = test_y)

# Train
model <- xgb.train(
  params = list(
    objective = "binary:logistic",
    eval_metric = "auc",
    max_depth = 6,
    eta = 0.1
  ),
  data = dtrain,
  nrounds = 100,
  watchlist = list(train = dtrain, test = dtest),
  early_stopping_rounds = 10
)

# Predict
pred <- predict(model, dtest)
```

## Parameters

```r
params <- list(
  # Objective
  objective = "binary:logistic",     # Binary classification
  objective = "multi:softmax",       # Multiclass (returns class)
  objective = "multi:softprob",      # Multiclass (returns prob)
  objective = "reg:squarederror",    # Regression
  objective = "rank:pairwise",       # Ranking
  
  # Tree
  max_depth = 6,                     # Max tree depth
  min_child_weight = 1,              # Min sum of instance weight
  gamma = 0,                         # Min loss reduction for split
  subsample = 0.8,                   # Row sampling ratio
  colsample_bytree = 0.8,            # Column sampling per tree
  colsample_bylevel = 1,             # Column sampling per level
  colsample_bynode = 1,              # Column sampling per node
  
  # Learning
  eta = 0.1,                         # Learning rate
  lambda = 1,                        # L2 regularization
  alpha = 0,                         # L1 regularization
  
  # Evaluation
  eval_metric = "auc",               # AUC
  eval_metric = "logloss",           # Log loss
  eval_metric = "rmse",              # RMSE
  eval_metric = "mae",               # MAE
  eval_metric = "merror",            # Multiclass error
  eval_metric = "mlogloss",          # Multiclass log loss
  
  # Other
  nthread = 4,                       # Number of threads
  seed = 42                          # Random seed
)
```

## Cross-Validation

```r
cv_results <- xgb.cv(
  params = params,
  data = dtrain,
  nrounds = 1000,
  nfold = 5,
  stratified = TRUE,
  early_stopping_rounds = 50,
  print_every_n = 10
)

# Best iteration
best_nrounds <- cv_results$best_iteration
```

## Feature Importance

```r
# Importance
importance <- xgb.importance(model = model)
print(importance)

# Plot
xgb.plot.importance(importance, top_n = 20)

# SHAP values
shap <- xgb.plot.shap(data = as.matrix(train_x), model = model, top_n = 10)
```

## Save/Load

```r
# Save
xgb.save(model, "model.xgb")
saveRDS(model, "model.rds")

# Load
model <- xgb.load("model.xgb")
model <- readRDS("model.rds")
```

## Multiclass

```r
# Prepare labels (0-indexed)
train_y <- as.numeric(factor(train_y)) - 1
num_class <- length(unique(train_y))

params <- list(
  objective = "multi:softprob",
  num_class = num_class,
  eval_metric = "mlogloss"
)

model <- xgb.train(params, dtrain, nrounds = 100)

# Predict probabilities
pred_prob <- predict(model, dtest)
pred_matrix <- matrix(pred_prob, ncol = num_class, byrow = TRUE)

# Predict class
pred_class <- max.col(pred_matrix) - 1
```

## Custom Objective

```r
# Custom loss function
custom_obj <- function(preds, dtrain) {
  labels <- getinfo(dtrain, "label")
  grad <- preds - labels
  hess <- rep(1, length(labels))
  return(list(grad = grad, hess = hess))
}

model <- xgb.train(
  params = list(max_depth = 6),
  data = dtrain,
  nrounds = 100,
  obj = custom_obj
)
```
