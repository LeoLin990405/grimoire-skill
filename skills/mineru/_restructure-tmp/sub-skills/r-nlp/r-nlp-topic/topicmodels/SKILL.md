---
name: topicmodels
description: R topicmodels package for topic modeling. Use for LDA and CTM topic models on document-term matrices.
---

# topicmodels

Topic models for text analysis.

## LDA (Latent Dirichlet Allocation)

```r
library(topicmodels)
library(tm)

# Create document-term matrix
corpus <- Corpus(VectorSource(texts))
dtm <- DocumentTermMatrix(corpus)

# Fit LDA
lda_model <- LDA(dtm, k = 5)  # 5 topics
```

## LDA Parameters

```r
lda_model <- LDA(
  dtm,
  k = 5,                    # Number of topics
  method = "Gibbs",         # "VEM" or "Gibbs"
  control = list(
    seed = 123,             # For reproducibility
    burnin = 1000,          # Gibbs: burn-in iterations
    iter = 2000,            # Gibbs: sampling iterations
    thin = 100,             # Gibbs: thinning interval
    alpha = 0.1,            # Document-topic prior
    delta = 0.1             # Topic-word prior (VEM only)
  )
)
```

## Extract Results

```r
# Top terms per topic
terms(lda_model, 10)

# Topic probabilities for documents
topics(lda_model)

# Full posterior
posterior(lda_model)

# Beta (topic-word distribution)
beta <- posterior(lda_model)$terms

# Gamma (document-topic distribution)
gamma <- posterior(lda_model)$topics
```

## CTM (Correlated Topic Model)

```r
# Fit CTM
ctm_model <- CTM(dtm, k = 5)

# CTM allows topic correlations
# Extract correlation matrix
ctm_model@Sigma
```

## Model Selection

```r
# Perplexity for different k values
perplexities <- sapply(2:10, function(k) {
  model <- LDA(dtm, k = k, control = list(seed = 123))
  perplexity(model)
})

# Plot
plot(2:10, perplexities, type = "b",
     xlab = "Number of Topics", ylab = "Perplexity")

# Choose k with lowest perplexity or elbow
```

## Cross-Validation

```r
# Split data
train_idx <- sample(nrow(dtm), 0.8 * nrow(dtm))
train_dtm <- dtm[train_idx, ]
test_dtm <- dtm[-train_idx, ]

# Fit on training
model <- LDA(train_dtm, k = 5)

# Evaluate on test
perplexity(model, newdata = test_dtm)
```

## Visualization

```r
library(tidytext)
library(ggplot2)

# Tidy format
topics_tidy <- tidy(lda_model, matrix = "beta")

# Top terms per topic
top_terms <- topics_tidy %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup()

# Plot
ggplot(top_terms, aes(reorder(term, beta), beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip()
```

## Document Classification

```r
# Get dominant topic per document
doc_topics <- topics(lda_model)

# Topic probabilities
doc_probs <- posterior(lda_model)$topics

# Assign to original data
df$topic <- doc_topics
```

## New Documents

```r
# Predict topics for new documents
new_corpus <- Corpus(VectorSource(new_texts))
new_dtm <- DocumentTermMatrix(new_corpus,
  control = list(dictionary = Terms(dtm))
)

# Get topic distribution
new_topics <- posterior(lda_model, newdata = new_dtm)$topics
```

## Preprocessing Tips

```r
library(tm)

# Standard preprocessing
corpus <- Corpus(VectorSource(texts))
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, stopwords("english"))
corpus <- tm_map(corpus, stemDocument)
corpus <- tm_map(corpus, stripWhitespace)

# Create DTM with term frequency bounds
dtm <- DocumentTermMatrix(corpus,
  control = list(
    bounds = list(global = c(5, Inf)),  # Min 5 docs
    weighting = weightTf
  )
)

# Remove sparse terms
dtm <- removeSparseTerms(dtm, 0.99)
```

## Seeded LDA

```r
# Provide seed words for topics
seed_words <- list(
  c("economy", "market", "stock"),
  c("health", "medical", "disease"),
  c("sports", "game", "team")
)

# Use seeded LDA (requires additional packages)
```
