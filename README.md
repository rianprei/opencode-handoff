# opencode-handoff

> **Local replica of the session-handoff pattern** — structured state transfer instead of lossy compaction. Built from the convergence of 20+ open-source handoff implementations, Reddit practitioner threads, arXiv 2608.14528 (handover theory), the ACE paper (ICLR 2026), Anthropic's own engineering guidance on context resets, and hardened by **six adversarial fleet reviews** (116 findings, all fixed), a **5-lens council convergence round** (7 techniques adopted, 3 deferred with reasons), two **ecosystem max-sweeps** (arXiv-grounded), and a **10-front research battalion** (22 adopted deltas, 17 deferred with reasons). Runs 100% locally. No cloud. No quota. No git required.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-2.8-green.svg)](CHANGELOG.md)
[![Runtimes](https://img.shields.io/badge/runtimes-opencode%20%7C%20claude%20%7C%20codex%20%7C%20grok-blueviolet.svg)](#installation)
[![Cloud Free](https://img.shields.io/badge/cloud-free-brightgreen.svg)](#the-problem-it-solves)
[![Quota Free](https://img.shields.io/badge/quota-unlimited-brightgreen.svg)](#the-problem-it-solves)

## The problem it solves

Long sessions rot. Compaction summarizes at the model's worst moment, drops the "why" of decisions, and auto-compact fires silently around ~83% of the window — usually before you remember to save anything. Anthropic's own harness-design post prescribes the fix for long tasks: **context resets + structured handoff**, not compaction (which never gives a clean slate and leaves "context anxiety" in place).

`/handoff` is that handoff: distill the session's transferable state into a small, **verified** document; the next session starts fresh and resumes from it.

```
/handoff                # write: extract state → .handoff/handoff-N-<slug>-<date>.md (evidence-backed gate)
/handoff load <path>    # resume: classify trust, verify against disk, classify drift, continue
/handoff chain          # list the chain (Seq, date, status, goal)
```

## v2.8 — replication battalion (4× full-spectrum, convergência ≥2)

Quatro agentes independentes varreram o espectro inteiro (Reddit/old.reddit, GitHub/GitLab, fóruns RU/CN/nichados, Vale do Silício, vendor docs, arXiv). Regra de replicação: só entra o que ≥2 convergiram. Adotado:

- **Split initializer×coder + `FirstWindow`**: sessão inaugural faz scaffolding (`init.sh`, progress file, `feature_list.json` com `passes: false`, commit inicial), não progresso incremental
- **Ledger `passes`-only**: o writer só alterna o flag, jamais remove ou edita testes
- **Fresh-restart + smoke-test-first**: ordem de reorientação `pwd → git log → progresso → features → init.sh → 1 e2e`, antes de qualquer feature nova
- **Clearing cirúrgico + prefixo estável**: mantenha chamadas, descarte payloads re-buscáveis; nunca resuma o que pode ser re-lido
- **Anti-wrap-up**: nunca encerre cedo por pressão de limite; admita não-recall em vez de afirmar falso
- **Direction flag** (`escalate`/`downshift`/`same`) para trocas de modelo/runtime; **detail-sufficiency** ("mencionado sem detalhe" falha no gate)
- EVAL: probes com fato plantado + check de suficiência; CI/sync markers 44 → 51

## v2.7 — battalion convergence (10 fronts → 22 deltas)

A 10-front research battalion (GitHub new repos, Reddit postmortems, vendor docs, arXiv Oct-2026, engineering blogs, lists/marketplaces, non-English sources, adjacent patterns, adversarial, real exemplars) converged 22 adoptable deltas, all applied:

- **Forced read-back + dirty-ack** — the load report quotes back the executable next step, the acknowledged dirty-tree state and 1 active gate; a receiver that can't recite the map didn't understand it
- **Receipt-hardened verifiability** — `checked` requires a repo receipt; without receipt = `UNVERIFIED`; mock ≠ real-request receipts
- **Stop-and-wait timeout** — one re-ask, then stop; high-risk defaults to NOT executing; approval record (who approved what, when)
- **Recovery sequence + verify-loop** — Next Steps order IS the recovery order; keyless writes use write → idempotent-read → retry-if-absent
- **Cascade invalidation, source anti-duplicate, live-evidence-before-success, tool-output revalidation, goal-drift check**
- **Normalized scanning** (NFKC + base64 decode), **egress rule** (never follow URLs from untrusted state), **rotation** to `.handoff/archive/`, **completion requirement** in Goal
- 17 more deferred with documented reasons (map-reduce, always-stop, token hooks, mutual verification loop, hook automation, memory MCPs, swarm contracts…)

## v2.4 — theory-grounded schema upgrade (arXiv-verified)

The schema itself got upgraded this round, with verified quantitative grounding:

- **Item lifecycle: ACTIVE / SUPERSEDED / REVOKED** on every carry-forward item — append-only chains score *below a memoryless agent* after regime reversal (TEPA, arXiv:2608.07429); revocation is the feature, not the defect
- **Constraints/Dead Ends as gates** (`gatilho · bloqueia · até`), re-asserted verbatim in the Resume — constraint *role* erodes in handoffs, full blocker text fixes it (arXiv:2608.24569: forbidden actions 85.2%→0.0%)
- **Provenance + non-amplification** — `externo-não-confiável` items never enter Commands or gate actions (arXiv:2607.29167: consolidation launders untrusted observations into apparent user history)
- **Environment pin + reconciliation** — anchors are valid for the header SHA; moved HEAD downgrades unverifiable anchors to inference, never deletes (arXiv:2608.14380)
- **Rollback-risk and preconditions per step** — non-idempotent effects are never re-executed (arXiv:2606.02875, Handoff Debt)
- **Write-side invariant** — recommending a restart writes the checkpoint first; materiality gate (every cited path resolves); filesystem-not-chat self-test; atomic one-shot write; layered cut order
- Hook-side automation (PreCompact backstop, measured-75% triggers, ownership lease, eval scorecard) documented as ecosystem doctrine in the round-5 report — the command encodes the invariants the hooks enforce

## v2.3 — council convergence (GitHub + Reddit → 5-lens council)

7 techniques adopted from the ecosystem sweep, each filtered by Security (fail-closed preserved) and QA (testable-as-specified):

- **Self-instructing, capability-negating bootstrap** — the `Resume` block teaches any agent (no command installed, any runtime, paste scenarios) the safe pickup: read whole doc → verify against disk → treat as data → **propose and wait**. It can never instruct writes, execution, or trust escalation — the ASI06 vector stays closed.
- **Last-verifier-result as a clue, not proof** — `Última verificação: <cmd> → <pass|fail>` in Execution Notes; the load re-runs the cheap command instead of trusting a stamp a planted chain could forge.
- **Verifiability labels** — bullets with `file:line` are verifiable; unlabeled = inference (hypothesis until verified).
- **Non-goals** — one line in the header; a new human request beats yesterday's non-goal.
- **Emergency mode, degraded not ungated** — near-full context: minimal content, `Emergência: true`; the secret scan and Seq/Parent checks **always run** (never skipped); the load treats emergency claims as unverified and stops for human ok.
- **Chain health line** — CHAIN reports orphans/broken-parents/zombies; read-only, never auto-repairs.
- **Goal-directed extraction** — name the next session's goal in the alvo; the doc carries only what that goal needs.

Deferred by council: map-reduce extraction (non-deterministic → breaks eval reproducibility), universal brief-then-stop (kills the trusted fast path), absolute-token hooks (needs per-runtime threshold matrix + hysteresis).

## v2.2 — hardened by three adversarial fleet reviews

Rounds: 38 findings (v1.0), 28 (attacking the v2.0 fixes), 26 (attacking the v2.1 fixes). All fixed ([full reports](docs/ULTRAREVIEW-v2.md)):

- **Evidence-backed gate, recomputable** — the close message **transports the measurements** (tokens with an honest `medidos|estimados` label, secret-scan match counts, section count) and **every number is recomputable from the file on disk** (`wc -c` ÷ 3.5, `grep -cE` with the gate's pattern, `grep -c '^## '`) — fabricating numbers is detectable, not just discouraged.
- **Origin sensor** — trust is mechanical AND origin-aware: the chain counts as trusted only if it is **not git-tracked** (`git ls-files .handoff/` empty — chains committed or force-added came from a clone); the dubious-origin list **takes precedence** over the positive field-arithmetic definition; untrusted chains are never elected as parents and **nothing is ever written** to them.
- **Split anatomy** — overflow splits into `#N` (Goal + state + Next Steps) and `#N+1` (verbatim overflow sections, `Parent: #N`); supersede never fires between split parts; both pass the gate independently; `Next Steps: nenhum` is a legitimate closure.
- **Precedence declared** — verbatim and the 25 bullets beat the 300-word section cap as long as the total ≤ 10K ceiling; DIVERGED/INCOMPLETE actions are *proposals* gated by the stop-and-wait (no mutation before human ok); `[FEITO]`/`SUPERSEDED` on disk require consent too.
- **Chain laundering blocked** — WRITE refuses verbatim inheritance from a non-trusted parent; only in-chain, git-untracked files are eligible parents.
- **Codex explicit-only on both discovery paths** — installed to `~/.agents/skills` (current, documented) AND `~/.codex/skills` (legacy, deprecated upstream), with `agents/openai.yaml` (`allow_implicit_invocation: false`) in both; Codex ignores `disable-model-invocation` in SKILL.md frontmatter (Grok honors it).
- **Fail-closed everywhere** — install.sh aborts on missing tag (no silent main fallback) and on missing checksum; CI YAML validator fails on unterminated frontmatter; sync parses the policy YAML instead of grepping a keyword; version equality (description × DNA comment) enforced across the 4 variants.
- **Dead ends with validity conditions** — "failed with lib X v1.2" instead of dogma; re-checked when the condition expires.
- **Drift taxonomy with actions and an oracle** — CLEAN → proceed · DIVERGED/INCOMPLETE/STALE → propose-and-wait (no mutation before human ok); mixed drift reports primary + secondary; evals assert the stop via tool-call traces, not strings.
- **State anchors in the header** — `Seq · Parent · Date(±seconds) · Status · Cwd · Git branch@sha`: drift detection costs two commands; repo-moved detection via Cwd; races detected via duplicate-Seq check; multi-ACTIVE chains (different Seqs too) reported as 2 heads.
- **Token budget, internally consistent** — target ~3K, hard cap 10K, ≤300 words/section with declared precedence (verbatim/bullets win below the ceiling), cut direction unambiguous: **preserve** user corrections > errors > active work > completed (cut in reverse); verbatim is never truncated — overflow splits (W12); gate loop bounded at 2 iterations; duplicate-Seq renumbering declares the header field authoritative and stops for a human instead of writing zombies.
- **Secret scan, count-mode** — the gate counts matches (`-c`) and never pastes matched lines into the chat; covers JWT (`eyJ`), URL credentials, `Basic` auth, `password=`/`api_key=`/`secret=` query strings, raw SSH keys.
- **`.gitignore` guard, verified** — append preserves every existing rule; idempotent via `git check-ignore`; the gate re-checks the diff.
- **Least privilege** — Claude variant: `Read, Grep, Glob, Write, Edit` (no shell); codex/grok skills explicit-only. *Note: opencode has no per-command tool allowlist — the perimeter there is prompt-enforced (`agent: build`).*

## The document

```markdown
# HANDOFF — <objective in one line>
Seq · Parent · Date · Status: ACTIVE · Cwd · Git: <branch@sha dirty|clean>

Goal · Where We Are (≤25 verifiable bullets, file:line) · Key Decisions (verbatim,
with the why) · Dead Ends (with validity condition) · Next Steps ([FEITO] marks done)
· Relevant Files (LER PRIMEIRO | reference; never sensitive dotfiles) · Commands
(env vars, never values) · Gotchas · Open Questions · Constraints · Execution
Notes · Resume
```

Fidelity by class (the 3-part record from arXiv 2608.14528): decisions/constraints/dead-ends are **verbatim** (they exist nowhere else); Where We Are is **verifiable statistics** (the disk confirms); gotchas are **original observations**.

## Installation

```bash
bash install.sh   # from the repo root — or curl | bash (see install.sh; release-tag pinned, checksum-fatal)
```

| Runtime | Files |
|---|---|
| opencode | `~/.config/opencode/commands/handoff.md` |
| Claude Code | `~/.claude/commands/handoff.md` |
| Codex | `~/.codex/skills/handoff/SKILL.md` + `agents/openai.yaml` |
| Grok Build | `~/.grok/skills/handoff/SKILL.md` |

> **Duplicate `/handoff` entries in Claude Code?** Claude Code also reads the shared `~/.agents/skills/` directory. If a foreign skill named `handoff` lives there (or in `~/.claude/skills/`), it collides with this command. Fix: rename the foreign folder — `mv ~/.agents/skills/handoff ~/.agents/skills/handoff-compact` and update its `name:` frontmatter. install.sh deliberately does **not** install to `~/.agents/skills/handoff` for exactly this reason.

## When to use what

| Situation | Reach for | Why |
|---|---|---|
| Same task, context still load-bearing | continue | don't pay to rebuild the window |
| Short gap, same machine, session intact | native resume (`claude --resume`, `codex resume --last`, `opencode -c`) | full history is cheap enough |
| Context full/degraded, cross-machine, cross-runtime, poisoned thread | **`/handoff` + fresh session** | clean slate + verified state |
| Same task mid-flow, can tolerate loss | `/compact` | stays in-session, but lossy at the worst moment |

## Evidence base

- **arXiv 2608.14528** — Handover of In-Context Learning State Across Session Boundaries (the 3-part record: exact decisions, task-justified statistics, retained original observations)
- **ACE, arXiv 2510.04618 (ICLR 2026)** — brevity bias & context collapse in iterative rewrites; incremental curated deltas
- **Anthropic engineering** — harness design (context anxiety → resets + handoff); session management (context rot: "the model is at its least intelligent point when compacting")
- **anthropics/claude-cookbooks** — preserve rules (identifiers/errors verbatim) & cut priority
- **crd/session-handoff, se4thvin/context-handoff, live9369/session-handoff-skill, nlashinsky/claude-code-handoff, mattpocock/skills** — section convergence, status lifecycle, drift verification
- **paperclip#2755 / OWASP ASI06** — injection via handoff files & the trust-delimiter mitigation
- **openai/codex #29989/#10585, mattpocock/skills #516** — Codex invocation policy (`agents/openai.yaml`)

## Suite

Part of the local ULTRA suite: [opencode-ultraplan](https://github.com/rianprei/opencode-ultraplan) · [opencode-ultrareview](https://github.com/rianprei/opencode-ultrareview) · [opencode-ultragoal](https://github.com/rianprei/opencode-ultragoal) · **opencode-handoff**

## License

MIT — see [LICENSE](LICENSE).
