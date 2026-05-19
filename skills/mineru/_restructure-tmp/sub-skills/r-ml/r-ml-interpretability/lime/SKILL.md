---
name: lime
description: R lime package for local explanations. Use for explaining individual predictions with local interpretable models.
---

# lime

Local Interpretable Model-agnostic Explanations.

## Setup

```r
library(lime)

# Create explainer
explainer <- lime(
  x = train_data,
  model = model
)
```

## Explain Predictions

```r
# Explain single prediction
explanation <- explain(
  x = new_data[1, ],
  explainer = explainer,
  n_features = 5
)

# Plot
plot_features(explanation)
```

## Multiple Predictions

```r
# Explain multiple
explanation <- explain(
  x = new_data[1:4, ],
  explainer = explainer,
  n_features = 5
)

# Plot all
plot_features(explanation)

# Plot explanations
plot_explanations(explanation)
```

## Options

```r
explanation <- explain(
  x = new_data,
  explainer = explainer,
  n_features = 5,           # Number of features
  n_labels = 1,             # Number of labels (classification)
  n_permutations = 5000,    # Permutations for sampling
  feature_select = "auto"   # Feature selection method
)
```

## Feature Selection

```r
# Methods
explanation <- explain(x, explainer, n_features = 5,
  feature_select = "auto")           # Automatic
explanation <- explain(x, explainer, n_features = 5,
  feature_select = "forward_selection")
explanation <- explain(x, explainer, n_features = 5,
  feature_select = "highest_weights")
explanation <- explain(x, explainer, n_features = 5,
  feature_select = "lasso_path")
```

## Text Data

```r
# For text classification
explainer <- lime(
  x = train_text,
  model = text_model,
  preprocess = function(x) {
    # Tokenize/vectorize text
  }
)

explanation <- explain(
  x = new_text,
  explainer = explainer,
  n_features = 10
)

# Highlight text
plot_text_explanations(explanation)
```

## Image Data

```r
# For image classification
explainer <- lime(
  x = train_images,
  model = image_model,
  preprocess = image_prep
)

explanation <- explain(
  x = new_image,
  explainer = explainer,
  n_superpixels = 50,
  weight = 10
)

plot_image_explanation(explanation)
```

## Custom Models

```r
# Define predict function
model_type.my_model <- function(x, ...) "classification"
predict_model.my_model <- function(x, newdata, ...) {
  predict(x, newdata, type = "prob")
}

# Use with lime
explainer <- lime(train_data, my_model)
```
