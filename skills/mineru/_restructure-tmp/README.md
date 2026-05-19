<p align="center">
  <img src="https://img.shields.io/badge/Claude%20Code-Skill-blue?style=for-the-badge" alt="Claude Code Skill">
  <img src="https://img.shields.io/badge/Packages-250+-green?style=for-the-badge" alt="Packages">
  <img src="https://img.shields.io/badge/R-Analytics-276DC3?style=for-the-badge" alt="R Analytics">
</p>

<h1 align="center">R Analytics Skill</h1>

<p align="center">
  <strong>Comprehensive R Language Analytics Skill for Claude Code</strong>
  <br>
  <em>250+ packages across 15 domains including data manipulation, visualization, machine learning, and more</em>
</p>

<p align="center">
  <a href="#-features">Features</a> •
  <a href="#-quick-start">Quick Start</a> •
  <a href="#-domains">Domains</a> •
  <a href="#-packages">Packages</a> •
  <a href="#-structure">Structure</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Claude%20Code-CLI-8A2BE2?logo=anthropic&logoColor=white" alt="Claude Code">
  <img src="https://img.shields.io/badge/R-276DC3?logo=r&logoColor=white" alt="R">
  <img src="https://img.shields.io/badge/tidyverse-1A162D?logo=tidyverse&logoColor=white" alt="tidyverse">
  <img src="https://img.shields.io/badge/ggplot2-FC8D62?logo=ggplot2&logoColor=white" alt="ggplot2">
  <img src="https://img.shields.io/badge/License-MIT-yellow" alt="License">
</p>

**English** | [中文](#中文)

---

## Overview

**R Analytics Skill** provides comprehensive R programming assistance, covering data manipulation, visualization, machine learning, web development, spatial analysis, and more.

### Why R Analytics Skill?

| Challenge | Solution |
|-----------|----------|
| Scattered R knowledge | **357 SKILL.md files** organized by domain |
| Package selection | **250+ packages** with recommendations |
| Learning curve | **Hierarchical structure** from basic to advanced |
| Code examples | **Practical examples** for each package |

---

## Features

| Feature | Description |
|---------|-------------|
| **15 Domains** | Major R application areas |
| **70+ Categories** | Specific sub-domains |
| **250+ Packages** | Individual R packages |
| **357 SKILL.md** | Total skill files |

---

## Quick Start

### Installation

```bash
cd ~/.claude/skills
git clone https://github.com/LeoLin990405/r-analytics-skill.git r-analytics
```

### Verify Installation

```bash
ls ~/.claude/skills/r-analytics/SKILL.md
```

---

## Domains

| Domain | Description | Packages |
|--------|-------------|----------|
| `r-data` | Data manipulation, formats, databases | 35+ |
| `r-viz` | Static, interactive, animated visualization | 35+ |
| `r-ml` | Machine learning frameworks, algorithms | 45+ |
| `r-web` | Shiny, APIs, scraping, reports | 25+ |
| `r-spatial` | Vector, raster, mapping, analysis | 15+ |
| `r-network` | Graph analysis, visualization | 10+ |
| `r-nlp` | Text mining, sentiment, topic modeling | 12+ |
| `r-stats` | Bayesian, finance, optimization | 17+ |
| `r-bio` | Bioinformatics (RNA-seq, genomics) | 11+ |
| `r-dev` | Package development, testing | 20+ |
| `r-parallel` | Parallel & high-performance computing | 8+ |
| `r-syntax` | Pipe operators & syntax extensions | 2 |
| `r-language-api` | Python, JavaScript, Java, C++ interfaces | 5 |
| `r-logging` | Application logging frameworks | 3 |
| `r-learning` | Interactive learning tools | 2 |

---

## Packages

### Data Processing (35+)

```
Manipulation:  dplyr, data.table, tidyr, purrr, lubridate, stringr
Formats:       readr, arrow, readxl, jsonlite, haven, vroom
Database:      DBI, dbplyr, RSQLite, RPostgres, odbc
Validation:    validate, assertr, pointblank
```

### Visualization (35+)

```
Static:        ggplot2, patchwork, scales, ggthemes, cowplot, gt
Interactive:   plotly, leaflet, DT, highcharter, echarts4r
Animation:     gganimate, animation
```

### Machine Learning (45+)

```
Frameworks:    tidymodels, caret, mlr3, h2o
Boosting:      xgboost, lightgbm, gbm, catboost
Deep Learning: keras, torch, tensorflow
Time Series:   prophet, forecast, fable
```

---

## Structure

```
r-analytics/
├── SKILL.md                 # Main skill file
├── README.md                # Documentation
├── references/              # Reference docs (17 files)
└── sub-skills/              # Domain-specific skills (15 domains)
    ├── r-data/              # Data manipulation
    ├── r-viz/               # Visualization
    ├── r-ml/                # Machine learning
    ├── r-web/               # Web & reports
    ├── r-spatial/           # Spatial analysis
    └── ...
```

---

## Usage

```bash
# Ask about R programming
"How do I use dplyr to filter data?"

# Request data analysis
"Analyze this CSV file with R"

# Create visualizations
"Create a ggplot2 scatter plot"

# Work with specific packages
"Show me how to use tidymodels for classification"
```

---

## 中文

### 概述

**R Analytics Skill** 提供全面的 R 编程辅助，涵盖数据处理、可视化、机器学习、Web 开发、空间分析等。

### 领域覆盖

| 领域 | 描述 | 包数量 |
|------|------|--------|
| `r-data` | 数据处理、格式、数据库 | 35+ |
| `r-viz` | 静态、交互、动画可视化 | 35+ |
| `r-ml` | 机器学习框架、算法 | 45+ |
| `r-web` | Shiny、API、爬虫、报告 | 25+ |
| `r-spatial` | 矢量、栅格、制图、分析 | 15+ |
| `r-network` | 图分析、可视化 | 10+ |
| `r-nlp` | 文本挖掘、情感分析 | 12+ |
| `r-stats` | 贝叶斯、金融、优化 | 17+ |
| `r-bio` | 生物信息学 | 11+ |
| `r-dev` | 包开发、测试 | 20+ |
| `r-parallel` | 并行计算 | 8+ |

### 安装

```bash
cd ~/.claude/skills
git clone https://github.com/LeoLin990405/r-analytics-skill.git r-analytics
```

### 使用方法

```bash
# 询问 R 编程
"用 dplyr 怎么筛选数据？"

# 请求数据分析
"用 R 分析这个 CSV 文件"

# 创建可视化
"用 ggplot2 画散点图"
```

### 依赖

- R 4.0+
- Claude Code CLI

---

## Contributors

- **Leo** ([@LeoLin990405](https://github.com/LeoLin990405)) - Project Lead & Curation
- **Claude** (Anthropic Claude Opus 4.5) - Content Generation & Organization

## Acknowledgements

- **[Hadley Wickham](https://hadley.nz/)** - For tidyverse, ggplot2
- **[RStudio/Posit](https://posit.co/)** - For the R ecosystem
- **[CRAN](https://cran.r-project.org/)** - For hosting R packages
- **[Bioconductor](https://bioconductor.org/)** - For bioinformatics packages

## License

MIT License - see [LICENSE](LICENSE) for details.

---

<p align="center">
  <sub>Built with ❤️ by Leo and Claude</sub>
</p>
