---
name: tidymodels
description: R tidymodels package for machine learning. Use for modeling workflows with recipes, parsnip, tune, and yardstick.
---

# tidymodels

Tidy machine learning framework.

## Workflow

```r
library(tidymodels)

# 1. Split data
split <- initial_split(df, prop = 0.8, strata = target)
train <- training(split)
test <- testing(split)

# 2. Create recipe
recipe <- recipe(target ~ ., data = train) %>%
  step_normalize(all_numeric_predictors()) %>%
  step_dummy(all_nominal_predictors())

# 3. Specify model
model <- rand_forest(trees = 100) %>%
  set_engine("ranger") %>%
  set_mode("classification")

# 4. Create workflow
wf <- workflow() %>%
  add_recipe(recipe) %>%
  add_model(model)

# 5. Fit
fit <- wf %>% fit(data = train)

# 6. Predict
predictions <- predict(fit, test)
```

## Recipes

```r
recipe(target ~ ., data = train) %>%
  # Imputation
  step_impute_mean(all_numeric_predictors()) %>%
  step_impute_mode(all_nominal_predictors()) %>%
  step_impute_knn(all_predictors()) %>%
  
  # Transformation
  step_normalize(all_numeric_predictors()) %>%
  step_scale(all_numeric_predictors()) %>%
  step_center(all_numeric_predictors()) %>%
  step_log(value, base = 10) %>%
  step_sqrt(value) %>%
  step_BoxCox(all_numeric_predictors()) %>%
  step_YeoJohnson(all_numeric_predictors()) %>%
  
  # Encoding
  step_dummy(all_nominal_predictors()) %>%
  step_other(category, threshold = 0.05) %>%
  step_novel(all_nominal_predictors()) %>%
  step_unknown(all_nominal_predictors()) %>%
  
  # Feature engineering
  step_interact(~ x1:x2) %>%
  step_poly(x, degree = 2) %>%
  step_ns(x, deg_free = 3) %>%
  step_date(date, features = c("dow", "month", "year")) %>%
  
  # Selection
  step_zv(all_predictors()) %>%
  step_nzv(all_predictors()) %>%
  step_corr(all_numeric_predictors(), threshold = 0.9) %>%
  step_pca(all_numeric_predictors(), num_comp = 5) %>%
  step_select(x1, x2, x3)
```

## Models (parsnip)

```r
# Linear models
linear_reg() %>% set_engine("lm")
logistic_reg() %>% set_engine("glm")
logistic_reg(penalty = 0.1, mixture = 0.5) %>% set_engine("glmnet")

# Trees
decision_tree() %>% set_engine("rpart")
rand_forest(trees = 100, mtry = 5, min_n = 10) %>% set_engine("ranger")
boost_tree(trees = 100, learn_rate = 0.1) %>% set_engine("xgboost")

# SVM
svm_rbf(cost = 1, rbf_sigma = 0.1) %>% set_engine("kernlab")
svm_linear() %>% set_engine("kernlab")

# Neural network
mlp(hidden_units = 10, penalty = 0.01) %>% set_engine("nnet")

# Set mode
set_mode("classification")
set_mode("regression")
```

## Tuning

```r
# Specify tunable parameters
model <- rand_forest(
  trees = 100,
  mtry = tune(),
  min_n = tune()
) %>%
  set_engine("ranger") %>%
  set_mode("classification")

# Create folds
folds <- vfold_cv(train, v = 5, strata = target)

# Grid search
grid <- grid_regular(
  mtry(range = c(2, 10)),
  min_n(range = c(2, 20)),
  levels = 5
)

# Tune
tune_results <- tune_grid(
  wf,
  resamples = folds,
  grid = grid,
  metrics = metric_set(accuracy, roc_auc)
)

# Best parameters
best <- select_best(tune_results, metric = "roc_auc")
final_wf <- finalize_workflow(wf, best)
```

## Evaluation (yardstick)

```r
# Metrics
predictions %>%
  bind_cols(test) %>%
  metrics(truth = target, estimate = .pred_class)

# Classification
accuracy(data, truth, estimate)
precision(data, truth, estimate)
recall(data, truth, estimate)
f_meas(data, truth, estimate)
roc_auc(data, truth, .pred_class)
conf_mat(data, truth, estimate)

# Regression
rmse(data, truth, estimate)
mae(data, truth, estimate)
rsq(data, truth, estimate)
mape(data, truth, estimate)

# ROC curve
roc_curve(data, truth, .pred_class) %>% autoplot()
```

## Resampling

```r
# Cross-validation
vfold_cv(data, v = 10)
vfold_cv(data, v = 5, repeats = 3)
vfold_cv(data, v = 5, strata = target)

# Bootstrap
bootstraps(data, times = 25)

# Leave-one-out
loo_cv(data)

# Monte Carlo
mc_cv(data, prop = 0.8, times = 25)
```
