# R4DS - Part IV: Import & Join

Based on "R for Data Science" (2e) by Hadley Wickham et al.
Book URL: https://r4ds.hadley.nz/

## Reading Files (readr)

### CSV Files
```r
library(readr)

read_csv("file.csv")
read_csv("file.csv", na = c("", "NA", "N/A"))
read_csv("file.csv", skip = 2)           # Skip header rows
read_csv("file.csv", comment = "#")      # Ignore comment lines
read_csv("file.csv", col_names = FALSE)  # No header
read_csv("file.csv", col_names = c("a", "b", "c"))
```

### Column Types
```r
# Explicit types
read_csv("file.csv", col_types = cols(
  x = col_double(),
  y = col_character(),
  z = col_date(format = "%Y-%m-%d")
))

# Type shortcuts
read_csv("file.csv", col_types = "dci")  # double, character, integer

# Available types
col_logical()      # l
col_integer()      # i
col_double()       # d
col_character()    # c
col_factor()       # f
col_date()         # D
col_datetime()     # T
col_time()         # t
col_skip()         # _ or -
col_guess()        # ?
```

### Other Delimiters
```r
read_tsv("file.tsv")                     # Tab-separated
read_delim("file.txt", delim = "|")      # Custom delimiter
read_fwf("file.txt", fwf_widths(c(5, 10, 3)))  # Fixed width
```

### Multiple Files
```r
files <- list.files("data/", pattern = "\\.csv$", full.names = TRUE)
df <- read_csv(files, id = "source_file")
```

### Clean Column Names
```r
df |> janitor::clean_names()  # snake_case
```

## Excel Files (readxl)

```r
library(readxl)

read_excel("file.xlsx")
read_excel("file.xlsx", sheet = "Sheet2")
read_excel("file.xlsx", sheet = 2)
read_excel("file.xlsx", range = "A1:D10")
read_excel("file.xlsx", skip = 2)
read_excel("file.xlsx", na = c("", "NA"))

excel_sheets("file.xlsx")  # List sheet names
```

## Writing Files

```r
# CSV
write_csv(df, "output.csv")
write_csv(df, "output.csv", na = "")

# Excel
library(openxlsx)
write.xlsx(df, "output.xlsx")

# R binary (preserves types)
write_rds(df, "output.rds")
df <- read_rds("output.rds")

# Parquet (fast, cross-language)
library(arrow)
write_parquet(df, "output.parquet")
df <- read_parquet("output.parquet")
```

## Joins

### Mutating Joins
Add columns from another table.

```r
# Keep all rows from x
left_join(x, y, join_by(key))

# Keep only matching rows
inner_join(x, y, join_by(key))

# Keep all rows from y
right_join(x, y, join_by(key))

# Keep all rows from both
full_join(x, y, join_by(key))
```

### Join Keys
```r
# Same column name
join_by(id)
join_by(id, date)

# Different column names
join_by(x_id == y_id)

# Multiple conditions
join_by(id, x_date == y_date)
```

### Filtering Joins
Filter rows based on another table.

```r
# Keep rows in x with match in y
semi_join(x, y, join_by(key))

# Keep rows in x without match in y
anti_join(x, y, join_by(key))
```

### Non-Equi Joins
```r
# Inequality joins
join_by(x >= y_start, x <= y_end)

# Closest match (rolling join)
join_by(closest(x >= y))

# Overlap joins
join_by(overlaps(x_start, x_end, y_start, y_end))
join_by(within(x_start, x_end, y_start, y_end))
```

### Cross Join
```r
cross_join(x, y)  # All combinations
```

### Handling Duplicates
```r
# Check for duplicates
df |> count(key) |> filter(n > 1)

# Multiple matches warning
relationship = "many-to-one"
relationship = "one-to-many"
relationship = "many-to-many"
```

## Binding Rows/Columns

```r
# Stack rows
bind_rows(df1, df2)
bind_rows(df1, df2, .id = "source")

# Add columns
bind_cols(df1, df2)
```

## Set Operations

```r
intersect(x, y)  # Rows in both
union(x, y)      # Rows in either
setdiff(x, y)    # Rows in x but not y
```
