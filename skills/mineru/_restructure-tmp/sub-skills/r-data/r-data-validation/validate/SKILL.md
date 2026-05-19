---
name: validate
description: R validate package for data validation. Use for defining and checking data validation rules.
---

# validate

Data validation infrastructure.

## Define Rules

```r
library(validate)

# Create validator
rules <- validator(
  age >= 0,
  age <= 120,
  income >= 0,
  !is.na(name)
)

# From expressions
rules <- validator(
  positive_age = age >= 0,
  valid_income = income > 0,
  has_name = nchar(name) > 0
)
```

## Check Data

```r
# Confront data with rules
result <- confront(df, rules)

# Summary
summary(result)

# Values (TRUE/FALSE/NA)
values(result)

# As data frame
as.data.frame(result)
```

## Rule Types

```r
rules <- validator(
  # Range checks
  age %in% 0:120,

  # Pattern matching
  grepl("^[A-Z]", name),

  # Cross-field validation
  end_date >= start_date,

  # Aggregates
  mean(income) > 0,

  # Uniqueness
  is_unique(id),

  # Completeness
  is_complete(name, age)
)
```

## Indicators

```r
# Define indicators (metrics)
ind <- indicator(
  mean_age = mean(age, na.rm = TRUE),
  pct_missing = mean(is.na(income)) * 100,
  n_records = .N
)

# Add to confrontation
add_indicator(result, ind)
```

## Export Rules

```r
# Export to YAML
export_yaml(rules, "rules.yaml")

# Import from YAML
rules <- validator(.file = "rules.yaml")

# Export to data frame
as.data.frame(rules)
```

## Reporting

```r
# Barplot of results
barplot(result)

# Aggregate by rule
aggregate(result)

# Aggregate by record
aggregate(result, by = "record")
```

## Error Localization

```r
# Find erroneous values
errors <- values(result)
df[!errors[, "positive_age"], ]
```

## Rule Metadata

```r
# Add descriptions
rules <- validator(
  age >= 0,
  .description = "Age must be non-negative"
)

# Get rule info
meta(rules)
```
