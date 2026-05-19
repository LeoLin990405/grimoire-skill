---
name: MCMCpack
description: R MCMCpack package for MCMC sampling. Use for Markov Chain Monte Carlo methods and Bayesian inference.
---

# MCMCpack

Markov Chain Monte Carlo methods.

## Linear Regression

```r
library(MCMCpack)

# Bayesian linear regression
model <- MCMCregress(y ~ x1 + x2, data = df)

# With priors
model <- MCMCregress(y ~ x1 + x2, data = df,
  b0 = 0,           # Prior mean for coefficients
  B0 = 0.001,       # Prior precision for coefficients
  c0 = 0.001,       # Prior shape for variance
  d0 = 0.001        # Prior scale for variance
)

# Summary
summary(model)
```

## Logistic Regression

```r
# Bayesian logistic regression
model <- MCMClogit(y ~ x1 + x2, data = df)

# With priors
model <- MCMClogit(y ~ x1 + x2, data = df,
  b0 = 0,
  B0 = 0.001
)
```

## Poisson Regression

```r
# Bayesian Poisson regression
model <- MCMCpoisson(count ~ x1 + x2, data = df)
```

## Probit Regression

```r
# Bayesian probit regression
model <- MCMCprobit(y ~ x1 + x2, data = df)
```

## Ordinal Probit

```r
# Ordinal probit model
model <- MCMCoprobit(ordered_y ~ x1 + x2, data = df)
```

## Multinomial Logit

```r
# Multinomial logit
model <- MCMCmnl(choice ~ x1 + x2, data = df,
  mcmc.method = "IndMH"
)
```

## MCMC Settings

```r
model <- MCMCregress(y ~ x1 + x2, data = df,
  burnin = 1000,      # Burn-in iterations
  mcmc = 10000,       # MCMC iterations
  thin = 10,          # Thinning interval
  seed = 123          # Random seed
)
```

## Diagnostics

```r
# Summary statistics
summary(model)

# Plot traces
plot(model)

# Geweke diagnostic
geweke.diag(model)

# Heidelberg-Welch diagnostic
heidel.diag(model)

# Raftery-Lewis diagnostic
raftery.diag(model)
```

## Extract Results

```r
# Posterior means
colMeans(model)

# Posterior standard deviations
apply(model, 2, sd)

# Credible intervals
summary(model)$quantiles

# HPD intervals
HPDinterval(model)
```

## Factor Analysis

```r
# Bayesian factor analysis
model <- MCMCfactanal(~ x1 + x2 + x3 + x4, data = df,
  factors = 2
)
```

## Item Response Theory

```r
# 1-parameter IRT
model <- MCMCirt1d(data_matrix)

# 2-parameter IRT
model <- MCMCirtKd(data_matrix, dimensions = 1)
```

## Mixed Models

```r
# Hierarchical linear model
model <- MCMChregress(y ~ x1 + x2, data = df,
  group = "group_var"
)
```

## Model Comparison

```r
# Bayes factor
BayesFactor(model1, model2)

# DIC
# Computed automatically in summary
```

## Convergence

```r
library(coda)

# Convert to mcmc object
mcmc_obj <- as.mcmc(model)

# Gelman-Rubin (requires multiple chains)
# Run model multiple times with different seeds
chains <- mcmc.list(model1, model2, model3)
gelman.diag(chains)

# Effective sample size
effectiveSize(model)
```
