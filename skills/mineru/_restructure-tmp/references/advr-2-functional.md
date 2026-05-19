# Advanced R - Part II: Functional Programming

Based on "Advanced R" (2nd ed) by Hadley Wickham.
Book URL: https://adv-r.hadley.nz/

## 8. Functionals

A **functional** takes a function as input and returns a vector.

### map() Family (purrr)

```r
map(x, f)           # Returns list
map_lgl(x, f)       # Returns logical vector
map_int(x, f)       # Returns integer vector
map_dbl(x, f)       # Returns double vector
map_chr(x, f)       # Returns character vector
```

### Multiple Inputs
```r
map2(x, y, f)       # Two inputs in parallel
pmap(list(x, y, z), f)  # Any number of inputs
imap(x, f)          # Values + indices/names
```

### Side Effects
```r
walk(x, f)          # Returns input invisibly
walk2(x, y, f)
pwalk(list, f)
```

### Anonymous Functions
```r
map(x, \(x) x + 1)  # R 4.1+ syntax
map(x, ~ .x + 1)    # purrr formula syntax
```

### Base R Equivalents
| purrr | base R |
|-------|--------|
| `map()` | `lapply()` |
| `map_*()` | `vapply()` |
| `map2()` | `Map()` |

### Reduce
```r
reduce(x, f)        # Combine to single value
# reduce(1:4, `+`) = ((1+2)+3)+4

accumulate(x, f)    # Keep intermediate results
```

### Predicate Functionals
```r
keep(x, is.numeric)    # Keep matching
discard(x, is.na)      # Remove matching
some(x, is.na)         # Any TRUE?
every(x, is.numeric)   # All TRUE?
detect(x, is.na)       # First match
```

## 9. Function Factories

A **function factory** is a function that creates functions.

### Basic Pattern
```r
power <- function(exp) {
  function(x) x ^ exp
}

square <- power(2)
cube <- power(3)
square(3)  # 9
```

### Stateful Functions
```r
counter <- function() {
  count <- 0
  function() {
    count <<- count + 1
    count
  }
}

count_calls <- counter()
count_calls()  # 1
count_calls()  # 2
```

### Force Evaluation
```r
# Problem: lazy evaluation captures promise
power <- function(exp) {
  force(exp)  # Evaluate immediately
  function(x) x ^ exp
}
```

### Common Use Cases
- Memoization (caching results)
- Maximum likelihood estimation
- Bootstrap generators
- ggplot2 scale functions

## 10. Function Operators

A **function operator** takes function(s) as input and returns a modified function.

### Common Patterns

**Modify behavior:**
```r
safely <- function(f) {
  function(...) {
    tryCatch(
      list(result = f(...), error = NULL),
      error = function(e) list(result = NULL, error = e)
    )
  }
}
```

**Modify output:**
```r
capture_output <- function(f) {
  function(...) {
    capture.output(f(...))
  }
}
```

**Modify input:**
```r
partial <- function(f, ...) {
  args <- list(...)
  function(...) {
    do.call(f, c(args, list(...)))
  }
}
```

### purrr Operators
```r
safely(f)       # Capture errors
possibly(f, otherwise)  # Default on error
quietly(f)      # Capture messages/warnings
insistently(f)  # Retry on failure
slowly(f, rate) # Rate limiting
```

### Composition
```r
compose(f, g, h)  # f(g(h(x)))
# Or use pipe: x |> h() |> g() |> f()
```
