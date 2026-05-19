---
name: r-language-api
description: R interfaces to other languages. Use for calling Python, Java, JavaScript, and other languages from R.
---

# R Language Interfaces

Call other programming languages from R.

## reticulate (Python)

```r
library(reticulate)

# Use Python
py_run_string("x = 1 + 1")
py$x

# Import modules
np <- import("numpy")
pd <- import("pandas")

# Call Python functions
np$array(c(1, 2, 3))
pd$DataFrame(list(a = 1:3, b = 4:6))
```

## rJava (Java)

```r
library(rJava)

# Initialize JVM
.jinit()

# Create Java objects
str <- .jnew("java/lang/String", "Hello")

# Call methods
.jcall(str, "I", "length")
.jcall(str, "S", "toUpperCase")
```

## V8 (JavaScript)

```r
library(V8)

# Create context
ctx <- v8()

# Run JavaScript
ctx$eval("var x = 1 + 1")
ctx$get("x")

# Call functions
ctx$eval("function add(a, b) { return a + b; }")
ctx$call("add", 1, 2)
```

## Rcpp (C++)

```r
library(Rcpp)

# Inline C++
cppFunction('
  int add(int x, int y) {
    return x + y;
  }
')
add(1, 2)

# Source C++ file
sourceCpp("functions.cpp")
```

## Data Exchange

```r
# R to Python
py$df <- r_to_py(mtcars)

# Python to R
r_df <- py_to_r(py$df)

# Automatic conversion
reticulate::py_config()
```

## Best Practices

```r
# 1. Check availability
reticulate::py_available()
rJava::.jcheck()

# 2. Handle errors
tryCatch({
  py_run_string("import nonexistent")
}, error = function(e) {
  message("Python error: ", e$message)
})

# 3. Clean up resources
# Java: .jgc()
# V8: ctx$reset()
```
