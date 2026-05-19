---
name: knitr
description: R knitr package for dynamic report generation. Use for literate programming and chunk options.
---

# knitr Package

Dynamic report generation engine.

## Global Options

```r
knitr::opts_chunk$set(
  echo = TRUE,
  message = FALSE,
  warning = FALSE,
  fig.width = 8,
  fig.height = 6,
  fig.path = "figures/",
  cache = TRUE,
  cache.path = "cache/"
)
```

## Chunk Options

```r
# Display
echo = TRUE/FALSE      # Show code
eval = TRUE/FALSE      # Run code
include = TRUE/FALSE   # Include in output
results = "markup"/"asis"/"hide"/"hold"

# Figures
fig.width = 7
fig.height = 5
fig.cap = "Caption"
fig.align = "center"/"left"/"right"
out.width = "80%"
dev = "png"/"pdf"/"svg"

# Caching
cache = TRUE
cache.lazy = TRUE
dependson = "chunk-name"
```

## Tables

```r
knitr::kable(df, caption = "My Table")

knitr::kable(df,
  format = "html",
  digits = 2,
  col.names = c("A", "B", "C"),
  align = c("l", "c", "r")
)
```

## Include External

```r
# Read external code
knitr::read_chunk("external.R")

# Include child document
```{r child = "child.Rmd"}
```

# Include graphics
knitr::include_graphics("image.png")
```

## Hooks

```r
# Custom chunk hook
knitr::knit_hooks$set(
  time = function(before, options) {
    if (before) {
      start_time <<- Sys.time()
    } else {
      paste("Time:", Sys.time() - start_time)
    }
  }
)
```

## Spin

```r
# Convert R script to Rmd
knitr::spin("script.R")

# In script.R use:
#' # Title
#' Some text
#+ chunk-name, echo=FALSE
code_here()
```
