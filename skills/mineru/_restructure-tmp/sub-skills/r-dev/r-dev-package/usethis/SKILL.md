---
name: usethis
description: R usethis package for workflow automation. Use for package setup, Git, GitHub, and project configuration.
---

# usethis Package

Workflow automation for R packages and projects.

## Create Package

```r
library(usethis)

# New package
create_package("mypackage")

# New project
create_project("myproject")
```

## Package Setup

```r
# License
use_mit_license()
use_gpl3_license()
use_cc0_license()

# Documentation
use_roxygen_md()
use_package_doc()
use_news_md()
use_readme_rmd()

# Dependencies
use_package("dplyr")
use_package("ggplot2", type = "Suggests")
use_pipe()  # Add %>%
use_tibble()
```

## Testing

```r
use_testthat()
use_test("myfunction")
use_coverage()
```

## Git & GitHub

```r
use_git()
use_github()
use_github_action_check_standard()
use_github_action("pkgdown")
use_github_pages()
```

## Data

```r
# Internal data
use_data_raw("dataset")
use_data(mydata, internal = TRUE)

# External data
use_data(mydata)
```

## Vignettes

```r
use_vignette("introduction")
use_article("advanced-usage")
```

## CI/CD

```r
use_github_action_check_standard()
use_github_action_check_release()
use_github_action("test-coverage")
use_github_action("pkgdown")
```

## Other

```r
# Add file
use_r("myfunction")
use_test("myfunction")

# Badges
use_cran_badge()
use_lifecycle_badge("experimental")
use_coverage_badge()

# Imports
use_import_from("dplyr", "filter")
```
