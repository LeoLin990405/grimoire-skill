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
- [内置来源技能](#内置来源技能--bundled-source-skills)
- [一条命令：书 / 视频 → 笔记 + 技能](#一条命令书--视频--笔记--技能--one-command)
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
| **脚本默认不装 skill** | 技能包里的 skill 默认全是候选态（candidate），需人工审查后晋升。**例外**：显式传 `grimoire.sh --install` 或显式调用 `scripts/skill-install.sh` 时，会按用户明确选择的 agent 安装——这是**经用户明确请求、刻意跨越**候选边界，并记录在 manifest 的 `red_line_note` 里 |
| **两段式·笔记→技能** | 一份合同（`GRIMOIRE_TASK.md`），两个顺序阶段：阶段 1 从源文写类型化笔记；阶段 2 是刻意的「重复学习」——**从刚写好的笔记**（而非原始正文）里挖技能包 |
| **纯文本入口** | `grimoire.sh --from-text <file\|->` 跳过 MinerU，把原始文本/标准输入直接当源走 notes/skills 管线（配 `--only skills` 即「文本→技能」） |
| **跨 agent 管理** | `scripts/skill-manage.sh`：`status`/`list`/`sync`/`uninstall`/`gate`；逐包操作，绝不动某个 agent 自有的非共享 skill |

### English

| Principle | Detail |
|-----------|--------|
| **Parse once** | MinerU runs exactly once; both the notes pipeline and the skill-pack pipeline share the same extracted Markdown |
| **Scripts never call an LLM** | All shell scripts are pure text processors; `GRIMOIRE.md.json` records `llm_invoked: false` |
| **Scripts never write into the vault** | Note scaffolds are generated, but the Obsidian write happens only after the agent passes a quality self-check |
| **Scripts never install skills (by default)** | Extracted skills are candidates by default. **Exception:** passing `grimoire.sh --install` or invoking `scripts/skill-install.sh` directly installs into the agents the user explicitly chooses — a deliberate boundary crossing **by explicit user request**, recorded in the manifest's `red_line_note` |
| **Two-stage, notes→skills** | One contract (`GRIMOIRE_TASK.md`), two sequential stages: Stage 1 writes the notes from the source; Stage 2 is a deliberate re-learning pass that mines the skill pack **from the notes the agent just wrote**, not the raw source (重复学习) |
| **Raw-text input** | `grimoire.sh --from-text <file\|->` skips MinerU and runs the notes/skills pipeline straight from raw text or stdin (with `--only skills` = text → skill) |
| **Cross-agent management** | `scripts/skill-manage.sh` — `status`/`list`/`sync`/`uninstall`/`gate`; per-pack only, never touches an agent's own non-shared skills |

---

## 内置来源技能 · Bundled Source Skills

仓库自带 4 个「来源获取」技能（`skills/`），让 PDF/视频 → 可读文本这一步在仓库内自洽：

| Skill | 作用 | 喂给 grimoire 的方式 |
|---|---|---|
| `skills/mineru-local` | PDF/DOC/PPT/图片 → Markdown（本地 MinerU + 云端 fallback，一行 `pdf2md`）。**第一来源：PDF 书籍**经它转 MD 再读 | 产出 MD → `grimoire.sh --from-markdown <md>` |
| `skills/mineru` | 旧版纯云端 MinerU API（异步任务 + ZIP，带 examples） | 同上 |
| `skills/kedou-media-workflow` | 蝌蚪网页解析：在线视频解析、批量字幕/弹幕/歌词提取、图文提取 | 抓到字幕文本 → `grimoire.sh --from-text <txt>` |
| `skills/youtube-clipper` | YouTube 下载 + 字幕 + AI 分章 + 中英双语字幕 | 字幕文本 → `grimoire.sh --from-text -` |

> **脱敏说明**：`mineru-local` 原本硬编码了作者内网 tailnet 主机，移植进本仓库时
> 已改为环境变量 `MINERU_LOCAL_URL`（默认 `http://127.0.0.1:8010`）。
> `youtube-clipper` 只保留 `.env.example`，不提交真实 `.env`（`.gitignore` 已加守卫）。
> 这些是经用户明确请求纳入仓库的来源技能；安装/启用仍走 `grimoire-manage` 的显式流程。

---

## 一条命令：书 / 视频 → 笔记 + 技能 · One Command

`scripts/forge.sh` 把「取文本 → 炼魔典」两步合一,自动识别输入并选对来源技能:

```bash
# 书籍 / 文档（自动 pdf2md / MinerU → MD → 笔记+技能）
scripts/forge.sh ~/books/deep-work.pdf --only both
scripts/forge.sh https://arxiv.org/pdf/1706.03762 --only both

# 视频（自动 yt-dlp 抓字幕 → 文本 → 笔记+技能）
scripts/forge.sh "https://youtu.be/XXXX" --only both

# B站：自动走 Kedou 网页（OpenCLI 驱动，比 yt-dlp 更可靠拿中文字幕）
scripts/forge.sh "https://www.bilibili.com/video/BV..." --only both
#   --bili-via kedou|ytdlp|auto（默认 auto：装了 opencli 走 kedou，否则 yt-dlp）
# 也可单独取字幕：
SRT="$(scripts/kedou-bili-subs.sh https://www.bilibili.com/video/BV...)"

# B站整个 UP 空间批量（可续跑、限额感知）
scripts/kedou-bili-batch.sh "https://space.bilibili.com/<id>" --out-dir ./kedou-bili
scripts/kedou-bili-batch.sh ./kedou-bili/manifests/videos.jsonl --resume   # 次日续跑
scripts/kedou-bili-batch.sh --status --out-dir ./kedou-bili
#   manifest 单独构建：scripts/kedou-bili-manifest.sh <space-url> --out videos.jsonl
#   （直连空间 API 会风控 412/-352，故经 OpenCLI 捕获页面自身请求）

# 已有 Markdown / 纯文本 / 字幕文件，直接进
scripts/forge.sh notes.md --only skills
scripts/forge.sh talk.srt --title "某讲座"

scripts/forge.sh <input> --dry-run    # 只看路由与命令，不执行
scripts/forge.sh <input> --install    # 顺带跨 agent 安装（透传 grimoire）
```

路由:`*.pdf/doc/ppt/img | arXiv URL → mineru-local pdf2md`;`B站 URL → Kedou
(OpenCLI) 或 yt-dlp`;`其它 youtube/vimeo/… → yt-dlp 字幕`;`*.md →
--from-markdown`;`*.txt/.srt/.vtt → --from-text`。B站字幕→笔记的完整 recipe
与坑见 `skills/kedou-media-workflow/references/bilibili-subtitle-to-note.md`;
字幕笔记模板 `templates/subtitle-note-template.md`(脚本只搭脚手架,agent 填写)。
整空间批量见 `kedou-bili-batch.sh`(清单经 OpenCLI 捕获、`progress.jsonl` 可续跑、
限额感知);**刻意只用 Kedou 公网页面、不内置 Kedou API 加密复刻**。

> **边界不变**:forge 只做「确定性取文本」(pdf2md / yt-dlp,不调 LLM)。笔记与
> 技能仍由 agent 执行产出的 `GRIMOIRE_TASK.md` 合同来写——脚本不调 LLM 的红线保留。
> 运行前自动跑 `skill-manage.sh doctor`,缺必需依赖会先报错并给出修复指引
> (`--skip-doctor` 可跳过)。

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

# MD-first：已经有 Markdown（如 pdf2md / mineru-local 的产物），
# 用户此时才主动选择续跑魔典 —— 不重新上传、不重复解析。
~/.claude/skills/grimoire/scripts/grimoire.sh \
    --from-markdown ./mineru-extracted/book \
    --title "Source Title" \
    --only both          # 或：notes | skills
```

> **流程是「带闸门」的,不是自动的 · A gated, not automatic, flow**
> 先把来源转成 Markdown(`pdf2md` / `mineru-local`)——很多需求**到此为止**。
> 只有当用户确实想要读书笔记 / 把内容封装成 skill 工程提示时,才用
> `--from-markdown` 从那份 MD **主动续跑**。`--only notes|skills|both`
> 是第二道 opt-in。Grimoire 不抢 `mineru-local` 的触发词,它是 MD 之后
> 刻意为之的下一步。
> *Markdown first; notes and skill-packaging are deliberate opt-in
> continuations from that Markdown — nothing is re-uploaded or re-parsed.*

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

# 把这个文件的路径告诉 Agent，它会（两段式）：
# 阶段1: 逐段读源文，写类型化笔记，质检后写入 Obsidian vault
# 阶段2: 重复学习——回头读自己写的笔记，从知识点里挖技能候选
#        完成 whole-book 合并，技能仅为候选待人工评审
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
├── GRIMOIRE_TASK.md         # Agent 合同（两段式：阶段1 笔记 → 阶段2 从笔记挖技能）
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
| `awk` / `find` | Markdown 分段 / 文件枚举 |
| MinerU token | `~/.config/mineru/token`（云端 fallback 用），从 [mineru.net/apiManage/token](https://mineru.net/apiManage/token) 获取 |
| `pdf2md` *(可选)* | 本地 MinerU 一行转 MD（`skills/mineru-local`）；缺失时 `forge.sh` 回退到 grimoire 原生云端解析 |
| `yt-dlp` + `ffmpeg` *(视频)* | `forge.sh` 视频→字幕路径（YouTube 等） |
| `opencli` *(B站)* | `kedou-bili-subs.sh` / `forge.sh` 的 B站 Kedou 字幕路径；缺失则 B站回退 yt-dlp |

> 用 `scripts/skill-manage.sh doctor [--skill <name>]` 一键体检宿主依赖（缺必需项报错并给修复指引）。

### 环境变量 · Environment Variables

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `MINERU_OBSIDIAN_VAULT` | Obsidian vault 根目录 | `~/Documents/Obsidian-Vaults/Knowledge-Hub` |
| `GRIMOIRE_PARSER` | 替换云端解析器（用于本地 MinerU） | `scripts/mineru-parse.sh` |
| `MINERU_TOKEN_FILE` | Token 文件路径 | `~/.config/mineru/token` |
| `MINERU_API_BASE` | API 基础 URL | `https://mineru.net/api/v4` |
| `MINERU_LOCAL_URL` | 本地 MinerU 服务地址（`skills/mineru-local`，已脱敏为可配置） | `http://127.0.0.1:8010` |

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
  --from-markdown <p>  跳过 MinerU，从已转好的 Markdown 文件/目录续跑
  --from-text <p|->    跳过 MinerU，原始文本/标准输入当源（配 --only skills 即文本→技能）
  --cloud-ok         确认本地文件上传到云端
  --install          产出后追加跨 agent 安装步骤到合同（显式可选，记入 manifest）
  --force            覆盖已存在的 grimoire
```

> 多数情况直接用 **`scripts/forge.sh <书|视频|文本>`** 一条命令即可（自动判类型、
> 取文本、调 grimoire）；见上文「一条命令」。

---

## 项目结构 · Project Structure

```
grimoire-skill/
├── scripts/
│   ├── forge.sh                 # ★ 一条命令入口：书/视频/文本 自动路由 → grimoire
│   ├── grimoire.sh              # 主管线：解析 → 笔记包 + 技能包 → 统一合同
│   ├── reading-notes-pack.sh    # 笔记管线：分类 + 分段 + 脚手架
│   ├── source-skill-pack.sh     # 技能管线：分段 + 提炼工作区
│   ├── mineru-parse.sh          # MinerU 云端解析 CLI 封装
│   ├── kedou-bili-subs.sh       # B站 Kedou 字幕下载（OpenCLI 驱动，--dry-run）
│   ├── skill-install.sh         # 跨 agent 安装产出技能（显式 opt-in，记 manifest）
│   ├── skill-manage.sh          # 管理：scan/doctor/status/list/sync/uninstall/gate
│   ├── mineru-to-notes.sh / mineru-source-to-skill.sh  # 解析+笔记/技能（独立模式）
│   ├── vivo-workspace.sh / vivo-note-template.sh        # Vivo 多源 agent workspace
│   ├── book-skill-pack.sh · mineru-book-to-skill.sh · vivo-agent-workspace.sh
│   │                             #   ⚠️ 已弃用 compat wrapper（仍转发，将移除）
│   └── lib/
│       ├── common.sh            # 通用工具（slugify/require_cmd/ensure_fresh_dir…）
│       ├── reading-types.sh     # 阅读类型分类器（book/paper/document）
│       ├── source-types.sh      # 11 类来源类型分类器（技能包用）
│       ├── segment.sh           # 共享 Markdown 分段器（笔记+技能共用）
│       └── agent-targets.sh     # 跨 agent 拓扑（copy/symlink、漂移备份、逐包）
├── skills/                      # 内置来源/管理技能（见「内置来源技能」）
│   ├── mineru-local/ · mineru/  # PDF/DOC/PPT/img → Markdown（本地+云）
│   ├── kedou-media-workflow/    # 网页视频/字幕解析（含 B站→笔记 recipe）
│   ├── youtube-clipper/         # YouTube 下载+字幕+分章
│   └── grimoire-manage/         # 跨 agent 安装/管理的配套技能
├── templates/
│   ├── reading-notes/{book,paper,document}-notes.md
│   ├── subtitle-note-template.md   # 字幕笔记固定模板（agent 填，脚本不写 vault）
│   └── vivo/…
├── docs/                        # reading-notes / vivo / skill-manager 参考
├── examples/                    # 旗舰 + 单步示例
├── tests/run.sh + Makefile      # `make test` 离线测试套件（143/0）
├── SKILL.md                     # Skill 元数据、API 参考、触发词
├── CHANGELOG.md · CONTRIBUTING.md · LICENSE
```

---

## 许可证 · License

MIT — 详见 [LICENSE](LICENSE)。

---

<details>
<summary>📜 兼容性说明 · Legacy Compatibility</summary>

这 3 个是 **已弃用的兼容封装**：调用时会向 stderr 打印 `[deprecated]` 提示，
但仍原样转发（出参/退出码不变），将在未来大版本移除。推荐直接用目标脚本，
或更上层的 `forge.sh` / `grimoire.sh`：

| 已弃用 wrapper | 转发目标（请改用） |
|--------|-----------|
| `book-skill-pack.sh` | `source-skill-pack.sh` |
| `mineru-book-to-skill.sh` | `mineru-source-to-skill.sh` |
| `vivo-agent-workspace.sh` | `vivo-workspace.sh` |

（`mineru-to-notes.sh` / `mineru-source-to-skill.sh` 不是弃用 wrapper，是
解析+笔记/技能的独立 compound 脚本，继续可用。）

</details>
