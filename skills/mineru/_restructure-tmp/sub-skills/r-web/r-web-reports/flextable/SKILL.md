---
name: flextable
description: R flextable package for flexible tables. Use for creating publication-ready tables for Word, PowerPoint, HTML, and PDF.
---

# flextable

Create flexible tables for multiple output formats.

## Basic Table

```r
library(flextable)

# Create flextable
ft <- flextable(head(mtcars))
ft

# From data frame
ft <- flextable(df)

# Select columns
ft <- flextable(df, col_keys = c("name", "value", "category"))
```

## Formatting

```r
ft <- flextable(df) %>%
  # Bold header
  bold(part = "header") %>%
  # Italic specific column
  italic(j = "name") %>%
  # Color text
  color(j = "value", color = "blue") %>%
  # Background color
  bg(j = "status", bg = "lightgray") %>%
  # Font size
  fontsize(size = 10, part = "all") %>%
  # Font family
  font(fontname = "Arial", part = "all")
```

## Conditional Formatting

```r
ft <- flextable(df) %>%
  # Color based on value

  color(i = ~ value > 100, j = "value", color = "red") %>%
  # Background based on condition
  bg(i = ~ status == "Critical", bg = "pink") %>%
  # Bold based on condition
  bold(i = ~ important == TRUE)
```

## Column Formatting

```r
ft <- flextable(df) %>%
  # Number formatting
  colformat_double(j = "value", digits = 2) %>%
  # Percent
  colformat_double(j = "rate", digits = 1, suffix = "%") %>%
  # Currency
  colformat_double(j = "price", prefix = "$", digits = 2) %>%
  # Date
  colformat_date(j = "date", fmt_date = "%Y-%m-%d") %>%
  # Integer
  colformat_int(j = "count", big.mark = ",")
```

## Headers

```r
ft <- flextable(df) %>%
  # Rename headers
  set_header_labels(
    col1 = "Column One",
    col2 = "Column Two"
  ) %>%
  # Add header row
  add_header_row(
    values = c("Group A", "Group B"),
    colwidths = c(2, 3)
  ) %>%
  # Merge header cells
  merge_h(part = "header")
```

## Borders

```r
ft <- flextable(df) %>%
  # All borders
  border_outer() %>%
  border_inner() %>%
  # Horizontal lines
  hline(border = fp_border(color = "gray")) %>%
  # Vertical lines
  vline(border = fp_border(color = "gray")) %>%
  # Bottom border on header
  hline_bottom(part = "header", border = fp_border(width = 2))
```

## Alignment

```r
ft <- flextable(df) %>%
  # Horizontal alignment
  align(j = c("name"), align = "left") %>%
  align(j = c("value"), align = "right") %>%
  align(j = c("status"), align = "center") %>%
  # Vertical alignment
  valign(valign = "center", part = "all") %>%
  # Header alignment
  align(align = "center", part = "header")
```

## Width and Height

```r
ft <- flextable(df) %>%
  # Set column widths
  width(j = "name", width = 2) %>%
  width(j = "value", width = 1) %>%
  # Auto fit

  autofit() %>%
  # Set height
  height(height = 0.5, part = "body")
```

## Merge Cells

```r
ft <- flextable(df) %>%
  # Merge vertically (same values)
  merge_v(j = "category") %>%
  # Merge horizontally
  merge_h(i = 1) %>%
  # Merge at specific location
  merge_at(i = 1:2, j = 1:2)
```

## Footnotes

```r
ft <- flextable(df) %>%
  footnote(
    i = 1, j = 1,
    value = as_paragraph("This is a footnote"),
    ref_symbols = "a"
  ) %>%
  footnote(
    i = 2, j = 2,
    value = as_paragraph("Another footnote"),
    ref_symbols = "b"
  )
```

## Export

```r
# Save as Word
save_as_docx(ft, path = "table.docx")

# Save as PowerPoint
save_as_pptx(ft, path = "table.pptx")

# Save as image
save_as_image(ft, path = "table.png")

# Save as HTML
save_as_html(ft, path = "table.html")

# Use with officer
library(officer)
doc <- read_docx() %>%
  body_add_flextable(ft)
print(doc, target = "document.docx")
```

## Themes

```r
ft <- flextable(df) %>%
  theme_vanilla() %>%
  # Or other themes
  theme_booktabs() %>%
  theme_alafoli() %>%
  theme_box() %>%
  theme_zebra()
```

## Mini Charts

```r
ft <- flextable(df) %>%
  # Sparklines
  compose(
    j = "trend",
    value = as_paragraph(
      minibar(value = trend_data)
    )
  )
```
