# R for Data Science (2e) Quick Reference

Based on "R for Data Science" by Hadley Wickham, Mine Çetinkaya-Rundel, and Garrett Grolemund.
Book URL: https://r4ds.hadley.nz/

## 1. Data Visualization (ggplot2)

### Core Structure
```r
ggplot(data, aes(x = var1, y = var2)) +
  geom_*() +
  labs() +
  theme_*()
```

### Aesthetic Mappings
- **Inside `aes()`**: Map data to visual properties (varies by data)
- **Outside `aes()`**: Set fixed visual properties

```r
# Mapping (color varies by species)
ggplot(df, aes(x = x, y = y, color = species)) + geom_point()

# Setting (all points blue)
ggplot(df, aes(x = x, y = y)) + geom_point(color = "blue")
```

### Common Geoms
| Geom | Use Case |
|------|----------|
| `geom_point()` | Scatter plots |
| `geom_line()` | Line charts |
| `geom_bar()` | Bar charts (categorical) |
| `geom_histogram()` | Distributions (numeric) |
| `geom_boxplot()` | Box plots |
| `geom_density()` | Density curves |
| `geom_smooth()` | Trend lines |

### Faceting
```r
+ facet_wrap(~variable)           # Single variable
+ facet_grid(row_var ~ col_var)   # Two variables
```

### Save Plots
```r
ggsave("plot.png", width = 10, height = 6, dpi = 300)
```

## 2. Data Transformation (dplyr)

### The Pipe `|>`
```r
df |> filter(...) |> select(...) |> mutate(...)
```

### Row Operations
```r
filter(condition)      # Keep rows matching condition
arrange(col)           # Sort rows (use desc() for descending)
distinct(col)          # Unique rows
slice_head(n = 5)      # First n rows
slice_max(col, n = 5)  # Top n by column value
```

### Column Operations
```r
select(col1, col2)           # Keep columns
select(starts_with("x"))     # Helper functions
mutate(new = col1 + col2)    # Create/modify columns
rename(new_name = old_name)  # Rename columns
relocate(col, .before = x)   # Move columns
```

### Grouping & Summarizing
```r
df |>
  group_by(category) |>
  summarize(
    mean_val = mean(value),
    count = n()
  )

# Per-operation grouping (alternative)
df |> summarize(mean = mean(x), .by = category)
```

## 3. Data Tidying (tidyr)

### Tidy Data Principles
1. Each variable is a column
2. Each observation is a row
3. Each value is a cell

### Pivoting
```r
# Wide to long
pivot_longer(
  cols = col1:col3,
  names_to = "name_column",
  values_to = "value_column"
)

# Long to wide
pivot_wider(
  names_from = name_column,
  values_from = value_column
)
```

## 4. Data Import (readr)

### Reading Files
```r
read_csv("file.csv")                    # CSV
read_csv("file.csv", na = c("", "NA"))  # Specify NA values
read_csv("file.csv", skip = 2)          # Skip header rows
read_tsv("file.tsv")                    # Tab-separated
read_delim("file.txt", delim = "|")     # Custom delimiter
```

### Multiple Files
```r
files <- list.files("data/", pattern = "\\.csv$", full.names = TRUE)
df <- read_csv(files, id = "source_file")
```

### Clean Column Names
```r
df |> janitor::clean_names()
```

### Save Data
```r
write_csv(df, "output.csv")
write_rds(df, "output.rds")      # Preserves types
arrow::write_parquet(df, "output.parquet")  # Fast, cross-language
```

## 5. Joins

### Mutating Joins
```r
left_join(x, y, join_by(key))   # Keep all rows from x
inner_join(x, y, join_by(key))  # Keep only matching rows
right_join(x, y, join_by(key))  # Keep all rows from y
full_join(x, y, join_by(key))   # Keep all rows from both
```

### Filtering Joins
```r
semi_join(x, y)   # Rows in x with match in y
anti_join(x, y)   # Rows in x without match in y
```

### Different Column Names
```r
left_join(x, y, join_by(x_col == y_col))
```

## 6. Strings (stringr)

### Basic Operations
```r
str_length(x)              # Character count
str_c(a, b, sep = "-")     # Concatenate
str_glue("Hello {name}")   # Interpolation
str_sub(x, 1, 3)           # Substring
str_to_upper(x)            # Case conversion
str_to_lower(x)
```

### Pattern Matching
```r
str_detect(x, pattern)     # TRUE/FALSE
str_count(x, pattern)      # Count matches
str_replace(x, pattern, replacement)
str_replace_all(x, pattern, replacement)
str_extract(x, pattern)    # Extract first match
str_extract_all(x, pattern)
```

### Separating Strings
```r
separate_wider_delim(col, delim = "-", names = c("a", "b"))
separate_longer_delim(col, delim = ",")
```

## 7. Factors (forcats)

### Creating Factors
```r
factor(x, levels = c("low", "medium", "high"))
fct(x, levels = c("low", "medium", "high"))  # Stricter
```

### Reordering
```r
fct_reorder(f, x)      # By another variable
fct_infreq(f)          # By frequency
fct_rev(f)             # Reverse order
fct_relevel(f, "first") # Move level to front
```

### Modifying Levels
```r
fct_recode(f, new = "old")
fct_collapse(f, group = c("a", "b"))
fct_lump_n(f, n = 5)   # Keep top n, lump rest
```

## 8. Dates & Times (lubridate)

### Parsing
```r
ymd("2024-01-15")
mdy("01/15/2024")
dmy("15-01-2024")
ymd_hms("2024-01-15 10:30:00")
```

### Components
```r
year(x)    month(x)   day(x)
hour(x)    minute(x)  second(x)
wday(x)    # Day of week
```

### Arithmetic
```r
x + days(1)
x + months(1)
interval(start, end) / days(1)  # Duration in days
```

## 9. Functions

### Basic Syntax
```r
my_function <- function(arg1, arg2 = default) {
  # body
  result
}
```

### Tidy Evaluation (Embracing)
```r
# For dplyr/tidyverse functions
my_summary <- function(df, group_var, value_var) {
  df |>
    group_by({{ group_var }}) |>
    summarize(mean = mean({{ value_var }}))
}
```

## 10. Iteration

### across() for Multiple Columns
```r
df |> summarize(across(where(is.numeric), mean))
df |> mutate(across(c(a, b), \(x) x * 2))
```

### map() for Lists
```r
map(list, function)           # Returns list
map_dbl(list, function)       # Returns numeric vector
map_chr(list, function)       # Returns character vector
map2(list1, list2, function)  # Two inputs
walk(list, function)          # Side effects only
```

### Reading Multiple Files
```r
files <- list.files("data/", pattern = "\\.csv$", full.names = TRUE)
df_list <- map(files, read_csv)
df <- list_rbind(df_list)
```
