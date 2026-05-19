---
name: brms
description: R brms package for Bayesian regression. Use for fitting Bayesian models with Stan backend.
---

# brms

Bayesian regression models using Stan.

## Basic Models

```r
library(brms)

# Linear regression
model <- brm(y ~ x1 + x2, data = df)

# With family
model <- brm(y ~ x, data = df, family = gaussian())
model <- brm(y ~ x, data = df, family = bernoulli())
model <- brm(y ~ x, data = df, family = poisson())
model <- brm(y ~ x, data = df, family = negbinomial())

# Hierarchical model
model <- brm(y ~ x + (1 | group), data = df)
model <- brm(y ~ x + (1 + x | group), data = df)
```

## Priors

```r
# Get default priors
get_prior(y ~ x + (1 | group), data = df)

# Set priors
priors <- c(
  prior(normal(0, 10), class = "b"),
  prior(normal(0, 5), class = "b", coef = "x"),
  prior(cauchy(0, 2), class = "sd"),
  prior(cauchy(0, 5), class = "sigma"),
  prior(lkj(2), class = "cor")
)

model <- brm(y ~ x + (1 | group), data = df, prior = priors)

# Prior distributions
prior(normal(0, 10), class = "b")
prior(student_t(3, 0, 10), class = "b")
prior(cauchy(0, 2), class = "sd")
prior(exponential(1), class = "sigma")
prior(uniform(0, 100), class = "sigma")
prior(lkj(2), class = "cor")
```

## MCMC Settings

```r
model <- brm(
  y ~ x,
  data = df,
  chains = 4,
  iter = 2000,
  warmup = 1000,
  thin = 1,
  cores = 4,
  seed = 1234,
  control = list(adapt_delta = 0.95, max_treedepth = 15)
)
```

## Model Summary

```r
# Summary
summary(model)

# Fixed effects
fixef(model)

# Random effects
ranef(model)

# Variance components
VarCorr(model)

# Posterior samples
as_draws_df(model)
posterior_samples(model)
```

## Diagnostics

```r
# Trace plots
plot(model)
mcmc_trace(as_draws_df(model))

# R-hat and ESS
rhat(model)
neff_ratio(model)

# Posterior predictive check
pp_check(model)
pp_check(model, type = "dens_overlay")
pp_check(model, type = "stat", stat = "mean")
pp_check(model, type = "scatter_avg")

# LOO-CV
loo(model)
```

## Predictions

```r
# Fitted values
fitted(model)

# Predictions
predict(model)
predict(model, newdata = new_df)

# Posterior predictions
posterior_predict(model)
posterior_epred(model)

# Conditional effects
conditional_effects(model)
plot(conditional_effects(model))
```

## Model Comparison

```r
# LOO comparison
loo1 <- loo(model1)
loo2 <- loo(model2)
loo_compare(loo1, loo2)

# WAIC
waic(model)

# Bayes factor
bayes_factor(model1, model2)
```

## Hypothesis Testing

```r
# Hypothesis
hypothesis(model, "x > 0")
hypothesis(model, "x1 > x2")
hypothesis(model, "x = 0")

# Evidence ratio
hypothesis(model, "x > 0")$hypothesis$Evid.Ratio
```

## Advanced Models

```r
# Non-linear
model <- brm(
  bf(y ~ a * exp(-b * x), a ~ 1, b ~ 1, nl = TRUE),
  data = df,
  prior = c(
    prior(normal(1, 1), nlpar = "a"),
    prior(normal(0.5, 0.5), nlpar = "b")
  )
)

# Multivariate
model <- brm(
  mvbind(y1, y2) ~ x,
  data = df
)

# Ordinal
model <- brm(y ~ x, data = df, family = cumulative())

# Zero-inflated
model <- brm(y ~ x, data = df, family = zero_inflated_poisson())
```
