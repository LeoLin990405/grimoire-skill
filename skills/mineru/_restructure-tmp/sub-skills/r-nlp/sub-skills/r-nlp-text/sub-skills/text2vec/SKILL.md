---
name: text2vec
description: R text2vec package for text vectorization. Use for word embeddings, GloVe, and efficient text processing.
---

# text2vec Package

Fast text vectorization and embeddings.

## Tokenization

```r
library(text2vec)

# Iterator
it <- itoken(texts,
  preprocessor = tolower,
  tokenizer = word_tokenizer
)

# From files
it <- ifiles("*.txt") %>%
  itoken(tokenizer = word_tokenizer)
```

## Vocabulary

```r
# Create vocabulary
vocab <- create_vocabulary(it)

# Prune
vocab <- prune_vocabulary(vocab,
  term_count_min = 5,
  doc_proportion_max = 0.5
)

# Vectorizer
vectorizer <- vocab_vectorizer(vocab)
```

## Document-Term Matrix

```r
# Create DTM
dtm <- create_dtm(it, vectorizer)

# TF-IDF
tfidf <- TfIdf$new()
dtm_tfidf <- fit_transform(dtm, tfidf)
```

## Word Embeddings (GloVe)

```r
# Co-occurrence matrix
tcm <- create_tcm(it, vectorizer, skip_grams_window = 5)

# Train GloVe
glove <- GloVe$new(rank = 100, x_max = 10)
word_vectors <- glove$fit_transform(tcm, n_iter = 20)

# Get word vector
word_vectors["king", ]

# Word analogies
king <- word_vectors["king", ]
man <- word_vectors["man", ]
woman <- word_vectors["woman", ]
queen_vec <- king - man + woman
```

## Topic Modeling (LDA)

```r
lda <- LDA$new(n_topics = 10)
doc_topics <- lda$fit_transform(dtm, n_iter = 100)

# Top words per topic
lda$get_top_words(n = 10)
```

## Similarity

```r
# Cosine similarity
sim <- sim2(dtm[1:10, ], dtm, method = "cosine")

# Jaccard
sim <- sim2(dtm, method = "jaccard")
```
