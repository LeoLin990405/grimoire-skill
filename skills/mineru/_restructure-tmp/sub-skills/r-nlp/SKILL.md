---
name: r-nlp
description: R natural language processing packages. Use for text mining, sentiment analysis, topic modeling, tokenization, and text vectorization.
---

# R NLP Skill

## Sub-skills

| Sub-skill | Description |
|-----------|-------------|
| [r-nlp-text](r-nlp-text/SKILL.md) | tidytext, quanteda, text2vec |
| [r-nlp-topic](r-nlp-topic/SKILL.md) | LDA, STM, topic modeling |
| [r-nlp-sentiment](r-nlp-sentiment/SKILL.md) | sentimentr, syuzhet, lexicons |

Natural Language Processing and text mining in R.

## Core NLP Packages

| Package | Description |
|---------|-------------|
| **tidytext** ★ | Tidy text mining (tidyverse style) |
| **quanteda** ★ | Quantitative text analysis |
| **tm** | Comprehensive text mining framework |
| **text2vec** ★ | Fast vectorization & word embeddings |
| **NLP** | Basic NLP functions |
| **openNLP** | Apache OpenNLP interface |

## Text Processing

| Package | Description |
|---------|-------------|
| **stringr** | Consistent string manipulation |
| **stringi** | ICU-based string processing |
| **SnowballC** | Snowball stemmers |
| **koRpus** | Text analysis package |
| **utf8** | UTF-8 text handling |

## Sentiment Analysis

| Package | Description |
|---------|-------------|
| **syuzhet** | Sentiment extraction (3 dictionaries) |
| **sentimentr** | Sentence-level sentiment |
| **tidytext** | Sentiment lexicons (AFINN, Bing, NRC) |

## Topic Modeling

| Package | Description |
|---------|-------------|
| **topicmodels** | LDA and CTM topic models |
| **LDAvis** | Interactive topic model visualization |
| **stm** | Structural topic models |

## Other

| Package | Description |
|---------|-------------|
| **zipfR** | Word frequency distributions |
| **MonkeyLearn** | MonkeyLearn API interface |
| **corporaexplorer** | Dynamic text collection exploration |

## Quick Examples

```r
# tidytext workflow
library(tidytext)
library(dplyr)

# Tokenize
df %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  count(word, sort = TRUE)

# Sentiment analysis
df %>%
  unnest_tokens(word, text) %>%
  inner_join(get_sentiments("bing")) %>%
  count(sentiment)

# TF-IDF
df %>%
  unnest_tokens(word, text) %>%
  count(document, word) %>%
  bind_tf_idf(word, document, n)

# quanteda
library(quanteda)
corpus <- corpus(texts)
tokens <- tokens(corpus, remove_punct = TRUE)
dfm <- dfm(tokens) %>%
  dfm_remove(stopwords("en")) %>%
  dfm_trim(min_termfreq = 5)

# Topic modeling
library(topicmodels)
dtm <- cast_dtm(df, document, word, n)
lda <- LDA(dtm, k = 5, control = list(seed = 1234))
topics <- tidy(lda, matrix = "beta")

# text2vec word embeddings
library(text2vec)
it <- itoken(texts, tokenizer = word_tokenizer)
vocab <- create_vocabulary(it)
vectorizer <- vocab_vectorizer(vocab)
tcm <- create_tcm(it, vectorizer, skip_grams_window = 5)
glove <- GloVe$new(rank = 50)
word_vectors <- glove$fit_transform(tcm, n_iter = 10)
```

## Common Workflows

### Text Preprocessing
```r
library(tidytext)
library(dplyr)
library(stringr)

clean_text <- df %>%
  mutate(
    text = str_to_lower(text),
    text = str_remove_all(text, "[[:punct:]]"),
    text = str_remove_all(text, "[[:digit:]]"),
    text = str_squish(text)
  ) %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  mutate(word = SnowballC::wordStem(word))
```

### Document-Term Matrix
```r
# tidytext to DTM
dtm <- df %>%
  unnest_tokens(word, text) %>%
  count(doc_id, word) %>%
  cast_dtm(doc_id, word, n)

# quanteda DFM
dfm <- corpus(texts) %>%
  tokens() %>%
  dfm()
```

## Resources

- tidytext book: https://www.tidytextmining.com/
- quanteda: https://quanteda.io/
- text2vec: https://text2vec.org/
- tm: https://tm.r-forge.r-project.org/
