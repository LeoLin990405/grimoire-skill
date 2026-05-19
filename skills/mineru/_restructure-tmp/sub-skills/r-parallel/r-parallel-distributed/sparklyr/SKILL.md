---
name: sparklyr
description: R sparklyr package for Apache Spark. Use for distributed data processing with dplyr interface.
---

# sparklyr Package

R interface to Apache Spark.

## Connect

```r
library(sparklyr)
library(dplyr)

# Local mode
sc <- spark_connect(master = "local")

# Cluster
sc <- spark_connect(master = "yarn")
sc <- spark_connect(master = "spark://host:7077")
```

## Data Transfer

```r
# Copy to Spark
spark_df <- copy_to(sc, local_df, "my_table")

# Read from Spark
local_df <- collect(spark_df)

# Read files
spark_df <- spark_read_csv(sc, "data", "path/to/file.csv")
spark_df <- spark_read_parquet(sc, "data", "path/to/file.parquet")
spark_df <- spark_read_json(sc, "data", "path/to/file.json")
```

## dplyr Operations

```r
result <- spark_df %>%
  filter(year == 2023) %>%
  group_by(category) %>%
  summarise(
    count = n(),
    avg_value = mean(value)
  ) %>%
  arrange(desc(count))

# View SQL
show_query(result)

# Execute
collected <- collect(result)
```

## Machine Learning

```r
# Split data
partitions <- sdf_random_split(spark_df, training = 0.8, test = 0.2)

# Linear regression
model <- partitions$training %>%
  ml_linear_regression(y ~ x1 + x2)

# Predictions
predictions <- ml_predict(model, partitions$test)

# Random forest
model <- partitions$training %>%
  ml_random_forest(y ~ ., type = "classification")
```

## Write Data

```r
spark_write_csv(spark_df, "output.csv")
spark_write_parquet(spark_df, "output.parquet")
```

## Disconnect

```r
spark_disconnect(sc)
```
