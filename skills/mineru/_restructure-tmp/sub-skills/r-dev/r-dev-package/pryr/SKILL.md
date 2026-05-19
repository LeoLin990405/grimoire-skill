---
name: pryr
description: R pryr package for R internals. Use for exploring R's internal workings and memory usage.
---

# pryr

Tools for computing on the language.

## Object Information

```r
library(pryr)

# Object size
object_size(x)
object_size(x, y)  # Combined size

# Compare sizes
compare_size(x, y)

# Memory address
address(x)

# References to object
refs(x)
```

## Memory Tracking

```r
# Track memory changes
mem_used()

# Memory change from expression
mem_change(x <- 1:1e6)

# Track allocations
track_copy(x)
```

## Object Types

```r
# Type of object
otype(x)  # base, S3, S4, RC, R6

# Is object...
is_s3_generic(f)
is_s3_method(f)

# Function type
ftype(f)  # primitive, internal, closure, special
```

## Environments

```r
# Where is object defined
where("mean")

# Parent environments
parenvs(e)

# Environment as list
env2list(e)
```

## Function Inspection

```r
# Function body
body(f)

# Function arguments
fargs(f)

# Function environment
environment(f)

# Unenclose function
unenclose(f)
```

## Promises

```r
# Check if promise
is_promise(x)

# Promise info
promise_info(x)
```

## Calls and Expressions

```r
# Standardize call
standardise_call(quote(mean(x, na.rm = TRUE)))

# Modify call
modify_call(call, new_args)

# Call tree
call_tree(quote(f(g(x), h(y))))
```

## Active Bindings

```r
# Create active binding
make_active_binding("x", function() runif(1), .GlobalEnv)

# Check if active binding
is_active_binding("x")
```

## Partial Application

```r
# Partial function application
f <- function(x, y, z) x + y + z
g <- partial(f, x = 1)
g(y = 2, z = 3)  # Returns 6

# With dots
h <- partial(f, x = 1, .lazy = FALSE)
```

## Composition

```r
# Compose functions
f <- function(x) x + 1
g <- function(x) x * 2

fg <- compose(f, g)  # f(g(x))
fg(5)  # Returns 11
```

## Substitution

```r
# Substitute in expression
subs(x + y, list(x = 1))

# Substitute with quoting
subs_q(x + y, list(x = quote(a)))
```

## Bytecode

```r
# Check if bytecode compiled
is_bytecode(f)

# Disassemble bytecode
disassemble(f)
```

## Performance

```r
# Compare object sizes
object_size(1:1000)
object_size(as.numeric(1:1000))

# Memory efficient operations
# Use pryr to understand memory behavior
x <- 1:1e6
address(x)
x[1] <- 0L
address(x)  # Same address (modify in place)

y <- x
address(y)  # Same address (copy on modify)
y[1] <- 1L
address(y)  # Different address (copied)
```
