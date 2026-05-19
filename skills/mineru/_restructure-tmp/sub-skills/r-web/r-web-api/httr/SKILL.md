---
name: httr
description: R httr package for HTTP requests. Use for making GET, POST, and other HTTP requests to web APIs.
---

# httr

Tools for working with HTTP.

## GET Requests

```r
library(httr)

# Simple GET
response <- GET("https://api.example.com/data")

# With query parameters
response <- GET("https://api.example.com/search",
  query = list(q = "R programming", limit = 10)
)

# With headers
response <- GET("https://api.example.com/data",
  add_headers(Authorization = "Bearer token123")
)
```

## POST Requests

```r
# POST with JSON body
response <- POST("https://api.example.com/data",
  body = list(name = "John", age = 30),
  encode = "json"
)

# POST with form data
response <- POST("https://api.example.com/form",
  body = list(field1 = "value1", field2 = "value2"),
  encode = "form"
)

# POST with file upload
response <- POST("https://api.example.com/upload",
  body = list(file = upload_file("data.csv"))
)
```

## Other Methods

```r
# PUT
response <- PUT("https://api.example.com/data/1",
  body = list(name = "Updated"),
  encode = "json"
)

# PATCH
response <- PATCH("https://api.example.com/data/1",
  body = list(status = "active"),
  encode = "json"
)

# DELETE
response <- DELETE("https://api.example.com/data/1")

# HEAD
response <- HEAD("https://api.example.com/data")
```

## Response Handling

```r
# Status code
status_code(response)

# Check for success
http_error(response)
stop_for_status(response)
warn_for_status(response)

# Content
content(response)                    # Auto-parse
content(response, "text")            # As text
content(response, "raw")             # As raw bytes
content(response, "parsed")          # Parsed based on content type

# Headers
headers(response)
headers(response)$`content-type`
```

## Authentication

```r
# Basic auth
response <- GET("https://api.example.com/data",
  authenticate("username", "password")
)

# OAuth 1.0
myapp <- oauth_app("myapp", key = "key", secret = "secret")
token <- oauth1.0_token(oauth_endpoint(...), myapp)
response <- GET("https://api.example.com/data", config(token = token))

# OAuth 2.0
token <- oauth2.0_token(oauth_endpoint(...), myapp)
response <- GET("https://api.example.com/data", config(token = token))

# API key in header
response <- GET("https://api.example.com/data",
  add_headers(`X-API-Key` = "your-api-key")
)
```

## Configuration

```r
# Timeout
response <- GET("https://api.example.com/data",
  timeout(10)
)

# Verbose output
response <- GET("https://api.example.com/data",
  verbose()
)

# Custom user agent
response <- GET("https://api.example.com/data",
  user_agent("MyApp/1.0")
)

# Proxy
response <- GET("https://api.example.com/data",
  use_proxy("proxy.example.com", 8080)
)
```

## Cookies

```r
# Set cookies
response <- GET("https://api.example.com/data",
  set_cookies(session = "abc123")
)

# Get cookies from response
cookies(response)
```

## Retry

```r
# Retry on failure
response <- RETRY("GET", "https://api.example.com/data",
  times = 3,
  pause_base = 1,
  pause_cap = 60
)
```

## JSON API Example

```r
# Complete API workflow
base_url <- "https://api.example.com"

# GET list
response <- GET(paste0(base_url, "/items"),
  add_headers(Authorization = paste("Bearer", token)),
  query = list(page = 1, limit = 10)
)
stop_for_status(response)
items <- content(response)

# POST new item
response <- POST(paste0(base_url, "/items"),
  add_headers(Authorization = paste("Bearer", token)),
  body = list(name = "New Item", value = 100),
  encode = "json"
)
stop_for_status(response)
new_item <- content(response)
```
