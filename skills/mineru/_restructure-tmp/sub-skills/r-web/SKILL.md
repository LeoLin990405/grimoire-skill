---
name: r-web
description: R web technologies and reproducible research. Use for Shiny apps, web scraping, REST APIs, dynamic reports (rmarkdown, knitr), and document generation.
---

# R Web & Reproducible Research Skill

## Sub-skills

| Sub-skill | Description |
|-----------|-------------|
| [r-web-shiny](r-web-shiny/SKILL.md) | Shiny apps, golem, shinyjs |
| [r-web-api](r-web-api/SKILL.md) | plumber, httr, REST APIs |
| [r-web-scraping](r-web-scraping/SKILL.md) | rvest, xml2, web scraping |
| [r-web-reports](r-web-reports/SKILL.md) | rmarkdown, knitr, quarto |

Web technologies, APIs, and reproducible research in R.

## Web Applications

| Package | Description |
|---------|-------------|
| **shiny** ★ | Interactive web applications |
| **shinyjs** | Improve Shiny UX |
| **golem** | Production-grade Shiny framework |
| **plumber** ★ | REST API from R functions |
| **OpenCPU** | HTTP API for R |

## HTTP & Web Scraping

| Package | Description |
|---------|-------------|
| **httr** ★ | User-friendly HTTP client |
| **httr2** | Next-gen httr |
| **curl** | Modern web client |
| **RCurl** | General network client |
| **rvest** ★ | Simple web scraping |
| **xml2** | XML parsing |
| **XML** | XML tools |

## Social Media APIs

| Package | Description |
|---------|-------------|
| **Rfacebook** | Facebook API |
| **rtweet** | Twitter API |
| **RSiteCatalyst** | Adobe Analytics |

## Reproducible Research

| Package | Description |
|---------|-------------|
| **knitr** ★ | Dynamic report generation |
| **rmarkdown** ★ | Dynamic documents |
| **quarto** ★ | Next-gen publishing |
| **bookdown** | Books with R Markdown |
| **blogdown** | Websites with R Markdown |
| **slidify** | HTML5 slides |
| **xaringan** | Presentations (remark.js) |

## Tables & Output

| Package | Description |
|---------|-------------|
| **kableExtra** | Fancy HTML/LaTeX tables |
| **gt** | Grammar of tables |
| **flextable** | Tables for Word/PowerPoint/HTML |
| **xtable** | Export to LaTeX/HTML |
| **texreg** | Format models for LaTeX/HTML |
| **formattable** | Formattable data structures |

## Office Documents

| Package | Description |
|---------|-------------|
| **officer** | Word/PowerPoint/HTML reports |
| **openxlsx** | Excel files |
| **writexl** | Write Excel |

## Workflow & Reproducibility

| Package | Description |
|---------|-------------|
| **targets** ★ | Make-like pipeline tool |
| **checkpoint** | Package snapshots |
| **renv** | Project environments |
| **tinytex** | Lightweight LaTeX |
| **brew** | Report templating |

## Quick Examples

```r
# Shiny app
library(shiny)
ui <- fluidPage(
  titlePanel("App"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("n", "N:", 1, 100, 50)
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

# REST API with plumber
# plumber.R
#* @get /mean
function(n = 10) {
  mean(rnorm(as.numeric(n)))
}
# Run: plumber::plumb("plumber.R")$run(port = 8000)

# Web scraping
library(rvest)
page <- read_html("https://example.com")
page %>%
  html_elements("table") %>%
  html_table()

# HTTP requests
library(httr)
resp <- GET("https://api.example.com/data",
            query = list(key = "value"))
content(resp, "parsed")

# R Markdown document
---
title: "Report"
output: html_document
---
```{r}
summary(mtcars)
```

# knitr tables
library(knitr)
kable(head(df), format = "html")

# targets pipeline
library(targets)
# _targets.R
list(
  tar_target(data, read_csv("data.csv")),
  tar_target(model, lm(y ~ x, data = data)),
  tar_target(report, rmarkdown::render("report.Rmd"))
)
```

## Resources

- Shiny: https://shiny.rstudio.com/
- plumber: https://www.rplumber.io/
- R Markdown: https://rmarkdown.rstudio.com/
- Quarto: https://quarto.org/
- targets: https://docs.ropensci.org/targets/
