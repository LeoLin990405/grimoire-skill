---
name: gganimate
description: R gganimate package for animated plots. Use for creating animated ggplot2 visualizations.
---

# gganimate

A grammar of animated graphics.

## Basic Animation

```r
library(ggplot2)
library(gganimate)

p <- ggplot(gapminder::gapminder, aes(gdpPercap, lifeExp, size = pop, color = continent)) +
  geom_point(alpha = 0.7) +
  scale_x_log10() +
  labs(title = 'Year: {frame_time}') +
  transition_time(year) +
  ease_aes('linear')

animate(p)
```

## Transitions

```r
# Transition through states
ggplot(data, aes(x, y)) +
  geom_point() +
  transition_states(state, transition_length = 2, state_length = 1)

# Transition along time
ggplot(data, aes(x, y)) +
  geom_point() +
  transition_time(time)

# Reveal data
ggplot(data, aes(x, y)) +
  geom_line() +
  transition_reveal(time)

# Filter data
ggplot(data, aes(x, y)) +
  geom_point() +
  transition_filter(filter1, filter2)
```

## Labels

```r
# Dynamic labels
labs(title = 'Year: {frame_time}')
labs(title = 'State: {closest_state}')
labs(title = '{current_frame} of {nframes}')
```

## Enter/Exit

```r
ggplot(data, aes(x, y)) +
  geom_point() +
  transition_states(state) +
  enter_fade() +
  exit_shrink()

# Options: enter_fade, enter_grow, enter_appear
# exit_fade, exit_shrink, exit_disappear
```

## Shadow

```r
# Leave trail
ggplot(data, aes(x, y)) +
  geom_point() +
  transition_time(time) +
  shadow_wake(wake_length = 0.1)

# Mark previous positions
ggplot(data, aes(x, y)) +
  geom_point() +
  transition_time(time) +
  shadow_mark(past = TRUE, future = FALSE)
```

## Easing

```r
# Easing functions
ease_aes('linear')
ease_aes('quadratic-in')
ease_aes('cubic-in-out')
ease_aes('bounce-out')
ease_aes('elastic-in')
```

## Rendering

```r
# Animate and save
anim <- animate(p, nframes = 100, fps = 10)
anim_save("animation.gif", anim)

# Different renderers
animate(p, renderer = gifski_renderer())
animate(p, renderer = av_renderer())  # Video
animate(p, renderer = ffmpeg_renderer())
```

## View

```r
# Follow data
ggplot(data, aes(x, y)) +
  geom_point() +
  transition_time(time) +
  view_follow()

# Step view
view_step(pause_length = 2, step_length = 1)
```
