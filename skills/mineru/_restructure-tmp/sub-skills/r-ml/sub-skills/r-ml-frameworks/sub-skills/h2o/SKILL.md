---
name: h2o
description: R h2o package for scalable ML. Use for distributed machine learning with AutoML and deep learning.
---

# h2o Package

Scalable machine learning platform.

## Initialize

```r
library(h2o)
h2o.init(nthreads = -1, max_mem_size = "8G")

# Import data
df_h2o <- as.h2o(df)
df_h2o <- h2o.importFile("data.csv")

# Split
splits <- h2o.splitFrame(df_h2o, ratios = c(0.8), seed = 123)
train <- splits[[1]]
test <- splits[[2]]
```

## AutoML

```r
aml <- h2o.automl(
  x = predictors,
  y = "target",
  training_frame = train,
  max_runtime_secs = 300,
  seed = 123
)

# Leaderboard
aml@leaderboard

# Best model
best <- aml@leader
h2o.performance(best, test)
```

## Individual Models

```r
# GLM
glm <- h2o.glm(x = predictors, y = "target",
  training_frame = train, family = "binomial")

# Random Forest
rf <- h2o.randomForest(x = predictors, y = "target",
  training_frame = train, ntrees = 100)

# GBM
gbm <- h2o.gbm(x = predictors, y = "target",
  training_frame = train, ntrees = 100, learn_rate = 0.1)

# XGBoost
xgb <- h2o.xgboost(x = predictors, y = "target",
  training_frame = train, ntrees = 100)

# Deep Learning
dl <- h2o.deeplearning(x = predictors, y = "target",
  training_frame = train, hidden = c(200, 200))
```

## Predictions

```r
pred <- h2o.predict(model, test)
perf <- h2o.performance(model, test)
h2o.auc(perf)
h2o.confusionMatrix(perf)
```

## Save/Load

```r
h2o.saveModel(model, path = "models/")
model <- h2o.loadModel("models/model_id")
```

## Shutdown

```r
h2o.shutdown(prompt = FALSE)
```
