#!/usr/bin/env bash
# kedou-progress.sh — resumable batch progress on a JSONL log. Pure bash + jq
# (no node). One line per attempt; latest record per bvid wins.
#
# Statuses: done | no_chinese_subtitle | rate_limited | quota_limited |
#           subtitle_failed
#
# Sourced by kedou-bili-batch.sh / skill-manage.sh.

if [[ -n "${KEDOU_PROGRESS_SH_LOADED:-}" ]]; then return 0; fi
KEDOU_PROGRESS_SH_LOADED=1

# kp_record <progress_file> <index> <bvid> <status> [message]
kp_record() {
    local pf="$1" idx="$2" bvid="$3" st="$4" msg="${5:-}"
    mkdir -p "$(dirname "$pf")"
    jq -cn --argjson index "$idx" --arg bvid "$bvid" --arg status "$st" \
        --arg message "$msg" --arg ts "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
        '{index:$index,bvid:$bvid,status:$status,message:$message,ts:$ts}' >> "$pf"
}

# kp_latest_counts <progress_file> — JSON {latest_records,max_index_seen,counts}
kp_latest_counts() {
    local pf="$1"
    [[ -s "$pf" ]] || { echo '{"latest_records":0,"max_index_seen":0,"counts":{}}'; return 0; }
    jq -s '
        (reduce .[] as $r ({}; .[$r.bvid] = $r) | [.[]]) as $latest
        | {
            latest_records: ($latest | length),
            max_index_seen: ([$latest[].index] | max // 0),
            counts: ($latest | group_by(.status)
                     | map({key:(.[0].status), value:length}) | from_entries)
          }' "$pf"
}

# kp_latest_status <progress_file> <bvid> — latest status for one bvid (or "")
kp_latest_status() {
    local pf="$1" bvid="$2"
    [[ -s "$pf" ]] || { echo ""; return 0; }
    jq -rs --arg b "$bvid" '
        map(select(.bvid==$b)) | (last // {}) | (.status // "")' "$pf"
}

# kp_next_resume <progress_file> <manifest_jsonl> — first manifest index whose
# latest status is not "done" (manifest order). Empty progress → first index.
kp_next_resume() {
    local pf="$1" mf="$2"
    [[ -s "$mf" ]] || { echo 1; return 0; }
    if [[ ! -s "$pf" ]]; then
        jq -s 'map(.index) | min // 1' "$mf"; return 0
    fi
    local done_bvids
    done_bvids="$(jq -rs '
        (reduce .[] as $r ({}; .[$r.bvid]=$r) | [.[]])
        | map(select(.status=="done") | .bvid) | .[]' "$pf" 2>/dev/null | sort -u)"
    jq -rs --arg done "$done_bvids" '
        ($done | split("\n") | map(select(length>0))) as $d
        | (sort_by(.index)) as $m
        | ([ $m[] | select((.bvid as $b | $d | index($b)) | not) ][0].index)
          // (($m | last).index + 1)' "$mf"
}
