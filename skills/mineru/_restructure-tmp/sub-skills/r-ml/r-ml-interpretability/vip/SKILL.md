---
name: vip
description: R vip package for variable importance. Use for computing and visualizing variable importance scores.
---

# vip

Variable Importance Plots.

## Basic Usage

```r
library(vip)

# Variable importance plot
vip(model)

# With options
vip(model, num_features = 10)
```

## Importance Methods

```r
# Model-specific (default)
vip(model, method = "model")

# Permutation-based
vip(model, method = "permute",
  train = train_data,
  target = "y",
  metric = "rmse")

# SHAP-based
vip(model, method = "shap",
  train = train_data)

# FIRM (feature importance ranking measure)
vip(model, method = "firm",
  train = train_data)
```

## Permutation Importance

```r
# Permutation importance
vi_perm <- vi_permute(
  model,
  train = train_data,
  target = "y",
  metric = "rmse",
  nsim = 10
)

# Plot
vip(vi_perm)
```

## SHAP Importance

```r
# SHAP-based importance
vi_shap <- vi_shap(
  model,
  train = train_data
)

vip(vi_shap)
```

## Custom Metrics

```r
# Custom loss function
my_metric <- function(actual, predicted) {
  mean(abs(actual - predicted))
}

vi_permute(model, train = train_data, target = "y",
  metric = my_metric)
```

## Partial Dependence

```r
# Partial dependence plots
library(pdp)

# Single variable
partial(model, pred.var = "age", train = train_data) %>%
  autoplot()

# Two variables
partial(model, pred.var = c("age", "income"), train = train_data) %>%
  autoplot()
```

## Extract Importance

```r
# Get importance values
vi(model)

# As data frame
vi_model(model)

# Sorted
vi(model) %>%
  arrange(desc(Importance))
```

## Plotting Options

```r
vip(model,
  num_features = 10,
  geom = "point",           # or "col", "boxplot"
  aesthetics = list(
    color = "steelblue",
    fill = "steelblue"
  ))

# Horizontal
vip(model, horizontal = TRUE)

# Include zero
vip(model, include_type = TRUE)
```

## Multiple Models

```r
# Compare models
vi1 <- vi(model1)
vi2 <- vi(model2)

# Combine and plot
library(ggplot2)
bind_rows(
  mutate(vi1, model = "Model 1"),
  mutate(vi2, model = "Model 2")
) %>%
  ggplot(aes(x = reorder(Variable, Importance), y = Importance, fill = model)) +
  geom_col(position = "dodge") +
  coord_flip()
```
