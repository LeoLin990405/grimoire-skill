---
name: wordcloud2
description: R wordcloud2 package for word clouds. Use for creating interactive HTML word clouds.
---

# wordcloud2

Interactive word clouds using wordcloud2.js.

## Basic Word Cloud

```r
library(wordcloud2)

# From data frame (word, freq columns)
wordcloud2(df)

# Simple example
words <- data.frame(
  word = c("R", "Python", "Julia", "Scala", "Java"),
  freq = c(100, 80, 40, 30, 60)
)
wordcloud2(words)
```

## Customization

```r
wordcloud2(
  data = words,
  size = 1,                    # Font size scaling
  minSize = 0,                 # Minimum font size
  gridSize = 0,                # Grid size for layout
  fontFamily = "Segoe UI",     # Font family
  fontWeight = "bold",         # Font weight
  color = "random-dark",       # Color scheme
  backgroundColor = "white",   # Background color
  minRotation = -pi/4,         # Min rotation angle
  maxRotation = pi/4,          # Max rotation angle
  rotateRatio = 0.4,           # Ratio of rotated words
  shape = "circle",            # Shape: circle, cardioid, diamond, etc.
  ellipticity = 0.65,          # Ellipticity of shape
  widgetsize = NULL,           # Widget size
  figPath = NULL,              # Custom shape image
  hoverFunction = NULL         # Hover callback
)
```

## Color Options

```r
# Random dark colors
wordcloud2(words, color = "random-dark")

# Random light colors
wordcloud2(words, color = "random-light")

# Single color
wordcloud2(words, color = "steelblue")

# Custom color function
wordcloud2(words, color = htmlwidgets::JS(
  "function(word, weight) {
    return weight > 50 ? 'red' : 'blue';
  }"
))

# Color vector
colors <- c("red", "blue", "green", "orange", "purple")
words$color <- colors[1:nrow(words)]
wordcloud2(words)
```

## Shapes

```r
# Circle (default)
wordcloud2(words, shape = "circle")

# Cardioid (heart-like)
wordcloud2(words, shape = "cardioid")

# Diamond
wordcloud2(words, shape = "diamond")

# Triangle
wordcloud2(words, shape = "triangle")

# Pentagon
wordcloud2(words, shape = "pentagon")

# Star
wordcloud2(words, shape = "star")
```

## Custom Shape from Image

```r
# Use image as mask
wordcloud2(words, figPath = "shape.png")

# Letter shape
letterCloud(words, word = "R", size = 2)
```

## Rotation

```r
# No rotation
wordcloud2(words, minRotation = 0, maxRotation = 0, rotateRatio = 0)

# Only horizontal and vertical
wordcloud2(words, minRotation = -pi/2, maxRotation = pi/2, rotateRatio = 0.5)

# Random rotation
wordcloud2(words, minRotation = -pi, maxRotation = pi, rotateRatio = 1)
```

## Hover Effects

```r
# Custom hover function
wordcloud2(words, hoverFunction = htmlwidgets::JS(
  "function(item, dimension, event) {
    console.log(item[0] + ': ' + item[1]);
  }"
))
```

## From Text

```r
library(tm)

# Create corpus
corpus <- Corpus(VectorSource(text))
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeWords, stopwords("english"))

# Create term-document matrix
tdm <- TermDocumentMatrix(corpus)
m <- as.matrix(tdm)
word_freqs <- sort(rowSums(m), decreasing = TRUE)

# Create data frame
words <- data.frame(
  word = names(word_freqs),
  freq = word_freqs
)

wordcloud2(words)
```

## Saving

```r
library(htmlwidgets)

# Save as HTML
wc <- wordcloud2(words)
saveWidget(wc, "wordcloud.html", selfcontained = TRUE)

# Save as image (requires webshot)
library(webshot)
saveWidget(wc, "temp.html", selfcontained = TRUE)
webshot("temp.html", "wordcloud.png", delay = 5)
```

## In Shiny

```r
library(shiny)

ui <- fluidPage(
  wordcloud2Output("cloud")
)

server <- function(input, output) {
  output$cloud <- renderWordcloud2({
    wordcloud2(words)
  })
}

shinyApp(ui, server)
```

## Performance Tips

```r
# Limit number of words
top_words <- head(words[order(-words$freq), ], 200)
wordcloud2(top_words)

# Adjust grid size for faster rendering
wordcloud2(words, gridSize = 10)
```
