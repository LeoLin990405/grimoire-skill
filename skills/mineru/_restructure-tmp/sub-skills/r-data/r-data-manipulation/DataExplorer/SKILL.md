---
name: DataExplorer
description: R DataExplorer package for EDA. Use for automated exploratory data analysis and reporting.
---

# DataExplorer

Automated exploratory data analysis.

## Quick Overview

```r
library(DataExplorer)

# Introduction report
introduce(df)

# Plot introduction
plot_intro(df)

# Full EDA report
create_report(df)
create_report(df, output_file = "eda_report.html")
```

## Missing Data

```r
# Profile missing values
profile_missing(df)

# Plot missing values
plot_missing(df)

# Plot missing by row
plot_missing(df, group = list(group1 = 1:5, group2 = 6:10))
```

## Data Structure

```r
# Plot data structure
plot_str(df)
plot_str(df, type = "diagonal")
plot_str(df, type = "radial")
```

## Distributions

```r
# Histograms for continuous
plot_histogram(df)
plot_histogram(df, ncol = 3)

# Density plots
plot_density(df)

# Bar plots for categorical
plot_bar(df)
plot_bar(df, with = "target_var")

# QQ plots
plot_qq(df)
plot_qq(df, by = "group")
```

## Correlations

```r
# Correlation matrix
plot_correlation(df)
plot_correlation(df, type = "continuous")
plot_correlation(df, type = "discrete")

# Correlation with target
plot_correlation(df, cor_args = list(use = "pairwise.complete.obs"))
```

## Feature Analysis

```r
# Box plots
plot_boxplot(df, by = "target")

# Scatter plots
plot_scatterplot(df, by = "target")

# PCA
plot_prcomp(df)
plot_prcomp(df, variance_cap = 0.9)
```

## Data Transformation

```r
# Drop columns
df_clean <- drop_columns(df, c("col1", "col2"))

# Set missing values
df_clean <- set_missing(df, list(col1 = 0, col2 = "Unknown"))

# Group sparse categories
df_clean <- group_category(df, feature = "category", threshold = 0.1)

# Dummify categorical
df_dummy <- dummify(df)
df_dummy <- dummify(df, select = c("cat1", "cat2"))

# Update columns
df_updated <- update_columns(df, c("col1", "col2"), as.factor)
```

## Automated Report

```r
# Full report with all plots
create_report(
  df,
  output_file = "report.html",
  output_dir = "./reports/",
  y = "target",  # Target variable
  config = configure_report(
    add_plot_str = TRUE,
    add_plot_qq = TRUE,
    add_plot_prcomp = TRUE,
    add_plot_boxplot = TRUE,
    add_plot_scatterplot = TRUE
  )
)
```

## Configuration

```r
# Configure report
config <- configure_report(
  add_plot_str = TRUE,
  add_plot_qq = FALSE,
  add_plot_prcomp = TRUE,
  add_plot_boxplot = TRUE,
  add_plot_scatterplot = FALSE,
  global_ggtheme = quote(theme_minimal())
)

create_report(df, config = config)
```

## Split Data

```r
# Split by feature
split_columns(df, by = "type")

# Split by missing
split_columns(df, by = "missing")
```
