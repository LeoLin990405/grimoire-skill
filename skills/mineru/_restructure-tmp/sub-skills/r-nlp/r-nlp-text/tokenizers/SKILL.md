---
name: tokenizers
description: R tokenizers package for text tokenization. Use for fast, consistent tokenization of text.
---

# tokenizers

Fast, consistent tokenization of natural language text.

## Word Tokenization

```r
library(tokenizers)

# Tokenize into words
tokenize_words("This is a test sentence.")

# Multiple texts
texts <- c("First sentence.", "Second sentence.")
tokenize_words(texts)
```

## Options

```r
# Lowercase
tokenize_words(text, lowercase = TRUE)

# Keep punctuation
tokenize_words(text, strip_punct = FALSE)

# Keep numbers
tokenize_words(text, strip_numeric = FALSE)

# Stopwords
tokenize_words(text, stopwords = stopwords::stopwords("en"))
```

## Sentence Tokenization

```r
# Tokenize into sentences
tokenize_sentences("First sentence. Second sentence!")

# With abbreviations
tokenize_sentences(text, strip_punct = FALSE)
```

## Character Tokenization

```r
# Single characters
tokenize_characters("hello")

# Character shingles
tokenize_character_shingles("hello", n = 3)
```

## N-grams

```r
# Word n-grams
tokenize_ngrams("This is a test", n = 2)

# Range of n-grams
tokenize_ngrams("This is a test", n = 2, n_min = 1)

# Skip-grams
tokenize_skip_ngrams("This is a test", n = 2, k = 1)
```

## Paragraph Tokenization

```r
# Split by paragraphs
text <- "First paragraph.\n\nSecond paragraph."
tokenize_paragraphs(text)
```

## Line Tokenization

```r
# Split by lines
tokenize_lines("Line 1\nLine 2\nLine 3")
```

## Regex Tokenization

```r
# Custom pattern
tokenize_regex(text, pattern = "\\s+")
```

## Word Stems

```r
# Tokenize and stem
tokenize_word_stems("running cats jumping")

# With language
tokenize_word_stems(text, language = "english")
```

## PTB Tokenization

```r
# Penn Treebank style
tokenize_ptb("It's a test.")
```

## Tweet Tokenization

```r
# Twitter-aware tokenization
tokenize_tweets("Hello @user! Check out #rstats http://example.com")
```

## Count Tokens

```r
# Count words
count_words("This is a test sentence.")

# Count sentences
count_sentences("First. Second. Third.")

# Count characters
count_characters("hello")
```
