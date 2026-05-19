---
name: golem
description: R golem package for production Shiny apps. Use for building Shiny apps as R packages.
---

# golem Package

Framework for production-grade Shiny apps.

## Create App

```r
library(golem)

# Create new app
create_golem("myapp")

# Project structure:
# myapp/
# ├── R/
# │   ├── app_config.R
# │   ├── app_server.R
# │   ├── app_ui.R
# │   └── run_app.R
# ├── inst/
# │   └── app/www/
# ├── dev/
# │   ├── 01_start.R
# │   ├── 02_dev.R
# │   └── 03_deploy.R
# └── DESCRIPTION
```

## Add Modules

```r
# Create module
add_module(name = "dashboard")
# Creates R/mod_dashboard.R

# Module template
mod_dashboard_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # UI elements
  )
}

mod_dashboard_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Server logic
  })
}
```

## Add Dependencies

```r
# Add package dependency
use_package("dplyr")
use_package("ggplot2")

# Add internal data
use_data_raw("dataset")

# Add external files
add_css_file("custom")
add_js_file("handlers")
```

## Configuration

```r
# Set options
set_golem_options(
  golem_name = "myapp",
  golem_version = "1.0.0"
)

# Get options
get_golem_options("golem_name")
```

## Run & Deploy

```r
# Run locally
run_app()

# Build for deployment
golem::add_dockerfile()
golem::add_dockerfile_shinyproxy()

# Deploy to RStudio Connect
rsconnect::deployApp()
```
