---
name: r-ml-regularization
description: R regularized regression. Use for lasso, ridge, elastic-net with glmnet, and penalized regression.
---

# R Regularized Regression

Lasso, ridge, and elastic-net models.

## glmnet

```r
library(glmnet)

# Prepare data (matrix format required)
x <- as.matrix(train[, -which(names(train) == "target")])
y <- train$target

# Ridge regression (alpha = 0)
ridge <- glmnet(x, y, alpha = 0)

# Lasso regression (alpha = 1)
lasso <- glmnet(x, y, alpha = 1)

# Elastic-net (0 < alpha < 1)
enet <- glmnet(x, y, alpha = 0.5)

# Cross-validation for lambda
cv_lasso <- cv.glmnet(x, y, alpha = 1, nfolds = 10)
plot(cv_lasso)

# Best lambda
cv_lasso$lambda.min      # Minimum CV error
cv_lasso$lambda.1se      # 1 SE rule (more regularization)

# Coefficients at best lambda
coef(cv_lasso, s = "lambda.min")

# Predictions
x_test <- as.matrix(test[, -which(names(test) == "target")])
pred <- predict(cv_lasso, newx = x_test, s = "lambda.min")

# Classification (logistic)
cv_logistic <- cv.glmnet(x, y, family = "binomial", alpha = 1)
pred_prob <- predict(cv_logistic, newx = x_test, s = "lambda.min", type = "response")

# Multinomial
cv_multi <- cv.glmnet(x, y, family = "multinomial", alpha = 1)

# Poisson
cv_poisson <- cv.glmnet(x, y, family = "poisson", alpha = 1)
```

## Feature Selection with Lasso

```r
# Fit lasso
cv_lasso <- cv.glmnet(x, y, alpha = 1)

# Non-zero coefficients
coefs <- coef(cv_lasso, s = "lambda.min")
selected <- rownames(coefs)[coefs[, 1] != 0]
selected <- selected[selected != "(Intercept)"]

# Coefficient path
plot(lasso, xvar = "lambda", label = TRUE)
```

## Grouped Lasso

```r
library(grpreg)

# Define groups
group <- c(1, 1, 2, 2, 2, 3, 3)  # Feature group assignments

# Fit
model <- grpreg(x, y, group, penalty = "grLasso")

# Cross-validation
cv_model <- cv.grpreg(x, y, group, penalty = "grLasso")
plot(cv_model)

# Coefficients
coef(cv_model, s = "lambda.min")
```

## Adaptive Lasso

```r
# Step 1: Get initial weights from ridge
ridge <- cv.glmnet(x, y, alpha = 0)
ridge_coef <- coef(ridge, s = "lambda.min")[-1]
weights <- 1 / abs(ridge_coef)

# Step 2: Adaptive lasso
adaptive_lasso <- cv.glmnet(x, y, alpha = 1, penalty.factor = weights)
```

## tidymodels Integration

```r
library(tidymodels)

# Lasso specification
lasso_spec <- linear_reg(
  penalty = tune(),
  mixture = 1  # 1 = lasso, 0 = ridge
) %>%
  set_engine("glmnet")

# Ridge specification
ridge_spec <- linear_reg(
  penalty = tune(),
  mixture = 0
) %>%
  set_engine("glmnet")

# Elastic-net
enet_spec <- linear_reg(
  penalty = tune(),
  mixture = tune()
) %>%
  set_engine("glmnet")

# Tune
tune_results <- tune_grid(
  workflow() %>% add_model(enet_spec) %>% add_formula(target ~ .),
  resamples = vfold_cv(train, v = 5),
  grid = grid_regular(penalty(), mixture(), levels = 10)
)
```

## Comparison

| Method | alpha | Effect |
|--------|-------|--------|
| Ridge | 0 | Shrinks all coefficients |
| Lasso | 1 | Sparse (feature selection) |
| Elastic-net | 0-1 | Balance of both |
