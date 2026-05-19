---
name: echarts4r
description: R echarts4r package for Apache ECharts. Use for interactive charts with Chinese language support.
---

# echarts4r Package

R interface to Apache ECharts.

## Basic Charts

```r
library(echarts4r)

# Line
df %>%
  e_charts(x) %>%
  e_line(y)

# Bar
df %>%
  e_charts(category) %>%
  e_bar(value)

# Scatter
df %>%
  e_charts(x) %>%
  e_scatter(y, size = z)

# Pie
df %>%
  e_charts(category) %>%
  e_pie(value)
```

## Multiple Series

```r
df %>%
  e_charts(date) %>%
  e_line(series1, name = "Series 1") %>%
  e_line(series2, name = "Series 2") %>%
  e_area(series3, name = "Series 3")
```

## Customization

```r
df %>%
  e_charts(x) %>%
  e_line(y) %>%
  e_title("Chart Title", "Subtitle") %>%
  e_legend(right = 0) %>%
  e_tooltip(trigger = "axis") %>%
  e_toolbox_feature(feature = "saveAsImage") %>%
  e_theme("dark")
```

## Animations

```r
df %>%
  e_charts(x) %>%
  e_line(y) %>%
  e_animation(duration = 1000)
```

## Maps

```r
# China map
df %>%
  e_charts(province) %>%
  e_map(value, map = "china")

# World map
df %>%
  e_charts(country) %>%
  e_map(value, map = "world")
```

## 3D Charts

```r
df %>%
  e_charts(x) %>%
  e_scatter_3d(y, z, color)

df %>%
  e_charts(x) %>%
  e_surface_3d(y, z)
```

## Timeline

```r
df %>%
  group_by(year) %>%
  e_charts(x, timeline = TRUE) %>%
  e_bar(y)
```

## Themes

```r
e_theme("vintage")
e_theme("dark")
e_theme("westeros")
e_theme("essos")
e_theme("roma")
```
