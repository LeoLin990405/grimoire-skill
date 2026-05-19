---
name: RcppParallel
description: R RcppParallel package for parallel C++. Use for multi-threaded C++ code with Intel TBB.
---

# RcppParallel Package

Parallel programming with Rcpp using Intel TBB.

## Setup

```cpp
// [[Rcpp::depends(RcppParallel)]]
#include <Rcpp.h>
#include <RcppParallel.h>
using namespace Rcpp;
using namespace RcppParallel;
```

## Parallel For

```cpp
struct SquareWorker : public Worker {
  const RVector<double> input;
  RVector<double> output;

  SquareWorker(const NumericVector input, NumericVector output)
    : input(input), output(output) {}

  void operator()(std::size_t begin, std::size_t end) {
    for (std::size_t i = begin; i < end; i++) {
      output[i] = input[i] * input[i];
    }
  }
};

// [[Rcpp::export]]
NumericVector parallelSquare(NumericVector x) {
  NumericVector output(x.size());
  SquareWorker worker(x, output);
  parallelFor(0, x.size(), worker);
  return output;
}
```

## Parallel Reduce

```cpp
struct SumWorker : public Worker {
  const RVector<double> input;
  double value;

  SumWorker(const NumericVector input) : input(input), value(0) {}
  SumWorker(const SumWorker& sum, Split) : input(sum.input), value(0) {}

  void operator()(std::size_t begin, std::size_t end) {
    for (std::size_t i = begin; i < end; i++) {
      value += input[i];
    }
  }

  void join(const SumWorker& rhs) {
    value += rhs.value;
  }
};

// [[Rcpp::export]]
double parallelSum(NumericVector x) {
  SumWorker worker(x);
  parallelReduce(0, x.size(), worker);
  return worker.value;
}
```

## Thread Count

```r
# Set threads
RcppParallel::setThreadOptions(numThreads = 4)

# Get default
RcppParallel::defaultNumThreads()
```

## Matrix Operations

```cpp
struct MatrixMultWorker : public Worker {
  const RMatrix<double> A;
  const RMatrix<double> B;
  RMatrix<double> C;

  MatrixMultWorker(const NumericMatrix A, const NumericMatrix B, NumericMatrix C)
    : A(A), B(B), C(C) {}

  void operator()(std::size_t begin, std::size_t end) {
    for (std::size_t i = begin; i < end; i++) {
      for (std::size_t j = 0; j < B.ncol(); j++) {
        double sum = 0;
        for (std::size_t k = 0; k < A.ncol(); k++) {
          sum += A(i, k) * B(k, j);
        }
        C(i, j) = sum;
      }
    }
  }
};
```
