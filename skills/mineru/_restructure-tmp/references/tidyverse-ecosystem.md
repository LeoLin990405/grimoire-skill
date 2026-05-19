# Tidyverse Ecosystem Reference

Official site: https://www.tidyverse.org/

## Core Packages

Loaded with `library(tidyverse)`:

| Package | Purpose | Key Functions |
|---------|---------|---------------|
| **ggplot2** | Visualization | `ggplot()`, `aes()`, `geom_*()` |
| **dplyr** | Data manipulation | `filter()`, `select()`, `mutate()`, `summarize()` |
| **tidyr** | Data tidying | `pivot_longer()`, `pivot_wider()`, `separate()` |
| **readr** | Read rectangular data | `read_csv()`, `read_tsv()`, `write_csv()` |
| **purrr** | Functional programming | `map()`, `map2()`, `reduce()`, `walk()` |
| **tibble** | Modern data frames | `tibble()`, `as_tibble()`, `tribble()` |
| **stringr** | String manipulation | `str_detect()`, `str_replace()`, `str_extract()` |
| **forcats** | Factor handling | `fct_reorder()`, `fct_recode()`, `fct_lump()` |
| **lubridate** | Date-time handling | `ymd()`, `year()`, `month()`, `floor_date()` |

## Import Packages

```r
# Excel
library(readxl)
read_excel("file.xlsx", sheet = 1)

# SPSS, Stata, SAS
library(haven)
read_sav("file.sav")   # SPSS
read_dta("file.dta")   # Stata
read_sas("file.sas7bdat")  # SAS

# JSON
library(jsonlite)
fromJSON("file.json")
toJSON(df)

# Web scraping
library(rvest)
read_html(url) |> html_elements("table") |> html_table()

# Google Sheets
library(googlesheets4)
read_sheet("sheet_id")

# Databases
library(DBI)
con <- dbConnect(RSQLite::SQLite(), "database.db")
dbGetQuery(con, "SELECT * FROM table")
```

## dplyr Backends

```r
# SQL databases
library(dbplyr)
tbl(con, "table") |> filter(x > 10) |> collect()

# data.table (faster)
library(dtplyr)
lazy_dt(df) |> filter(x > 10) |> as_tibble()

# DuckDB (analytical)
library(duckplyr)
df |> as_duckplyr_df() |> summarize(mean(x))
```

## Modeling (tidymodels)

```r
library(tidymodels)

# Workflow
model_spec <- linear_reg() |> set_engine("lm")
recipe <- recipe(y ~ ., data = train) |> step_normalize(all_numeric())
workflow <- workflow() |> add_model(model_spec) |> add_recipe(recipe)
fit <- workflow |> fit(data = train)
predict(fit, new_data = test)
```

## Pipe Operators

```r
# Native pipe (R 4.1+)
df |> filter(x > 10) |> select(y)

# magrittr pipe
library(magrittr)
df %>% filter(x > 10) %>% select(y)

# Placeholder
df |> lm(y ~ x, data = _)      # Native (R 4.2+)
df %>% lm(y ~ x, data = .)     # magrittr
```

## String Interpolation (glue)

```r
library(glue)

name <- "World"
glue("Hello, {name}!")

# In data frames
df |> mutate(label = glue("{name}: {value}"))

# Multi-line
glue("
  Name: {name}
  Value: {value}
")
```

## Reproducible Examples (reprex)

```r
library(reprex)

# Copy code to clipboard, then:
reprex()

# Or directly:
reprex({
  library(dplyr)
  mtcars |> filter(mpg > 20)
})
```

## Common Patterns

### Read Multiple Files
```r
files <- list.files("data/", pattern = "\\.csv$", full.names = TRUE)
df <- map(files, read_csv) |> list_rbind()
```

### Nested Data
```r
# Nest
df |> nest(data = -group)

# Unnest
df |> unnest(data)

# Map over nested data
df |>
  nest(data = -group) |>
  mutate(model = map(data, \(d) lm(y ~ x, data = d))) |>
  mutate(coef = map(model, broom::tidy)) |>
  unnest(coef)
```

### Rowwise Operations
```r
df |>
  rowwise() |>
  mutate(total = sum(c_across(x:z))) |>
  ungroup()
```

### Conditional Mutate
```r
df |> mutate(
  category = case_when(
    x < 10 ~ "low",
    x < 50 ~ "medium",
    TRUE ~ "high"
  )
)

df |> mutate(
  y = if_else(x > 0, log(x), NA_real_)
)
```
