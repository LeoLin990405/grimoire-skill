---
name: mockery
description: R mockery package for mocking in tests. Use for stubbing functions and mocking dependencies.
---

# mockery Package

Mocking for unit tests.

## Basic Mocking

```r
library(mockery)
library(testthat)

test_that("function uses dependency", {
  # Create mock
  m <- mock(42)

  # Stub the function
  stub(my_function, "dependency_function", m)

  # Run test
  result <- my_function()

  # Verify mock was called

  expect_called(m, 1)
  expect_equal(result, 42)
})
```

## Mock Return Values

```r
# Single return value
m <- mock(42)

# Multiple return values (cycle through)
m <- mock(1, 2, 3, cycle = TRUE)

# Different values each call
m <- mock(1, 2, 3)
m()  # 1
m()  # 2
m()  # 3
```

## Verify Calls

```r
m <- mock(TRUE)
stub(my_function, "api_call", m)
my_function("arg1", "arg2")

# Check call count
expect_called(m, 1)

# Check arguments
expect_args(m, 1, "arg1", "arg2")

# Get all calls
mock_calls(m)
mock_args(m)
```

## Stub in Namespace

```r
test_that("stubs package function", {
  m <- mock(data.frame(x = 1))

  # Stub in specific namespace
  stub(my_function, "dplyr::filter", m)

  result <- my_function()
  expect_called(m, 1)
})
```

## Mock Side Effects

```r
# Mock that throws error
m <- mock(stop("API error"))

# Mock with side effect
counter <- 0
m <- mock(side_effect = function(...) {
  counter <<- counter + 1
  return(counter)
})
```

## Example: API Testing

```r
test_that("handles API response", {
  mock_response <- list(status = 200, data = list(id = 1))
  m <- mock(mock_response)

  stub(fetch_data, "httr::GET", m)

  result <- fetch_data("https://api.example.com")

  expect_called(m, 1)
  expect_equal(result$id, 1)
})
```
