---
name: syuzhet
description: R syuzhet package for sentiment analysis. Use for extracting sentiment and emotion from text.
---

# syuzhet

Sentiment extraction and analysis.

## Basic Sentiment

```r
library(syuzhet)

# Get sentiment scores
text <- "I love this amazing product! It's wonderful."
get_sentiment(text)

# Multiple sentences
sentences <- c("I love this!", "This is terrible.", "It's okay.")
get_sentiment(sentences)
```

## Sentiment Methods

```r
# Syuzhet (default)
get_sentiment(text, method = "syuzhet")

# Bing
get_sentiment(text, method = "bing")

# AFINN
get_sentiment(text, method = "afinn")

# NRC
get_sentiment(text, method = "nrc")

# Stanford (requires Java)
get_sentiment(text, method = "stanford")
```

## NRC Emotions

```r
# Get emotion scores
emotions <- get_nrc_sentiment(text)

# Returns data frame with columns:
# anger, anticipation, disgust, fear, joy,
# sadness, surprise, trust, negative, positive

# Multiple texts
texts <- c("I'm so happy!", "This makes me angry.", "I'm scared.")
emotions <- get_nrc_sentiment(texts)
```

## Sentiment by Sentence

```r
# Split into sentences
sentences <- get_sentences(text)

# Get sentiment for each
sentiment <- get_sentiment(sentences)

# Plot sentiment arc
plot(sentiment, type = "l")
```

## Sentiment Transformation

```r
# Get sentiment values
sentiment <- get_sentiment(sentences)

# Smooth with DCT
dct_values <- get_dct_transform(sentiment, low_pass_size = 5)

# Percentage-based transformation
pct_values <- get_percentage_values(sentiment, bins = 10)

# Plot transformed sentiment
simple_plot(dct_values)
```

## Sentiment Arcs

```r
# Get sentiment arc
sentiment <- get_sentiment(sentences)

# Rescale to 0-1
rescaled <- rescale_x_2(sentiment)

# Plot arc
plot(rescaled, type = "l", main = "Sentiment Arc")
```

## Word Tokens

```r
# Get tokens
tokens <- get_tokens(text)

# Get sentiment for tokens
token_sentiment <- get_sentiment(tokens)
```

## Custom Lexicon

```r
# Load custom lexicon
custom_lexicon <- data.frame(
  word = c("awesome", "terrible", "meh"),
  value = c(2, -2, 0)
)

# Use custom method
get_sentiment(text, method = "custom", lexicon = custom_lexicon)
```

## Visualization

```r
# Bar plot of emotions
emotions <- get_nrc_sentiment(text)
barplot(
  colSums(emotions),
  las = 2,
  col = rainbow(10),
  main = "Emotion Scores"
)

# Sentiment over time
sentiment <- get_sentiment(sentences)
plot(
  sentiment,
  type = "l",
  main = "Sentiment Over Time",
  xlab = "Sentence",
  ylab = "Sentiment"
)
```

## Processing Large Texts

```r
# Read text file
text <- get_text_as_string("book.txt")

# Split into sentences
sentences <- get_sentences(text)

# Get sentiment
sentiment <- get_sentiment(sentences)

# Smooth and plot
dct <- get_dct_transform(sentiment, low_pass_size = 5)
simple_plot(dct)
```

## Comparing Texts

```r
# Multiple texts
texts <- list(
  text1 = get_sentences(text1),
  text2 = get_sentences(text2)
)

# Get sentiment for each
sentiments <- lapply(texts, get_sentiment)

# Compare arcs
par(mfrow = c(1, 2))
simple_plot(get_dct_transform(sentiments[[1]]))
simple_plot(get_dct_transform(sentiments[[2]]))
```
