---
name: r-dev-docs
description: R documentation with pkgdown, roxygen2, rmarkdown. Use for package websites and documentation.
---

# R Documentation

Package documentation and websites.

## pkgdown

```r
library(pkgdown)

# Build site
build_site()

# Components
build_home()
build_reference()
build_articles()
build_news()

# Preview
preview_site()
```

## _pkgdown.yml

```yaml
url: https://mypackage.github.io/mypackage

template:
  bootstrap: 5
  bootswatch: flatly

navbar:
  structure:
    left: [intro, reference, articles]
    right: [search, github]
  components:
    articles:
      text: Articles
      menu:
        - text: Getting Started
          href: articles/intro.html
        - text: Advanced Usage
          href: articles/advanced.html

reference:
  - title: Data Manipulation
    contents:
      - filter_data
      - transform_data
  - title: Visualization
    contents:
      - starts_with("plot_")

articles:
  - title: Tutorials
    navbar: ~
    contents:
      - intro
      - advanced
```

## Vignettes

```r
# Create vignette
usethis::use_vignette("intro")

# Vignette header
---
title: "Introduction to mypackage"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Introduction to mypackage}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---
```

## roxygen2 Tags

```r
#' @title Function Title
#' @description Detailed description
#' @details Additional details
#' @param x Parameter description
#' @return Return value description
#' @export
#' @examples
#' \dontrun{
#'   slow_example()
#' }
#' @family related functions
#' @seealso \code{\link{other_function}}
#' @references Paper citation
#' @keywords internal
#' @noRd
```

## README.Rmd

```r
# Create
usethis::use_readme_rmd()

# Build
devtools::build_readme()

# Badge examples
[![R-CMD-check](https://github.com/user/repo/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/user/repo/actions)
[![Codecov](https://codecov.io/gh/user/repo/branch/main/graph/badge.svg)](https://codecov.io/gh/user/repo)
```
