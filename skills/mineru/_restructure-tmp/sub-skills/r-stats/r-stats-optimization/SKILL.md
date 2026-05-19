---
name: r-stats-optimization
description: R optimization with ROI, lpSolve, nloptr. Use for linear programming, nonlinear optimization, and constraint solving.
---

# R Optimization

Mathematical optimization.

## ROI (R Optimization Infrastructure)

```r
library(ROI)
library(ROI.plugin.glpk)

# Linear programming: max 2x + 3y
# subject to: x + y <= 4, 2x + y <= 5, x,y >= 0
op <- OP(
  objective = L_objective(c(2, 3)),
  constraints = L_constraint(
    L = rbind(c(1, 1), c(2, 1)),
    dir = c("<=", "<="),
    rhs = c(4, 5)
  ),
  bounds = V_bound(lb = c(0, 0)),
  maximum = TRUE
)

sol <- ROI_solve(op, solver = "glpk")
solution(sol)
```

## lpSolve

```r
library(lpSolve)

# Linear programming
obj <- c(2, 3)
con <- matrix(c(1, 1, 2, 1), nrow = 2, byrow = TRUE)
dir <- c("<=", "<=")
rhs <- c(4, 5)

result <- lp("max", obj, con, dir, rhs)
result$solution
result$objval

# Integer programming
result <- lp("max", obj, con, dir, rhs, all.int = TRUE)

# Binary
result <- lp("max", obj, con, dir, rhs, all.bin = TRUE)

# Transportation problem
costs <- matrix(c(8, 6, 10, 9, 9, 12, 13, 7, 14, 9, 16, 5), nrow = 3)
supply <- c(15, 25, 10)
demand <- c(5, 15, 15, 15)
lp.transport(costs, "min", supply, demand)
```

## nloptr (Nonlinear)

```r
library(nloptr)

# Minimize f(x) = (x1 - 1)^2 + (x2 - 2)^2
fn <- function(x) (x[1] - 1)^2 + (x[2] - 2)^2

result <- nloptr(
  x0 = c(0, 0),
  eval_f = fn,
  lb = c(-Inf, -Inf),
  ub = c(Inf, Inf),
  opts = list(algorithm = "NLOPT_LN_COBYLA", xtol_rel = 1e-8)
)
result$solution

# With gradient
fn <- function(x) sum((x - c(1, 2))^2)
gr <- function(x) 2 * (x - c(1, 2))

result <- nloptr(
  x0 = c(0, 0),
  eval_f = fn,
  eval_grad_f = gr,
  opts = list(algorithm = "NLOPT_LD_LBFGS")
)

# With constraints
# g(x) <= 0
eval_g <- function(x) x[1] + x[2] - 3

result <- nloptr(
  x0 = c(0, 0),
  eval_f = fn,
  eval_g_ineq = eval_g,
  opts = list(algorithm = "NLOPT_LN_COBYLA")
)
```

## optim (Base R)

```r
# Nelder-Mead
fn <- function(x) (x[1] - 1)^2 + (x[2] - 2)^2
result <- optim(c(0, 0), fn)
result$par

# BFGS (with gradient)
result <- optim(c(0, 0), fn, gr, method = "BFGS")

# L-BFGS-B (bounded)
result <- optim(c(0, 0), fn, method = "L-BFGS-B", lower = c(0, 0), upper = c(10, 10))

# Simulated annealing
result <- optim(c(0, 0), fn, method = "SANN")
```

## ompr (Algebraic Modeling)

```r
library(ompr)
library(ompr.roi)

# Model
model <- MIPModel() %>%
  add_variable(x[i], i = 1:2, type = "continuous", lb = 0) %>%
  set_objective(2 * x[1] + 3 * x[2], "max") %>%
  add_constraint(x[1] + x[2] <= 4) %>%
  add_constraint(2 * x[1] + x[2] <= 5)

result <- solve_model(model, with_ROI(solver = "glpk"))
get_solution(result, x[i])
```
