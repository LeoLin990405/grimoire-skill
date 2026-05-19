# Advanced R - Part III: Object-Oriented Programming

Based on "Advanced R" (2nd ed) by Hadley Wickham.
Book URL: https://adv-r.hadley.nz/

## Overview

R has multiple OOP systems:

| System | Style | Dispatch | Mutability |
|--------|-------|----------|------------|
| S3 | Functional | Generic function | Copy-on-modify |
| S4 | Functional | Generic function | Copy-on-modify |
| R6 | Encapsulated | Method belongs to object | Reference |
| RC | Encapsulated | Method belongs to object | Reference |

## 11. S3

### Basics
S3 object = base type + `class` attribute

```r
# Create S3 object
x <- structure(list(), class = "myclass")
# Or
x <- list()
class(x) <- "myclass"
```

### Three Functions Pattern

**Constructor** (developer-facing):
```r
new_myclass <- function(x = double(), name = character()) {
  stopifnot(is.double(x), is.character(name))
  structure(list(x = x, name = name), class = "myclass")
}
```

**Validator**:
```r
validate_myclass <- function(x) {
  if (length(x$name) != 1) stop("name must be length 1")
  x
}
```

**Helper** (user-facing):
```r
myclass <- function(x, name) {
  x <- as.double(x)
  validate_myclass(new_myclass(x, name))
}
```

### Generics and Methods
```r
# Create generic
my_generic <- function(x, ...) {
  UseMethod("my_generic")
}

# Create method
my_generic.myclass <- function(x, ...) {
  # implementation
}

# Default method
my_generic.default <- function(x, ...) {
  stop("Not supported")
}
```

### Method Dispatch
```r
sloop::s3_dispatch(print(x))  # Show dispatch
sloop::s3_methods_generic("print")  # All print methods
sloop::s3_methods_class("factor")   # All factor methods
```

### Inheritance
```r
class(x) <- c("subclass", "superclass")

# In method, call parent:
NextMethod()
```

## 12. R6

### Creating Classes
```r
library(R6)

Person <- R6Class("Person",
  public = list(
    name = NULL,
    initialize = function(name) {
      self$name <- name
    },
    greet = function() {
      cat("Hello, I'm", self$name, "\n")
    }
  )
)

# Create instance
bob <- Person$new("Bob")
bob$greet()
```

### Private Members
```r
Account <- R6Class("Account",
  public = list(
    initialize = function(balance) {
      private$.balance <- balance
    },
    deposit = function(amount) {
      private$.balance <- private$.balance + amount
    },
    get_balance = function() private$.balance
  ),
  private = list(
    .balance = NULL
  )
)
```

### Active Bindings
```r
Circle <- R6Class("Circle",
  public = list(
    initialize = function(radius) {
      private$.radius <- radius
    }
  ),
  private = list(
    .radius = NULL
  ),
  active = list(
    radius = function(value) {
      if (missing(value)) private$.radius
      else private$.radius <- value
    },
    area = function() pi * private$.radius^2
  )
)
```

### Inheritance
```r
Child <- R6Class("Child",
  inherit = Parent,
  public = list(
    method = function() {
      super$method()  # Call parent method
      # additional code
    }
  )
)
```

### Reference Semantics
```r
x <- Account$new(100)
y <- x           # Same object!
y$deposit(50)
x$get_balance()  # 150

# Explicit copy
z <- x$clone()
```

## 13. S4

### Defining Classes
```r
setClass("Person",
  slots = c(
    name = "character",
    age = "numeric"
  )
)

# Create instance
new("Person", name = "Alice", age = 30)
```

### Generics and Methods
```r
setGeneric("age", function(x) standardGeneric("age"))

setMethod("age", "Person", function(x) x@age)
```

### Accessors
```r
x@slot_name      # Access slot
slot(x, "name")  # Programmatic access
```

## Choosing a System

| Use Case | Recommended |
|----------|-------------|
| Simple, interactive | S3 |
| Formal, validated | S4 |
| Mutable state | R6 |
| Package development | S3 or S4 |
| Complex hierarchies | R6 |
