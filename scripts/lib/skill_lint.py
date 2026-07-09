#!/usr/bin/env python3
"""skills-lint — audit and index a large local Agent-Skills library.

Unlike the many "install / marketplace" tools, this is for people who *own* a big
personal skill library (hundreds of `SKILL.md` files) and need to keep it healthy:
detect duplicate content, boilerplate/low-signal descriptions, name collisions,
dead `[[wiki]]` references, stub files, and orphan nested collections — then
regenerate a browsable `INDEX.md`.

Tuned defaults target `~/.claude/skills/` but everything is `--root`-configurable,
so it works for any agent's skills dir (Claude Code, Codex, Cursor, …).

Usage:
    python skills-lint.py                 # audit report on the default root
    python skills-lint.py --root DIR      # audit a different skills dir
    python skills-lint.py --index         # (re)write <root>/INDEX.md
    python skills-lint.py --json          # machine-readable findings
    python skills-lint.py --only dup,desc # run a subset of checks
    python skills-lint.py --quiet         # only summary + exit code

Exit code: 0 = clean, 1 = findings at/above --fail-level (default: error).
Checks: frontmatter, desc, dup-content, dup-desc, collision, deadlink, stub, orphan.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import sys
from collections import Counter, defaultdict
from pathlib import Path

DEFAULT_ROOT = os.path.expanduser("~/.claude/skills")

# --- lightweight YAML frontmatter parse (avoid hard dep; fall back to PyYAML) ---
try:
    import yaml  # type: ignore

    def _parse_yaml(text: str):
        return yaml.safe_load(text) or {}
except Exception:  # pragma: no cover
    def _parse_yaml(text: str):
        out = {}
        for line in text.splitlines():
            m = re.match(r"^([A-Za-z0-9_-]+):\s*(.*)$", line)
            if m:
                out[m.group(1)] = m.group(2).strip().strip("\"'")
        return out


SEV = {"error": 3, "warn": 2, "info": 1}
WIKILINK = re.compile(r"\[\[([^|\]#]+)")
BOILERPLATE_HINTS = [
    "applying concepts from this book",
    "to practical problems and system design",
]
TRIGGER_HINTS = ["use when", "use for", "trigger", "triggers", "触发", "用于", "用来", "when the user"]
NEAR_DUP_RATIO = 0.90  # Jaccard threshold for "near-duplicate" (calibrated: template
# scaffolding pushes generated skills to ~0.85-0.89 similarity; real near-dupes are ≥0.90)


def _tokset(text: str, limit: int = 600) -> frozenset:
    """Token set for cheap fuzzy similarity (ASCII words + CJK runs)."""
    return frozenset(re.findall(r"[a-z0-9一-鿿]{3,}", text.lower())[:limit])


def _jaccard(a: frozenset, b: frozenset) -> float:
    if not a or not b:
        return 0.0
    union = len(a | b)
    return len(a & b) / union if union else 0.0


class Skill:
    def __init__(self, path: Path, root: Path):
        self.path = path
        self.dir = path.parent
        self.name_dir = path.parent.name
        self.rel = str(path.parent.relative_to(root))
        # utf-8-sig strips a leading BOM so `---` frontmatter is still detected
        self.raw = path.read_text(encoding="utf-8-sig", errors="replace")
        self.fm, self.body = self._split()
        self.name = str(self.fm.get("name", "")).strip()
        self.description = str(self.fm.get("description", "")).strip()

    def _split(self):
        if self.raw.startswith("---"):
            parts = self.raw.split("---", 2)
            if len(parts) >= 3:
                try:
                    fm = _parse_yaml(parts[1]) or {}
                except Exception:
                    fm = {}
                return (fm if isinstance(fm, dict) else {}), parts[2]
        return {}, self.raw

    def body_hash(self) -> str:
        norm = re.sub(r"\s+", " ", self.raw).strip()
        return hashlib.sha1(norm.encode("utf-8")).hexdigest()


def find_skills(root: Path) -> list[Skill]:
    skills = []
    for p in sorted(root.glob("*/SKILL.md")):
        try:
            skills.append(Skill(p, root))
        except Exception as e:  # noqa: BLE001
            print(f"WARN: could not read {p}: {e}", file=sys.stderr)
    return skills


def desc_quality(s: Skill) -> tuple[int, list[str]]:
    """0-100 description quality score + reasons for deductions."""
    d = s.description
    score, why = 100, []
    if not d:
        return 0, ["空 description"]
    low = d.lower()
    if len(d) < 60:
        score -= 40
        why.append("过短(<60 字符)")
    if not any(h in low for h in TRIGGER_HINTS):
        score -= 25
        why.append("无触发词(Use when/Trigger/触发/用于)")
    if any(h in low for h in BOILERPLATE_HINTS):
        score -= 35
        why.append("模板套话(applying concepts…)")
    # distinctiveness: proportion of unique tokens
    toks = re.findall(r"[A-Za-z一-鿿][A-Za-z0-9一-鿿\-]{2,}", d)
    if toks and len(set(toks)) / len(toks) < 0.55:
        score -= 10
        why.append("重复词多、特异性低")
    if len(d) > 1800:
        score -= 5
        why.append("过长(>1800 字符)")
    return max(0, score), why


def run(root: Path, only: set[str] | None):
    skills = find_skills(root)
    findings = []  # (severity, check, skill_rel, message)

    def add(sev, check, rel, msg):
        if only and check not in only:
            return
        findings.append((sev, check, rel, msg))

    names = {s.name_dir for s in skills}

    # collision: duplicate `name:` field, and duplicate meaningful suffix
    name_field = defaultdict(list)
    suffix = defaultdict(list)
    for s in skills:
        if s.name:
            name_field[s.name].append(s.name_dir)
        m = re.match(r"^(wdkns-child-\d+|.+?)-(.+)$", s.name_dir)
        if m and len(m.group(2)) > 4:
            suffix[m.group(2)].append(s.name_dir)

    for s in skills:
        # frontmatter
        if not s.fm:
            add("error", "frontmatter", s.rel, "无 YAML frontmatter")
        else:
            if not s.name:
                add("error", "frontmatter", s.rel, "缺 name")
            elif s.name != s.name_dir:
                add("warn", "frontmatter", s.rel, f"name '{s.name}' 与目录名 '{s.name_dir}' 不符")
            if not s.description:
                add("error", "frontmatter", s.rel, "缺 description")
            try:
                if s.raw.startswith("---"):
                    _parse_yaml(s.raw.split("---", 2)[1])
            except Exception as e:  # noqa: BLE001
                add("error", "frontmatter", s.rel, f"YAML 解析失败: {str(e)[:60]}")

        # description quality
        if s.description:
            sc, why = desc_quality(s)
            if sc < 60:
                add("warn", "desc", s.rel, f"description 质量 {sc}/100 — {'; '.join(why)}")

        # stub
        if len(s.raw) < 400:
            add("warn", "stub", s.rel, f"SKILL.md 过小({len(s.raw)}B),疑似占位")

        # dead [[wiki]] links to nonexistent skills (only skill-shaped targets)
        for tgt in {t.strip() for t in WIKILINK.findall(s.body)}:
            base = tgt.split("/")[-1]
            looks_like_skill = bool(re.match(r"^[a-z0-9]+(-[a-z0-9]+)+$", base))
            if looks_like_skill and base not in names and base != s.name_dir:
                add("warn", "deadlink", s.rel, f"[[{tgt}]] 指向不存在的 skill")

    # duplicate content (identical/near-identical whole SKILL.md)
    by_hash = defaultdict(list)
    for s in skills:
        by_hash[s.body_hash()].append(s.name_dir)
    exact_dup = set()
    for h, group in by_hash.items():
        if len(group) > 1:
            exact_dup.update(group)
            for g in group:
                add("error", "dup-content", g, f"内容与 {', '.join(x for x in group if x != g)} 完全相同")

    # near-duplicate content (fuzzy) — catches near-identical skills exact-hash misses.
    # Threshold calibrated on a 358-skill library: 0.85 flags ~127 template-similar pairs
    # (noise); 0.90 isolates genuine near-dupes. See NEAR_DUP_RATIO.
    if not only or "near-dup" in only:
        cand = [(s, _tokset(s.raw)) for s in skills if s.name_dir not in exact_dup]
        cand.sort(key=lambda x: len(x[1]))
        reported = set()
        for i, (s, ts) in enumerate(cand):
            for s2, ts2 in cand[i + 1:]:
                if len(ts2) > len(ts) * 1.6:  # sorted by size → prune far-apart pairs
                    break
                pair = frozenset((s.name_dir, s2.name_dir))
                if pair in reported:
                    continue
                if _jaccard(ts, ts2) >= NEAR_DUP_RATIO:
                    reported.add(pair)
                    add("warn", "near-dup", s.name_dir, f"内容与 {s2.name_dir} 高度相似(≥{int(NEAR_DUP_RATIO*100)}%)")
                    add("warn", "near-dup", s2.name_dir, f"内容与 {s.name_dir} 高度相似(≥{int(NEAR_DUP_RATIO*100)}%)")

    # duplicate descriptions (boilerplate cluster)
    by_desc = defaultdict(list)
    for s in skills:
        if s.description:
            key = re.sub(r"\s+", " ", s.description.lower())[:200]
            by_desc[key].append(s.name_dir)
    for key, group in by_desc.items():
        if len(group) >= 3:
            for g in group:
                add("warn", "dup-desc", g, f"description 与另外 {len(group)-1} 个雷同(检索噪声)")

    # name-field / suffix collisions
    for name, dirs in name_field.items():
        if len(dirs) > 1:
            for d in dirs:
                add("error", "collision", d, f"name:'{name}' 与 {', '.join(x for x in dirs if x != d)} 重复")
    for suf, dirs in suffix.items():
        if len(dirs) > 1:
            for d in dirs:
                add("info", "collision", d, f"后缀 '-{suf}' 与 {', '.join(x for x in dirs if x != d)} 撞车(易误触发)")

    # orphan nested collection: a dir with child SKILL.md but no top-level SKILL.md
    if not only or "orphan" in only:
        for d in sorted(root.iterdir()):
            if d.name.startswith((".", "_")):
                continue  # skip hidden/system dirs (.archived, .system, _shared)
            if d.is_dir() and not (d / "SKILL.md").exists():
                nested = list(d.glob("*/SKILL.md"))
                if nested:
                    add("warn", "orphan", d.name, f"{len(nested)} 个子 skill 但无顶层 SKILL.md(未并入生态)")

    return skills, findings


def run_against(candidate: Path, library: Path):
    """Lint a candidate skill dir against an existing library: flag name collisions
    and identical/near-duplicate content vs skills already installed. Intended as a
    promotion gate (e.g. grimoire's `gate`) before a new pack is added to a big library."""
    lib = {s.name_dir: s for s in find_skills(library)}
    lib_hash = {}
    lib_tok = {}
    for s in lib.values():
        lib_hash.setdefault(s.body_hash(), s.name_dir)
        lib_tok[s.name_dir] = _tokset(s.raw)
    cand = find_skills(candidate)
    findings = []
    for s in cand:
        if s.name_dir in lib:
            findings.append(("error", "against", s.name_dir, f"与库中已有 skill 同名: {s.name_dir}"))
        h = s.body_hash()
        if h in lib_hash:  # candidate & library are separate roots → any hash match is a dup
            findings.append(("error", "against", s.name_dir, f"内容与库中 {lib_hash[h]} 完全相同"))
        else:
            ts = _tokset(s.raw)
            for ln, lt in lib_tok.items():
                if ln != s.name_dir and _jaccard(ts, lt) >= NEAR_DUP_RATIO:
                    findings.append(("warn", "against", s.name_dir, f"内容与库中 {ln} 高度相似"))
                    break
    return cand, findings


def category_of(name: str) -> str:
    for pref, cat in (
        ("wdkns-series-", "wdkns / series"),
        ("wdkns-child-", "wdkns / child"),
        ("wdkns-up-", "wdkns / up"),
        ("book-", "books"),
        ("child-", "concept children"),
    ):
        if name.startswith(pref):
            return cat
    if name.endswith("-meta") or "-meta-" in name:
        return "meta-index"
    return "functional / tools / methodology"


def write_index(root: Path, skills: list[Skill]) -> Path:
    groups = defaultdict(list)
    for s in skills:
        groups[category_of(s.name_dir)].append(s)
    order = [
        "functional / tools / methodology", "meta-index", "books",
        "concept children", "wdkns / up", "wdkns / series", "wdkns / child",
    ]
    lines = [
        "# Skills INDEX", "",
        f"> Auto-generated by `skills-lint.py` · {len(skills)} skills · root `{root}`",
        "> Do not hand-edit; regenerate with `python skills-lint.py --index`.", "",
    ]
    for cat in order + [c for c in groups if c not in order]:
        items = groups.get(cat)
        if not items:
            continue
        lines.append(f"## {cat} ({len(items)})")
        for s in sorted(items, key=lambda x: x.name_dir):
            one = re.sub(r"\s+", " ", s.description).strip()
            if len(one) > 140:
                one = one[:137] + "…"
            lines.append(f"- **{s.name_dir}** — {one}")
        lines.append("")
    out = root / "INDEX.md"
    out.write_text("\n".join(lines), encoding="utf-8")
    return out


def main() -> int:
    ap = argparse.ArgumentParser(description="Audit & index a local Agent-Skills library.")
    ap.add_argument("--root", default=DEFAULT_ROOT)
    ap.add_argument("--index", action="store_true", help="(re)write <root>/INDEX.md")
    ap.add_argument("--json", action="store_true", help="machine-readable findings")
    ap.add_argument("--only", help="comma list: frontmatter,desc,dup-content,near-dup,dup-desc,collision,deadlink,stub,orphan")
    ap.add_argument("--against", help="lint --root as a CANDIDATE against this existing library (promotion gate)")
    ap.add_argument("--fail-level", default="error", choices=["error", "warn", "info"])
    ap.add_argument("--quiet", action="store_true")
    a = ap.parse_args()

    root = Path(os.path.expanduser(a.root))
    if not root.is_dir():
        print(f"ERROR: root not found: {root}", file=sys.stderr)
        return 2
    only = {x.strip() for x in a.only.split(",")} if a.only else None

    if a.against:
        library = Path(os.path.expanduser(a.against))
        if not library.is_dir():
            print(f"ERROR: --against library not found: {library}", file=sys.stderr)
            return 2
        skills, findings = run_against(root, library)
    else:
        skills, findings = run(root, only)

    if a.index:
        out = write_index(root, skills)
        print(f"INDEX written: {out} ({len(skills)} skills)")

    counts = Counter(f[0] for f in findings)
    if a.json:
        print(json.dumps(
            {"root": str(root), "skills": len(skills),
             "counts": dict(counts),
             "findings": [{"sev": s, "check": c, "skill": r, "msg": m} for s, c, r, m in findings]},
            ensure_ascii=False, indent=2))
    elif not a.quiet:
        by_check = defaultdict(list)
        for f in findings:
            by_check[f[1]].append(f)
        icon = {"error": "❌", "warn": "⚠️ ", "info": "ℹ️ "}
        for check in sorted(by_check):
            print(f"\n=== {check} ({len(by_check[check])}) ===")
            for sev, _c, rel, msg in sorted(by_check[check], key=lambda x: -SEV[x[0]])[:60]:
                print(f"  {icon[sev]} {rel}: {msg}")
            if len(by_check[check]) > 60:
                print(f"  … 另有 {len(by_check[check]) - 60} 条")

    summary = (f"{len(skills)} skills · {counts.get('error', 0)} error / "
               f"{counts.get('warn', 0)} warn / {counts.get('info', 0)} info")
    print(("\n" + summary) if not a.json else summary, file=sys.stderr if a.json else sys.stdout)

    threshold = SEV[a.fail_level]
    return 1 if any(SEV[f[0]] >= threshold for f in findings) else 0


if __name__ == "__main__":
    raise SystemExit(main())
