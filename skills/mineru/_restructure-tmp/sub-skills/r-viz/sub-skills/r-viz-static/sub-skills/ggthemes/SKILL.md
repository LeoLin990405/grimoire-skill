---
name: ggthemes
description: R ggthemes package for extra ggplot2 themes. Use for publication-ready themes like Economist, WSJ, FiveThirtyEight.
---

# ggthemes Package

Extra themes and scales for ggplot2.

## Themes

```r
library(ggplot2)
library(ggthemes)

p <- ggplot(mtcars, aes(wt, mpg)) + geom_point()

# Publication themes
p + theme_economist()
p + theme_wsj()
p + theme_fivethirtyeight()
p + theme_tufte()
p + theme_stata()
p + theme_excel()
p + theme_gdocs()
p + theme_hc()  # Highcharts

# Minimal themes
p + theme_few()
p + theme_clean()
p + theme_foundation()
```

## Color Scales

```r
# Economist
p + scale_color_economist()

# Tableau
p + scale_color_tableau()
p + scale_fill_tableau()

# Colorblind-safe
p + scale_color_colorblind()

# FiveThirtyEight
p + scale_color_fivethirtyeight()

# Stata
p + scale_color_stata()

# Few
p + scale_color_few()
```

## Shapes

```r
# Shapes for colorblind
p + scale_shape_cleveland()
p + scale_shape_tremmel()
```

## Example

```r
ggplot(economics, aes(date, unemploy)) +
  geom_line() +
  theme_economist() +
  scale_color_economist() +
  labs(title = "US Unemployment")
```
