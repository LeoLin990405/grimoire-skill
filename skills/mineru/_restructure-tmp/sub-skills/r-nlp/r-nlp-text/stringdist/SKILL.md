---
name: stringdist
description: R stringdist package for string distance. Use for approximate string matching and distance metrics.
---

# stringdist

Approximate string matching and string distance functions.

## String Distance

```r
library(stringdist)

# Single comparison
stringdist("hello", "hallo")

# Multiple comparisons
stringdist(c("hello", "world"), c("hallo", "word"))
```

## Distance Methods

```r
# Levenshtein (default)
stringdist("hello", "hallo", method = "lv")

# Optimal string alignment
stringdist("hello", "hallo", method = "osa")

# Damerau-Levenshtein
stringdist("hello", "hallo", method = "dl")

# Longest common substring
stringdist("hello", "hallo", method = "lcs")

# q-gram
stringdist("hello", "hallo", method = "qgram", q = 2)

# Cosine
stringdist("hello", "hallo", method = "cosine", q = 2)

# Jaccard
stringdist("hello", "hallo", method = "jaccard", q = 2)

# Jaro
stringdist("hello", "hallo", method = "jw")

# Jaro-Winkler
stringdist("hello", "hallo", method = "jw", p = 0.1)

# Soundex
stringdist("hello", "hallo", method = "soundex")
```

## Distance Matrix

```r
# Compute distance matrix
strings <- c("hello", "hallo", "hullo", "world")
stringdistmatrix(strings)

# Between two sets
stringdistmatrix(c("hello", "world"), c("hallo", "word"))
```

## Approximate Matching

```r
# Find closest match
amatch("hello", c("hallo", "world", "help"), maxDist = 2)

# All matches within distance
ain("hello", c("hallo", "world", "help"), maxDist = 2)
```

## String Grouping

```r
# Group similar strings
strings <- c("hello", "hallo", "hullo", "world", "word")
stringdist_grouping <- function(x, maxDist = 2) {
  d <- stringdistmatrix(x)
  hc <- hclust(as.dist(d))
  cutree(hc, h = maxDist)
}
```

## Phonetic Coding

```r
# Soundex
phonetic("hello", method = "soundex")

# Metaphone
phonetic("hello", method = "metaphone")
```

## Q-grams

```r
# Get q-grams
qgrams("hello", q = 2)

# Q-gram table
qgrams(c("hello", "world"), q = 2)
```

## Sequence Alignment

```r
# Get alignment
seq_dist("hello", "hallo", method = "lv")
seq_distmatrix(c("hello", "world"), c("hallo", "word"))
```
