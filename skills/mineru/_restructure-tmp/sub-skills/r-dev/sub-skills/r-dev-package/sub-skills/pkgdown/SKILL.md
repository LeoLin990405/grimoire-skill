---
name: pkgdown
description: R pkgdown package for package websites. Use for generating documentation websites from R packages.
---

# pkgdown Package

Build package documentation websites.

## Quick Start

```r
library(pkgdown)

# Build site
build_site()

# Preview
preview_site()
```

## Configuration (_pkgdown.yml)

```yaml
url: https://mypackage.github.io/mypackage

template:
  bootstrap: 5
  bootswatch: flatly

navbar:
  structure:
    left: [intro, reference, articles, tutorials, news]
    right: [search, github]

reference:
  - title: Data manipulation
    contents:
      - filter
      - select
      - mutate
  - title: Visualization
    contents:
      - starts_with("plot_")

articles:
  - title: Getting started
    contents:
      - introduction
  - title: Advanced
    contents:
      - advanced-usage
```

## Build Components

```r
# Reference pages
build_reference()

# Articles/vignettes
build_articles()

# News
build_news()

# Home page
build_home()
```

## Reference Organization

```yaml
reference:
  - title: Main functions
    desc: Core functionality
    contents:
      - main_function
      - helper_function

  - title: internal
    contents:
      - starts_with("internal_")
```

## Custom Styling

```yaml
template:
  bootstrap: 5
  bslib:
    primary: "#0d6efd"
    border-radius: 0.5rem
    btn-border-radius: 0.25rem
```

## Deploy

```r
# GitHub Pages
usethis::use_pkgdown_github_pages()

# Manual deploy
pkgdown::deploy_to_branch()
```
