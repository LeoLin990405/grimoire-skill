---
name: Rcpp
description: R Rcpp package for C++ integration. Use for seamless R and C++ integration.
---

# Rcpp

Seamless R and C++ integration.

## Basic Function

```cpp
// myfile.cpp
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double sumC(NumericVector x) {
  int n = x.size();
  double total = 0;
  for (int i = 0; i < n; i++) {
    total += x[i];
  }
  return total;
}
```

```r
library(Rcpp)
sourceCpp("myfile.cpp")
sumC(1:10)
```

## Inline C++

```r
library(Rcpp)

cppFunction('
  double sumC(NumericVector x) {
    int n = x.size();
    double total = 0;
    for (int i = 0; i < n; i++) {
      total += x[i];
    }
    return total;
  }
')

sumC(1:10)
```

## Vector Types

```cpp
// Numeric
NumericVector x;
NumericMatrix m;

// Integer
IntegerVector x;
IntegerMatrix m;

// Character
CharacterVector x;

// Logical
LogicalVector x;

// List
List L;

// DataFrame
DataFrame df;
```

## Vector Operations

```cpp
// [[Rcpp::export]]
NumericVector vecOps(NumericVector x) {
  // Create vector
  NumericVector y(10);
  NumericVector z = clone(x);

  // Access elements
  double first = x[0];
  double last = x[x.size() - 1];

  // Named access
  x["a"] = 1.0;

  // Sugar functions
  NumericVector result = sqrt(x) + log(x);

  return result;
}
```

## Matrix Operations

```cpp
// [[Rcpp::export]]
NumericMatrix matOps(NumericMatrix m) {
  int nrow = m.nrow();
  int ncol = m.ncol();

  // Access element
  double val = m(0, 0);

  // Row/column
  NumericVector row = m.row(0);
  NumericVector col = m.column(0);

  return m;
}
```

## Return List

```cpp
// [[Rcpp::export]]
List returnList(NumericVector x) {
  return List::create(
    Named("mean") = mean(x),
    Named("sd") = sd(x),
    Named("data") = x
  );
}
```

## DataFrame

```cpp
// [[Rcpp::export]]
DataFrame createDF() {
  return DataFrame::create(
    Named("x") = NumericVector::create(1, 2, 3),
    Named("y") = CharacterVector::create("a", "b", "c")
  );
}
```

## Sugar Functions

```cpp
// Rcpp sugar provides R-like syntax
NumericVector y = abs(x);
NumericVector y = sqrt(x);
NumericVector y = exp(x);
NumericVector y = log(x);
double s = sum(x);
double m = mean(x);
double v = var(x);
double sd = sd(x);
double mn = min(x);
double mx = max(x);
```

## Attributes

```cpp
// [[Rcpp::export]]
NumericVector withAttrs(NumericVector x) {
  x.attr("dim") = IntegerVector::create(2, 5);
  x.attr("class") = "myclass";
  return x;
}
```
