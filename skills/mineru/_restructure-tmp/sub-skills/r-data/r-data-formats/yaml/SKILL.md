---
name: yaml
description: R yaml package for YAML parsing. Use for reading/writing YAML configuration files.
---

# yaml

YAML parsing and generation.

## Reading YAML

```r
library(yaml)

# Read from file
config <- read_yaml("config.yml")
config <- yaml.load_file("config.yml")

# Read from string
yaml_str <- "
name: project
version: 1.0
settings:
  debug: true
  threads: 4
"
config <- yaml.load(yaml_str)
```

## Writing YAML

```r
# Write to file
write_yaml(config, "output.yml")

# Convert to string
yaml_str <- as.yaml(config)
cat(yaml_str)
```

## Data Structures

```r
# Lists become YAML mappings
config <- list(
  name = "myproject",
  version = "1.0.0",
  authors = c("Alice", "Bob"),
  settings = list(
    debug = TRUE,
    port = 8080
  )
)
as.yaml(config)
# name: myproject
# version: 1.0.0
# authors:
# - Alice
# - Bob
# settings:
#   debug: yes
#   port: 8080

# Data frames
df <- data.frame(x = 1:3, y = c("a", "b", "c"))
as.yaml(df)
```

## Handlers

```r
# Custom type handlers
handlers <- list(
  "!date" = function(x) as.Date(x),
  "!expr" = function(x) eval(parse(text = x))
)

yaml_str <- "
date: !date 2024-01-15
result: !expr 1 + 2 + 3
"
config <- yaml.load(yaml_str, handlers = handlers)
```

## Options

```r
# Preserve order
config <- yaml.load_file("config.yml",
  eval.expr = FALSE,
  merge.precedence = "override"
)

# Unicode handling
write_yaml(config, "output.yml",
  unicode = TRUE,
  indent = 2
)

# Column width
as.yaml(config, column.major = FALSE, indent.mapping.sequence = TRUE)
```

## Common Patterns

```r
# Configuration file
config <- list(
  database = list(
    host = "localhost",
    port = 5432,
    name = "mydb"
  ),
  logging = list(
    level = "INFO",
    file = "app.log"
  ),
  features = list(
    enabled = c("auth", "cache"),
    disabled = c("beta")
  )
)
write_yaml(config, "config.yml")

# Read and use
config <- read_yaml("config.yml")
db_host <- config$database$host
log_level <- config$logging$level
```

## Multi-Document YAML

```r
# Read multiple documents
docs <- yaml.load_file("multi.yml",
  readLines.warn = FALSE,
  multi.document = TRUE
)

# Each document is a list element
doc1 <- docs[[1]]
doc2 <- docs[[2]]
```

## Error Handling

```r
# Safe loading
tryCatch({
  config <- read_yaml("config.yml")
}, error = function(e) {
  message("YAML parse error: ", e$message)
  config <- list()  # Default config
})
```
