---
name: mlr3
description: R mlr3 package for machine learning. Use for modern ML framework with pipelines, tuning, and benchmarking.
---

# mlr3 Package

Modern machine learning framework.

## Basic Workflow

```r
library(mlr3)
library(mlr3learners)

# Task
task <- as_task_classif(iris, target = "Species")
task <- as_task_regr(mtcars, target = "mpg")

# Learner
learner <- lrn("classif.rpart")
learner <- lrn("regr.ranger")

# Train
learner$train(task)

# Predict
prediction <- learner$predict(task)
prediction$confusion
prediction$score(msr("classif.acc"))
```

## Resampling

```r
# Cross-validation
resampling <- rsmp("cv", folds = 5)
rr <- resample(task, learner, resampling)
rr$aggregate(msr("classif.acc"))

# Holdout
resampling <- rsmp("holdout", ratio = 0.8)
```

## Hyperparameter Tuning

```r
library(mlr3tuning)

# Search space
search_space <- ps(
  cp = p_dbl(lower = 0.001, upper = 0.1),
  minsplit = p_int(lower = 1, upper = 20)
)

# Tuner
instance <- tune(
  tuner = tnr("grid_search"),
  task = task,
  learner = lrn("classif.rpart"),
  resampling = rsmp("cv", folds = 3),
  measure = msr("classif.acc"),
  search_space = search_space
)

instance$result
```

## Pipelines

```r
library(mlr3pipelines)

# Preprocessing + learner
graph <- po("scale") %>>%
  po("encode") %>>%
  lrn("classif.ranger")

graph_learner <- as_learner(graph)
graph_learner$train(task)
```

## Benchmarking

```r
design <- benchmark_grid(
  tasks = list(task1, task2),
  learners = list(lrn("classif.rpart"), lrn("classif.ranger")),
  resamplings = rsmp("cv", folds = 5)
)

bmr <- benchmark(design)
bmr$aggregate(msr("classif.acc"))
```

## Available Learners

```r
mlr_learners  # List all
as.data.table(mlr_learners)
```
