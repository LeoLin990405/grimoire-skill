---
name: keras
description: R keras package for deep learning. Use for neural networks with TensorFlow backend.
---

# keras Package

Deep learning with TensorFlow backend.

## Setup

```r
library(keras)
# install_keras()  # First time only
```

## Sequential Model

```r
model <- keras_model_sequential() %>%
  layer_dense(units = 64, activation = "relu", input_shape = c(10)) %>%
  layer_dropout(rate = 0.3) %>%
  layer_dense(units = 32, activation = "relu") %>%
  layer_dropout(rate = 0.3) %>%
  layer_dense(units = 1, activation = "sigmoid")

model %>% compile(
  optimizer = "adam",
  loss = "binary_crossentropy",
  metrics = c("accuracy")
)

summary(model)
```

## Training

```r
history <- model %>% fit(
  x_train, y_train,
  epochs = 50,
  batch_size = 32,
  validation_split = 0.2,
  callbacks = list(
    callback_early_stopping(patience = 5),
    callback_model_checkpoint("best_model.h5", save_best_only = TRUE)
  )
)

plot(history)
```

## Evaluation

```r
model %>% evaluate(x_test, y_test)
predictions <- model %>% predict(x_test)
```

## CNN for Images

```r
model <- keras_model_sequential() %>%
  layer_conv_2d(filters = 32, kernel_size = c(3, 3), activation = "relu",
    input_shape = c(28, 28, 1)) %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_conv_2d(filters = 64, kernel_size = c(3, 3), activation = "relu") %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_flatten() %>%
  layer_dense(units = 64, activation = "relu") %>%
  layer_dense(units = 10, activation = "softmax")
```

## LSTM for Sequences

```r
model <- keras_model_sequential() %>%
  layer_lstm(units = 50, return_sequences = TRUE, input_shape = c(timesteps, features)) %>%
  layer_lstm(units = 50) %>%
  layer_dense(units = 1)
```

## Save/Load

```r
save_model_hdf5(model, "model.h5")
model <- load_model_hdf5("model.h5")
```
