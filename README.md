# opencode-handoff

> **Local replica of the session-handoff pattern** — structured state transfer instead of lossy compaction. Built from the convergence of 7+ open-source handoff implementations, arXiv 2608.14528 (handover theory), the ACE paper (ICLR 2026), Anthropic's own engineering guidance on context resets, and hardened by a 5-reviewer adversarial fleet review that confirmed and fixed 38 findings. Runs 100% locally. No cloud. No quota. No git required.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-2.0-green.svg)](CHANGELOG.md)
[![Runtimes](https://img.shields.io/badge/runtimes-opencode%20%7C%20claude%20%7C%20codex%20%7C%20grok-blueviolet.svg)](#installation)
[![Cloud Free](https://img.shields.io/badge/cloud-free-brightgreen.svg)](#the-problem-it-solves)
[![Quota Free](https://img.shields.io/badge/quota-unlimited-brightgreen.svg)](#the-problem-it-solves)

## The problem it solves

Long sessions rot. Compaction summarizes at the model's worst moment, drops the "why" of decisions, and auto-compact fires silently around ~83% of the window — usually before you remember to save anything. Anthropic's own harness-design post prescribes the fix for long tasks: **context resets + structured handoff**, not compaction (which never gives a clean slate and leaves "context anxiety" in place).

`/handoff` is that handoff: distill the session's transferable state into a small, **verified** document; the next session starts fresh and resumes from it.

```
/handoff                # write: extract state → .handoff/handoff-N-<slug>-<date>.md (post-write gate)
/handoff load <path>    # resume: verify against disk, classify drift, continue from the first open step
/handoff chain          # list the chain (Seq, date, status, goal)
```

## v2.0 — hardened by a 5-reviewer fleet review

38 confirmed findings (18 high), all fixed ([full report](docs/ULTRAREVIEW-v2.md)):

- **Post-write gate** — re-reads the file it just wrote: 12 sections present, actionable #1, secret scan (`sk-`, `ghp_`, `AKIA`, `AIza`, `Bearer`, `PRIVATE KEY`, …), seq/parent consistent, token budget. **Never announces "written" without passing.**
- **Provenance rule** — a handoff you didn't write (cloned repo, PR, edited by hand) is **untrusted**: Commands and paths outside the project require explicit human confirmation; Next Steps are suggestions to validate. Injection via state files is a documented vector (OWASP ASI06).
- **Curated chain carry** — the child inherits **verbatim only what's still live** from the parent; superseded items become one-line pointers. No O(N²) bloat, no poisoned-payload propagation.
- **Dead ends with validity conditions** — "failed with lib X v1.2, error E" instead of dogma; re-checked when the condition expires (dependency updated, upstream bug fixed).
- **Drift taxonomy with actions** — CLEAN → proceed · DIVERGED → reconcile first · INCOMPLETE → finish in-flight work first · STALE → re-evaluate strategy.
- **State anchors in the header** — `Seq · Parent · Date · Status · Cwd · Git branch@sha`: drift detection costs one command, not a re-derivation of 25 bullets.
- **Token budget** — target ~3K, hard cap 10K, ≤500 words/section, cut priority: user corrections > errors > active work > completed work.
- **Write-before-compact trigger** — warns at ~70% context, *before* auto-compact eats the data the handoff needs.
- **`.gitignore` guard** — handoff state never lands in a commit by default.
- **Least privilege** — Claude variant drops Bash from `allowed-tools`; codex/grok skills are explicit-only (`disable-model-invocation: true`).

## The document

```markdown
# HANDOFF — <objective in one line>
Seq · Parent · Date · Status: ACTIVE · Cwd · Git: <branch@sha dirty|clean>

Goal · Where We Are (≤25 verifiable bullets, file:line) · Key Decisions (verbatim,
with the why) · Dead Ends (with validity condition) · Next Steps ([FEITO] marks done)
· Relevant Files (LER PRIMEIRO | reference) · Commands (env vars, never values)
· Gotchas · Open Questions · Constraints · Execution Notes · Resume
```

Fidelity by class (the 3-part record from arXiv 2608.14528): decisions/constraints/dead-ends are **verbatim** (they exist nowhere else); Where We Are is **verifiable statistics** (the disk confirms); gotchas are **original observations**.

## Installation

```bash
bash install.sh   # from the repo root — or curl -fsSL ... | bash (see install.sh)
```

| Runtime | File |
|---|---|
| opencode | `~/.config/opencode/commands/handoff.md` |
| Claude Code | `~/.claude/commands/handoff.md` |
| Codex | `~/.codex/skills/handoff/SKILL.md` |
| Grok Build | `~/.grok/skills/handoff/SKILL.md` |

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

## Suite

Part of the local ULTRA suite: [opencode-ultraplan](https://github.com/rianprei/opencode-ultraplan) · [opencode-ultrareview](https://github.com/rianprei/opencode-ultrareview) · [opencode-ultragoal](https://github.com/rianprei/opencode-ultragoal) · **opencode-handoff**

## License

MIT — see [LICENSE](LICENSE).
