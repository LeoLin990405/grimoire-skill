---
name: rstanarm
description: R rstanarm package for applied Bayesian regression. Use for easy Bayesian models with familiar R formula syntax.
---

# rstanarm Package

Applied Bayesian regression with Stan.

## Linear Regression

```r
library(rstanarm)
options(mc.cores = parallel::detectCores())

# Basic linear model
fit <- stan_glm(y ~ x1 + x2, data = df)

# With priors
fit <- stan_glm(y ~ x1 + x2, data = df,
  prior = normal(0, 2.5),
  prior_intercept = normal(0, 10)
)
```

## GLM Models

```r
# Logistic regression
fit <- stan_glm(y ~ x1 + x2, data = df,
  family = binomial(link = "logit"))

# Poisson
fit <- stan_glm(count ~ x1 + x2, data = df,
  family = poisson())

# Negative binomial
fit <- stan_glm(count ~ x1 + x2, data = df,
  family = neg_binomial_2())
```

## Mixed Effects

```r
# Random intercepts
fit <- stan_lmer(y ~ x1 + (1 | group), data = df)

# Random slopes
fit <- stan_lmer(y ~ x1 + (1 + x1 | group), data = df)

# GLMM
fit <- stan_glmer(y ~ x1 + (1 | group), data = df,
  family = binomial())
```

## Results

```r
# Summary
print(fit)
summary(fit)

# Coefficients
coef(fit)
fixef(fit)  # For mixed models
ranef(fit)

# Credible intervals
posterior_interval(fit, prob = 0.95)
```

## Posterior Analysis

```r
# Extract posterior
posterior <- as.matrix(fit)

# Plot
plot(fit)
plot(fit, pars = c("x1", "x2"))

# With bayesplot
library(bayesplot)
mcmc_areas(posterior, pars = c("x1", "x2"), prob = 0.95)
```

## Predictions

```r
# Posterior predictions
pred <- posterior_predict(fit, newdata = new_df)

# Expected values
epred <- posterior_epred(fit, newdata = new_df)

# Point predictions
predict(fit, newdata = new_df)
```

## Model Comparison

```r
# LOO-CV
loo1 <- loo(fit1)
loo2 <- loo(fit2)
loo_compare(loo1, loo2)

# WAIC
waic(fit)
```
