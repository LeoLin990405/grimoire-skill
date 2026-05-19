---
name: r-nlp-sentiment
description: R sentiment analysis with tidytext, syuzhet, sentimentr. Use for sentiment scoring and emotion detection.
---

# R Sentiment Analysis

Sentiment and emotion detection.

## tidytext Lexicons

```r
library(tidytext)
library(dplyr)

# Available lexicons
get_sentiments("afinn")   # Score -5 to +5
get_sentiments("bing")    # positive/negative
get_sentiments("nrc")     # 8 emotions + pos/neg

# Sentiment analysis
df %>%
  unnest_tokens(word, text) %>%
  inner_join(get_sentiments("bing")) %>%
  count(document, sentiment) %>%
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) %>%
  mutate(sentiment = positive - negative)

# AFINN scoring
df %>%
  unnest_tokens(word, text) %>%
  inner_join(get_sentiments("afinn")) %>%
  group_by(document) %>%
  summarise(sentiment = sum(value))

# NRC emotions
df %>%
  unnest_tokens(word, text) %>%
  inner_join(get_sentiments("nrc")) %>%
  count(sentiment, sort = TRUE)
```

## syuzhet

```r
library(syuzhet)

# Get sentiment scores
sentiment <- get_sentiment(texts, method = "syuzhet")
sentiment <- get_sentiment(texts, method = "bing")
sentiment <- get_sentiment(texts, method = "afinn")
sentiment <- get_sentiment(texts, method = "nrc")

# NRC emotions
emotions <- get_nrc_sentiment(texts)
# Returns: anger, anticipation, disgust, fear, joy, sadness, surprise, trust, negative, positive

# Plot emotional arc
plot(sentiment, type = "l")

# Sentiment by sentence
sentences <- get_sentences(text)
sent_values <- get_sentiment(sentences)

# Smooth sentiment arc
smoothed <- get_dct_transform(sent_values, low_pass_size = 5)
plot(smoothed, type = "l")
```

## sentimentr

```r
library(sentimentr)

# Sentence-level sentiment (handles negation, amplifiers)
result <- sentiment(texts)
result <- sentiment_by(texts, by = NULL)  # Aggregate

# With grouping
result <- sentiment_by(df$text, by = df$document)

# Profanity detection
profanity(texts)

# Emotion detection
emotion(texts)

# Highlight sentiment
highlight(sentiment_by(texts))
```

## Custom Lexicons

```r
library(tidytext)

# Create custom lexicon
custom_lexicon <- tibble(
  word = c("excellent", "terrible", "amazing", "awful"),
  sentiment = c("positive", "negative", "positive", "negative")
)

# Use custom lexicon
df %>%
  unnest_tokens(word, text) %>%
  inner_join(custom_lexicon)

# Domain-specific (finance)
library(lexicon)
hash_sentiment_loughran_mcdonald  # Financial sentiment
```

## Visualization

```r
library(ggplot2)

# Sentiment over time
df %>%
  unnest_tokens(word, text) %>%
  inner_join(get_sentiments("bing")) %>%
  count(date, sentiment) %>%
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) %>%
  mutate(sentiment = positive - negative) %>%
  ggplot(aes(date, sentiment)) +
  geom_line() +
  geom_smooth()

# Word contribution
df %>%
  unnest_tokens(word, text) %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  group_by(sentiment) %>%
  slice_max(n, n = 10) %>%
  ggplot(aes(reorder(word, n), n, fill = sentiment)) +
  geom_col() +
  coord_flip() +
  facet_wrap(~sentiment, scales = "free_y")
```
