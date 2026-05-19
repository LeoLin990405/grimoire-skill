# Advanced R - Part IV: Metaprogramming

Based on "Advanced R" (2nd ed) by Hadley Wickham.
Book URL: https://adv-r.hadley.nz/

## Overview

**Metaprogramming**: Code is data that can be inspected and modified programmatically.

## 14. Expressions (AST)

### Capturing Code
```r
expr(x + y)           # Capture expression
exprs(x, y, z)        # Capture multiple

# From user input
enexpr(x)             # In function
enexprs(...)          # Multiple arguments
```

### Expression Types
| Type | Example | Check |
|------|---------|-------|
| Constant | `1`, `"a"` | `is_syntactic_literal()` |
| Symbol | `x`, `foo` | `is.symbol()` |
| Call | `f(x)` | `is.call()` |
| Pairlist | formals | `is.pairlist()` |

### Working with Calls
```r
x <- expr(f(a, b, c))

x[[1]]        # Function: f
x[[2]]        # First arg: a
x$a           # Named arg

# Modify
x[[2]] <- expr(z)
```

### Abstract Syntax Trees
```r
lobstr::ast(f(g(x), y))
# █─f
# ├─█─g
# │ └─x
# └─y
```

## 15. Quasiquotation

### Unquoting
```r
x <- expr(a + b)

# Unquote single value
expr(f(!!x))          # f(a + b)

# Unquote-splice list
args <- exprs(a, b, c)
expr(f(!!!args))      # f(a, b, c)
```

### Unquoting Names
```r
name <- "x"
expr(!!sym(name))     # x (as symbol)

# Dynamic names in calls
expr(f(!!name := 1))  # f(x = 1)
```

### Quosures
Capture expression + environment:
```r
quo(x + y)            # Create quosure
enquo(x)              # Capture from argument

quo_get_expr(q)       # Get expression
quo_get_env(q)        # Get environment
```

## 16. Evaluation

### Basic Evaluation
```r
eval(expr(x + y), env)           # Evaluate in environment
eval_tidy(quo, data)             # Tidy evaluation
```

### Data Masks
```r
eval_tidy(expr(x + y), data = df)  # df columns as variables
```

### Creating Functions with NSE
```r
my_summarize <- function(data, expr) {
  eval_tidy(enquo(expr), data)
}

my_summarize(mtcars, mean(mpg))
```

### Embracing (Tidy Eval)
```r
# For dplyr/tidyverse
my_summary <- function(data, var) {
  data |>
    summarize(mean = mean({{ var }}))
}
```

## 17. Translating R Code

### Walking the AST
```r
expr_type <- function(x) {
  if (is_syntactic_literal(x)) "constant"
  else if (is.symbol(x)) "symbol"
  else if (is.call(x)) "call"
  else typeof(x)
}

switch_expr <- function(x, ...) {
  switch(expr_type(x), ...)
}
```

### Recursive Processing
```r
# Example: find all symbols
find_symbols <- function(x) {
  switch_expr(x,
    constant = character(),
    symbol = as.character(x),
    call = {
      args <- as.list(x)[-1]
      unique(unlist(lapply(args, find_symbols)))
    }
  )
}
```

### Use Cases
- R to SQL translation (dbplyr)
- R to HTML/LaTeX
- Code analysis tools
- Domain-specific languages
