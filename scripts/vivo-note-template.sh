#!/usr/bin/env bash
# Copy Vivo source-type and note templates into an existing workspace.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_ROOT="$REPO_ROOT/templates/vivo"

WORKSPACE=""
SOURCE_TYPE=""
TITLE=""
FORCE=false

usage() {
    cat <<EOF
Vivo Note Template Installer

Usage: vivo-note-template.sh --workspace <dir> --type <type> [options]

Options:
  --workspace <dir>  Vivo workspace directory.
  --type <type>      book, paper, course, video, audio, web, manual,
                    project-notes, mixed, or auto.
  --title <title>    Optional note title hint.
  --force            Overwrite existing template files.
  -h, --help         Show this help.
EOF
    exit 0
}

error() {
    echo "Error: $*" >&2
    exit 1
}

template_for_type() {
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

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) usage ;;
        --workspace) WORKSPACE="${2:?Missing value for --workspace}"; shift 2 ;;
        --type|--source-type|--text-type) SOURCE_TYPE="${2:?Missing value for $1}"; shift 2 ;;
        --title) TITLE="${2:?Missing value for --title}"; shift 2 ;;
        --force) FORCE=true; shift ;;
        -*) error "Unknown option: $1" ;;
        *) error "Unexpected positional argument: $1" ;;
    esac
done

[[ -n "$WORKSPACE" ]] || error "--workspace is required"
[[ -n "$SOURCE_TYPE" ]] || error "--type is required"
[[ -d "$WORKSPACE" ]] || error "Workspace not found: $WORKSPACE"
[[ -d "$TEMPLATE_ROOT" ]] || error "Template directory not found: $TEMPLATE_ROOT"

mkdir -p "$WORKSPACE/notes"

confirm_dest="$WORKSPACE/notes/source-type-confirmation.md"
coverage_dest="$WORKSPACE/notes/skill-discovery-coverage.md"
note_dest="$WORKSPACE/notes/$(template_for_type "$SOURCE_TYPE")"

copy_template() {
    local src="$1" dest="$2"
    [[ -f "$src" ]] || error "Template missing: $src"
    if [[ -e "$dest" && "$FORCE" != true ]]; then
        error "File already exists: $dest (use --force)"
    fi
    cp "$src" "$dest"
}

copy_template "$TEMPLATE_ROOT/source-type-confirmation.md" "$confirm_dest"
copy_template "$TEMPLATE_ROOT/skill-discovery-coverage.md" "$coverage_dest"
copy_template "$TEMPLATE_ROOT/notes/$(template_for_type "$SOURCE_TYPE")" "$note_dest"

if [[ -n "$TITLE" ]]; then
    printf '\n<!-- Title hint: %s -->\n' "$TITLE" >> "$note_dest"
fi

echo "Vivo templates installed:"
echo "  $confirm_dest"
echo "  $note_dest"
echo "  $coverage_dest"
