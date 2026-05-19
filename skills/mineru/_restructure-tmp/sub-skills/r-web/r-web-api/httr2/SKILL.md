---
name: httr2
description: R httr2 package for HTTP requests. Use for making API calls with modern, pipeable interface.
---

# httr2

Modern HTTP client.

## Basic Requests

```r
library(httr2)

# GET request
resp <- request("https://api.example.com/data") %>%
  req_perform()

# POST request
resp <- request("https://api.example.com/data") %>%
  req_method("POST") %>%
  req_body_json(list(key = "value")) %>%
  req_perform()

# Response body
resp %>% resp_body_json()
resp %>% resp_body_string()
```

## Request Building

```r
req <- request("https://api.example.com") %>%
  # URL path
  req_url_path_append("v1", "users") %>%
  req_url_path("/v1/users") %>%
  
  # Query parameters
  req_url_query(page = 1, limit = 10) %>%
  
  # Headers
  req_headers(
    Accept = "application/json",
    `X-Custom` = "value"
  ) %>%
  
  # Authentication
  req_auth_basic("user", "password") %>%
  req_auth_bearer_token("token") %>%
  
  # Body
  req_body_json(list(name = "value")) %>%
  req_body_form(field1 = "value1", field2 = "value2") %>%
  req_body_multipart(file = curl::form_file("path/to/file")) %>%
  
  # Timeout
  req_timeout(30) %>%
  
  # Retry
  req_retry(max_tries = 3, backoff = ~ 2)
```

## Response Handling

```r
resp <- req_perform(req)

# Status
resp_status(resp)
resp_status_desc(resp)
resp_is_error(resp)

# Headers
resp_headers(resp)
resp_header(resp, "Content-Type")
resp_content_type(resp)

# Body
resp_body_json(resp)
resp_body_string(resp)
resp_body_raw(resp)
resp_body_html(resp)
resp_body_xml(resp)
```

## Error Handling

```r
# Check for errors
resp <- req %>%
  req_error(is_error = function(resp) FALSE) %>%
  req_perform()

# Custom error handling
resp <- req %>%
  req_error(body = function(resp) {
    resp_body_json(resp)$error$message
  }) %>%
  req_perform()

# Try perform
resp <- req %>% req_perform()
if (resp_is_error(resp)) {
  # Handle error
}
```

## OAuth

```r
# OAuth 2.0 client credentials
token <- oauth_client(
  id = "client_id",
  secret = "client_secret",
  token_url = "https://api.example.com/oauth/token"
) %>%
  oauth_flow_client_credentials()

req <- request("https://api.example.com/data") %>%
  req_oauth_auth_code(
    client = oauth_client(...),
    auth_url = "https://api.example.com/oauth/authorize"
  )
```

## Pagination

```r
# Iterate pages
resps <- request("https://api.example.com/data") %>%
  req_perform_iterative(
    next_req = function(resp, req) {
      next_url <- resp_body_json(resp)$next
      if (is.null(next_url)) return(NULL)
      request(next_url)
    },
    max_reqs = 10
  )

# Combine results
all_data <- resps %>%
  resps_data(function(resp) resp_body_json(resp)$data)
```

## Parallel Requests

```r
# Multiple requests
reqs <- list(
  request("https://api.example.com/1"),
  request("https://api.example.com/2"),
  request("https://api.example.com/3")
)

resps <- req_perform_parallel(reqs)
```

## Caching

```r
# Cache responses
resp <- request("https://api.example.com/data") %>%
  req_cache(tempdir()) %>%
  req_perform()
```
