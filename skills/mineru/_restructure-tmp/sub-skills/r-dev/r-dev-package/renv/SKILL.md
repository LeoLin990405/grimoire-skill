---
name: renv
description: R renv package for dependency management. Use for creating isolated, reproducible R project environments.
---

# renv

Project-local R dependency management.

## Initialize Project

```r
library(renv)

# Initialize renv in project
renv::init()

# Creates:
# - renv.lock (lockfile)
# - renv/ directory
# - .Rprofile (auto-activation)
```

## Workflow

```r
# 1. Initialize project
renv::init()

# 2. Work on project, install packages
install.packages("dplyr")

# 3. Snapshot dependencies
renv::snapshot()

# 4. Share project (commit renv.lock)

# 5. Collaborator restores environment
renv::restore()
```

## Snapshot

```r
# Snapshot current state
renv::snapshot()

# Snapshot specific packages
renv::snapshot(packages = c("dplyr", "ggplot2"))

# Snapshot with prompt
renv::snapshot(prompt = TRUE)

# Types of snapshots
renv::snapshot(type = "implicit")  # Used packages only
renv::snapshot(type = "explicit")  # DESCRIPTION only
renv::snapshot(type = "all")       # All installed
```

## Restore

```r
# Restore from lockfile
renv::restore()

# Restore specific packages
renv::restore(packages = c("dplyr"))

# Clean restore (remove unlisted packages)
renv::restore(clean = TRUE)
```

## Package Management

```r
# Install packages
renv::install("dplyr")
renv::install("tidyverse")

# Install from GitHub
renv::install("tidyverse/dplyr")

# Install specific version
renv::install("dplyr@1.0.0")

# Install from local source
renv::install("./path/to/package")

# Update packages
renv::update()
renv::update("dplyr")

# Remove packages
renv::remove("unused_package")
```

## Status and Diagnostics

```r
# Check status
renv::status()

# View dependencies
renv::dependencies()

# Check for issues
renv::diagnostics()

# View lockfile
renv::lockfile_read()
```

## Lockfile

```r
# View lockfile contents
lockfile <- renv::lockfile_read()
lockfile$Packages

# Modify lockfile
renv::record("dplyr@1.1.0")

# Validate lockfile
renv::lockfile_validate()
```

## Configuration

```r
# Settings in .Rprofile or renv/settings.dcf

# Use binary packages
renv::settings$use.cache(TRUE)

# Set repository
renv::settings$repos(c(CRAN = "https://cloud.r-project.org"))

# Ignore packages
renv::settings$ignored.packages(c("devtools"))
```

## Cache

```r
# View cache
renv::paths$cache()

# Clean cache
renv::clean()

# Rebuild cache
renv::rebuild()

# Copy to cache
renv::isolate()
```

## History

```r
# View history
renv::history()

# Revert to previous state
renv::revert(commit = "abc123")
```

## CI/CD Integration

```r
# GitHub Actions
# .github/workflows/R-CMD-check.yaml
# - uses: r-lib/actions/setup-renv@v2

# Restore in CI
if (file.exists("renv.lock")) {
  renv::restore()
}
```

## Migration

```r
# From packrat
renv::migrate(packrat = TRUE)

# Deactivate renv
renv::deactivate()

# Reactivate
renv::activate()
```

## Best Practices

```r
# 1. Always commit renv.lock
# 2. Don't commit renv/library/
# 3. Run renv::snapshot() after installing packages
# 4. Run renv::restore() when pulling changes
# 5. Use renv::status() to check synchronization

# .gitignore for renv
# renv/library/
# renv/local/
# renv/cellar/
# renv/lock/
# renv/python/
# renv/staging/
```
