---
name: stringr
description: R stringr package for string manipulation. Use for pattern matching, extraction, replacement, and string operations.
---

# stringr

Consistent string manipulation.

## Basic Operations

```r
library(stringr)

# Length
str_length("hello")

# Combine
str_c("a", "b", "c")
str_c("a", "b", sep = "-")
str_c(c("a", "b"), collapse = ", ")

# Subset
str_sub("hello", 1, 3)  # "hel"
str_sub("hello", -2)    # "lo"

# Case
str_to_upper("hello")
str_to_lower("HELLO")
str_to_title("hello world")
str_to_sentence("hello world")

# Trim/pad
str_trim("  hello  ")
str_squish("  hello   world  ")
str_pad("5", width = 3, pad = "0")  # "005"

# Truncate
str_trunc("hello world", width = 8)
```

## Pattern Matching

```r
# Detect
str_detect("hello", "ell")
str_detect(x, "^a")  # Starts with
str_detect(x, "z$")  # Ends with

# Locate
str_locate("hello", "l")
str_locate_all("hello", "l")

# Count
str_count("hello", "l")

# Which
str_which(x, "pattern")
str_subset(x, "pattern")
```

## Extract and Replace

```r
# Extract
str_extract("abc123def", "\\d+")  # "123"
str_extract_all("a1b2c3", "\\d")  # c("1", "2", "3")

# Match groups
str_match("abc123", "(\\w+)(\\d+)")
str_match_all(x, "(\\w+)=(\\d+)")

# Replace
str_replace("hello", "l", "L")      # First
str_replace_all("hello", "l", "L")  # All
str_replace_all(x, c("a" = "1", "b" = "2"))

# Remove
str_remove("hello", "l")
str_remove_all("hello", "l")
```

## Split and Join

```r
# Split
str_split("a,b,c", ",")
str_split_fixed("a,b,c", ",", n = 2)
str_split_1("a,b,c", ",")  # Returns vector

# Join
str_flatten(c("a", "b", "c"), collapse = ", ")
str_flatten_comma(c("a", "b", "c"))
```

## Regex

```r
# Literal string
fixed("$100")

# Case insensitive
regex("hello", ignore_case = TRUE)

# Boundary
str_extract_all("hello world", boundary("word"))

# Common patterns
"\\d"    # Digit
"\\w"    # Word character
"\\s"    # Whitespace
"."      # Any character
"^"      # Start
"$"      # End
"+"      # One or more
"*"      # Zero or more
"?"      # Zero or one
"{n}"    # Exactly n
"{n,m}"  # Between n and m
"[abc]"  # Character class
"[^abc]" # Negated class
"()"     # Group
"|"      # Or
```

## Glue (interpolation)

```r
library(glue)

name <- "world"
glue("Hello, {name}!")
glue("1 + 1 = {1 + 1}")
glue_data(df, "{x} is {y}")
```
