---
name: ggrepel
description: R ggrepel package for non-overlapping text labels. Use for automatically positioning labels to avoid overlap in ggplot2.
---

# ggrepel

Repel overlapping text labels in ggplot2.

## Basic Usage

```r
library(ggrepel)
library(ggplot2)

# Text labels that don't overlap
ggplot(df, aes(x, y)) +
  geom_point() +
  geom_text_repel(aes(label = name))

# Label boxes
ggplot(df, aes(x, y)) +
  geom_point() +
  geom_label_repel(aes(label = name))
```

## Selective Labeling

```r
# Label only some points
ggplot(df, aes(x, y)) +
  geom_point() +
  geom_text_repel(
    data = subset(df, important == TRUE),
    aes(label = name)
  )

# Label top N
ggplot(df, aes(x, y)) +
  geom_point() +
  geom_text_repel(
    data = df %>% slice_max(value, n = 10),
    aes(label = name)
  )
```

## Styling

```r
ggplot(df, aes(x, y)) +
  geom_point() +
  geom_text_repel(
    aes(label = name),
    size = 3,
    color = "darkblue",
    fontface = "bold",
    family = "sans"
  )

# Label boxes with styling
ggplot(df, aes(x, y)) +
  geom_point() +
  geom_label_repel(
    aes(label = name),
    fill = "white",
    color = "black",
    box.padding = 0.5,
    label.padding = 0.25,
    label.size = 0.25
  )
```

## Segment Lines

```r
# Customize connector lines
ggplot(df, aes(x, y)) +
  geom_point() +
  geom_text_repel(
    aes(label = name),
    segment.color = "grey50",
    segment.size = 0.5,
    segment.linetype = "dashed",
    segment.curvature = -0.1,
    segment.angle = 20
  )

# Arrow segments
ggplot(df, aes(x, y)) +
  geom_point() +
  geom_text_repel(
    aes(label = name),
    arrow = arrow(length = unit(0.02, "npc"))
  )
```

## Repulsion Control

```r
ggplot(df, aes(x, y)) +
  geom_point() +
  geom_text_repel(
    aes(label = name),
    force = 2,              # Repulsion force
    force_pull = 0.5,       # Pull toward data point
    max.overlaps = 20,      # Max overlaps before giving up
    max.iter = 10000,       # Max iterations
    max.time = 1            # Max seconds
  )
```

## Direction Control

```r
# Repel only horizontally
ggplot(df, aes(x, y)) +
  geom_point() +
  geom_text_repel(aes(label = name), direction = "x")

# Repel only vertically
ggplot(df, aes(x, y)) +
  geom_point() +
  geom_text_repel(aes(label = name), direction = "y")

# Both directions (default)
ggplot(df, aes(x, y)) +
  geom_point() +
  geom_text_repel(aes(label = name), direction = "both")
```

## Nudging

```r
# Nudge labels in a direction
ggplot(df, aes(x, y)) +
  geom_point() +
  geom_text_repel(
    aes(label = name),
    nudge_x = 0.5,
    nudge_y = 0.5
  )
```

## Box Padding

```r
ggplot(df, aes(x, y)) +
  geom_point() +
  geom_text_repel(
    aes(label = name),
    box.padding = 1,        # Padding around text
    point.padding = 0.5,    # Padding around points
    min.segment.length = 0  # Always show segments
  )
```

## With Facets

```r
ggplot(df, aes(x, y)) +
  geom_point() +
  geom_text_repel(aes(label = name)) +
  facet_wrap(~group)
```

## Seed for Reproducibility

```r
ggplot(df, aes(x, y)) +
  geom_point() +
  geom_text_repel(aes(label = name), seed = 42)
```

## Handling Many Labels

```r
# Limit overlaps
ggplot(df, aes(x, y)) +
  geom_point() +
  geom_text_repel(
    aes(label = name),
    max.overlaps = Inf,     # Show all labels
    verbose = TRUE          # Print progress
  )
```
