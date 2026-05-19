---
name: slidify
description: R slidify package for HTML5 slides. Use for creating interactive HTML5 presentations from R Markdown.
---

# slidify

Create stunning HTML5 slides from R Markdown.

## Getting Started

```r
library(slidify)

# Create new deck
author("mydeck")

# This creates:
# mydeck/
#   index.Rmd
#   assets/
```

## Basic Slide

```markdown
---
title       : My Presentation
subtitle    : Subtitle here
author      : Your Name
job         : Job Title
framework   : io2012
highlighter : highlight.js
hitheme     : tomorrow
widgets     : []
mode        : selfcontained
---

## Slide 1

Content here

---

## Slide 2

More content
```

## Frameworks

```yaml
# Available frameworks:
framework: io2012      # Google I/O 2012
framework: html5slides # HTML5 slides
framework: deck.js     # deck.js
framework: dzslides    # DZSlides
framework: landslide   # Landslide
framework: shower      # Shower
framework: revealjs    # reveal.js
```

## Code Chunks

```markdown
## R Code

```{r}
summary(cars)
```

## Plot

```{r, fig.width=8, fig.height=6}
plot(cars)
```
```

## Widgets

```yaml
widgets: [mathjax, quiz, bootstrap]
```

```markdown
## Math

$$E = mc^2$$

## Quiz

--- &radio

What is 2 + 2?

1. 3
2. _4_
3. 5

*** .hint
Think about it...

*** .explanation
2 + 2 = 4
```

## Slide Classes

```markdown
--- .class1 .class2 #id

## Styled Slide

Content with custom classes
```

## Two Columns

```markdown
--- &twocol

## Two Columns

*** =left

Left content

*** =right

Right content
```

## Build and Publish

```r
# Generate slides
slidify("index.Rmd")

# Publish to GitHub
publish_github(user = "username", repo = "repo")

# Publish to Dropbox
publish_dropbox()

# Publish to RPubs
publish_rpubs("Title", "index.html")
```

## Custom CSS

```markdown
---
framework: io2012
---

<style>
.title-slide {
  background-color: #CBE7A5;
}
</style>
```
