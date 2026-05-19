---
name: dygraphs
description: R dygraphs package for time series visualization. Use for creating interactive time series charts.
---

# dygraphs

Interactive time series visualization.

## Basic Usage

```r
library(dygraphs)

# From xts object
library(xts)
ts_data <- xts(rnorm(100), order.by = Sys.Date() + 1:100)
dygraph(ts_data)

# From data frame with date column
dygraph(df, x = "date")

# Multiple series
dygraph(cbind(series1, series2))
```

## Customization

```r
dygraph(ts_data) %>%
  dyOptions(
    colors = c("blue", "red"),
    strokeWidth = 2,
    fillGraph = TRUE,
    fillAlpha = 0.2
  ) %>%
  dyAxis("y", label = "Value") %>%
  dyAxis("x", label = "Date")
```

## Range Selector

```r
dygraph(ts_data) %>%
  dyRangeSelector(
    height = 20,
    strokeColor = "gray",
    fillColor = "lightgray"
  )
```

## Annotations

```r
dygraph(ts_data) %>%
  dyAnnotation("2024-06-15", text = "Event", tooltip = "Important event") %>%
  dyAnnotation("2024-07-01", text = "A", attachAtBottom = TRUE)
```

## Shading

```r
dygraph(ts_data) %>%
  dyShading(from = "2024-01-01", to = "2024-03-31", color = "#FFE6E6") %>%
  dyShading(from = "2024-07-01", to = "2024-09-30", color = "#E6FFE6")
```

## Events

```r
dygraph(ts_data) %>%
  dyEvent("2024-06-15", "Event 1", labelLoc = "bottom") %>%
  dyEvent("2024-08-01", "Event 2", color = "red")
```

## Highlighting

```r
dygraph(ts_data) %>%
  dyHighlight(
    highlightCircleSize = 5,
    highlightSeriesBackgroundAlpha = 0.2,
    hideOnMouseOut = FALSE
  )
```

## Series Options

```r
dygraph(cbind(series1, series2)) %>%
  dySeries("series1", label = "Series 1", color = "blue") %>%
  dySeries("series2", label = "Series 2", color = "red", strokePattern = "dashed")
```

## Candlestick/OHLC

```r
# OHLC data
dygraph(ohlc_data) %>%
  dyCandlestick()

# Or bar chart
dygraph(ohlc_data) %>%
  dyBarChart()
```

## Rolling Average

```r
dygraph(ts_data) %>%
  dyRoller(rollPeriod = 7)
```

## Callbacks

```r
dygraph(ts_data) %>%
  dyCallbacks(
    clickCallback = JS("function(e, x, points) { alert('Clicked: ' + x); }"),
    highlightCallback = JS("function(e, x, points, row) { console.log(x); }")
  )
```

## Legend

```r
dygraph(ts_data) %>%
  dyLegend(
    show = "always",
    width = 400,
    labelsSeparateLines = TRUE
  )
```

## Limits

```r
dygraph(ts_data) %>%
  dyLimit(50, "Upper", strokePattern = "dashed", color = "red") %>%
  dyLimit(20, "Lower", strokePattern = "dotted", color = "blue")
```

## Export

```r
# Save as HTML
library(htmlwidgets)
p <- dygraph(ts_data)
saveWidget(p, "timeseries.html")
```
