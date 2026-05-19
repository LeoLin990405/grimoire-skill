---
name: bookdown
description: R bookdown package for books and long documents. Use for multi-chapter documents with cross-references.
---

# bookdown Package

Authoring books and technical documents.

## Project Structure

```
mybook/
├── index.Rmd        # First chapter (with YAML)
├── 01-intro.Rmd
├── 02-methods.Rmd
├── 03-results.Rmd
├── _bookdown.yml    # Book configuration
├── _output.yml      # Output configuration
└── references.bib
```

## index.Rmd

```yaml
---
title: "My Book"
author: "Author Name"
date: "`r Sys.Date()`"
site: bookdown::bookdown_site
documentclass: book
bibliography: references.bib
link-citations: yes
---
```

## _bookdown.yml

```yaml
book_filename: "mybook"
delete_merged_file: true
language:
  ui:
    chapter_name: "Chapter "
rmd_files:
  - index.Rmd
  - 01-intro.Rmd
  - 02-methods.Rmd
```

## _output.yml

```yaml
bookdown::gitbook:
  css: style.css
  config:
    toc:
      before: |
        <li><a href="./">My Book</a></li>
bookdown::pdf_book:
  includes:
    in_header: preamble.tex
bookdown::epub_book: default
```

## Cross-References

```markdown
# Introduction {#intro}

See Chapter \@ref(methods) for details.
See Figure \@ref(fig:myplot).
See Table \@ref(tab:mytable).
See Equation \@ref(eq:myeq).

```{r myplot, fig.cap="My caption"}
plot(1:10)
```
```

## Build

```r
bookdown::render_book("index.Rmd", "bookdown::gitbook")
bookdown::render_book("index.Rmd", "bookdown::pdf_book")

# Preview
bookdown::serve_book()
```
