---
name: cpp11
description: R cpp11 package for C++ integration. Use for modern C++11 integration with R.
---

# cpp11

A header-only C++11 interface for R.

## Basic Function

```cpp
// myfile.cpp
#include "cpp11.hpp"
using namespace cpp11;

[[cpp11::register]]
double sum_cpp(doubles x) {
  double total = 0;
  for (double val : x) {
    total += val;
  }
  return total;
}
```

```r
cpp11::cpp_source("myfile.cpp")
sum_cpp(1:10)
```

## Vector Types

```cpp
// Read-only vectors
doubles x;      // NumericVector
integers i;     // IntegerVector
strings s;      // CharacterVector
logicals l;     // LogicalVector
raws r;         // RawVector
list lst;       // List

// Writable vectors
writable::doubles x;
writable::integers i;
writable::strings s;
writable::logicals l;
```

## Creating Vectors

```cpp
[[cpp11::register]]
doubles create_vec() {
  writable::doubles x(10);
  for (int i = 0; i < 10; i++) {
    x[i] = i * 2.0;
  }
  return x;
}
```

## Named Vectors

```cpp
[[cpp11::register]]
doubles named_vec() {
  using namespace cpp11::literals;
  writable::doubles x({"a"_nm = 1.0, "b"_nm = 2.0});
  return x;
}
```

## Lists

```cpp
[[cpp11::register]]
list return_list(doubles x) {
  using namespace cpp11::literals;
  writable::list result;
  result.push_back({"mean"_nm = mean(x)});
  result.push_back({"data"_nm = x});
  return result;
}
```

## Data Frames

```cpp
[[cpp11::register]]
data_frame create_df() {
  using namespace cpp11::literals;
  writable::doubles x = {1.0, 2.0, 3.0};
  writable::strings y = {"a", "b", "c"};
  return writable::data_frame({
    "x"_nm = x,
    "y"_nm = y
  });
}
```

## Matrices

```cpp
[[cpp11::register]]
doubles_matrix<> mat_ops(doubles_matrix<> m) {
  int nrow = m.nrow();
  int ncol = m.ncol();

  writable::doubles_matrix<> result(nrow, ncol);
  for (int i = 0; i < nrow; i++) {
    for (int j = 0; j < ncol; j++) {
      result(i, j) = m(i, j) * 2;
    }
  }
  return result;
}
```

## Attributes

```cpp
[[cpp11::register]]
doubles with_attrs(doubles x) {
  writable::doubles y(x);
  y.attr("class") = "myclass";
  return y;
}
```

## Package Integration

```r
# In package DESCRIPTION
LinkingTo: cpp11

# In R/
#' @useDynLib mypackage, .registration = TRUE
NULL
```

## Comparison with Rcpp

```cpp
// cpp11 advantages:
// - Header-only (no compilation of Rcpp)
// - Modern C++11 features
// - ALTREP support
// - Stricter type safety
// - No R API macros
```
