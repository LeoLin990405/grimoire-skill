---
name: arules
description: R arules package for association rules. Use for mining frequent itemsets and association rules.
---

# arules

Mining association rules and frequent itemsets.

## Transactions

```r
library(arules)

# From list
trans_list <- list(
  c("milk", "bread", "butter"),
  c("milk", "bread"),
  c("milk", "eggs"),
  c("bread", "butter", "eggs")
)
trans <- as(trans_list, "transactions")

# From data frame (binary)
trans <- as(df, "transactions")

# From CSV
trans <- read.transactions("basket.csv", format = "basket", sep = ",")
trans <- read.transactions("single.csv", format = "single", cols = c(1, 2))
```

## Inspect Transactions

```r
# Summary
summary(trans)

# View items
inspect(trans[1:5])

# Item frequency
itemFrequency(trans)
itemFrequency(trans, type = "absolute")

# Plot frequency
itemFrequencyPlot(trans, topN = 20)
```

## Apriori Algorithm

```r
# Mine frequent itemsets
itemsets <- apriori(trans,
  parameter = list(
    support = 0.01,
    target = "frequent itemsets"
  )
)

# Mine association rules
rules <- apriori(trans,
  parameter = list(
    support = 0.01,
    confidence = 0.5,
    minlen = 2
  )
)
```

## Rule Parameters

```r
rules <- apriori(trans,
  parameter = list(
    support = 0.01,      # Minimum support
    confidence = 0.5,    # Minimum confidence
    minlen = 2,          # Minimum items in rule
    maxlen = 10,         # Maximum items in rule
    target = "rules"     # "rules", "frequent itemsets", "maximally frequent itemsets"
  )
)
```

## Inspect Rules

```r
# Summary
summary(rules)

# View rules
inspect(rules)
inspect(head(sort(rules, by = "lift"), 10))

# Quality measures
quality(rules)
```

## Rule Measures

```r
# Support: P(A ∪ B)
# Confidence: P(B|A) = P(A ∪ B) / P(A)
# Lift: P(B|A) / P(B)

# Additional measures
interestMeasure(rules, c("chiSquared", "conviction", "leverage"), trans)
```

## Filtering Rules

```r
# By quality
high_conf <- subset(rules, confidence > 0.8)
high_lift <- subset(rules, lift > 2)

# By items
milk_rules <- subset(rules, items %in% "milk")
lhs_milk <- subset(rules, lhs %in% "milk")
rhs_milk <- subset(rules, rhs %in% "milk")

# Redundant rules
non_redundant <- rules[!is.redundant(rules)]
```

## Sorting Rules

```r
# Sort by measure
sorted <- sort(rules, by = "confidence", decreasing = TRUE)
sorted <- sort(rules, by = "lift")
sorted <- sort(rules, by = "support")

# Top N rules
top_rules <- head(sort(rules, by = "lift"), 20)
```

## Visualization

```r
library(arulesViz)

# Scatter plot
plot(rules)
plot(rules, measure = c("support", "lift"), shading = "confidence")

# Graph
plot(rules, method = "graph", limit = 20)

# Grouped matrix
plot(rules, method = "grouped")

# Parallel coordinates
plot(rules, method = "paracoord")
```

## ECLAT Algorithm

```r
# Faster for frequent itemsets
itemsets <- eclat(trans,
  parameter = list(
    support = 0.01,
    minlen = 2
  )
)
```

## Closed/Maximal Itemsets

```r
# Closed itemsets
closed <- apriori(trans,
  parameter = list(
    support = 0.01,
    target = "closed frequent itemsets"
  )
)

# Maximal itemsets
maximal <- apriori(trans,
  parameter = list(
    support = 0.01,
    target = "maximally frequent itemsets"
  )
)
```

## Save/Load

```r
# Save rules
write(rules, file = "rules.csv", sep = ",")

# Save as RDS
saveRDS(rules, "rules.rds")
rules <- readRDS("rules.rds")
```
