---
name: caret
description: R caret package for machine learning. Use for training, tuning, and evaluating classification and regression models.
---

# caret

Classification and Regression Training.

## Basic Workflow

```r
library(caret)

# Split data
set.seed(123)
trainIndex <- createDataPartition(df$target, p = 0.8, list = FALSE)
train <- df[trainIndex, ]
test <- df[-trainIndex, ]

# Train model
model <- train(
  target ~ .,
  data = train,
  method = "rf"
)

# Predict
predictions <- predict(model, test)
```

## Training Control

```r
# Cross-validation
ctrl <- trainControl(
  method = "cv",
  number = 10
)

# Repeated CV
ctrl <- trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 3
)

# Bootstrap
ctrl <- trainControl(
  method = "boot",
  number = 25
)

# Leave-one-out
ctrl <- trainControl(method = "LOOCV")

# Classification options
ctrl <- trainControl(
  method = "cv",
  number = 10,
  classProbs = TRUE,
  summaryFunction = twoClassSummary
)

model <- train(
  target ~ .,
  data = train,
  method = "rf",
  trControl = ctrl,
  metric = "ROC"
)
```

## Tuning

```r
# Default grid
model <- train(target ~ ., data = train, method = "rf")

# Custom grid
grid <- expand.grid(
  mtry = c(2, 4, 6, 8),
  splitrule = "gini",
  min.node.size = c(1, 5, 10)
)

model <- train(
  target ~ .,
  data = train,
  method = "ranger",
  tuneGrid = grid,
  trControl = ctrl
)

# Random search
ctrl <- trainControl(
  method = "cv",
  number = 10,
  search = "random"
)

model <- train(
  target ~ .,
  data = train,
  method = "rf",
  trControl = ctrl,
  tuneLength = 20
)
```

## Preprocessing

```r
# In train()
model <- train(
  target ~ .,
  data = train,
  method = "rf",
  preProcess = c("center", "scale")
)

# Options
preProcess = c("center", "scale")
preProcess = c("range")  # 0-1 scaling
preProcess = c("pca")
preProcess = c("knnImpute")
preProcess = c("medianImpute")
preProcess = c("BoxCox")
preProcess = c("YeoJohnson")

# Separate preprocessing
preProc <- preProcess(train, method = c("center", "scale"))
train_scaled <- predict(preProc, train)
test_scaled <- predict(preProc, test)
```

## Models

```r
# List available models
names(getModelInfo())

# Common methods
method = "lm"           # Linear regression
method = "glm"          # Logistic regression
method = "rf"           # Random forest
method = "ranger"       # Fast random forest
method = "xgbTree"      # XGBoost
method = "gbm"          # Gradient boosting
method = "svmRadial"    # SVM with RBF kernel
method = "svmLinear"    # Linear SVM
method = "knn"          # K-nearest neighbors
method = "rpart"        # Decision tree
method = "nnet"         # Neural network
method = "glmnet"       # Elastic net
```

## Evaluation

```r
# Confusion matrix
confusionMatrix(predictions, test$target)

# Metrics
postResample(predictions, test$target)

# Variable importance
varImp(model)
plot(varImp(model))

# Resampling results
model$results
model$bestTune

# Plot tuning
plot(model)
```

## Compare Models

```r
# Train multiple models
models <- list(
  rf = train(target ~ ., data = train, method = "rf", trControl = ctrl),
  gbm = train(target ~ ., data = train, method = "gbm", trControl = ctrl),
  svm = train(target ~ ., data = train, method = "svmRadial", trControl = ctrl)
)

# Compare
results <- resamples(models)
summary(results)
dotplot(results)
bwplot(results)
```
