#!/usr/bin/env bash
# Shared Markdown chapter/section segmenter.
# Splits a Markdown file into native units (chapters, sections, ...) at
# heading boundaries, with a single-unit fallback. Used by both the
# skill-pack and reading-notes pipelines so segmentation stays identical.

if [[ -n "${MINERU_SEGMENT_SH_LOADED:-}" ]]; then
    return 0
fi
MINERU_SEGMENT_SH_LOADED=1

segment_markdown_file() {
    local source_file="$1"
    local segments_dir="$2"
    local unit_label="$3"
    local source_label="${4:-$(basename "$source_file")}"
    local start_index="${5:-0}"
    # SECURITY: arg 6 is interpolated verbatim into an awk ERE inside
    # is_boundary(). It MUST be a hardcoded keyword alternation from
    # boundary_keywords()/reading_boundary_keywords() — never user input,
    # or it becomes an awk regex-injection / ReDoS vector.
    local extra_keywords="${6:-$(boundary_keywords book)}"

    awk -v outdir="$segments_dir" -v source_file="$source_file" -v source_label="$source_label" -v unit_label="$unit_label" -v start_index="$start_index" -v extra_keywords="$extra_keywords" '
    function slugify(value, result) {
        result = tolower(value)
        gsub(/[^a-z0-9]+/, "-", result)
        gsub(/^-+/, "", result)
        gsub(/-+$/, "", result)
        if (result == "") {
            result = "section"
        }
        return result
    }
    function is_boundary(line) {
        lc = tolower(line)
        return lc ~ "^#{1,3}[[:space:]]+((" extra_keywords ")([[:space:]:.-]+|$)|第.+[章节篇部]|[0-9]+([.)]|[[:space:]]+))"
    }
    function open_chapter(title) {
        if (file != "") {
            close(file)
        }
        count += 1
        global_index = start_index + count
        slug = slugify(title)
        filename = sprintf("%03d-%s.md", global_index, slug)
        file = sprintf("%s/%s", outdir, filename)
        titles[count] = title
        files[count] = "segments/" filename
        printf("# %s\n\n", title) > file
        printf("Source: `%s`\n\n", source_label) >> file
    }
    BEGIN {
        count = 0
        file = ""
    }
    {
        if (is_boundary($0)) {
            title = $0
            sub(/^#{1,3}[[:space:]]+/, "", title)
            open_chapter(title)
            next
        }
        if (file == "") {
            open_chapter(unit_label " 1 - " source_label)
        }
        print $0 >> file
    }
    END {
        if (file != "") {
            close(file)
        }
        for (i = 1; i <= count; i++) {
            printf("%s\t%s\n", files[i], titles[i])
        }
    }' "$source_file"
}
