---
name: r-parallel-cpp
description: R high-performance with Rcpp, RcppParallel, RcppArmadillo. Use for C++ integration and optimization.
---

# R High-Performance Computing

C++ integration.

## Rcpp

```r
library(Rcpp)

# Inline C++
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

# Source file
sourceCpp("my_functions.cpp")
```

## C++ File (.cpp)

```cpp
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double sumC(NumericVector x) {
  int n = x.size();
  double total = 0;
  for(int i = 0; i < n; ++i) {
    total += x[i];
  }
  return total;
}

// [[Rcpp::export]]
NumericVector cumsumC(NumericVector x) {
  int n = x.size();
  NumericVector out(n);
  out[0] = x[0];
  for(int i = 1; i < n; ++i) {
    out[i] = out[i-1] + x[i];
  }
  return out;
}

// [[Rcpp::export]]
DataFrame createDF() {
  return DataFrame::create(
    Named("x") = NumericVector::create(1, 2, 3),
    Named("y") = CharacterVector::create("a", "b", "c")
  );
}
```

## RcppArmadillo

```cpp
// [[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>

// [[Rcpp::export]]
arma::mat matmultC(arma::mat A, arma::mat B) {
  return A * B;
}

// [[Rcpp::export]]
arma::vec solveC(arma::mat A, arma::vec b) {
  return arma::solve(A, b);
}

// [[Rcpp::export]]
Rcpp::List eigenC(arma::mat X) {
  arma::vec eigval;
  arma::mat eigvec;
  arma::eig_sym(eigval, eigvec, X);
  return Rcpp::List::create(
    Rcpp::Named("values") = eigval,
    Rcpp::Named("vectors") = eigvec
  );
}
```

## RcppParallel

```cpp
// [[Rcpp::depends(RcppParallel)]]
#include <Rcpp.h>
#include <RcppParallel.h>
using namespace RcppParallel;

struct SumWorker : public Worker {
  const RVector<double> input;
  double value;
  
  SumWorker(const NumericVector input) : input(input), value(0) {}
  SumWorker(const SumWorker& sum, Split) : input(sum.input), value(0) {}
  
  void operator()(std::size_t begin, std::size_t end) {
    value += std::accumulate(input.begin() + begin, input.begin() + end, 0.0);
  }
  
  void join(const SumWorker& rhs) { value += rhs.value; }
};

// [[Rcpp::export]]
double parallelSum(NumericVector x) {
  SumWorker sum(x);
  parallelReduce(0, x.length(), sum);
  return sum.value;
}
```
