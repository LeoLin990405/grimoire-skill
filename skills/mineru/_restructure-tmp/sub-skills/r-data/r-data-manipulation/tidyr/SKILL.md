---
name: tidyr
description: R tidyr package for data tidying. Use for pivot_longer, pivot_wider, separate, unite, and handling missing values.
---

# tidyr

Tidy messy data.

## Pivoting

```r
library(tidyr)

# Wide to long
df %>% pivot_longer(
  cols = c(a, b, c),
  names_to = "variable",
  values_to = "value"
)

df %>% pivot_longer(
  cols = starts_with("year"),
  names_to = "year",
  names_prefix = "year_",
  values_to = "value"
)

df %>% pivot_longer(
  cols = -id,
  names_to = c("var", "time"),
  names_sep = "_",
  values_to = "value"
)

# Long to wide
df %>% pivot_wider(
  names_from = variable,
  values_from = value
)

df %>% pivot_wider(
  names_from = c(var1, var2),
  values_from = value,
  names_sep = "_"
)

df %>% pivot_wider(
  names_from = variable,
  values_from = value,
  values_fill = 0
)
```

## Separate and Unite

```r
# Separate column
df %>% separate(col, into = c("a", "b"), sep = "-")
df %>% separate(col, into = c("a", "b"), sep = 3)  # Position
df %>% separate_wider_delim(col, delim = "-", names = c("a", "b"))
df %>% separate_wider_regex(col, patterns = c(a = "\\d+", "-", b = "\\w+"))

# Separate rows
df %>% separate_rows(col, sep = ",")

# Unite columns
df %>% unite(new_col, a, b, sep = "-")
df %>% unite(new_col, a, b, sep = "-", remove = FALSE)
```

## Missing Values

```r
# Drop rows with NA
df %>% drop_na()
df %>% drop_na(x, y)

# Fill NA
df %>% fill(x)  # Down
df %>% fill(x, .direction = "up")
df %>% fill(x, .direction = "downup")

# Replace NA
df %>% replace_na(list(x = 0, y = "unknown"))

# Complete missing combinations
df %>% complete(x, y)
df %>% complete(x, y, fill = list(value = 0))
df %>% complete(x = 1:10, y)
```

## Nesting

```r
# Nest
df %>% nest(data = c(x, y))
df %>% nest(data = -group)
df %>% group_by(group) %>% nest()

# Unnest
df %>% unnest(data)
df %>% unnest_longer(col)
df %>% unnest_wider(col)

# Hoist (extract from nested)
df %>% hoist(data, a = "a", b = "b")
```

## Rectangling

```r
# Unnest JSON-like structures
df %>% unnest_wider(json_col)
df %>% unnest_longer(list_col)

# Hoist specific elements
df %>% hoist(
  json_col,
  name = "name",
  value = list("nested", "value")
)
```

## Expand

```r
# All combinations
df %>% expand(x, y)
expand_grid(x = 1:3, y = c("a", "b"))

# Crossing (remove duplicates)
crossing(x = 1:3, y = c("a", "b"))

# Nesting (only existing combinations)
df %>% expand(nesting(x, y))
```
