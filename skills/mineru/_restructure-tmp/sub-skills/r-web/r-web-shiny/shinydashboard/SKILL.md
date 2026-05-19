---
name: shinydashboard
description: R shinydashboard package for dashboard layouts. Use for admin-style dashboards with sidebar and boxes.
---

# shinydashboard Package

Dashboard layouts for Shiny.

## Basic Structure

```r
library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "My Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Reports", tabName = "reports", icon = icon("file"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",
        # Content
      ),
      tabItem(tabName = "reports",
        # Content
      )
    )
  )
)
```

## Boxes

```r
dashboardBody(
  fluidRow(
    box(title = "Box 1", status = "primary", solidHeader = TRUE,
      "Content here"
    ),
    box(title = "Box 2", status = "warning", collapsible = TRUE,
      plotOutput("plot")
    )
  )
)

# Status: primary, success, info, warning, danger
```

## Value Boxes

```r
fluidRow(
  valueBox(100, "New Orders", icon = icon("shopping-cart"), color = "green"),
  valueBox(50, "Users", icon = icon("users"), color = "blue"),
  valueBoxOutput("dynamicBox")
)

# Server
output$dynamicBox <- renderValueBox({
  valueBox(nrow(data), "Records", icon = icon("database"))
})
```

## Info Boxes

```r
fluidRow(
  infoBox("Revenue", "$10,000", icon = icon("dollar"), color = "green"),
  infoBoxOutput("dynamicInfo")
)
```

## Sidebar

```r
dashboardSidebar(
  sidebarMenu(
    menuItem("Home", tabName = "home", icon = icon("home")),
    menuItem("Analysis", icon = icon("chart-bar"),
      menuSubItem("Charts", tabName = "charts"),
      menuSubItem("Tables", tabName = "tables")
    )
  ),
  # Inputs in sidebar
  selectInput("dataset", "Dataset", choices = c("mtcars", "iris"))
)
```

## Notifications

```r
dropdownMenu(type = "notifications",
  notificationItem(text = "5 new users", icon = icon("users")),
  notificationItem(text = "Server load 80%", icon = icon("server"), status = "warning")
)
```
