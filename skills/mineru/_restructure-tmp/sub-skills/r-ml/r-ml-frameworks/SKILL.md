---
name: r-ml-frameworks
description: R machine learning frameworks. Use for unified ML workflows with tidymodels, caret, mlr3, and h2o.
---

# R ML Frameworks

Unified machine learning workflows.

## tidymodels

```r
library(tidymodels)

# 1. Split data
set.seed(123)
split <- initial_split(df, prop = 0.8, strata = target)
train <- training(split)
test <- testing(split)

# 2. Create recipe (preprocessing)
recipe <- recipe(target ~ ., data = train) %>%
  step_normalize(all_numeric_predictors()) %>%
  step_dummy(all_nominal_predictors()) %>%
  step_zv(all_predictors()) %>%
  step_impute_median(all_numeric_predictors())

# 3. Specify model
model_spec <- rand_forest(
  mtry = tune(),
  trees = 500,
  min_n = tune()
) %>%
  set_engine("ranger") %>%
  set_mode("classification")

# 4. Create workflow
wf <- workflow() %>%
  add_recipe(recipe) %>%
  add_model(model_spec)

# 5. Cross-validation
folds <- vfold_cv(train, v = 5, strata = target)

# 6. Tune hyperparameters
tune_results <- tune_grid(
  wf,
  resamples = folds,
  grid = 20,
  metrics = metric_set(roc_auc, accuracy)
)

# 7. Select best model
best_params <- select_best(tune_results, metric = "roc_auc")
final_wf <- finalize_workflow(wf, best_params)

# 8. Final fit
final_fit <- last_fit(final_wf, split)
collect_metrics(final_fit)

# 9. Predictions
predictions <- predict(final_fit$.workflow[[1]], test)
```

## caret

```r
library(caret)

# Train control
ctrl <- trainControl(
  method = "cv",
  number = 5,
  classProbs = TRUE,
  summaryFunction = twoClassSummary
)

# Train model
model <- train(
  target ~ .,
  data = train,
  method = "rf",
  trControl = ctrl,
  tuneLength = 10,
  metric = "ROC"
)

# Results
print(model)
plot(model)

# Predictions
pred <- predict(model, test)
pred_prob <- predict(model, test, type = "prob")

# Confusion matrix
confusionMatrix(pred, test$target)

# Variable importance
varImp(model)
```

## mlr3

```r
library(mlr3)
library(mlr3learners)
library(mlr3tuning)

# Task
task <- TaskClassif$new(id = "my_task", backend = df, target = "target")

# Learner
learner <- lrn("classif.ranger", predict_type = "prob")

# Resampling
resampling <- rsmp("cv", folds = 5)

# Benchmark
design <- benchmark_grid(
  tasks = task,
  learners = list(
    lrn("classif.ranger"),
    lrn("classif.xgboost"),
    lrn("classif.log_reg")
  ),
  resamplings = resampling
)
bmr <- benchmark(design)
bmr$aggregate(msr("classif.auc"))

# Tuning
learner <- lrn("classif.ranger",
  mtry = to_tune(1, 10),
  num.trees = to_tune(100, 500)
)
instance <- tune(
  tuner = tnr("grid_search"),
  task = task,
  learner = learner,
  resampling = resampling,
  measure = msr("classif.auc")
)
```

## h2o

```r
library(h2o)
h2o.init()

# Convert to H2O frame
train_h2o <- as.h2o(train)
test_h2o <- as.h2o(test)

# AutoML
aml <- h2o.automl(
  x = predictors,
  y = "target",
  training_frame = train_h2o,
  max_runtime_secs = 300,
  nfolds = 5
)

# Best model
leader <- aml@leader
h2o.performance(leader, test_h2o)

# Predictions
pred <- h2o.predict(leader, test_h2o)

# Shutdown
h2o.shutdown(prompt = FALSE)
```

## Model Comparison

| Framework | Strengths | Use Case |
|-----------|-----------|----------|
| tidymodels | Tidy syntax, modern | General ML |
| caret | Simple, many models | Quick prototyping |
| mlr3 | Flexible, extensible | Research |
| h2o | AutoML, scalable | Production |
