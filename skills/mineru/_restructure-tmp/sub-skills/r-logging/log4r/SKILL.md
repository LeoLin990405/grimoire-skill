---
name: log4r
description: R log4r package for simple logging. Use for fast, simple log4j-style logging.
---

# log4r

Simple, fast logging for R.

## Basic Usage

```r
library(log4r)

# Create logger
logger <- logger()

# Log messages
debug(logger, "Debug message")
info(logger, "Info message")
warn(logger, "Warning message")
error(logger, "Error message")
fatal(logger, "Fatal message")
```

## Logger Configuration

```r
# Create logger with options
logger <- logger(
  threshold = "INFO",
  appenders = console_appender()
)

# With file appender
logger <- logger(
  threshold = "DEBUG",
  appenders = file_appender("app.log")
)

# Multiple appenders
logger <- logger(
  threshold = "INFO",
  appenders = list(
    console_appender(),
    file_appender("app.log")
  )
)
```

## Log Levels

```r
# Levels (lowest to highest)
# DEBUG < INFO < WARN < ERROR < FATAL

# Set threshold
logger <- logger(threshold = "WARN")

# Level constants
log4r:::DEBUG
log4r:::INFO
log4r:::WARN
log4r:::ERROR
log4r:::FATAL
```

## Appenders

```r
# Console appender
console_appender(layout = default_log_layout())

# File appender
file_appender(
  file = "app.log",
  append = TRUE,
  layout = default_log_layout()
)

# Custom appender
my_appender <- function(level, ...) {
  msg <- paste(..., collapse = " ")
  # Custom logic
  cat(sprintf("[%s] %s\n", level, msg))
}
```

## Layouts

```r
# Default layout
default_log_layout()

# Custom layout function
my_layout <- function(level, ...) {
  msg <- paste(..., collapse = " ")
  sprintf("[%s] [%s] %s",
          format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
          level,
          msg)
}

logger <- logger(
  appenders = console_appender(layout = my_layout)
)
```

## Formatted Messages

```r
# Use sprintf-style formatting
info(logger, sprintf("Processing file: %s", filename))
info(logger, sprintf("Completed %d of %d", current, total))

# Or paste
info(logger, "User", user, "logged in")
```

## Conditional Logging

```r
# Check level before expensive operations
if (logger$threshold <= log4r:::DEBUG) {
  debug(logger, expensive_computation())
}
```

## Global Logger

```r
# Create global logger
.logger <- logger(threshold = "INFO")

# Wrapper functions
log_debug <- function(...) debug(.logger, ...)
log_info <- function(...) info(.logger, ...)
log_warn <- function(...) warn(.logger, ...)
log_error <- function(...) error(.logger, ...)

# Use throughout application
log_info("Application started")
```

## Exception Logging

```r
tryCatch({
  risky_operation()
}, error = function(e) {
  error(logger, "Operation failed:", e$message)
})
```

## Performance

```r
# log4r is designed for speed
# - Minimal overhead when level is below threshold
# - Simple implementation

# Benchmark
library(microbenchmark)
microbenchmark(
  info(logger, "test message"),
  times = 1000
)
```

## Configuration Example

```r
# Application setup
setup_logging <- function(level = "INFO", log_file = NULL) {
  appenders <- list(console_appender())

  if (!is.null(log_file)) {
    appenders <- c(appenders, list(file_appender(log_file)))
  }

  logger <<- logger(
    threshold = level,
    appenders = appenders
  )
}

# Initialize
setup_logging("DEBUG", "logs/app.log")
```
