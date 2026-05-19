---
name: sentimentr
description: R sentimentr package for sentence-level sentiment. Use for polarity-based sentiment analysis with valence shifters.
---

# sentimentr

Sentence-level sentiment with valence shifters.

## Basic Usage

```r
library(sentimentr)

# Sentiment of text
text <- "I really love this product. It's not bad at all."
sentiment(text)

# Returns data frame with:
# element_id, sentence_id, word_count, sentiment
```

## Sentiment Scores

```r
# Single text
result <- sentiment(text)

# Multiple texts
texts <- c("I love this!", "This is terrible.", "Not bad.")
result <- sentiment(texts)

# By sentence
result <- sentiment_by(texts)
```

## Valence Shifters

```r
# sentimentr handles:
# - Negators: "not good" -> negative
# - Amplifiers: "very good" -> more positive
# - De-amplifiers: "barely good" -> less positive
# - Adversative conjunctions: "good but expensive"

text <- "I don't like this. It's not very good."
sentiment(text)  # Correctly handles negation
```

## Sentiment by Group

```r
# Group by variable
df <- data.frame(
  text = c("Great product!", "Terrible service.", "Love it!"),
  group = c("A", "B", "A")
)

sentiment_by(df$text, df$group)
```

## Emotion Detection

```r
# Get emotions
emotion(text)

# Specific emotions
emotion_by(text)

# Returns: anger, anticipation, disgust, fear, joy,
#          sadness, surprise, trust
```

## Profanity Detection

```r
# Check for profanity
profanity(text)

# By group
profanity_by(texts, grouping_var)
```

## Highlighting

```r
# Highlight sentiment in text
result <- sentiment(text)
highlight(result)

# Returns HTML with color-coded sentiment
```

## Custom Lexicon

```r
# Create custom polarity table
my_lexicon <- lexicon::hash_sentiment_jockers_rinker

# Add custom words
my_lexicon <- update_key(my_lexicon,
  x = data.frame(
    x = c("awesome", "terrible"),
    y = c(1, -1)
  )
)

# Use custom lexicon
sentiment(text, polarity_dt = my_lexicon)
```

## Valence Shifter Tables

```r
# View default valence shifters
lexicon::hash_valence_shifters

# Custom valence shifters
my_shifters <- update_key(
  lexicon::hash_valence_shifters,
  x = data.frame(
    x = c("kinda", "sorta"),
    y = c(2, 2)  # 2 = de-amplifier
  )
)

sentiment(text, valence_shifters_dt = my_shifters)
```

## Sentence Extraction

```r
# Get sentences
get_sentences(text)

# With custom regex
get_sentences(text, regex = "[.!?]")
```

## Plotting

```r
library(ggplot2)

# Plot sentiment
result <- sentiment_by(texts)
plot(result)

# Custom plot
ggplot(result, aes(x = element_id, y = ave_sentiment)) +
  geom_bar(stat = "identity", fill = ifelse(result$ave_sentiment > 0, "green", "red")) +
  theme_minimal()
```

## With Data Frames

```r
# Sentiment on data frame column
df <- data.frame(
  id = 1:3,
  review = c("Great!", "Terrible!", "Okay.")
)

# Add sentiment
df$sentiment <- sentiment_by(df$review)$ave_sentiment
```

## Performance

```r
# For large datasets, use parallel processing
library(parallel)

# Split data
chunks <- split(texts, ceiling(seq_along(texts) / 1000))

# Process in parallel
results <- mclapply(chunks, sentiment_by, mc.cores = 4)

# Combine
final <- do.call(rbind, results)
```

## Comparison with Other Methods

```r
# sentimentr advantages:
# - Handles valence shifters (negation, amplification)
# - Sentence-level analysis
# - Fast performance
# - Customizable lexicons

# Example showing valence shifter handling
sentiment("This is good")      # Positive
sentiment("This is not good")  # Negative (handles negation)
sentiment("This is very good") # More positive (handles amplification)
```
