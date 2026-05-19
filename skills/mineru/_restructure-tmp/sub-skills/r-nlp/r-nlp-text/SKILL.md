---
name: r-nlp-text
description: R text mining with tidytext, tm, quanteda. Use for tokenization, TF-IDF, document-term matrices.
---

# R Text Mining

Text processing and analysis.

## tidytext

```r
library(tidytext)
library(dplyr)

# Tokenize
df %>% unnest_tokens(word, text)

# Remove stop words
df %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

# Word counts
df %>%
  unnest_tokens(word, text) %>%
  count(word, sort = TRUE)

# TF-IDF
df %>%
  unnest_tokens(word, text) %>%
  count(document, word) %>%
  bind_tf_idf(word, document, n)

# N-grams
df %>% unnest_tokens(bigram, text, token = "ngrams", n = 2)

# Cast to DTM
dtm <- df %>%
  unnest_tokens(word, text) %>%
  count(document, word) %>%
  cast_dtm(document, word, n)
```

## quanteda

```r
library(quanteda)

# Create corpus
corpus <- corpus(texts)

# Tokenize
tokens <- tokens(corpus, remove_punct = TRUE, remove_numbers = TRUE)
tokens <- tokens_tolower(tokens)
tokens <- tokens_remove(tokens, stopwords("en"))
tokens <- tokens_wordstem(tokens)

# Document-feature matrix
dfm <- dfm(tokens)
dfm <- dfm_trim(dfm, min_termfreq = 5, min_docfreq = 2)

# TF-IDF weighting
dfm_tfidf <- dfm_tfidf(dfm)

# Top features
topfeatures(dfm, 20)

# Keyword in context
kwic(tokens, pattern = "economy", window = 5)
```

## tm

```r
library(tm)

# Create corpus
corpus <- Corpus(VectorSource(texts))

# Preprocessing
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, stopwords("english"))
corpus <- tm_map(corpus, stemDocument)
corpus <- tm_map(corpus, stripWhitespace)

# Document-term matrix
dtm <- DocumentTermMatrix(corpus)
dtm <- removeSparseTerms(dtm, 0.99)

# Term-document matrix
tdm <- TermDocumentMatrix(corpus)

# Find frequent terms
findFreqTerms(dtm, lowfreq = 10)

# Find associations
findAssocs(dtm, "economy", corlimit = 0.3)
```

## text2vec

```r
library(text2vec)

# Iterator
it <- itoken(texts, tokenizer = word_tokenizer, progressbar = FALSE)

# Vocabulary
vocab <- create_vocabulary(it)
vocab <- prune_vocabulary(vocab, term_count_min = 5)

# Vectorizer
vectorizer <- vocab_vectorizer(vocab)

# DTM
dtm <- create_dtm(it, vectorizer)

# TF-IDF
tfidf <- TfIdf$new()
dtm_tfidf <- fit_transform(dtm, tfidf)
```
