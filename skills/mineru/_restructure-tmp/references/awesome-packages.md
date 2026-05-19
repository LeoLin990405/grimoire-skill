# Awesome R Packages Reference

Curated from [awesome-R](https://github.com/qinwf/awesome-R). Packages marked ★ are highly recommended.

## IDEs & Editors

| Package | Description |
|---------|-------------|
| RStudio ★ | Powerful IDE for R |
| VSCode + vscode-R | R language support for VS Code |
| IRkernel | R kernel for Jupyter |
| radian ★ | Modern R console with syntax highlighting |
| Nvim-R | Neovim plugin for R |

## Data Manipulation

| Package | Description |
|---------|-------------|
| dplyr ★ | Fast data frames manipulation |
| data.table ★ | Fast manipulation with concise syntax |
| tidyr | Tidy messy data |
| reshape2 | Flexible reshape and aggregate |
| broom ★ | Convert models to tidy data frames |
| stringr ★ | Consistent string processing |
| stringi | ICU-based string processing |

## Data Formats

| Package | Description |
|---------|-------------|
| arrow ★ | Interface to Apache Arrow |
| fst ★ | Lightning fast data frame serialization |
| feather | Fast binary data frame storage |
| readr ★ | Fast tabular data reading |
| readxl ★ | Read Excel files |
| haven | Read SPSS, Stata, SAS |
| jsonlite | JSON parsing |

## Visualization

| Package | Description |
|---------|-------------|
| ggplot2 ★ | Grammar of Graphics |
| plotly ★ | Interactive plots |
| rCharts | Interactive JS charts |
| lattice | Trellis graphics |
| ggvis | Interactive grammar of graphics |
| patchwork ★ | Combine ggplot2 plots |

## HTML Widgets

| Package | Description |
|---------|-------------|
| DiagrammeR ★ | JS graph diagrams and flowcharts |
| formattable | Formattable data structures |
| DT ★ | Interactive data tables |
| leaflet ★ | Interactive maps |
| dygraphs | Time series charting |

## Web Technologies

| Package | Description |
|---------|-------------|
| shiny ★ | Interactive web applications |
| httr / httr2 ★ | HTTP requests |
| rvest ★ | Web scraping |
| xml2 | XML parsing |
| plumber | REST API from R functions |
| OpenCPU | HTTP API for R |

## Reproducible Research

| Package | Description |
|---------|-------------|
| knitr ★ | Dynamic report generation |
| rmarkdown ★ | Dynamic documents |
| quarto ★ | Next-gen scientific publishing |
| bookdown | Books and technical documents |
| xaringan | Presentations with remark.js |

## Machine Learning

| Package | Description |
|---------|-------------|
| caret ★ | Classification and regression training |
| mlr3 ★ | Next-gen ML framework |
| tidymodels ★ | Tidyverse-friendly modeling |
| xgboost ★ | Gradient boosting |
| lightgbm ★ | Light gradient boosting |
| h2o | Deep learning, RF, GBM |
| glmnet ★ | Lasso and elastic-net |
| ranger | Fast random forests |
| keras / tensorflow | Deep learning |

## Time Series & Forecasting

| Package | Description |
|---------|-------------|
| prophet ★ | Facebook's forecasting tool |
| forecast ★ | Time series forecasting |
| zoo ★ | Regular/irregular time series |
| xts | Extensible time series |
| tsibble | Tidy temporal data |
| fable | Tidy forecasting |

## Bayesian

| Package | Description |
|---------|-------------|
| rstan ★ | Interface to Stan MCMC |
| brms ★ | Bayesian regression models |
| rstanarm | Bayesian applied regression |

## NLP & Text

| Package | Description |
|---------|-------------|
| tidytext ★ | Tidy text mining |
| quanteda | Quantitative text analysis |
| text2vec | Text vectorization |
| tm | Text mining framework |

## Spatial

| Package | Description |
|---------|-------------|
| sf ★ | Simple features for R |
| terra | Spatial data analysis |
| tmap | Thematic maps |
| rgdal | Geospatial data abstraction |

## Network Analysis

| Package | Description |
|---------|-------------|
| igraph ★ | Network analysis tools |
| tidygraph | Tidy API for graph/network |
| ggraph | Grammar of graphics for graphs |
| visNetwork | Interactive network visualization |

## Finance

| Package | Description |
|---------|-------------|
| quantmod ★ | Quantitative financial modeling |
| PerformanceAnalytics | Performance and risk analysis |
| TTR | Technical trading rules |
| tidyquant | Tidy quantitative analysis |

## Parallel & Performance

| Package | Description |
|---------|-------------|
| Rcpp ★ | C++ integration |
| future ★ | Unified parallel/distributed API |
| foreach | Parallel loops |
| furrr | future + purrr |
| parallel | Built-in parallel support |
| SparkR / sparklyr | Spark integration |

## Development

| Package | Description |
|---------|-------------|
| devtools ★ | Package development tools |
| testthat ★ | Unit testing |
| usethis ★ | Workflow automation |
| roxygen2 ★ | Documentation from comments |
| renv ★ | Project environments |
| R6 ★ | Encapsulated OOP |
| pkgdown | Package websites |
| lintr | Static code analysis |

## Database

| Package | Description |
|---------|-------------|
| DBI ★ | Database interface |
| dbplyr ★ | dplyr for databases |
| RSQLite | SQLite interface |
| RPostgres | PostgreSQL interface |
| RMySQL | MySQL interface |
| odbc | ODBC interface |

## Language Interfaces

| Package | Description |
|---------|-------------|
| reticulate ★ | Python interface |
| JuliaCall | Julia interface |
| V8 | JavaScript engine |

## Learning Resources

| Resource | Description |
|----------|-------------|
| swirl ★ | Interactive R tutorials in console |
| learnr | Interactive tutorials |
| DataScienceR | R tutorials collection |

## Installation Patterns

```r
# Install multiple packages
install.packages(c("tidyverse", "data.table", "xgboost"))

# GitHub packages
remotes::install_github("user/repo")

# Bioconductor
BiocManager::install("package")
```
