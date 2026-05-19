---
name: reticulate
description: R reticulate package for Python integration. Use for calling Python from R, importing Python modules, and data exchange.
---

# reticulate

R interface to Python.

## Setup

```r
library(reticulate)

# Use specific Python
use_python("/usr/bin/python3")
use_virtualenv("myenv")
use_condaenv("myenv")

# Check configuration
py_config()
py_available()
```

## Import Modules

```r
# Import Python modules
np <- import("numpy")
pd <- import("pandas")
sklearn <- import("sklearn")

# Import with conversion disabled
np <- import("numpy", convert = FALSE)

# Import submodules
preprocessing <- import("sklearn.preprocessing")
```

## Call Python

```r
# Run Python code
py_run_string("x = 1 + 1")
py_run_file("script.py")

# Access Python objects
py$x
py$my_function(arg1, arg2)

# Execute in main module
py_run_string("
import pandas as pd
df = pd.DataFrame({'a': [1,2,3]})
")
py$df
```

## Data Conversion

```r
# R to Python
py_df <- r_to_py(mtcars)

# Python to R
r_df <- py_to_r(py$df)

# Automatic conversion (default)
np$array(c(1, 2, 3))  # Returns R vector

# Disable conversion
np <- import("numpy", convert = FALSE)
arr <- np$array(c(1, 2, 3))  # Returns Python object
py_to_r(arr)  # Explicit conversion
```

## NumPy Integration

```r
np <- import("numpy")

# Create arrays
arr <- np$array(matrix(1:9, 3, 3))
arr <- np$zeros(c(3L, 3L))
arr <- np$ones(c(3L, 3L))

# Array operations
np$sum(arr)
np$mean(arr)
np$dot(arr, arr)

# Convert to R
as.matrix(arr)
```

## Pandas Integration

```r
pd <- import("pandas")

# Create DataFrame
py_df <- pd$DataFrame(list(
  a = 1:3,
  b = c("x", "y", "z")
))

# Read files
py_df <- pd$read_csv("data.csv")
py_df <- pd$read_excel("data.xlsx")

# Convert to R
r_df <- py_to_r(py_df)

# R data frame to pandas
py_df <- r_to_py(mtcars)
```

## Scikit-learn

```r
sklearn <- import("sklearn")
preprocessing <- import("sklearn.preprocessing")
model_selection <- import("sklearn.model_selection")

# Preprocessing
scaler <- preprocessing$StandardScaler()
X_scaled <- scaler$fit_transform(X)

# Train/test split
split <- model_selection$train_test_split(X, y, test_size = 0.2)
X_train <- split[[1]]
X_test <- split[[2]]

# Models
linear_model <- import("sklearn.linear_model")
model <- linear_model$LogisticRegression()
model$fit(X_train, y_train)
predictions <- model$predict(X_test)
```

## Virtual Environments

```r
# Create virtualenv
virtualenv_create("myenv")

# Install packages
virtualenv_install("myenv", "pandas")
virtualenv_install("myenv", c("numpy", "scikit-learn"))

# Use virtualenv
use_virtualenv("myenv")

# List packages
virtualenv_list()
py_list_packages("myenv")
```

## Conda Environments

```r
# Create conda env
conda_create("myenv", packages = c("pandas", "numpy"))

# Install packages
conda_install("myenv", "scikit-learn")

# Use conda env
use_condaenv("myenv")

# List environments
conda_list()
```

## Source Python Files

```r
# Source Python script
source_python("functions.py")

# Functions become available
my_python_function(arg1, arg2)
```

## Error Handling

```r
# Catch Python errors
tryCatch({
  py_run_string("raise ValueError('error')")
}, error = function(e) {
  message("Python error: ", conditionMessage(e))
})

# Check for None
if (is.null(py_to_r(result))) {
  message("Result is None")
}
```

## Interactive Python

```r
# Start Python REPL
repl_python()
# Type 'exit' to return to R

# In RMarkdown
```{python}
import pandas as pd
df = pd.DataFrame({'x': [1,2,3]})
```
```

## Best Practices

```r
# 1. Specify Python version
use_python("/usr/bin/python3", required = TRUE)

# 2. Use virtual environments
use_virtualenv("project_env")

# 3. Handle conversion explicitly for large data
np <- import("numpy", convert = FALSE)

# 4. Check availability
if (py_module_available("pandas")) {
  pd <- import("pandas")
}
```
