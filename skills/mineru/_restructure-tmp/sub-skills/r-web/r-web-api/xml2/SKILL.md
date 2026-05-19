---
name: xml2
description: R xml2 package for XML/HTML parsing. Use for reading, parsing, and manipulating XML and HTML documents.
---

# xml2

Parse and manipulate XML and HTML.

## Reading XML/HTML

```r
library(xml2)

# Read from file
doc <- read_xml("data.xml")
html <- read_html("page.html")

# Read from URL
doc <- read_xml("https://example.com/data.xml")
html <- read_html("https://example.com/page.html")

# Read from string
doc <- read_xml("<root><item>value</item></root>")
html <- read_html("<html><body><p>Hello</p></body></html>")
```

## XPath Queries

```r
# Find nodes
nodes <- xml_find_all(doc, "//item")
node <- xml_find_first(doc, "//item[@id='1']")

# Check if exists
xml_find_lgl(doc, "boolean(//item)")

# Count nodes
xml_find_num(doc, "count(//item)")

# Get text
xml_find_chr(doc, "string(//title)")
```

## Node Information

```r
# Get text content
xml_text(node)
xml_text(nodes)

# Get attribute
xml_attr(node, "id")
xml_attrs(node)  # All attributes

# Get name
xml_name(node)

# Get namespace
xml_ns(doc)
```

## Navigation

```r
# Children
xml_children(node)
xml_child(node, 1)  # First child

# Parent
xml_parent(node)

# Siblings
xml_siblings(node)

# Root
xml_root(doc)

# Path
xml_path(node)
```

## Modification

```r
# Set text
xml_set_text(node, "new value")

# Set attribute
xml_set_attr(node, "id", "123")
xml_set_attrs(node, c(id = "123", class = "item"))

# Set name
xml_set_name(node, "new_name")

# Add child
xml_add_child(node, "child", "value")
xml_add_child(node, "child", .where = "before")

# Add sibling
xml_add_sibling(node, "sibling", "value")

# Remove node
xml_remove(node)

# Replace node
xml_replace(node, read_xml("<new>content</new>"))
```

## Creating XML

```r
# Create document
doc <- xml_new_document()
root <- xml_add_child(doc, "root")
xml_add_child(root, "item", "value1", id = "1")
xml_add_child(root, "item", "value2", id = "2")

# Create from scratch
doc <- read_xml("<root/>")
xml_add_child(doc, "child", "text")
```

## Namespaces

```r
# Register namespace
ns <- xml_ns(doc)
xml_find_all(doc, "//d1:item", ns)

# Or use local-name()
xml_find_all(doc, "//*[local-name()='item']")
```

## HTML Specific

```r
# Parse HTML (more forgiving)
html <- read_html("<p>Unclosed paragraph")

# CSS selectors (with rvest)
library(rvest)
html %>% html_elements("p.class")
html %>% html_elements("#id")
```

## Writing

```r
# Write to file
write_xml(doc, "output.xml")

# As string
as.character(doc)
xml_serialize(doc, NULL)
```

## Validation

```r
# Validate against schema
xml_validate(doc, read_xml("schema.xsd"))
```

## Large Files

```r
# Stream large XML
callback <- function(node) {
  # Process each node
  print(xml_text(node))
}

xml_find_all(doc, "//item", callback = callback)
```
