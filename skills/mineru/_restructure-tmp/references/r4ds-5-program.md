# R4DS - Part V: Program (Functions & Iteration)

Based on "R for Data Science" (2e) by Hadley Wickham et al.
Book URL: https://r4ds.hadley.nz/

## Functions

### Basic Syntax
```r
my_function <- function(arg1, arg2 = default) {
  # body
  result  # Last expression is returned
}
```

### When to Write Functions
Write a function when you've copied code more than twice.

### Function Style
```r
# Good: verb names, clear arguments
rescale01 <- function(x) {
  (x - min(x)) / (max(x) - min(x))
}

# Return early for special cases
mean_ci <- function(x, conf = 0.95) {
  if (length(x) == 0) return(NULL)
  # ... rest of function
}
```

### Tidy Evaluation (Embracing)

For functions using dplyr/tidyverse:

```r
# Data-masking functions (filter, mutate, summarize)
grouped_mean <- function(df, group_var, value_var) {
  df |>
    group_by({{ group_var }}) |>
    summarize(mean = mean({{ value_var }}))
}

# Tidy-selection functions (select, rename, relocate)
my_select <- function(df, cols) {
  df |> select({{ cols }})
}

# Dynamic column names
my_mutate <- function(df, var) {
  df |> mutate("{{ var }}_squared" := {{ var }}^2)
}
```

### Multiple Columns
```r
# Accept multiple columns
summarize_vars <- function(df, ...) {
  df |> summarize(across(c(...), mean))
}

summarize_vars(mtcars, mpg, hp, wt)
```

## Iteration

### across() - Multiple Columns
```r
# Apply function to multiple columns
df |> summarize(across(everything(), mean))
df |> summarize(across(where(is.numeric), mean))
df |> summarize(across(c(x, y, z), mean))
df |> summarize(across(starts_with("x"), mean))

# Multiple functions
df |> summarize(across(
  where(is.numeric),
  list(mean = mean, sd = sd)
))

# Custom names
df |> summarize(across(
  where(is.numeric),
  mean,
  .names = "mean_{.col}"
))

# With arguments
df |> summarize(across(
  where(is.numeric),
  \(x) mean(x, na.rm = TRUE)
))
```

### map() - Lists (purrr)
```r
library(purrr)

# Basic map (returns list)
map(x, f)
map(x, \(x) x + 1)

# Type-specific variants
map_lgl(x, is.numeric)    # Logical vector
map_int(x, length)        # Integer vector
map_dbl(x, mean)          # Double vector
map_chr(x, class)         # Character vector

# Multiple inputs
map2(x, y, f)             # Two inputs
pmap(list(x, y, z), f)    # Any number of inputs

# With index/names
imap(x, \(val, idx) paste(idx, val))
```

### Reading Multiple Files
```r
# Get file paths
files <- list.files("data/", pattern = "\\.csv$", full.names = TRUE)

# Read all files
df_list <- map(files, read_csv)

# Combine into one data frame
df <- list_rbind(df_list)

# With file names
df_list <- map(files, read_csv)
names(df_list) <- basename(files)
df <- list_rbind(df_list, names_to = "file")

# One-liner
df <- map(files, read_csv) |> list_rbind()
```

### Saving Multiple Outputs
```r
# Save multiple plots
plots <- map(unique(df$group), \(g) {
  df |> filter(group == g) |>
    ggplot(aes(x, y)) + geom_point() + ggtitle(g)
})

paths <- str_c("plots/", unique(df$group), ".png")
walk2(paths, plots, ggsave)

# Save multiple data frames
df |>
  group_nest(group) |>
  mutate(path = str_c("data/", group, ".csv")) |>
  select(path, data) |>
  pwalk(\(path, data) write_csv(data, path))
```

### Side Effects
```r
walk(x, print)            # Print each element
walk(x, \(x) cat(x, "\n")) # Custom output
walk2(paths, data, write_csv)
pwalk(list(paths, data), write_csv)
```

### Error Handling
```r
# Capture errors
safely(f)                 # Returns list(result, error)
possibly(f, otherwise = NA)  # Default on error

# Example
safe_log <- safely(log)
results <- map(x, safe_log)
errors <- map(results, "error")
values <- map(results, "result")

# With possibly
map_dbl(x, possibly(log, NA_real_))
```

### Reduce
```r
# Combine elements
reduce(list(df1, df2, df3), left_join)
reduce(1:4, `+`)  # ((1+2)+3)+4 = 10

# Keep intermediate results
accumulate(1:4, `+`)  # 1, 3, 6, 10
```

### Predicate Functions
```r
keep(x, is.numeric)       # Keep matching
discard(x, is.na)         # Remove matching
some(x, is.na)            # Any TRUE?
every(x, is.numeric)      # All TRUE?
none(x, is.na)            # None TRUE?
detect(x, is.na)          # First match
detect_index(x, is.na)    # Index of first match
```
