---
name: r-stats
description: R statistical packages for Bayesian analysis, optimization, and finance. Use for MCMC (Stan, JAGS), linear programming, portfolio analysis, and quantitative finance.
---

# R Statistics Skill

## Sub-skills

| Sub-skill | Description |
|-----------|-------------|
| [r-stats-bayesian](r-stats-bayesian/SKILL.md) | Stan, brms, MCMC, posterior inference |
| [r-stats-optimization](r-stats-optimization/SKILL.md) | ROI, lpSolve, nloptr |
| [r-stats-finance](r-stats-finance/SKILL.md) | quantmod, PerformanceAnalytics, tidyquant |

Bayesian analysis, optimization, and finance in R.

## Bayesian Analysis

| Package | Description |
|---------|-------------|
| **rstan** ★ | Stan MCMC interface |
| **brms** ★ | High-level Bayesian regression |
| **rstanarm** | Bayesian applied regression |
| **coda** | MCMC output analysis |
| **mcmc** | Markov Chain Monte Carlo |
| **MCMCpack** | MCMC package |
| **rjags** | JAGS interface |
| **R2WinBUGS** | WinBUGS/OpenBUGS interface |
| **BRugs** | OpenBUGS interface |

## Optimization

| Package | Description |
|---------|-------------|
| **ROI** ★ | R Optimization Infrastructure |
| **lpSolve** | Linear/Integer programming |
| **Rglpk** | GNU Linear Programming Kit |
| **ompr** | Algebraic MIP modeling |
| **nloptr** | Nonlinear optimization |
| **minqa** | Derivative-free optimization |

## Finance

| Package | Description |
|---------|-------------|
| **quantmod** ★ | Quantitative financial modeling |
| **tidyquant** | Tidy quantitative analysis |
| **PerformanceAnalytics** | Performance and risk analysis |
| **TTR** | Technical trading rules |
| **zoo** ★ | Regular/irregular time series |
| **xts** | Extensible time series |
| **tseries** | Time series analysis |
| **fAssets** | Financial assets analysis |
| **scorecard** | Credit risk scorecard |
| **pedquant** | Public economic data |

## Quick Examples

```r
# Bayesian regression with brms
library(brms)
model <- brm(
  y ~ x1 + x2 + (1|group),
  data = df,
  family = gaussian(),
  prior = c(
    prior(normal(0, 10), class = "b"),
    prior(cauchy(0, 2), class = "sd")
  ),
  chains = 4, iter = 2000
)
summary(model)
plot(model)

# Stan model
library(rstan)
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
  y ~ normal(alpha + beta * x, sigma);
}
"
fit <- stan(model_code = stan_code, data = list(N = 100, x = x, y = y))

# Linear programming
library(lpSolve)
obj <- c(1, 2, 3)
con <- matrix(c(1, 1, 1, 2, 1, 3), nrow = 2, byrow = TRUE)
dir <- c("<=", "<=")
rhs <- c(4, 6)
lp("max", obj, con, dir, rhs)

# Quantitative finance
library(quantmod)
getSymbols("AAPL", from = "2020-01-01")
chartSeries(AAPL)
addBBands()
addMACD()

# Portfolio analysis
library(PerformanceAnalytics)
returns <- Return.calculate(prices)
table.AnnualizedReturns(returns)
chart.RollingPerformance(returns)
SharpeRatio(returns)

# Time series
library(zoo)
ts <- zoo(data, order.by = dates)
rollmean(ts, k = 7)
na.locf(ts)  # Last observation carried forward
```

## Bayesian Workflow

```r
library(brms)

# 1. Specify model
model <- brm(
  y ~ x + (1|group),
  data = df,
  family = gaussian()
)

# 2. Check convergence
plot(model)
mcmc_trace(as.array(model))

# 3. Posterior predictive check
pp_check(model)

# 4. Model comparison
loo(model1, model2)

# 5. Predictions
predict(model, newdata = new_df)
```

## Resources

- Stan: https://mc-stan.org/
- brms: https://paul-buerkner.github.io/brms/
- quantmod: http://www.quantmod.com/
- PerformanceAnalytics: https://github.com/braverock/PerformanceAnalytics
