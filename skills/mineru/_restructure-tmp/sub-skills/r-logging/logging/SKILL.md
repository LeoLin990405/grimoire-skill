---
name: logging
description: R logging package for Python-style logging. Use for logging with handlers and formatters.
---

# logging

Python-style logging for R.

## Basic Usage

```r
library(logging)

# Initialize basic configuration
basicConfig()

# Log messages
logdebug("Debug message")
loginfo("Info message")
logwarn("Warning message")
logerror("Error message")
logfinest("Finest message")
```

## Configuration

```r
# Basic config with level
basicConfig(level = "DEBUG")

# With file handler
basicConfig(level = "INFO")
addHandler(writeToFile, file = "app.log")

# Custom format
basicConfig(level = "INFO")
```

## Log Levels

```r
# Levels (lowest to highest)
# FINEST < FINER < FINE < DEBUG < INFO < WARNING < ERROR

# Set level
setLevel("DEBUG")
setLevel("INFO", container = "logger.name")

# Get level
getLevel()
```

## Named Loggers

```r
# Get/create logger
logger <- getLogger("myapp")

# Set level for specific logger
setLevel("DEBUG", container = "myapp")

# Log with logger name
loginfo("Message", logger = "myapp")

# Hierarchical loggers
setLevel("INFO", container = "myapp")
setLevel("DEBUG", container = "myapp.database")
```

## Handlers

```r
# Console handler (default)
addHandler(writeToConsole)

# File handler
addHandler(writeToFile, file = "app.log")

# Custom handler
myHandler <- function(msg, handler) {
  # Custom logic
  cat(msg, "\n")
}
addHandler(myHandler)

# Remove handler
removeHandler("writeToConsole")
```

## Formatters

```r
# Default format includes:
# - Timestamp
# - Level
# - Logger name
# - Message

# Custom formatter
formatter <- function(record) {
  sprintf("[%s] [%s] %s",
          record$timestamp,
          record$levelname,
          record$msg)
}
```

## Formatted Messages

```r
# Printf-style
loginfo("Processing file: %s", filename)
loginfo("Completed %d of %d items", current, total)

# Multiple arguments
loginfo("User %s action %s", user, action)
```

## Exception Logging

```r
tryCatch({
  risky_operation()
}, error = function(e) {
  logerror("Operation failed: %s", e$message)
})

# With condition
logwarn("Condition: %s", conditionMessage(cond))
```

## Logger Hierarchy

```r
# Parent logger
setLevel("INFO", container = "app")

# Child loggers inherit settings
loginfo("Database query", logger = "app.db")
loginfo("API call", logger = "app.api")

# Override child level
setLevel("DEBUG", container = "app.db")
```

## Configuration Example

```r
# Application setup
setup_logging <- function() {
  # Reset
  logReset()

  # Basic config
  basicConfig(level = "INFO")

  # Add file handler
  addHandler(writeToFile,
             file = "logs/app.log",
             level = "DEBUG")

  # Add console handler for errors only
  addHandler(writeToConsole,
             level = "ERROR")
}

# Initialize
setup_logging()
```

## Conditional Logging

```r
# Check if level is enabled
if (getLevel() <= loglevels["DEBUG"]) {
  logdebug("Expensive: %s", expensive_computation())
}
```

## Reset Logging

```r
# Reset all logging configuration
logReset()

# Then reconfigure
basicConfig(level = "INFO")
```

## With Functions

```r
# Log function entry/exit
my_function <- function(x) {
  loginfo("Entering my_function with x=%s", x)

  result <- tryCatch({
    # Function logic
    x * 2
  }, error = function(e) {
    logerror("Error in my_function: %s", e$message)
    NA
  })

  loginfo("Exiting my_function with result=%s", result)
  result
}
```
