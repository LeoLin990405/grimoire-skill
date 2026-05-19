---
name: shinyjs
description: R shinyjs package for JavaScript operations. Use for show/hide, enable/disable, and custom JS in Shiny.
---

# shinyjs Package

JavaScript operations in Shiny without writing JS.

## Setup

```r
library(shiny)
library(shinyjs)

ui <- fluidPage(
  useShinyjs(),  # Required!
  # ... rest of UI
)
```

## Show/Hide

```r
# UI
div(id = "myDiv", "Content to show/hide")
actionButton("toggle", "Toggle")

# Server
observeEvent(input$toggle, {
  toggle("myDiv")
})

# Other options
show("myDiv")
hide("myDiv")
toggle("myDiv", anim = TRUE, animType = "fade")
```

## Enable/Disable

```r
# UI
textInput("text", "Input"),
actionButton("btn", "Submit")

# Server
observe({
  if (nchar(input$text) > 0) {
    enable("btn")
  } else {
    disable("btn")
  }
})

# Toggle
toggleState("btn", condition = nchar(input$text) > 0)
```

## CSS Classes

```r
addClass("myDiv", "highlight")
removeClass("myDiv", "highlight")
toggleClass("myDiv", "highlight")
```

## HTML Content

```r
html("myDiv", "New content")
html("myDiv", "<b>Bold</b>", add = TRUE)
```

## Reset

```r
# Reset input to default
reset("text")
reset("form")  # Reset all inputs in container
```

## Run JavaScript

```r
# Run custom JS
runjs("alert('Hello!')")
runjs("$('#myDiv').css('color', 'red')")

# Extended functions
extendShinyjs(text = "shinyjs.hello = function() { alert('Hi!'); }")
# Then call: js$hello()
```

## Delay

```r
delay(1000, show("myDiv"))  # Show after 1 second
```
