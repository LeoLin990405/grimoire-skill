---
name: dplyr
description: R dplyr package for data manipulation. Use for filter, select, mutate, summarize, group_by, joins, and data transformation.
---

# dplyr

Fast, consistent data manipulation.

## Core Verbs

```r
library(dplyr)

# filter - subset rows
df %>% filter(x > 10)
df %>% filter(x > 10, y == "A")
df %>% filter(x > 10 | y == "A")
df %>% filter(between(x, 5, 10))
df %>% filter(x %in% c(1, 2, 3))

# select - subset columns
df %>% select(a, b, c)
df %>% select(-x)
df %>% select(starts_with("col"))
df %>% select(ends_with("_id"))
df %>% select(contains("name"))
df %>% select(matches("^x[0-9]"))
df %>% select(where(is.numeric))

# mutate - create/modify columns
df %>% mutate(z = x + y)
df %>% mutate(z = x + y, w = z * 2)
df %>% mutate(across(where(is.numeric), scale))
df %>% mutate(across(c(a, b), as.character))

# summarize - aggregate
df %>% summarize(mean_x = mean(x), n = n())
df %>% summarize(across(where(is.numeric), mean))

# arrange - sort rows
df %>% arrange(x)
df %>% arrange(desc(x))
df %>% arrange(x, desc(y))
```

## Grouping

```r
# group_by
df %>%
  group_by(category) %>%
  summarize(mean = mean(value), n = n())

# Multiple groups
df %>%
  group_by(cat1, cat2) %>%
  summarize(total = sum(value), .groups = "drop")

# ungroup
df %>% group_by(x) %>% mutate(pct = value/sum(value)) %>% ungroup()

# rowwise
df %>% rowwise() %>% mutate(total = sum(c_across(a:c)))
```

## Joins

```r
# Inner join
inner_join(df1, df2, by = "id")
inner_join(df1, df2, by = c("a" = "b"))

# Left/right join
left_join(df1, df2, by = "id")
right_join(df1, df2, by = "id")

# Full join
full_join(df1, df2, by = "id")

# Semi/anti join
semi_join(df1, df2, by = "id")  # Keep rows in df1 that match df2
anti_join(df1, df2, by = "id")  # Keep rows in df1 that don't match df2
```

## Window Functions

```r
df %>% mutate(
  row = row_number(),
  rank = min_rank(x),
  dense = dense_rank(x),
  pct_rank = percent_rank(x),
  cum = cumsum(x),
  lag1 = lag(x, 1),
  lead1 = lead(x, 1),
  first = first(x),
  last = last(x),
  nth = nth(x, 3)
)
```

## Helpers

```r
# count
df %>% count(category)
df %>% count(cat1, cat2, sort = TRUE)

# distinct
df %>% distinct(x)
df %>% distinct(x, .keep_all = TRUE)

# slice
df %>% slice(1:10)
df %>% slice_head(n = 5)
df %>% slice_tail(n = 5)
df %>% slice_max(x, n = 3)
df %>% slice_min(x, n = 3)
df %>% slice_sample(n = 10)

# pull - extract column as vector
df %>% pull(x)

# rename
df %>% rename(new_name = old_name)
df %>% rename_with(toupper)

# relocate
df %>% relocate(z, .before = x)
df %>% relocate(z, .after = y)

# case_when
df %>% mutate(
  category = case_when(
    x < 10 ~ "low",
    x < 20 ~ "medium",
    TRUE ~ "high"
  )
)

# if_else
df %>% mutate(flag = if_else(x > 10, "yes", "no"))

# coalesce
df %>% mutate(z = coalesce(x, y, 0))

# na_if
df %>% mutate(x = na_if(x, -999))

# bind
bind_rows(df1, df2)
bind_cols(df1, df2)
```
