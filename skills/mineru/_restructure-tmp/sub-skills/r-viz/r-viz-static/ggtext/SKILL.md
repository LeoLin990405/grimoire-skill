---
name: ggtext
description: R ggtext package for rich text in ggplot2. Use for adding formatted text, markdown, and HTML to plots.
---

# ggtext

Improved text rendering for ggplot2.

## Basic Markdown

```r
library(ggplot2)
library(ggtext)

ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  labs(title = "**Bold** and *italic* text") +
  theme(plot.title = element_markdown())
```

## Colored Text

```r
ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  labs(title = "<span style='color:red'>Red</span> and <span style='color:blue'>Blue</span>") +
  theme(plot.title = element_markdown())
```

## Axis Labels

```r
ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  labs(
    x = "Weight (*1000 lbs*)",
    y = "Miles per gallon"
  ) +
  theme(axis.title.x = element_markdown())
```

## Legend with Markdown

```r
ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
  geom_point() +
  scale_color_manual(
    values = c("red", "green", "blue"),
    labels = c("**4** cyl", "**6** cyl", "**8** cyl")
  ) +
  theme(legend.text = element_markdown())
```

## Text Box

```r
ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  labs(title = "Title with **formatting**") +
  theme(
    plot.title = element_textbox_simple(
      padding = margin(5, 5, 5, 5),
      margin = margin(0, 0, 10, 0),
      fill = "lightgray"
    )
  )
```

## Geom Richtext

```r
df <- data.frame(
  x = 1:3,
  y = 1:3,
  label = c("**Bold**", "*Italic*", "<span style='color:red'>Red</span>")
)

ggplot(df, aes(x, y, label = label)) +
  geom_richtext()

# Without box
ggplot(df, aes(x, y, label = label)) +
  geom_richtext(fill = NA, label.color = NA)
```

## Images in Text

```r
# Include images
labs(title = "<img src='logo.png' width='20'/> Title")
```

## Facet Labels

```r
ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  facet_wrap(~cyl, labeller = as_labeller(
    c(`4` = "**4** cylinders", `6` = "**6** cylinders", `8` = "**8** cylinders")
  )) +
  theme(strip.text = element_markdown())
```

## Subscript/Superscript

```r
labs(
  x = "CO<sub>2</sub> concentration",
  y = "Area (m<sup>2</sup>)"
) +
theme(
  axis.title.x = element_markdown(),
  axis.title.y = element_markdown()
)
```
