---
name: stm
description: R stm package for structural topic models. Use for topic modeling with document-level covariates.
---

# stm

Structural Topic Models with covariates.

## Basic Usage

```r
library(stm)

# Prepare documents
processed <- textProcessor(texts, metadata = df)
out <- prepDocuments(processed$documents, processed$vocab, processed$meta)

# Fit STM
model <- stm(
  documents = out$documents,
  vocab = out$vocab,
  K = 10,  # Number of topics
  data = out$meta
)
```

## With Covariates

```r
# Topic prevalence varies by covariate
model <- stm(
  documents = out$documents,
  vocab = out$vocab,
  K = 10,
  prevalence = ~ party + s(year),  # Topic prevalence formula
  data = out$meta
)

# Topic content varies by covariate
model <- stm(
  documents = out$documents,
  vocab = out$vocab,
  K = 10,
  content = ~ party,  # Topic content formula
  data = out$meta
)

# Both
model <- stm(
  documents = out$documents,
  vocab = out$vocab,
  K = 10,
  prevalence = ~ party + s(year),
  content = ~ party,
  data = out$meta
)
```

## Model Selection

```r
# Search for optimal K
search_result <- searchK(
  out$documents,
  out$vocab,
  K = c(5, 10, 15, 20),
  data = out$meta,
  prevalence = ~ party
)

# Plot diagnostics
plot(search_result)
```

## Extract Results

```r
# Top words per topic
labelTopics(model)

# FREX words (frequent and exclusive)
labelTopics(model, frexweight = 0.5)

# Topic proportions
model$theta

# Word-topic probabilities
model$beta
```

## Visualization

```r
# Topic quality
topicQuality(model, out$documents)

# Topic correlation
topicCorr(model)
plot(topicCorr(model))

# Word cloud
cloud(model, topic = 1)

# Topic prevalence
plot(model, type = "summary")

# Topic labels
plot(model, type = "labels")

# Perspectives (compare topics)
plot(model, type = "perspectives", topics = c(1, 2))
```

## Covariate Effects

```r
# Estimate effect of covariates
effect <- estimateEffect(
  formula = 1:10 ~ party + s(year),
  stmobj = model,
  metadata = out$meta
)

# Plot effect
plot(effect, covariate = "party", topics = 1:5,
     model = model, method = "difference",
     cov.value1 = "Democrat", cov.value2 = "Republican")

# Continuous covariate
plot(effect, covariate = "year", topics = 1,
     model = model, method = "continuous")
```

## Find Representative Documents

```r
# Find documents for each topic
thoughts <- findThoughts(model, texts = texts, n = 3, topics = 1:5)

# Plot
plotQuote(thoughts, width = 40)
```

## Topic Labels

```r
# Automatic labels
sageLabels(model)

# Custom labels
topic_labels <- c("Economy", "Health", "Politics", ...)
```

## Preprocessing

```r
# Text processor options
processed <- textProcessor(
  texts,
  metadata = df,
  lowercase = TRUE,
  removestopwords = TRUE,
  removenumbers = TRUE,
  removepunctuation = TRUE,
  stem = TRUE,
  wordLengths = c(3, Inf),
  sparselevel = 1,
  language = "en",
  verbose = TRUE
)

# Prepare documents
out <- prepDocuments(
  processed$documents,
  processed$vocab,
  processed$meta,
  lower.thresh = 10,  # Min word frequency
  upper.thresh = Inf
)
```

## Spectral Initialization

```r
# Use spectral initialization (recommended)
model <- stm(
  documents = out$documents,
  vocab = out$vocab,
  K = 10,
  init.type = "Spectral",
  data = out$meta
)
```

## Convergence

```r
# Check convergence
plot(model$convergence$bound, type = "l",
     main = "Convergence", xlab = "Iteration", ylab = "Bound")

# More iterations if needed
model <- stm(
  documents = out$documents,
  vocab = out$vocab,
  K = 10,
  max.em.its = 150,
  data = out$meta
)
```

## Save and Load

```r
# Save model
saveRDS(model, "stm_model.rds")

# Load model
model <- readRDS("stm_model.rds")
```
