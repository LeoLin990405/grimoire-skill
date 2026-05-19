---
name: officer
description: R officer package for Microsoft Office documents. Use for creating and editing Word and PowerPoint files programmatically.
---

# officer

Generate Microsoft Word and PowerPoint documents.

## Word Documents

```r
library(officer)

# Create new document
doc <- read_docx()

# Add content
doc <- doc %>%
  body_add_par("Title", style = "heading 1") %>%
  body_add_par("This is a paragraph of text.") %>%
  body_add_par("Another paragraph.")

# Save
print(doc, target = "document.docx")
```

## Word Formatting

```r
# Formatted text
doc <- read_docx() %>%
  body_add_par("Normal text") %>%
  body_add_par("Bold text", style = "Strong") %>%
  body_add_par("Italic text", style = "Emphasis") %>%
  body_add_fpar(
    fpar(
      ftext("Mixed ", prop = fp_text(bold = TRUE)),
      ftext("formatting ", prop = fp_text(italic = TRUE)),
      ftext("in one line", prop = fp_text(color = "red"))
    )
  )

# Custom text properties
my_text <- fp_text(
  font.size = 12,
  font.family = "Arial",
  bold = TRUE,
  color = "#336699"
)

doc <- doc %>%
  body_add_fpar(fpar(ftext("Custom styled text", prop = my_text)))
```

## Tables in Word

```r
# Add table
doc <- read_docx() %>%
  body_add_table(mtcars[1:5, 1:4], style = "table_template")

# Styled table with flextable
library(flextable)
ft <- flextable(head(mtcars))
doc <- doc %>%
  body_add_flextable(ft)
```

## Images in Word

```r
# Add image
doc <- read_docx() %>%
  body_add_img(src = "plot.png", width = 6, height = 4)

# Add ggplot directly
library(ggplot2)
p <- ggplot(mtcars, aes(mpg, wt)) + geom_point()

doc <- doc %>%
  body_add_gg(value = p, width = 6, height = 4)
```

## PowerPoint

```r
# Create presentation
ppt <- read_pptx()

# Add slides
ppt <- ppt %>%
  add_slide(layout = "Title and Content", master = "Office Theme") %>%
  ph_with(value = "Slide Title", location = ph_location_type("title")) %>%
  ph_with(value = "Bullet point 1\nBullet point 2",
          location = ph_location_type("body"))

# Save
print(ppt, target = "presentation.pptx")
```

## PowerPoint with Images

```r
ppt <- read_pptx() %>%
  add_slide(layout = "Title and Content") %>%
  ph_with("Chart Slide", location = ph_location_type("title")) %>%
  ph_with(external_img("plot.png", width = 6, height = 4),
          location = ph_location_type("body"))

# Add ggplot
ppt <- ppt %>%
  add_slide() %>%
  ph_with(dml(ggobj = p), location = ph_location_type("body"))
```

## Templates

```r
# Use template
doc <- read_docx("template.docx")

# List styles
styles_info(doc)

# Use template styles
doc <- doc %>%
  body_add_par("Custom heading", style = "MyHeading")
```

## Sections and Breaks

```r
doc <- read_docx() %>%
  body_add_par("Page 1 content") %>%
  body_add_break(pos = "after") %>%
  body_add_par("Page 2 content") %>%
  body_add_par("Section break", style = "heading 1") %>%
  body_end_section_landscape()  # Landscape section
```

## Headers and Footers

```r
doc <- read_docx() %>%
  body_add_par("Document content")

# Add header
doc <- headers_replace_all_text(doc, "Header Text", "My Header")

# Add footer with page numbers
doc <- footers_replace_all_text(doc, "Footer Text", "Page ")
```

## Bookmarks and Links

```r
doc <- read_docx() %>%
  body_add_par("Click here for section 2") %>%
  body_bookmark("section1") %>%
  body_add_break() %>%
  body_add_par("Section 2", style = "heading 1") %>%
  body_bookmark("section2")
```

## Edit Existing Documents

```r
# Read and modify
doc <- read_docx("existing.docx")

# Replace text
doc <- body_replace_all_text(doc, "old text", "new text")

# Add at cursor
doc <- doc %>%
  cursor_reach(keyword = "insert here") %>%
  body_add_par("Inserted content")

print(doc, target = "modified.docx")
```
