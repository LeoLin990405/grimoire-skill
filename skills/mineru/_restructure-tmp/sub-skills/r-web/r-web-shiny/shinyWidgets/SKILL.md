---
name: shinyWidgets
description: R shinyWidgets package for custom Shiny inputs. Use for enhanced input widgets in Shiny apps.
---

# shinyWidgets

Custom inputs widgets for Shiny.

## Pickers

```r
library(shiny)
library(shinyWidgets)

# Picker input (enhanced selectInput)
pickerInput("picker", "Select:",
  choices = c("A", "B", "C"),
  multiple = TRUE,
  options = pickerOptions(
    actionsBox = TRUE,
    liveSearch = TRUE
  ))

# Virtual select (for large lists)
virtualSelectInput("vselect", "Select:",
  choices = 1:10000,
  search = TRUE)
```

## Switches and Checkboxes

```r
# Material switch
materialSwitch("switch", "Enable:", value = TRUE)

# Pretty checkbox
prettyCheckbox("check", "Option", value = TRUE,
  icon = icon("check"))

# Pretty radio buttons
prettyRadioButtons("radio", "Choose:",
  choices = c("A", "B", "C"),
  inline = TRUE)

# Switch input
switchInput("switch2", value = TRUE)
```

## Buttons

```r
# Action button with icon
actionBttn("btn", "Click",
  style = "material-flat",
  color = "primary")

# Download button
downloadBttn("download", "Download",
  style = "gradient")

# Button group
radioGroupButtons("group", "Select:",
  choices = c("A", "B", "C"))

# Checkbox group buttons
checkboxGroupButtons("checks", "Select:",
  choices = c("A", "B", "C"))
```

## Sliders

```r
# No UI slider
noUiSliderInput("slider", "Value:",
  min = 0, max = 100, value = 50)

# Knob input
knobInput("knob", "Value:",
  min = 0, max = 100, value = 50)
```

## Search and Autocomplete

```r
# Search input
searchInput("search", "Search:",
  placeholder = "Type to search...")

# Autocomplete
autocomplete_input("auto", "Search:",
  options = c("apple", "banana", "cherry"))
```

## Dropdowns

```r
# Dropdown button
dropdownButton(
  tags$h3("Options"),
  selectInput("sel", "Choose:", choices = 1:5),
  circle = TRUE,
  icon = icon("gear"),
  tooltip = tooltipOptions(title = "Settings")
)

# Dropdown menu
dropdown(
  "Content here",
  style = "bordered",
  icon = icon("bars"),
  animate = animateOptions(enter = "fadeIn")
)
```

## Progress

```r
# Progress bar
progressBar("pb", value = 50, display_pct = TRUE)

# Update progress
updateProgressBar(session, "pb", value = 75)
```

## Alerts and Notifications

```r
# Sweet alert
sendSweetAlert(session,
  title = "Success!",
  text = "Operation completed",
  type = "success")

# Confirm dialog
confirmSweetAlert(session, "confirm",
  title = "Are you sure?",
  type = "warning")

# Toast notification
show_toast(
  title = "Notification",
  text = "Message here",
  type = "success"
)
```

## Color Picker

```r
# Color picker
colorPickr("color", "Pick color:",
  selected = "#112446")

# Spectrum color picker
spectrumInput("spectrum", "Color:",
  selected = "#112446")
```
