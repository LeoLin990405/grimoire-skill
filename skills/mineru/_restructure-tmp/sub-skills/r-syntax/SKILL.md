---
name: r-syntax
description: R syntax extensions and pipe operators. Use for magrittr pipes, functional programming, and syntax enhancements.
---

# R Syntax Extensions

Pipe operators and syntax enhancements.

## magrittr Pipe

```r
library(magrittr)

# Basic pipe %>%
df %>%
  filter(x > 0) %>%
  select(a, b) %>%
  mutate(c = a + b)

# Equivalent to
mutate(select(filter(df, x > 0), a, b), c = a + b)
```

## Native Pipe (R 4.1+)

```r
# Native pipe |>
df |>
  filter(x > 0) |>
  select(a, b)

# With placeholder (R 4.2+)
df |> lm(y ~ x, data = _)
```

## magrittr Special Pipes

```r
# Assignment pipe %<>%
x %<>% sqrt()
# Equivalent to: x <- sqrt(x)

# Tee pipe %T>%
df %T>%
  print() %>%
  filter(x > 0)
# Prints df, then continues pipeline

# Exposition pipe %$%
df %$%
  cor(x, y)
# Exposes columns as variables
```

## Placeholder

```r
# Dot placeholder
df %>% lm(y ~ x, data = .)

# Multiple uses
df %>% {
  model <- lm(y ~ x, data = .)
  summary(.)
}

# In specific position
c(1, 2, 3) %>% paste("value:", .)
```

## Functional Sequences

```r
# Create reusable pipeline
my_pipeline <- . %>%
  filter(x > 0) %>%
  mutate(y = x * 2) %>%
  summarise(mean = mean(y))

# Apply to data
df1 %>% my_pipeline()
df2 %>% my_pipeline()
```

## Lambda Functions

```r
# Anonymous function in pipe
df %>%
  {function(d) d[d$x > 0, ]}() %>%
  head()

# With formula syntax (purrr)
df %>%
  map(~ .x * 2)
```

## Debugging Pipes

```r
# Print intermediate results
df %>%
  filter(x > 0) %>%
  print() %>%
  mutate(y = x * 2)

# Use browser
df %>%
  filter(x > 0) %>%
  {browser(); .} %>%
  mutate(y = x * 2)
```

## Best Practices

```r
# Good: Clear, readable pipeline
result <- df %>%
  filter(x > 0) %>%
  group_by(category) %>%
  summarise(mean = mean(value))

# Avoid: Too long pipelines
# Break into logical chunks
cleaned <- df %>%
  filter(x > 0) %>%
  mutate(y = log(x))

result <- cleaned %>%
  group_by(category) %>%
  summarise(mean = mean(y))

# Avoid: Side effects in pipes
# Use %T>% for side effects
df %T>%
  write.csv("output.csv") %>%
  summarise(n = n())
```

## Comparison

```r
# magrittr %>%
# - Works with any function
# - Dot placeholder
# - Special pipes (%<>%, %T>%, %$%)

# Native |>
# - Faster (no function call overhead)
# - Built into R
# - Limited placeholder support
# - No special pipes
```
