---
name: polite
description: R polite package for ethical web scraping. Use for respecting robots.txt and rate limiting.
---

# polite Package

Ethical web scraping with robots.txt compliance.

## Basic Usage

```r
library(polite)
library(rvest)

# Bow (introduce yourself)
session <- bow("https://example.com",
  user_agent = "MyBot (contact@example.com)"
)

# Check permissions
session

# Scrape (politely)
page <- scrape(session)
```

## Rate Limiting

```r
# Automatic delay between requests
session <- bow("https://example.com",
  delay = 5  # 5 seconds between requests
)

# Scrape multiple pages
urls <- c("/page1", "/page2", "/page3")

results <- lapply(urls, function(path) {
  session %>%
    nod(path) %>%
    scrape()
})
```

## Navigate

```r
# Initial bow
session <- bow("https://example.com")

# Navigate to subpages
page1 <- session %>% nod("/products") %>% scrape()
page2 <- session %>% nod("/about") %>% scrape()
```

## Check robots.txt

```r
# See what's allowed
session <- bow("https://example.com")
session$robotstxt

# Check specific path
session$robotstxt$check("/api/")
```

## With rvest

```r
library(polite)
library(rvest)

session <- bow("https://example.com")

# Scrape and extract
data <- session %>%
  scrape() %>%
  html_elements(".item") %>%
  html_text()

# Multiple pages
pages <- paste0("/page/", 1:10)

all_data <- lapply(pages, function(p) {
  Sys.sleep(1)  # Extra politeness
  session %>%
    nod(p) %>%
    scrape() %>%
    html_table()
})
```
