---
name: tm
description: R tm package for text mining. Use for classic text mining infrastructure and preprocessing.
---

# tm Package

Text mining infrastructure.

## Corpus

```r
library(tm)

# From vector
corp <- VCorpus(VectorSource(texts))

# From directory
corp <- VCorpus(DirSource("texts/"))

# From data frame
corp <- VCorpus(DataframeSource(df))
```

## Preprocessing

```r
# Transform functions
corp <- tm_map(corp, content_transformer(tolower))
corp <- tm_map(corp, removePunctuation)
corp <- tm_map(corp, removeNumbers)
corp <- tm_map(corp, removeWords, stopwords("english"))
corp <- tm_map(corp, stripWhitespace)
corp <- tm_map(corp, stemDocument)

# Custom function
corp <- tm_map(corp, content_transformer(function(x) gsub("pattern", "", x)))
```

## Document-Term Matrix

```r
# Create DTM
dtm <- DocumentTermMatrix(corp)

# Term-Document Matrix
tdm <- TermDocumentMatrix(corp)

# With controls
dtm <- DocumentTermMatrix(corp,
  control = list(
    weighting = weightTfIdf,
    minWordLength = 3,
    bounds = list(global = c(5, Inf))
  )
)
```

## Inspection

```r
# Inspect
inspect(dtm[1:5, 1:10])

# Find frequent terms
findFreqTerms(dtm, lowfreq = 100)

# Find associations
findAssocs(dtm, "data", corlimit = 0.5)
```

## Sparse Matrix

```r
# Remove sparse terms
dtm <- removeSparseTerms(dtm, sparse = 0.95)

# Convert to matrix
m <- as.matrix(dtm)

# To data frame
df <- as.data.frame(as.matrix(dtm))
```

## Dictionary

```r
dict <- c("good", "bad", "excellent")
dtm_dict <- DocumentTermMatrix(corp,
  control = list(dictionary = dict)
)
```
