---
name: plumber
description: R plumber package for REST APIs. Use for creating web APIs from R functions.
---

# plumber

REST APIs from R functions.

## Basic API

```r
# plumber.R
library(plumber)

#* @get /hello
function() {
  list(message = "Hello, World!")
}

#* @get /echo
#* @param msg The message to echo
function(msg = "") {
  list(message = msg)
}

#* @post /sum
#* @param a First number
#* @param b Second number
function(a, b) {
  list(result = as.numeric(a) + as.numeric(b))
}
```

## Run API

```r
library(plumber)

# Run
pr("plumber.R") %>%
  pr_run(port = 8000)

# With host
pr("plumber.R") %>%
  pr_run(host = "0.0.0.0", port = 8000)
```

## HTTP Methods

```r
#* @get /resource
function() { }

#* @post /resource
function() { }

#* @put /resource/{id}
function(id) { }

#* @delete /resource/{id}
function(id) { }

#* @patch /resource/{id}
function(id) { }
```

## Parameters

```r
# Query parameters
#* @get /search
#* @param q Search query
#* @param limit Max results
function(q, limit = 10) {
  # ?q=term&limit=20
}

# Path parameters
#* @get /users/<id>
function(id) {
  # /users/123
}

# Request body (POST/PUT)
#* @post /users
function(req) {
  body <- req$body
  # JSON body parsed automatically
}
```

## Response Types

```r
# JSON (default)
#* @get /json
function() {
  list(data = 1:5)
}

# HTML
#* @get /html
#* @html
function() {
  "<html><body><h1>Hello</h1></body></html>"
}

# Plot
#* @get /plot
#* @serializer png
function() {
  plot(1:10)
}

#* @get /plot
#* @serializer jpeg list(quality = 90)
function() {
  plot(1:10)
}

# CSV
#* @get /data
#* @serializer csv
function() {
  mtcars
}

# Custom content type
#* @get /custom
function(res) {
  res$setHeader("Content-Type", "text/plain")
  "Plain text response"
}
```

## Filters

```r
#* @filter logger
function(req) {
  cat(req$REQUEST_METHOD, req$PATH_INFO, "\n")
  plumber::forward()
}

#* @filter auth
function(req, res) {
  if (is.null(req$HTTP_AUTHORIZATION)) {
    res$status <- 401
    return(list(error = "Unauthorized"))
  }
  plumber::forward()
}
```

## Error Handling

```r
#* @get /error
function(res) {
  tryCatch({
    stop("Something went wrong")
  }, error = function(e) {
    res$status <- 500
    list(error = e$message)
  })
}

# Global error handler
pr("plumber.R") %>%
  pr_set_error(function(req, res, err) {
    res$status <- 500
    list(error = "Internal server error")
  })
```

## CORS

```r
# Enable CORS
pr("plumber.R") %>%
  pr_set_api_spec(function(spec) {
    spec$components$securitySchemes <- list(...)
    spec
  }) %>%
  pr_run()

# Or with filter
#* @filter cors
function(req, res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  if (req$REQUEST_METHOD == "OPTIONS") {
    res$setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE")
    res$setHeader("Access-Control-Allow-Headers", "Content-Type")
    res$status <- 200
    return(list())
  }
  plumber::forward()
}
```

## OpenAPI/Swagger

```r
# Auto-generated at /__docs__/

#* @apiTitle My API
#* @apiDescription API description
#* @apiVersion 1.0.0

#* Get user by ID
#* @get /users/<id>
#* @param id:int User ID
#* @response 200 User object
#* @response 404 User not found
function(id) { }
```
