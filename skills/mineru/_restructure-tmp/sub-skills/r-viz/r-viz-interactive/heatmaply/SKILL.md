---
name: heatmaply
description: R heatmaply package for interactive heatmaps. Use for creating interactive clustered heatmaps with D3.js.
---

# heatmaply

Interactive cluster heatmaps with plotly.

## Basic Heatmap

```r
library(heatmaply)

# Basic heatmap
heatmaply(mtcars)

# With scaling
heatmaply(mtcars, scale = "column")
heatmaply(mtcars, scale = "row")
heatmaply(mtcars, scale = "none")
```

## Clustering

```r
# Hierarchical clustering (default)
heatmaply(mtcars,
  distfun = "euclidean",
  hclustfun = "complete"
)

# Different distance methods
heatmaply(mtcars, distfun = "pearson")
heatmaply(mtcars, distfun = "spearman")
heatmaply(mtcars, distfun = "manhattan")

# Different clustering methods
heatmaply(mtcars, hclustfun = "ward.D2")
heatmaply(mtcars, hclustfun = "average")
heatmaply(mtcars, hclustfun = "single")

# No clustering
heatmaply(mtcars, dendrogram = "none")
heatmaply(mtcars, dendrogram = "row")
heatmaply(mtcars, dendrogram = "column")
```

## Color Scales

```r
# Viridis palettes
heatmaply(mtcars, colors = viridis::viridis(100))
heatmaply(mtcars, colors = viridis::magma(100))
heatmaply(mtcars, colors = viridis::plasma(100))

# RColorBrewer
heatmaply(mtcars, colors = RColorBrewer::brewer.pal(9, "YlOrRd"))

# Custom colors
heatmaply(mtcars, colors = colorRampPalette(c("blue", "white", "red"))(100))

# Diverging for correlation
heatmaply(cor(mtcars), colors = cool_warm)
```

## Annotations

```r
# Row annotations
row_side <- data.frame(
  Category = c(rep("A", 16), rep("B", 16)),
  row.names = rownames(mtcars)
)

heatmaply(mtcars, row_side_colors = row_side)

# Column annotations
col_side <- data.frame(
  Type = c(rep("Numeric", 5), rep("Factor", 6)),
  row.names = colnames(mtcars)
)

heatmaply(mtcars, col_side_colors = col_side)

# Both
heatmaply(mtcars,
  row_side_colors = row_side,
  col_side_colors = col_side
)
```

## Labels and Text

```r
# Show cell values
heatmaply(mtcars, cellnote = mtcars)

# Custom cell text
heatmaply(mtcars,
  cellnote = round(mtcars, 1),
  cellnote_textposition = "middle center"
)

# Label formatting
heatmaply(mtcars,
  fontsize_row = 8,
  fontsize_col = 10,
  label_names = c("Car", "Variable", "Value")
)
```

## Correlation Heatmap

```r
# Correlation matrix
cor_mat <- cor(mtcars)

heatmaply_cor(cor_mat,
  node_type = "scatter",
  point_size_mat = abs(cor_mat)
)

# With significance
library(Hmisc)
res <- rcorr(as.matrix(mtcars))

heatmaply_cor(res$r,
  node_type = "scatter",
  point_size_mat = -log10(res$P)
)
```

## Customization

```r
heatmaply(mtcars,
  main = "Motor Trend Car Data",
  xlab = "Variables",
  ylab = "Cars",
  margins = c(60, 100, 40, 20),
  grid_gap = 1,
  grid_color = "white",
  hide_colorbar = FALSE,
  branches_lwd = 0.5
)
```

## K-means Clustering

```r
# K-means instead of hierarchical
heatmaply(mtcars,
  k_row = 3,
  k_col = 2
)
```

## Seriation

```r
# Optimal leaf ordering
heatmaply(mtcars, seriate = "OLO")

# Other seriation methods
heatmaply(mtcars, seriate = "GW")
heatmaply(mtcars, seriate = "mean")
heatmaply(mtcars, seriate = "none")
```

## Export

```r
# Save as HTML
p <- heatmaply(mtcars)
htmlwidgets::saveWidget(p, "heatmap.html")

# Save as static image (requires webshot)
heatmaply(mtcars, file = "heatmap.png")
```

## With Shiny

```r
# In Shiny UI
heatmaplyOutput("heatmap")

# In Shiny server
output$heatmap <- renderHeatmaply({
  heatmaply(data())
})
```
