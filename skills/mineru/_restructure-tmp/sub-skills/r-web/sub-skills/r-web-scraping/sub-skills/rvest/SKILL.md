---
name: rvest
description: R rvest package for web scraping. Use for extracting data from HTML pages.
---

# rvest Package

Web scraping with tidyverse style.

## Read HTML

```r
library(rvest)

# From URL
page <- read_html("https://example.com")

# From file
page <- read_html("page.html")

# From string
page <- read_html("<html><body><p>Hello</p></body></html>")
```

## Select Elements

```r
# CSS selectors
page %>% html_elements("p")
page %>% html_elements(".class")
page %>% html_elements("#id")
page %>% html_elements("div.content p")

# XPath
page %>% html_elements(xpath = "//p")
page %>% html_elements(xpath = "//div[@class='content']//a")

# First match only
page %>% html_element("h1")
```

## Extract Data

```r
# Text
page %>% html_elements("p") %>% html_text()
page %>% html_elements("p") %>% html_text2()  # Cleaner

# Attributes
page %>% html_elements("a") %>% html_attr("href")
page %>% html_elements("img") %>% html_attr("src")

# All attributes
page %>% html_elements("a") %>% html_attrs()
```

## Tables

```r
# Extract table
tables <- page %>% html_table()
df <- tables[[1]]

# With options
page %>% html_table(fill = TRUE, header = TRUE)
```

## Forms

```r
# Get form
form <- page %>% html_form()[[1]]

# Fill form
form <- form %>%
  html_form_set(username = "user", password = "pass")

# Submit
session <- session("https://example.com/login")
session <- session_submit(session, form)
```

## Sessions

```r
# Start session
session <- session("https://example.com")

# Navigate
session <- session %>% session_follow_link("Next")
session <- session %>% session_jump_to("/page2")

# Get current page
session %>% read_html()
```
