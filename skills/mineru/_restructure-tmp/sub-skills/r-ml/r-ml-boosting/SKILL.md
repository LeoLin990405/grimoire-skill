---
name: r-ml-boosting
description: R gradient boosting packages. Use for xgboost, lightgbm, gbm, and catboost.
---

# R Gradient Boosting

High-performance gradient boosting models.

## xgboost

```r
library(xgboost)

# Prepare data
dtrain <- xgb.DMatrix(data = as.matrix(train_x), label = train_y)
dtest <- xgb.DMatrix(data = as.matrix(test_x), label = test_y)

# Parameters
params <- list(
  objective = "binary:logistic",  # or "reg:squarederror"
  eval_metric = "auc",
  max_depth = 6,
  eta = 0.1,
  subsample = 0.8,
  colsample_bytree = 0.8
)

# Train with early stopping
watchlist <- list(train = dtrain, test = dtest)
model <- xgb.train(
  params = params,
  data = dtrain,
  nrounds = 1000,
  watchlist = watchlist,
  early_stopping_rounds = 50,
  verbose = 1
)

# Predictions
pred <- predict(model, dtest)

# Feature importance
importance <- xgb.importance(model = model)
xgb.plot.importance(importance, top_n = 20)

# Cross-validation
cv <- xgb.cv(
  params = params,
  data = dtrain,
  nrounds = 1000,
  nfold = 5,
  early_stopping_rounds = 50
)

# Save/load model
xgb.save(model, "model.xgb")
model <- xgb.load("model.xgb")
```

## lightgbm

```r
library(lightgbm)

# Prepare data
dtrain <- lgb.Dataset(data = as.matrix(train_x), label = train_y)
dtest <- lgb.Dataset(data = as.matrix(test_x), label = test_y, reference = dtrain)

# Parameters
params <- list(
  objective = "binary",
  metric = "auc",
  num_leaves = 31,
  learning_rate = 0.1,
  feature_fraction = 0.8,
  bagging_fraction = 0.8,
  bagging_freq = 5
)

# Train
model <- lgb.train(
  params = params,
  data = dtrain,
  nrounds = 1000,
  valids = list(test = dtest),
  early_stopping_rounds = 50
)

# Predictions
pred <- predict(model, as.matrix(test_x))

# Feature importance
importance <- lgb.importance(model)
lgb.plot.importance(importance, top_n = 20)

# Save/load
lgb.save(model, "model.lgb")
model <- lgb.load("model.lgb")
```

## gbm

```r
library(gbm)

# Train
model <- gbm(
  target ~ .,
  data = train,
  distribution = "bernoulli",  # or "gaussian"
  n.trees = 1000,
  interaction.depth = 4,
  shrinkage = 0.01,
  n.minobsinnode = 10,
  cv.folds = 5
)

# Optimal trees
best_iter <- gbm.perf(model, method = "cv")

# Predictions
pred <- predict(model, test, n.trees = best_iter, type = "response")

# Variable importance
summary(model, n.trees = best_iter)
```

## Hyperparameter Tuning

```r
# xgboost with tidymodels
library(tidymodels)

xgb_spec <- boost_tree(
  trees = 1000,
  tree_depth = tune(),
  min_n = tune(),
  loss_reduction = tune(),
  sample_size = tune(),
  mtry = tune(),
  learn_rate = tune()
) %>%
  set_engine("xgboost") %>%
  set_mode("classification")

xgb_grid <- grid_latin_hypercube(
  tree_depth(),
  min_n(),
  loss_reduction(),
  sample_size = sample_prop(),
  finalize(mtry(), train),
  learn_rate(),
  size = 30
)

tune_results <- tune_grid(
  workflow() %>% add_model(xgb_spec) %>% add_formula(target ~ .),
  resamples = vfold_cv(train, v = 5),
  grid = xgb_grid,
  metrics = metric_set(roc_auc)
)
```

## Comparison

| Package | Speed | Memory | Features |
|---------|-------|--------|----------|
| xgboost | Fast | Medium | GPU, sparse |
| lightgbm | Fastest | Low | Categorical |
| gbm | Slow | High | Simple API |
| catboost | Fast | Medium | Categorical |
