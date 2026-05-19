---
name: rcmdcheck
description: R rcmdcheck package for R CMD check. Use for running R CMD check with better output.
---

# rcmdcheck

Run R CMD check from R.

## Basic Usage

```r
library(rcmdcheck)

# Check current package
rcmdcheck()

# Check specific package
rcmdcheck("path/to/package")
```

## Options

```r
# With arguments
rcmdcheck(args = c("--no-manual", "--as-cran"))

# Build arguments
rcmdcheck(build_args = "--no-build-vignettes")

# Check directory
rcmdcheck(check_dir = "check_output")
```

## Common Arguments

```r
# CRAN-like check
rcmdcheck(args = "--as-cran")

# Skip manual
rcmdcheck(args = "--no-manual")

# Skip vignettes
rcmdcheck(args = "--no-vignettes")

# Skip tests
rcmdcheck(args = "--no-tests")

# Skip examples
rcmdcheck(args = "--no-examples")

# Multiple
rcmdcheck(args = c("--no-manual", "--no-vignettes"))
```

## Results

```r
# Run check
res <- rcmdcheck()

# Access results
res$errors
res$warnings
res$notes

# Status
res$status  # 0 = success

# Print summary
print(res)
```

## Error on Issues

```r
# Error if check fails
rcmdcheck(error_on = "error")

# Error on warnings too
rcmdcheck(error_on = "warning")

# Error on notes
rcmdcheck(error_on = "note")
```

## CI Usage

```r
# In CI scripts
rcmdcheck::rcmdcheck(
  args = "--no-manual",
  error_on = "warning",
  check_dir = "check"
)
```

## Compare Checks

```r
# Compare two check results
compare_checks(check1, check2)

# Compare to CRAN
cran_check_results("packagename")
```

## Revdep Checks

```r
# Reverse dependency checks
library(revdepcheck)
revdep_check()
```
