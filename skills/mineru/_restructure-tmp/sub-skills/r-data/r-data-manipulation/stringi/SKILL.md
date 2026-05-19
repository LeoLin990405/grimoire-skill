---
name: stringi
description: R stringi package for string processing. Use for fast, consistent string manipulation with ICU library.
---

# stringi

Fast string processing with ICU.

## Basic Operations

```r
library(stringi)

# Length
stri_length("hello")
stri_length(c("hello", "world"))

# Concatenation
stri_c("hello", "world")
stri_c("a", "b", "c", sep = "-")
stri_paste(letters[1:3], collapse = ", ")

# Duplication
stri_dup("ab", 3)  # "ababab"
```

## Case Conversion

```r
stri_trans_toupper("hello")
stri_trans_tolower("HELLO")
stri_trans_totitle("hello world")

# Locale-aware
stri_trans_toupper("istanbul", locale = "tr_TR")
```

## Substring

```r
# Extract
stri_sub("hello", 1, 3)  # "hel"
stri_sub("hello", -2)    # "lo"

# Replace
x <- "hello"
stri_sub(x, 1, 2) <- "XX"  # "XXllo"

# Multiple extractions
stri_sub_all("hello", list(c(1, 3), c(2, 4)))
```

## Pattern Matching

```r
# Detect
stri_detect_regex("hello123", "\\d+")
stri_detect_fixed("hello", "ell")

# Count
stri_count_regex("a1b2c3", "\\d")
stri_count_fixed("banana", "a")

# Locate
stri_locate_first_regex("hello123", "\\d+")
stri_locate_all_regex("a1b2c3", "\\d")
```

## Extract and Replace

```r
# Extract matches
stri_extract_first_regex("hello123", "\\d+")
stri_extract_all_regex("a1b2c3", "\\d+")

# Replace
stri_replace_first_regex("hello123", "\\d+", "XXX")
stri_replace_all_regex("a1b2c3", "\\d", "X")
stri_replace_all_fixed("banana", "a", "o")
```

## Split

```r
stri_split_fixed("a,b,c", ",")
stri_split_regex("a1b2c3", "\\d")
stri_split_boundaries("hello world", type = "word")
```

## Trim and Pad

```r
# Trim whitespace
stri_trim("  hello  ")
stri_trim_left("  hello  ")
stri_trim_right("  hello  ")

# Pad
stri_pad_left("42", 5, "0")   # "00042"
stri_pad_right("hi", 5, "-")  # "hi---"
stri_pad_both("hi", 6, "*")   # "**hi**"
```

## Encoding

```r
# Detect encoding
stri_enc_detect(raw_bytes)

# Convert encoding
stri_encode(x, from = "latin1", to = "UTF-8")

# Check if valid UTF-8
stri_enc_isutf8(x)
```

## Comparison

```r
# Compare strings
stri_cmp("a", "b")  # -1, 0, or 1

# Locale-aware comparison
stri_cmp("ä", "z", locale = "de_DE")

# Sorting
stri_sort(c("b", "a", "c"))
stri_order(c("b", "a", "c"))
```

## Unicode

```r
# Normalize
stri_trans_nfc(x)   # Canonical composition
stri_trans_nfd(x)   # Canonical decomposition

# Character info
stri_trans_char("hello", "aeiou", "12345")
```

## Random Strings

```r
stri_rand_strings(5, 10)  # 5 random strings of length 10
stri_rand_strings(3, 8, "[a-z]")  # Lowercase only
```
