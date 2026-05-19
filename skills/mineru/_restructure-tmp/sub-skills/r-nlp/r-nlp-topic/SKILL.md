---
name: r-nlp-topic
description: R topic modeling with topicmodels, LDAvis, stm. Use for LDA, CTM, and topic visualization.
---

# R Topic Modeling

Latent topic discovery.

## topicmodels (LDA)

```r
library(topicmodels)

# Prepare DTM
dtm <- cast_dtm(df, document, word, n)

# Fit LDA
lda <- LDA(dtm, k = 10, control = list(seed = 1234))

# Topics
topics(lda)  # Top topic per document
terms(lda, 10)  # Top 10 terms per topic

# Tidy output
library(tidytext)
topics_beta <- tidy(lda, matrix = "beta")  # Word-topic probabilities
topics_gamma <- tidy(lda, matrix = "gamma")  # Document-topic probabilities

# Top terms per topic
topics_beta %>%
  group_by(topic) %>%
  slice_max(beta, n = 10) %>%
  ungroup()

# Find optimal k
library(ldatuning)
result <- FindTopicsNumber(
  dtm,
  topics = seq(2, 20, by = 2),
  metrics = c("Griffiths2004", "CaoJuan2009", "Arun2010", "Deveaud2014"),
  method = "Gibbs",
  control = list(seed = 1234)
)
FindTopicsNumber_plot(result)
```

## LDAvis (Visualization)

```r
library(LDAvis)

# Prepare data for visualization
phi <- posterior(lda)$terms
theta <- posterior(lda)$topics
vocab <- colnames(phi)
doc_length <- rowSums(as.matrix(dtm))
term_freq <- colSums(as.matrix(dtm))

json <- createJSON(
  phi = phi,
  theta = theta,
  vocab = vocab,
  doc.length = doc_length,
  term.frequency = term_freq
)

serVis(json)
```

## stm (Structural Topic Model)

```r
library(stm)

# Prepare data
processed <- textProcessor(texts, metadata = df)
out <- prepDocuments(processed$documents, processed$vocab, processed$meta)

# Fit STM with covariates
model <- stm(
  documents = out$documents,
  vocab = out$vocab,
  K = 10,
  prevalence = ~ category + s(date),
  data = out$meta
)

# Results
labelTopics(model)
plot(model, type = "summary")

# Topic correlations
topicCorr(model)

# Effect of covariates
effect <- estimateEffect(1:10 ~ category, model, meta = out$meta)
plot(effect, covariate = "category", topics = 1:5)

# Find optimal K
search_k <- searchK(out$documents, out$vocab, K = c(5, 10, 15, 20))
plot(search_k)
```

## CTM (Correlated Topic Model)

```r
library(topicmodels)

ctm <- CTM(dtm, k = 10, control = list(seed = 1234))
terms(ctm, 10)
```
