# Skill Discovery Coverage

Repeat extraction passes until no new supported skills are found.

## Coverage Status

| Field | Value |
|---|---|
| Current pass | 1 |
| Skill discovery complete | false |
| Completion confidence | low / medium / high |
| Completion reason |  |

## Pass Log

| Pass | Sources/segments checked | New skills found | Skipped material | Why skipped | Next action |
|---|---|---:|---|---|---|
| 1 |  | 0 |  |  |  |

## Exhaustiveness Checklist

- [ ] Every chapter/lesson/section/timestamp segment checked.
- [ ] Procedures and workflows extracted.
- [ ] Checklists extracted.
- [ ] Diagnostics extracted.
- [ ] Decision rules extracted.
- [ ] Prompt patterns extracted.
- [ ] Implementation patterns extracted.
- [ ] Evaluation criteria extracted.
- [ ] Reference-only material separated.
- [ ] No unsupported skills invented.
- [ ] No long copyrighted excerpts copied.

## Stop Condition

Set `Skill discovery complete` to true only when a full pass over every source
unit produces no new supported operational skills and skipped material has a
clear reason.
