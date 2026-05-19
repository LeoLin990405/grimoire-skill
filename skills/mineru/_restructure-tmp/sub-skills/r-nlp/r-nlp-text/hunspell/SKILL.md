---
name: hunspell
description: R hunspell package for spell checking. Use for spell checking and morphological analysis.
---

# hunspell

High-performance stemmer, tokenizer, and spell checker.

## Spell Checking

```r
library(hunspell)

# Check spelling
hunspell("This is a tset of speling")

# Returns list of misspelled words
hunspell(c("hello", "wrold", "test"))
```

## Suggestions

```r
# Get suggestions for misspelled word
hunspell_suggest("speling")

# Multiple words
hunspell_suggest(c("speling", "wrold"))
```

## Check Single Word

```r
# Check if word is correct
hunspell_check("hello")
hunspell_check("wrold")

# Multiple words
hunspell_check(c("hello", "wrold", "test"))
```

## Stemming

```r
# Get word stems
hunspell_stem("running")
hunspell_stem("cats")

# Multiple words
hunspell_stem(c("running", "cats", "better"))
```

## Analyze

```r
# Morphological analysis
hunspell_analyze("running")
hunspell_analyze("cats")
```

## Dictionaries

```r
# List available dictionaries
list_dictionaries()

# Use specific dictionary
hunspell("bonjour", dict = "fr_FR")

# Download dictionary
# dictionary(lang = "de_DE")
```
## Custom Dictionary

```r
# Add words to dictionary
dict <- dictionary("en_US", add_words = c("RStudio", "tidyverse"))
hunspell("RStudio", dict = dict)
```

## Tokenization

```r
# Parse text into words
hunspell_parse("This is a test sentence.")

# With format
hunspell_parse("This is a test.", format = "text")
hunspell_parse("<p>HTML text</p>", format = "html")
hunspell_parse("\\LaTeX{} text", format = "latex")
```

## With Text Data

```r
# Check document
text <- "This is a tset of the speling checker."
misspelled <- hunspell(text)[[1]]

# Get suggestions for each
suggestions <- hunspell_suggest(misspelled)
```
