---
name: r-parallel-distributed
description: R distributed computing with sparklyr, future.batchtools. Use for cluster and cloud computing.
---

# R Distributed Computing

Cluster and cloud computing.

## sparklyr

```r
library(sparklyr)

# Connect
sc <- spark_connect(master = "local")
sc <- spark_connect(master = "yarn")

# Copy data
sdf <- copy_to(sc, df, "my_table")
sdf <- spark_read_csv(sc, "data", "path/to/file.csv")
spark_read_parquet(sc, "data", "path/to/file.parquet")

# dplyr operations
result <- sdf %>%
  filter(x > 0) %>%
  group_by(category) %>%
  summarize(mean_x = mean(x)) %>%
  collect()

# SQL
sdf <- sdf_sql(sc, "SELECT * FROM my_table WHERE x > 0")

# ML
model <- sdf %>%
  ml_linear_regression(y ~ x1 + x2)

predictions <- ml_predict(model, new_data)

# Disconnect
spark_disconnect(sc)
```

## future.batchtools

```r
library(future.batchtools)

# SLURM
plan(batchtools_slurm, workers = 100)

# SGE
plan(batchtools_sge)

# Custom template
plan(batchtools_slurm,
  template = "slurm.tmpl",
  resources = list(
    walltime = "01:00:00",
    memory = "4G",
    ncpus = 1
  )
)

# Submit jobs
results <- future_map(1:1000, process_task)
```

## batchtools

```r
library(batchtools)

# Create registry
reg <- makeRegistry(file.dir = "registry")

# Define jobs
batchMap(fun = my_function, args = list(x = 1:100), reg = reg)

# Submit
submitJobs(reg = reg)

# Status
getStatus(reg = reg)
getJobTable(reg = reg)

# Results
reduceResults(reg = reg)
loadResult(1, reg = reg)
```

## clustermq

```r
library(clustermq)

# Options
options(clustermq.scheduler = "slurm")

# Submit
results <- Q(
  fun = my_function,
  x = 1:100,
  n_jobs = 10
)

# With data
results <- Q(
  fun = my_function,
  x = 1:100,
  const = list(data = my_data),
  export = list(helper_function = helper_function)
)
```
