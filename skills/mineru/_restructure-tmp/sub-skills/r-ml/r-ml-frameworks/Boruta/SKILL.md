---
name: Boruta
description: R Boruta package for feature selection. Use for all-relevant feature selection using random forest.
---

# Boruta

All-relevant feature selection.

## Basic Usage

```r
library(Boruta)

# Run Boruta
boruta_result <- Boruta(target ~ ., data = df, doTrace = 2)

# With formula
boruta_result <- Boruta(y ~ x1 + x2 + x3, data = df)

# Without formula
boruta_result <- Boruta(x = df[, -1], y = df$target)
```

## Parameters

```r
boruta_result <- Boruta(
  target ~ .,
  data = df,
  maxRuns = 100,        # Max iterations
  doTrace = 2,          # Verbosity (0, 1, 2)
  holdHistory = TRUE,   # Keep importance history
  getImp = getImpRfZ    # Importance function
)
```

## Results

```r
# Summary
print(boruta_result)

# Get decisions
boruta_result$finalDecision

# Confirmed important
getSelectedAttributes(boruta_result, withTentative = FALSE)

# Including tentative
getSelectedAttributes(boruta_result, withTentative = TRUE)

# Importance scores
attStats(boruta_result)
```

## Handling Tentative

```r
# Resolve tentative features
boruta_final <- TentativeRoughFix(boruta_result)

# Get final selection
getSelectedAttributes(boruta_final)
```

## Visualization

```r
# Plot importance
plot(boruta_result)

# With labels
plot(boruta_result, las = 2, cex.axis = 0.7)

# Custom plot
plotImpHistory(boruta_result)
```

## Custom Importance

```r
# Use different importance measure
boruta_result <- Boruta(
  target ~ .,
  data = df,
  getImp = getImpRfGini  # Gini importance
)

# Custom function
my_imp <- function(x, y) {
  # Return importance vector
}
boruta_result <- Boruta(target ~ ., data = df, getImp = my_imp)
```

## With Different Models

```r
# Using ranger
library(ranger)
getImpRanger <- function(x, y) {
  rf <- ranger(y ~ ., data = data.frame(y, x), importance = "impurity")
  return(rf$variable.importance)
}

boruta_result <- Boruta(target ~ ., data = df, getImp = getImpRanger)
```

## Parallel Processing

```r
library(doParallel)
registerDoParallel(cores = 4)

boruta_result <- Boruta(
  target ~ .,
  data = df,
  doTrace = 2
)
```

## Feature Selection Workflow

```r
# 1. Run Boruta
boruta_result <- Boruta(target ~ ., data = train_df, maxRuns = 100)

# 2. Fix tentative
boruta_final <- TentativeRoughFix(boruta_result)

# 3. Get selected features
selected <- getSelectedAttributes(boruta_final)

# 4. Create formula
formula <- as.formula(paste("target ~", paste(selected, collapse = " + ")))

# 5. Train final model
final_model <- randomForest(formula, data = train_df)
```

## Comparison with Other Methods

```r
# Boruta vs RFE
# Boruta: finds ALL relevant features
# RFE: finds MINIMAL optimal subset

# Boruta is better when:
# - You want to understand all important features
# - Feature interpretation is important
# - You have correlated features
```
