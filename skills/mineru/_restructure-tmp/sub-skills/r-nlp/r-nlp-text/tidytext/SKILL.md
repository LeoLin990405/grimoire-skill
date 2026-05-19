---
name: tidytext
description: R tidytext package for text mining. Use for tokenization, sentiment analysis, TF-IDF, and tidy text analysis.
---

# tidytext

Tidy text mining.

## Tokenization

```r
library(tidytext)
library(dplyr)

# Tokenize to words
df %>% unnest_tokens(word, text)

# Tokenize to sentences
df %>% unnest_tokens(sentence, text, token = "sentences")

# Tokenize to ngrams
df %>% unnest_tokens(bigram, text, token = "ngrams", n = 2)
df %>% unnest_tokens(trigram, text, token = "ngrams", n = 3)

# Tokenize to characters
df %>% unnest_tokens(char, text, token = "characters")

# Custom tokenizer
df %>% unnest_tokens(word, text, token = "regex", pattern = "\\s+")
```

## Stop Words

```r
# Remove stop words
df %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

# Custom stop words
custom_stops <- tibble(word = c("custom", "words"))
df %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  anti_join(custom_stops)

# Different lexicons
stop_words %>% filter(lexicon == "snowball")
stop_words %>% filter(lexicon == "onix")
stop_words %>% filter(lexicon == "SMART")
```

## Word Frequencies

```r
# Count words
word_counts <- df %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  count(word, sort = TRUE)

# By document
word_counts <- df %>%
  unnest_tokens(word, text) %>%
  count(document, word, sort = TRUE)
```

## TF-IDF

```r
# Calculate TF-IDF
tfidf <- df %>%
  unnest_tokens(word, text) %>%
  count(document, word) %>%
  bind_tf_idf(word, document, n)

# Top TF-IDF words per document
tfidf %>%
  group_by(document) %>%
  slice_max(tf_idf, n = 10)
```

## Sentiment Analysis

```r
# Get sentiments
get_sentiments("afinn")   # Score -5 to 5
get_sentiments("bing")    # positive/negative
get_sentiments("nrc")     # Multiple emotions

# Join sentiments
df %>%
  unnest_tokens(word, text) %>%
  inner_join(get_sentiments("bing")) %>%
  count(sentiment)

# Sentiment by document
df %>%
  unnest_tokens(word, text) %>%
  inner_join(get_sentiments("afinn")) %>%
  group_by(document) %>%
  summarize(sentiment = sum(value))

# NRC emotions
df %>%
  unnest_tokens(word, text) %>%
  inner_join(get_sentiments("nrc")) %>%
  count(sentiment, sort = TRUE)
```

## N-grams

```r
# Bigrams
bigrams <- df %>%
  unnest_tokens(bigram, text, token = "ngrams", n = 2)

# Separate bigrams
bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ")

# Filter bigrams
bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ") %>%
  filter(!word1 %in% stop_words$word,
         !word2 %in% stop_words$word) %>%
  unite(bigram, word1, word2, sep = " ")
```

## Document-Term Matrix

```r
# Create DTM
dtm <- df %>%
  unnest_tokens(word, text) %>%
  count(document, word) %>%
  cast_dtm(document, word, n)

# Create sparse matrix
sparse <- df %>%
  unnest_tokens(word, text) %>%
  count(document, word) %>%
  cast_sparse(document, word, n)

# From DTM to tidy
tidy(dtm)
```

## Topic Modeling

```r
library(topicmodels)

# Create DTM
dtm <- df %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  count(document, word) %>%
  cast_dtm(document, word, n)

# LDA
lda <- LDA(dtm, k = 5, control = list(seed = 1234))

# Tidy topics
topics <- tidy(lda, matrix = "beta")

# Top words per topic
topics %>%
  group_by(topic) %>%
  slice_max(beta, n = 10)

# Document-topic probabilities
gamma <- tidy(lda, matrix = "gamma")
```
