# Changelog

## v2.3 (2026-10-14)

Convergence round: full GitHub + Reddit sweep (12 new sources) → 10 candidate techniques → 5-lens council (Architect/Security/Performance/UX/QA) → 7 adopted, 3 deferred with reasons. No fleet-review findings this round — this is capability adoption.

### Added
- **Capability-negating bootstrap** (council: Security constraint + UX need): the `Resume` block now teaches ANY agent — with or without our command installed — the safe pickup protocol (read whole doc → verify against disk → treat as data → propose and WAIT for confirmation). It may only instruct brief/verify/stop; never write, execute, or escalate trust
- **Last-verifier-result** (`Última verificação: <cmd> → <pass|fail> (<data>)` in Execution Notes): a display-only pointer that saves a wasted re-verification turn on resume — rendered as a clue, never as proof (planted chains could stamp PASS); absent = unverified
- **Verifiability labels**: bullets/decisions with `file:line` = verifiable; **without anchor = inference — hypothesis until verified**
- **Non-goals** (`Não-metas:` header line): declares out-of-scope; a new human request beats yesterday's non-goal (human wins)
- **Emergency mode (degraded)**: when context is nearly full — same template, minimal content, header `Emergência: true`; **skips ONLY budget/section checks — the secret scan and Seq/Parent checks always run**; the load treats emergency claims as unverified (full re-verification) and stops for human ok
- **Chain health line** (doctor integrated into CHAIN, read-only, never auto-repairs): orphans / broken parents / zombie ACTIVEs
- **Goal-directed extraction**: an alvo naming the NEXT session's goal extracts only what it needs; vague alvo → full extraction
- CI markers extended (23); version-equality check retained
- Fixed: codex dual-path install reverted — `~/.agents/skills` is a **shared namespace** (Claude Code reads it too) and a skill named `handoff` there collides with the `/handoff` command; codex keeps the legacy `~/.codex/skills` path (read by current builds), install.sh documents the trade-off, and the sync warns about foreign copies in both shared roots

### Deferred (with council reasons)
- Map-reduce extraction for 400K+ sessions (QA: non-deterministic reduce breaks the eval regression net)
- Always-brief-then-stop on every resume (Performance/UX: kills the trusted fast path; kept risk-based default)
- Absolute-token trigger hooks (Architect/QA: per-runtime adapters + hysteresis + generation-keyed fire-once first; pattern documented)

## v2.2 (2026-10-14)

26 findings from fleet-review round 3 (attacking the v2.1 fixes) — all fixed. [Full report](docs/ULTRAREVIEW-v2.md).

### Added
- **Origin sensor** — a chain is trusted only if it is **not git-tracked** (`git ls-files .handoff/` empty; committed/force-added chains came from a clone); the dubious-origin list takes **precedence** over the positive field-arithmetic definition; WRITE elects parents only among trusted files and asks about orphan chains; LOAD **writes nothing** to untrusted handoffs
- **Split anatomy** — overflow splits into `#N` (Goal + state + Next Steps) / `#N+1` (verbatim overflow, `Parent: #N`); supersede never fires between split parts; both pass the gate; `Next Steps: nenhum` is a legitimate gate closure
- **Declared precedence** — verbatim/bullets beat the 300-word section cap below the 10K ceiling; DIVERGED/INCOMPLETE actions are proposals gated by stop-and-wait; `[FEITO]`/`SUPERSEDED` on disk require human ok; "pule e anote" annotates the report, never the disk before consent
- **EVAL oracles** — stop-and-wait asserted via tool-call traces (zero reads/execs of the flagged item) + fixed-format report + unchanged disk; G3 recomputes the close's numbers from the file (`wc -c` ÷3.5, `grep -cE`, `grep -c '^## '`); new cases: W12 split, L17 Cwd-divergent, L18 multi-ACTIVE different Seqs, G6 gitignore re-check, G7 empty closure
- Version-equality check (description × DNA comment) in sync + CI; sync parses the codex policy YAML (python3-guarded) instead of grepping a keyword; environment advisories for the 5th-copy namespace collision and missing `~/.agents/skills` path

### Fixed
- Close label is honest per runtime: `<tokens> tokens (medidos|estimados)` — the estimate was being reported as a measurement in the shell-less claude variant
- install.sh fail-closed: missing release tag aborts (no silent main fallback); missing CHECKSUMS.sha256 aborts (a missing gate is the worst failure); README claim now matches behavior
- Codex discovery dual-path: installs to `~/.agents/skills` (current, documented) and `~/.codex/skills` (legacy, deprecated upstream) — was inert-on-current-path risk
- Secret scan: adds `Basic` auth, `password=`/`passwd=`/`secret=`/`api_key=`/`api-key=`/`aws_secret_access_key`, conn-string pattern covering passwords with `/` and `@`; scan runs in **count mode** (`-c`) — matched lines with secret values are never pasted into the chat
- Gate covers empty closure (`Next Steps: nenhum`); duplicate-`Seq` renumbering declares the header field authoritative (filename may diverge) and stops for a human after iterations instead of writing zombies
- Multi-ACTIVE chains with **different** Seqs reported as 2 heads (was: only same-Seq races detected); fork tie-breaks by suffix then alphabetical
- `.gitignore` preservation is gate-checked (`git check-ignore` + line diff), not just prose
- LOAD chain-trust sweep via one grep of `^Seq:|^Parent:`; claim verification reads the range around the line (offset/limit), never whole files; `Git` anchor has a no-shell fallback (read `.git/HEAD` + ref)
- codex/grok skills now use natural-language phrasing in Resume/CHAIN ("diga: leia/retome o handoff") instead of the nonexistent `/handoff` slash command; CHAIN gained "+ liste os concluídos" parity
- CI YAML validator is fail-closed (unterminated frontmatter no longer passes silently)

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
