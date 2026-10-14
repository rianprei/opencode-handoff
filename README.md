# opencode-handoff

> **Local replica of the session-handoff pattern** — structured state transfer instead of lossy compaction. Built from the convergence of 7+ open-source handoff implementations, arXiv 2608.14528 (handover theory), the ACE paper (ICLR 2026), Anthropic's own engineering guidance on context resets, and hardened by **two adversarial fleet reviews** (66 confirmed findings, all fixed). Runs 100% locally. No cloud. No quota. No git required.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-2.1-green.svg)](CHANGELOG.md)
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

## v2.1 — hardened by two adversarial fleet reviews

Round 1: 38 findings. Round 2 (attacking the fixes themselves): 28 more. All fixed ([full reports](docs/ULTRAREVIEW-v2.md)):

- **Evidence-backed gate** — the close message **transports the measurements** (tokens, secret-scan matches with redactions, section count). A bare "gate OK" is an attestation, not proof — and the reviewers caught exactly that failure mode.
- **Trust is mechanical, not vibes** — trusted = file belongs to the project chain (`.handoff/`, navigable Seq/Parent) **and** was opened by explicit invocation. Untrusted (cloned repo, PR, broken chain, sensitive-dotfile reference): any command requires human confirmation; loads that are untrusted or drifted **stop and wait** before the first action.
- **Chain laundering blocked** — WRITE refuses verbatim inheritance from a non-trusted parent; planted files with forged `Seq: 999` are never eligible parents.
- **Codex explicit-only actually enforced** — Codex ignores `disable-model-invocation` in SKILL.md frontmatter (Grok honors it), so install ships `agents/openai.yaml` with `allow_implicit_invocation: false`.
- **Dead ends with validity conditions** — "failed with lib X v1.2" instead of dogma; re-checked when the condition expires.
- **Drift taxonomy with actions** — CLEAN → proceed · DIVERGED → reconcile first · INCOMPLETE → finish in-flight first · STALE → re-evaluate strategy; mixed drift reports primary + secondary.
- **State anchors in the header** — `Seq · Parent · Date(±seconds) · Status · Cwd · Git branch@sha`: drift detection costs two commands; repo-moved detection via Cwd; races detected via duplicate-Seq check.
- **Token budget, internally consistent** — target ~3K, hard cap 10K, ≤300 words/section (caps and ceiling agree), cut direction unambiguous: **preserve** user corrections > errors > active work > completed (cut in reverse); verbatim is never truncated — overflow splits into two handoffs; gate loop bounded at 2 iterations.
- **`.gitignore` guard** — append preserves every existing rule; idempotent via `git check-ignore`.
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
