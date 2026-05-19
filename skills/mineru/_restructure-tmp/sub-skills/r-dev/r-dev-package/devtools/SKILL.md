---
name: devtools
description: R devtools package for package development. Use for loading, documenting, testing, and building R packages.
---

# devtools

Package development tools.

## Development Workflow

```r
library(devtools)

# Load package for development
load_all()

# Document (roxygen2)
document()

# Test
test()

# Check
check()

# Build
build()

# Install
install()
```

## Loading

```r
# Load all package code
load_all()
load_all("path/to/package")

# Unload
unload()

# Reload
reload()
```

## Documentation

```r
# Generate documentation from roxygen
document()

# Build manual
build_manual()

# Build vignettes
build_vignettes()

# Check documentation
check_man()
```

## Testing

```r
# Run all tests
test()

# Run specific test file
test_file("tests/testthat/test-function.R")

# Test coverage
test_coverage()
test_coverage_file("R/function.R")
```

## Checking

```r
# Full R CMD check
check()

# Quick check
check(args = "--no-examples")

# Check specific aspects
check_man()
check_examples()
check_tests()
check_vignettes()

# Check on CRAN
check_win_devel()
check_win_release()
check_rhub()
```

## Building

```r
# Build source package
build()

# Build binary package
build(binary = TRUE)

# Build and check
build_and_check()
```

## Installing

```r
# Install from local
install()
install("path/to/package")

# Install from GitHub
install_github("user/repo")
install_github("user/repo@branch")
install_github("user/repo@v1.0.0")

# Install from other sources
install_gitlab("user/repo")
install_bitbucket("user/repo")
install_url("https://example.com/package.tar.gz")
install_local("package.tar.gz")

# Install dependencies
install_deps()
install_dev_deps()
```

## Session

```r
# Session info
session_info()

# Package dependencies
package_deps("package")

# Dev mode
dev_mode()
dev_mode(on = FALSE)
```

## Release

```r
# Prepare for CRAN
release()

# Spell check
spell_check()

# Check reverse dependencies
revdep_check()
```
