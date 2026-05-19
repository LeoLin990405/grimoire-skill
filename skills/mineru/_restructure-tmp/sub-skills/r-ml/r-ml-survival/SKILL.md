---
name: r-ml-survival
description: R survival analysis. Use for Kaplan-Meier, Cox regression, survival curves with survival and survminer.
---

# R Survival Analysis

Time-to-event analysis.

## survival Package

```r
library(survival)

# Create survival object
surv_obj <- Surv(time = df$time, event = df$status)

# Kaplan-Meier estimate
km_fit <- survfit(surv_obj ~ 1)
summary(km_fit)
plot(km_fit)

# KM by group
km_fit <- survfit(surv_obj ~ group, data = df)
plot(km_fit, col = 1:2)

# Median survival
km_fit

# Cox proportional hazards
cox_model <- coxph(Surv(time, status) ~ age + sex + treatment, data = df)
summary(cox_model)

# Hazard ratios
exp(coef(cox_model))
exp(confint(cox_model))

# Test proportional hazards assumption
cox.zph(cox_model)
plot(cox.zph(cox_model))

# Stratified Cox
cox_model <- coxph(Surv(time, status) ~ age + strata(sex), data = df)
```

## survminer (Visualization)

```r
library(survminer)

# Kaplan-Meier plot
km_fit <- survfit(Surv(time, status) ~ group, data = df)

ggsurvplot(km_fit,
  data = df,
  pval = TRUE,
  conf.int = TRUE,
  risk.table = TRUE,
  risk.table.col = "strata",
  ggtheme = theme_minimal(),
  palette = c("#E7B800", "#2E9FDF")
)

# Customization
ggsurvplot(km_fit,
  data = df,
  pval = TRUE,
  pval.method = TRUE,
  log.rank.weights = "1",
  surv.median.line = "hv",
  legend.title = "Group",
  legend.labs = c("Control", "Treatment"),
  xlab = "Time (months)",
  ylab = "Survival probability",
  break.time.by = 12,
  xlim = c(0, 60)
)

# Forest plot for Cox model
ggforest(cox_model, data = df)

# Cumulative hazard
ggsurvplot(km_fit, fun = "cumhaz")

# Event plot
ggsurvplot(km_fit, fun = "event")
```

## Parametric Models

```r
library(survival)

# Weibull
weibull_model <- survreg(Surv(time, status) ~ age + sex, data = df, dist = "weibull")
summary(weibull_model)

# Exponential
exp_model <- survreg(Surv(time, status) ~ age + sex, data = df, dist = "exponential")

# Log-normal
lognorm_model <- survreg(Surv(time, status) ~ age + sex, data = df, dist = "lognormal")

# Predictions
predict(weibull_model, type = "response")  # Expected time
predict(weibull_model, type = "quantile", p = 0.5)  # Median
```

## Competing Risks

```r
library(cmprsk)

# Cumulative incidence
ci <- cuminc(df$time, df$status, df$group)
plot(ci)

# Fine-Gray model
fg_model <- crr(df$time, df$status, df[, c("age", "sex")])
summary(fg_model)
```

## Random Survival Forests

```r
library(randomForestSRC)

# Fit
rsf <- rfsrc(Surv(time, status) ~ ., data = df, ntree = 500)

# Variable importance
vimp(rsf)
plot(vimp(rsf))

# Predictions
pred <- predict(rsf, newdata = test)
pred$survival  # Survival curves
```

## Log-Rank Test

```r
# Compare survival curves
survdiff(Surv(time, status) ~ group, data = df)

# Pairwise comparisons
pairwise_survdiff(Surv(time, status) ~ group, data = df)
```
