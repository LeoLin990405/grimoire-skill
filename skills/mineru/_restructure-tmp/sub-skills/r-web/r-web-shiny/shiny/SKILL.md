---
name: shiny
description: R shiny package for web applications. Use for building interactive web apps with reactive programming.
---

# shiny

Interactive web applications.

## Basic App

```r
library(shiny)

ui <- fluidPage(
  titlePanel("My App"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("n", "N:", min = 1, max = 100, value = 50)
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

server <- function(input, output) {
  output$plot <- renderPlot({
    hist(rnorm(input$n))
  })
}

shinyApp(ui, server)
```

## UI Inputs

```r
# Numeric
numericInput("num", "Number:", value = 10, min = 1, max = 100)
sliderInput("slider", "Slider:", min = 0, max = 100, value = 50)

# Text
textInput("text", "Text:", value = "")
textAreaInput("textarea", "Text Area:", value = "")
passwordInput("password", "Password:")

# Selection
selectInput("select", "Select:", choices = c("A", "B", "C"))
selectInput("select", "Select:", choices = c("A", "B"), multiple = TRUE)
radioButtons("radio", "Radio:", choices = c("A", "B", "C"))
checkboxInput("check", "Check:", value = FALSE)
checkboxGroupInput("checks", "Checks:", choices = c("A", "B", "C"))

# Date
dateInput("date", "Date:")
dateRangeInput("dates", "Date Range:")

# File
fileInput("file", "Upload:")

# Action
actionButton("btn", "Click")
downloadButton("download", "Download")
```

## UI Outputs

```r
# Plot
plotOutput("plot")
plotOutput("plot", click = "plot_click", brush = "plot_brush")

# Table
tableOutput("table")
dataTableOutput("datatable")

# Text
textOutput("text")
verbatimTextOutput("code")
htmlOutput("html")

# UI
uiOutput("dynamic_ui")
```

## Server Render

```r
server <- function(input, output) {
  # Plot
  output$plot <- renderPlot({ ggplot(...) })
  
  # Table
  output$table <- renderTable({ df })
  output$datatable <- renderDataTable({ df })
  
  # Text
  output$text <- renderText({ paste("Value:", input$n) })
  output$code <- renderPrint({ summary(df) })
  
  # UI
  output$dynamic_ui <- renderUI({
    selectInput("dynamic", "Dynamic:", choices = get_choices())
  })
}
```

## Reactivity

```r
server <- function(input, output) {
  # Reactive expression
  data <- reactive({
    df %>% filter(x > input$threshold)
  })
  
  # Use reactive
  output$plot <- renderPlot({
    ggplot(data(), aes(x, y)) + geom_point()
  })
  
  # Reactive values
  rv <- reactiveValues(count = 0, data = NULL)
  
  # Observer
  observe({
    rv$count <- rv$count + 1
  })
  
  # Observe event
  observeEvent(input$btn, {
    rv$data <- load_data()
  })
  
  # Event reactive
  data <- eventReactive(input$btn, {
    expensive_computation()
  })
  
  # Isolate
  output$text <- renderText({
    isolate(input$n)  # Don't react to n
  })
  
  # Debounce/throttle
  data_d <- data %>% debounce(500)
  data_t <- data %>% throttle(1000)
}
```

## Layout

```r
# Fluid page
fluidPage(
  fluidRow(
    column(4, ...),
    column(8, ...)
  )
)

# Sidebar layout
sidebarLayout(
  sidebarPanel(...),
  mainPanel(...)
)

# Tabs
tabsetPanel(
  tabPanel("Tab 1", ...),
  tabPanel("Tab 2", ...)
)

# Navbar
navbarPage("App",
  tabPanel("Page 1", ...),
  tabPanel("Page 2", ...),
  navbarMenu("More",
    tabPanel("Page 3", ...),
    tabPanel("Page 4", ...)
  )
)

# Modal
showModal(modalDialog(
  title = "Title",
  "Content",
  footer = modalButton("Close")
))
```

## Notifications

```r
# Notification
showNotification("Message", type = "message")
showNotification("Warning", type = "warning")
showNotification("Error", type = "error")

# Progress
withProgress(message = "Loading", {
  for (i in 1:10) {
    incProgress(1/10)
    Sys.sleep(0.1)
  }
})
```
