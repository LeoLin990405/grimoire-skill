---
name: survminer
description: R survminer package for survival visualization. Use for publication-ready Kaplan-Meier plots and forest plots.
---

# survminer

Publication-ready survival analysis plots.

## Kaplan-Meier Plots

```r
library(survminer)
library(survival)

# Fit survival
fit <- survfit(Surv(time, status) ~ sex, data = lung)

# Basic plot
ggsurvplot(fit, data = lung)

# With confidence intervals
ggsurvplot(fit, data = lung, conf.int = TRUE)

# With risk table
ggsurvplot(fit, data = lung, risk.table = TRUE)

# With p-value
ggsurvplot(fit, data = lung, pval = TRUE)

# With median survival
ggsurvplot(fit, data = lung, surv.median.line = "hv")
```

## Customization

```r
ggsurvplot(fit, data = lung,
  # Colors
  palette = c("#E7B800", "#2E9FDF"),

  # Line types
  linetype = "strata",

  # Confidence interval
  conf.int = TRUE,
  conf.int.style = "ribbon",

  # Risk table
  risk.table = TRUE,
  risk.table.col = "strata",

  # Labels
  legend.title = "Sex",
  legend.labs = c("Male", "Female"),
  xlab = "Time (days)",
  ylab = "Survival probability",

  # Theme
  ggtheme = theme_bw()
)
```

## Faceted Plots

```r
# Facet by variable
ggsurvplot_facet(fit, data = lung, facet.by = "ph.ecog")

# Multiple groups
ggsurvplot_list(list(fit1, fit2), data = lung)

# Combined plot
ggsurvplot_combine(list(fit1, fit2), data = lung)
```

## Risk Tables

```r
ggsurvplot(fit, data = lung,
  risk.table = TRUE,
  risk.table.height = 0.25,
  risk.table.y.text = FALSE,
  risk.table.title = "Number at risk",
  tables.theme = theme_cleantable()
)

# Cumulative events
ggsurvplot(fit, data = lung,
  cumevents = TRUE,
  cumcensor = TRUE
)
```

## Cox Model Visualization

```r
# Fit Cox model
cox_fit <- coxph(Surv(time, status) ~ age + sex + ph.ecog, data = lung)

# Forest plot
ggforest(cox_fit, data = lung)

# Adjusted survival curves
ggadjustedcurves(cox_fit, data = lung, variable = "sex")

# Survival curves at specific covariate values
new_data <- data.frame(age = c(50, 70), sex = 1, ph.ecog = 1)
fit_cox <- survfit(cox_fit, newdata = new_data)
ggsurvplot(fit_cox, data = lung)
```

## Statistical Tests

```r
# Log-rank test
surv_diff <- survdiff(Surv(time, status) ~ sex, data = lung)

# Pairwise comparisons
pairwise_survdiff(Surv(time, status) ~ ph.ecog, data = lung)

# Add p-value to plot
ggsurvplot(fit, data = lung,
  pval = TRUE,
  pval.method = TRUE,
  log.rank.weights = "1"  # Log-rank
)
```

## Cutpoint Analysis

```r
# Find optimal cutpoint
cut <- surv_cutpoint(lung, time = "time", event = "status",
                     variables = "age")

# Summary
summary(cut)

# Plot
plot(cut, "age")

# Categorize
lung_cat <- surv_categorize(cut)

# Fit with categories
fit_cat <- survfit(Surv(time, status) ~ age, data = lung_cat)
ggsurvplot(fit_cat, data = lung_cat, pval = TRUE)
```

## Cumulative Hazard

```r
# Cumulative hazard plot
ggsurvplot(fit, data = lung, fun = "cumhaz")

# Event plot
ggsurvplot(fit, data = lung, fun = "event")

# Log-log plot
ggsurvplot(fit, data = lung, fun = "cloglog")
```

## Publication Ready

```r
# Full publication plot
p <- ggsurvplot(fit, data = lung,
  pval = TRUE,
  conf.int = TRUE,
  risk.table = TRUE,
  risk.table.col = "strata",
  linetype = "strata",
  surv.median.line = "hv",
  ggtheme = theme_bw(),
  palette = c("#E7B800", "#2E9FDF"),
  title = "Survival by Sex",
  legend.title = "",
  legend.labs = c("Male", "Female"),
  font.main = c(14, "bold"),
  font.x = c(12, "plain"),
  font.y = c(12, "plain"),
  font.tickslab = c(10, "plain")
)

# Save
ggsave("survival_plot.pdf", print(p), width = 8, height = 6)
```

## Competing Risks

```r
library(cmprsk)

# Cumulative incidence
cif <- cuminc(lung$time, lung$status, lung$sex)

# Plot
ggcompetingrisks(cif)
```
