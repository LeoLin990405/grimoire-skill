---
name: r-ml
description: R machine learning packages. Use for classification, regression, clustering, deep learning, gradient boosting (xgboost, lightgbm), random forests, neural networks, and time series forecasting.
---

# R Machine Learning Skill

## Sub-skills

| Sub-skill | Description |
|-----------|-------------|
| [r-ml-frameworks](r-ml-frameworks/SKILL.md) | tidymodels, caret, mlr3, h2o |
| [r-ml-boosting](r-ml-boosting/SKILL.md) | xgboost, lightgbm, gbm |
| [r-ml-trees](r-ml-trees/SKILL.md) | randomForest, ranger, rpart |
| [r-ml-regularization](r-ml-regularization/SKILL.md) | glmnet, lasso, elastic-net |
| [r-ml-deeplearning](r-ml-deeplearning/SKILL.md) | torch, keras, neural networks |
| [r-ml-timeseries](r-ml-timeseries/SKILL.md) | prophet, fable, forecast |
| [r-ml-survival](r-ml-survival/SKILL.md) | survival, survminer |
| [r-ml-anomaly](r-ml-anomaly/SKILL.md) | AnomalyDetection, anomalize |

Machine learning and predictive modeling in R.

## ML Frameworks

| Package | Description |
|---------|-------------|
| **caret** ★ | Classification and Regression Training |
| **mlr3** ★ | Next-gen extensible ML framework |
| **tidymodels** ★ | Tidyverse-friendly modeling |
| **h2o** | Deep learning, RF, GBM, GLM |

## Gradient Boosting

| Package | Description |
|---------|-------------|
| **xgboost** ★ | eXtreme Gradient Boosting |
| **lightgbm** ★ | Light Gradient Boosting Machine |
| **gbm** | Generalized Boosted Regression |
| **bst** | Gradient Boosting |
| **mboost** | Model-Based Boosting |
| **CoxBoost** | Cox models boosting |
| **GAMBoost** | GAM boosting |
| **gamboostLSS** | GAMLSS boosting |
| **GMMBoost** | Mixed models boosting |

## Tree-Based Methods

| Package | Description |
|---------|-------------|
| **randomForest** | Breiman's random forests |
| **ranger** ★ | Fast random forests |
| **randomForestSRC** | RF for survival/regression/classification |
| **rpart** | Recursive partitioning trees |
| **party** | Recursive partitioning lab |
| **partykit** | Partitioning toolkit |
| **C50** | C5.0 Decision Trees |
| **Cubist** | Rule-based regression |
| **evtree** | Evolutionary trees |
| **tree** | Classification/regression trees |
| **bigrf** | Big Random Forests |

## Regularization & Linear Models

| Package | Description |
|---------|-------------|
| **glmnet** ★ | Lasso and elastic-net GLMs |
| **lars** | Least Angle Regression, Lasso |
| **elasticnet** | Elastic-Net, Sparse PCA |
| **penalized** | L1/L2 penalized estimation |
| **ncvreg** | SCAD/MCP regularization |
| **grplasso** | Group Lasso |
| **grpreg** | Grouped covariates regularization |
| **L0Learn** | Best subset selection |

## Neural Networks & Deep Learning

| Package | Description |
|---------|-------------|
| **torch** ★ | PyTorch-like tensors/NNs |
| **MXNet** | Flexible GPU deep learning |
| **nnet** | Feed-forward NNs |
| **RSNNS** | Stuttgart NN Simulator |
| **keras** | Keras interface |

## Mixed Effects Models

| Package | Description |
|---------|-------------|
| **lme4** ★ | Mixed-effects models |
| **nlme** | Mixed-effects with custom covariance |
| **glmmTMB** | Generalized mixed-effects |

## Time Series & Forecasting

| Package | Description |
|---------|-------------|
| **prophet** ★ | Facebook's forecasting tool |
| **fable** | Tidy forecasting |
| **forecast** | Time series forecasting |

## Anomaly Detection

| Package | Description |
|---------|-------------|
| **AnomalyDetection** | Twitter's anomaly detection |
| **anomalize** | Tidy anomaly detection |
| **BreakoutDetection** | Twitter's breakout detection |
| **CausalImpact** | Google's causal inference |

## SVM & Kernel Methods

| Package | Description |
|---------|-------------|
| **kernlab** | Kernel-based ML lab |
| **e1071** | SVM, Naive Bayes, etc. |
| **LiblineaR** | Linear predictive models |
| **svmpath** | SVM path algorithm |
| **penalizedSVM** | Feature selection SVM |

## Clustering & Dimensionality

| Package | Description |
|---------|-------------|
| **kohonen** | Self-Organizing Maps |
| **Rsomoclu** | Parallel SOM |
| **hda** | Heteroscedastic Discriminant Analysis |
| **klaR** | Classification and visualization |

## Feature Selection

| Package | Description |
|---------|-------------|
| **Boruta** | All-relevant feature selection |
| **FSelector** | Subset-search/ranking selection |
| **varSelRF** | Variable selection with RF |

## Survival Analysis

| Package | Description |
|---------|-------------|
| **survival** ★ | Survival analysis |
| **survminer** | Survival visualization |
| **ahaz** | Additive hazards regression |

## Other

| Package | Description |
|---------|-------------|
| **arules** | Association rules mining |
| **rattle** | GUI for data mining |
| **rminer** | Simplified NN/SVM usage |
| **ROCR** | Classifier performance visualization |
| **SuperLearner** | Ensemble learning |
| **RWeka** | Weka interface |

## Quick Examples

```r
# tidymodels workflow
library(tidymodels)
split <- initial_split(df, prop = 0.8)
train <- training(split)
test <- testing(split)

model <- rand_forest(trees = 100) %>%
  set_engine("ranger") %>%
  set_mode("classification")

recipe <- recipe(target ~ ., data = train) %>%
  step_normalize(all_numeric())

workflow <- workflow() %>%
  add_model(model) %>%
  add_recipe(recipe)

fit <- workflow %>% fit(data = train)
predict(fit, test)

# xgboost
library(xgboost)
dtrain <- xgb.DMatrix(data = as.matrix(train_x), label = train_y)
model <- xgb.train(
  params = list(objective = "binary:logistic", max_depth = 6),
  data = dtrain, nrounds = 100
)

# caret
library(caret)
ctrl <- trainControl(method = "cv", number = 5)
model <- train(target ~ ., data = train, method = "rf", trControl = ctrl)
```

## Resources

- tidymodels: https://www.tidymodels.org/
- caret: https://topepo.github.io/caret/
- xgboost: https://xgboost.readthedocs.io/
- mlr3: https://mlr3.mlr-org.com/
