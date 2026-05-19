---
name: randomForest
description: R randomForest package for random forest models. Use for classification and regression with ensemble of decision trees.
---

# randomForest

Random forest for classification and regression.

## Classification

```r
library(randomForest)

# Train classifier
rf <- randomForest(Species ~ ., data = iris, ntree = 500)

# With formula
rf <- randomForest(target ~ ., data = train_df)

# Without formula
rf <- randomForest(x = train_x, y = train_y)

# Predict
pred <- predict(rf, newdata = test_df)
pred_prob <- predict(rf, newdata = test_df, type = "prob")
```

## Regression

```r
# Train regressor
rf <- randomForest(mpg ~ ., data = mtcars, ntree = 500)

# Predict
pred <- predict(rf, newdata = test_df)
```

## Parameters

```r
rf <- randomForest(
  target ~ .,
  data = train_df,
  ntree = 500,           # Number of trees
  mtry = 3,              # Variables per split (sqrt(p) for class, p/3 for reg)
  nodesize = 1,          # Min terminal node size
  maxnodes = NULL,       # Max terminal nodes
  importance = TRUE,     # Calculate importance
  proximity = FALSE,     # Calculate proximity matrix
  sampsize = nrow(df),   # Sample size per tree
  replace = TRUE,        # Sample with replacement
  classwt = NULL,        # Class weights
  cutoff = c(0.5, 0.5),  # Class probability cutoffs
  strata = NULL,         # Stratification variable
  na.action = na.omit
)
```

## Variable Importance

```r
# Enable importance
rf <- randomForest(target ~ ., data = df, importance = TRUE)

# Get importance
importance(rf)
importance(rf, type = 1)  # Mean decrease accuracy
importance(rf, type = 2)  # Mean decrease Gini

# Plot importance
varImpPlot(rf)
varImpPlot(rf, n.var = 10)  # Top 10
```

## Model Evaluation

```r
# OOB error
rf$err.rate[nrow(rf$err.rate), ]

# Confusion matrix
rf$confusion

# Plot error vs trees
plot(rf)

# Predictions
rf$predicted
```

## Tuning mtry

```r
# Find optimal mtry
tuneRF(
  x = train_x,
  y = train_y,
  mtryStart = 3,
  ntreeTry = 100,
  stepFactor = 1.5,
  improve = 0.01,
  trace = TRUE,
  plot = TRUE
)
```

## Partial Dependence

```r
# Partial dependence plot
partialPlot(rf, pred.data = train_df, x.var = "age")

# For classification
partialPlot(rf, pred.data = train_df, x.var = "age", which.class = "Yes")
```

## Proximity Matrix

```r
# Calculate proximity
rf <- randomForest(target ~ ., data = df, proximity = TRUE)

# Get proximity matrix
rf$proximity

# MDS plot
MDSplot(rf, df$target)
```

## Handling Imbalanced Data

```r
# Class weights
rf <- randomForest(target ~ ., data = df,
  classwt = c("No" = 1, "Yes" = 10)
)

# Stratified sampling
rf <- randomForest(target ~ ., data = df,
  strata = df$target,
  sampsize = c(100, 100)
)

# Cutoff adjustment
rf <- randomForest(target ~ ., data = df,
  cutoff = c(0.7, 0.3)
)
```

## Missing Values

```r
# Impute missing values
df_imputed <- rfImpute(target ~ ., data = df)

# Na rough fix
rf <- randomForest(target ~ ., data = df, na.action = na.roughfix)
```

## Combining Forests

```r
# Combine multiple forests
rf1 <- randomForest(target ~ ., data = df1, ntree = 250)
rf2 <- randomForest(target ~ ., data = df2, ntree = 250)
rf_combined <- combine(rf1, rf2)
```
