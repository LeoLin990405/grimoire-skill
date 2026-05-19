---
name: ggstatsplot
description: R ggstatsplot package for statistical plots. Use for publication-ready plots with statistical details.
---

# ggstatsplot

ggplot2-based plots with statistical details.

## Scatter Plot with Statistics

```r
library(ggstatsplot)

# Scatter with correlation
ggscatterstats(
  data = mtcars,
  x = wt,
  y = mpg
)

# With grouping
grouped_ggscatterstats(
  data = mtcars,
  x = wt,
  y = mpg,
  grouping.var = cyl
)
```

## Box/Violin Plots

```r
# Between-subjects comparison
ggbetweenstats(
  data = iris,
  x = Species,
  y = Sepal.Length
)

# Violin plot
ggbetweenstats(
  data = iris,
  x = Species,
  y = Sepal.Length,
  type = "nonparametric",
  plot.type = "violin"
)

# Paired/within-subjects
ggwithinstats(
  data = df,
  x = condition,
  y = score,
  subject.id = subject
)
```

## Bar Plots

```r
# Proportion test
ggbarstats(
  data = mtcars,
  x = am,
  y = cyl
)

# Pie chart
ggpiestats(
  data = mtcars,
  x = cyl
)
```

## Histogram

```r
# With distribution fit
gghistostats(
  data = mtcars,
  x = mpg,
  binwidth = 2
)

# Density plot
gghistostats(
  data = mtcars,
  x = mpg,
  type = "nonparametric"
)
```

## Dot Plot

```r
# Dot plot with statistics
ggdotplotstats(
  data = df,
  x = value,
  y = category
)
```

## Correlation Matrix

```r
# Correlation plot
ggcorrmat(
  data = mtcars,
  cor.vars = c(mpg, disp, hp, wt)
)

# With specific method
ggcorrmat(
  data = mtcars,
  type = "nonparametric",  # Spearman
  cor.vars = c(mpg, disp, hp, wt)
)
```

## Covariance Plot

```r
# Covariance matrix
ggcorrmat(
  data = mtcars,
  cor.vars = c(mpg, disp, hp),
  matrix.type = "upper",
  type = "parametric"
)
```

## Statistical Test Types

```r
# Parametric (default)
ggbetweenstats(data = df, x = group, y = value, type = "parametric")

# Non-parametric
ggbetweenstats(data = df, x = group, y = value, type = "nonparametric")

# Robust
ggbetweenstats(data = df, x = group, y = value, type = "robust")

# Bayesian
ggbetweenstats(data = df, x = group, y = value, type = "bayes")
```

## Customization

```r
# Custom colors
ggbetweenstats(
  data = iris,
  x = Species,
  y = Sepal.Length,
  palette = "Set2"
)

# Custom labels
ggbetweenstats(
  data = iris,
  x = Species,
  y = Sepal.Length,
  xlab = "Iris Species",
  ylab = "Sepal Length (cm)",
  title = "Comparison of Sepal Length"
)

# Pairwise comparisons
ggbetweenstats(
  data = iris,
  x = Species,
  y = Sepal.Length,
  pairwise.comparisons = TRUE,
  pairwise.display = "significant"
)
```

## Effect Sizes

```r
# Show effect size
ggbetweenstats(
  data = iris,
  x = Species,
  y = Sepal.Length,
  effsize.type = "eta"  # eta, omega, epsilon
)
```

## Grouped Plots

```r
# Grouped scatter
grouped_ggscatterstats(
  data = mtcars,
  x = wt,
  y = mpg,
  grouping.var = cyl,
  plotgrid.args = list(ncol = 2)
)

# Grouped box plots
grouped_ggbetweenstats(
  data = mtcars,
  x = am,
  y = mpg,
  grouping.var = cyl
)
```

## Extract Statistics

```r
# Get statistical results
result <- ggbetweenstats(data = iris, x = Species, y = Sepal.Length)

# Extract stats
extract_stats(result)
extract_subtitle(result)
```

## Combine Plots

```r
# Using patchwork
library(patchwork)

p1 <- ggbetweenstats(data = iris, x = Species, y = Sepal.Length)
p2 <- ggbetweenstats(data = iris, x = Species, y = Sepal.Width)

p1 + p2
```
