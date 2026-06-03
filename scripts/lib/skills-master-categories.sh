#!/usr/bin/env bash
# skills-master-categories.sh
#
# Map Grimoire's 11 source-types onto skills-master's 12 categories.
# v2 addition (2026-06-03) — enables Grimoire output to be auto-routed
# to the right category in ~/.claude/skills/skills-master/references/categories/.
#
# Reference:
# - source-types.sh (11 types: book/course/paper/manual/article-collection/
#                   project-notes/video/audio/web/mixed)
# - skills-master/references/categories/ (12 categories: 01-functional ...
#                                                       12-cross-tool-paths)

if [[ -n "${GRIMOIRE_SKILLS_MASTER_CATEGORIES_LOADED:-}" ]]; then
    return 0
fi
GRIMOIRE_SKILLS_MASTER_CATEGORIES_LOADED=1

# Recommend skills-master category for a source.
#
# Args:
#   $1 source_type    (11-type, from classify_source_type)
#   $2 title_lc       (lowercase title for keyword match)
#   $3 platform       (optional: "bilibili" / "youtube" / "dlai" / "mit" / "csdiy" / ...)
#
# Output: "<NN>-<category-slug>"  e.g. "02-product-methodology"
recommend_skills_master_category() {
    local source_type="$1"
    local title_lc="$2"
    local platform="${3:-}"

    # 1. Platform-specific overrides (highest priority)
    case "$platform" in
        bilibili)
            # 5 道口纳什 UP system
            if printf '%s' "$title_lc" | grep -Eiq 'nashinfo|wdkns|五道口|纳什'; then
                printf '03-wdkns-system'; return
            fi
            printf '09-courses-other'; return
            ;;
        dlai|deeplearning.ai)
            printf '07-courses-dlai'; return
            ;;
        coursera|udacity|edx)
            printf '09-courses-other'; return
            ;;
        mit-ocw)
            printf '08-courses-mit'; return
            ;;
    esac

    # 2. Product methodology books (高价值 — 已蒸馏 6 本)
    if printf '%s' "$title_lc" | grep -Eiq 'inspired|build trap|continuous discovery|mom test|lean product|building ai.powered|cagan|perri|torres|fitzpatrick|olsen|nika'; then
        printf '02-product-methodology'; return
    fi

    # 3. Source-type → category default
    case "$source_type" in
        book)
            # 检测是否复杂系统 / 帝国主义 / Claude/Agent 主题
            if printf '%s' "$title_lc" | grep -Eiq 'complexity|chaos|network|scale|emergence'; then
                printf '05-books'  # 复杂系统主题，05 内分组
            elif printf '%s' "$title_lc" | grep -Eiq 'empire|imperialism|colonial'; then
                printf '05-books'  # 帝国主义，可走 book-imperialism-meta-index
            elif printf '%s' "$title_lc" | grep -Eiq 'claude|agent|llm|gpt|transformer'; then
                printf '05-books'  # 走 book-claude-code-and-agents-meta
            else
                printf '05-books'
            fi
            ;;
        course)
            # 默认 csdiy；MIT/DLAI 已被 platform 路由
            printf '06-courses-csdiy'
            ;;
        paper)
            # 5 道口 paper 系列优先
            if printf '%s' "$title_lc" | grep -Eiq 'wdkns|纳什|五道口'; then
                printf '03-wdkns-system'
            else
                printf '05-books'  # 学术论文当 book 容器处理
            fi
            ;;
        manual)
            printf '01-functional'
            ;;
        article-collection)
            printf '05-books'
            ;;
        project-notes)
            printf '01-functional'
            ;;
        video)
            if printf '%s' "$title_lc" | grep -Eiq 'wdkns|纳什|五道口'; then
                printf '03-wdkns-system'
            elif printf '%s' "$title_lc" | grep -Eiq 'crash course|crashcourse'; then
                printf '09-courses-other'
            else
                printf '09-courses-other'
            fi
            ;;
        audio)
            # podcast / interview
            printf '05-books'  # 暂归 books 容器
            ;;
        web)
            # 博客 / Substack / Lenny's Newsletter
            printf '05-books'
            ;;
        mixed)
            # 多源聚合 → meta-index
            printf '04-meta-index'
            ;;
        github-repo)
            # v2 新增源
            if printf '%s' "$title_lc" | grep -Eiq 'tool|cli|api|library'; then
                printf '01-functional'
            else
                printf '05-books'
            fi
            ;;
        obsidian-vault-segment)
            # v2 新增源 — 默认 books（具体由内容定）
            printf '05-books'
            ;;
        *)
            printf '05-books'  # 兜底
            ;;
    esac
}

# Recommend skill type (thin/thick/meta) for a source.
#
# Args:
#   $1 source_type
#   $2 estimated_volume  ("low" | "medium" | "high" 内容量预估)
recommend_skill_type() {
    local source_type="$1"
    local volume="${2:-medium}"

    case "$source_type" in
        # 产品方法论书 → 3 skill (1 薄 + 2 厚)
        book)
            if [[ "$volume" == "high" ]]; then
                printf 'thin-index + 2 thick-workflow'  # book-distill-pipeline 模式
            else
                printf 'thin-index'
            fi
            ;;
        paper|article-collection|audio|web)
            printf 'thin-index'
            ;;
        course|video)
            printf 'thin-index'  # 大多课程是容器型
            ;;
        manual|project-notes|github-repo)
            printf 'thick-workflow'  # 操作型
            ;;
        mixed)
            printf 'meta-index'  # 聚合型
            ;;
        *)
            printf 'thin-index'
            ;;
    esac
}

# Write recommendation into manifest.json (called from forge.sh / grimoire.sh)
#
# Args:
#   $1 manifest_path
#   $2 source_type
#   $3 title_lc
#   $4 platform (optional)
write_skills_master_recommendation() {
    local manifest="$1"
    local source_type="$2"
    local title_lc="$3"
    local platform="${4:-}"

    local cat=$(recommend_skills_master_category "$source_type" "$title_lc" "$platform")
    local type=$(recommend_skill_type "$source_type" "medium")

    # JSON snippet (will be merged into manifest by manifest builder)
    cat <<EOF
{
  "skills_master": {
    "recommended_category": "$cat",
    "recommended_skill_type": "$type",
    "category_file": "~/.claude/skills/skills-master/references/categories/${cat}.md",
    "placement_workflow": "~/.claude/skills/skills-master/references/workflows/skill-placement-decision.md",
    "integration_workflow": "~/.claude/skills/skills-master/references/workflows/integrate-external-skill.md"
  }
}
EOF
}

# Lookup category description (for human-readable output)
category_description() {
    case "$1" in
        01-functional) printf 'Functional skills (CCB/Knowledge/Content/Doc/Browser/3D)' ;;
        02-product-methodology) printf 'Product methodology (6 books × 3 + 1 mother)' ;;
        03-wdkns-system) printf 'wdkns UP system (up + series + child)' ;;
        04-meta-index) printf 'Meta-index aggregating multiple skills' ;;
        05-books) printf 'Book containers' ;;
        06-courses-csdiy) printf 'CSDIY 自学路径课程' ;;
        07-courses-dlai) printf 'DeepLearning.AI 课程' ;;
        08-courses-mit) printf 'MIT OCW 政治学/IR' ;;
        09-courses-other) printf 'OSSU/CX/CrashCourse/Coursera' ;;
        10-plugin-namespaces) printf 'Plugin namespaces (codex/cn/anthropic-skills)' ;;
        11-archive-history) printf 'Archived skills (rollback-able)' ;;
        12-cross-tool-paths) printf 'Cross-tool sharing (Codex/Cursor)' ;;
        *) printf 'Unknown category' ;;
    esac
}
