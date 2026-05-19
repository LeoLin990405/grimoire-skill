---
name: cowplot
description: R cowplot package for combining ggplot2 plots. Use for publication-ready multi-panel figures with shared legends.
---

# cowplot Package

Streamlined plot theme and plot annotations for ggplot2.

## Combine Plots

```r
library(ggplot2)
library(cowplot)

p1 <- ggplot(mtcars, aes(wt, mpg)) + geom_point()
p2 <- ggplot(mtcars, aes(factor(cyl))) + geom_bar()
p3 <- ggplot(mtcars, aes(hp, mpg)) + geom_point()

# Simple grid
plot_grid(p1, p2, ncol = 2)

# With labels
plot_grid(p1, p2, p3,
  labels = c("A", "B", "C"),
  ncol = 2
)

# Custom layout
plot_grid(p1, p2, p3,
  ncol = 2,
  rel_widths = c(2, 1),
  rel_heights = c(1, 1.5)
)
```

## Shared Legend

```r
# Extract legend
legend <- get_legend(p1 + theme(legend.position = "bottom"))

# Combine without legends
plots <- plot_grid(
  p1 + theme(legend.position = "none"),
  p2 + theme(legend.position = "none"),
  ncol = 2
)

# Add shared legend
plot_grid(plots, legend, ncol = 1, rel_heights = c(1, 0.1))
```

## Annotations

```r
# Add labels
ggdraw(p1) +
  draw_label("Draft", x = 0.5, y = 0.5, size = 40, alpha = 0.3)

# Add image
ggdraw() +
  draw_image("logo.png", x = 0.9, y = 0.9, width = 0.1) +
  draw_plot(p1)
```

## Theme

```r
# Clean theme
p1 + theme_cowplot()
p1 + theme_minimal_grid()
p1 + theme_minimal_hgrid()  # horizontal only
p1 + theme_minimal_vgrid()  # vertical only
```

## Save

```r
save_plot("figure.pdf", p1, base_width = 8, base_height = 6)
```
