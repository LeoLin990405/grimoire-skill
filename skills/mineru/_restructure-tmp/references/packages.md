# R Packages Reference

## Data Manipulation

### tidyverse
Meta-package including: ggplot2, dplyr, tidyr, readr, purrr, tibble, stringr, forcats

```r
install.packages("tidyverse")
library(tidyverse)
```

### dplyr - Data Manipulation
```r
# Core verbs
filter()    # subset rows
select()    # subset columns
mutate()    # create/modify columns
arrange()   # sort rows
summarise() # aggregate
group_by()  # group operations
join()      # merge datasets (left_join, inner_join, etc.)
```

### data.table - Fast Data Manipulation
```r
library(data.table)
dt <- data.table(df)
dt[i, j, by]  # i=rows, j=columns, by=group
dt[x > 5, .(mean_y = mean(y)), by = group]
```

## Visualization

### ggplot2 - Grammar of Graphics
```r
# Structure: ggplot(data, aes()) + geom_*() + theme_*()

# Geoms
geom_point()     # scatter
geom_line()      # line
geom_bar()       # bar
geom_histogram() # histogram
geom_boxplot()   # boxplot
geom_smooth()    # trend line

# Themes
theme_minimal()
theme_bw()
theme_classic()
```

### plotly - Interactive Plots
```r
library(plotly)
p <- ggplot(df, aes(x, y)) + geom_point()
ggplotly(p)  # convert ggplot to interactive

# Native plotly
plot_ly(df, x = ~x, y = ~y, type = "scatter", mode = "markers")
```

## Statistical Analysis

### stats (base R)
```r
lm()        # linear regression
glm()       # generalized linear model
t.test()    # t-test
aov()       # ANOVA
cor()       # correlation
chisq.test() # chi-square test
```

### Common Statistical Packages
| Package | Purpose |
|---------|---------|
| lme4 | Mixed-effects models |
| survival | Survival analysis |
| caret | Machine learning |
| randomForest | Random forest |
| xgboost | Gradient boosting |

## I/O

### Reading Data
```r
# CSV
read.csv()           # base R
readr::read_csv()    # fast, tibble

# Excel
readxl::read_excel()
openxlsx::read.xlsx()

# JSON
jsonlite::fromJSON()

# Database
DBI::dbConnect()
DBI::dbGetQuery()
```

### Writing Data
```r
write.csv(df, "file.csv", row.names = FALSE)
readr::write_csv(df, "file.csv")
openxlsx::write.xlsx(df, "file.xlsx")
jsonlite::toJSON(df)
```
