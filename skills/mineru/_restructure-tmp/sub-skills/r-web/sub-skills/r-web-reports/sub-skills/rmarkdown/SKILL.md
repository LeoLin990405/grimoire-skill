---
name: rmarkdown
description: R rmarkdown package for dynamic documents. Use for creating reports, presentations, and documents from R.
---

# rmarkdown Package

Dynamic documents combining R code and text.

## Document Types

```yaml
---
title: "My Report"
author: "Name"
date: "`r Sys.Date()`"
output: html_document
---
```

```r
# Output formats
output: html_document
output: pdf_document
output: word_document
output: github_document
output: ioslides_presentation
output: slidy_presentation
output: beamer_presentation
```

## Code Chunks

````markdown
```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

```{r load-data}
library(tidyverse)
data <- read_csv("data.csv")
```

```{r plot, fig.width=8, fig.height=6}
ggplot(data, aes(x, y)) + geom_point()
```
````

## Chunk Options

```r
# Common options
echo = FALSE      # Hide code
eval = FALSE      # Don't run
include = FALSE   # Run but hide everything
message = FALSE   # Hide messages
warning = FALSE   # Hide warnings
results = "hide"  # Hide output
fig.width = 8     # Figure width
fig.height = 6    # Figure height
cache = TRUE      # Cache results
```

## Inline Code

```markdown
The mean is `r mean(data$x)` and n = `r nrow(data)`.
```

## Parameters

```yaml
---
params:
  year: 2023
  region: "North"
---
```

```r
# Use in document
data %>% filter(year == params$year)

# Render with parameters
rmarkdown::render("report.Rmd", params = list(year = 2024))
```

## Render

```r
# Single document
rmarkdown::render("report.Rmd")

# With output file
rmarkdown::render("report.Rmd", output_file = "output.html")

# Multiple formats
rmarkdown::render("report.Rmd", output_format = "all")
```
