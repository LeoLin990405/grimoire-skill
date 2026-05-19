---
name: scales
description: R scales package for axis scales and transformations. Use for formatting labels, color palettes, and scale transformations in ggplot2.
---

# scales Package

Scale functions for visualization.

## Label Formatting

```r
library(scales)

# Numbers
label_number()(c(1000, 2000))  # "1 000", "2 000"
label_comma()(c(1000, 2000))   # "1,000", "2,000"
label_number(suffix = "K", scale = 1e-3)(1000)  # "1K"

# Currency
label_dollar()(c(100, 1000))   # "$100", "$1,000"
label_dollar(prefix = "€")(100)

# Percent
label_percent()(c(0.1, 0.25))  # "10%", "25%"
label_percent(accuracy = 0.1)(0.123)  # "12.3%"

# Scientific
label_scientific()(c(1e6, 1e9))

# Date/time
label_date(format = "%b %Y")(Sys.Date())
```

## In ggplot2

```r
library(ggplot2)

ggplot(df, aes(x, y)) +
  geom_point() +
  scale_y_continuous(labels = label_comma()) +
  scale_x_continuous(labels = label_dollar())
```

## Transformations

```r
# Log
log_trans()
log10_trans()
log2_trans()

# Square root
sqrt_trans()

# Reverse
reverse_trans()

# Custom
trans_new("square", function(x) x^2, sqrt)
```

## Color Scales

```r
# Continuous
col_numeric("Blues", domain = c(0, 100))(50)

# Binned
col_bin("YlOrRd", bins = 5, domain = c(0, 100))

# Quantile
col_quantile("Greens", n = 4)

# Manual rescaling
rescale(1:10)  # 0 to 1
rescale(1:10, to = c(0, 100))
```

## Breaks

```r
breaks_pretty(n = 5)(1:100)
breaks_log(n = 5)(c(1, 1000))
breaks_width(width = 10)(1:100)
```
