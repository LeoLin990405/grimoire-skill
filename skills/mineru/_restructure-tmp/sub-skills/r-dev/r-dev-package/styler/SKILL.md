---
name: styler
description: R styler package for code formatting. Use for automatically formatting R code to follow style guidelines.
---

# styler

Non-invasive pretty printing of R code.

## Basic Usage

```r
library(styler)

# Style a file
style_file("script.R")

# Style a directory
style_dir("R/")

# Style a package
style_pkg()

# Style text
style_text("x=1+2")
```

## Styling Options

```r
# Default tidyverse style
style_file("script.R")

# Custom indentation
style_file("script.R", indent_by = 4)

# Strict mode (more changes)
style_file("script.R", strict = TRUE)

# Dry run (show changes without applying)
style_file("script.R", dry = "on")
```

## Style Guides

```r
# Tidyverse style (default)
style_file("script.R", style = tidyverse_style())

# Custom style
my_style <- tidyverse_style(
  indent_by = 4,
  strict = FALSE
)
style_file("script.R", style = my_style)
```

## What Styler Changes

```r
# Before
x=1+2
if(x>0){print(x)}
function(a,b,c){a+b+c}

# After
x <- 1 + 2
if (x > 0) {
  print(x)
}
function(a, b, c) {
  a + b + c
}
```

## Scope Control

```r
# Style specific scope
style_file("script.R", scope = "tokens")  # Only tokens
style_file("script.R", scope = "spaces")  # Only spacing
style_file("script.R", scope = "indention")  # Only indentation
style_file("script.R", scope = "line_breaks")  # Only line breaks

# Multiple scopes
style_file("script.R", scope = c("spaces", "tokens"))
```

## Exclusions

```r
# Exclude code blocks
# styler: off
x=1+2
y=3+4
# styler: on

# Exclude single line
x=1+2 # styler: off
```

## IDE Integration

```r
# RStudio
# Addins > Style selection
# Addins > Style active file

# Keyboard shortcut
# Tools > Modify Keyboard Shortcuts
# Search "style"

# VS Code
# Install R extension
# Format document: Shift+Alt+F
```

## CI/CD Integration

```r
# GitHub Actions
# Check if code is styled
style_file("R/", dry = "fail")

# Pre-commit hook
# .pre-commit-config.yaml
# - repo: https://github.com/lorenzwalthert/precommit
#   hooks:
#     - id: style-files
```

## Custom Transformers

```r
# Create custom style
my_style <- function() {
  create_style_guide(
    # Transformers
    space = list(
      spacing_around_op = function(pd) {
        # Custom spacing logic
      }
    ),
    # Other options
    indent_by = 2,
    strict = TRUE
  )
}

style_file("script.R", style = my_style)
```

## Caching

```r
# Enable caching (faster repeated styling)
cache_activate()

# Clear cache
cache_clear()

# Check cache info
cache_info()
```

## Comparison with formatR

```r
# styler advantages:
# - Non-invasive (preserves more original formatting)
# - Better handling of edge cases
# - More configurable
# - Active development

# formatR advantages:
# - Simpler
# - Faster for basic formatting
```

## Best Practices

```r
# 1. Run styler before committing
style_pkg()

# 2. Use pre-commit hooks
# 3. Configure in .Rprofile for consistency
options(
  styler.addins_style_transformer = "styler::tidyverse_style()"
)

# 4. Exclude generated code
# styler: off
# Generated code here
# styler: on

# 5. Use with lintr for complete code quality
lintr::lint_package()
styler::style_pkg()
```

## Batch Processing

```r
# Style multiple files
files <- list.files("R/", pattern = "\\.R$", full.names = TRUE)
lapply(files, style_file)

# Style with progress
style_dir("R/", filetype = "R")
```
