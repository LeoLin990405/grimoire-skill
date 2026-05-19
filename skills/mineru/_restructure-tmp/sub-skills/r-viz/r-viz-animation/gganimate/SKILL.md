---
name: gganimate
description: R gganimate package for animated ggplot2 plots. Use for creating animated visualizations with transitions.
---

# gganimate

Animate ggplot2 plots.

## Basic Animation

```r
library(gganimate)

p <- ggplot(df, aes(x, y)) +
  geom_point() +
  transition_time(year) +
  labs(title = "Year: {frame_time}")

animate(p)
```

## Transitions

```r
# Time-based
transition_time(time_var)
transition_time(year) + labs(title = "Year: {frame_time}")

# State-based
transition_states(state_var, transition_length = 2, state_length = 1)
transition_states(category) + labs(title = "{closest_state}")

# Reveal
transition_reveal(along = time_var)

# Filter
transition_filter(transition_length = 2, filter_length = 1,
  condition1, condition2, condition3)

# Layers
transition_layers(layer_length = 1, transition_length = 2)

# Manual
transition_manual(frame_var)
```

## Enter/Exit

```r
# Enter animations
enter_fade()
enter_grow()
enter_appear()
enter_fly(x_loc = 0, y_loc = 0)
enter_drift(x_mod = 0, y_mod = 1)

# Exit animations
exit_fade()
exit_shrink()
exit_disappear()
exit_fly(x_loc = 0, y_loc = 0)
exit_drift(x_mod = 0, y_mod = -1)

# Combined
p + transition_states(state) +
  enter_fade() + enter_grow() +
  exit_fade() + exit_shrink()
```

## Easing

```r
# Easing functions
ease_aes("linear")
ease_aes("quadratic-in")
ease_aes("quadratic-out")
ease_aes("quadratic-in-out")
ease_aes("cubic-in-out")
ease_aes("elastic-in-out")
ease_aes("bounce-in-out")

# Per aesthetic
ease_aes(x = "cubic-in-out", y = "bounce-out")
```

## Shadow

```r
# Keep previous frames
shadow_wake(wake_length = 0.1)
shadow_trail(distance = 0.05, size = 0.3)
shadow_mark(past = TRUE, future = FALSE)
shadow_null()  # No shadow
```

## View

```r
# Follow data
view_follow()
view_follow(fixed_x = TRUE)
view_follow(fixed_y = c(0, NA))

# Step through views
view_step(pause_length = 2, step_length = 1, nsteps = 3)

# Static view
view_static()
```

## Rendering

```r
# Animate
anim <- animate(p, nframes = 100, fps = 10)

# Options
animate(p,
  nframes = 200,
  fps = 20,
  width = 800,
  height = 600,
  res = 150,
  renderer = gifski_renderer()
)

# Renderers
gifski_renderer()  # GIF (default)
magick_renderer()  # GIF via magick
av_renderer()      # Video
ffmpeg_renderer()  # Video via ffmpeg
file_renderer()    # PNG sequence

# Save
anim_save("animation.gif", anim)
anim_save("animation.mp4", anim, renderer = av_renderer())
```

## Labels

```r
# Dynamic labels
labs(title = "Year: {frame_time}")
labs(title = "State: {closest_state}")
labs(title = "Frame {frame} of {nframes}")
labs(subtitle = "{frame_time}")
```
