---
name: ROI
description: R ROI package for optimization infrastructure. Use for unified interface to various optimization solvers.
---

# ROI

R Optimization Infrastructure.

## Basic Usage

```r
library(ROI)
library(ROI.plugin.glpk)  # Or other solver plugins

# Define optimization problem
op <- OP(
  objective = L_objective(c(3, 2)),  # Maximize 3x + 2y
  constraints = L_constraint(
    L = matrix(c(1, 1, 2, 1), nrow = 2, byrow = TRUE),
    dir = c("<=", "<="),
    rhs = c(4, 5)
  ),
  maximum = TRUE
)

# Solve
result <- ROI_solve(op, solver = "glpk")

# Results
solution(result)
solution(result, "objval")
solution(result, "status")
```

## Linear Programming

```r
# Minimize c'x subject to Ax <= b
op <- OP(
  objective = L_objective(c(1, 2, 3)),
  constraints = L_constraint(
    L = matrix(c(1, 1, 1,
                 2, 1, 0,
                 0, 1, 2), nrow = 3, byrow = TRUE),
    dir = c("<=", "<=", ">="),
    rhs = c(10, 8, 5)
  ),
  bounds = V_bound(lb = c(0, 0, 0), ub = c(Inf, Inf, Inf)),
  maximum = FALSE
)

result <- ROI_solve(op)
```

## Quadratic Programming

```r
library(ROI.plugin.quadprog)

# Minimize 0.5 * x'Qx + c'x
Q <- matrix(c(2, 0, 0, 2), nrow = 2)
c <- c(-4, -6)

op <- OP(
  objective = Q_objective(Q = Q, L = c),
  constraints = L_constraint(
    L = matrix(c(1, 1, -1, 2), nrow = 2, byrow = TRUE),
    dir = c("<=", "<="),
    rhs = c(2, 2)
  ),
  bounds = V_bound(lb = c(0, 0))
)

result <- ROI_solve(op, solver = "quadprog")
```

## Integer Programming

```r
# Mixed integer linear programming
op <- OP(
  objective = L_objective(c(3, 2, 5)),
  constraints = L_constraint(
    L = matrix(c(1, 1, 1,
                 2, 1, 0), nrow = 2, byrow = TRUE),
    dir = c("<=", "<="),
    rhs = c(10, 8)
  ),
  types = c("I", "C", "B"),  # Integer, Continuous, Binary
  maximum = TRUE
)

result <- ROI_solve(op, solver = "glpk")
```

## Bounds

```r
# Variable bounds
bounds <- V_bound(
  li = c(1, 2, 3),      # Indices with lower bounds
  ui = c(1, 2, 3),      # Indices with upper bounds
  lb = c(0, 0, 0),      # Lower bounds
  ub = c(10, 5, Inf),   # Upper bounds
  nobj = 3             # Number of variables
)

op <- OP(
  objective = L_objective(c(1, 2, 3)),
  constraints = L_constraint(...),
  bounds = bounds
)
```

## Available Solvers

```r
# List available solvers
ROI_available_solvers()

# Install solver plugins
install.packages("ROI.plugin.glpk")     # GLPK
install.packages("ROI.plugin.quadprog") # quadprog
install.packages("ROI.plugin.nloptr")   # nloptr
install.packages("ROI.plugin.alabama")  # alabama
install.packages("ROI.plugin.ipop")     # ipop
```

## Nonlinear Optimization

```r
library(ROI.plugin.nloptr)

# Define nonlinear objective
f <- function(x) (x[1] - 1)^2 + (x[2] - 2)^2

op <- OP(
  objective = F_objective(f, n = 2),
  bounds = V_bound(lb = c(-Inf, -Inf), ub = c(Inf, Inf))
)

result <- ROI_solve(op, solver = "nloptr", start = c(0, 0))
```

## Constraint Types

```r
# Linear constraints
L_constraint(L, dir, rhs)

# Quadratic constraints
Q_constraint(Q, L, dir, rhs)

# Functional constraints
F_constraint(F, dir, rhs)

# Combine constraints
c(constraint1, constraint2)
```

## Portfolio Optimization Example

```r
library(ROI.plugin.quadprog)

# Minimize variance: 0.5 * w'Σw
# Subject to: sum(w) = 1, w'μ >= target, w >= 0

Sigma <- cov(returns)
mu <- colMeans(returns)
n <- ncol(returns)

op <- OP(
  objective = Q_objective(Q = Sigma, L = rep(0, n)),
  constraints = L_constraint(
    L = rbind(rep(1, n), mu),
    dir = c("==", ">="),
    rhs = c(1, target_return)
  ),
  bounds = V_bound(lb = rep(0, n))
)

result <- ROI_solve(op, solver = "quadprog")
optimal_weights <- solution(result)
```

## Solution Extraction

```r
# Optimal solution
solution(result)

# Objective value
solution(result, "objval")

# Status
solution(result, "status")

# Message
solution(result, "msg")

# All solution info
solution(result, "solution")
```
