---
name: testthat
description: R testthat package for unit testing. Use for writing and running unit tests for R packages.
---

# testthat

Unit testing for R.

## Setup

```r
library(testthat)

# In package development
usethis::use_testthat()

# Creates tests/testthat/ directory
```

## Basic Tests

```r
test_that("description of test", {
  expect_equal(1 + 1, 2)
  expect_true(is.numeric(1))
  expect_false(is.character(1))
})
```

## Expectations

```r
# Equality
expect_equal(x, y)           # Near equality
expect_identical(x, y)       # Exact equality

# Comparison
expect_lt(x, y)              # Less than
expect_lte(x, y)             # Less than or equal
expect_gt(x, y)              # Greater than
expect_gte(x, y)             # Greater than or equal

# Type
expect_type(x, "double")
expect_s3_class(x, "data.frame")
expect_s4_class(x, "Matrix")

# Length/dimension
expect_length(x, 10)

# NULL
expect_null(x)

# Output
expect_output(print(x), "pattern")
expect_message(f(), "message")
expect_warning(f(), "warning")
expect_error(f(), "error")
expect_silent(f())

# Matching
expect_match(x, "regex")
```

## Test Files

```r
# tests/testthat/test-myfunction.R
test_that("myfunction works", {
  result <- myfunction(1, 2)
  expect_equal(result, 3)
})

test_that("myfunction handles errors", {
  expect_error(myfunction("a", "b"))
})
```

## Running Tests

```r
# Run all tests
devtools::test()

# Run specific file
test_file("tests/testthat/test-myfunction.R")

# Run interactively
test_that("quick test", {
  expect_equal(1, 1)
})
```

## Fixtures

```r
# Setup/teardown
test_that("test with setup", {
  # Setup
  tmp <- tempfile()
  write.csv(mtcars, tmp)

  # Test
  data <- read.csv(tmp)
  expect_equal(nrow(data), 32)

  # Cleanup (automatic with withr)
})

# Using withr
test_that("test with withr", {
  withr::local_tempfile(tmp)
  # tmp is cleaned up automatically
})
```

## Skipping

```r
test_that("conditional test", {
  skip_on_cran()
  skip_on_ci()
  skip_if_not_installed("pkg")
  skip_if(condition, "reason")

  # Test code
})
```

## Snapshots

```r
test_that("output matches snapshot", {
  expect_snapshot(print(summary(lm(mpg ~ wt, mtcars))))
})

# Update snapshots
snapshot_accept()
```
