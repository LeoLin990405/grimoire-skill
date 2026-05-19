---
name: DALEX
description: R DALEX package for model explanations. Use for explaining complex machine learning models.
---

# DALEX

Descriptive mAchine Learning EXplanations.

## Create Explainer

```r
library(DALEX)

# Create explainer
explainer <- explain(
  model = model,
  data = train_data,
  y = train_labels,
  label = "My Model"
)
```

## Model Performance

```r
# Model performance
perf <- model_performance(explainer)
plot(perf)

# Compare models
perf1 <- model_performance(explainer1)
perf2 <- model_performance(explainer2)
plot(perf1, perf2)
```

## Variable Importance

```r
# Permutation importance
vi <- model_parts(explainer)
plot(vi)

# With options
vi <- model_parts(explainer,
  loss_function = loss_root_mean_square,
  B = 10)
```

## Partial Dependence

```r
# Partial dependence plot
pdp <- model_profile(explainer, variables = "age")
plot(pdp)

# Multiple variables
pdp <- model_profile(explainer, variables = c("age", "income"))
plot(pdp)

# Grouped
pdp <- model_profile(explainer, variables = "age", groups = "gender")
plot(pdp)
```

## Individual Predictions

```r
# Break down single prediction
bd <- predict_parts(explainer, new_observation = new_data[1, ])
plot(bd)

# SHAP values
shap <- predict_parts(explainer, new_observation = new_data[1, ],
  type = "shap")
plot(shap)
```

## Ceteris Paribus

```r
# What-if analysis
cp <- predict_profile(explainer, new_observation = new_data[1, ])
plot(cp)

# Multiple observations
cp <- predict_profile(explainer, new_observation = new_data[1:3, ])
plot(cp)
```

## Model Diagnostics

```r
# Residual diagnostics
diag <- model_diagnostics(explainer)
plot(diag)
```

## Arena (Interactive)

```r
# Interactive dashboard
library(arenar)
arena <- create_arena(live = TRUE) %>%
  push_model(explainer)
run_server(arena)
```

## Compare Models

```r
# Multiple explainers
explainer1 <- explain(model1, data, y, label = "Model 1")
explainer2 <- explain(model2, data, y, label = "Model 2")

# Compare
vi1 <- model_parts(explainer1)
vi2 <- model_parts(explainer2)
plot(vi1, vi2)
```
