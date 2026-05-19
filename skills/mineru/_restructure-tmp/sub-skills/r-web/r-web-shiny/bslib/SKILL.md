---
name: bslib
description: R bslib package for Bootstrap theming. Use for modern Bootstrap 5 themes in Shiny and R Markdown.
---

# bslib Package

Bootstrap theming for Shiny and R Markdown.

## Shiny Theme

```r
library(shiny)
library(bslib)

ui <- page_fluid(
  theme = bs_theme(
    bootswatch = "flatly",
    primary = "#0d6efd",
    font_scale = 1.1
  ),
  # UI content
)
```

## Bootswatch Themes

```r
# Available themes
bootswatch_themes()

# Use theme
bs_theme(bootswatch = "darkly")
bs_theme(bootswatch = "minty")
bs_theme(bootswatch = "sandstone")
```

## Custom Theme

```r
theme <- bs_theme(
  bg = "#ffffff",
  fg = "#000000",
  primary = "#0d6efd",
  secondary = "#6c757d",
  success = "#198754",
  info = "#0dcaf0",
  warning = "#ffc107",
  danger = "#dc3545",
  base_font = font_google("Roboto"),
  heading_font = font_google("Montserrat"),
  code_font = font_google("Fira Code")
)
```

## Layout Components

```r
# Cards
card(
  card_header("Title"),
  card_body("Content"),
  card_footer("Footer")
)

# Sidebar layout
page_sidebar(
  sidebar = sidebar("Sidebar content"),
  "Main content"
)

# Navbar
page_navbar(
  title = "App",
  nav_panel("Tab 1", "Content 1"),
  nav_panel("Tab 2", "Content 2")
)
```

## Value Boxes

```r
value_box(
  title = "Revenue",
  value = "$10,000",
  showcase = bsicons::bs_icon("currency-dollar"),
  theme = "success"
)
```

## Theme Picker (Dev)

```r
# Interactive theme customization
run_with_themer(shinyApp(ui, server))
```
