# Grimoire · 魔典

> **一次解析，两件器物。**  
> **One parse. Two artifacts. One agent contract.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Shell](https://img.shields.io/badge/Shell-Bash-4EAA25?logo=gnu-bash)](scripts/grimoire.sh)
[![MinerU](https://img.shields.io/badge/Powered%20by-MinerU-blue)](https://mineru.net)
[![Obsidian](https://img.shields.io/badge/Vault-Obsidian-7C3AED)](https://obsidian.md)

---

## 目录 · Contents

- [一句话定位](#一句话定位--positioning)
- [核心理念](#核心理念--core-philosophy)
- [快速开始](#快速开始--quick-start)
- [阅读类型](#阅读类型--reading-types)
- [Workspace 目录结构](#workspace-目录结构--workspace-layout)
- [技能包管线](#技能包管线--skill-pack-pipeline)
- [Obsidian 落地](#obsidian-落地--obsidian-integration)
- [隐私与边界](#隐私与边界--privacy--boundaries)
- [模型说明](#模型说明--model-notes)
- [安装与配置](#安装与配置--installation--configuration)
- [项目结构](#项目结构--project-structure)
- [许可证](#许可证--license)

---

## 一句话定位 · Positioning

**中文：** Grimoire（魔典）把一份 PDF 或文档「一次解析」，同时炼出两件器物：落进 Obsidian 知识库的**类型化阅读笔记**，以及按书/课程合并的**可复用技能包**。脚本只管解析和脚手架，真正的阅读与炼金由 Agent 来完成。

**English:** Grimoire parses a PDF or document once, producing two bound artifacts in a single workspace: typed **reading notes** destined for your Obsidian vault, and a per-source **skill pack** of reusable agent capabilities. The scripts scaffold only — no LLM is called, no vault file is written, no skill is installed. The agent does the reading and the refining.

---

## 核心理念 · Core Philosophy

### 中文

| 原则 | 说明 |
|------|------|
| **一次解析** | MinerU 只跑一次，解析产物由笔记管线和技能包管线共享，不重复付费、不重复等待 |
| **脚本不调 LLM** | 所有 shell 脚本纯文本处理，零 AI 调用；`GRIMOIRE.md.json` 会明确记录 `llm_invoked: false` |
| **脚本不写 vault** | 笔记模板由脚本生成，但写入 Obsidian 知识库的操作由 Agent 在质量自检通过后执行 |
| **脚本不装 skill** | 技能包里的 skill 全是候选态（candidate），需要人工审查后，通过 `skills-mgr` 手动晋升 |
| **Agent 来填** | 脚本交出的是合同（`GRIMOIRE_TASK.md`）：同一段正文，Agent 一次阅读，同时写笔记并挖掘技能 |

### English

| Principle | Detail |
|-----------|--------|
| **Parse once** | MinerU runs exactly once; both the notes pipeline and the skill-pack pipeline share the same extracted Markdown |
| **Scripts never call an LLM** | All shell scripts are pure text processors; `GRIMOIRE.md.json` records `llm_invoked: false` |
| **Scripts never write into the vault** | Note scaffolds are generated, but the Obsidian write happens only after the agent passes a quality self-check |
| **Scripts never install skills** | All extracted skills are candidates; promotion into a managed skill repository requires human review and a separate `skills-mgr` invocation |
| **The agent fills both** | The agent receives a single contract (`GRIMOIRE_TASK.md`) and makes one reading pass — writing the note and mining skills for the same segment simultaneously |

---

## 快速开始 · Quick Start

### 1. 安装 · Install

```bash
# 把仓库克隆到 Claude Code 的 skills 目录（skill name: grimoire）
git clone https://github.com/LeoLin990405/grimoire-skill \
    ~/.claude/skills/grimoire
```

### 2. 配置 MinerU Token · Configure MinerU Token

```bash
mkdir -p ~/.config/mineru
echo "YOUR_TOKEN_HERE" > ~/.config/mineru/token
chmod 600 ~/.config/mineru/token
# 在 https://mineru.net/apiManage/token 获取 token
```

### 3. 一条命令，炼出魔典 · One Command

```bash
# 本地 PDF（本地文件会上传到 MinerU 云端，--cloud-ok 是必须的确认项）
~/.claude/skills/grimoire/scripts/grimoire.sh /path/to/book.pdf --cloud-ok

# 公开 URL（无需 --cloud-ok）
~/.claude/skills/grimoire/scripts/grimoire.sh https://arxiv.org/pdf/xxxx.pdf

# 指定标题、类型、只炼笔记
~/.claude/skills/grimoire/scripts/grimoire.sh paper.pdf \
    --title "Attention Is All You Need" \
    --type paper \
    --only notes \
    --cloud-ok

# 指定页面范围、启用 OCR
~/.claude/skills/grimoire/scripts/grimoire.sh textbook.pdf \
    --pages "1-120,200-250" \
    --ocr \
    --cloud-ok
```

### 4. 中文自然语言触发示例 · Chinese Trigger Examples

在 Claude Code 中，以下说法均可触发 `grimoire` skill：

```
帮我读这个 PDF，写读书笔记并提炼 skill
把这本书炼成魔典
解析这篇论文，落进 Obsidian
这个文档帮我写笔记
从这本书里提炼 skill
```

### 5. 把合同交给 Agent · Hand the Contract to the Agent

```bash
# grimoire.sh 完成后，产出路径形如：
./grimoires/<slug>/GRIMOIRE_TASK.md

# 把这个文件的路径告诉 Agent，它会：
# 1. 逐段阅读 notes/ 和 skills/ 共享的分段 Markdown
# 2. 同时写笔记 + 挖掘技能候选
# 3. 完成 whole-book 合并后，将笔记写入 Obsidian vault
```

---

## 阅读类型 · Reading Types

分类器是「**启发式打分 + 低置信 AI 兜底**」的混合机制，由 `scripts/lib/reading-types.sh` 实现，**从不调用 LLM**。

> The classifier is a **hybrid of deterministic heuristic scoring and an AI confirmation fallback**. It is implemented in `scripts/lib/reading-types.sh` and **never calls an LLM itself**.

### 三种类型 · Three Buckets

| 类型 | 触发信号 | 笔记规程 | Vault 目标文件夹 |
|------|----------|----------|-----------------|
| `book` | ≥2 个 `第N章`/`Chapter N`，目录，ISBN，≥60 页 | **逐章完整笔记**：核心问题、论证展开、关键术语、证据锚点、章间衔接、全书综合 | `Books/` |
| `paper` | `abstract`、DOI/arXiv、`references`、`related work`、学术会场标识 | **结构化精读 + 摘录**：研究问题、贡献、方法、实验、结果、局限、批判；不分段，整体阅读 | `Papers/` |
| `document` | API 参考、安装/配置/troubleshooting、季报、spec、slides；或短文档（≤25 页）且无书/论文信号 | **内容自适应结构化要点**：按文档自身结构拆解，手册→操作步骤+参数+约束，报告→结论+证据，规范→规则+边界 | `Documents/` |

### 置信度与 AI 兜底 · Confidence and AI Fallback

```
高分差（score ≥ 5, margin ≥ 3）  →  confidence: high   → 直接推进
中分差（score ≥ 3, margin ≥ 2）  →  confidence: medium  → 直接推进
低分差                           →  confidence: low    → 生成 AI_CLASSIFY.md
```

当置信度为 `low` 时，脚本在 `notes/` 下额外生成 `AI_CLASSIFY.md`，内含文本样本和严格的三选一决策合同。Agent 必须先完成 **Step 0**（确认或推翻启发式判断）再开始阅读。若 Agent 的判断与启发式结果不同，它会用正确的 `--type` 重新运行 `reading-notes-pack.sh`。

> When confidence is `low`, the pack generates `AI_CLASSIFY.md` with a text sample and a strict `book`/`paper`/`document` decision contract. The agent runs **Step 0** before reading; if it disagrees with the heuristic it re-runs `reading-notes-pack.sh --type <correct-type>`.

手动覆盖始终可用：`--type book|paper|document`（跳过分类，置信度直接设为 `high`）。

---

## Workspace 目录结构 · Workspace Layout

`grimoire.sh` 的产出路径（以 `./grimoires/<slug>/` 为根）：

```
./grimoires/<slug>/
│
├── GRIMOIRE.md              # 统一状态面板：类型、页数、vault 目标、边界声明
├── GRIMOIRE.md.json         # 机器可读版本（schema: grimoire.workspace.v1）
├── GRIMOIRE_TASK.md         # Agent 阅读合同（笔记 + 技能，同一 pass）
├── README.md                # 人类可读摘要
│
├── source/                  # 原始文件（PDF/DOC/PPT）或 source_url.txt
│
├── mineru/                  # MinerU 解析产物（仅此一份，两半共享）
│   ├── parse_manifest.json  # 解析清单（含 extract_dir、page_count）
│   └── <extracted .md ...>  # MinerU 输出的 Markdown
│
├── notes/                   # 阅读笔记包（reading-notes-pack.sh 产出）
│   ├── manifest.json        # 类型、置信度、vault_target、llm_invoked: false
│   ├── classification.json  # 详细分类信号
│   ├── AI_CLASSIFY.md       # 仅在 confidence: low 时生成
│   ├── AI_READING_TASK.md   # 笔记阅读合同（entry point for notes half）
│   ├── OBSIDIAN_PLAN.md     # vault 落地路径 + 行文规范
│   ├── source-markdown/     # 复制过来的 MinerU Markdown
│   ├── segments/            # 章/节分段（book/document；paper 不分段）
│   │   ├── manifest.json
│   │   └── 001-<chapter>.md
│   └── notes/<slug>.md      # 笔记模板（来自对应类型的 template）
│
└── skills/                  # 技能包（source-skill-pack.sh 产出）
    ├── manifest.json        # schema: mineru.longform-skill-pack.v2
    ├── LLM_EXTRACTION_PROMPT.md
    ├── BOOK_SKILL_INDEX.md
    ├── MANAGE_SKILLS.md     # 晋升边界与 skills-mgr 使用说明
    ├── MINDMAP.md
    ├── SKILL_DISCOVERY_COVERAGE.md
    ├── source-markdown/
    ├── segments/
    │   ├── manifest.json
    │   └── 001-<chapter>.md
    ├── chapter-skills/
    │   └── 001-<chapter>/
    │       ├── CHAPTER_SKILL_INDEX.md
    │       └── skills/
    │           └── _skill-template.md
    ├── whole-book/
    │   └── WHOLE_BOOK_SUMMARY.md
    └── skills/              # 仅存放已审查的跨段候选 skill
        ├── README.md
        └── _skill-template.md
```

> **注意**：`notes/` 和 `skills/` 下的 `segments/` 是同一份 Markdown 的两份镜像，由同一个分段器（`scripts/lib/segment.sh`）生成，段序完全对齐。Agent 可以 `skills/segments/manifest.json` 为规范顺序，`notes/segments/` 与之一一对应。
>
> **Note:** Both `notes/segments/` and `skills/segments/` mirror the same parsed Markdown, split identically by the shared segmenter in `scripts/lib/segment.sh`. Use `skills/segments/manifest.json` as the canonical order; the notes segments line up one-to-one.

---

## 技能包管线 · Skill Pack Pipeline

### 炼金路径 · The Refining Path

```
PDF / DOC / URL
      │
      ▼  grimoire.sh —— MinerU 解析（一次）
      │
      ├──► reading-notes-pack.sh  ──► notes/  （笔记脚手架）
      │
      └──► source-skill-pack.sh  ──► skills/ （技能脚手架）
                                              │
                              ┌───────────────┤ 全部交给 Agent
                              │  GRIMOIRE_TASK.md（单一合同）
                              ▼
                     Agent 逐段阅读（一 pass，两件事）
                     ┌─────────────────────────┐
                     │  Step 1+2: 写笔记         │  → notes/<slug>.md
                     │  Step 1+2: 挖掘技能候选  │  → chapter-skills/*/skills/
                     │  Step 3:   whole-book 合并│  → whole-book/WHOLE_BOOK_SUMMARY.md
                     │  Step 4:   笔记写入 vault │  → Obsidian vault
                     └─────────────────────────┘
```

### 技能候选的晋升路径 · Skill Promotion Path

| 阶段 | 位置 | 状态 |
|------|------|------|
| 段级草稿 | `skills/chapter-skills/<seg>/skills/*.md` | `draft` (candidate) |
| 跨段复审 | `skills/skills/*.md` | reviewed candidate |
| 全书合并 | `skills/whole-book/WHOLE_BOOK_SUMMARY.md` + `BOOK_SKILL_INDEX.md` | 综合评审 |
| 晋升为托管 skill | `~/.claude/skills/<skill-name>/` | 由 `skills-mgr` 启用 |

**晋升规则（来自 `MANAGE_SKILLS.md`）：**

- 段级草稿先在 `chapter-skills/*/skills/` 中堆积，不自动流出
- 只有经过人工审查、确认为「普遍可用」的跨段候选才能写入根级 `skills/`
- 最终晋升需要显式执行 `skills enable <skill-name>`，不存在自动安装路径
- 不得在 skill 文件中存储 API token、auth header、私账数据或远程结果 URL

---

## Obsidian 落地 · Obsidian Integration

### 目标路径解析 · Vault Target Resolution

| 阅读类型 | Vault 子文件夹 |
|----------|---------------|
| `book`   | `Books/`      |
| `paper`  | `Papers/`     |
| `document` | `Documents/` |

Vault 根目录优先级：`--vault <path>` > `$MINERU_OBSIDIAN_VAULT` > `~/Documents/Obsidian-Vaults/Knowledge-Hub`

### 落地流程（Agent 执行）· Landing Flow (Agent Executes)

1. 打开目标文件夹中一个已有的同级笔记，镜像其 frontmatter 键名、标题风格和语言
2. 填写 `notes/<slug>.md`（从对应类型的模板 `templates/reading-notes/<type>-notes.md` 生成）
3. 通过质量自检：
   - 实质合成内容 > 2KB（目标 > 5KB）
   - 含证据锚点（章节/§/页码）
   - 含 `[[wikilinks]]` 交叉引用
   - 无未填写的模板占位符（`<...>`、空表格行）
4. 将笔记写入 `OBSIDIAN_PLAN.md` 中指定的 vault 目标路径
5. 在 vault 根目录的 `log.md` 追加一行：`## [YYYY-MM-DD] ingest | <title> -> <folder>/<slug>.md`

> **边界**：所有 `manifest.json` 均记录 `writes_into_vault: false`。脚手架阶段零 vault 写入。
>
> **Boundary:** All `manifest.json` files record `writes_into_vault: false`. Zero vault writes occur during scaffolding.

---

## 隐私与边界 · Privacy & Boundaries

```
本地文件上传云端 = 数据离开你的机器
Local file upload = data leaves your machine
```

- `grimoire.sh` 对本地文件强制要求 `--cloud-ok` 标志；没有此标志直接报错退出
- 公开 URL 无需 `--cloud-ok`（文件本就是公开的）
- 需要处理私密/受版权保护文档时，请使用本地 MinerU 工作流并设置环境变量 `GRIMOIRE_PARSER` 指向本地解析脚本

```bash
# 使用本地 MinerU（替换云端解析器）
GRIMOIRE_PARSER=/path/to/local-mineru-parse.sh \
    grimoire.sh /private/confidential.pdf
```

- 生成的 workspace 中不得出现 API token、auth header、远程结果 URL
- `GRIMOIRE.md.json` 记录 `stores_remote_result_url: false`

---

## 模型说明 · Model Notes

| 模型 | 状态 | 说明 |
|------|------|------|
| `vlm` | **默认，推荐** | MinerU 2.5，复杂版式最高精度；云端首选；本地需 GPU |
| `pipeline` | 可用 | 通用文档，支持纯 CPU，精度略低 |
| `MinerU-HTML` | 可用 | 保留 HTML 格式，适合 Web 内容 |
| `hybrid` | **已退役** | 云端 API 于 2026-04 下线，调用返回 `code -10002 "version field invalid"`，请勿使用 |

> `hybrid` was the default model before April 2026. The MinerU cloud API has since retired it — any request with `model_version: hybrid` returns `-10002`. The default is now `vlm`.

---

## 安装与配置 · Installation & Configuration

### 依赖 · Dependencies

| 工具 | 用途 |
|------|------|
| `bash` 3.2+ | 所有脚本的运行时（兼容 macOS 自带 bash 3.2） |
| `jq` | JSON 处理（`manifest.json` 生成与读取） |
| `awk` | Markdown 分段 |
| `find` | 文件枚举 |
| MinerU token | `~/.config/mineru/token`，从 [mineru.net/apiManage/token](https://mineru.net/apiManage/token) 获取 |

### 环境变量 · Environment Variables

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `MINERU_OBSIDIAN_VAULT` | Obsidian vault 根目录 | `~/Documents/Obsidian-Vaults/Knowledge-Hub` |
| `GRIMOIRE_PARSER` | 替换云端解析器（用于本地 MinerU） | `scripts/mineru-parse.sh` |
| `MINERU_TOKEN_FILE` | Token 文件路径 | `~/.config/mineru/token` |
| `MINERU_API_BASE` | API 基础 URL | `https://mineru.net/api/v4` |

### grimoire.sh 完整选项 · Full Options

```
Usage: grimoire.sh <url_or_file> [options]

  --title <title>    源标题（默认取文件名/URL basename）
  --slug <slug>      workspace + vault note 的 slug
  --type <type>      auto（默认）| book | paper | document
  --only <what>      both（默认）| notes | skills
  --model <m>        vlm（默认）| pipeline | MinerU-HTML
  --ocr              启用 OCR
  --pages <range>    页面范围，如 "1-50,80-120"
  --agent <name>     阅读 Agent 名称（写入合同文件）
  --vault <path>     Obsidian vault 根目录
  --output <dir>     输出根目录（默认 ./grimoires）
  --cloud-ok         确认本地文件上传到云端
  --force            覆盖已存在的 grimoire
```

---

## 项目结构 · Project Structure

```
grimoire-skill/
├── scripts/
│   ├── grimoire.sh              # 主入口：解析 → 笔记包 + 技能包 → 统一合同
│   ├── reading-notes-pack.sh    # 笔记管线：分类 + 分段 + 脚手架
│   ├── source-skill-pack.sh     # 技能管线：分段 + 提炼工作区
│   ├── mineru-parse.sh          # MinerU 云端解析 CLI 封装
│   ├── mineru-to-notes.sh       # 解析 + 笔记（独立模式）
│   ├── mineru-source-to-skill.sh # 解析 + 技能包（独立模式）
│   ├── vivo-workspace.sh        # Vivo agent workspace（多源混合模式）
│   └── lib/
│       ├── common.sh            # 通用工具函数（slugify、require_cmd 等）
│       ├── reading-types.sh     # 阅读类型分类器（book/paper/document）
│       ├── source-types.sh      # 11 类来源类型分类器（技能包用）
│       └── segment.sh           # 共享 Markdown 分段器（笔记+技能共用）
├── templates/
│   └── reading-notes/
│       ├── book-notes.md        # 逐章笔记模板
│       ├── paper-notes.md       # 结构化精读模板
│       └── document-notes.md    # 内容自适应笔记模板
├── docs/
│   ├── reading-notes-workflow.md   # 笔记工作流详解
│   ├── vivo-agent-workflow.md      # Vivo 多源工作流
│   └── open-source-skill-manager-references.md
├── examples/
│   ├── pdf_to_notes.sh
│   └── book_to_skill.sh
├── SKILL.md                     # Skill 元数据、API 参考、触发词
├── CHANGELOG.md
├── CONTRIBUTING.md
└── LICENSE
```

---

## 许可证 · License

MIT — 详见 [LICENSE](LICENSE)。

---

<details>
<summary>📜 兼容性说明 · Legacy Compatibility</summary>

以下脚本是更早工作流的兼容封装，仍可使用，但新工作流推荐直接使用 `grimoire.sh`：

| 旧脚本 | 等价新命令 |
|--------|-----------|
| `mineru-book-to-skill.sh` | `grimoire.sh --only skills` |
| `book-skill-pack.sh` | `source-skill-pack.sh` |
| `mineru-to-notes.sh` | `grimoire.sh --only notes` |
| `vivo-agent-workspace.sh` | `vivo-workspace.sh`（多源模式） |

</details>
