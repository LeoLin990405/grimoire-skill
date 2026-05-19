---
name: magrittr
description: R magrittr package for pipe operators. Use for %>% pipe and functional programming chains.
---

# magrittr

Forward pipe operator and more.

## Basic Pipe %>%

```r
library(magrittr)

# Pipe data through functions
x %>% f()
# Equivalent to: f(x)

x %>% f() %>% g() %>% h()
# Equivalent to: h(g(f(x)))

# Real example
mtcars %>%
  subset(hp > 100) %>%
  aggregate(. ~ cyl, data = ., FUN = mean) %>%
  transform(kpl = mpg * 0.425)
```

## Placeholder .

```r
# Default: first argument
x %>% f(y)
# Equivalent to: f(x, y)

# Explicit placement
x %>% f(y, .)
# Equivalent to: f(y, x)

# Multiple uses
x %>% f(., .)
# Equivalent to: f(x, x)

# In nested calls
x %>% f(g(.))
# Equivalent to: f(g(x))
```

## Assignment Pipe %<>%

```r
# Modify in place
x <- 1:10
x %<>% sqrt()
# x is now sqrt(1:10)

# Chain modifications
df %<>%
  filter(x > 0) %>%
  mutate(y = x * 2)
# df is modified
```

## Tee Pipe %T>%

```r
# Side effects without breaking chain
df %T>%
  print() %>%
  filter(x > 0)
# Prints df, then filters

# Save intermediate result
df %T>%
  {intermediate <<- .} %>%
  summarise(n = n())

# Multiple side effects
df %T>%
  write.csv("backup.csv") %T>%
  print() %>%
  filter(x > 0)
```

## Exposition Pipe %$%

```r
# Expose names
df %$%
  cor(x, y)
# Equivalent to: cor(df$x, df$y)

# With base functions
mtcars %$%
  plot(mpg, hp)

# Multiple variables
df %$%
  lm(y ~ x + z)
```

## Functional Sequences

```r
# Create reusable pipeline
standardize <- . %>%
  subtract(mean(.)) %>%
  divide_by(sd(.))

# Apply
x %>% standardize()
y %>% standardize()

# More complex
process_data <- . %>%
  na.omit() %>%
  scale() %>%
  as.data.frame()
```

## Aliases

```r
# Arithmetic aliases
x %>% add(1)           # x + 1
x %>% subtract(1)      # x - 1
x %>% multiply_by(2)   # x * 2
x %>% divide_by(2)     # x / 2
x %>% raise_to_power(2) # x ^ 2
x %>% mod(3)           # x %% 3

# Logical aliases
x %>% and(y)           # x & y
x %>% or(y)            # x | y
x %>% equals(y)        # x == y
x %>% is_greater_than(y) # x > y

# Extraction aliases
x %>% extract(1)       # x[1]
x %>% extract2(1)      # x[[1]]
x %>% use_series(col)  # x$col
```

## Compound Assignment

```r
# Combine with aliases
x %<>% add(1)
x %<>% multiply_by(2)

# In data frames
df$x %<>% sqrt()
df$y %<>% log()
```

## Debugging

```r
# Print and continue
x %>%
  f() %>%
  print() %>%
  g()

# Debug with browser
x %>%
  f() %>%
  {browser(); .} %>%
  g()

# Verbose pipe
x %>%
  f() %>%
  {message("After f: ", length(.)); .} %>%
  g()
```

## Lambda Expressions

```r
# Anonymous function
x %>%
  {sum(.) / length(.)}

# With multiple statements
x %>% {
  n <- length(.)
  s <- sum(.)
  s / n
}
```
