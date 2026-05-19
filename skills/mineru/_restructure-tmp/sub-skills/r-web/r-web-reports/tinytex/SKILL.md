---
name: tinytex
description: R tinytex package for LaTeX distribution. Use for installing and managing a lightweight LaTeX distribution for PDF rendering.
---

# tinytex

Lightweight LaTeX distribution for R.

## Installation

```r
# Install tinytex R package
install.packages("tinytex")

# Install TinyTeX distribution
tinytex::install_tinytex()

# Uninstall
tinytex::uninstall_tinytex()
```

## Check Installation

```r
# Check if TinyTeX is installed
tinytex::is_tinytex()

# Check LaTeX version
tinytex::tinytex_root()

# List installed packages
tinytex::tl_pkgs()
```

## Package Management

```r
# Install LaTeX packages
tinytex::tlmgr_install("amsmath")
tinytex::tlmgr_install(c("booktabs", "longtable", "multirow"))

# Search for packages
tinytex::tlmgr_search("beamer")

# Update packages
tinytex::tlmgr_update()

# Remove packages
tinytex::tlmgr_remove("unused-package")
```

## Compile Documents

```r
# Compile LaTeX to PDF
tinytex::latexmk("document.tex")

# With options
tinytex::latexmk("document.tex", engine = "xelatex")
tinytex::latexmk("document.tex", engine = "lualatex")
tinytex::latexmk("document.tex", engine = "pdflatex")

# Compile and clean auxiliary files
tinytex::latexmk("document.tex", clean = TRUE)
```

## With R Markdown

```r
# In YAML header
---
output:
  pdf_document:
    latex_engine: xelatex
---

# TinyTeX automatically installs missing packages
# when rendering R Markdown to PDF
rmarkdown::render("document.Rmd")
```

## Troubleshooting

```r
# Parse LaTeX log for errors
tinytex::parse_latex_log("document.log")

# Find missing packages from error
tinytex::parse_packages("document.log")

# Install missing packages automatically
tinytex::latexmk("document.tex", install_packages = TRUE)
```

## Configuration

```r
# Set default engine
options(tinytex.engine = "xelatex")

# Set verbose output
options(tinytex.verbose = TRUE)

# Custom TinyTeX path
Sys.setenv(TINYTEX_DIR = "/custom/path")
```

## Common LaTeX Packages

```r
# Essential packages for R Markdown
tinytex::tlmgr_install(c(
  "booktabs",      # Better tables
  "longtable",     # Multi-page tables
  "multirow",      # Multi-row cells
  "wrapfig",       # Wrapped figures
  "float",         # Figure placement
  "colortbl",      # Colored tables
  "tabu",          # Advanced tables
  "threeparttable", # Table notes
  "fancyhdr",      # Headers/footers
  "lastpage",      # Page count
  "geometry",      # Page margins
  "hyperref"       # Hyperlinks
))

# For CJK (Chinese, Japanese, Korean)
tinytex::tlmgr_install(c(
  "ctex",
  "xecjk",
  "cjk"
))

# For fonts
tinytex::tlmgr_install(c(
  "fontspec",
  "unicode-math"
))
```

## Reinstall/Repair

```r
# Reinstall TinyTeX
tinytex::reinstall_tinytex()

# Repair installation
tinytex::tlmgr_path()

# Force reinstall packages
tinytex::tlmgr_install("package", force = TRUE)
```

## Version Control

```r
# Pin TinyTeX version
tinytex::install_tinytex(version = "2023.04")

# Get current version
tinytex::tl_version()
```

## CI/CD Usage

```r
# GitHub Actions example
# In .github/workflows/render.yml:
# - uses: r-lib/actions/setup-tinytex@v2

# Install in CI
if (!tinytex::is_tinytex()) {
  tinytex::install_tinytex()
}
```
