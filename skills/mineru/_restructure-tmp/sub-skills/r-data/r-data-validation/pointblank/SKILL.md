---
name: pointblank
description: R pointblank package for data quality. Use for data validation and quality reporting.
---

# pointblank

Data quality assessment and reporting.

## Create Agent

```r
library(pointblank)

# Create validation agent
agent <- create_agent(df) %>%
  col_vals_gt(vars(age), 0) %>%
  col_vals_lt(vars(age), 120) %>%
  col_vals_not_null(vars(name)) %>%
  col_is_numeric(vars(income)) %>%
  interrogate()

# View report
agent
```

## Validation Functions

```r
agent <- create_agent(df) %>%
  # Value comparisons
  col_vals_gt(vars(x), 0) %>%
  col_vals_gte(vars(x), 0) %>%
  col_vals_lt(vars(x), 100) %>%
  col_vals_lte(vars(x), 100) %>%
  col_vals_equal(vars(x), 1) %>%
  col_vals_not_equal(vars(x), 0) %>%
  col_vals_between(vars(x), 0, 100) %>%

  # Set membership
  col_vals_in_set(vars(status), c("A", "B", "C")) %>%
  col_vals_not_in_set(vars(status), c("X", "Y")) %>%

  # Null checks
  col_vals_null(vars(x)) %>%

  col_vals_not_null(vars(x)) %>%

  # Pattern matching
  col_vals_regex(vars(email), "^[a-z]+@") %>%

  interrogate()
```

## Column Checks

```r
agent <- create_agent(df) %>%
  # Type checks
  col_is_numeric(vars(age)) %>%
  col_is_character(vars(name)) %>%
  col_is_date(vars(date)) %>%
  col_is_logical(vars(flag)) %>%

  # Existence
  col_exists(vars(id, name, age)) %>%

  interrogate()
```

## Row Checks

```r
agent <- create_agent(df) %>%
  # Row count
  row_count_match(100) %>%

  # Distinct rows
  rows_distinct() %>%

  # Complete rows
  rows_complete() %>%

  interrogate()
```

## Actions

```r
# Define actions
al <- action_levels(
  warn_at = 0.1,   # Warn if >10% fail
  stop_at = 0.25,  # Stop if >25% fail
  notify_at = 0.05
)

agent <- create_agent(df, actions = al) %>%
  col_vals_not_null(vars(id)) %>%
  interrogate()
```

## Reporting

```r
# Get report
get_agent_report(agent)

# Export report
export_report(agent, filename = "report.html")

# X-list (detailed results)
get_agent_x_list(agent)
```

## Informant

```r
# Create data dictionary
informant <- create_informant(df) %>%
  info_tabular(
    description = "Customer data"
  ) %>%
  info_columns(
    columns = vars(id),
    info = "Unique identifier"
  ) %>%
  incorporate()
```

## YAML Workflow

```r
# Export to YAML
yaml_write(agent, filename = "validation.yaml")

# Read and run
agent <- yaml_read_agent("validation.yaml") %>%
  interrogate()
```
