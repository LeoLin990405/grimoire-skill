---
name: r-viz-animation
description: R animation with gganimate. Use for animated plots, transitions, and GIF/video export.
---

# R Animation

Animated visualizations with gganimate.

## gganimate Basics

```r
library(ggplot2)
library(gganimate)

# Basic animation
p <- ggplot(df, aes(x, y, color = group)) +
  geom_point() +
  transition_time(year) +
  labs(title = "Year: {frame_time}")

animate(p)
```

## Transitions

```r
# transition_time - animate over time variable
ggplot(df, aes(x, y)) +
  geom_point() +
  transition_time(date) +
  labs(title = "Date: {frame_time}")

# transition_states - animate between discrete states
ggplot(df, aes(x, y)) +
  geom_point() +
  transition_states(category, transition_length = 2, state_length = 1) +
  labs(title = "Category: {closest_state}")

# transition_reveal - reveal data along axis
ggplot(df, aes(x = date, y = value)) +
  geom_line() +
  geom_point() +
  transition_reveal(date)

# transition_filter - filter between conditions
ggplot(df, aes(x, y)) +
  geom_point() +
  transition_filter(
    transition_length = 2,
    filter_length = 1,
    group1 == "A",
    group1 == "B"
  )

# transition_layers - animate layers
ggplot(df, aes(x, y)) +
  geom_point() +
  geom_smooth() +
  transition_layers(layer_length = 1, transition_length = 2)
```

## Views

```r
# view_follow - camera follows data
ggplot(df, aes(x, y)) +
  geom_point() +
  transition_time(time) +
  view_follow()

# view_step - step between views
ggplot(df, aes(x, y)) +
  geom_point() +
  transition_states(state) +
  view_step(pause_length = 2, step_length = 1)

# view_zoom - zoom effect
ggplot(df, aes(x, y)) +
  geom_point() +
  transition_time(time) +
  view_zoom_manual(
    xmin = c(0, 10), xmax = c(100, 50),
    ymin = c(0, 20), ymax = c(100, 60)
  )
```

## Shadows

```r
# shadow_wake - trailing shadow
ggplot(df, aes(x, y, color = group)) +
  geom_point(size = 3) +
  transition_time(time) +
  shadow_wake(wake_length = 0.1, alpha = FALSE)

# shadow_trail - leave trail
ggplot(df, aes(x, y)) +
  geom_point() +
  transition_time(time) +
  shadow_trail(distance = 0.01, alpha = 0.3)

# shadow_mark - mark past/future
ggplot(df, aes(x, y)) +
  geom_point() +
  transition_time(time) +
  shadow_mark(past = TRUE, future = FALSE, alpha = 0.3)
```

## Enter/Exit

```r
# Control how points appear/disappear
ggplot(df, aes(x, y)) +
  geom_point() +
  transition_states(state) +
  enter_fade() +
  exit_shrink()

# Options: enter_fade, enter_grow, enter_fly, enter_drift
# Options: exit_fade, exit_shrink, exit_fly, exit_drift
```

## Easing

```r
# Control animation smoothness
ggplot(df, aes(x, y)) +
  geom_point() +
  transition_states(state) +
  ease_aes("cubic-in-out")

# Options: linear, quadratic, cubic, quartic, quintic
# Modifiers: -in, -out, -in-out
# Special: bounce, elastic, back, circular, exponential
```

## Rendering

```r
# Animate with options
anim <- animate(p,
  nframes = 100,
  fps = 10,
  width = 800,
  height = 600,
  renderer = gifski_renderer()
)

# Save
anim_save("animation.gif", anim)

# Video output
animate(p, renderer = av_renderer("animation.mp4"))
animate(p, renderer = ffmpeg_renderer("animation.mp4"))
```

## Example: Racing Bar Chart

```r
library(ggplot2)
library(gganimate)

p <- df %>%
  group_by(year) %>%
  mutate(rank = rank(-value)) %>%
  filter(rank <= 10) %>%
  ggplot(aes(x = rank, y = value, fill = category)) +
  geom_col() +
  geom_text(aes(label = name), hjust = -0.1) +
  coord_flip() +
  scale_x_reverse() +
  transition_time(year) +
  labs(title = "Year: {frame_time}") +
  theme_minimal()

animate(p, nframes = 200, fps = 20)
```
