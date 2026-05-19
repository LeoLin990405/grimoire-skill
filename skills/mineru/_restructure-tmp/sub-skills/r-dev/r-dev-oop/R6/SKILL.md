---
name: R6
description: R R6 package for OOP. Use for encapsulated object-oriented programming with reference semantics.
---

# R6 Package

Encapsulated OOP with reference semantics.

## Basic Class

```r
library(R6)

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
    }
  )
)

# Create instance
p <- Person$new("Alice", 30)
p$greet()
```

## Private Members

```r
BankAccount <- R6Class("BankAccount",
  private = list(
    balance = 0
  ),

  public = list(
    deposit = function(amount) {
      private$balance <- private$balance + amount
      invisible(self)
    },

    withdraw = function(amount) {
      if (amount > private$balance) stop("Insufficient funds")
      private$balance <- private$balance - amount
      invisible(self)
    },

    get_balance = function() {
      private$balance
    }
  )
)
```

## Active Bindings

```r
Circle <- R6Class("Circle",
  private = list(
    .radius = 1
  ),

  active = list(
    radius = function(value) {
      if (missing(value)) return(private$.radius)
      private$.radius <- value
    },

    area = function() {
      pi * private$.radius^2
    }
  )
)

c <- Circle$new()
c$radius <- 5
c$area  # Computed property
```

## Inheritance

```r
Animal <- R6Class("Animal",
  public = list(
    name = NULL,
    initialize = function(name) self$name <- name,
    speak = function() cat("...\n")
  )
)

Dog <- R6Class("Dog",
  inherit = Animal,
  public = list(
    speak = function() cat("Woof!\n")
  )
)

d <- Dog$new("Rex")
d$speak()
```

## Method Chaining

```r
# Return invisible(self) for chaining
account$deposit(100)$withdraw(50)$get_balance()
```

## Clone

```r
p2 <- p$clone()
p2 <- p$clone(deep = TRUE)  # Deep copy
```
