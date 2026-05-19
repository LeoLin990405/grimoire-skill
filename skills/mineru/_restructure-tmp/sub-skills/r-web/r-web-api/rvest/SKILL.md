---
name: rvest
description: R rvest package for web scraping. Use for scraping data from web pages.
---

# rvest

Easily harvest web pages.

## Basic Scraping

```r
library(rvest)

# Read HTML
page <- read_html("https://example.com")

# From file
page <- read_html("page.html")
```

## Selecting Elements

```r
# CSS selectors
page %>% html_elements("p")
page %>% html_elements(".class")
page %>% html_elements("#id")
page %>% html_elements("div.class")
page %>% html_elements("table tr")

# XPath
page %>% html_elements(xpath = "//div[@class='content']")
```

## Extracting Data

```r
# Text content
page %>%
  html_elements("p") %>%
  html_text()

# Clean text (removes whitespace)
page %>%
  html_elements("p") %>%
  html_text2()

# Attributes
page %>%
  html_elements("a") %>%
  html_attr("href")

# All attributes
page %>%
  html_elements("a") %>%
  html_attrs()
```

## Tables

```r
# Extract tables
tables <- page %>%
  html_elements("table") %>%
  html_table()

# First table
df <- tables[[1]]

# With options
page %>%
  html_element("table") %>%
  html_table(header = TRUE, fill = TRUE)
```

## Forms

```r
# Find form
form <- page %>%
  html_form()[[1]]

# Fill form
form <- form %>%
  html_form_set(
    username = "user",
    password = "pass"
  )

# Submit form
session <- session("https://example.com")
session <- session_submit(session, form)
```

## Sessions

```r
# Start session
session <- session("https://example.com")

# Navigate
session <- session_follow_link(session, "Next")
session <- session_jump_to(session, "https://example.com/page2")

# Go back
session <- session_back(session)

# Get current page
session %>% read_html()
```

## Handling JavaScript

```r
# rvest doesn't execute JavaScript
# For JS-rendered pages, use RSelenium or chromote

# Or find the API endpoint
# Check Network tab in browser DevTools
```

## Example: Scrape Table

```r
library(rvest)
library(dplyr)

url <- "https://en.wikipedia.org/wiki/List_of_countries_by_population"

page <- read_html(url)

df <- page %>%
  html_element("table.wikitable") %>%
  html_table() %>%
  clean_names()
```
