---
name: coda
description: R coda package for MCMC diagnostics. Use for analyzing and diagnosing MCMC output.
---

# coda

Output analysis and diagnostics for MCMC.

## MCMC Objects

```r
library(coda)

# Create mcmc object
mcmc_obj <- mcmc(matrix_data)

# With parameters
mcmc_obj <- mcmc(matrix_data,
  start = 1,
  end = 10000,
  thin = 1
)

# Multiple chains
chains <- mcmc.list(chain1, chain2, chain3)
```

## Summary Statistics

```r
# Summary
summary(mcmc_obj)

# Mean
colMeans(mcmc_obj)

# Standard deviation
apply(mcmc_obj, 2, sd)

# Quantiles
summary(mcmc_obj)$quantiles
```

## Convergence Diagnostics

```r
# Geweke diagnostic
geweke.diag(mcmc_obj)
geweke.plot(mcmc_obj)

# Heidelberg-Welch diagnostic
heidel.diag(mcmc_obj)

# Raftery-Lewis diagnostic
raftery.diag(mcmc_obj)

# Gelman-Rubin (requires multiple chains)
gelman.diag(chains)
gelman.plot(chains)
```

## Effective Sample Size

```r
# Effective sample size
effectiveSize(mcmc_obj)

# Autocorrelation
autocorr(mcmc_obj)
autocorr.diag(mcmc_obj)
autocorr.plot(mcmc_obj)
```

## Plotting

```r
# Trace plot
traceplot(mcmc_obj)
plot(mcmc_obj, trace = TRUE, density = FALSE)

# Density plot
densplot(mcmc_obj)
plot(mcmc_obj, trace = FALSE, density = TRUE)

# Both
plot(mcmc_obj)

# Autocorrelation plot
autocorr.plot(mcmc_obj)

# Cross-correlation
crosscorr.plot(mcmc_obj)
```

## Credible Intervals

```r
# HPD interval
HPDinterval(mcmc_obj)
HPDinterval(mcmc_obj, prob = 0.95)

# Quantile-based interval
summary(mcmc_obj)$quantiles[, c("2.5%", "97.5%")]
```

## Thinning and Subsetting

```r
# Thin chain
thinned <- window(mcmc_obj, thin = 10)

# Subset iterations
subset <- window(mcmc_obj, start = 1000, end = 5000)

# Subset parameters
subset <- mcmc_obj[, c("beta1", "beta2")]
```

## Combining Chains

```r
# Combine multiple chains
combined <- mcmc.list(chain1, chain2, chain3)

# Stack chains
stacked <- as.mcmc(do.call(rbind, combined))
```

## Cross-Correlation

```r
# Cross-correlation matrix
crosscorr(mcmc_obj)

# Plot
crosscorr.plot(mcmc_obj)
```

## Batch Means

```r
# Batch means standard error
batchSE(mcmc_obj)

# Spectrum at zero
spectrum0(mcmc_obj)
spectrum0.ar(mcmc_obj)
```

## Reading/Writing

```r
# Read CODA output
mcmc_obj <- read.coda("chain.txt", "index.txt")

# Write
write.coda(mcmc_obj, "output")
```

## With Other Packages

```r
# From MCMCpack
library(MCMCpack)
model <- MCMCregress(y ~ x, data = df)
mcmc_obj <- as.mcmc(model)

# From rstan
library(rstan)
mcmc_obj <- As.mcmc.list(stanfit)

# From brms
library(brms)
mcmc_obj <- as.mcmc(brms_fit)
```

## Diagnostic Summary

```r
# Run all diagnostics
diagnostic_summary <- function(mcmc_obj) {
  list(
    summary = summary(mcmc_obj),
    geweke = geweke.diag(mcmc_obj),
    heidel = heidel.diag(mcmc_obj),
    raftery = raftery.diag(mcmc_obj),
    ess = effectiveSize(mcmc_obj)
  )
}
```
