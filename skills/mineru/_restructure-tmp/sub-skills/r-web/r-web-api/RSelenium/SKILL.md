---
name: RSelenium
description: R RSelenium package for browser automation. Use for web scraping JavaScript-rendered pages and browser automation.
---

# RSelenium

R bindings for Selenium WebDriver.

## Setup

```r
library(RSelenium)

# Start Selenium server (requires Java)
rD <- rsDriver(browser = "chrome")
remDr <- rD$client

# Or connect to existing server
remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4444L,
  browserName = "chrome"
)
remDr$open()
```

## Navigation

```r
# Navigate to URL
remDr$navigate("https://example.com")

# Get current URL
remDr$getCurrentUrl()

# Go back/forward
remDr$goBack()
remDr$goForward()

# Refresh
remDr$refresh()
```

## Finding Elements

```r
# By CSS selector
elem <- remDr$findElement(using = "css selector", value = "#id")
elem <- remDr$findElement(using = "css selector", value = ".class")

# By XPath
elem <- remDr$findElement(using = "xpath", value = "//div[@id='content']")

# By ID
elem <- remDr$findElement(using = "id", value = "myid")

# By name
elem <- remDr$findElement(using = "name", value = "username")

# Multiple elements
elems <- remDr$findElements(using = "css selector", value = "p")
```

## Interacting with Elements

```r
# Click
elem$clickElement()

# Send keys
elem$sendKeysToElement(list("text to type"))

# Clear input
elem$clearElement()

# Get text
elem$getElementText()

# Get attribute
elem$getElementAttribute("href")

# Submit form
elem$submitElement()
```

## Waiting

```r
# Implicit wait
remDr$setTimeout(type = "implicit", milliseconds = 10000)

# Explicit wait
Sys.sleep(2)

# Wait for element
library(RSelenium)
webElem <- NULL
while(is.null(webElem)) {
  webElem <- tryCatch(
    remDr$findElement(using = "id", value = "element"),
    error = function(e) NULL
  )
  Sys.sleep(0.5)
}
```

## JavaScript

```r
# Execute JavaScript
remDr$executeScript("return document.title;")

# Scroll
remDr$executeScript("window.scrollTo(0, document.body.scrollHeight);")

# Click via JS
remDr$executeScript("arguments[0].click();", list(elem))
```

## Screenshots

```r
# Take screenshot
remDr$screenshot(file = "screenshot.png")

# Get as base64
b64 <- remDr$screenshot()
```

## Cleanup

```r
# Close browser
remDr$close()

# Stop server
rD$server$stop()
```

## Docker Setup

```bash
# Run Selenium in Docker
docker run -d -p 4444:4444 selenium/standalone-chrome
```

```r
# Connect to Docker Selenium
remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4444L,
  browserName = "chrome"
)
```
