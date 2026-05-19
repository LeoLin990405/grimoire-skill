---
name: learnr
description: R learnr package for interactive tutorials. Use for creating Shiny-based interactive R tutorials.
---

# learnr

Interactive tutorials with Shiny.

## Running Tutorials

```r
library(learnr)

# Run built-in tutorial
run_tutorial("hello", package = "learnr")

# Run from package
run_tutorial("tutorial_name", package = "package_name")

# List available tutorials
available_tutorials()
available_tutorials("package_name")
```

## Creating Tutorials

```r
# Create new tutorial (in RStudio)
# File > New File > R Markdown > From Template > Interactive Tutorial

# Or manually create .Rmd file with:
# output: learnr::tutorial
```

## Tutorial Structure

````markdown
---
title: "My Tutorial"
output: learnr::tutorial
runtime: shiny_prerendered
---

```{r setup, include=FALSE}
library(learnr)
knitr::opts_chunk$set(echo = FALSE)
```

## Topic 1

### Exercise

Write code to create a vector:

```{r vector, exercise=TRUE}

```

```{r vector-hint}
# Use c() or :
```

```{r vector-solution}
c(1, 2, 3, 4, 5)
```
````

## Exercise Chunks

````markdown
```{r exercise-name, exercise=TRUE}
# Starter code here
```

```{r exercise-name-hint-1}
# First hint
```

```{r exercise-name-hint-2}
# Second hint
```

```{r exercise-name-solution}
# Solution code
```

```{r exercise-name-check}
# Custom checking code
```
````

## Exercise Options

````markdown
```{r ex, exercise=TRUE, exercise.lines=10}
# 10 lines of space
```

```{r ex, exercise=TRUE, exercise.timelimit=60}
# 60 second time limit
```

```{r ex, exercise=TRUE, exercise.cap="Try it"}
# Custom caption
```

```{r ex, exercise=TRUE, exercise.eval=TRUE}
# Evaluate starter code
```
````

## Quiz Questions

````markdown
```{r quiz}
quiz(
  question("What is 2 + 2?",
    answer("3"),
    answer("4", correct = TRUE),
    answer("5"),
    allow_retry = TRUE
  ),
  question("Select all prime numbers",
    answer("2", correct = TRUE),
    answer("3", correct = TRUE),
    answer("4"),
    answer("5", correct = TRUE),
    type = "multiple"
  )
)
```
````

## Question Types

```r
# Single choice
question("Question text",
  answer("A"),
  answer("B", correct = TRUE),
  answer("C")
)

# Multiple choice
question("Select all that apply",
  answer("A", correct = TRUE),
  answer("B", correct = TRUE),
  answer("C"),
  type = "multiple"
)

# Text input
question_text("Enter your answer",
  answer("correct answer", correct = TRUE),
  allow_retry = TRUE
)

# Numeric input
question_numeric("What is 2 + 2?",
  answer(4, correct = TRUE),
  allow_retry = TRUE
)
```

## Exercise Checking

```r
# In setup chunk
library(gradethis)
gradethis_setup()

# In check chunk
grade_this_code()  # Check against solution

# Custom grading
grade_this({
  if (.result == expected) {
    pass("Correct!")
  }
  fail("Try again.")
})
```

## Tutorial State

```r
# Access exercise results
event_register_handler("exercise_result", function(data) {
  # data$label, data$correct, data$code
})

# Store/retrieve state
tutorial_options(exercise.completion = TRUE)
```

## Deployment

```r
# Deploy to shinyapps.io
rsconnect::deployApp()

# Or include in package
# inst/tutorials/tutorial_name/tutorial_name.Rmd
```
