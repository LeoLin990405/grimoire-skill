#!/usr/bin/env bash
# Reading-note source classifier shared by the source-to-notes pipeline.
#
# The wider repo has an 11-type taxonomy (source-types.sh). The reading-notes
# pipeline only needs three buckets, each with a distinct note discipline:
#
#   book      -> chapter-by-chapter complete notes
#   paper     -> detailed reading / excerpt notes
#   document  -> content-adaptive notes (manuals, reports, slides, mixed, ...)
#
# Classification is a HYBRID of a deterministic heuristic scorer and an AI
# confirmation fallback. The scorer never blocks: it always returns a best
# guess plus a confidence band. When confidence is "low" the orchestrator asks
# the active agent to confirm the type from a text sample before notes start.
# Nothing here calls an LLM.

if [[ -n "${MINERU_READING_TYPES_SH_LOADED:-}" ]]; then
    return 0
fi
MINERU_READING_TYPES_SH_LOADED=1

READING_TYPES="auto book paper document"

validate_reading_type() {
    case "$1" in
        auto|book|paper|document) return 0 ;;
        *) error "Unsupported reading type: $1 (use auto, book, paper, or document)" ;;
    esac
}

# Map the repo's 11-type taxonomy onto the 3 reading buckets so callers can
# reuse classify_source_type / --type values without a second vocabulary.
reading_bucket_for_source_type() {
    case "$1" in
        book) printf 'book' ;;
        paper) printf 'paper' ;;
        course|manual|article-collection|project-notes|video|audio|web|mixed) printf 'document' ;;
        *) printf 'document' ;;
    esac
}

# classify_reading_type <requested_type> <title_lc> <sample_text> [page_count]
#
# Emits one tab-separated line:
#   <type>\t<confidence>\t<method>\t<signal,signal,...>
#
#   type        book | paper | document
#   confidence  high | medium | low   (low => caller must run AI confirmation)
#   method      forced | heuristic
#   signals     comma-joined evidence tokens, or "-" when none fired
classify_reading_type() {
    local requested_type="$1"
    local title_lc="$2"
    local sample_text="$3"
    local page_count="${4:-0}"

    if [[ "$requested_type" != "auto" ]]; then
        validate_reading_type "$requested_type"
        printf '%s\t%s\t%s\t%s\n' "$requested_type" "high" "forced" "user-specified"
        return 0
    fi

    local hay
    hay="$(printf '%s\n%s\n' "$title_lc" "$sample_text" | tr '[:upper:]' '[:lower:]')"

    local paper_score=0 book_score=0 doc_score=0
    local signals=""
    _hit() { signals="${signals:+$signals,}$1"; }

    # ---- paper evidence -------------------------------------------------
    if printf '%s' "$hay" | grep -Eq '(^|[^a-z])abstract([^a-z]|$)'; then paper_score=$((paper_score+3)); _hit "abstract"; fi
    if printf '%s' "$hay" | grep -Eq '\bdoi\b|doi\.org|arxiv|arxiv\.org'; then paper_score=$((paper_score+3)); _hit "doi/arxiv"; fi
    if printf '%s' "$hay" | grep -Eq 'references|bibliography|参考文献'; then paper_score=$((paper_score+2)); _hit "references"; fi
    if printf '%s' "$hay" | grep -Eq 'related work|prior work|相关工作'; then paper_score=$((paper_score+2)); _hit "related-work"; fi
    if printf '%s' "$hay" | grep -Eq 'we propose|we present|our method|our approach|in this paper|本文提出'; then paper_score=$((paper_score+2)); _hit "paper-voice"; fi
    if printf '%s' "$hay" | grep -Eq 'et al\.|neurips|icml|\bacl\b|\bcvpr\b|\bieee\b|\bacm\b|proceedings of'; then paper_score=$((paper_score+2)); _hit "venue"; fi
    if printf '%s' "$hay" | grep -Eq 'methodology|experimental setup|ablation|evaluation metric'; then paper_score=$((paper_score+1)); _hit "methods"; fi

    # ---- book evidence --------------------------------------------------
    local chapter_hits
    # grep -o | wc -l is portable; BSD grep -c counts matching *lines*, not
    # matches, so two chapter headings on one line would undercount.
    chapter_hits="$(printf '%s' "$hay" | grep -Eo '第[0-9一二三四五六七八九十百零]+[章篇]|chapter[[:space:]]+[0-9ivxlc]+' 2>/dev/null | wc -l | tr -d ' ' || true)"
    chapter_hits="${chapter_hits:-0}"
    if [[ "$chapter_hits" -ge 5 ]]; then book_score=$((book_score+4)); _hit "chapters:$chapter_hits";
    elif [[ "$chapter_hits" -ge 2 ]]; then book_score=$((book_score+2)); _hit "chapters:$chapter_hits"; fi
    if printf '%s' "$hay" | grep -Eq 'table of contents|目录|contents$'; then book_score=$((book_score+2)); _hit "toc"; fi
    if printf '%s' "$hay" | grep -Eq '\bisbn\b|isbn[ -]?[0-9]'; then book_score=$((book_score+3)); _hit "isbn"; fi
    if printf '%s' "$hay" | grep -Eq 'preface|foreword|前言|序言|acknowledg(e)?ments'; then book_score=$((book_score+1)); _hit "front-matter"; fi
    if printf '%s' "$hay" | grep -Eq 'part[[:space:]]+(one|two|three|i{1,3}|iv|v)|第[一二三四五]部分'; then book_score=$((book_score+1)); _hit "parts"; fi
    if [[ "$page_count" -ge 120 ]]; then book_score=$((book_score+2)); _hit "long:${page_count}p";
    elif [[ "$page_count" -ge 60 ]]; then book_score=$((book_score+1)); _hit "mid:${page_count}p"; fi

    # ---- document evidence ---------------------------------------------
    if printf '%s' "$hay" | grep -Eq 'api reference|installation|configuration|quick start|getting started|troubleshooting|changelog|release notes'; then doc_score=$((doc_score+3)); _hit "manual-markers"; fi
    if printf '%s' "$hay" | grep -Eq 'user guide|user manual|specification|datasheet|runbook|playbook|sop|standard operating'; then doc_score=$((doc_score+3)); _hit "guide-markers"; fi
    if printf '%s' "$hay" | grep -Eq 'quarterly report|annual report|executive summary|whitepaper|memo|meeting notes|agenda'; then doc_score=$((doc_score+2)); _hit "report-markers"; fi
    if printf '%s' "$hay" | grep -Eq 'slide|deck|presentation|agenda:'; then doc_score=$((doc_score+1)); _hit "slides"; fi
    # A short single document with no paper/book markers is almost always a doc.
    if [[ "$page_count" -gt 0 && "$page_count" -le 25 && "$paper_score" -lt 3 && "$book_score" -lt 3 ]]; then
        doc_score=$((doc_score+2)); _hit "short:${page_count}p"
    fi

    [[ -z "$signals" ]] && signals="-"

    # ---- decide ---------------------------------------------------------
    # Winner = max score. `-ge` with document evaluated last makes document
    # win any tie it is part of (safe default: it is the most general note
    # discipline). Runner-up is the highest score among the non-winners,
    # computed independently so the margin/confidence is honest.
    local best="document" best_score=-1 s name val
    for s in "paper:$paper_score" "book:$book_score" "document:$doc_score"; do
        name="${s%%:*}"; val="${s##*:}"
        if [[ "$val" -ge "$best_score" ]]; then best="$name"; best_score="$val"; fi
    done
    local runner=0
    for s in "paper:$paper_score" "book:$book_score" "document:$doc_score"; do
        name="${s%%:*}"; val="${s##*:}"
        [[ "$name" == "$best" ]] && continue
        [[ "$val" -gt "$runner" ]] && runner="$val"
    done
    # document is the safe default when nothing scored.
    if [[ "$best_score" -le 0 ]]; then best="document"; best_score=0; fi

    local margin=$((best_score - runner))
    local confidence="low"
    if [[ "$best_score" -ge 5 && "$margin" -ge 3 ]]; then
        confidence="high"
    elif [[ "$best_score" -ge 3 && "$margin" -ge 2 ]]; then
        confidence="medium"
    fi

    printf '%s\t%s\t%s\t%s\n' "$best" "$confidence" "heuristic" "$signals"
}

# Vault sub-folder for each reading bucket (Obsidian Knowledge-Hub layout).
reading_vault_folder() {
    case "$1" in
        book) printf 'Books' ;;
        paper) printf 'Papers' ;;
        document) printf 'Documents' ;;
        *) printf 'Documents' ;;
    esac
}

# Note template filename for each reading bucket.
reading_note_template() {
    case "$1" in
        book) printf 'book-notes.md' ;;
        paper) printf 'paper-notes.md' ;;
        document) printf 'document-notes.md' ;;
        *) error "Unsupported reading note template type: $1" ;;
    esac
}

# Boundary keywords for chapter/section splitting per reading bucket. Reuses
# source-types.sh vocabulary so the awk segmenter stays shared.
reading_boundary_keywords() {
    case "$1" in
        book) boundary_keywords book ;;
        paper) boundary_keywords paper ;;
        document) boundary_keywords manual ;;
        *) boundary_keywords book ;;
    esac
}

reading_unit_label() {
    case "$1" in
        book) printf 'Chapter' ;;
        paper) printf 'Section' ;;
        document) printf 'Section' ;;
        *) printf 'Section' ;;
    esac
}
