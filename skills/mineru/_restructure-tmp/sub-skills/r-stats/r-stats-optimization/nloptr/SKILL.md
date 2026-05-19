---
name: nloptr
description: R nloptr package for nonlinear optimization. Use for solving nonlinear optimization problems with various algorithms.
---

# nloptr

Nonlinear optimization with NLopt library.

## Basic Usage

```r
library(nloptr)

# Minimize Rosenbrock function
eval_f <- function(x) {
  (1 - x[1])^2 + 100 * (x[2] - x[1]^2)^2
}

# Gradient (optional but recommended)
eval_grad_f <- function(x) {
  c(-2 * (1 - x[1]) - 400 * x[1] * (x[2] - x[1]^2),
    200 * (x[2] - x[1]^2))
}

# Optimize
result <- nloptr(
  x0 = c(-1, 1),
  eval_f = eval_f,
  eval_grad_f = eval_grad_f,
  opts = list(algorithm = "NLOPT_LD_LBFGS", xtol_rel = 1e-8)
)

result$solution
result$objective
```

## Algorithms

```r
# Local derivative-free
"NLOPT_LN_COBYLA"      # COBYLA
"NLOPT_LN_BOBYQA"      # BOBYQA
"NLOPT_LN_NEWUOA"      # NEWUOA
"NLOPT_LN_NELDERMEAD"  # Nelder-Mead
"NLOPT_LN_SBPLX"       # Subplex

# Local gradient-based
"NLOPT_LD_LBFGS"       # L-BFGS
"NLOPT_LD_MMA"         # MMA
"NLOPT_LD_SLSQP"       # SLSQP
"NLOPT_LD_TNEWTON"     # Truncated Newton

# Global
"NLOPT_GN_DIRECT"      # DIRECT
"NLOPT_GN_CRS2_LM"     # CRS
"NLOPT_GN_ISRES"       # ISRES
"NLOPT_GD_STOGO"       # StoGO
```

## Bound Constraints

```r
result <- nloptr(
  x0 = c(0.5, 0.5),
  eval_f = eval_f,
  lb = c(0, 0),        # Lower bounds
  ub = c(1, 1),        # Upper bounds
  opts = list(algorithm = "NLOPT_LN_BOBYQA", xtol_rel = 1e-8)
)
```

## Inequality Constraints

```r
# g(x) <= 0
eval_g_ineq <- function(x) {
  c(x[1] + x[2] - 1,   # x1 + x2 <= 1
    x[1]^2 + x[2]^2 - 1)  # x1^2 + x2^2 <= 1
}

result <- nloptr(
  x0 = c(0.5, 0.5),
  eval_f = eval_f,
  eval_g_ineq = eval_g_ineq,
  opts = list(algorithm = "NLOPT_LN_COBYLA", xtol_rel = 1e-8)
)
```

## Equality Constraints

```r
# h(x) = 0
eval_g_eq <- function(x) {
  x[1] + x[2] - 1  # x1 + x2 = 1
}

result <- nloptr(
  x0 = c(0.5, 0.5),
  eval_f = eval_f,
  eval_g_eq = eval_g_eq,
  opts = list(algorithm = "NLOPT_LD_SLSQP", xtol_rel = 1e-8)
)
```

## Options

```r
opts <- list(
  algorithm = "NLOPT_LD_LBFGS",
  xtol_rel = 1e-8,           # Relative tolerance on x
  xtol_abs = 1e-8,           # Absolute tolerance on x
  ftol_rel = 1e-8,           # Relative tolerance on f
  ftol_abs = 1e-8,           # Absolute tolerance on f
  maxeval = 1000,            # Max function evaluations
  maxtime = 60,              # Max time in seconds
  print_level = 0            # 0 = silent, 3 = verbose
)
```

## Wrapper Functions

```r
# Simpler interfaces
# BOBYQA (derivative-free, bounded)
bobyqa(x0, fn, lower, upper, control = list())

# COBYLA (derivative-free, constrained)
cobyla(x0, fn, hin = NULL, lower, upper, control = list())

# L-BFGS (gradient-based)
lbfgs(x0, fn, gr = NULL, lower, upper, control = list())

# SLSQP (gradient-based, constrained)
slsqp(x0, fn, gr = NULL, hin = NULL, heq = NULL, lower, upper)
```

## Example: Portfolio Optimization

```r
# Minimize variance subject to return constraint
# x = portfolio weights

eval_f <- function(x) {
  t(x) %*% cov_matrix %*% x  # Variance
}

eval_g_eq <- function(x) {
  c(sum(x) - 1,              # Weights sum to 1
    sum(x * returns) - target_return)  # Target return
}

result <- nloptr(
  x0 = rep(1/n, n),
  eval_f = eval_f,
  eval_g_eq = eval_g_eq,
  lb = rep(0, n),            # No short selling
  ub = rep(1, n),
  opts = list(algorithm = "NLOPT_LD_SLSQP", xtol_rel = 1e-8)
)
```

## Global Optimization

```r
# Use global algorithm
result <- nloptr(
  x0 = c(0, 0),
  eval_f = eval_f,
  lb = c(-5, -5),
  ub = c(5, 5),
  opts = list(
    algorithm = "NLOPT_GN_DIRECT_L",
    maxeval = 10000,
    xtol_rel = 1e-6
  )
)
```

## Check Gradients

```r
# Numerical gradient check
check.derivatives(
  x = c(1, 1),
  func = eval_f,
  func_grad = eval_grad_f
)
```
