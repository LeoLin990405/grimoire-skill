---
name: r-viz-interactive
description: R interactive visualization with plotly, leaflet, DT, highcharter. Use for interactive charts, maps, data tables, and dashboards.
---

# R Interactive Visualization

Interactive HTML widgets for web-based visualization.

## plotly

```r
library(plotly)

# Convert ggplot2
p <- ggplot(df, aes(x, y, color = group)) + geom_point()
ggplotly(p)

# Native plotly
plot_ly(df, x = ~x, y = ~y, color = ~group, type = "scatter", mode = "markers")

# Line chart
plot_ly(df, x = ~date, y = ~value, type = "scatter", mode = "lines")

# Bar chart
plot_ly(df, x = ~category, y = ~value, type = "bar")

# Multiple traces
plot_ly(df) %>%
  add_trace(x = ~x, y = ~y1, name = "Series 1", type = "scatter", mode = "lines") %>%
  add_trace(x = ~x, y = ~y2, name = "Series 2", type = "scatter", mode = "lines")

# 3D scatter
plot_ly(df, x = ~x, y = ~y, z = ~z, color = ~group, type = "scatter3d")

# Heatmap
plot_ly(z = ~matrix, type = "heatmap")

# Layout
plot_ly(df, x = ~x, y = ~y) %>%
  layout(
    title = "Title",
    xaxis = list(title = "X Axis"),
    yaxis = list(title = "Y Axis"),
    showlegend = TRUE
  )

# Subplots
subplot(p1, p2, nrows = 1, shareX = TRUE)
```

## leaflet (Maps)

```r
library(leaflet)

# Basic map
leaflet() %>%
  addTiles() %>%
  setView(lng = 116.4, lat = 39.9, zoom = 10)

# Markers
leaflet(df) %>%
  addTiles() %>%
  addMarkers(~lng, ~lat, popup = ~name)

# Circle markers
leaflet(df) %>%
  addTiles() %>%
  addCircleMarkers(~lng, ~lat,
    radius = ~sqrt(value),
    color = ~colorFactor("Set1", category)(category),
    popup = ~paste(name, ":", value)
  )

# Choropleth
leaflet(shp) %>%
  addTiles() %>%
  addPolygons(
    fillColor = ~colorQuantile("YlOrRd", value)(value),
    weight = 1,
    fillOpacity = 0.7,
    popup = ~name
  )

# Layers control
leaflet() %>%
  addTiles(group = "OSM") %>%
  addProviderTiles("CartoDB.Positron", group = "CartoDB") %>%
  addLayersControl(baseGroups = c("OSM", "CartoDB"))

# Legend
leaflet() %>%
  addLegend(
    position = "bottomright",
    pal = colorNumeric("viridis", df$value),
    values = df$value,
    title = "Value"
  )
```

## DT (Data Tables)

```r
library(DT)

# Basic table
datatable(df)

# With options
datatable(df,
  filter = "top",
  options = list(
    pageLength = 25,
    scrollX = TRUE,
    order = list(list(0, "desc"))
  )
)

# Formatting
datatable(df) %>%
  formatCurrency("price", "$") %>%
  formatPercentage("rate", 2) %>%
  formatRound("value", 2) %>%
  formatStyle("status",
    backgroundColor = styleEqual(c("good", "bad"), c("green", "red"))
  )

# Row selection
datatable(df, selection = "multiple")
# In Shiny: input$table_rows_selected
```

## highcharter

```r
library(highcharter)

# Line chart
hchart(df, "line", hcaes(x = date, y = value, group = category))

# Bar chart
hchart(df, "column", hcaes(x = category, y = value))

# Scatter
hchart(df, "scatter", hcaes(x = x, y = y, group = category))

# Stock chart
hchart(stock_data, type = "stock")

# Customization
hchart(df, "line", hcaes(x = date, y = value)) %>%
  hc_title(text = "Title") %>%
  hc_xAxis(title = list(text = "Date")) %>%
  hc_yAxis(title = list(text = "Value")) %>%
  hc_add_theme(hc_theme_economist())
```

## echarts4r

```r
library(echarts4r)

df %>%
  e_charts(x) %>%
  e_line(y1) %>%
  e_bar(y2) %>%
  e_title("Title") %>%
  e_tooltip(trigger = "axis") %>%
  e_theme("dark")
```

## visNetwork

```r
library(visNetwork)

visNetwork(nodes, edges) %>%
  visOptions(
    highlightNearest = TRUE,
    nodesIdSelection = TRUE
  ) %>%
  visLayout(randomSeed = 123) %>%
  visPhysics(stabilization = FALSE)
```

## dygraphs (Time Series)

```r
library(dygraphs)

dygraph(xts_data) %>%
  dyRangeSelector() %>%
  dyOptions(stackedGraph = TRUE) %>%
  dyHighlight(highlightSeriesOpts = list(strokeWidth = 2))
```
