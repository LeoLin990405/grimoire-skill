---
name: glmnet
description: R glmnet package for regularized regression. Use for lasso, ridge, and elastic-net regularization.
---

# glmnet

Lasso and elastic-net regularization.

## Basic Usage

```r
library(glmnet)

# Prepare data (matrix required)
x <- as.matrix(train[, -1])
y <- train$target

# Fit model
model <- glmnet(x, y)

# Cross-validation
cv_model <- cv.glmnet(x, y)

# Best lambda
cv_model$lambda.min      # Lambda with min error
cv_model$lambda.1se      # Lambda within 1 SE of min

# Predict
pred <- predict(cv_model, newx = as.matrix(test[, -1]), s = "lambda.min")
```

## Model Types

```r
# Ridge (alpha = 0)
model <- glmnet(x, y, alpha = 0)

# Lasso (alpha = 1)
model <- glmnet(x, y, alpha = 1)

# Elastic net (0 < alpha < 1)
model <- glmnet(x, y, alpha = 0.5)

# Logistic regression
model <- glmnet(x, y, family = "binomial")

# Multinomial
model <- glmnet(x, y, family = "multinomial")

# Poisson
model <- glmnet(x, y, family = "poisson")

# Cox
model <- glmnet(x, Surv(time, status), family = "cox")
```

## Cross-Validation

```r
# CV with specific folds
cv_model <- cv.glmnet(
  x, y,
  alpha = 1,
  nfolds = 10,
  type.measure = "mse"  # mse, deviance, class, auc, mae
)

# Plot CV results
plot(cv_model)

# Coefficients at best lambda
coef(cv_model, s = "lambda.min")
coef(cv_model, s = "lambda.1se")
```

## Coefficients

```r
# All coefficients
coef(model)

# At specific lambda
coef(model, s = 0.01)

# Non-zero coefficients
coefs <- coef(cv_model, s = "lambda.min")
coefs[coefs[, 1] != 0, ]

# Number of non-zero
sum(coef(cv_model, s = "lambda.min") != 0)
```

## Prediction

```r
# Predict response
predict(model, newx = x_test, s = 0.01)

# Predict class (classification)
predict(model, newx = x_test, s = 0.01, type = "class")

# Predict probabilities
predict(model, newx = x_test, s = 0.01, type = "response")

# Predict coefficients
predict(model, s = 0.01, type = "coefficients")

# Predict non-zero
predict(model, s = 0.01, type = "nonzero")
```

## Tuning Alpha

```r
# Grid search for alpha
alphas <- seq(0, 1, by = 0.1)
results <- data.frame(alpha = alphas, cvm = NA)

for (i in seq_along(alphas)) {
  cv <- cv.glmnet(x, y, alpha = alphas[i])
  results$cvm[i] <- min(cv$cvm)
}

best_alpha <- results$alpha[which.min(results$cvm)]
```

## Grouped Lasso

```r
# Group lasso
library(gglasso)

model <- gglasso(x, y, group = c(1, 1, 2, 2, 3, 3))
```

## Sparse Matrix

```r
library(Matrix)

# Create sparse matrix
x_sparse <- Matrix(x, sparse = TRUE)

# Fit with sparse matrix
model <- glmnet(x_sparse, y)
```
