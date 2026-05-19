---
name: flexdashboard
description: R flexdashboard package for R Markdown dashboards. Use for creating interactive dashboards with R Markdown.
---

# flexdashboard

Easy interactive dashboards for R.

## Basic Dashboard

```yaml
---
title: "My Dashboard"
output: flexdashboard::flex_dashboard
---
```

## Layout

```markdown
Column {data-width=650}
-----------------------------------------------------------------------

### Chart A

```{r}
plot(cars)
```

Column {data-width=350}
-----------------------------------------------------------------------

### Chart B

```{r}
hist(mtcars$mpg)
```

### Chart C

```{r}
summary(mtcars)
```
```

## Rows Layout

```yaml
---
title: "Row Layout"
output:
  flexdashboard::flex_dashboard:
    orientation: rows
---
```

## Pages

```markdown
Page 1
=====================================

### Chart

```{r}
```

Page 2
=====================================

### Another Chart

```{r}
```
```

## Value Boxes

```r
library(flexdashboard)

valueBox(42, icon = "fa-users", caption = "Users")
valueBox(100, icon = "fa-dollar", color = "success")
valueBox(50, icon = "fa-warning", color = "warning")
```

## Gauges

```r
gauge(42, min = 0, max = 100, symbol = '%',
  gaugeSectors(
    success = c(80, 100),
    warning = c(40, 79),
    danger = c(0, 39)
  ))
```

## With Shiny

```yaml
---
title: "Shiny Dashboard"
output: flexdashboard::flex_dashboard
runtime: shiny
---
```

```r
# Input
selectInput("var", "Variable:", choices = names(mtcars))

# Output
renderPlot({
  hist(mtcars[[input$var]])
})
```

## Sidebar

```markdown
Sidebar {.sidebar}
-----------------------------------------------------------------------

```{r}
selectInput("x", "X Variable:", choices = names(mtcars))
```

Column
-----------------------------------------------------------------------

### Plot

```{r}
renderPlot({
  plot(mtcars[[input$x]])
})
```
```

## Themes

```yaml
---
output:
  flexdashboard::flex_dashboard:
    theme: cosmo
    # Options: default, cosmo, bootstrap, cerulean, journal, flatly, readable, spacelab, united, lumen, paper, sandstone, simplex, yeti
---
```

## Storyboard

```yaml
---
output:
  flexdashboard::flex_dashboard:
    storyboard: true
---
```

```markdown
### Frame 1 {data-commentary-width=400}

```{r}
plot(cars)
```

***

Commentary for frame 1.

### Frame 2

```{r}
hist(mtcars$mpg)
```
```
