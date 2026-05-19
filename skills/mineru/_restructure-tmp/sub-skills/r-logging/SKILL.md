---
name: r-logging
description: R logging packages for application logging. Use for structured logging, debugging, and monitoring R applications.
---

# R Logging

Logging frameworks for R applications.

## Overview

| Package | Style | Features |
|---------|-------|----------|
| futile.logger | log4j-style | Hierarchical loggers, layouts |
| log4r | log4j-style | Simple, fast |
| logging | Python-style | Handlers, formatters |

## Quick Start

```r
# futile.logger
library(futile.logger)
flog.info("Application started")
flog.warn("Low memory: %d MB", memory_mb)
flog.error("Failed to connect: %s", error_msg)

# log4r
library(log4r)
logger <- logger()
info(logger, "Application started")
warn(logger, "Low memory")
error(logger, "Connection failed")

# logging
library(logging)
basicConfig()
loginfo("Application started")
logwarn("Low memory")
logerror("Connection failed")
```

## Log Levels

```r
# Standard levels (lowest to highest priority)
# TRACE < DEBUG < INFO < WARN < ERROR < FATAL

# Set threshold
flog.threshold(INFO)  # Only INFO and above
flog.threshold(DEBUG) # Include DEBUG messages
```

## Best Practices

```r
# 1. Use appropriate levels
flog.debug("Variable x = %d", x)      # Development details
flog.info("Processing file: %s", f)   # Normal operations
flog.warn("Retry attempt %d", n)      # Potential issues
flog.error("Failed: %s", msg)         # Errors
flog.fatal("Cannot continue")         # Critical failures

# 2. Include context
flog.info("[%s] User %s logged in", session_id, user)

# 3. Log to file in production
flog.appender(appender.file("app.log"))

# 4. Use structured data when possible
flog.info("Request completed", request_id = id, duration = ms)
```

## Sub-skills

- futile.logger: Full-featured log4j-style logging
- log4r: Simple and fast logging
- logging: Python-style logging
