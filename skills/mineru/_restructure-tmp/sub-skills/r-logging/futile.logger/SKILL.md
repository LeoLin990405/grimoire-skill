---
name: futile.logger
description: R futile.logger package for log4j-style logging. Use for hierarchical logging with layouts and appenders.
---

# futile.logger

Log4j-style logging for R.

## Basic Usage

```r
library(futile.logger)

# Log messages
flog.trace("Trace message")
flog.debug("Debug message")
flog.info("Info message")
flog.warn("Warning message")
flog.error("Error message")
flog.fatal("Fatal message")
```

## Formatted Messages

```r
# Printf-style formatting
flog.info("Processing file: %s", filename)
flog.info("Completed %d of %d items", current, total)
flog.info("Value: %.2f", value)

# Multiple arguments
flog.info("User %s performed action %s at %s", user, action, time)
```

## Log Levels

```r
# Set threshold
flog.threshold(INFO)   # Show INFO and above
flog.threshold(DEBUG)  # Show DEBUG and above
flog.threshold(WARN)   # Show WARN and above

# Get current threshold
flog.threshold()

# Log level constants
TRACE, DEBUG, INFO, WARN, ERROR, FATAL
```

## Named Loggers

```r
# Create named logger
flog.threshold(DEBUG, name = "myapp")
flog.info("Message", name = "myapp")

# Hierarchical loggers
flog.threshold(INFO, name = "myapp")
flog.threshold(DEBUG, name = "myapp.database")

# Child inherits from parent unless overridden
flog.info("DB query", name = "myapp.database")
```

## Appenders

```r
# Console (default)
flog.appender(appender.console())

# File
flog.appender(appender.file("app.log"))

# Tee (console and file)
flog.appender(appender.tee("app.log"))

# Multiple appenders
flog.appender(appender.tee("app.log"), name = "myapp")

# Custom appender
my_appender <- function(line) {
  # Custom logic
  cat(line, "\n")
}
flog.appender(my_appender)
```

## Layouts

```r
# Default layout
flog.layout(layout.simple)

# With timestamp
flog.layout(layout.format('[~t] [~l] ~m'))

# Custom format
# ~l = level
# ~t = timestamp
# ~n = namespace
# ~f = calling function
# ~m = message

flog.layout(layout.format('[~t] [~l] [~n] ~m'))

# JSON layout
flog.layout(layout.json)

# Tracing layout (includes function name)
flog.layout(layout.tracing)
```

## Conditional Logging

```r
# Check if level is enabled
if (flog.logger()$threshold <= DEBUG) {
  # Expensive debug computation
  flog.debug("Expensive: %s", expensive_computation())
}
```

## Exception Logging

```r
tryCatch({
  risky_operation()
}, error = function(e) {
  flog.error("Operation failed: %s", e$message)
  flog.debug("Stack trace: %s", paste(sys.calls(), collapse = "\n"))
})
```

## Configuration

```r
# Set up logging at application start
setup_logging <- function() {
  # Set global threshold

  flog.threshold(INFO)

  # Log to file
  flog.appender(appender.tee("logs/app.log"))

  # Custom layout
  flog.layout(layout.format('[~t] [~l] ~m'))

  # Debug logger for development
  flog.threshold(DEBUG, name = "debug")
  flog.appender(appender.file("logs/debug.log"), name = "debug")
}
```

## Capture Output

```r
# Capture function output
flog.capture(my_function(), name = "output")
```

## Performance

```r
# Disable logging in production
flog.threshold(FATAL)  # Only fatal errors

# Or use NULL appender
flog.appender(function(x) invisible(NULL))
```
