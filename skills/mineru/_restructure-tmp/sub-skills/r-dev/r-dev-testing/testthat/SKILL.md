---
name: testthat
description: R testthat package for unit testing. Use for writing and running tests with expectations.
---

# testthat

Unit testing framework.

## Test Structure

```r
library(testthat)

# Test file: tests/testthat/test-function.R
test_that("description of test", {
  # Arrange
  x <- 1
  y <- 2
  
  # Act
  result <- add(x, y)
  
  # Assert
  expect_equal(result, 3)
})
```

## Expectations

```r
# Equality
expect_equal(x, y)              # Equal with tolerance
expect_identical(x, y)          # Exactly identical
expect_equivalent(x, y)         # Equal ignoring attributes

# Comparison
expect_true(x)
expect_false(x)
expect_null(x)
expect_na(x)

# Type
expect_type(x, "double")
expect_s3_class(x, "data.frame")
expect_s4_class(x, "Matrix")

# Length/names
expect_length(x, 5)
expect_named(x, c("a", "b"))
expect_named(x)  # Has names

# Numeric
expect_lt(x, y)   # Less than
expect_lte(x, y)  # Less than or equal
expect_gt(x, y)   # Greater than
expect_gte(x, y)  # Greater than or equal

# String
expect_match(x, "pattern")
expect_match(x, "pattern", fixed = TRUE)

# Error/warning/message
expect_error(f())
expect_error(f(), "error message")
expect_error(f(), class = "custom_error")
expect_warning(f())
expect_warning(f(), "warning message")
expect_message(f())
expect_message(f(), "message")
expect_condition(f())
expect_silent(f())

# Output
expect_output(print(x), "pattern")
expect_invisible(f())
expect_visible(f())

# Snapshots
expect_snapshot(f())
expect_snapshot_output(print(x))
expect_snapshot_error(f())
expect_snapshot_value(x)
expect_snapshot_file("output.png")
```

## Test Organization

```r
# Setup/teardown
setup({
  # Runs before each test file
  con <<- dbConnect(...)
})

teardown({
  # Runs after each test file
  dbDisconnect(con)
})

# Local setup
local_setup <- function(env = parent.frame()) {
  withr::defer(cleanup(), envir = env)
  # Setup code
}

# Skip tests
skip("reason")
skip_on_cran()
skip_on_ci()
skip_on_os("windows")
skip_if_not_installed("package")
skip_if(condition, "reason")
skip_if_offline()
```

## Running Tests

```r
# Run all tests
test_dir("tests/testthat")
test_package("mypackage")

# Run specific file
test_file("tests/testthat/test-function.R")

# Run with filter
test_dir("tests/testthat", filter = "function")

# Interactive
test_local()
```

## Mocking

```r
# Mock function
local_mocked_bindings(
  read_csv = function(...) data.frame(x = 1:3),
  .package = "readr"
)

# With mockery
library(mockery)
m <- mock(10, 20)
stub(my_function, "other_function", m)
```

## Fixtures

```r
# Test fixture file
# tests/testthat/fixtures/data.rds

# Use fixture
test_that("uses fixture", {
  data <- readRDS(test_path("fixtures", "data.rds"))
  expect_equal(nrow(data), 100)
})
```

## Reporters

```r
# Different output formats
test_dir("tests", reporter = "summary")
test_dir("tests", reporter = "minimal")
test_dir("tests", reporter = "progress")
test_dir("tests", reporter = "check")
```
