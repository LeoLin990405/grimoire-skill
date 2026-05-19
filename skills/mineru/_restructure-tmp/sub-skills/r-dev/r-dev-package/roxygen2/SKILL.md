---
name: roxygen2
description: R roxygen2 package for documentation. Use for in-source documentation with special comments.
---

# roxygen2 Package

In-source documentation for R packages.

## Basic Tags

```r
#' Add two numbers
#'
#' @param x A number
#' @param y A number
#' @return The sum of x and y
#' @export
#' @examples
#' add(1, 2)
add <- function(x, y) {
  x + y
}
```

## Common Tags

```r
#' @title Short title
#' @description Longer description
#' @details Even more details
#'
#' @param x Description of x
#' @param ... Additional arguments
#' @return What the function returns
#'
#' @export
#' @keywords internal
#'
#' @examples
#' \dontrun{
#'   slow_function()
#' }
#'
#' @seealso \code{\link{other_function}}
#' @references Paper citation
```

## S3 Methods

```r
#' @export
#' @rdname print
print.myclass <- function(x, ...) {
  cat("My object\n")
}

#' @export
#' @method summary myclass
summary.myclass <- function(object, ...) {
  # ...
}
```

## Imports

```r
#' @import dplyr
#' @importFrom ggplot2 ggplot aes
#' @importFrom magrittr %>%
NULL

#' @useDynLib mypackage, .registration = TRUE
```

## Data Documentation

```r
#' My dataset
#'
#' @format A data frame with 100 rows and 3 columns:
#' \describe{
#'   \item{x}{Description of x}
#'   \item{y}{Description of y}
#'   \item{z}{Description of z}
#' }
#' @source Where the data came from
"mydata"
```

## Package Documentation

```r
#' mypackage: A brief description
#'
#' @docType package
#' @name mypackage
"_PACKAGE"
```

## Generate Docs

```r
devtools::document()
# Or
roxygen2::roxygenise()
```
