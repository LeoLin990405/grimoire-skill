# R4DS - Part III: Wrangle (tidyr, strings, factors, dates)

Based on "R for Data Science" (2e) by Hadley Wickham et al.
Book URL: https://r4ds.hadley.nz/

## Data Tidying (tidyr)

### Tidy Data Principles
1. Each variable is a column
2. Each observation is a row
3. Each value is a cell

### pivot_longer() - Wide to Long
```r
df |> pivot_longer(
  cols = col1:col3,
  names_to = "name_column",
  values_to = "value_column"
)

# Multiple variables in column names
df |> pivot_longer(
  cols = starts_with("x"),
  names_to = c("var", "year"),
  names_sep = "_",
  values_to = "value"
)

# Column names contain data
df |> pivot_longer(
  cols = -id,
  names_to = c(".value", "year"),
  names_sep = "_"
)
```

### pivot_wider() - Long to Wide
```r
df |> pivot_wider(
  names_from = name_column,
  values_from = value_column
)

df |> pivot_wider(
  id_cols = id,
  names_from = name,
  values_from = value,
  values_fill = 0
)
```

### Separate & Unite
```r
# Separate one column into multiple
df |> separate_wider_delim(col, delim = "-", names = c("a", "b"))
df |> separate_wider_position(col, widths = c(a = 2, b = 3))
df |> separate_longer_delim(col, delim = ",")

# Unite multiple columns into one
df |> unite(new_col, col1, col2, sep = "-")
```

## Strings (stringr)

### Basic Operations
```r
str_length(x)              # Character count
str_c(a, b, sep = "-")     # Concatenate
str_glue("Hello {name}")   # Interpolation
str_flatten(x, collapse = ", ")  # Vector to single string
str_sub(x, 1, 3)           # Substring (1-indexed)
str_sub(x, -3, -1)         # Last 3 characters
```

### Case Conversion
```r
str_to_upper(x)
str_to_lower(x)
str_to_title(x)
str_to_sentence(x)
```

### Whitespace
```r
str_trim(x)                # Remove leading/trailing
str_squish(x)              # Trim + collapse internal
str_pad(x, width = 5, side = "left", pad = "0")
```

### Pattern Matching
```r
str_detect(x, pattern)     # TRUE/FALSE
str_count(x, pattern)      # Count matches
str_locate(x, pattern)     # Position of first match
str_extract(x, pattern)    # Extract first match
str_extract_all(x, pattern) # Extract all matches
str_match(x, pattern)      # Extract with groups
str_replace(x, pattern, replacement)
str_replace_all(x, pattern, replacement)
str_remove(x, pattern)
str_remove_all(x, pattern)
str_split(x, pattern)      # Split into list
```

### Regular Expressions
```r
# Anchors
^           # Start of string
$           # End of string

# Character classes
.           # Any character
\\d         # Digit [0-9]
\\s         # Whitespace
\\w         # Word character [a-zA-Z0-9_]
[abc]       # Any of a, b, c
[^abc]      # Not a, b, c
[a-z]       # Range

# Quantifiers
?           # 0 or 1
*           # 0 or more
+           # 1 or more
{n}         # Exactly n
{n,}        # n or more
{n,m}       # Between n and m

# Groups
(...)       # Capture group
(?:...)     # Non-capture group
\\1         # Backreference
```

## Factors (forcats)

### Creating Factors
```r
factor(x, levels = c("low", "medium", "high"))
fct(x, levels = c("low", "medium", "high"))  # Stricter
```

### Reordering Levels
```r
fct_reorder(f, x)          # By another variable
fct_reorder(f, x, .fun = median)
fct_infreq(f)              # By frequency
fct_rev(f)                 # Reverse order
fct_relevel(f, "first")    # Move to front
fct_relevel(f, "last", after = Inf)  # Move to end
fct_shift(f, n = 1)        # Shift levels
```

### Modifying Levels
```r
fct_recode(f, new = "old", new2 = "old2")
fct_collapse(f, group = c("a", "b", "c"))
fct_lump_n(f, n = 5)       # Keep top n
fct_lump_min(f, min = 10)  # Keep if count >= min
fct_lump_prop(f, prop = 0.1)  # Keep if prop >= 0.1
fct_other(f, keep = c("a", "b"))  # Others to "Other"
fct_drop(f)                # Drop unused levels
fct_expand(f, "new_level") # Add new level
```

### Inspection
```r
levels(f)
nlevels(f)
fct_count(f)
fct_unique(f)
```

## Dates & Times (lubridate)

### Parsing
```r
library(lubridate)

# From strings
ymd("2024-01-15")
mdy("01/15/2024")
dmy("15-01-2024")
ymd_hms("2024-01-15 10:30:00")
ymd_hm("2024-01-15 10:30")

# From components
make_date(year, month, day)
make_datetime(year, month, day, hour, min, sec)
```

### Components
```r
year(x)
month(x)
month(x, label = TRUE)     # "Jan", "Feb", etc.
day(x)
mday(x)                    # Day of month
wday(x)                    # Day of week (1 = Sunday)
wday(x, label = TRUE)      # "Sun", "Mon", etc.
yday(x)                    # Day of year
hour(x)
minute(x)
second(x)
```

### Arithmetic
```r
# Durations (exact seconds)
x + days(1)
x + weeks(2)
x + hours(3)

# Periods (human units)
x + months(1)
x + years(1)

# Intervals
interval(start, end)
int_length(interval)       # Duration in seconds
interval / days(1)         # Duration in days

# Differences
difftime(end, start, units = "days")
as.numeric(difftime(end, start, units = "hours"))
```

### Rounding
```r
floor_date(x, unit = "month")
ceiling_date(x, unit = "week")
round_date(x, unit = "hour")
```

### Time Zones
```r
with_tz(x, tzone = "America/New_York")  # Display in new tz
force_tz(x, tzone = "UTC")              # Change tz (same instant)
Sys.timezone()
OlsonNames()                            # List all timezones
```
