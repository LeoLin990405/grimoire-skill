---
name: LDAvis
description: R LDAvis package for topic model visualization. Use for interactive visualization of LDA topic models.
---

# LDAvis

Interactive visualization of LDA topic models.

## Basic Usage

```r
library(LDAvis)
library(topicmodels)

# Fit LDA model first
lda_model <- LDA(dtm, k = 10)

# Create visualization
json <- createJSON(
  phi = posterior(lda_model)$terms,
  theta = posterior(lda_model)$topics,
  doc.length = rowSums(as.matrix(dtm)),
  vocab = colnames(dtm),
  term.frequency = colSums(as.matrix(dtm))
)

# View in browser
serVis(json)
```

## With topicmodels

```r
library(topicmodels)
library(LDAvis)

# Fit LDA
lda <- LDA(dtm, k = 10, method = "Gibbs",
           control = list(seed = 123, iter = 1000))

# Extract components
phi <- posterior(lda)$terms
theta <- posterior(lda)$topics
vocab <- colnames(dtm)
doc_length <- rowSums(as.matrix(dtm))
term_freq <- colSums(as.matrix(dtm))

# Create JSON
json <- createJSON(
  phi = phi,
  theta = theta,
  doc.length = doc_length,
  vocab = vocab,
  term.frequency = term_freq
)

serVis(json)
```

## Customization

```r
json <- createJSON(
  phi = phi,
  theta = theta,
  doc.length = doc_length,
  vocab = vocab,
  term.frequency = term_freq,
  R = 30,                    # Number of terms to display
  lambda.step = 0.01,        # Lambda slider step
  mds.method = jsPCA,        # MDS method
  cluster = NULL,            # Cluster topics
  reorder.topics = TRUE      # Reorder by prevalence
)
```

## Save Visualization

```r
# Save as HTML
serVis(json, out.dir = "lda_vis", open.browser = FALSE)

# Creates:
# - lda_vis/index.html
# - lda_vis/lda.json
# - lda_vis/d3.v3.js
# - lda_vis/ldavis.v1.0.0.js
# - lda_vis/ldavis.v1.0.0.css
```

## With text2vec

```r
library(text2vec)
library(LDAvis)

# Create DTM with text2vec
it <- itoken(texts, preprocessor = tolower, tokenizer = word_tokenizer)
vocab <- create_vocabulary(it)
vectorizer <- vocab_vectorizer(vocab)
dtm <- create_dtm(it, vectorizer)

# Fit LDA
lda_model <- LDA$new(n_topics = 10)
doc_topic_distr <- lda_model$fit_transform(dtm, n_iter = 1000)

# Get components
phi <- lda_model$get_top_words(n = ncol(dtm), lambda = 1)
# ... create visualization
```

## Understanding the Visualization

```r
# The visualization shows:
# 1. Left panel: Topic circles
#    - Size = topic prevalence
#    - Position = topic similarity (MDS)
#
# 2. Right panel: Top terms
#    - Red bars = term frequency in selected topic
#    - Blue bars = overall term frequency
#
# 3. Lambda slider
#    - λ = 1: Most frequent terms in topic
#    - λ = 0: Most exclusive terms to topic
#    - λ ≈ 0.6: Good balance (recommended)
```

## Relevance Metric

```r
# Term relevance = λ * log(φ_kw) + (1-λ) * log(φ_kw / p_w)
# where:
# - φ_kw = probability of word w in topic k
# - p_w = marginal probability of word w
# - λ = weight parameter (0 to 1)

# Lower λ emphasizes exclusivity
# Higher λ emphasizes frequency
```

## In Shiny

```r
library(shiny)
library(LDAvis)

ui <- fluidPage(
  visOutput("ldavis")
)

server <- function(input, output) {
  output$ldavis <- renderVis({
    createJSON(phi, theta, doc.length, vocab, term.frequency)
  })
}

shinyApp(ui, server)
```

## Troubleshooting

```r
# If terms don't match
# Ensure vocab order matches phi columns
stopifnot(all(vocab == colnames(phi)))

# If document lengths don't match
# Ensure doc.length matches theta rows
stopifnot(length(doc_length) == nrow(theta))

# Remove empty documents
non_empty <- doc_length > 0
theta <- theta[non_empty, ]
doc_length <- doc_length[non_empty]
```

## Alternative MDS Methods

```r
# Default: jsPCA (fast, approximate)
json <- createJSON(..., mds.method = jsPCA)

# Classical MDS (slower, exact)
json <- createJSON(..., mds.method = function(x) cmdscale(dist(x), k = 2))

# t-SNE
library(Rtsne)
json <- createJSON(..., mds.method = function(x) {
  Rtsne(x, dims = 2, perplexity = 5)$Y
})
```
