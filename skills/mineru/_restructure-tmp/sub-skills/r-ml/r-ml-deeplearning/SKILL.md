---
name: r-ml-deeplearning
description: R deep learning with torch, keras, tensorflow. Use for neural networks, CNNs, RNNs, and GPU acceleration.
---

# R Deep Learning

Neural networks with torch and keras.

## torch (PyTorch-like)

```r
library(torch)

# Tensors
x <- torch_tensor(matrix(1:6, 2, 3))
x$shape
x$dtype

# Operations
y <- x + 1
z <- torch_matmul(x, x$t())

# GPU
if (cuda_is_available()) {
  x <- x$cuda()
}

# Define model
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

model <- net(input_size = 10, hidden_size = 64, output_size = 2)

# Training loop
optimizer <- optim_adam(model$parameters, lr = 0.001)
criterion <- nn_cross_entropy_loss()

for (epoch in 1:100) {
  optimizer$zero_grad()
  output <- model(x_train)
  loss <- criterion(output, y_train)
  loss$backward()
  optimizer$step()

  if (epoch %% 10 == 0) {
    cat("Epoch:", epoch, "Loss:", loss$item(), "\n")
  }
}

# Predictions
model$eval()
with_no_grad({
  pred <- model(x_test)
})
```

## luz (High-level torch)

```r
library(luz)

# Define model
model <- nn_module(
  initialize = function(input_size) {
    self$net <- nn_sequential(
      nn_linear(input_size, 128),
      nn_relu(),
      nn_dropout(0.3),
      nn_linear(128, 64),
      nn_relu(),
      nn_linear(64, 1)
    )
  },
  forward = function(x) {
    self$net(x)
  }
)

# Train with luz
fitted <- model %>%
  setup(
    loss = nn_mse_loss(),
    optimizer = optim_adam,
    metrics = list(luz_metric_mae())
  ) %>%
  set_hparams(input_size = ncol(x_train)) %>%
  fit(
    data = list(x_train, y_train),
    valid_data = list(x_valid, y_valid),
    epochs = 100,
    callbacks = list(
      luz_callback_early_stopping(patience = 10),
      luz_callback_lr_scheduler(lr_one_cycle, max_lr = 0.01)
    )
  )

# Predictions
pred <- predict(fitted, x_test)
```

## keras/tensorflow

```r
library(keras)

# Sequential model
model <- keras_model_sequential() %>%
  layer_dense(units = 128, activation = "relu", input_shape = c(10)) %>%
  layer_dropout(rate = 0.3) %>%
  layer_dense(units = 64, activation = "relu") %>%
  layer_dense(units = 1, activation = "sigmoid")

# Compile
model %>% compile(
  loss = "binary_crossentropy",
  optimizer = optimizer_adam(learning_rate = 0.001),
  metrics = c("accuracy")
)

# Train
history <- model %>% fit(
  x_train, y_train,
  epochs = 100,
  batch_size = 32,
  validation_split = 0.2,
  callbacks = list(
    callback_early_stopping(patience = 10),
    callback_reduce_lr_on_plateau(factor = 0.1, patience = 5)
  )
)

# Evaluate
model %>% evaluate(x_test, y_test)

# Predictions
pred <- model %>% predict(x_test)

# Save/load
save_model_hdf5(model, "model.h5")
model <- load_model_hdf5("model.h5")
```

## CNN Example

```r
library(torch)

# CNN for images
cnn <- nn_module(
  initialize = function() {
    self$conv1 <- nn_conv2d(1, 32, kernel_size = 3)
    self$conv2 <- nn_conv2d(32, 64, kernel_size = 3)
    self$fc1 <- nn_linear(64 * 5 * 5, 128)
    self$fc2 <- nn_linear(128, 10)
  },
  forward = function(x) {
    x %>%
      self$conv1() %>% nnf_relu() %>% nnf_max_pool2d(2) %>%
      self$conv2() %>% nnf_relu() %>% nnf_max_pool2d(2) %>%
      torch_flatten(start_dim = 2) %>%
      self$fc1() %>% nnf_relu() %>%
      self$fc2()
  }
)
```

## Comparison

| Framework | Style | GPU | Ecosystem |
|-----------|-------|-----|-----------|
| torch | PyTorch | Yes | Growing |
| keras | High-level | Yes | Mature |
| tensorflow | Low-level | Yes | Mature |
