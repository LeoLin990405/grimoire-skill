---
name: lme4
description: R lme4 package for mixed-effects models. Use for fitting linear and generalized linear mixed-effects models.
---

# lme4

Linear mixed-effects models.

## Linear Mixed Models

```r
library(lme4)

# Random intercept
model <- lmer(y ~ x + (1 | group), data = df)

# Random intercept and slope
model <- lmer(y ~ x + (1 + x | group), data = df)

# Uncorrelated random effects
model <- lmer(y ~ x + (1 | group) + (0 + x | group), data = df)

# Multiple grouping factors
model <- lmer(y ~ x + (1 | group1) + (1 | group2), data = df)

# Nested groups
model <- lmer(y ~ x + (1 | group1/group2), data = df)

# Crossed random effects
model <- lmer(y ~ x + (1 | subject) + (1 | item), data = df)
```

## Generalized Linear Mixed Models

```r
# Logistic
model <- glmer(y ~ x + (1 | group), data = df, family = binomial)

# Poisson
model <- glmer(count ~ x + (1 | group), data = df, family = poisson)

# Negative binomial
library(MASS)
model <- glmer.nb(count ~ x + (1 | group), data = df)
```

## Model Summary

```r
# Summary
summary(model)

# Fixed effects
fixef(model)
coef(summary(model))

# Random effects
ranef(model)
VarCorr(model)

# Confidence intervals
confint(model)
confint(model, method = "boot", nsim = 1000)
```

## Model Comparison

```r
# Likelihood ratio test
model1 <- lmer(y ~ x + (1 | group), data = df)
model2 <- lmer(y ~ x + z + (1 | group), data = df)
anova(model1, model2)

# AIC/BIC
AIC(model1, model2)
BIC(model1, model2)
```

## Predictions

```r
# Predictions with random effects
predict(model)
predict(model, newdata = new_df)

# Predictions without random effects (population level)
predict(model, re.form = NA)

# Predictions for new groups
predict(model, newdata = new_df, allow.new.levels = TRUE)
```

## Diagnostics

```r
# Residuals
residuals(model)
residuals(model, type = "pearson")

# Fitted values
fitted(model)

# Influence measures
influence(model)

# Plot diagnostics
plot(model)
qqnorm(resid(model))
```

## Bootstrapping

```r
# Bootstrap confidence intervals
boot_ci <- confint(model, method = "boot", nsim = 500)

# Bootstrap predictions
bootMer(model, FUN = fixef, nsim = 100)
```

## Convergence Issues

```r
# Increase iterations
model <- lmer(y ~ x + (1 | group), data = df,
  control = lmerControl(optCtrl = list(maxfun = 100000))
)

# Different optimizer
model <- lmer(y ~ x + (1 | group), data = df,
  control = lmerControl(optimizer = "bobyqa")
)

# Scale predictors
df$x_scaled <- scale(df$x)
model <- lmer(y ~ x_scaled + (1 | group), data = df)
```

## Effect Sizes

```r
# R-squared
library(MuMIn)
r.squaredGLMM(model)

# ICC
library(performance)
icc(model)
```
