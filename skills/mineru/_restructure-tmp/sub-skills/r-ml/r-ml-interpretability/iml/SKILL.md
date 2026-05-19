---
name: iml
description: R iml package for interpretable ML. Use for model-agnostic interpretability methods.
---

# iml

Interpretable Machine Learning.

## Create Predictor

```r
library(iml)

# Create predictor object
predictor <- Predictor$new(
  model = model,
  data = train_data,
  y = train_labels
)
```

## Feature Importance

```r
# Permutation importance
imp <- FeatureImp$new(predictor, loss = "mse")
plot(imp)

# Results
imp$results
```

## Partial Dependence

```r
# Single feature
pdp <- FeatureEffect$new(predictor, feature = "age")
plot(pdp)

# Method options
pdp <- FeatureEffect$new(predictor, feature = "age",
  method = "pdp")      # Partial dependence
pdp <- FeatureEffect$new(predictor, feature = "age",
  method = "ale")      # Accumulated local effects
pdp <- FeatureEffect$new(predictor, feature = "age",
  method = "pdp+ice")  # PDP + ICE
```

## Feature Interactions

```r
# Two-way interaction
interact <- Interaction$new(predictor)
plot(interact)

# Specific feature
interact <- Interaction$new(predictor, feature = "age")
```

## SHAP Values

```r
# Shapley values for single prediction
shap <- Shapley$new(predictor, x.interest = new_data[1, ])
plot(shap)

# Results
shap$results
```

## LIME

```r
# Local interpretable model
lime <- LocalModel$new(predictor, x.interest = new_data[1, ])
plot(lime)

# Results
lime$results
```

## Surrogate Model

```r
# Global surrogate
tree <- TreeSurrogate$new(predictor, maxdepth = 3)
plot(tree)

# Predict with surrogate
tree$predict(new_data)
```

## Counterfactuals

```r
# What-if counterfactuals
library(counterfactuals)
cf <- Counterfactuals$new(predictor, x.interest = new_data[1, ])
cf$find_counterfactuals(desired_outcome = 1)
```

## Multiple Features

```r
# 2D PDP
pdp2d <- FeatureEffect$new(predictor,
  feature = c("age", "income"),
  method = "pdp")
plot(pdp2d)
```
