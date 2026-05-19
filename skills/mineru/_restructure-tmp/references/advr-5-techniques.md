# Advanced R - Part V: Techniques

Based on "Advanced R" (2nd ed) by Hadley Wickham.
Book URL: https://adv-r.hadley.nz/

## 18. Debugging

### Strategy
1. **Google** the error message
2. **Make it repeatable** (minimal reproducible example)
3. **Figure out where** (binary search)
4. **Fix and test**

### Tools

**traceback()** - Show call stack after error:
```r
f()  # Error occurs
traceback()
# Or in RStudio: click "Show Traceback"

rlang::last_trace()  # Cleaner output
```

**browser()** - Interactive debugging:
```r
my_function <- function(x) {
  browser()  # Pause here
  x + 1
}

# Conditional
if (x < 0) browser()
```

**Browser commands:**
| Command | Action |
|---------|--------|
| `n` | Next step |
| `s` | Step into function |
| `c` | Continue |
| `Q` | Quit |
| `where` | Show call stack |

**Other tools:**
```r
debug(f)           # Debug on every call
debugonce(f)       # Debug once
undebug(f)         # Stop debugging
options(error = recover)  # Interactive on error
```

### Non-Error Problems
```r
# Warnings as errors
options(warn = 2)

# Trace messages
rlang::with_abort(message_func())
```

## 19. Measuring Performance

### Profiling
```r
library(profvis)

profvis({
  # Code to profile
  result <- slow_function(data)
})
```

**Interpret results:**
- Focus on functions taking most time
- Watch for `<GC>` (garbage collection) - indicates many temporary objects
- Memory column shows allocations

### Microbenchmarking
```r
library(bench)

bench::mark(
  method1 = expr1,
  method2 = expr2,
  check = TRUE  # Verify same results
)
```

**Key metrics:**
- `min`, `median` - Focus on these
- `mem_alloc` - Memory allocated
- `n_gc` - Garbage collections

**Time scale reference:**
| Time | Operations/second |
|------|-------------------|
| 1 ms | 1,000 |
| 1 µs | 1,000,000 |
| 1 ns | 1,000,000,000 |

## 20. Improving Performance

### General Strategies

1. **Do less work**
   - Avoid unnecessary copies
   - Use appropriate data structures
   - Pre-allocate vectors

2. **Vectorize**
   ```r
   # Slow
   for (i in seq_along(x)) x[i] <- x[i] * 2

   # Fast
   x <- x * 2
   ```

3. **Avoid growing objects**
   ```r
   # Slow
   result <- c()
   for (i in 1:n) result <- c(result, f(i))

   # Fast
   result <- vector("list", n)
   for (i in 1:n) result[[i]] <- f(i)
   ```

4. **Use efficient packages**
   - `data.table` for large data
   - `Matrix` for sparse matrices
   - `Rcpp` for C++ integration

### Common Optimizations

**Lookup tables:**
```r
# Slow
ifelse(x == "a", 1, ifelse(x == "b", 2, 3))

# Fast
lookup <- c(a = 1, b = 2)
lookup[x]
```

**Avoid copies:**
```r
# Slow (copies on each iteration)
for (i in seq_along(df)) df[[i]] <- f(df[[i]])

# Fast (modify in place with data.table)
library(data.table)
dt <- as.data.table(df)
for (col in names(dt)) set(dt, j = col, value = f(dt[[col]]))
```

## 21. Rcpp

### Basic Usage
```r
library(Rcpp)

cppFunction('
  double sumC(NumericVector x) {
    int n = x.size();
    double total = 0;
    for (int i = 0; i < n; i++) {
      total += x[i];
    }
    return total;
  }
')

sumC(1:10)
```

### Source Files
```cpp
// sum.cpp
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double sumC(NumericVector x) {
  int n = x.size();
  double total = 0;
  for (int i = 0; i < n; i++) {
    total += x[i];
  }
  return total;
}
```

```r
sourceCpp("sum.cpp")
```

### When to Use Rcpp
- Loops that can't be vectorized
- Recursive functions
- Problems requiring advanced data structures
- Calling C/C++ libraries
