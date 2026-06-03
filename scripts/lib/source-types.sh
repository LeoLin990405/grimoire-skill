#!/usr/bin/env bash
# Source type rules shared by source-to-skill and Vivo workspace scripts.

if [[ -n "${MINERU_SOURCE_TYPES_SH_LOADED:-}" ]]; then
    return 0
fi
MINERU_SOURCE_TYPES_SH_LOADED=1

SOURCE_TYPES="auto book course paper manual article-collection project-notes video audio web mixed github-repo obsidian-vault-segment podcast"

validate_source_type() {
    case "$1" in
        auto|book|course|paper|manual|article-collection|project-notes|video|audio|web|mixed|github-repo|obsidian-vault-segment|podcast) return 0 ;;
        *) error "Unsupported source type: $1" ;;
    esac
}

classify_source_type() {
    local requested_type="$1"
    local title_lc="$2"
    local file_sample="$3"

    if [[ "$requested_type" != "auto" ]]; then
        printf '%s' "$requested_type"
        return
    fi

    if printf '%s\n%s\n' "$title_lc" "$file_sample" | grep -Eiq 'abstract|methodology|experiments?|limitations?|references|arxiv|doi'; then
        printf '%s' "paper"
    elif printf '%s\n%s\n' "$title_lc" "$file_sample" | grep -Eiq 'lesson|module|nanodegree|udacity|course|quiz|exercise|project rubric'; then
        printf '%s' "course"
    elif printf '%s\n%s\n' "$title_lc" "$file_sample" | grep -Eiq 'api reference|installation|configuration|quick start|troubleshooting|manual|specification'; then
        printf '%s' "manual"
    elif printf '%s\n%s\n' "$title_lc" "$file_sample" | grep -Eiq 'video|youtube|vimeo|subtitle|caption'; then
        printf '%s' "video"
    elif printf '%s\n%s\n' "$title_lc" "$file_sample" | grep -Eiq 'audio|podcast|interview|speaker:'; then
        printf '%s' "audio"
    elif printf '%s\n%s\n' "$title_lc" "$file_sample" | grep -Eiq 'article|newsletter|post|essay collection'; then
        printf '%s' "article-collection"
    elif printf '%s\n%s\n' "$title_lc" "$file_sample" | grep -Eiq 'podcast|episode|host:|interviewer:'; then
        printf '%s' "podcast"
    elif printf '%s\n%s\n' "$title_lc" "$file_sample" | grep -Eiq 'readme|github\.com|gitlab\.com|source code|repository'; then
        printf '%s' "github-repo"
    elif printf '%s\n' "$title_lc" | grep -Eiq '/obsidian-vaults?/'; then
        printf '%s' "obsidian-vault-segment"
    else
        printf '%s' "book"
    fi
}

source_unit_label() {
    case "$1" in
        book) printf '%s' "Chapter" ;;
        course) printf '%s' "Lesson" ;;
        paper) printf '%s' "Section" ;;
        manual) printf '%s' "Section" ;;
        article-collection) printf '%s' "Article" ;;
        project-notes) printf '%s' "Note" ;;
        video) printf '%s' "Segment" ;;
        audio) printf '%s' "Segment" ;;
        web) printf '%s' "Section" ;;
        mixed) printf '%s' "Source" ;;
        github-repo) printf '%s' "Module" ;;
        obsidian-vault-segment) printf '%s' "Note" ;;
        podcast) printf '%s' "Episode" ;;
        *) printf '%s' "Section" ;;
    esac
}

boundary_keywords() {
    case "$1" in
        paper)
            printf '%s' "abstract|introduction|background|related work|method|methods|methodology|experiment|experiments|evaluation|results|discussion|limitations?|conclusion|references|appendix"
            ;;
        manual)
            printf '%s' "overview|quick start|getting started|installation|setup|configuration|usage|api reference|reference|examples?|troubleshooting|faq|appendix"
            ;;
        course)
            printf '%s' "lesson|module|unit|week|project|exercise|quiz|rubric|summary|review"
            ;;
        article-collection)
            printf '%s' "article|essay|post|newsletter|part"
            ;;
        video)
            printf '%s' "chapter|segment|timestamp|transcript|topic|section|part"
            ;;
        audio)
            printf '%s' "timestamp|transcript|speaker|topic|section|chapter|segment"
            ;;
        web)
            printf '%s' "overview|introduction|background|guide|steps?|workflow|examples?|faq|summary|section"
            ;;
        mixed)
            printf '%s' "chapter|chap\\.?|part|section|lesson|module|unit|week|abstract|introduction|overview|methodology|installation|transcript|article|topic|summary"
            ;;
        *)
            printf '%s' "chapter|chap\\.?|part|section|lesson|module|unit|week"
            ;;
    esac
}

note_template_for_type() {
    case "$1" in
        book) printf '%s' "book-chapter-note.md" ;;
        paper) printf '%s' "paper-reading-note.md" ;;
        course) printf '%s' "course-lesson-note.md" ;;
        video) printf '%s' "video-transcript-note.md" ;;
        audio) printf '%s' "audio-transcript-note.md" ;;
        web) printf '%s' "web-article-note.md" ;;
        manual) printf '%s' "manual-spec-note.md" ;;
        project-notes) printf '%s' "project-notes-note.md" ;;
        mixed|auto) printf '%s' "mixed-source-note.md" ;;
        *) error "Unsupported note template type: $1" ;;
    esac
}
