---
name: r-dev-oop
description: R OOP with R6, S3, S4. Use for object-oriented programming patterns.
---

# R Object-Oriented Programming

OOP systems in R.

## R6 Classes

```r
library(R6)

# Define class
Person <- R6Class("Person",
  public = list(
    name = NULL,
    age = NULL,
    
    initialize = function(name, age = NA) {
      self$name <- name
      self$age <- age
    },
    
    greet = function() {
      cat("Hello, I'm", self$name, "\n")
    },
    
    set_age = function(age) {
      private$validate_age(age)
      self$age <- age
    }
  ),
  
  private = list(
    validate_age = function(age) {
      if (!is.numeric(age) || age < 0) {
        stop("Invalid age")
      }
    }
  ),
  
  active = list(
    birth_year = function() {
      as.integer(format(Sys.Date(), "%Y")) - self$age
    }
  )
)

# Use
p <- Person$new("Alice", 30)
p$greet()
p$birth_year

# Inheritance
Employee <- R6Class("Employee",
  inherit = Person,
  public = list(
    title = NULL,
    initialize = function(name, age, title) {
      super$initialize(name, age)
      self$title <- title
    }
  )
)
```

## S3 Classes

```r
# Constructor
new_person <- function(name, age) {
  structure(
    list(name = name, age = age),
    class = "person"
  )
}

# Validator
validate_person <- function(x) {
  if (!is.character(x$name)) stop("name must be character")
  if (!is.numeric(x$age)) stop("age must be numeric")
  x
}

# Helper
person <- function(name, age) {
  validate_person(new_person(name, age))
}

# Methods
print.person <- function(x, ...) {
  cat("Person:", x$name, "(", x$age, ")\n")
}

summary.person <- function(object, ...) {
  cat("Name:", object$name, "\n")
  cat("Age:", object$age, "\n")
}

# Generic
greet <- function(x) UseMethod("greet")
greet.person <- function(x) cat("Hello, I'm", x$name, "\n")
greet.default <- function(x) cat("Hello\n")
```

## S4 Classes

```r
library(methods)

# Define class
setClass("Person",
  slots = c(
    name = "character",
    age = "numeric"
  ),
  prototype = list(
    name = NA_character_,
    age = NA_real_
  )
)

# Constructor
Person <- function(name, age) {
  new("Person", name = name, age = age)
}

# Validity
setValidity("Person", function(object) {
  if (length(object@name) != 1) return("name must be length 1")
  if (object@age < 0) return("age must be positive")
  TRUE
})

# Methods
setGeneric("greet", function(x) standardGeneric("greet"))
setMethod("greet", "Person", function(x) {
  cat("Hello, I'm", x@name, "\n")
})

# Inheritance
setClass("Employee",
  contains = "Person",
  slots = c(title = "character")
)
```
