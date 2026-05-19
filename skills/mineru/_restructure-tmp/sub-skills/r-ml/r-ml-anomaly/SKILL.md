---
name: r-ml-anomaly
description: R anomaly detection. Use for outlier detection, breakpoint detection with AnomalyDetection, anomalize, and changepoint.
---

# R Anomaly Detection

Outlier and anomaly detection.

## AnomalyDetection (Twitter)

```r
library(AnomalyDetection)

# Time series anomaly detection
result <- AnomalyDetectionTs(
  df,  # data.frame with timestamp and count columns
  max_anoms = 0.02,
  direction = "both",  # "pos", "neg", or "both"
  alpha = 0.05,
  only_last = "day",  # "day", "hr", or NULL
  plot = TRUE
)

# Results
result$anoms  # Anomalies
result$plot   # Plot

# Vector anomaly detection (no timestamps)
result <- AnomalyDetectionVec(
  values,
  max_anoms = 0.02,
  direction = "both",
  period = 24,  # Seasonality period
  plot = TRUE
)
```

## anomalize (Tidy)

```r
library(anomalize)
library(tibbletime)

# Prepare data
df_ts <- df %>%
  as_tbl_time(index = date)

# Detect anomalies
result <- df_ts %>%
  time_decompose(value, method = "stl") %>%
  anomalize(remainder, method = "iqr") %>%
  time_recompose()

# Plot
result %>% plot_anomalies()
result %>% plot_anomaly_decomposition()

# Get anomalies
anomalies <- result %>%
  filter(anomaly == "Yes")

# Methods
# Decomposition: "stl", "twitter"
# Anomaly detection: "iqr", "gesd"
```

## BreakoutDetection (Twitter)

```r
library(BreakoutDetection)

# Detect breakouts (mean shifts)
result <- breakout(
  df$value,
  min.size = 24,
  method = "multi",
  beta = 0.001,
  degree = 1,
  plot = TRUE
)

# Results
result$loc  # Breakpoint locations
result$plot
```

## changepoint

```r
library(changepoint)

# Mean change
cpt_mean <- cpt.mean(values, method = "PELT")
plot(cpt_mean)
cpts(cpt_mean)  # Changepoint locations

# Variance change
cpt_var <- cpt.var(values, method = "PELT")

# Mean and variance
cpt_meanvar <- cpt.meanvar(values, method = "PELT")

# Multiple changepoints
cpt_multi <- cpt.mean(values, method = "BinSeg", Q = 5)
```

## Isolation Forest

```r
library(isotree)

# Fit isolation forest
model <- isolation.forest(df, ntrees = 100)

# Anomaly scores (higher = more anomalous)
scores <- predict(model, df)

# Threshold
threshold <- quantile(scores, 0.95)
anomalies <- df[scores > threshold, ]
```

## LOF (Local Outlier Factor)

```r
library(dbscan)

# Compute LOF scores
lof_scores <- lof(df, minPts = 5)

# Identify outliers
outliers <- which(lof_scores > 1.5)
```

## Statistical Methods

```r
# Z-score
z_scores <- scale(values)
outliers <- which(abs(z_scores) > 3)

# IQR method
Q1 <- quantile(values, 0.25)
Q3 <- quantile(values, 0.75)
IQR <- Q3 - Q1
lower <- Q1 - 1.5 * IQR
upper <- Q3 + 1.5 * IQR
outliers <- which(values < lower | values > upper)

# Mahalanobis distance
mah_dist <- mahalanobis(df, colMeans(df), cov(df))
outliers <- which(mah_dist > qchisq(0.99, df = ncol(df)))

# Grubbs test
library(outliers)
grubbs.test(values)
```

## CausalImpact (Google)

```r
library(CausalImpact)

# Prepare data (pre/post intervention)
pre_period <- c(1, 70)
post_period <- c(71, 100)

# Estimate causal impact
impact <- CausalImpact(data, pre_period, post_period)

# Results
summary(impact)
summary(impact, "report")
plot(impact)
```
