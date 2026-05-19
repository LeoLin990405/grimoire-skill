---
name: corrplot
description: R corrplot package for correlation matrix visualization. Use for creating beautiful correlation heatmaps and plots.
---

# corrplot

Graphical display of correlation matrices.

## Basic Usage

```r
library(corrplot)

# Compute correlation matrix
cor_matrix <- cor(mtcars)

# Basic plot
corrplot(cor_matrix)

# Different methods
corrplot(cor_matrix, method = "circle")   # Default
corrplot(cor_matrix, method = "square")
corrplot(cor_matrix, method = "ellipse")
corrplot(cor_matrix, method = "number")
corrplot(cor_matrix, method = "shade")
corrplot(cor_matrix, method = "color")
corrplot(cor_matrix, method = "pie")
```

## Layout Types

```r
# Full matrix
corrplot(cor_matrix, type = "full")

# Upper triangle
corrplot(cor_matrix, type = "upper")

# Lower triangle
corrplot(cor_matrix, type = "lower")
```

## Ordering

```r
# Hierarchical clustering order
corrplot(cor_matrix, order = "hclust")

# First principal component order
corrplot(cor_matrix, order = "FPC")

# Angular order of eigenvectors
corrplot(cor_matrix, order = "AOE")

# Alphabetical
corrplot(cor_matrix, order = "alphabet")

# Original order
corrplot(cor_matrix, order = "original")
```

## Clustering

```r
# Add rectangles around clusters
corrplot(cor_matrix, order = "hclust", addrect = 3)

# Customize clustering
corrplot(cor_matrix,
  order = "hclust",
  hclust.method = "ward.D2",
  addrect = 4,
  rect.col = "red"
)
```

## Color Schemes

```r
# Custom color palette
corrplot(cor_matrix, col = colorRampPalette(c("blue", "white", "red"))(200))

# COL1 and COL2 palettes
corrplot(cor_matrix, col = COL1("YlOrRd"))
corrplot(cor_matrix, col = COL2("RdBu"))

# Reverse colors
corrplot(cor_matrix, col = rev(COL2("RdBu")))
```

## Labels and Text

```r
# Add correlation coefficients
corrplot(cor_matrix, addCoef.col = "black")

# Customize text
corrplot(cor_matrix,
  addCoef.col = "black",
  number.cex = 0.7,
  number.digits = 2
)

# Text labels
corrplot(cor_matrix,
  tl.col = "black",
  tl.srt = 45,        # Rotation angle
  tl.cex = 0.8        # Text size
)
```

## Significance Testing

```r
# Compute p-values
library(Hmisc)
res <- rcorr(as.matrix(mtcars))
cor_matrix <- res$r
p_matrix <- res$P

# Show only significant correlations
corrplot(cor_matrix,
  p.mat = p_matrix,
  sig.level = 0.05,
  insig = "blank"     # Hide non-significant
)

# Mark non-significant with X
corrplot(cor_matrix,
  p.mat = p_matrix,
  sig.level = 0.05,
  insig = "pch",
  pch = "X"
)

# Show confidence intervals
corrplot(cor_matrix,
  p.mat = p_matrix,
  insig = "label_sig",
  sig.level = c(0.001, 0.01, 0.05),
  pch.cex = 0.9
)
```

## Mixed Plots

```r
# Upper and lower different methods
corrplot.mixed(cor_matrix,
  lower = "number",
  upper = "circle",
  tl.col = "black"
)

# Customize mixed
corrplot.mixed(cor_matrix,
  lower = "shade",
  upper = "pie",
  order = "hclust"
)
```

## Customization

```r
corrplot(cor_matrix,
  method = "color",
  type = "upper",
  order = "hclust",
  addCoef.col = "black",
  tl.col = "black",
  tl.srt = 45,
  diag = FALSE,       # Hide diagonal
  cl.pos = "b",       # Color legend position
  cl.ratio = 0.2,     # Color legend size
  title = "Correlation Matrix",
  mar = c(0, 0, 2, 0)
)
```

## Background and Grid

```r
corrplot(cor_matrix,
  addgrid.col = "gray",
  bg = "white",
  outline = TRUE
)
```
