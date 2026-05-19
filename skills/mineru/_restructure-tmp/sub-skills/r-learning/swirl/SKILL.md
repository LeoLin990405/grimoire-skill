---
name: swirl
description: R swirl package for interactive learning. Use for learning R programming through interactive console tutorials.
---

# swirl

Learn R, in R.

## Getting Started

```r
library(swirl)

# Start swirl
swirl()

# Follow prompts to:
# 1. Enter your name
# 2. Select a course
# 3. Select a lesson
```

## Course Management

```r
# Install courses from swirl repository
install_course("R Programming")
install_course("Getting and Cleaning Data")
install_course("Regression Models")

# Install from GitHub
install_course_github("swirldev", "R_Programming_E")

# Install from URL
install_course_url("http://example.com/course.zip")

# Install from local zip
install_course_zip("path/to/course.zip")

# List installed courses
list_courses()

# Uninstall course
uninstall_course("Course Name")
```

## Available Courses

```r
# Official courses from swirldev:
# - R Programming
# - R Programming E (enhanced)
# - Getting and Cleaning Data
# - Regression Models
# - Statistical Inference
# - Exploratory Data Analysis

# Community courses available at:
# https://swirlstats.com/scn/
```

## During a Lesson

```r
# Commands during swirl:
# - Type answer and press Enter
# - skip() - Skip current question
# - play() - Exit swirl temporarily
# - nxt() - Return to swirl after play()
# - bye() - Exit swirl
# - main() - Return to main menu
# - info() - Display options again
```

## Progress

```r
# Progress is saved automatically
# Resume where you left off by running swirl()

# Delete progress
delete_progress("Course Name")
```

## Creating Courses

```r
# Initialize new course
new_course("My Course")

# Add lesson
new_lesson("Lesson 1", "My Course")

# Lesson structure:
# - lesson.yaml: Lesson content
# - initLesson.R: Setup code
# - customTests.R: Custom test functions
# - dependson.txt: Required packages
```

## Lesson YAML Format

```yaml
# lesson.yaml example
- Class: meta
  Course: My Course
  Lesson: Lesson 1
  Author: Your Name
  Type: Standard
  Organization: Your Org
  Version: 1.0.0

- Class: text
  Output: Welcome to this lesson!

- Class: cmd_question
  Output: Create a vector from 1 to 10.
  CorrectAnswer: 1:10
  AnswerTests: omnitest(correctExpr='1:10')
  Hint: Use the colon operator.

- Class: mult_question
  Output: What is 2 + 2?
  AnswerChoices: 3;4;5
  CorrectAnswer: 4
  AnswerTests: omnitest(correctVal='4')
```

## Custom Tests

```r
# customTests.R
test_func <- function() {
  # Access user's answer with e$val
  # Return TRUE if correct, FALSE otherwise
  e$val == expected_value
}
```

## Options

```r
# Set options
options(swirl_logging = TRUE)
options(swirl_is_fun = TRUE)

# Disable logging
options(swirl_logging = FALSE)
```
