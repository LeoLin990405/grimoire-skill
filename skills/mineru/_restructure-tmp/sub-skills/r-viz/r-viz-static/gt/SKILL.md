---
name: gt
description: R gt package for publication-quality tables. Use for creating beautiful, customizable tables for reports and presentations.
---

# gt

Generate information-rich, publication-quality tables.

## Basic Table

```r
library(gt)

# Create gt table
df %>%
  gt()

# With row names
df %>%
  gt(rowname_col = "name")

# Grouped data
df %>%
  gt(groupname_col = "category")
```

## Headers and Labels

```r
df %>%
  gt() %>%
  tab_header(
    title = "Sales Report",
    subtitle = "Q1 2024"
  ) %>%
  tab_source_note("Source: Company Database") %>%
  tab_footnote(
    footnote = "Adjusted for inflation",
    locations = cells_column_labels(columns = revenue)
  )
```

## Column Formatting

```r
df %>%
  gt() %>%
  cols_label(
    col1 = "Column One",
    col2 = "Column Two"
  ) %>%
  cols_move(columns = col3, after = col1) %>%
  cols_hide(columns = temp_col) %>%
  cols_width(
    col1 ~ px(150),
    col2 ~ pct(30)
  )
```

## Number Formatting

```r
df %>%
  gt() %>%
  fmt_number(columns = value, decimals = 2) %>%
  fmt_currency(columns = price, currency = "USD") %>%
  fmt_percent(columns = rate, decimals = 1) %>%
  fmt_integer(columns = count) %>%
  fmt_scientific(columns = large_num)
```

## Date/Time Formatting

```r
df %>%
  gt() %>%
  fmt_date(columns = date, date_style = "yMMMd") %>%
  fmt_time(columns = time, time_style = "Hm") %>%
  fmt_datetime(columns = timestamp, date_style = "yMd", time_style = "Hms")
```

## Styling

```r
df %>%
  gt() %>%
  tab_style(
    style = cell_fill(color = "lightblue"),
    locations = cells_body(columns = value, rows = value > 100)
  ) %>%
  tab_style(
    style = cell_text(weight = "bold", color = "red"),
    locations = cells_body(columns = status, rows = status == "Critical")
  ) %>%
  tab_style(
    style = cell_borders(sides = "bottom", color = "black", weight = px(2)),
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
      palette = c("red", "yellow", "green"),
      domain = c(0, 100)
    )
  )
```

## Spanners (Column Groups)

```r
df %>%
  gt() %>%
  tab_spanner(
    label = "Metrics",
    columns = c(metric1, metric2, metric3)
  ) %>%
  tab_spanner(
    label = "Demographics",
    columns = c(age, gender, location)
  )
```

## Summary Rows

```r
df %>%
  gt() %>%
  summary_rows(
    groups = TRUE,
    columns = c(sales, profit),
    fns = list(
      Total = ~sum(.),
      Average = ~mean(.)
    )
  ) %>%
  grand_summary_rows(
    columns = c(sales, profit),
    fns = list(
      "Grand Total" = ~sum(.)
    )
  )
```

## Export

```r
# Save as HTML
tbl %>% gtsave("table.html")

# Save as PNG
tbl %>% gtsave("table.png")

# Save as PDF (requires webshot2)
tbl %>% gtsave("table.pdf")

# Save as RTF (Word-compatible)
tbl %>% gtsave("table.rtf")

# Save as LaTeX
tbl %>% as_latex()
```

## Themes

```r
df %>%
  gt() %>%
  opt_stylize(style = 1, color = "blue") %>%
  opt_row_striping() %>%
  opt_table_outline()

# Custom theme
df %>%
  gt() %>%
  tab_options(
    table.font.size = px(14),
    heading.title.font.size = px(18),
    column_labels.font.weight = "bold",
    table.border.top.style = "solid"
  )
```
