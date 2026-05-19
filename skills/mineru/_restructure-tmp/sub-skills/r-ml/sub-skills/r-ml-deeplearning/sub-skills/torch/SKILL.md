---
name: torch
description: R torch package for deep learning. Use for PyTorch-style neural networks in R.
---

# torch Package

PyTorch-style deep learning in R.

## Tensors

```r
library(torch)

# Create tensors
x <- torch_tensor(c(1, 2, 3))
x <- torch_randn(3, 4)
x <- torch_zeros(2, 3)
x <- torch_ones(2, 3)

# Operations
y <- x + 1
z <- torch_matmul(x, y$t())

# GPU
if (cuda_is_available()) {
  x <- x$cuda()
}
```

## Define Model

```r
net <- nn_module(
  initialize = function(input_size, hidden_size, output_size) {
    self$fc1 <- nn_linear(input_size, hidden_size)
    self$fc2 <- nn_linear(hidden_size, output_size)
  },
  forward = function(x) {
    x %>%
      self$fc1() %>%
      nnf_relu() %>%
      self$fc2()
  }
)

model <- net(input_size = 10, hidden_size = 64, output_size = 1)
```

## Training Loop

```r
optimizer <- optim_adam(model$parameters, lr = 0.001)
loss_fn <- nn_mse_loss()

for (epoch in 1:100) {
  optimizer$zero_grad()

  output <- model(x_train)
  loss <- loss_fn(output, y_train)

  loss$backward()
  optimizer$step()

  if (epoch %% 10 == 0) {
    cat("Epoch:", epoch, "Loss:", loss$item(), "\n")
  }
}
```

## Dataset & DataLoader

```r
dataset <- dataset(
  initialize = function(x, y) {
    self$x <- torch_tensor(x)
    self$y <- torch_tensor(y)
  },
  .getitem = function(i) {
    list(x = self$x[i, ], y = self$y[i])
  },
  .length = function() {
    self$x$size(1)
  }
)

ds <- dataset(x_data, y_data)
dl <- dataloader(ds, batch_size = 32, shuffle = TRUE)

for (batch in enumerate(dl)) {
  # batch$x, batch$y
}
```

## Save/Load

```r
torch_save(model, "model.pt")
model <- torch_load("model.pt")
```
