---
name: blogdown
description: R blogdown package for creating blogs with Hugo. Use for building static websites and blogs with R Markdown.
---

# blogdown

Create blogs and websites with R Markdown.

## Getting Started

```r
library(blogdown)

# Create new site
new_site(theme = "yihui/hugo-lithium")

# Serve site locally
serve_site()

# Stop server
stop_server()
```

## New Content

```r
# New post
new_post("My First Post")

# With options
new_post(
  title = "My Post",
  author = "Name",
  categories = c("R", "Tutorial"),
  tags = c("ggplot2", "visualization")
)

# New page
new_content("about.md")
```

## Build

```r
# Build site
build_site()

# Build to specific directory
build_site(local = TRUE)

# Check site
check_site()
```

## Configuration

```yaml
# config.yaml
baseurl: "https://example.com/"
title: "My Blog"
theme: "hugo-lithium"

params:
  author: "Your Name"
  description: "Blog description"

menu:
  main:
    - name: "About"
      url: "/about/"
    - name: "GitHub"
      url: "https://github.com/username"
```

## Post Front Matter

```yaml
---
title: "Post Title"
author: "Author Name"
date: "2024-01-15"
categories: ["R"]
tags: ["visualization", "ggplot2"]
---
```

## Themes

```r
# Install theme
install_theme("gcushen/hugo-academic")

# Popular themes:
# - yihui/hugo-lithium (simple)
# - gcushen/hugo-academic (academic)
# - wowchemy/starter-hugo-academic
# - nanxstats/hugo-renga
```

## Deployment

```r
# Build for deployment
build_site()

# Deploy to Netlify (drag public/ folder)
# Or connect GitHub repo to Netlify

# Hugo version for Netlify
# netlify.toml:
# [build]
#   publish = "public"
#   command = "hugo"
# [build.environment]
#   HUGO_VERSION = "0.120.0"
```

## Utilities

```r
# Find Hugo
find_hugo()

# Install Hugo
install_hugo()

# Update Hugo
update_hugo()

# Check content
check_content()
check_netlify()
check_hugo()
```
