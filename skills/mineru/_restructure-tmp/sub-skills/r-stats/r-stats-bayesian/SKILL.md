---
name: r-stats-bayesian
description: R Bayesian analysis with Stan, brms, rjags. Use for MCMC, posterior inference, and hierarchical models.
---

# R Bayesian Analysis

MCMC and Bayesian inference.

## brms (High-level Stan)

```r
library(brms)

# Simple regression
model <- brm(y ~ x1 + x2, data = df, family = gaussian())

# With priors
model <- brm(
  y ~ x1 + x2,
  data = df,
  prior = c(
    prior(normal(0, 10), class = "b"),
    prior(cauchy(0, 2), class = "sigma")
  ),
  chains = 4, iter = 2000, warmup = 1000
)

# Hierarchical model
model <- brm(y ~ x + (1 + x | group), data = df)

# Logistic regression
model <- brm(y ~ x, data = df, family = bernoulli())

# Results
summary(model)
plot(model)
pp_check(model)

# Posterior
posterior_samples(model)
hypothesis(model, "x1 > 0")

# Predictions
predict(model, newdata = new_df)
fitted(model)
```

## rstan

```r
library(rstan)
options(mc.cores = parallel::detectCores())

stan_code <- "
data {
  int<lower=0> N;
  vector[N] x;
  vector[N] y;
}
parameters {
  real alpha;
  real beta;
  real<lower=0> sigma;
}
model {
  alpha ~ normal(0, 10);
  beta ~ normal(0, 10);
  sigma ~ cauchy(0, 5);
  y ~ normal(alpha + beta * x, sigma);
}
"

fit <- stan(
  model_code = stan_code,
  data = list(N = nrow(df), x = df$x, y = df$y),
  chains = 4, iter = 2000
)

print(fit)
plot(fit)
traceplot(fit)
pairs(fit)

# Extract samples
samples <- extract(fit)
mean(samples$beta)
quantile(samples$beta, c(0.025, 0.975))
```

## rstanarm

```r
library(rstanarm)

# Linear regression
model <- stan_glm(y ~ x1 + x2, data = df)

# Hierarchical
model <- stan_glmer(y ~ x + (1 | group), data = df)

# Logistic
model <- stan_glm(y ~ x, data = df, family = binomial())

summary(model)
posterior_interval(model)
```

## Diagnostics

```r
library(bayesplot)

# Trace plots
mcmc_trace(as.array(model))

# Density
mcmc_dens(as.array(model))

# R-hat and ESS
mcmc_rhat(rhat(model))
mcmc_neff(neff_ratio(model))

# Posterior predictive check
pp_check(model, type = "dens_overlay")
pp_check(model, type = "stat", stat = "mean")
```

## Model Comparison

```r
# LOO-CV
loo1 <- loo(model1)
loo2 <- loo(model2)
loo_compare(loo1, loo2)

# WAIC
waic(model)

# Bayes factor
library(bridgesampling)
bf <- bayes_factor(bridge_sampler(model1), bridge_sampler(model2))
```
