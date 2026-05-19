# R Analytics Skill - Claude Code 技能包

> **为 [Claude Code](https://github.com/anthropics/claude-code) 打造的综合性 R 语言技能包**
>
> 涵盖 15 个领域的 250+ 个 R 包，包括数据处理、可视化、机器学习、Web 开发、空间分析等。

[English](README.md) | **中文说明**

---

## 关于本项目

本技能包由以下成员协作创建：
- **Leo** ([@LeoLin990405](https://github.com/LeoLin990405)) - 项目负责人 & 内容整理
- **Claude** (Anthropic Claude Opus 4.5) - 内容生成 & 组织架构

我们专注于提供 **全面的覆盖范围**、**实用的代码示例** 和 **层次化的组织结构**，以便更好地辅助 R 编程。

---

## 核心特性

### 1. 层次化技能结构
| 层级 | 描述 | 数量 |
|------|------|------|
| 领域 | R 语言主要应用领域 | 15 |
| 类别 | 具体子领域 | 70+ |
| 包 | 独立 R 包 | 250+ |
| **SKILL.md 文件总数** | | **357** |

### 2. 领域覆盖
| 领域 | 描述 | 包数量 |
|------|------|--------|
| `r-data` | 数据操作、格式、数据库、验证 | 35+ |
| `r-viz` | 静态、交互、动画可视化 | 35+ |
| `r-ml` | 机器学习框架、算法、可解释性 | 45+ |
| `r-web` | Shiny、API、爬虫、报告 | 25+ |
| `r-spatial` | 矢量、栅格、制图、分析 | 15+ |
| `r-network` | 图分析、可视化、动态网络 | 10+ |
| `r-nlp` | 文本挖掘、情感分析、主题建模 | 12+ |
| `r-stats` | 贝叶斯、金融、优化、时间序列 | 17+ |
| `r-bio` | 生物信息学 (RNA-seq, 基因组学, 系统发育) | 11+ |
| `r-dev` | 包开发、测试、性能分析 | 20+ |
| `r-parallel` | 并行与高性能计算 | 8+ |
| `r-syntax` | 管道操作符与语法扩展 | 2 |
| `r-language-api` | Python、JavaScript、Java、C++ 接口 | 5 |
| `r-logging` | 应用日志框架 | 3 |
| `r-learning` | 交互式学习工具 | 2 |

### 3. 包覆盖范围

#### 数据处理 (35+)
```
数据操作:   dplyr, data.table, tidyr, purrr, lubridate, stringr, broom, reshape2, stringi, DataExplorer, fuzzyjoin, janitor
数据格式:   readr, arrow, readxl, jsonlite, haven, writexl, vroom, fst, qs, rio, yaml, feather, RDS
数据库:     DBI, dbplyr, RSQLite, RPostgres, odbc, mongolite, elastic, RMariaDB, redis
数据验证:   validate, assertr, pointblank
```

#### 可视化 (35+)
```
静态图:     ggplot2, patchwork, scales, ggthemes, cowplot, gt, ggforce, ggrepel, corrplot, rayshader, lattice, rgl, ggalt, ggstatsplot, ggridges, ggtext, ggdist, ggtree
交互图:     plotly, leaflet, DT, highcharter, echarts4r, visNetwork, networkD3, DiagrammeR, formattable, heatmaply, dygraphs, ggvis, rbokeh, threejs, wordcloud2
动画:       gganimate, animation
```

#### 机器学习 (45+)
```
框架:       tidymodels, caret, mlr3, h2o, lme4, nlme, Boruta, arules, e1071, kernlab
提升算法:   xgboost, lightgbm, gbm, catboost
树模型:     ranger, randomForest, rpart
正则化:     glmnet, elasticnet
深度学习:   keras, torch, tensorflow
时间序列:   prophet, forecast, fable, tsibble, tseries
生存分析:   survival, survminer
异常检测:   AnomalyDetection, anomalize
聚类:       cluster, factoextra, mclust, dbscan
降维:       Rtsne, umap, irlba
可解释性:   DALEX, iml, lime, vip
```

#### Web 开发 (25+)
```
Shiny:      shiny, golem, shinyjs, shinydashboard, bslib, flexdashboard, shinythemes, shinyWidgets
API:        httr2, httr, plumber, curl, xml2
爬虫:       rvest, polite, RSelenium
报告:       rmarkdown, quarto, knitr, bookdown, officer, flextable, targets, tinytex, gt, blogdown, slidify
```

#### 统计分析 (17+)
```
贝叶斯:     brms, rstan, rstanarm, MCMCpack, coda
金融:       quantmod, xts, zoo, TTR, PerformanceAnalytics
优化:       lpSolve, nloptr, ROI
时间序列:   forecast, tseries, fable, feasts
```

#### 空间分析 (15+)
```
矢量:       sf, terra, rgdal, rgeos, maptools
栅格:       terra, stars, raster
制图:       tmap, mapview, ggmap, cartography, mapsf
分析:       sp, spatstat
```

#### 网络分析 (10+)
```
分析:       igraph, tidygraph, sna, network, statnet
可视化:     ggraph
动态网络:   networkDynamic, ndtv, tsna
```

#### 自然语言处理 (12+)
```
文本:       tidytext, quanteda, text2vec, tm, stringdist, hunspell, tokenizers
情感分析:   syuzhet, sentimentr
主题建模:   topicmodels, stm, LDAvis
```

#### 生物信息学 (11+)
```
RNA-seq:    DESeq2, edgeR, limma
基因组学:   GenomicRanges, Biostrings, Bioconductor, seqinr, genetics, pheatmap
系统发育:   ape, phangorn
```

#### 开发工具 (20+)
```
包开发:     devtools, usethis, roxygen2, pkgdown, renv, box, lintr, styler, pryr, installr, rcmdcheck
测试:       testthat, covr, mockery
面向对象:   R6
性能分析:   bench, profvis, microbenchmark, lobstr
```

#### 并行计算 (8+)
```
本地并行:   future, furrr, foreach, parallel, doParallel
分布式:     sparklyr
C++ 加速:   Rcpp, RcppParallel
```

#### 日志 (3)
```
futile.logger, log4r, logging
```

#### 语法扩展 (2)
```
管道:       magrittr, pipeR
```

#### 语言接口 (5)
```
Python:     reticulate
JavaScript: V8
Java:       rJava
C++:        Rcpp, cpp11
```

#### 学习工具 (2)
```
交互式:     learnr, swirl
```

### 4. 参考文档
- **R for Data Science (2e)** - Tidyverse 工作流
- **Advanced R (2e)** - 深入 R 编程
- **R Graphics Cookbook** - 可视化食谱
- **Tidyverse 生态系统** - 核心包指南
- **Bioconductor** - 生物信息学包

---

## 快速开始

### 安装
```bash
# 克隆到 Claude Code skills 目录
cd ~/.claude/skills
git clone https://github.com/LeoLin990405/r-analytics-skill.git r-analytics
```

### 验证安装
```bash
ls ~/.claude/skills/r-analytics/SKILL.md
```

---

## 文件结构
```
r-analytics/
├── SKILL.md                 # 主技能文件 (触发器 & 快速参考)
├── README.md                # 英文文档
├── README_CN.md             # 中文文档
├── references/              # 参考文档 (17 个文件)
│   ├── r4ds-*.md           # R for Data Science 笔记
│   ├── advr-*.md           # Advanced R 笔记
│   ├── graphics-cookbook.md
│   └── ...
├── scripts/                 # 工具脚本
│   └── update_packages.R
└── sub-skills/             # 领域专项技能 (15 个领域)
    ├── r-data/             # 数据处理 (35+ 个包)
    │   ├── r-data-manipulation/
    │   ├── r-data-formats/
    │   ├── r-data-database/
    │   └── r-data-validation/
    ├── r-viz/              # 可视化 (35+ 个包)
    │   ├── r-viz-static/
    │   ├── r-viz-interactive/
    │   └── r-viz-animation/
    ├── r-ml/               # 机器学习 (45+ 个包)
    │   ├── r-ml-frameworks/
    │   ├── r-ml-boosting/
    │   ├── r-ml-trees/
    │   ├── r-ml-regularization/
    │   ├── r-ml-deeplearning/
    │   ├── r-ml-timeseries/
    │   ├── r-ml-survival/
    │   ├── r-ml-anomaly/
    │   ├── r-ml-clustering/
    │   ├── r-ml-dimensionality/
    │   └── r-ml-interpretability/
    ├── r-web/              # Web 与报告 (25+ 个包)
    │   ├── r-web-shiny/
    │   ├── r-web-api/
    │   ├── r-web-scraping/
    │   └── r-web-reports/
    ├── r-spatial/          # 空间分析 (15+ 个包)
    │   ├── r-spatial-vector/
    │   ├── r-spatial-raster/
    │   ├── r-spatial-mapping/
    │   └── r-spatial-analysis/
    ├── r-network/          # 网络分析 (10+ 个包)
    │   ├── r-network-analysis/
    │   ├── r-network-viz/
    │   └── r-network-dynamic/
    ├── r-nlp/              # 自然语言处理 (12+ 个包)
    │   ├── r-nlp-text/
    │   ├── r-nlp-sentiment/
    │   └── r-nlp-topic/
    ├── r-stats/            # 统计分析 (17+ 个包)
    │   ├── r-stats-bayesian/
    │   ├── r-stats-finance/
    │   ├── r-stats-optimization/
    │   └── r-stats-timeseries/
    ├── r-bio/              # 生物信息学 (11+ 个包)
    │   ├── r-bio-rnaseq/
    │   ├── r-bio-genomics/
    │   └── r-bio-phylo/
    ├── r-dev/              # 开发工具 (20+ 个包)
    │   ├── r-dev-package/
    │   ├── r-dev-testing/
    │   ├── r-dev-oop/
    │   ├── r-dev-docs/
    │   └── r-dev-profiling/
    ├── r-parallel/         # 并行计算 (8+ 个包)
    │   ├── r-parallel-local/
    │   ├── r-parallel-distributed/
    │   └── r-parallel-cpp/
    ├── r-syntax/           # 语法扩展 (2 个包)
    ├── r-language-api/     # 语言接口 (5 个包)
    ├── r-logging/          # 日志框架 (3 个包)
    └── r-learning/         # 学习工具 (2 个包)
```

---

## 使用方式

安装后，当你进行以下操作时，Claude Code 会自动使用此技能：

```bash
# 询问 R 编程问题
"如何使用 dplyr 过滤数据？"

# 请求数据分析
"用 R 分析这个 CSV 文件"

# 创建可视化
"用 ggplot2 画一个散点图"

# 使用特定包
"教我用 tidymodels 做分类"

# 英文查询同样有效
"How do I use dplyr to filter data?"
"Create a ggplot2 scatter plot"
```

---

## 致谢

本项目的实现离不开以下贡献者：

- **[Hadley Wickham](https://hadley.nz/)** - tidyverse、ggplot2 及众多 R 贡献
- **[RStudio/Posit](https://posit.co/)** - R 生态系统和工具
- **[CRAN](https://cran.r-project.org/)** - R 包托管
- **[Bioconductor](https://bioconductor.org/)** - 生物信息学包
- **R 社区** - 创建了众多优秀的包

---

## 许可证

MIT 许可证 - 详见 [LICENSE](LICENSE)

---

## 贡献

欢迎提交 Issue 和 PR！你可以：
- 报告错误或不准确之处
- 建议添加新的包
- 改进文档
- 添加更多示例

---

*由 Leo 和 Claude 用 ❤️ 构建*
