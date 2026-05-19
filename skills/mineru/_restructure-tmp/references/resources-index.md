# R Resources Index

## Official Documentation

| Resource | URL | Description |
|----------|-----|-------------|
| CRAN Manuals | https://cran.r-project.org/manuals.html | Official R manuals |
| R Language Definition | https://cran.r-project.org/doc/manuals/r-release/R-lang.html | Language specification |
| Writing R Extensions | https://cran.r-project.org/doc/manuals/r-release/R-exts.html | Package development |
| R Data Import/Export | https://cran.r-project.org/doc/manuals/r-release/R-data.html | Data I/O guide |
| Modern R Manuals | https://rstudio.github.io/r-manuals/ | Quarto version |

## Search & Reference

| Resource | URL | Description |
|----------|-----|-------------|
| RDocumentation | https://www.rdocumentation.org/ | Function search engine |
| rdrr.io | https://rdrr.io/ | CRAN/Bioconductor search |
| RSeek | https://rseek.org/ | R-specific Google search |
| DevDocs | https://devdocs.io/r/ | Clean documentation interface |

## Ecosystems

| Resource | URL | Description |
|----------|-----|-------------|
| Tidyverse | https://www.tidyverse.org/ | Data science packages |
| Bioconductor | https://www.bioconductor.org/ | Bioinformatics packages |
| Posit Docs | https://docs.posit.co/ | RStudio/Posit documentation |

## Free Online Books

| Book | URL | Topics |
|------|-----|--------|
| R for Data Science (2e) | https://r4ds.hadley.nz/ | Tidyverse, data analysis |
| Advanced R (2e) | https://adv-r.hadley.nz/ | Deep R programming |
| R Graphics Cookbook | https://r-graphics.org/ | ggplot2 recipes |
| Happy Git with R | https://happygitwithr.com/ | Git/GitHub for R |
| R Packages (2e) | https://r-pkgs.org/ | Package development |
| Bookdown Library | https://bookdown.org/ | Collection of R books |

## Cheat Sheets (Posit)

Download from: https://posit.co/resources/cheatsheets/

| Topic | Key Content |
|-------|-------------|
| **Data Visualization** | ggplot2 geoms, aesthetics, scales |
| **Data Transformation** | dplyr verbs, joins, grouping |
| **Data Tidying** | tidyr pivoting, separating |
| **String Manipulation** | stringr functions, regex |
| **Date/Time** | lubridate parsing, arithmetic |
| **Factors** | forcats reordering, recoding |
| **Iteration** | purrr map functions |
| **R Markdown** | Document formatting, chunks |
| **Shiny** | UI components, server logic |
| **Package Development** | devtools workflow |

Available in 16+ languages including Chinese.

## Community

| Resource | URL | Description |
|----------|-----|-------------|
| Stack Overflow | https://stackoverflow.com/questions/tagged/r | Q&A |
| R-bloggers | https://www.r-bloggers.com/ | Daily R news |
| RStudio Community | https://forum.posit.co/ | Posit forums |
| Twitter/X | #rstats | R community hashtag |

## Getting Help in R

```r
# Function help
?function_name
help(function_name)

# Search help
??keyword
help.search("keyword")

# Package vignettes
vignette("vignette_name", package = "pkg")
browseVignettes("package_name")

# Package documentation
help(package = "dplyr")

# Demo
demo(package = "graphics")
example(plot)
```

## Reproducible Examples

```r
# Create minimal reproducible example
library(reprex)
reprex({
  library(dplyr)
  mtcars |> filter(mpg > 20) |> head()
})

# Session info for bug reports
sessionInfo()
# Or more detailed:
devtools::session_info()
```
