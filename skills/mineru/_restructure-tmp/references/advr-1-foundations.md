# Advanced R - Part I: Foundations

Based on "Advanced R" (2nd ed) by Hadley Wickham.
Book URL: https://adv-r.hadley.nz/

## 1. Names and Values

### Binding Basics
Names reference values, not contain them. Multiple names can bind to the same object.

```r
x <- c(1, 2, 3)
y <- x  # y references same object as x
```

### Copy-on-Modify
R creates copies when modifying objects with multiple bindings:
```r
x <- c(1, 2, 3)
y <- x
y[[3]] <- 4  # Creates new object; x unchanged
```

Use `tracemem()` to observe copies.

### Modify-in-Place Exceptions
1. Objects with single binding may modify in place
2. Environments always use reference semantics

### Memory Tools
```r
lobstr::obj_addr(x)  # Object address
lobstr::obj_size(x)  # Memory size
```

## 2. Vectors

### Two Types
- **Atomic vectors**: All elements same type (logical, integer, double, character)
- **Lists**: Elements can be different types

### Coercion Order
character → double → integer → logical

### Attributes
```r
attr(x, "name")           # Get attribute
attributes(x)             # All attributes
structure(x, attr = val)  # Set attributes
```

Key attributes: `names`, `dim`, `class`

### S3 Vectors
| Type | Base | Description |
|------|------|-------------|
| Factor | integer | Categorical with `levels` |
| Date | double | Days since 1970-01-01 |
| POSIXct | double | Seconds since 1970-01-01 |
| difftime | double | Duration with `units` |

### Data Frames vs Tibbles
```r
df <- data.frame(x = 1:3, y = c("a", "b", "c"))
tb <- tibble::tibble(x = 1:3, y = c("a", "b", "c"))
```

## 3. Subsetting

### Three Operators
| Operator | Returns | Use |
|----------|---------|-----|
| `[` | Same type | Multiple elements |
| `[[` | Simplified | Single element |
| `$` | Simplified | Named element (partial match) |

### Six Subsetting Methods
```r
x[c(1, 3)]      # Positive integers
x[-c(1, 3)]     # Negative integers (exclude)
x[c(TRUE, FALSE)] # Logical
x["name"]       # Character (by name)
x[]             # Nothing (returns all)
x[0]            # Zero (empty result)
```

### Preserve Dimensions
```r
df[1, , drop = FALSE]  # Keep data frame structure
```

## 4. Control Flow

### Conditionals
```r
if (condition) {
  # code
} else if (condition2) {
  # code
} else {
  # code
}

# Vectorized
ifelse(test, yes, no)
dplyr::case_when(
  condition1 ~ result1,
  condition2 ~ result2,
  TRUE ~ default
)
```

### Loops
```r
for (item in vector) { }
while (condition) { }
repeat { if (condition) break }
```

## 5. Functions

### Three Components
```r
formals(fn)     # Arguments
body(fn)        # Code
environment(fn) # Enclosing environment
```

### Lexical Scoping Rules
1. **Name masking**: Inner scope shadows outer
2. **Fresh start**: New environment each call
3. **Dynamic lookup**: Values found at runtime

### Lazy Evaluation
Arguments evaluated only when accessed. Implemented via promises.

### Special Arguments
```r
f <- function(...) {
  args <- list(...)  # Capture all
  ..1                # First argument
}
```

## 6. Environments

### Properties
- Every name unique
- Names unordered
- Has parent environment
- Reference semantics (modified in place)

### Key Functions
```r
rlang::env()              # Create
env_names(e)              # List bindings
env_has(e, "x")           # Check binding
env_parent(e)             # Get parent
env_unbind(e, "x")        # Remove binding
```

### Super Assignment
```r
x <<- value  # Modify in parent environment
```

### Special Environments
- **Global**: User workspace
- **Package**: Each attached package
- **Function**: Where function was defined
- **Execution**: Created for each function call

## 7. Conditions

### Signal Conditions
```r
stop("error")       # Error (stops execution)
warning("warning")  # Warning (continues)
message("info")     # Message (informational)
```

### Handle Conditions
```r
# Simple
try(expr)
suppressWarnings(expr)
suppressMessages(expr)

# Advanced - exiting handler
tryCatch(
  error = function(cnd) "handled",
  expr
)

# Advanced - calling handler
withCallingHandlers(
  warning = function(cnd) { },
  expr
)
```

### Custom Conditions
```r
rlang::abort(
  "error_type",
  message = "Description",
  custom_field = value
)
```
