---
name: gt
description: R gt package for grammar of tables. Use for creating publication-quality tables.
---

# gt

Easily create presentation-ready display tables.

## Basic Table

```r
library(gt)

# Create gt table
mtcars %>%
  head() %>%
  gt()

# From data frame
gt(df)
```

## Structure

```r
df %>%
  gt(rowname_col = "name") %>%
  tab_header(
    title = "Table Title",
    subtitle = "Subtitle here"
  ) %>%
  tab_source_note("Source: Dataset") %>%
  tab_footnote(
    footnote = "Note about data",
    locations = cells_body(columns = col1, rows = 1)
  )
```

## Column Labels

```r
df %>%
  gt() %>%
  cols_label(
    col1 = "Column 1",
    col2 = "Column 2"
  ) %>%
  cols_move_to_start(col2) %>%
  cols_hide(col3)
```

## Formatting

```r
df %>%
  gt() %>%
  fmt_number(columns = value, decimals = 2) %>%
  fmt_currency(columns = price, currency = "USD") %>%
  fmt_percent(columns = pct, decimals = 1) %>%
  fmt_date(columns = date, date_style = "yMMMd")
```

## Styling

```r
df %>%
  gt() %>%
  tab_style(
    style = cell_fill(color = "lightblue"),
    locations = cells_body(columns = col1)
  ) %>%
  tab_style(
    style = cell_text(weight = "bold"),
    locations = cells_column_labels()
  )
```

## Conditional Formatting

```r
df %>%
  gt() %>%
  data_color(
    columns = value,
    colors = scales::col_numeric(
      palette = c("red", "white", "green"),
      domain = NULL
    )
  )
```

## Grouping

```r
df %>%
  gt(groupname_col = "group") %>%
  tab_spanner(
    label = "Measurements",
    columns = c(col1, col2)
  )
```

## Summary Rows

```r
df %>%
  gt(groupname_col = "group") %>%
  summary_rows(
    groups = TRUE,
    columns = value,
    fns = list(
      Total = ~sum(.),
      Average = ~mean(.)
    )
  ) %>%
  grand_summary_rows(
    columns = value,
    fns = list(Grand = ~sum(.))
  )
```

## Export

```r
# Save as HTML
gtsave(table, "table.html")

# Save as PNG
gtsave(table, "table.png")

# Save as PDF
gtsave(table, "table.pdf")

# Save as RTF
gtsave(table, "table.rtf")
```
