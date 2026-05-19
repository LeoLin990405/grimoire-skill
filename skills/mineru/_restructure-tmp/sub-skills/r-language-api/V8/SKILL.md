---
name: V8
description: R V8 package for JavaScript integration. Use for running JavaScript code and using JS libraries from R.
---

# V8

Embedded JavaScript engine for R.

## Basic Usage

```r
library(V8)

# Create JavaScript context
ctx <- v8()

# Evaluate JavaScript
ctx$eval("var x = 1 + 1")
ctx$get("x")  # Returns 2

# Run multiple statements
ctx$eval("
  var a = 10;
  var b = 20;
  var sum = a + b;
")
ctx$get("sum")
```

## Functions

```r
# Define JavaScript function
ctx$eval("
  function add(a, b) {
    return a + b;
  }
")

# Call from R
ctx$call("add", 5, 3)

# With arrays
ctx$eval("
  function sum(arr) {
    return arr.reduce((a, b) => a + b, 0);
  }
")
ctx$call("sum", c(1, 2, 3, 4, 5))
```

## Data Exchange

```r
# R to JavaScript
ctx$assign("mydata", mtcars)
ctx$eval("console.log(mydata.length)")

# JavaScript to R
ctx$eval("var result = {a: 1, b: 2, c: [1,2,3]}")
ctx$get("result")

# JSON conversion
ctx$eval("var json = JSON.stringify({x: 1, y: 2})")
ctx$get("json")
```

## Console Output

```r
# Capture console.log
ctx$eval("console.log('Hello from JS')")

# Custom console
ctx$console(function(msg) {
  message("JS: ", msg)
})
```

## Load JavaScript Libraries

```r
# Load from file
ctx$source("library.js")

# Load from URL
ctx$source("https://cdn.example.com/library.js")

# Load bundled libraries
ctx$source(system.file("js/underscore.js", package = "V8"))
```

## NPM Packages

```r
# Use browserified npm packages
# First, bundle with browserify:
# browserify -r lodash -o lodash-bundle.js

ctx$source("lodash-bundle.js")
ctx$eval("var _ = require('lodash')")
ctx$call("_.chunk", c(1,2,3,4,5,6), 2)
```

## Error Handling

```r
# JavaScript errors become R errors
tryCatch({
  ctx$eval("throw new Error('Something went wrong')")
}, error = function(e) {
  message("JS Error: ", e$message)
})

# Syntax errors
tryCatch({
  ctx$eval("var x = ")
}, error = function(e) {
  message("Syntax error")
})
```

## Multiple Contexts

```r
# Isolated contexts
ctx1 <- v8()
ctx2 <- v8()

ctx1$eval("var x = 1")
ctx2$eval("var x = 2")

ctx1$get("x")  # 1
ctx2$get("x")  # 2

# Reset context
ctx1$reset()
```

## Typed Arrays

```r
# Work with typed arrays
ctx$eval("
  var buffer = new ArrayBuffer(16);
  var view = new Float64Array(buffer);
  view[0] = 3.14;
  view[1] = 2.71;
")

ctx$get("view")
```

## Async Operations

```r
# V8 is single-threaded, no true async
# But can use callbacks pattern

ctx$eval("
  function processAsync(data, callback) {
    // Simulate processing
    var result = data.map(x => x * 2);
    callback(result);
  }
")

# Call with callback
ctx$assign("myCallback", function(result) {
  print(result)
})
ctx$eval("processAsync([1,2,3], myCallback)")
```

## JSON Processing

```r
# Parse JSON
ctx$eval("var data = JSON.parse('{\"a\": 1, \"b\": 2}')")
ctx$get("data")

# Stringify
ctx$assign("rdata", list(x = 1, y = 2))
ctx$eval("var json = JSON.stringify(rdata)")
ctx$get("json")
```

## Use Cases

```r
# 1. Data validation with JSON Schema
ctx$source("ajv.bundle.js")
ctx$eval("
  var Ajv = require('ajv');
  var ajv = new Ajv();
  var schema = {type: 'object', properties: {x: {type: 'number'}}};
  var validate = ajv.compile(schema);
")
ctx$call("validate", list(x = 1))

# 2. Text processing
ctx$eval("
  function slugify(text) {
    return text.toLowerCase()
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-|-$/g, '');
  }
")
ctx$call("slugify", "Hello World!")

# 3. Math operations
ctx$eval("
  function factorial(n) {
    return n <= 1 ? 1 : n * factorial(n - 1);
  }
")
ctx$call("factorial", 10)
```
