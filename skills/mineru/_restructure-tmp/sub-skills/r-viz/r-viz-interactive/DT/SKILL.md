---
name: DT
description: R DT package for interactive data tables. Use for creating searchable, sortable, paginated HTML tables.
---

# DT

Interactive data tables.

## Basic Table

```r
library(DT)

datatable(df)
datatable(df, options = list(pageLength = 25))
```

## Options

```r
datatable(df, options = list(
  pageLength = 10,
  lengthMenu = c(5, 10, 25, 50),
  searching = TRUE,
  ordering = TRUE,
  autoWidth = TRUE,
  scrollX = TRUE,
  scrollY = "400px",
  dom = "Bfrtip"  # Button, filter, processing, table, info, pagination
))
```

## Filtering

```r
# Column filters
datatable(df, filter = "top")
datatable(df, filter = "bottom")

# Filter types
datatable(df, filter = list(
  position = "top",
  clear = TRUE,
  plain = FALSE
))
```

## Formatting

```r
datatable(df) %>%
  formatCurrency("price", currency = "$", digits = 2) %>%
  formatPercentage("rate", digits = 1) %>%
  formatRound("value", digits = 2) %>%
  formatDate("date", method = "toLocaleDateString") %>%
  formatStyle("status",
    backgroundColor = styleEqual(c("good", "bad"), c("green", "red"))
  )

# Conditional formatting
datatable(df) %>%
  formatStyle("value",
    background = styleColorBar(df$value, "steelblue"),
    backgroundSize = "100% 90%",
    backgroundRepeat = "no-repeat",
    backgroundPosition = "center"
  )

datatable(df) %>%
  formatStyle("value",
    color = styleInterval(c(0, 100), c("red", "black", "green"))
  )
```

## Selection

```r
# Row selection
datatable(df, selection = "single")
datatable(df, selection = "multiple")
datatable(df, selection = list(mode = "multiple", selected = c(1, 3, 5)))

# In Shiny
output$table <- renderDT(datatable(df, selection = "single"))
selected_rows <- input$table_rows_selected
```

## Buttons

```r
datatable(df, extensions = "Buttons", options = list(
  dom = "Bfrtip",
  buttons = c("copy", "csv", "excel", "pdf", "print")
))

# Custom buttons
datatable(df, extensions = "Buttons", options = list(
  buttons = list(
    list(extend = "csv", filename = "data"),
    list(extend = "excel", filename = "data")
  )
))
```

## Extensions

```r
# Fixed columns
datatable(df, extensions = "FixedColumns", options = list(
  scrollX = TRUE,
  fixedColumns = list(leftColumns = 2)
))

# Row grouping
datatable(df, extensions = "RowGroup", options = list(
  rowGroup = list(dataSrc = 1)
))

# Scroller (virtual scrolling)
datatable(df, extensions = "Scroller", options = list(
  deferRender = TRUE,
  scrollY = 400,
  scroller = TRUE
))
```

## Editable

```r
datatable(df, editable = TRUE)
datatable(df, editable = list(target = "cell", disable = list(columns = c(0, 1))))

# In Shiny
observeEvent(input$table_cell_edit, {
  info <- input$table_cell_edit
  # info$row, info$col, info$value
})
```
