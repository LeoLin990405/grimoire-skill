---
name: r-ml-trees
description: R tree-based models. Use for random forests, decision trees, and ensemble methods with ranger, randomForest, rpart.
---

# R Tree-Based Models

Decision trees and random forests.

## ranger (Fast Random Forest)

```r
library(ranger)

# Classification
model <- ranger(
  target ~ .,
  data = train,
  num.trees = 500,
  mtry = sqrt(ncol(train) - 1),
  importance = "impurity",
  probability = TRUE  # For probabilities
)

# Regression
model <- ranger(
  target ~ .,
  data = train,
  num.trees = 500
)

# Predictions
pred <- predict(model, test)
pred$predictions

# Variable importance
importance(model)
sort(importance(model), decreasing = TRUE)

# OOB error
model$prediction.error
```

## randomForest

```r
library(randomForest)

# Train
model <- randomForest(
  target ~ .,
  data = train,
  ntree = 500,
  mtry = 3,
  importance = TRUE
)

# Predictions
pred <- predict(model, test)
pred_prob <- predict(model, test, type = "prob")

# Variable importance
importance(model)
varImpPlot(model)

# Partial dependence
partialPlot(model, train, x.var = "feature")

# OOB error
model$err.rate[nrow(model$err.rate), ]
```

## rpart (Decision Tree)

```r
library(rpart)
library(rpart.plot)

# Train
model <- rpart(
  target ~ .,
  data = train,
  method = "class",  # or "anova" for regression
  control = rpart.control(
    minsplit = 20,
    cp = 0.01,
    maxdepth = 10
  )
)

# Plot tree
rpart.plot(model, extra = 104)

# Predictions
pred <- predict(model, test, type = "class")
pred_prob <- predict(model, test, type = "prob")

# Pruning
printcp(model)
plotcp(model)
model_pruned <- prune(model, cp = 0.02)

# Variable importance
model$variable.importance
```

## party/partykit

```r
library(partykit)

# Conditional inference tree
model <- ctree(target ~ ., data = train)
plot(model)

# Predictions
pred <- predict(model, test)

# Random forest with conditional trees
library(party)
model <- cforest(target ~ ., data = train)
```

## Ensemble with tidymodels

```r
library(tidymodels)

# Random forest
rf_spec <- rand_forest(
  mtry = tune(),
  trees = 500,
  min_n = tune()
) %>%
  set_engine("ranger", importance = "impurity") %>%
  set_mode("classification")

# Decision tree
tree_spec <- decision_tree(
  cost_complexity = tune(),
  tree_depth = tune(),
  min_n = tune()
) %>%
  set_engine("rpart") %>%
  set_mode("classification")

# Tune
tune_results <- tune_grid(
  workflow() %>% add_model(rf_spec) %>% add_formula(target ~ .),
  resamples = vfold_cv(train, v = 5),
  grid = 20
)
```

## Comparison

| Package | Speed | Features | Use Case |
|---------|-------|----------|----------|
| ranger | Fastest | Survival, probability | Large data |
| randomForest | Medium | Classic, stable | General |
| rpart | Fast | Interpretable | Single tree |
| party | Slow | Statistical tests | Research |
