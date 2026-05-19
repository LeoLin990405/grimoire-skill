---
name: lintr
description: R lintr package for static code analysis. Use for checking R code style and finding potential issues.
---

# lintr

Static code analysis for R.

## Basic Usage

```r
library(lintr)

# Lint a file
lint("script.R")

# Lint a directory
lint_dir("R/")

# Lint a package
lint_package()

# Lint code string
lint("x=1")
```

## Configuration

```r
# .lintr file in project root
linters: linters_with_defaults(
    line_length_linter(120),
    commented_code_linter = NULL
  )
exclusions: list(
    "R/generated.R",
    "tests/testthat/helper.R" = list(1:10)
  )
```

## Common Linters

```r
# Style linters
assignment_linter()        # Use <- not =
spaces_inside_linter()     # No spaces inside brackets
commas_linter()            # Space after commas
infix_spaces_linter()      # Spaces around operators
line_length_linter(80)     # Line length limit
trailing_whitespace_linter()
trailing_blank_lines_linter()

# Best practice linters
no_tab_linter()
T_and_F_symbol_linter()    # Use TRUE/FALSE not T/F
equals_na_linter()         # Use is.na() not == NA
seq_linter()               # Use seq_len/seq_along
undesirable_function_linter()
undesirable_operator_linter()
```

## Custom Configuration

```r
# Use specific linters
lint("script.R", linters = list(
  assignment_linter(),
  line_length_linter(100),
  trailing_whitespace_linter()
))

# Modify defaults
lint("script.R", linters = linters_with_defaults(
  line_length_linter = line_length_linter(120),
  commented_code_linter = NULL  # Disable
))
```

## Exclusions

```r
# Exclude entire file in .lintr
exclusions: list("R/legacy.R")

# Exclude specific lines
exclusions: list(
    "R/file.R" = list(1, 5:10, 25)
  )

# Inline exclusion (in code)
x = 1 # nolint
x = 1 # nolint: assignment_linter

# Block exclusion
# nolint start
x = 1
y = 2
# nolint end

# Exclude next line
# nolint next
x = 1
```

## IDE Integration

```r
# RStudio
# Tools > Global Options > Code > Diagnostics
# Enable "Show diagnostics for R"

# VS Code
# Install R extension
# Lintr runs automatically

# Emacs/ESS
# (setq ess-use-flymake-for-R t)
```

## CI/CD Integration

```r
# GitHub Actions
# .github/workflows/lint.yaml
# - uses: r-lib/actions/setup-r@v2
# - run: |
#     install.packages("lintr")
#     lintr::lint_package()

# Check in CI
if (length(lintr::lint_package()) > 0) {
  stop("Linting errors found")
}
```

## Available Linters

```r
# List all available linters
names(linters_with_defaults())

# Categories:
# Style: assignment, spacing, indentation
# Readability: line length, complexity
# Best practices: T/F, NA comparison
# Performance: vectorization, seq
# Correctness: missing arguments, namespace
```

## Custom Linters

```r
# Create custom linter
my_linter <- function() {
  Linter(function(source_expression) {
    if (!is_lint_level(source_expression, "expression")) {
      return(list())
    }

    xml <- source_expression$xml_parsed_content

    # Find issues using XPath
    bad_nodes <- xml2::xml_find_all(xml, "//SYMBOL[text()='foo']")

    lapply(bad_nodes, function(node) {
      Lint(
        filename = source_expression$filename,
        line_number = as.integer(xml2::xml_attr(node, "line1")),
        column_number = as.integer(xml2::xml_attr(node, "col1")),
        type = "warning",
        message = "Avoid using 'foo'",
        linter = "my_linter"
      )
    })
  })
}
```

## Output Formats

```r
# Default (console)
lint("script.R")

# As data frame
as.data.frame(lint("script.R"))

# JSON output
lint("script.R", format = "json")

# SARIF (for GitHub)
lint("script.R", format = "sarif")
```
