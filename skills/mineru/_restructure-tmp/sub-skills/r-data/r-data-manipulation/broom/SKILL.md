---
name: broom
description: R broom package for tidying model outputs. Use for converting statistical model results to tidy data frames.
---

# broom

Convert statistical objects into tidy data frames.

## Core Functions

```r
library(broom)

# Fit a model
model <- lm(mpg ~ wt + hp, data = mtcars)

# tidy() - coefficient-level statistics
tidy(model)
# Returns: term, estimate, std.error, statistic, p.value

# glance() - model-level statistics
glance(model)
# Returns: r.squared, adj.r.squared, sigma, statistic, p.value, df, etc.

# augment() - observation-level statistics
augment(model)
# Returns: original data + .fitted, .resid, .hat, .sigma, .cooksd, .std.resid
```

## Linear Models

```r
# lm
model <- lm(y ~ x1 + x2, data = df)
tidy(model, conf.int = TRUE, conf.level = 0.95)

# glm
model <- glm(y ~ x, data = df, family = binomial)
tidy(model, exponentiate = TRUE)  # Odds ratios

# Robust standard errors
library(sandwich)
tidy(model, vcov = vcovHC)
```

## Statistical Tests

```r
# t-test
t_result <- t.test(x, y)
tidy(t_result)

# Correlation
cor_result <- cor.test(x, y)
tidy(cor_result)

# Chi-squared
chisq_result <- chisq.test(table(x, y))
tidy(chisq_result)

# ANOVA
aov_result <- aov(y ~ group, data = df)
tidy(aov_result)
```

## Survival Analysis

```r
library(survival)

# Cox model
cox_model <- coxph(Surv(time, status) ~ age + sex, data = df)
tidy(cox_model, exponentiate = TRUE)  # Hazard ratios
glance(cox_model)

# Kaplan-Meier
km_fit <- survfit(Surv(time, status) ~ group, data = df)
tidy(km_fit)
```

## Machine Learning Models

```r
# Random forest (ranger)
library(ranger)
rf_model <- ranger(y ~ ., data = df, importance = "impurity")
tidy(rf_model)  # Variable importance

# kmeans
km <- kmeans(df, centers = 3)
tidy(km)      # Cluster centers
glance(km)    # Clustering metrics
augment(km, df)  # Cluster assignments
```

## Multiple Models

```r
library(dplyr)
library(purrr)

# Fit models by group
models <- df %>%
  group_by(category) %>%
  nest() %>%
  mutate(
    model = map(data, ~ lm(y ~ x, data = .x)),
    tidied = map(model, tidy),
    glanced = map(model, glance)
  )

# Extract results
models %>%
  unnest(tidied)

models %>%
  unnest(glanced)
```

## Augment for Diagnostics

```r
model <- lm(y ~ x, data = df)

# Get fitted values and residuals
augmented <- augment(model)

# Plot residuals
library(ggplot2)
ggplot(augmented, aes(.fitted, .resid)) +
  geom_point() +
  geom_hline(yintercept = 0)

# Identify influential points
augmented %>%
  filter(.cooksd > 4 / nrow(df))
```

## Custom Tidiers

```r
# For unsupported models, create custom tidier
tidy.my_model <- function(x, ...) {

  tibble(
    term = names(coef(x)),
    estimate = coef(x),
    std.error = sqrt(diag(vcov(x)))
  )
}
```

## Supported Models

```r
# broom supports 100+ model types including:
# - lm, glm, nls
# - survival (coxph, survfit)
# - lme4 (lmer, glmer)
# - mgcv (gam)
# - MASS (rlm, glm.nb)
# - stats (t.test, cor.test, chisq.test)
# - And many more...

# Check if model is supported
methods(tidy)
methods(glance)
methods(augment)
```
