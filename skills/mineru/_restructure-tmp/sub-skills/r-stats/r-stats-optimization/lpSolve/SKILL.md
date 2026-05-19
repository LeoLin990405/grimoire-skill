---
name: lpSolve
description: R lpSolve package for linear programming. Use for solving linear and integer programming problems.
---

# lpSolve

Linear and integer programming.

## Linear Programming

```r
library(lpSolve)

# Maximize: 3x + 2y
# Subject to:
#   x + y <= 4
#   2x + y <= 5
#   x, y >= 0

# Objective function coefficients
obj <- c(3, 2)

# Constraint matrix
con <- matrix(c(1, 1,
                2, 1), nrow = 2, byrow = TRUE)

# Constraint directions
dir <- c("<=", "<=")

# Right-hand side
rhs <- c(4, 5)

# Solve
result <- lp("max", obj, con, dir, rhs)

# Results
result$objval      # Optimal value
result$solution    # Optimal solution
result$status      # 0 = success
```

## Integer Programming

```r
# All integer variables
result <- lp("max", obj, con, dir, rhs, all.int = TRUE)

# Binary variables
result <- lp("max", obj, con, dir, rhs, all.bin = TRUE)

# Mixed integer
result <- lp("max", obj, con, dir, rhs, int.vec = c(1))  # First variable integer
```

## Transportation Problem

```r
# Costs matrix (sources x destinations)
costs <- matrix(c(8, 6, 10, 9,
                  9, 12, 13, 7,
                  14, 9, 16, 5), nrow = 3, byrow = TRUE)

# Supply at each source
supply <- c(35, 50, 40)

# Demand at each destination
demand <- c(45, 20, 30, 30)

# Solve
result <- lp.transport(costs, "min",
                       row.signs = rep("<=", 3), row.rhs = supply,
                       col.signs = rep(">=", 4), col.rhs = demand)

result$objval
result$solution
```

## Assignment Problem

```r
# Cost matrix (workers x tasks)
costs <- matrix(c(90, 75, 75, 80,
                  35, 85, 55, 65,
                  125, 95, 90, 105,
                  45, 110, 95, 115), nrow = 4, byrow = TRUE)

# Solve
result <- lp.assign(costs, "min")

result$objval
result$solution  # Binary matrix showing assignments
```

## Bounds on Variables

```r
# Variable bounds: 0 <= x <= 10, 0 <= y <= 5
result <- lp("max", obj, con, dir, rhs,
             all.int = FALSE,
             presolve = 0,
             compute.sens = FALSE)

# For bounds, add constraints
con_with_bounds <- rbind(con,
                         c(1, 0),  # x <= 10
                         c(0, 1))  # y <= 5
dir_with_bounds <- c(dir, "<=", "<=")
rhs_with_bounds <- c(rhs, 10, 5)

result <- lp("max", obj, con_with_bounds, dir_with_bounds, rhs_with_bounds)
```

## Sensitivity Analysis

```r
# Enable sensitivity analysis
result <- lp("max", obj, con, dir, rhs, compute.sens = TRUE)

# Sensitivity results
result$sens.coef.from   # Objective coefficient ranges (from)
result$sens.coef.to     # Objective coefficient ranges (to)
result$duals            # Dual values (shadow prices)
result$duals.from       # Dual ranges (from)
result$duals.to         # Dual ranges (to)
```

## Equality Constraints

```r
# x + y = 4
dir <- c("=")
rhs <- c(4)

result <- lp("max", obj, con, dir, rhs)
```

## Multiple Solutions

```r
# Check for alternative optima
# If dual value is 0 for a non-binding constraint,
# alternative optima may exist
```

## Large Problems

```r
# For large problems, consider:
# - Presolve
result <- lp("max", obj, con, dir, rhs, presolve = 1)

# - Scaling
result <- lp("max", obj, con, dir, rhs, scale = 1)
```

## Example: Diet Problem

```r
# Minimize cost while meeting nutritional requirements
# Foods: bread, milk, cheese
# Nutrients: protein, calcium, calories

# Cost per unit
cost <- c(2, 3.5, 8)

# Nutrient content per unit (nutrients x foods)
nutrients <- matrix(c(
  4, 8, 7,    # Protein
  10, 25, 20, # Calcium
  200, 150, 400  # Calories
), nrow = 3, byrow = TRUE)

# Minimum requirements
min_req <- c(20, 50, 500)

# Solve
result <- lp("min", cost, nutrients, rep(">=", 3), min_req)

result$objval
result$solution
```
