---
name: r-viz
description: R visualization packages. Use for static plots (ggplot2, lattice), interactive visualizations (plotly, leaflet, DT), animations (gganimate), and HTML widgets.
---

# R Visualization Skill

## Sub-skills

| Sub-skill | Description |
|-----------|-------------|
| [r-viz-static](r-viz-static/SKILL.md) | ggplot2, lattice, base graphics |
| [r-viz-interactive](r-viz-interactive/SKILL.md) | plotly, leaflet, DT, htmlwidgets |
| [r-viz-animation](r-viz-animation/SKILL.md) | gganimate, animation |

Static and interactive visualization in R.

## Static Graphics (ggplot2 ecosystem)

| Package | Description |
|---------|-------------|
| **ggplot2** ★ | Grammar of Graphics implementation |
| **patchwork** ★ | Combine ggplot2 plots |
| **ggrepel** | Repel overlapping text labels |
| **ggalt** | Extra geoms and stats |
| **ggstatsplot** | Plots with statistical details |
| **ggfortify** | Unified interface for stat packages |
| **ggtree** | Phylogenetic tree visualization |
| **ggtech** | Tech company themes |
| **hrbrthemes** | Typographic-centric themes |
| **corrplot** | Correlation matrix display |

## Other Static Graphics

| Package | Description |
|---------|-------------|
| **lattice** | High-level Trellis graphics |
| **rgl** | 3D visualization device |
| **Cairo** | High-quality graphics output |
| **plot3D** | Multi-dimensional plotting |
| **waffle** | Waffle (square pie) charts |
| **dendextend** | Dendrogram visualization |

## Animation

| Package | Description |
|---------|-------------|
| **gganimate** ★ | Animate ggplot2 plots |
| **animation** | Animated graphics with ImageMagick |

## Fonts & Styling

| Package | Description |
|---------|-------------|
| **extrafont** | Use system fonts |
| **showtext** | Enable system fonts in graphics |
| **xkcd** | XKCD style graphics |

## HTML Widgets (Interactive)

| Package | Description |
|---------|-------------|
| **plotly** ★ | Interactive ggplot2/Shiny plots |
| **DT** ★ | Interactive data tables |
| **leaflet** ★ | Interactive maps |
| **DiagrammeR** ★ | JS graph diagrams/flowcharts |
| **dygraphs** | Time-series charting |
| **highcharter** | Highcharts wrapper |
| **echarts4r** | ECharts wrapper |
| **visNetwork** | Network visualization (vis.js) |
| **networkD3** | D3 network graphs |
| **scatterD3** | Interactive scatterplots |
| **rbokeh** | Bokeh interface |
| **threejs** | 3D scatter plots/globes |
| **timevis** | Timeline visualizations |
| **wordcloud2** | Word clouds |
| **heatmaply** | Interactive heatmaps |
| **formattable** | Formattable data structures |
| **ggvis** | Interactive grammar of graphics |
| **rCharts** | Interactive JS charts |
| **r2d3** | D3 visualizations interface |
| **MetricsGraphics** | D3 charts |

## Quick Examples

```r
# ggplot2 basics
library(ggplot2)
ggplot(df, aes(x, y, color = group)) +
  geom_point() +
  geom_smooth(method = "lm") +
  facet_wrap(~category) +
  theme_minimal() +
  labs(title = "Title", x = "X", y = "Y")

# Combine plots
library(patchwork)
(p1 | p2) / p3

# Interactive plotly
library(plotly)
ggplotly(p)

# Interactive table
library(DT)
datatable(df, filter = "top")

# Interactive map
library(leaflet)
leaflet() %>%
  addTiles() %>%
  addMarkers(lng = 116.4, lat = 39.9)

# Animation
library(gganimate)
p + transition_time(year) +
  labs(title = "Year: {frame_time}")

# Save
ggsave("plot.png", width = 10, height = 6, dpi = 300)
```

## Resources

- ggplot2: https://ggplot2.tidyverse.org/
- ggplot2 extensions: https://exts.ggplot2.tidyverse.org/
- plotly: https://plotly.com/r/
- leaflet: https://rstudio.github.io/leaflet/
- htmlwidgets: https://www.htmlwidgets.org/
