---
name: purrr
description: R purrr package for functional programming. Use for map, reduce, iteration, and list manipulation.
---

# purrr

Functional programming tools.

## Map Functions

```r
library(purrr)

# map - returns list
map(x, f)
map(x, ~ .x + 1)
map(x, \(x) x + 1)

# Typed variants
map_chr(x, f)  # Character vector
map_dbl(x, f)  # Double vector
map_int(x, f)  # Integer vector
map_lgl(x, f)  # Logical vector
map_vec(x, f)  # Auto-detect type

# map_dfr/map_dfc - bind results
map_dfr(files, read_csv)  # Bind rows
map_dfc(x, f)  # Bind columns

# map2 - two inputs
map2(x, y, f)
map2(x, y, ~ .x + .y)
map2_dbl(x, y, `+`)

# pmap - multiple inputs
pmap(list(a, b, c), f)
pmap_dbl(list(a, b, c), ~ ..1 + ..2 + ..3)

# imap - with index
imap(x, ~ paste(.y, .x))
imap_chr(x, ~ paste(.y, .x))

# walk - side effects (no return)
walk(x, print)
walk2(x, y, write_csv)
pwalk(list(data, paths), write_csv)
```

## Modify

```r
# modify - preserve structure
modify(x, f)
modify_if(x, is.numeric, ~ .x * 2)
modify_at(x, c("a", "b"), toupper)
modify_depth(x, 2, f)

# modify in place
modify(df, ~ if(is.numeric(.x)) scale(.x) else .x)
```

## Reduce and Accumulate

```r
# reduce - combine elements
reduce(x, `+`)
reduce(x, f, .init = 0)
reduce(list(df1, df2, df3), left_join, by = "id")

# reduce2 - with second list
reduce2(x, y, f)

# accumulate - keep intermediates
accumulate(x, `+`)
accumulate(x, f, .init = 0)
```

## Predicates

```r
# keep/discard
keep(x, is.numeric)
discard(x, is.na)
keep(x, ~ .x > 0)

# compact - remove NULL/empty
compact(x)

# every/some/none
every(x, is.numeric)
some(x, is.na)
none(x, is.null)

# detect - find first match
detect(x, ~ .x > 10)
detect_index(x, ~ .x > 10)

# head_while/tail_while
head_while(x, ~ .x > 0)
```

## Pluck and Assign

```r
# pluck - extract element
pluck(x, 1)
pluck(x, "name")
pluck(x, 1, "name", 2)
pluck(x, 1, .default = NA)

# chuck - strict pluck (error if missing)
chuck(x, 1)

# assign_in - modify nested
assign_in(x, list(1, "name"), "new_value")

# modify_in
modify_in(x, list(1, "name"), toupper)
```

## Safely and Possibly

```r
# safely - capture errors
safe_log <- safely(log)
result <- safe_log(-1)
result$result  # NULL
result$error   # Error message

results <- map(x, safely(f))
results %>% map("result") %>% compact()
results %>% map("error") %>% compact()

# possibly - default on error
safe_log <- possibly(log, otherwise = NA)
map_dbl(x, possibly(f, NA))

# quietly - capture messages/warnings
quiet_f <- quietly(f)
result <- quiet_f(x)
result$result
result$output
result$warnings
result$messages
```

## List Operations

```r
# flatten
flatten(x)
flatten_chr(x)
flatten_dbl(x)

# transpose
transpose(x)

# list_c/list_rbind/list_cbind
list_c(x)  # Combine to vector
list_rbind(x)  # Bind rows
list_cbind(x)  # Bind columns

# set_names
set_names(x, c("a", "b", "c"))
set_names(x, toupper)
```
