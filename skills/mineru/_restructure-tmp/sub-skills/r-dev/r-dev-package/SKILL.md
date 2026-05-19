---
name: r-dev-package
description: R package development with devtools, usethis, roxygen2. Use for creating and maintaining R packages.
---

# R Package Development

Creating R packages.

## usethis Setup

```r
library(usethis)

# Create package
create_package("mypackage")

# Add components
use_r("function_name")
use_test("function_name")
use_data(dataset)
use_data_raw("dataset")

# Documentation
use_readme_rmd()
use_vignette("intro")
use_news_md()
use_pkgdown()

# Dependencies
use_package("dplyr")
use_pipe()
use_tibble()

# Git/GitHub
use_git()
use_github()
use_github_action_check_standard()

# License
use_mit_license()
use_gpl3_license()
```

## devtools Workflow

```r
library(devtools)

# Development
load_all()        # Load package
document()        # Generate docs
test()            # Run tests
check()           # R CMD check

# Build
build()
install()

# Continuous
dev_mode()
```

## roxygen2 Documentation

```r
#' Title of function
#'
#' Description of what the function does.
#'
#' @param x Description of x
#' @param y Description of y
#' @return Description of return value
#' @export
#' @examples
#' my_function(1, 2)
#'
#' @seealso \code{\link{other_function}}
#' @importFrom dplyr filter select
my_function <- function(x, y) {
  # code
}

#' @rdname my_function
#' @export
my_function2 <- function(x) {
  # code
}
```

## DESCRIPTION

```
Package: mypackage
Title: What the Package Does
Version: 0.1.0
Authors@R: person("Name", "Last", email = "email@example.com", role = c("aut", "cre"))
Description: Longer description of what the package does.
License: MIT + file LICENSE
Encoding: UTF-8
Roxygen: list(markdown = TRUE)
RoxygenNote: 7.2.3
Imports:
    dplyr,
    ggplot2
Suggests:
    testthat (>= 3.0.0)
Config/testthat/edition: 3
```
