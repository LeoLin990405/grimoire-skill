---
name: r-resources
description: R learning resources. Use for finding books, courses, tutorials, cheat sheets, podcasts, and community resources.
---

# R Learning Resources Skill

## Sub-skills

| Sub-skill | Description |
|-----------|-------------|
| [r-resources-books](r-resources-books/SKILL.md) | Free online books, references |
| [r-resources-courses](r-resources-courses/SKILL.md) | MOOCs, tutorials, interactive learning |
| [r-resources-community](r-resources-community/SKILL.md) | Forums, conferences, user groups |

Books, courses, tutorials, and community resources for R.

## Official Documentation

| Resource | URL |
|----------|-----|
| R Project | https://www.r-project.org/ |
| CRAN Manuals | https://cran.r-project.org/manuals.html |
| CRAN Task Views | https://cran.r-project.org/web/views/ |
| R Introduction | https://cran.r-project.org/doc/manuals/R-intro.pdf |

## Search & Reference

| Resource | URL |
|----------|-----|
| RDocumentation | https://www.rdocumentation.org/ |
| rdrr.io | https://rdrr.io/ |
| Quick-R | http://www.statmethods.net/ |
| DevDocs R | https://devdocs.io/r/ |

## Free Online Books

| Book | URL | Topics |
|------|-----|--------|
| R for Data Science (2e) | https://r4ds.hadley.nz/ | Tidyverse, data science |
| Advanced R (2e) | https://adv-r.hadley.nz/ | Deep R programming |
| R Packages (2e) | https://r-pkgs.org/ | Package development |
| R Graphics Cookbook | https://r-graphics.org/ | ggplot2 recipes |
| Efficient R Programming | https://csgillespie.github.io/efficientR/ | Performance |
| Geocomputation with R | https://geocompr.robinlovelace.net/ | Spatial analysis |
| Text Mining with R | https://www.tidytextmining.com/ | NLP |
| Mastering Shiny | https://mastering-shiny.org/ | Shiny apps |
| R Cookbook | http://www.cookbook-r.com/ | Problem-oriented |
| ISLR | https://www.statlearning.com/ | Statistical learning |
| The R Inferno | http://www.burns-stat.com/pages/Tutor/R_inferno.pdf | R quirks |

## Paid Books

| Book | Publisher |
|------|-----------|
| The Art of R Programming | O'Reilly |
| R Cookbook (2e) | O'Reilly |
| R in Action | Manning |
| Use R! Series | Springer |

## Cheat Sheets

Download from: https://posit.co/resources/cheatsheets/

| Topic | Content |
|-------|---------|
| Data Visualization | ggplot2 |
| Data Transformation | dplyr |
| Data Tidying | tidyr |
| String Manipulation | stringr |
| Date/Time | lubridate |
| Factors | forcats |
| Iteration | purrr |
| R Markdown | Documents |
| Shiny | Web apps |

## MOOCs & Courses

| Course | Platform |
|--------|----------|
| Johns Hopkins Data Science | Coursera |
| HarvardX Biomedical Data Science | edX |
| Explore Statistics with R | edX |
| DataCamp R courses | DataCamp |

## Podcasts

| Podcast | URL |
|---------|-----|
| Not So Standard Deviations | https://nssdeviations.com/ |
| The R-Podcast | https://r-podcast.org/ |
| R Weekly Highlights | https://rweekly.org |

## News & Community

| Resource | URL |
|----------|-----|
| R Weekly | https://rweekly.org |
| R-bloggers | https://www.r-bloggers.com/ |
| RStudio Community | https://forum.posit.co/ |
| Stack Overflow [r] | https://stackoverflow.com/questions/tagged/r |
| Twitter #rstats | https://twitter.com/hashtag/rstats |
| R-users Jobs | https://www.r-users.com/ |

## Interactive Learning

| Resource | Description |
|----------|-------------|
| swirl | Interactive R tutorials in console |
| learnr | Interactive tutorials |
| tryR | Quick online course |
| rnotebook.io | Online R Jupyter notebooks |

## Curated Lists

| List | URL |
|------|-----|
| Awesome R | https://github.com/qinwf/awesome-R |
| RStartHere | https://github.com/rstudio/RStartHere |
| R Books List | https://github.com/RomanTsegelskyi/rbooks |
| ggplot2 Extensions | https://exts.ggplot2.tidyverse.org/ |
| RStudio Addins | https://github.com/daattali/addinslist |

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

# Examples
example(plot)
demo(package = "graphics")

# Session info (for bug reports)
sessionInfo()
devtools::session_info()

# Reproducible examples
library(reprex)
reprex({
  library(dplyr)
  mtcars |> filter(mpg > 20)
})
```

## Recommended Learning Path

1. **Beginner**: R for Data Science → swirl tutorials
2. **Intermediate**: R Cookbook → Cheat sheets
3. **Advanced**: Advanced R → R Packages
4. **Specialized**: Domain-specific books (Shiny, Spatial, etc.)
