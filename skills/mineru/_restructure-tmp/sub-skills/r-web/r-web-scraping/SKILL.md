---
name: r-web-scraping
description: R web scraping with rvest and xml2. Use for extracting data from websites.
---

# R Web Scraping

Extract data from websites.

## rvest

```r
library(rvest)

# Read page
page <- read_html("https://example.com")

# CSS selectors
page %>% html_elements("h1")
page %>% html_elements(".class")
page %>% html_elements("#id")
page %>% html_elements("div.class")
page %>% html_elements("table tr td")

# Extract text
page %>% html_elements("h1") %>% html_text()
page %>% html_elements("p") %>% html_text2()  # Better whitespace

# Extract attributes
page %>% html_elements("a") %>% html_attr("href")
page %>% html_elements("img") %>% html_attr("src")

# Extract tables
tables <- page %>% html_elements("table") %>% html_table()
df <- tables[[1]]

# Forms
form <- page %>% html_form()[[1]]
form <- html_form_set(form, username = "user", password = "pass")
session <- session("https://example.com/login")
session <- session_submit(session, form)
```

## XPath

```r
# XPath selectors
page %>% html_elements(xpath = "//h1")
page %>% html_elements(xpath = "//div[@class='content']")
page %>% html_elements(xpath = "//a[contains(@href, 'page')]")
page %>% html_elements(xpath = "//table//tr[position()>1]")
```

## Session Management

```r
library(rvest)

# Create session
session <- session("https://example.com")

# Navigate
session <- session_follow_link(session, "Next")
session <- session_jump_to(session, "https://example.com/page2")
session <- session_back(session)

# Get current page
page <- read_html(session)
```

## Handling JavaScript

```r
# For JS-rendered pages, use chromote or RSelenium
library(chromote)

b <- ChromoteSession$new()
b$Page$navigate("https://example.com")
Sys.sleep(2)  # Wait for JS
html <- b$Runtime$evaluate("document.documentElement.outerHTML")$result$value
page <- read_html(html)
b$close()
```

## Polite Scraping

```r
library(polite)

# Respect robots.txt
session <- bow("https://example.com")
print(session)  # Shows allowed paths

# Scrape politely
result <- scrape(session)

# Navigate
session <- nod(session, path = "/page")
result <- scrape(session)
```

## Best Practices

```r
# Rate limiting
library(httr)

scrape_page <- function(url) {
  Sys.sleep(1)  # Be polite
  read_html(url)
}

# User agent
page <- read_html(url) # rvest sets reasonable UA

# Error handling
safe_scrape <- function(url) {
  tryCatch({
    read_html(url)
  }, error = function(e) {
    message("Failed: ", url)
    NULL
  })
}

# Multiple pages
urls <- paste0("https://example.com/page/", 1:10)
pages <- lapply(urls, function(url) {
  Sys.sleep(1)
  safe_scrape(url)
})
```
