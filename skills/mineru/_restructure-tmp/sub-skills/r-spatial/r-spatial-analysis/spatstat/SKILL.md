---
name: spatstat
description: R spatstat package for spatial point patterns. Use for analyzing and modeling spatial point pattern data.
---

# spatstat

Spatial point pattern analysis.

## Point Patterns

```r
library(spatstat)

# Create point pattern
pp <- ppp(x, y, window = owin(c(0, 1), c(0, 1)))

# From data frame
pp <- ppp(df$x, df$y, window = owin(range(df$x), range(df$y)))

# With marks (attributes)
pp <- ppp(x, y, window = win, marks = factor(types))
```

## Windows

```r
# Rectangular window
win <- owin(c(0, 100), c(0, 100))

# Polygonal window
win <- owin(poly = list(x = c(0, 1, 1, 0), y = c(0, 0, 1, 1)))

# Circular window
win <- disc(radius = 50, centre = c(50, 50))

# From shapefile
library(maptools)
win <- as.owin(sp_polygon)
```

## Summary Statistics

```r
# Summary
summary(pp)

# Intensity (points per unit area)
intensity(pp)

# Quadrat counts
quadratcount(pp, nx = 5, ny = 5)

# Quadrat test (CSR)
quadrat.test(pp, nx = 5, ny = 5)
```

## Density Estimation

```r
# Kernel density
dens <- density(pp)
plot(dens)

# With bandwidth
dens <- density(pp, sigma = 10)

# Adaptive bandwidth
dens <- density(pp, sigma = bw.diggle)

# Bandwidth selection
bw.diggle(pp)
bw.ppl(pp)
bw.scott(pp)
```

## Distance Functions

```r
# G function (nearest neighbor)
G <- Gest(pp)
plot(G)

# F function (empty space)
F <- Fest(pp)
plot(F)

# K function (Ripley's K)
K <- Kest(pp)
plot(K)

# L function (transformed K)
L <- Lest(pp)
plot(L)

# Pair correlation function
g <- pcf(pp)
plot(g)
```

## Envelopes (Significance Testing)

```r
# Monte Carlo envelope for K function
env <- envelope(pp, Kest, nsim = 99)
plot(env)

# For L function
env <- envelope(pp, Lest, nsim = 99)
plot(env)

# Global envelope
env <- envelope(pp, Lest, nsim = 99, global = TRUE)
```

## Point Process Models

```r
# Poisson (CSR)
fit <- ppm(pp ~ 1)

# Inhomogeneous Poisson
fit <- ppm(pp ~ x + y)

# With covariates
fit <- ppm(pp ~ covariate_image)

# Cluster process
fit <- kppm(pp ~ 1, "Thomas")

# Summary
summary(fit)
```

## Marked Point Patterns

```r
# Create marked pattern
pp <- ppp(x, y, window = win, marks = factor(types))

# Split by marks
split(pp)

# Mark correlation
markcorr(pp)

# Cross-type functions
Kcross(pp, "type1", "type2")
Lcross(pp, "type1", "type2")
```

## Simulation

```r
# Poisson process
sim <- rpoispp(lambda = 100, win = win)

# Inhomogeneous Poisson
sim <- rpoispp(function(x, y) 100 * x, win = win)

# Thomas cluster process
sim <- rThomas(kappa = 10, scale = 0.1, mu = 5, win = win)

# Matern cluster process
sim <- rMatClust(kappa = 10, scale = 0.1, mu = 5, win = win)

# Hard core process
sim <- rHardcore(beta = 100, R = 0.05, W = win)
```

## Plotting

```r
# Basic plot
plot(pp)

# With density
plot(density(pp))
plot(pp, add = TRUE)

# Colored by marks
plot(pp, cols = c("red", "blue"))

# Multiple plots
par(mfrow = c(2, 2))
plot(Gest(pp), main = "G function")
plot(Fest(pp), main = "F function")
plot(Kest(pp), main = "K function")
plot(Lest(pp), main = "L function")
```

## Covariates

```r
# Create covariate image
cov <- as.im(function(x, y) x + y, W = win)

# Fit model with covariate
fit <- ppm(pp ~ cov)

# Rhohat (nonparametric)
rho <- rhohat(pp, cov)
plot(rho)
```

## Diagnostics

```r
# Residuals
res <- residuals(fit)
plot(res)

# Lurking variable plot
lurking(fit, covariate = "x")

# Q-Q plot
diagnose.ppm(fit)
```
