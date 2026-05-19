---
name: quarto
description: R quarto package for next-gen publishing. Use for multi-language documents, websites, and books.
---

# Quarto

Next-generation scientific publishing system.

## Document Types

```yaml
---
title: "My Document"
author: "Name"
format: html
---
```

```yaml
# Formats
format: html
format: pdf
format: docx
format: revealjs  # Presentations
format: dashboard
```

## Code Cells

````markdown
```{r}
library(tidyverse)
mtcars %>% head()
```

```{python}
import pandas as pd
df = pd.read_csv("data.csv")
```
````

## Cell Options

````markdown
```{r}
#| label: fig-plot
#| fig-cap: "My figure caption"
#| fig-width: 8
#| fig-height: 6
#| echo: false

ggplot(mtcars, aes(wt, mpg)) + geom_point()
```
````

## Cross-References

```markdown
See @fig-plot for the visualization.
See @tbl-data for the data.
See @sec-methods for methods.
```

## Projects

```bash
# Create project
quarto create project website mysite
quarto create project book mybook

# Render
quarto render
quarto preview
```

## Websites

```yaml
# _quarto.yml
project:
  type: website

website:
  title: "My Site"
  navbar:
    left:
      - href: index.qmd
        text: Home
      - about.qmd
```

## Books

```yaml
# _quarto.yml
project:
  type: book

book:
  title: "My Book"
  chapters:
    - index.qmd
    - intro.qmd
    - methods.qmd
```

## Render from R

```r
quarto::quarto_render("document.qmd")
quarto::quarto_preview("document.qmd")
```
