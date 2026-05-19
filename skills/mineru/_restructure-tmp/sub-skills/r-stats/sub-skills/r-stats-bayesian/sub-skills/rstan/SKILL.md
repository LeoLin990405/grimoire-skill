---
name: rstan
description: R rstan package for Stan interface. Use for full Bayesian inference with Stan probabilistic programming.
---

# rstan Package

R interface to Stan for Bayesian inference.

## Basic Model

```r
library(rstan)
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

# Stan model code
stan_code <- "
data {
  int<lower=0> N;
  vector[N] y;
}
parameters {
  real mu;
  real<lower=0> sigma;
}
model {
  mu ~ normal(0, 10);
  sigma ~ cauchy(0, 5);
  y ~ normal(mu, sigma);
}
"

# Fit model
fit <- stan(model_code = stan_code,
  data = list(N = length(y), y = y),
  iter = 2000,
  chains = 4
)
```

## From File

```r
# Save as model.stan
fit <- stan(file = "model.stan", data = stan_data)
```

## Extract Results

```r
# Summary
print(fit)
summary(fit)$summary

# Extract samples
samples <- extract(fit)
samples$mu
samples$sigma

# As array
posterior <- as.array(fit)
```

## Diagnostics

```r
# Trace plots
traceplot(fit)
traceplot(fit, pars = c("mu", "sigma"))

# Pairs plot
pairs(fit, pars = c("mu", "sigma"))

# R-hat and ESS
summary(fit)$summary[, c("Rhat", "n_eff")]

# Check divergences
check_divergences(fit)
check_treedepth(fit)
```

## Posterior Analysis

```r
library(bayesplot)

# Density
mcmc_dens(as.array(fit), pars = c("mu", "sigma"))

# Intervals
mcmc_intervals(as.array(fit), pars = c("mu", "sigma"))

# Areas
mcmc_areas(as.array(fit), pars = c("mu", "sigma"), prob = 0.95)
```

## Generated Quantities

```stan
generated quantities {
  vector[N] y_rep;
  for (n in 1:N)
    y_rep[n] = normal_rng(mu, sigma);
}
```

```r
# Posterior predictive checks
y_rep <- extract(fit)$y_rep
ppc_dens_overlay(y, y_rep[1:50, ])
```
