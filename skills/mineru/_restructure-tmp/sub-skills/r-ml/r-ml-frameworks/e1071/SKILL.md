---
name: e1071
description: R e1071 package for SVM and misc functions. Use for support vector machines, naive Bayes, and clustering.
---

# e1071

Support vector machines and misc statistical functions.

## Support Vector Machines

```r
library(e1071)

# Classification
svm_model <- svm(Species ~ ., data = iris)

# Regression
svm_model <- svm(mpg ~ ., data = mtcars)

# Predict
pred <- predict(svm_model, newdata = test_df)
```

## SVM Parameters

```r
svm_model <- svm(
  target ~ .,
  data = train_df,
  type = "C-classification",  # C-classification, nu-classification, eps-regression, nu-regression
  kernel = "radial",          # linear, polynomial, radial, sigmoid
  cost = 1,                   # Cost of constraints violation
  gamma = 1/ncol(df),         # Kernel parameter
  epsilon = 0.1,              # Epsilon for regression
  degree = 3,                 # Polynomial degree
  coef0 = 0,                  # Kernel coefficient
  scale = TRUE,               # Scale features
  probability = TRUE          # Enable probability estimates
)
```

## Kernel Types

```r
# Linear kernel
svm(target ~ ., data = df, kernel = "linear")

# Radial basis function (RBF)
svm(target ~ ., data = df, kernel = "radial", gamma = 0.1)

# Polynomial
svm(target ~ ., data = df, kernel = "polynomial", degree = 3)

# Sigmoid
svm(target ~ ., data = df, kernel = "sigmoid")
```

## Probability Predictions

```r
# Enable probabilities
svm_model <- svm(target ~ ., data = df, probability = TRUE)

# Get probabilities
pred <- predict(svm_model, newdata = test_df, probability = TRUE)
probs <- attr(pred, "probabilities")
```

## Tuning

```r
# Grid search
tune_result <- tune(
  svm,
  target ~ .,
  data = train_df,
  ranges = list(
    cost = c(0.1, 1, 10, 100),
    gamma = c(0.01, 0.1, 1)
  ),
  tunecontrol = tune.control(sampling = "cross", cross = 5)
)

# Best model
best_model <- tune_result$best.model

# Best parameters
tune_result$best.parameters

# Performance summary
summary(tune_result)
plot(tune_result)
```

## Naive Bayes

```r
# Train
nb_model <- naiveBayes(Species ~ ., data = iris)

# Predict
pred <- predict(nb_model, newdata = test_df)
pred_prob <- predict(nb_model, newdata = test_df, type = "raw")

# With Laplace smoothing
nb_model <- naiveBayes(target ~ ., data = df, laplace = 1)
```

## Clustering

```r
# Fuzzy c-means
result <- cmeans(data, centers = 3, iter.max = 100, m = 2)

# Cluster assignments
result$cluster

# Membership matrix
result$membership

# Cluster centers
result$centers
```

## Statistical Functions

```r
# Skewness
skewness(x)

# Kurtosis
kurtosis(x)

# Moment
moment(x, order = 3, center = TRUE)

# Hamming distance
hamming.distance(x, y)
```

## Cross-Validation

```r
# Built-in cross-validation
svm_model <- svm(target ~ ., data = df, cross = 10)

# CV accuracy
svm_model$tot.accuracy
```

## Multi-class SVM

```r
# One-vs-one (default)
svm_model <- svm(Species ~ ., data = iris)

# Predict
pred <- predict(svm_model, newdata = test_df)
```

## Feature Scaling

```r
# Auto-scaling (default)
svm_model <- svm(target ~ ., data = df, scale = TRUE)

# No scaling
svm_model <- svm(target ~ ., data = df, scale = FALSE)

# Manual scaling
df_scaled <- scale(df[, -1])
```
