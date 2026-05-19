---
name: rpart
description: R rpart package for decision trees. Use for recursive partitioning classification and regression trees.
---

# rpart

Recursive partitioning for decision trees.

## Classification Tree

```r
library(rpart)

# Train
tree <- rpart(Species ~ ., data = iris, method = "class")

# Predict class
pred <- predict(tree, newdata = test_df, type = "class")

# Predict probabilities
pred_prob <- predict(tree, newdata = test_df, type = "prob")
```

## Regression Tree

```r
# Train
tree <- rpart(mpg ~ ., data = mtcars, method = "anova")

# Predict
pred <- predict(tree, newdata = test_df)
```

## Control Parameters

```r
tree <- rpart(
  target ~ .,
  data = train_df,
  method = "class",           # class, anova, poisson, exp
  control = rpart.control(
    minsplit = 20,            # Min obs for split attempt
    minbucket = 7,            # Min obs in terminal node
    cp = 0.01,                # Complexity parameter
    maxdepth = 30,            # Max tree depth
    xval = 10,                # Cross-validation folds
    maxcompete = 4,           # Competing splits to display
    maxsurrogate = 5,         # Surrogate splits
    usesurrogate = 2          # How to use surrogates
  )
)
```

## Visualization

```r
# Base plot
plot(tree)
text(tree, use.n = TRUE)

# Better plot with rpart.plot
library(rpart.plot)
rpart.plot(tree)
rpart.plot(tree, extra = 104)  # Show probabilities

# Prp function
prp(tree, faclen = 0, extra = 1, roundint = FALSE)
```

## Pruning

```r
# View complexity table
printcp(tree)
plotcp(tree)

# Get optimal cp
opt_cp <- tree$cptable[which.min(tree$cptable[, "xerror"]), "CP"]

# Prune tree
pruned_tree <- prune(tree, cp = opt_cp)

# 1-SE rule
cp_1se <- tree$cptable[which.min(tree$cptable[, "xerror"]) + 1, "CP"]
pruned_tree <- prune(tree, cp = cp_1se)
```

## Variable Importance

```r
# Get importance
tree$variable.importance

# Normalized importance
importance <- tree$variable.importance / sum(tree$variable.importance)

# Plot
barplot(tree$variable.importance, las = 2)
```

## Model Summary

```r
# Summary
summary(tree)

# Print tree rules
print(tree)

# Tree structure
tree$frame
```

## Cross-Validation

```r
# Built-in CV (default xval = 10)
tree <- rpart(target ~ ., data = df)

# CV error
tree$cptable[, "xerror"]

# CV standard error
tree$cptable[, "xstd"]
```

## Handling Missing Values

```r
# Surrogate splits (default)
tree <- rpart(target ~ ., data = df)

# Predictions with missing values work automatically
pred <- predict(tree, newdata = test_df_with_na)
```

## Cost-Sensitive Learning

```r
# Loss matrix for classification
loss_matrix <- matrix(c(0, 1, 5, 0), nrow = 2)

tree <- rpart(
  target ~ .,
  data = df,
  method = "class",
  parms = list(loss = loss_matrix)
)

# Prior probabilities
tree <- rpart(
  target ~ .,
  data = df,
  method = "class",
  parms = list(prior = c(0.3, 0.7))
)
```

## Extract Rules

```r
# As text
rpart.rules(tree)

# Path to terminal nodes
path.rpart(tree, nodes = c(2, 3))
```

## Poisson Regression Tree

```r
# For count data
tree <- rpart(count ~ ., data = df, method = "poisson")
```

## Survival Tree

```r
# For survival data
library(survival)
tree <- rpart(Surv(time, status) ~ ., data = df, method = "exp")
```
