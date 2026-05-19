---
name: covr
description: R covr package for test coverage. Use for measuring and reporting code coverage.
---

# covr Package

Test coverage for R packages.

## Basic Usage

```r
library(covr)

# Package coverage
cov <- package_coverage()

# View report
report(cov)

# Summary
percent_coverage(cov)
```

## Coverage Types

```r
# All coverage
cov <- package_coverage(type = "all")

# Only tests
cov <- package_coverage(type = "tests")

# Only examples
cov <- package_coverage(type = "examples")

# Only vignettes
cov <- package_coverage(type = "vignettes")
```

## File Coverage

```r
# Single file
cov <- file_coverage("R/myfile.R", "tests/testthat/test-myfile.R")

# Function coverage
cov <- function_coverage("myfunction", test_file = "tests/testthat/test-myfunction.R")
```

## Reports

```r
# Interactive HTML report
report(cov)

# Zero coverage
zero_coverage(cov)

# Coverage by file
coverage_to_list(cov)
```

## CI Integration

```r
# Codecov
codecov(token = "YOUR_TOKEN")

# Coveralls
coveralls(token = "YOUR_TOKEN")
```

## GitHub Actions

```yaml
# .github/workflows/test-coverage.yaml
on: [push, pull_request]

jobs:
  test-coverage:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: r-lib/actions/setup-r@v2
      - uses: r-lib/actions/setup-r-dependencies@v2
      - name: Test coverage
        run: |
          covr::codecov()
        shell: Rscript {0}
```

## Exclusions

```r
# In code, exclude lines
# nocov start
code_to_exclude()
# nocov end

# Single line
x <- 1 # nocov
```
