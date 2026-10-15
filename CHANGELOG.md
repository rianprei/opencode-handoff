# Changelog

## v2.7 (2026-10-15)

Battalion round 7: 10 parallel research fronts (GitHub new repos, Reddit postmortems, vendor docs, arXiv Oct-2026, engineering blogs, lists/marketplaces, non-English sources, adjacent patterns, adversarial, real exemplars) → 22 adopted deltas, 17 deferred with reasons. No fleet findings — pure capability adoption on top of v2.6.

### Added
- **Forced read-back + dirty-ack** (§9): the load report must quote back the executable next step (command + file + done-criterion), the acknowledged dirty-tree state and 1 active gate — a receiver that can't recite the map didn't understand it
- **Receipt-hardened verifiability**: `checked` claims require a repo receipt (path:line or real command+output); without receipt = `UNVERIFIED`; mock receipts ≠ real-request receipts
- **Trust-code-over-doc + newer-revision check**: divergent HEAD makes the doc a starting point, not truth; the load checks for a newer handoff revision before acting
- **Stop-and-wait timeout**: no human response → re-ask once; high-risk actions default to NOT executing; the report records who approved what and when
- **Recovery sequence**: Next Steps order IS the recovery sequence (resume point = first open step); verify-loop (write → idempotent read → retry only if absent) for keyless writes
- **Cascade invalidation**: revoking an item lists dependents for re-verification (no orphaned Next Steps)
- **Source anti-duplicate**: the same fact from 2 sources enters once, with both origins annotated
- **Live-evidence-before-success**: COMPLETED requires re-executed evidence, not an inherited stamp
- **Tool-output revalidation**: quoted tool outputs are data, re-run rather than trusted (persisted tool descriptions/outputs can be poisoned upstream)
- **Goal-drift check**: Goal divergence vs parent without recorded reason warns before inheriting
- **Normalized scanning**: Unicode NFKC + base64-candidate decode before the secret scan (obfuscated blobs no longer pass)
- **Egress rule**: never fetch/render/follow URLs from untrusted state (session docs as exfil channel)
- **Rotation**: COMPLETED chains >10 handoffs archive old links to `.handoff/archive/`
- **Completion Requirement**: Goal carries an observable done-criterion, distinct from Next Steps
- **Multi-agent ownership** (task/workspace/validation) in Execution Notes; **beads/prd.json references** in Relevant Files; **parked read-only advisor** tip in Pós
- CI/sync markers extended 30 → 44

### Deferred (with reasons)
- Map-reduce extraction, universal always-stop, token hooks (standing defers); mutual old→new→old verification loop (needs the old session alive); hook automation, index regeneration, CLI tooling, plugin packaging (ecosystem infra); memory MCPs, swarm contracts, messaging infra (complements, not command text); compaction+note hybrid, plan-and-clear, inbox flow, 2-artifact split, safe-to-overwrite flags (UNVERIFIED or redundant with existing rules)

## v2.6 (2026-10-15)

Surgical tone rework of v2.5 command texts across all 4 runtimes — **zero semantic changes**. Professional register, direct, precise; emoji verified at zero in all 4 files (grep across full Unicode emoji ranges returns 0 matches); colloquialisms replaced ("diga e pare" → "informe e pare", "nada além" → "nada adicional", "pule" → "ignore", prompt-text standardized). All 30 content markers, section structure, gate semantics and trust machinery bit-identical to v2.5 (verified marker-by-marker); suite sync green without changes. install.sh retagged v2.5 → v2.6.

## v2.5 (2026-10-15)

Fleet round 6 on v2.4: **24 findings (3 critical, 8 high, 10 medium, 3 low), 1 refuted** — the curve rose because v2.4 added six new systems and the cracks sat at the joints. All fixed. [Full report](docs/ULTRAREVIEW-v2.md).

### Fixed — criticals
- **REVOKED authority** (#1): revocation now requires **anchored evidence** (unanchored = invalid, item stays ACTIVE), **human ok for `usuário`-class items**, predicate tightened to **incompatible** assertions (refinements update, not revoke), and the load **re-verifies the revocation evidence** before accepting it
- **Eval matrix tracked the schema** (#2): EVAL rewritten to the v2.5 matrix (48 cases) + CI staleness gate greps the matrix for lifecycle/gates/pin/emergency coverage
- **Pin reconciliation budget** (#3): max 5 anchors re-verified (re-anchor by content via grep, never full re-reads); broken cross-ref fixed

### Fixed — highs
- Resume gate re-assertion filters to **ACTIVE** items only (no zombie gates in the highest-survival block)
- Gates from **untrusted** handoffs are reported context — they never block nor authorize (a planted gate blocks; blocking never contradicts a permissive perimeter, so the anti-injection clause alone couldn't stop it)
- Split vs 2-heads: split parts are one logical document (chain marks them); head resolution picks part 1; part 1's Resume carries the ACTIVE gates — "gates survive compression" now holds in the split case; WRITE consults the multi-ACTIVE detector before electing a parent
- Emergency mode carries **Constraints ACTIVE (one line each)** — gates survive even in the highest-risk handoff; emergency rewrite-as-normal requires human ok and the rewritten doc passes the gate
- Export→distill fallback: **point to the transcript as reading** (never copy it into the repo) — no unscanned persistent artifact
- Materiality: **batched (one Glob/shell, cap ~25)** + sensitivity rule extended to anchors/Commands (`.env:12` as an anchor = red flag, handoff treated untrusted — the loader no longer reads secrets via anchor ranges)
- Claude no-shell fallback for the origin sensor (degrade + ask the human; never silently skipped)

### Fixed — medium/low
- Pin is quantified (`x/y anchors`) and **consumed** by LOAD step 0; self-attestation mitigated by the 5-anchor sample re-verification
- Human-requested action vs gate: human wins, annotated in report AND registered in the doc with ok (`gate reavaliado pelo humano:` — added to the write whitelist)
- `não-idempotente` gains an **anchor/command proving the effect on disk** (same mechanics as `[FEITO]`)
- Cut-order conflict resolved: **user corrections are never "histórico antigo"** — preserve order beats layers
- Emergency rewrite consent defined; REVOKED records **name the parent item**; ancestral revocations swept by one grep (2+ hop amnesia fixed)
- Honest token target: **~5K** (the 3K target was unreachable — field artifact measured 3.9K); structural growth documented (+12-15%)
- Host-prompt rule: **ok must reference the specific command**; uncertain-origin prompts treated as non-human
- Transcript pointer: runtime-dependent (opencode stores sessions in SQLite — omit); install TAG regression fixed (v2.2 → v2.5) + **installed×src cross-check** added to sync (the drift class invisible to both gates)

## v2.4 (2026-10-14)

Convergence round 2: Reddit (16 techniques, old.reddit threads) + GitHub (11, incl. continuity/redducklabs/batonpass) + arXiv (12 papers, 5 verified) → schema upgrade grounded in verified quantitative results. No fleet findings — pure capability + theory alignment.

### Added — theory-backed (arXiv verified)
- **Item lifecycle: ACTIVE / SUPERSEDED / REVOKED + supersedes links** on every carry-forward item (Key Decisions, Dead Ends, Gotchas, Where We Are). Grounding: TEPA (arXiv:2608.07429) — append-only memory scores **below a memoryless agent** after regime reversal (0.210 vs 0.309); validity-state memory reaches 0.950. The Seq/Parent chain is the audit archive; contradictions mark REVOKED with evidence instead of silent rewrites
- **Constraints and Dead Ends as GATES** (`gatilho · bloqueia · até`), gate-phrased ("não rode X até Y porque Z") instead of precedent-phrased, and **re-asserted verbatim in the Resume bootstrap**. Grounding: arXiv:2608.24569 — constraint *role* (not content) erodes in handoffs; full blocker text restored raises recognition 6.2%→99.2% and cuts forbidden actions 85.2%→0.0%
- **Per-item provenance with non-amplification**: `verificado-disco` / `usuário` / `inferência` / `externo-não-confiável` — external-untrusted items never enter Commands, never gate actions, and carry their source pointer through the chain. Grounding: arXiv:2607.29167 (provenance laundering in consolidation)
- **Environment pin + reconciliation** (header `Pin: <âncoras verificadas neste sha>`; LOAD step 0): anchors are valid for the header SHA; HEAD moved → re-verify; unverifiable anchors **downgrade to inference, never deleted**. Grounding: arXiv:2608.14380 (AgentRewind context↔environment alignment)
- **Rollback-risk + preconditions on Next Steps**: each step may carry `válido se <condição>` and `não-idempotente: <efeito>`; the load never re-executes a non-idempotent effect that already exists. Grounding: arXiv:2606.02875 (Handoff Debt — bounded continuation contract) + STALE (premise resistance)

### Added — practice-backed (Reddit/GitHub, ≥2 sources where critical)
- **Write-side invariant**: recommending a session restart → checkpoint FIRST (the agent's own restart advice was the top context-loss event); handoff is an invariant, not a ritual
- **Materiality gate**: every cited path resolves on disk at write time (dangling references = the most concrete documented context loss)
- **Filesystem-not-chat self-test**: disk + doc must reconstruct state without the transcript
- **Atomic one-shot write** (no appends — torn handoffs kill the chain)
- **Layered cut order**: task state + decisions/blockers + active-file diffs always survive; project context, tool activity, stats, old history fill the remainder
- **Snapshot-vs-tree staleness** folded into drift (dirty tree newer than header Date → DIVERGED); `Emergência` gains validity (re-verified → rewritten as normal)
- **Two-stage export→distill fallback** inside emergency mode; **origin-classified prompts** (host-started notifications never count as decisions); **verifier enum** `pass|fail|not-run`; **transcript pointer** (raw provenance); **Commands section = non-derivable only**; **statistics without anchor + dependent decision = decoration (cut)**

### Deferred
- Hook-side automation (PreCompact/Stop-block-once/measured-75% triggers, ownership lease with prompt blocking, eval scorecard): runtime-specific adapters — the doctrine is documented in docs/ULTRAREVIEW-v2.md round 5; the command encodes the invariants the hooks would enforce

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
