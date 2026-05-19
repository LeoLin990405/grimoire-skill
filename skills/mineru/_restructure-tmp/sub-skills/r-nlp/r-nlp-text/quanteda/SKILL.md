---
name: quanteda
description: R quanteda package for text analysis. Use for corpus management, tokenization, and document-feature matrices.
---

# quanteda Package

Quantitative analysis of textual data.

## Corpus

```r
library(quanteda)

# Create corpus
corp <- corpus(texts)
corp <- corpus(df, text_field = "text")

# Metadata
docvars(corp, "author") <- authors
summary(corp)
```

## Tokenization

```r
# Tokenize
toks <- tokens(corp)

# Options
toks <- tokens(corp,
  remove_punct = TRUE,
  remove_numbers = TRUE,
  remove_symbols = TRUE
)

# N-grams
toks <- tokens_ngrams(toks, n = 2:3)

# Compound tokens
toks <- tokens_compound(toks, pattern = phrase(c("New York", "United States")))
```

## Document-Feature Matrix

```r
# Create DFM
dfm <- dfm(toks)

# Trim
dfm <- dfm_trim(dfm, min_termfreq = 5, min_docfreq = 2)

# Weight
dfm <- dfm_tfidf(dfm)

# Select features
dfm <- dfm_select(dfm, pattern = stopwords("en"), selection = "remove")
```

## Analysis

```r
# Top features
topfeatures(dfm, 20)

# Keyness
keyness <- textstat_keyness(dfm, target = docvars(dfm, "group") == "A")
textplot_keyness(keyness)

# Similarity
sim <- textstat_simil(dfm, method = "cosine")

# Frequency
freq <- textstat_frequency(dfm, groups = docvars(dfm, "group"))
```

## Dictionary

```r
# Create dictionary
dict <- dictionary(list(
  positive = c("good", "great", "excellent"),
  negative = c("bad", "poor", "terrible")
))

# Apply
dfm_dict <- dfm_lookup(dfm, dict)
```

## Visualization

```r
# Word cloud
textplot_wordcloud(dfm, max_words = 100)

# Network
fcm <- fcm(dfm)
textplot_network(fcm, min_freq = 50)
```
