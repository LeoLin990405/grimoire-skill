---
name: box
description: R box package for modular code. Use for creating reusable modules with explicit imports/exports.
---

# box

Modern module system for R.

## Basic Module

```r
# modules/data_utils.R
#' @export
load_data <- function(path) {
  read.csv(path)
}

#' @export
clean_data <- function(df) {
  na.omit(df)
}

# Private function (not exported)
helper <- function(x) {
  x * 2
}
```

## Using Modules

```r
# Import entire module
box::use(./modules/data_utils)
data_utils$load_data("data.csv")

# Import specific functions
box::use(./modules/data_utils[load_data, clean_data])
load_data("data.csv")

# Import with alias
box::use(./modules/data_utils[load = load_data])
load("data.csv")

# Import all exports
box::use(./modules/data_utils[...])
```

## Package Imports

```r
# Import from packages
box::use(dplyr[filter, select, mutate])
box::use(ggplot2[ggplot, aes, geom_point])

# Import entire package
box::use(dplyr)
dplyr$filter(df, x > 0)

# Import with alias
box::use(dt = data.table)
dt$fread("data.csv")
```

## Module Structure

```r
# project/
# ├── main.R
# └── modules/
#     ├── data/
#     │   ├── __init__.R
#     │   ├── load.R
#     │   └── clean.R
#     └── analysis/
#         ├── __init__.R
#         └── models.R

# modules/data/__init__.R
#' @export
box::use(./load[...])
#' @export
box::use(./clean[...])

# main.R
box::use(./modules/data)
data$load_csv("file.csv")
```

## Reexporting

```r
# modules/utils.R
# Reexport from another module
#' @export
box::use(./helpers[helper_func])

# Reexport from package
#' @export
box::use(dplyr[filter, select])
```

## Documentation

```r
# modules/math.R

#' Add two numbers
#'
#' @param x First number
#' @param y Second number
#' @return Sum of x and y
#' @export
add <- function(x, y) {
  x + y
}

# Access documentation
box::use(./modules/math)
box::help(math$add)
```

## Module Options

```r
# Set module search path
options(box.path = c("~/R/modules", "./modules"))

# Reload module (during development)
box::reload(data_utils)

# Unload module
box::unload(data_utils)
```

## S3 Methods

```r
# modules/print_methods.R

#' @export
print.my_class <- function(x, ...) {
  cat("My class object:\n")
  print(unclass(x))
}

# Register S3 method
box::register_S3_method("print", "my_class", print.my_class)
```

## Testing Modules

```r
# tests/test_data_utils.R
box::use(../modules/data_utils[load_data, clean_data])
box::use(testthat[test_that, expect_equal])

test_that("load_data works", {
  df <- load_data("test_data.csv")
  expect_equal(nrow(df), 100)
})
```

## Best Practices

```r
# 1. One module per file
# 2. Explicit exports with #' @export
# 3. Use relative imports for local modules
# 4. Use package imports for external packages
# 5. Keep modules focused and small

# Good module structure
# modules/
# ├── data/
# │   ├── load.R      # Data loading functions
# │   ├── clean.R     # Data cleaning functions
# │   └── transform.R # Data transformation
# ├── analysis/
# │   ├── stats.R     # Statistical functions
# │   └── models.R    # Model fitting
# └── viz/
#     └── plots.R     # Visualization functions
```

## Migration from source()

```r
# Before (source)
source("utils.R")
my_function()

# After (box)
box::use(./utils[my_function])
my_function()

# Or import all
box::use(./utils[...])
```
