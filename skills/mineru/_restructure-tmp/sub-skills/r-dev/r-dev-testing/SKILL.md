---
name: r-dev-testing
description: R testing with testthat, covr, mockery. Use for unit tests, coverage, and mocking.
---

# R Testing

Unit testing and coverage.

## testthat

```r
library(testthat)

# Basic tests
test_that("addition works", {
  expect_equal(1 + 1, 2)
  expect_identical(1L + 1L, 2L)
})

# Expectations
expect_equal(x, y)           # Equal with tolerance
expect_identical(x, y)       # Exactly identical
expect_true(x)
expect_false(x)
expect_null(x)
expect_length(x, n)
expect_named(x, c("a", "b"))
expect_type(x, "double")
expect_s3_class(x, "data.frame")
expect_s4_class(x, "Matrix")

# Errors/warnings
expect_error(f(), "message")
expect_warning(f())
expect_message(f())
expect_silent(f())
expect_condition(f())

# Output
expect_output(print(x), "pattern")
expect_snapshot(f())
expect_snapshot_output(print(x))

# Comparisons
expect_gt(x, y)
expect_gte(x, y)
expect_lt(x, y)
expect_lte(x, y)
expect_match(x, "regex")
```

## Test Organization

```r
# tests/testthat/test-myfunction.R
test_that("myfunction handles basic input", {
  result <- myfunction(1, 2)
  expect_equal(result, 3)
})

test_that("myfunction handles edge cases", {
  expect_error(myfunction(NULL))
  expect_equal(myfunction(0, 0), 0)
})

# Setup/teardown
setup({
  # runs before each test
})

teardown({
  # runs after each test
})

# Skip tests
skip_on_cran()
skip_on_ci()
skip_if_not_installed("pkg")
skip_if(condition, "reason")
```

## covr (Coverage)

```r
library(covr)

# Package coverage
cov <- package_coverage()
report(cov)
percent_coverage(cov)

# File coverage
file_coverage("R/file.R", "tests/testthat/test-file.R")

# Codecov
codecov(token = "TOKEN")
```

## mockery

```r
library(mockery)

# Mock function
m <- mock(10, 20, 30)
m()  # Returns 10
m()  # Returns 20

# Stub
stub(my_function, "other_function", 42)

# Verify calls
expect_called(m, 2)
expect_args(m, 1, arg1, arg2)
```
