---
name: r-web-api
description: R REST APIs with plumber and httr. Use for creating and consuming web APIs.
---

# R Web APIs

Creating and consuming REST APIs.

## plumber (Create APIs)

```r
# plumber.R
library(plumber)

#* @apiTitle My API
#* @apiDescription API for data analysis

#* Echo input
#* @param msg Message to echo
#* @get /echo
function(msg = "") {
  list(message = paste0("Echo: ", msg))
}

#* Calculate mean
#* @param n Sample size
#* @get /mean
function(n = 10) {
  list(mean = mean(rnorm(as.numeric(n))))
}

#* Predict
#* @param x Input value
#* @post /predict
function(x) {
  # model loaded globally
  list(prediction = predict(model, newdata = data.frame(x = as.numeric(x))))
}

#* Upload file
#* @param file:file Uploaded file
#* @post /upload
function(file) {
  df <- read.csv(file$datapath)
  list(rows = nrow(df), cols = ncol(df))
}

# Run API
# pr <- plumb("plumber.R")
# pr$run(port = 8000)
```

## httr (Consume APIs)

```r
library(httr)

# GET request
resp <- GET("https://api.example.com/data")
status_code(resp)
content(resp, "parsed")

# With query parameters
resp <- GET("https://api.example.com/search",
  query = list(q = "term", limit = 10)
)

# POST request
resp <- POST("https://api.example.com/data",
  body = list(name = "test", value = 123),
  encode = "json"
)

# Headers
resp <- GET("https://api.example.com/data",
  add_headers(Authorization = "Bearer TOKEN")
)

# Authentication
resp <- GET("https://api.example.com/data",
  authenticate("user", "password")
)

# Upload file
resp <- POST("https://api.example.com/upload",
  body = list(file = upload_file("data.csv"))
)

# Error handling
resp <- GET("https://api.example.com/data")
if (http_error(resp)) {
  stop("API error: ", status_code(resp))
}
```

## httr2 (Modern)

```r
library(httr2)

# Build request
req <- request("https://api.example.com") %>%
  req_url_path_append("data") %>%
  req_url_query(limit = 10) %>%
  req_headers(Authorization = "Bearer TOKEN") %>%
  req_body_json(list(name = "test"))

# Perform request
resp <- req_perform(req)
resp_body_json(resp)

# Retry on failure
req %>%
  req_retry(max_tries = 3) %>%
  req_perform()

# Rate limiting
req %>%
  req_throttle(rate = 10 / 60) %>%  # 10 per minute
  req_perform()
```

## OpenCPU

```r
# Expose R functions as API
library(opencpu)
opencpu$start(port = 5656)

# Call via HTTP:
# POST /ocpu/library/stats/R/rnorm
# Body: {"n": 10}
```

## API Best Practices

```r
# plumber.R with error handling
#* @filter cors
function(req, res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  plumber::forward()
}

#* @filter logger
function(req) {
  cat(req$REQUEST_METHOD, req$PATH_INFO, "\n")
  plumber::forward()
}

#* @serializer json
#* @get /data
function() {
  tryCatch({
    list(data = get_data())
  }, error = function(e) {
    list(error = e$message)
  })
}
```
