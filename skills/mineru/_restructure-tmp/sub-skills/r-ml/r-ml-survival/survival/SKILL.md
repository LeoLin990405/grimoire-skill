---
name: survival
description: R survival package for survival analysis. Use for Kaplan-Meier curves, Cox regression, and time-to-event analysis.
---

# survival

Core survival analysis functions.

## Survival Objects

```r
library(survival)

# Create survival object
Surv(time, event)
Surv(time, time2, event)  # Interval censoring
Surv(time, event, type = "right")

# Example
surv_obj <- Surv(df$time, df$status)
```

## Kaplan-Meier Estimation

```r
# Fit KM curve
km_fit <- survfit(Surv(time, status) ~ 1, data = df)

# By group
km_fit <- survfit(Surv(time, status) ~ group, data = df)

# Summary
summary(km_fit)
summary(km_fit, times = c(30, 60, 90))

# Median survival
km_fit

# Plot
plot(km_fit)
plot(km_fit, conf.int = TRUE)
```

## Cox Proportional Hazards

```r
# Fit Cox model
cox_fit <- coxph(Surv(time, status) ~ age + sex + treatment, data = df)

# Summary
summary(cox_fit)

# Hazard ratios
exp(coef(cox_fit))
exp(confint(cox_fit))

# Test proportional hazards
cox.zph(cox_fit)
plot(cox.zph(cox_fit))
```

## Stratified Cox Model

```r
# Stratify by variable
cox_fit <- coxph(Surv(time, status) ~ age + strata(sex), data = df)

# Multiple strata
cox_fit <- coxph(Surv(time, status) ~ age + strata(sex, center), data = df)
```

## Time-Varying Covariates

```r
# Create time-varying dataset
tvc_data <- tmerge(df, df, id = id,
                   tstop = time,
                   event = event(time, status))

# Add time-varying covariate
tvc_data <- tmerge(tvc_data, covariate_df, id = id,
                   trt = tdc(start_time, treatment))

# Fit model
cox_fit <- coxph(Surv(tstart, tstop, event) ~ trt + age, data = tvc_data)
```

## Parametric Models

```r
# Weibull
weibull_fit <- survreg(Surv(time, status) ~ age + sex,
                       data = df, dist = "weibull")

# Exponential
exp_fit <- survreg(Surv(time, status) ~ age + sex,
                   data = df, dist = "exponential")

# Log-normal
lnorm_fit <- survreg(Surv(time, status) ~ age + sex,
                     data = df, dist = "lognormal")

# Log-logistic
llog_fit <- survreg(Surv(time, status) ~ age + sex,
                    data = df, dist = "loglogistic")
```

## Predictions

```r
# Survival curves from Cox model
surv_pred <- survfit(cox_fit, newdata = new_df)

# Predicted survival at specific times
summary(surv_pred, times = c(30, 60, 90))

# Baseline hazard
basehaz(cox_fit)
```

## Log-Rank Test

```r
# Compare survival curves
survdiff(Surv(time, status) ~ group, data = df)

# Stratified test
survdiff(Surv(time, status) ~ treatment + strata(center), data = df)
```

## Concordance

```r
# C-statistic
concordance(cox_fit)

# Manual calculation
survConcordance(Surv(time, status) ~ predict(cox_fit), data = df)
```

## Residuals

```r
# Martingale residuals
residuals(cox_fit, type = "martingale")

# Deviance residuals
residuals(cox_fit, type = "deviance")

# Schoenfeld residuals
residuals(cox_fit, type = "schoenfeld")

# Score residuals
residuals(cox_fit, type = "score")
```

## Frailty Models

```r
# Gamma frailty
cox_fit <- coxph(Surv(time, status) ~ age + frailty(cluster), data = df)

# Gaussian frailty
cox_fit <- coxph(Surv(time, status) ~ age + frailty(cluster, distribution = "gaussian"),
                 data = df)
```
