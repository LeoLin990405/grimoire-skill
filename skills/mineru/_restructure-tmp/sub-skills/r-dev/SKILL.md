---
name: r-dev
description: R development packages. Use for package development, testing, documentation, code style, and IDE setup.
---

# R Development Skill

## Sub-skills

| Sub-skill | Description |
|-----------|-------------|
| [r-dev-package](r-dev-package/SKILL.md) | devtools, usethis, roxygen2 |
| [r-dev-testing](r-dev-testing/SKILL.md) | testthat, covr, mockery |
| [r-dev-docs](r-dev-docs/SKILL.md) | pkgdown, vignettes, README |
| [r-dev-oop](r-dev-oop/SKILL.md) | R6, S3, S4 classes |

R package development and tooling.

## Package Development

| Package | Description |
|---------|-------------|
| **devtools** ★ | Package development tools |
| **usethis** ★ | Workflow automation |
| **roxygen2** ★ | Documentation from comments |
| **pkgdown** | Package websites |
| **testthat** ★ | Unit testing |
| **covr** | Test coverage |

## Code Quality

| Package | Description |
|---------|-------------|
| **lintr** ★ | Static code analysis |
| **styler** | Code formatting |
| **goodpractice** | Package best practices |

## Documentation

| Package | Description |
|---------|-------------|
| **roxygen2** ★ | In-source documentation |
| **sinew** | Generate roxygen skeletons |
| **staticdocs** | Static HTML docs |

## OOP Systems

| Package | Description |
|---------|-------------|
| **R6** ★ | Encapsulated OOP |
| **S7** | Next-gen OOP (experimental) |

## Debugging & Profiling

| Package | Description |
|---------|-------------|
| **pryr** | Understand R internals |
| **lineprof** | Line profiling |
| **profvis** | Interactive profiling |

## Environment & Reproducibility

| Package | Description |
|---------|-------------|
| **renv** ★ | Project environments |
| **box** | Modern module system |
| **import** | Import mechanism |
| **installr** | Install software (Windows) |

## Async & Promises

| Package | Description |
|---------|-------------|
| **promises** | Async programming |
| **future** | Parallel/distributed processing |

## Deployment

| Package | Description |
|---------|-------------|
| **Rocker** | Docker configurations |
| **drat** | R repositories on GitHub |

## IDEs & Editors

| Tool | Description |
|------|-------------|
| **RStudio** ★ | Full-featured IDE |
| **VSCode + vscode-R** | VS Code support |
| **radian** | Modern R console |
| **IRkernel** | Jupyter kernel |
| **Nvim-R** | Neovim plugin |

## Quick Examples

```r
# Create new package
usethis::create_package("mypackage")

# Add dependencies
usethis::use_package("dplyr")
usethis::use_pipe()  # Add %>%

# Documentation
usethis::use_roxygen_md()
devtools::document()

# Testing
usethis::use_testthat()
usethis::use_test("myfunction")
devtools::test()

# Check package
devtools::check()

# Build and install
devtools::build()
devtools::install()

# roxygen2 documentation
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

# testthat tests
test_that("add works", {
  expect_equal(add(1, 2), 3)
  expect_equal(add(-1, 1), 0)
  expect_error(add("a", 1))
})

# R6 class
library(R6)
Person <- R6Class("Person",
  public = list(
    name = NULL,
    initialize = function(name) {
      self$name <- name
    },
    greet = function() {
      cat("Hello, I'm", self$name, "\n")
    }
  )
)
p <- Person$new("Alice")
p$greet()

# renv workflow
renv::init()      # Initialize
renv::snapshot()  # Save state
renv::restore()   # Restore state

# Profiling
profvis::profvis({
  # Code to profile
  result <- slow_function(data)
})
```

## Package Development Workflow

```r
# 1. Create package
usethis::create_package("mypackage")

# 2. Set up Git
usethis::use_git()
usethis::use_github()

# 3. Add license
usethis::use_mit_license()

# 4. Set up testing
usethis::use_testthat()

# 5. Add CI
usethis::use_github_action_check_standard()

# 6. Write code in R/
# 7. Document with roxygen2
devtools::document()

# 8. Write tests in tests/testthat/
devtools::test()

# 9. Check package
devtools::check()

# 10. Build pkgdown site
usethis::use_pkgdown()
pkgdown::build_site()
```

## Resources

- R Packages book: https://r-pkgs.org/
- devtools: https://devtools.r-lib.org/
- testthat: https://testthat.r-lib.org/
- roxygen2: https://roxygen2.r-lib.org/
- R6: https://r6.r-lib.org/
