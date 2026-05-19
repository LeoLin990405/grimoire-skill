# Recipe: Bilibili Chinese subtitle → study note

Validated end-to-end path (Knowledge-Hub playbook, 2026-05-19, opencli
1.7.22). This is the **Bilibili** route — `forge.sh`'s default video path
uses `yt-dlp` (good for YouTube); for B站 Chinese subs the Kedou web page
driven via OpenCLI is the validated route.

## When to use

- A Bilibili **video** URL (`bilibili.com/video/BV…`) or a space page
  (`space.bilibili.com/<id>`), content you're authorized to study.
- You want the Chinese `.srt` + a structured note — not a full video.

Not for: bypassing paywalls/access control; pasting cookies/tokens
anywhere; platforms with no subtitles (offer local Whisper instead).

## Steps

```bash
# 1. (space page) list candidate videos, pick one
scripts/kedou-bili-subs.sh "https://space.bilibili.com/<id>" --list

# 2. download the Chinese .srt (drives Kedou via OpenCLI, prints the path)
SRT="$(scripts/kedou-bili-subs.sh "https://www.bilibili.com/video/BV…")"

# 3. turn it into notes + skills via the normal pipeline
scripts/forge.sh "$SRT" --from-text --only both --title "<视频标题>"

# 4. write the note from templates/subtitle-note-template.md
#    (the agent fills it; scripts never write the vault)
```

`scripts/kedou-bili-subs.sh --dry-run <url>` prints the full OpenCLI
sequence without touching anything.

## Gotchas baked into the helper

- Kedou's caption page needs the **video play URL**, not a space page —
  the helper extracts/lists videos from a space page and stops.
- OpenCLI DOM element ids **shift on SPA re-render** — the helper
  re-`state`s and locates by text each time; pass `--input-el/--extract-el/
  --zh-el` to override if heuristics miss.
- `opencli wait download` is broken (`Unknown action: wait-download`) —
  the helper polls the filesystem for a size-stable new `.srt` instead.
- Chrome dedupes same-name downloads to `name (1).srt` — the helper picks
  the newest match, so the suffix doesn't matter.
- Only the requested language (default 中文) is downloaded; never batched.

## Note shape

Use `templates/subtitle-note-template.md`: source URL + local srt path,
one-line summary, key points, timeline/chapters, tool map, workflow
principles, local-landed status, reusable commands, action items. Never
the full transcript; never cookies/auth/tokens/private paid links.
