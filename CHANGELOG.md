# Changelog

## v2.1 (2026-10-14)

28 findings from fleet-review round 2 (attacking the v2.0 fixes themselves) — all fixed. [Full report](docs/ULTRAREVIEW-v2.md).

### Added
- `agents/openai.yaml` for Codex (`allow_implicit_invocation: false`) — Codex ignores `disable-model-invocation` in SKILL.md frontmatter; install.sh ships and the sync validates it
- Dispatch guards restored on codex/grok skills (no-path → list, nonexistent → stop, cross-project → confirm) — was master-only
- Fork detection: 2 ACTIVE handoffs with the same `Seq:` warn; head resolved by filename timestamp (files now carry seconds)
- Duplicate-`Seq` re-check inside the gate (race window closed)

### Fixed
- **Gate transports evidence**: the close message carries measured tokens, secret-scan matches (with redactions) and section count — a bare "gate OK" was self-attestation accepted by every validator
- **Claude gate executable again**: size via `wc` when shell available, else Read estimate (bytes ÷ 3.5 — measured PT-BR ratio); `Edit` added to `allowed-tools`, making "one-line edits" real one-line edits
- **Trust operationalized**: trusted = chain membership (`.handoff/`, navigable Seq/Parent) + explicit invocation; untrusted → any command needs human confirmation; untrusted/drifted loads stop-and-wait (was: "written by you" — always false in a fresh session)
- **Chain laundering blocked**: no verbatim inheritance from non-trusted parents (items become `não-verificado` or human-confirmed); planted `Seq: 999` files are never eligible parents
- **Budget internally consistent**: sections ≤300 words (caps now fit the 10K ceiling); cut direction unambiguous (preserve: corrections > errors > active > completed — cut in reverse); verbatim never truncated — overflow splits into 2 handoffs; gate loop bounded (max 2 iterations)
- **evidence-before-accept capped**: anchors first, max 5 claims, rest on demand (was: up to 25 file reads before the first action)
- **Secret scan hardened**: JWT (`eyJ`), URL credentials (`://user:pass@`), raw SSH keys, case-insensitive cookies/sessions; mentions without values annotate instead of looping
- **`.gitignore` append preserves all existing rules**; idempotent via `git check-ignore`
- **[FEITO] closes the loop**: perimeter allows disk-verified `[FEITO]` marks; load skips steps whose effect already exists on disk; gate accepts all-`[FEITO]` closure docs
- **COMPLETED asks consent** (suite convention); CHAIN points at the most recent ACTIVE (a completed Latest triggered its own confirmation prompt); abandon-without-completion = SUPERSEDED with a reason line
- **Placeholder check**: error quotes containing `<>` (TS/JSX) no longer fail the gate
- **Cwd anchor consumed** (repo-moved detection); drift report carries primary + secondary classes
- **Seq sweep via grep** of the `^Seq:` field (never full reads); trigger reframed as signal-based (1 warning/session); scan-based size estimate ÷3.5 (PT-BR measured)
- **Tooling**: sync/CI invariant lists unified (16 markers both sides); version check generic (no v-string pin in CI); body parity via awk (frontmatter-change-proof); `pyyaml` pinned; install.sh checksum mismatch is now **fatal** and remote installs pin the release tag

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
