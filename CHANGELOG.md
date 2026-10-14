# Changelog

## v2.0 (2026-10-14)

Hardened by a 5-reviewer adversarial fleet review (logic, security, performance, tests, architecture, each with independent web verification): **38 confirmed findings, all fixed**. Full report: [docs/ULTRAREVIEW-v2.md](docs/ULTRAREVIEW-v2.md).

### Added
- **Post-write gate** — re-read + 6 checks (sections, actionable #1, secret scan, seq/parent, token budget); "written" is never announced without the gate passing
- **Provenance rule** — handoffs not written by this session (cloned repo/PR/manual edit) are untrusted: Commands and out-of-project paths require explicit human confirmation
- **Drift taxonomy with actions** — CLEAN / DIVERGED / INCOMPLETE / STALE, each with a verb
- **Status lifecycle** — `ACTIVE → SUPERSEDED (write) → COMPLETED (load)` as declared one-line edits
- **Header state anchors** — `Status`, `Cwd`, `Git branch@sha` for one-command drift detection
- **Execution Notes** section — running processes (and how to stop), auth via env-var name only, uncommitted WIP
- **Write-before-compact trigger** — warns at ~70% context, before auto-compact eats the data
- **Token budget** — ~3K target, 10K hard cap, ≤500 words/section, cut priority (user corrections > errors > active > completed)
- **Empty-section assertion** (`nenhum`) and **empty-session guard** (no hollow files in the chain)
- **Same-minute filename collision rule** (`-2`, `-3` suffix)
- **Chain adoption** — pre-existing handoffs outside `.handoff/` are referenced by `#1` instead of erased
- **`.gitignore` guard** on write — handoff state never committed by default
- `disable-model-invocation: true` on codex/grok skills (explicit-only; never auto-fires on casual phrases)

### Fixed
- **Seq derivation** — max of the `Seq:` header field, never filename ordering (lexicographic sort corrupted chains at seq ≥ 10)
- **LOAD reads the Parent** — chain decisions/dead-ends no longer lost at depth 2
- **Resume phrase routes through `/handoff load`** — load protections actually reach the fresh session
- **Dead Ends carry validity conditions** and are re-checked when the world changed (no eternal dogma)
- **Next Steps `[FEITO]` marking + skip rule** — no re-execution of completed (incl. destructive) steps
- **Claude variant: Bash removed** from `allowed-tools` (least privilege: WRITE needs Read+Write, LOAD needs Read)
- **codex/grok variants restored** — 13 lost semantic chunks (anti-injection clause, secret enumeration, LER PRIMEIRO markers, section rationales) — full parity with the master
- **All bodies PT-BR** — was the only EN member of the suite; codex==grok byte-identical; opencode==claude body md5
- **Version in frontmatter description** (suite convention; was hidden in a body comment)
- **Files-first reformulated** — "state loads from disk; conversation-only knowledge rides in the handoff (verbatim)"
- **Perimeter evidence rule** — code bodies never; short error/behavior quotes (≤2 lines) explicitly allowed

### Security
- Redaction now has a **mechanism**: the gate re-scans for `sk-`, `ghp_`, `github_pat_`, `glpat-`, `AKIA`, `AIza`, `xox`, `Bearer`, `token=`, `senha@`, `PRIVATE KEY`, `sessionid`
- Commands section: credentials as env-var names, never values
- Untrusted handoffs: Next Steps treated as suggestions to validate; instructions contradicting the perimeter are ignored

## v1.0 (2026-10-14)
- Initial release: WRITE / LOAD / CHAIN, 11-section template, Seq/Parent chain, files-first, no-journey, secret redaction (declaration), data-not-instruction.
