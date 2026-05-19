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

## Batch: a whole space → all Chinese subtitles (resumable)

For an entire UP space, not one video:

```bash
# 1. (optional) build the video manifest. Direct space API is 风控-blocked
#    (412 / -352) — it captures the page's own /x/space/wbi/arc/search:
scripts/kedou-bili-manifest.sh "https://space.bilibili.com/<id>" --out videos.jsonl
#    (or capture the network log yourself → --from-network <dump.json>)

# 2. resumable batch (manifest OR space URL directly):
scripts/kedou-bili-batch.sh videos.jsonl --out-dir ./kedou-bili \
    --delay-ms 12000 --rate-limit-wait-ms 300000 --retries 1
scripts/kedou-bili-batch.sh ./kedou-bili/manifests/videos.jsonl \
    --out-dir ./kedou-bili --resume          # next day after a quota stop
scripts/kedou-bili-batch.sh --status --out-dir ./kedou-bili

# notes mode: also stage a grimoire contract per video (agent writes notes)
scripts/kedou-bili-batch.sh videos.jsonl --out-dir ./kedou-bili --mode notes
```

`progress.jsonl` (latest record per bvid) drives `--resume`. Statuses:
`done | no_chinese_subtitle | rate_limited | quota_limited | subtitle_failed`.
"您今日的使用次数已达上限" → records `quota_limited` and **stops** (resume
next day); "请求过于频繁" → waits `--rate-limit-wait-ms` then retries.

**Deliberate boundary:** the batch reuses the public Kedou web UI per video
(via `kedou-bili-subs.sh`); it does **not** ship Kedou-API encryption
replication. Slower but stays on the public interface, strongly rate-limited.
`--mode notes` only stages grimoire contracts — the agent writes the notes;
scripts never write the vault.

## Note shape

Use `templates/subtitle-note-template.md`: source URL + local srt path,
one-line summary, key points, timeline/chapters, tool map, workflow
principles, local-landed status, reusable commands, action items. Never
the full transcript; never cookies/auth/tokens/private paid links.
