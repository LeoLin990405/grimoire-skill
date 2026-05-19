---
name: shinythemes
description: R shinythemes package for Shiny themes. Use for applying Bootstrap themes to Shiny apps.
---

# shinythemes

Themes for Shiny.

## Basic Usage

```r
library(shiny)
library(shinythemes)

ui <- fluidPage(
  theme = shinytheme("cerulean"),
  # App content
)
```

## Available Themes

```r
# Bootstrap themes
shinytheme("cerulean")
shinytheme("cosmo")
shinytheme("cyborg")
shinytheme("darkly")
shinytheme("flatly")
shinytheme("journal")
shinytheme("lumen")
shinytheme("paper")
shinytheme("readable")
shinytheme("sandstone")
shinytheme("simplex")
shinytheme("slate")
shinytheme("spacelab")
shinytheme("superhero")
shinytheme("united")
shinytheme("yeti")
```

## Theme Selector

```r
ui <- fluidPage(
  shinythemes::themeSelector(),
  # App content - allows live theme switching
)
```

## Complete Example

```r
library(shiny)
library(shinythemes)

ui <- fluidPage(
  theme = shinytheme("flatly"),

  titlePanel("My App"),

  sidebarLayout(
    sidebarPanel(
      selectInput("var", "Variable:", choices = names(mtcars))
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

server <- function(input, output) {
  output$plot <- renderPlot({
    hist(mtcars[[input$var]])
  })
}

shinyApp(ui, server)
```

## With navbarPage

```r
ui <- navbarPage(
  theme = shinytheme("superhero"),
  "My App",
  tabPanel("Tab 1", "Content 1"),
  tabPanel("Tab 2", "Content 2")
)
```
