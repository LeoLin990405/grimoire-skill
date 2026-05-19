---
name: r-web-shiny
description: R Shiny web applications. Use for interactive dashboards, reactive programming, and production deployment with golem.
---

# R Shiny Applications

Interactive web applications.

## Basic Structure

```r
library(shiny)

ui <- fluidPage(
  titlePanel("App Title"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("n", "N:", 1, 100, 50),
      selectInput("var", "Variable:", choices = names(mtcars))
    ),
    mainPanel(
      plotOutput("plot"),
      tableOutput("table")
    )
  )
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
    hist(rnorm(input$n))
  })
  output$table <- renderTable({
    head(mtcars[, input$var, drop = FALSE])
  })
}

shinyApp(ui, server)
```

## Inputs

```r
# Numeric
numericInput("num", "Number:", value = 10)
sliderInput("slider", "Slider:", min = 0, max = 100, value = 50)

# Text
textInput("text", "Text:")
textAreaInput("textarea", "Text Area:")
passwordInput("password", "Password:")

# Selection
selectInput("select", "Select:", choices = c("A", "B", "C"))
selectizeInput("selectize", "Selectize:", choices = c("A", "B"), multiple = TRUE)
radioButtons("radio", "Radio:", choices = c("A", "B"))
checkboxInput("check", "Checkbox:", value = TRUE)
checkboxGroupInput("checkgroup", "Checkboxes:", choices = c("A", "B"))

# Date
dateInput("date", "Date:")
dateRangeInput("daterange", "Date Range:")

# File
fileInput("file", "Upload:")

# Action
actionButton("btn", "Click")
downloadButton("download", "Download")
```

## Outputs

```r
# UI
plotOutput("plot")
tableOutput("table")
dataTableOutput("dt")
textOutput("text")
verbatimTextOutput("code")
htmlOutput("html")
uiOutput("dynamic")

# Server
output$plot <- renderPlot({ ... })
output$table <- renderTable({ ... })
output$dt <- renderDataTable({ ... })
output$text <- renderText({ ... })
output$code <- renderPrint({ ... })
output$html <- renderUI({ ... })
```

## Reactivity

```r
server <- function(input, output, session) {
  # Reactive expression (cached)
  data <- reactive({
    df %>% filter(x > input$threshold)
  })

  # Use reactive
  output$plot <- renderPlot({
    ggplot(data(), aes(x, y)) + geom_point()
  })

  # Reactive values
  rv <- reactiveValues(count = 0)

  observeEvent(input$btn, {
    rv$count <- rv$count + 1
  })

  # eventReactive (triggered by event)
  filtered <- eventReactive(input$go, {
    df %>% filter(x > input$threshold)
  })

  # Isolate (prevent reactivity)
  output$text <- renderText({
    input$btn  # Trigger
    isolate(input$text)  # Don't trigger on text change
  })
}
```

## Modules

```r
# Module UI
counterUI <- function(id) {
  ns <- NS(id)
  tagList(
    actionButton(ns("btn"), "Click"),
    textOutput(ns("count"))
  )
}

# Module Server
counterServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    count <- reactiveVal(0)
    observeEvent(input$btn, { count(count() + 1) })
    output$count <- renderText(count())
  })
}

# Use module
ui <- fluidPage(counterUI("counter1"))
server <- function(input, output, session) {
  counterServer("counter1")
}
```

## golem (Production)

```r
# Create golem app
golem::create_golem("myapp")

# Structure
# R/app_ui.R - UI
# R/app_server.R - Server
# R/mod_*.R - Modules
# dev/run_dev.R - Development

# Deploy
golem::add_dockerfile()
rsconnect::deployApp()
```
