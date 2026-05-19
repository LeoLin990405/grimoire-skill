---
name: formattable
description: R formattable package for formatted data structures. Use for creating colorful, formatted tables with conditional formatting.
---

# formattable

Formattable data structures for beautiful tables.

## Basic Formatting

```r
library(formattable)

# Format numbers
formattable(df, list(
  value = color_tile("white", "orange"),
  percent = percent,
  currency = currency
))

# Accounting format
accounting(c(1000, -500, 2500))

# Percent format
percent(c(0.1, 0.25, 0.5))

# Currency format
currency(c(100, 200, 300), symbol = "$")
```

## Color Formatting

```r
# Color tile (background)
formattable(df, list(
  value = color_tile("white", "steelblue")
))

# Color bar
formattable(df, list(
  value = color_bar("lightgreen")
))

# Color text
formattable(df, list(
  value = color_text("red", "green")
))

# Normalize colors
formattable(df, list(
  value = normalize_bar("pink", 0.2)
))
```

## Conditional Formatting

```r
# Formatter function
formattable(df, list(
  value = formatter("span",
    style = x ~ style(
      color = ifelse(x > 0, "green", "red"),
      font.weight = "bold"
    ))
))

# Icon formatting
formattable(df, list(
  status = formatter("span",
    style = x ~ style(color = ifelse(x == "Good", "green", "red")),
    x ~ icontext(ifelse(x == "Good", "ok", "remove"), x)
  )
))

# Multiple conditions
formattable(df, list(
  score = formatter("span",
    style = x ~ style(
      display = "block",
      padding = "0 4px",
      `border-radius` = "4px",
      `background-color` = case_when(
        x >= 90 ~ "#71CA97",
        x >= 70 ~ "#FFF3CD",
        TRUE ~ "#F8D7DA"
      )
    ))
))
```

## Icons

```r
# Add icons
formattable(df, list(
  trend = formatter("span",
    style = x ~ style(color = ifelse(x > 0, "green", "red")),
    x ~ icontext(ifelse(x > 0, "arrow-up", "arrow-down"))
  ),
  status = formatter("span",
    x ~ icontext(
      ifelse(x == "Pass", "ok-sign", "remove-sign"),
      ifelse(x == "Pass", "Pass", "Fail")
    )
  )
))

# Available icons (Bootstrap glyphicons)
# ok, remove, arrow-up, arrow-down, star, star-empty, etc.
```

## Sparklines

```r
# With sparklines (requires sparkline package)
library(sparkline)

df$trend <- sapply(1:nrow(df), function(i) {
  as.character(htmltools::as.tags(
    sparkline(sample(1:10, 10))
  ))
})

formattable(df)
```

## Area Formatting

```r
# Format specific area
formattable(df, list(
  area(col = c(value1, value2)) ~ color_tile("white", "pink"),
  area(col = value3) ~ color_bar("lightblue")
))

# Format by row condition
formattable(df, list(
  area(row = df$category == "A") ~ formatter("span",
    style = ~ style(background = "lightyellow"))
))
```

## Custom Formatters

```r
# Create custom formatter
bold_formatter <- formatter("span",
  style = ~ style(font.weight = "bold"))

red_if_negative <- formatter("span",
  style = x ~ style(color = ifelse(x < 0, "red", "black")))

# Use custom formatter
formattable(df, list(
  name = bold_formatter,
  value = red_if_negative
))
```

## With DT

```r
library(DT)

# Convert to DT for interactivity
as.datatable(formattable(df, list(
  value = color_bar("lightgreen")
)))
```

## Export

```r
# To HTML widget
widget <- as.htmlwidget(formattable(df))

# Save as HTML
htmlwidgets::saveWidget(widget, "table.html")

# In RMarkdown/Shiny
formattable(df)  # Renders automatically
```

## Styling Options

```r
formattable(df,
  align = c("l", "c", "r"),  # Left, center, right
  list(
    col1 = formatter("span", style = ~ style(width = "100px")),
    col2 = formatter("span", style = ~ style(
      font.family = "monospace",
      font.size = "12px"
    ))
  )
)
```
