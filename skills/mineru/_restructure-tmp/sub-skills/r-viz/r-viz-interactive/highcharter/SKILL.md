---
name: highcharter
description: R highcharter package for Highcharts visualizations. Use for interactive JavaScript charts with rich features.
---

# highcharter Package

R wrapper for Highcharts JavaScript library.

## Basic Charts

```r
library(highcharter)

# Line chart
hchart(economics, "line", hcaes(x = date, y = unemploy))

# Scatter
hchart(mtcars, "scatter", hcaes(x = wt, y = mpg, group = cyl))

# Bar
hchart(mtcars$cyl, type = "column")

# From data frame
highchart() %>%
  hc_add_series(data = df, type = "line", hcaes(x = x, y = y))
```

## Multiple Series

```r
highchart() %>%
  hc_add_series(data = df1, type = "line", name = "Series 1") %>%
  hc_add_series(data = df2, type = "line", name = "Series 2") %>%
  hc_xAxis(categories = df1$category)
```

## Customization

```r
highchart() %>%
  hc_add_series(data = df, type = "column", hcaes(x = x, y = y)) %>%
  hc_title(text = "My Chart") %>%
  hc_subtitle(text = "Subtitle") %>%
  hc_xAxis(title = list(text = "X Axis")) %>%
  hc_yAxis(title = list(text = "Y Axis")) %>%
  hc_tooltip(pointFormat = "{point.y:.2f}") %>%
  hc_legend(enabled = TRUE) %>%
  hc_credits(enabled = FALSE)
```

## Themes

```r
hc %>% hc_add_theme(hc_theme_economist())
hc %>% hc_add_theme(hc_theme_google())
hc %>% hc_add_theme(hc_theme_538())
hc %>% hc_add_theme(hc_theme_darkunica())
```

## Stock Charts

```r
library(quantmod)
getSymbols("AAPL")

highchart(type = "stock") %>%
  hc_add_series(AAPL, type = "candlestick")
```

## Maps

```r
hcmap("countries/us/us-all") %>%
  hc_add_series(data = state_data, type = "map",
    joinBy = c("hc-key", "code"),
    value = "value"
  )
```
