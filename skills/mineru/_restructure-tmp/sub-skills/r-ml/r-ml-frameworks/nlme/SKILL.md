---
name: nlme
description: R nlme package for mixed-effects models. Use for linear and nonlinear mixed-effects models with correlation structures.
---

# nlme

Linear and nonlinear mixed-effects models.

## Linear Mixed Models

```r
library(nlme)

# Random intercept
model <- lme(y ~ x, random = ~ 1 | group, data = df)

# Random intercept and slope
model <- lme(y ~ x, random = ~ 1 + x | group, data = df)

# Nested random effects
model <- lme(y ~ x, random = ~ 1 | group1/group2, data = df)
```

## Model Specification

```r
# Using formula
model <- lme(
  fixed = y ~ x1 + x2,
  random = ~ 1 | group,
  data = df
)

# Using pdMat classes
model <- lme(
  y ~ x,
  random = pdDiag(~ 1 + x | group),  # Diagonal covariance
  data = df
)

# Compound symmetry
model <- lme(
  y ~ x,
  random = pdCompSymm(~ 1 | group),
  data = df
)
```

## Correlation Structures

```r
# AR(1) correlation
model <- lme(y ~ x, random = ~ 1 | group,
  correlation = corAR1(form = ~ time | group),
  data = df
)

# Compound symmetry
model <- lme(y ~ x, random = ~ 1 | group,
  correlation = corCompSymm(form = ~ 1 | group),
  data = df
)

# Exponential spatial correlation
model <- lme(y ~ x, random = ~ 1 | group,
  correlation = corExp(form = ~ lat + lon | group),
  data = df
)

# General correlation
model <- lme(y ~ x, random = ~ 1 | group,
  correlation = corSymm(form = ~ 1 | group),
  data = df
)
```

## Variance Functions

```r
# Heteroscedasticity by group
model <- lme(y ~ x, random = ~ 1 | group,
  weights = varIdent(form = ~ 1 | group),
  data = df
)

# Variance proportional to fitted values
model <- lme(y ~ x, random = ~ 1 | group,
  weights = varPower(),
  data = df
)

# Exponential variance
model <- lme(y ~ x, random = ~ 1 | group,
  weights = varExp(form = ~ x),
  data = df
)

# Combined variance function
model <- lme(y ~ x, random = ~ 1 | group,
  weights = varComb(varIdent(form = ~ 1 | group), varPower()),
  data = df
)
```

## Model Summary

```r
# Summary
summary(model)

# Fixed effects
fixef(model)
fixed.effects(model)

# Random effects
ranef(model)
random.effects(model)

# Variance components
VarCorr(model)

# Confidence intervals
intervals(model)
```

## Predictions

```r
# Population level (fixed effects only)
predict(model, level = 0)

# Group level (with random effects)
predict(model, level = 1)

# New data
predict(model, newdata = new_df, level = 0)
predict(model, newdata = new_df, level = 1)
```

## Model Comparison

```r
# Likelihood ratio test
anova(model1, model2)

# AIC/BIC
AIC(model1, model2)
BIC(model1, model2)
```

## Nonlinear Mixed Models

```r
# Self-starting function
model <- nlme(
  height ~ SSasymp(age, Asym, R0, lrc),
  fixed = Asym + R0 + lrc ~ 1,
  random = Asym ~ 1 | group,
  data = df,
  start = c(Asym = 200, R0 = 10, lrc = -3)
)

# Custom model
model <- nlme(
  y ~ a * exp(-b * x),
  fixed = a + b ~ 1,
  random = a ~ 1 | group,
  data = df,
  start = c(a = 10, b = 0.1)
)
```

## Diagnostics

```r
# Residuals
residuals(model)
residuals(model, type = "normalized")
residuals(model, type = "pearson")

# Fitted values
fitted(model)
fitted(model, level = 0)  # Population
fitted(model, level = 1)  # Group

# Diagnostic plots
plot(model)
qqnorm(model)
plot(model, resid(.) ~ fitted(.) | group)
```

## Generalized Least Squares

```r
# GLS without random effects
model <- gls(y ~ x, data = df)

# With correlation structure
model <- gls(y ~ x,
  correlation = corAR1(form = ~ time | group),
  data = df
)

# With variance function
model <- gls(y ~ x,
  weights = varIdent(form = ~ 1 | group),
  data = df
)
```
