---
name: targets
description: R targets package for pipeline workflows. Use for creating reproducible, Make-like data analysis pipelines.
---

# targets

Make-like pipeline tool for data science.

## Basic Setup

```r
# _targets.R file in project root
library(targets)

# Define targets
list(
  tar_target(data, read_csv("data.csv")),
  tar_target(model, fit_model(data)),
  tar_target(report, render_report(model))
)
```

## Running Pipelines

```r
library(targets)

# Run pipeline
tar_make()

# Run specific target
tar_make(names = model)

# Parallel execution
tar_make_future(workers = 4)

# Check status
tar_manifest()
tar_visnetwork()
```

## Target Types

```r
list(
  # Standard target
  tar_target(data, load_data()),

  # File target (tracks file changes)
  tar_target(
    raw_file,
    "data/raw.csv",
    format = "file"
  ),

  # Multiple files
  tar_target(
    files,
    list.files("data", full.names = TRUE),
    format = "file"
  ),

  # RDS format (default)
  tar_target(model, fit_model(data), format = "rds"),

 # Feather format
  tar_target(df, process_data(data), format = "feather"),

  # Parquet format
  tar_target(df, process_data(data), format = "parquet")
)
```

## Branching (Dynamic)

```r
list(
  # Create branches dynamically
  tar_target(
    files,
    list.files("data", pattern = "*.csv", full.names = TRUE)
  ),

  # Map over files
  tar_target(
    processed,
    process_file(files),
    pattern = map(files)
  ),

  # Combine results
  tar_target(
    combined,
    bind_rows(processed)
  )
)
```

## Branching (Static)

```r
# In _targets.R
values <- list(
  list(name = "model_a", params = list(alpha = 0.1)),
  list(name = "model_b", params = list(alpha = 0.5))
)

list(
  tar_map(
    values = values,
    tar_target(model, fit_model(data, params))
  )
)
```

## Dependencies

```r
list(
  tar_target(raw_data, read_csv("data.csv")),
  tar_target(clean_data, clean(raw_data)),
  tar_target(model, fit(clean_data)),
  tar_target(predictions, predict(model, clean_data)),
  tar_target(report, render("report.Rmd", predictions))
)

# targets automatically detects dependencies
# from function arguments
```

## Inspection

```r
# View pipeline
tar_visnetwork()

# Check outdated targets
tar_outdated()

# Read target value
tar_read(model)

# Load target into environment
tar_load(model)

# Get metadata
tar_meta()
```

## Error Handling

```r
list(
  tar_target(
    risky_target,
    risky_function(),
    error = "continue"  # Continue on error
  ),

  tar_target(
    safe_target,
    safe_function(),
    error = "stop"  # Stop on error (default)
  )
)
```

## Caching

```r
# Targets are cached automatically
# Re-run only rebuilds changed targets

# Force rebuild
tar_invalidate(model)

# Delete cache
tar_destroy()

# Prune unused targets
tar_prune()
```

## Configuration

```r
# _targets.R
tar_option_set(
  packages = c("dplyr", "ggplot2"),
  format = "rds",
  memory = "transient",
  garbage_collection = TRUE
)

list(
  tar_target(data, load_data()),
  tar_target(plot, make_plot(data))
)
```

## Reports

```r
list(
  tar_target(data, load_data()),
  tar_target(model, fit_model(data)),

  # Render R Markdown
  tar_render(
    report,
    "report.Rmd",
    output_file = "output/report.html"
  ),

  # Render Quarto
  tar_quarto(
    quarto_report,
    "report.qmd"
  )
)
```

## Best Practices

```r
# 1. Keep functions in R/ directory
# 2. Source functions in _targets.R
source("R/functions.R")

# 3. Use tar_option_set for common settings
tar_option_set(packages = c("tidyverse"))

# 4. Name targets descriptively
list(
  tar_target(raw_sales_data, read_sales()),
  tar_target(clean_sales_data, clean_sales(raw_sales_data)),
  tar_target(sales_model, fit_sales_model(clean_sales_data))
)
```
