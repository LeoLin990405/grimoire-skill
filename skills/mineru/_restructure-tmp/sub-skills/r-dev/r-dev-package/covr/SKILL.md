---
name: covr
description: R covr package for test coverage. Use for measuring and reporting test coverage of R packages.
---

# covr

Test coverage for R packages.

## Basic Usage

```r
library(covr)

# Calculate coverage
cov <- package_coverage()

# View report
report(cov)

# Print summary
cov
```

## Coverage Types

```r
# Package coverage
package_coverage()

# File coverage
file_coverage("R/myfile.R", "tests/testthat/test-myfile.R")

# Function coverage
function_coverage("myfunction", test_file = "tests/test.R")

# Code coverage
code_coverage(source_code, test_code)
```

## Coverage Report

```r
# Interactive HTML report
report(cov)

# Zero coverage
zero_coverage(cov)

# Coverage by file
coverage_to_list(cov)
```

## Codecov Integration

```r
# Upload to Codecov
codecov(token = "YOUR_TOKEN")

# In GitHub Actions
# - uses: codecov/codecov-action@v3
```

## Coveralls Integration

```r
# Upload to Coveralls
coveralls(token = "YOUR_TOKEN")
```

## Exclusions

```r
# Exclude lines with comments
# nocov start
code_to_exclude()
# nocov end

# Single line exclusion
x <- 1 # nocov
```

## Options

```r
# Set options
options(covr.exclude_pattern = "# nocov")
options(covr.exclude_start = "# nocov start")
options(covr.exclude_end = "# nocov end")
```

## CI Configuration

```yaml
# .github/workflows/test-coverage.yaml
on: push
jobs:
  test-coverage:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: r-lib/actions/setup-r@v2
      - name: Test coverage
        run: |
          install.packages("covr")
          covr::codecov()
        shell: Rscript {0}
```

## Percent Coverage

```r
# Get percent
percent_coverage(cov)

# By expression type
tally_coverage(cov)
```
