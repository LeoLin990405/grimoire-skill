---
name: Rcpp
description: R Rcpp package for C++ integration. Use for writing high-performance C++ code callable from R.
---

# Rcpp Package

Seamless R and C++ integration.

## Inline C++

```r
library(Rcpp)

cppFunction('
  double sumC(NumericVector x) {
    int n = x.size();
    double total = 0;
    for(int i = 0; i < n; ++i) {
      total += x[i];
    }
    return total;
  }
')

sumC(1:1000000)
```

## Source File

```cpp
// mycode.cpp
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double meanC(NumericVector x) {
  int n = x.size();
  double total = 0;
  for(int i = 0; i < n; ++i) {
    total += x[i];
  }
  return total / n;
}
```

```r
sourceCpp("mycode.cpp")
meanC(1:100)
```

## Data Types

```cpp
// Vectors
NumericVector x;
IntegerVector y;
CharacterVector z;
LogicalVector b;

// Matrices
NumericMatrix m;

// Lists
List L;

// Data frames
DataFrame df;
```

## Vector Operations

```cpp
// [[Rcpp::export]]
NumericVector squareC(NumericVector x) {
  int n = x.size();
  NumericVector out(n);
  for(int i = 0; i < n; ++i) {
    out[i] = x[i] * x[i];
  }
  return out;
}

// Sugar (vectorized)
// [[Rcpp::export]]
NumericVector squareSugar(NumericVector x) {
  return x * x;
}
```

## Return List

```cpp
// [[Rcpp::export]]
List statsC(NumericVector x) {
  return List::create(
    Named("mean") = mean(x),
    Named("sd") = sd(x),
    Named("min") = min(x),
    Named("max") = max(x)
  );
}
```

## STL Algorithms

```cpp
#include <algorithm>

// [[Rcpp::export]]
NumericVector sortC(NumericVector x) {
  NumericVector y = clone(x);
  std::sort(y.begin(), y.end());
  return y;
}
```
