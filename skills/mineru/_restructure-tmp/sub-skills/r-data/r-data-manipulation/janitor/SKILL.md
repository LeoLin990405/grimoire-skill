---
name: janitor
description: R janitor package for data cleaning. Use for cleaning dirty data and creating tabulations.
---

# janitor

Simple tools for examining and cleaning dirty data.

## Clean Names

```r
library(janitor)

# Clean column names
df <- clean_names(df)

# Options
df <- clean_names(df, case = "snake")      # default
df <- clean_names(df, case = "lower_camel")
df <- clean_names(df, case = "upper_camel")
df <- clean_names(df, case = "screaming_snake")
df <- clean_names(df, case = "title")

# Make names from vector
make_clean_names(c("First Name", "Last Name"))
```

## Tabulations

```r
# One-way tabulation
df %>% tabyl(category)

# Two-way tabulation
df %>% tabyl(category, group)

# Three-way tabulation
df %>% tabyl(category, group, year)
```

## Tabyl Adornments

```r
df %>%
  tabyl(category, group) %>%
  adorn_totals("row") %>%           # Add row totals
  adorn_totals("col") %>%           # Add column totals
  adorn_percentages("row") %>%      # Convert to row percentages
  adorn_pct_formatting() %>%        # Format percentages
  adorn_ns() %>%                    # Add counts in parentheses
  adorn_title("combined")           # Add title row
```

## Remove Empty

```r
# Remove empty rows and columns
df <- remove_empty(df, which = c("rows", "cols"))

# Remove empty rows only
df <- remove_empty(df, which = "rows")

# Remove empty columns only
df <- remove_empty(df, which = "cols")

# Remove constant columns
df <- remove_constant(df)
```

## Duplicates

```r
# Find duplicates
df %>% get_dupes()

# Find duplicates by specific columns
df %>% get_dupes(name, date)

# Count duplicates
df %>% get_dupes() %>% nrow()
```

## Data Comparison

```r
# Compare data frames
compare_df_cols(df1, df2)

# Check if same columns
compare_df_cols_same(df1, df2)
```

## Excel Dates

```r
# Convert Excel numeric dates
excel_numeric_to_date(44197)  # Returns Date

# Convert Excel datetime
excel_numeric_to_date(44197.5, include_time = TRUE)

# Convert to Excel date
convert_to_date("2021-01-01")
convert_to_datetime("2021-01-01 12:00:00")
```

## Rounding

```r
# Round half up (Excel-style)
round_half_up(2.5)  # Returns 3

# Round to fraction
round_to_fraction(0.37, denominator = 4)  # Returns 0.25
```

## Row-wise Operations

```r
# Add row numbers
df %>% row_to_names(row_number = 1)  # Use first row as names

# Convert first row to names
df %>% row_to_names(1)
```

## Crosstab

```r
# Cross tabulation with statistics
df %>%
  tabyl(var1, var2) %>%
  chisq.test()

# Fisher's exact test
df %>%
  tabyl(var1, var2) %>%
  fisher.test()
```

## Top Levels

```r
# Show top levels of factor
df %>% top_levels(category, n = 5)
```

## Single Value

```r
# Check if column has single value
df %>%
  summarise(across(everything(), ~ n_distinct(.x) == 1))
```

## With dplyr

```r
library(dplyr)

df %>%
  clean_names() %>%
  remove_empty(c("rows", "cols")) %>%
  mutate(date = excel_numeric_to_date(date_col)) %>%
  tabyl(category) %>%
  adorn_pct_formatting()
```
