---
name: r-web-reports
description: R reproducible reports with rmarkdown, knitr, quarto. Use for dynamic documents, presentations, and books.
---

# R Reproducible Reports

Dynamic documents and reports.

## R Markdown

```yaml
---
title: "Report"
author: "Name"
date: "`r Sys.Date()`"
output:
  html_document:
    toc: true
    toc_float: true
    theme: cosmo
    code_folding: hide
---
```

```r
# Code chunk
```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE, warning = FALSE, message = FALSE)
library(tidyverse)
```

```{r analysis}
summary(mtcars)
```

```{r plot, fig.width=10, fig.height=6}
ggplot(mtcars, aes(mpg, hp)) + geom_point()
```
```

## Output Formats

```yaml
# HTML
output: html_document

# PDF (requires LaTeX)
output: pdf_document

# Word
output: word_document

# Presentation
output:
  ioslides_presentation: default
  slidy_presentation: default
  beamer_presentation: default

# Dashboard
output: flexdashboard::flex_dashboard
```

## Quarto

```yaml
---
title: "Report"
format:
  html:
    toc: true
    code-fold: true
  pdf:
    documentclass: article
execute:
  echo: true
  warning: false
---
```

```r
# Quarto code chunk
```{r}
#| label: fig-plot
#| fig-cap: "My Plot"
#| fig-width: 10
ggplot(mtcars, aes(mpg, hp)) + geom_point()
```
```

## Tables

```r
# kable
library(knitr)
kable(head(df), format = "html")

# kableExtra
library(kableExtra)
kable(df) %>%
  kable_styling(bootstrap_options = c("striped", "hover")) %>%
  column_spec(1, bold = TRUE)

# gt
library(gt)
gt(df) %>%
  tab_header(title = "Table Title") %>%
  fmt_number(columns = value, decimals = 2)

# DT (interactive)
library(DT)
datatable(df, filter = "top")
```

## Parameterized Reports

```yaml
---
title: "Report"
params:
  year: 2024
  category: "A"
output: html_document
---
```

```r
# Use parameters
df %>% filter(year == params$year, category == params$category)

# Render with parameters
rmarkdown::render("report.Rmd", params = list(year = 2024, category = "B"))
```

## bookdown

```yaml
# _bookdown.yml
book_filename: "mybook"
output_dir: "docs"
rmd_files: ["index.Rmd", "chapter1.Rmd", "chapter2.Rmd"]

# _output.yml
bookdown::gitbook:
  css: style.css
bookdown::pdf_book:
  includes:
    in_header: preamble.tex
```

## targets (Pipelines)

```r
# _targets.R
library(targets)

list(
  tar_target(data, read_csv("data.csv")),
  tar_target(model, lm(y ~ x, data = data)),
  tar_target(report, {
    rmarkdown::render("report.Rmd")
    "report.html"
  })
)

# Run
tar_make()
tar_read(model)
```
